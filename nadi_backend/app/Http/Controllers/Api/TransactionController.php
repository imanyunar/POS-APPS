<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use App\Models\StockMovement;
use App\Models\Transaction;
use App\Models\TransactionItem;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class TransactionController extends Controller
{
    public function index(Request $request)
    {
        $query = Transaction::where('transactions.workspace_id', $request->user()->workspace_id)
            ->with('cashier', 'items.product');

        if ($request->has('date_from')) {
            $query->whereDate('created_at', '>=', $request->date_from);
        }

        if ($request->has('date_to')) {
            $query->whereDate('created_at', '<=', $request->date_to);
        }

        if ($request->has('cashier_id')) {
            $query->where('cashier_id', $request->cashier_id);
        }

        $transactions = $query->latest()->paginate(20);

        return response()->json($transactions);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'items' => 'required|array|min:1',
            'items.*.product_id' => 'required|exists:products,id',
            'items.*.qty' => 'required|integer|min:1',
            'items.*.discount' => 'integer|min:0',
            'discount' => 'integer|min:0',
            'amount_paid' => 'required|integer|min:0',
            'payment_method' => 'required|string|in:cash,qris,transfer,card',
            'notes' => 'nullable|string',
        ]);

        $workspaceId = $request->user()->workspace_id;

        return DB::transaction(function () use ($request, $validated, $workspaceId) {
            $total = 0;
            $items = [];
            $products = []; // BUG-08 fix: simpan referensi product yang sudah di-lock

            foreach ($validated['items'] as $item) {
                $product = Product::where('id', $item['product_id'])
                    ->where('workspace_id', $workspaceId)
                    ->lockForUpdate()
                    ->firstOrFail();

                $discount = $item['discount'] ?? 0;
                $subtotal = ($product->price * $item['qty']) - $discount;
                $total += $subtotal;

                if ($product->stock < $item['qty']) {
                    abort(400, "Stok {$product->name} tidak mencukupi (sisa: {$product->stock})");
                }

                // BUG-08 fix: simpan product yang sudah di-lock
                $products[$product->id] = $product;

                $items[] = [
                    'product_id' => $product->id,
                    'product_name' => $product->name,
                    'qty' => $item['qty'],
                    'price' => $product->price,
                    'discount' => $discount,
                    'subtotal' => $subtotal,
                ];
            }

            $discount = $validated['discount'] ?? 0;
            $grandTotal = $total - $discount;
            $amountPaid = $validated['amount_paid'];
            $change = $amountPaid - $grandTotal;

            if ($change < 0) {
                abort(400, 'Uang tidak mencukupi.');
            }

            $transaction = Transaction::create([
                'workspace_id' => $workspaceId,
                'cashier_id' => $request->user()->id,
                'total' => $total,
                'discount' => $discount,
                'grand_total' => $grandTotal,
                'amount_paid' => $amountPaid,
                'change' => $change,
                'payment_method' => $validated['payment_method'],
                'status' => 'completed',
                'notes' => $validated['notes'] ?? null,
            ]);

            foreach ($items as $item) {
                $item['transaction_id'] = $transaction->id;
                TransactionItem::create($item);

                // BUG-08 fix: gunakan product yang sudah di-lock, bukan findOrFail baru
                $product = $products[$item['product_id']];
                $oldStock = $product->stock;
                $product->decrement('stock', $item['qty']);
                // BUG-09 fix: refresh model setelah decrement agar stock akurat
                $product->refresh();

                StockMovement::create([
                    'workspace_id' => $workspaceId,
                    'product_id' => $item['product_id'],
                    'type' => 'sale',
                    'qty_change' => -$item['qty'],
                    'qty_after' => $product->stock,
                    'note' => "Penjualan #{$transaction->id}",
                    'created_by' => $request->user()->id,
                ]);
            }

            return response()->json(
                $transaction->load('items.product', 'cashier'),
                201
            );
        });
    }

    public function show(Request $request, Transaction $transaction)
    {
        if ($transaction->workspace_id !== $request->user()->workspace_id) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        return response()->json($transaction->load('items.product', 'cashier'));
    }
}
