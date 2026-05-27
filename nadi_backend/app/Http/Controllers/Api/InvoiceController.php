<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreInvoiceRequest;
use App\Http\Resources\InvoiceResource;
use App\Models\Activity;
use App\Models\Invoice;
use App\Models\InvoiceItem;
use Carbon\Carbon;
use Illuminate\Http\Request;

class InvoiceController extends Controller
{
    public function index(Request $request)
    {
        $query = Invoice::where('user_id', $request->user()->id)
            ->with(['customer', 'items']);

        if ($status = $request->status) {
            $query->where('status', $status);
        }

        $invoices = $query->latest()->get();

        return response()->json([
            'success' => true,
            'message' => 'Invoices retrieved',
            'data' => InvoiceResource::collection($invoices),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function store(StoreInvoiceRequest $request)
    {
        $today = Carbon::today()->format('Ymd');
        $count = Invoice::whereDate('created_at', Carbon::today())->count() + 1;
        $invoiceNumber = "INV-{$today}-" . str_pad($count, 3, '0', STR_PAD_LEFT);

        $subtotal = collect($request->items)->sum(fn($i) => $i['quantity'] * $i['unitPrice']);
        $tax = $request->tax ?? 0;
        $total = $subtotal + $tax;

        $invoice = Invoice::create([
            'user_id' => $request->user()->id,
            'customer_id' => $request->customerId,
            'order_id' => $request->orderId,
            'invoice_number' => $invoiceNumber,
            'status' => 'unpaid',
            'subtotal' => $subtotal,
            'tax' => $tax,
            'total' => $total,
            'due_date' => $request->dueDate ? Carbon::parse($request->dueDate) : null,
        ]);

        foreach ($request->items as $item) {
            InvoiceItem::create([
                'invoice_id' => $invoice->id,
                'name' => $item['name'],
                'quantity' => $item['quantity'],
                'unit_price' => $item['unitPrice'],
                'total' => $item['quantity'] * $item['unitPrice'],
            ]);
        }

        Activity::create([
            'user_id' => $request->user()->id,
            'customer_id' => $request->customerId,
            'type' => 'invoice_created',
            'details' => [
                'invoice_id' => $invoice->id,
                'invoice_number' => $invoiceNumber,
                'total' => $total,
            ],
        ]);

        $invoice->load(['customer', 'items']);

        return response()->json([
            'success' => true,
            'message' => 'Invoice created',
            'data' => new InvoiceResource($invoice),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ], 201);
    }

    public function show(Request $request, string $id)
    {
        $invoice = Invoice::where('user_id', $request->user()->id)
            ->with(['customer', 'items', 'order'])
            ->findOrFail($id);

        return response()->json([
            'success' => true,
            'message' => 'Invoice retrieved',
            'data' => new InvoiceResource($invoice),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function destroy(Request $request, string $id)
    {
        $invoice = Invoice::where('user_id', $request->user()->id)->findOrFail($id);
        $invoice->delete();

        return response()->json([
            'success' => true,
            'message' => 'Invoice deleted',
            'data' => null,
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function markPaid(Request $request, string $id)
    {
        $invoice = Invoice::where('user_id', $request->user()->id)->findOrFail($id);
        $invoice->update(['status' => 'paid']);

        Activity::create([
            'user_id' => $request->user()->id,
            'customer_id' => $invoice->customer_id,
            'type' => 'invoice_paid',
            'details' => [
                'invoice_id' => $invoice->id,
                'invoice_number' => $invoice->invoice_number,
                'total' => $invoice->total,
            ],
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Invoice marked as paid',
            'data' => new InvoiceResource($invoice->load(['customer', 'items'])),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }
}
