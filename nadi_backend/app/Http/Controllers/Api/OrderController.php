<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreOrderRequest;
use App\Http\Resources\OrderResource;
use App\Models\Activity;
use App\Models\Order;
use App\Models\OrderItem;
use Carbon\Carbon;
use Illuminate\Http\Request;

class OrderController extends Controller
{
    public function index(Request $request)
    {
        $query = Order::where('user_id', $request->user()->id)
            ->with(['customer', 'items']);

        if ($status = $request->status) {
            $query->where('status', $status);
        }

        if ($type = $request->orderType) {
            $query->where('order_type', $type);
        }

        $orders = $query->latest()->get();

        return response()->json([
            'success' => true,
            'message' => 'Orders retrieved',
            'data' => OrderResource::collection($orders),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function store(StoreOrderRequest $request)
    {
        $today = Carbon::today()->format('Ymd');
        $count = Order::whereDate('created_at', Carbon::today())->count() + 1;
        $orderNumber = "ORD-{$today}-" . str_pad($count, 3, '0', STR_PAD_LEFT);

        $totalAmount = collect($request->items)->sum(fn($i) => $i['quantity'] * $i['unitPrice']);

        $order = Order::create([
            'user_id' => $request->user()->id,
            'customer_id' => $request->customerId,
            'order_number' => $orderNumber,
            'status' => 'pending',
            'total_amount' => $totalAmount,
            'order_type' => $request->orderType ?? 'dine-in',
            'table_number' => $request->tableNumber,
            'notes' => $request->notes,
        ]);

        foreach ($request->items as $item) {
            OrderItem::create([
                'order_id' => $order->id,
                'menu_item_id' => $item['menuItemId'] ?? null,
                'item_name' => $item['name'],
                'quantity' => $item['quantity'],
                'unit_price' => $item['unitPrice'],
                'total' => $item['quantity'] * $item['unitPrice'],
            ]);
        }

        Activity::create([
            'user_id' => $request->user()->id,
            'customer_id' => $request->customerId,
            'type' => 'order_created',
            'details' => [
                'order_id' => $order->id,
                'order_number' => $orderNumber,
                'total' => $totalAmount,
            ],
        ]);

        $order->load(['customer', 'items']);

        return response()->json([
            'success' => true,
            'message' => 'Order created',
            'data' => new OrderResource($order),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ], 201);
    }

    public function show(Request $request, string $id)
    {
        $order = Order::where('user_id', $request->user()->id)
            ->with(['customer', 'items', 'invoice'])
            ->findOrFail($id);

        return response()->json([
            'success' => true,
            'message' => 'Order retrieved',
            'data' => new OrderResource($order),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function update(Request $request, string $id)
    {
        $order = Order::where('user_id', $request->user()->id)->findOrFail($id);

        $order->update($request->only([
            'customer_id', 'notes', 'order_type', 'table_number',
        ]));

        return response()->json([
            'success' => true,
            'message' => 'Order updated',
            'data' => new OrderResource($order->load(['customer', 'items'])),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function destroy(Request $request, string $id)
    {
        $order = Order::where('user_id', $request->user()->id)->findOrFail($id);
        $order->delete();

        return response()->json([
            'success' => true,
            'message' => 'Order deleted',
            'data' => null,
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function updateStatus(Request $request, string $id)
    {
        $request->validate(['status' => 'required|in:pending,preparing,ready,completed,cancelled']);

        $order = Order::where('user_id', $request->user()->id)->findOrFail($id);
        $order->update(['status' => $request->status]);

        Activity::create([
            'user_id' => $request->user()->id,
            'customer_id' => $order->customer_id,
            'type' => 'order_status_updated',
            'details' => [
                'order_id' => $order->id,
                'order_number' => $order->order_number,
                'status' => $request->status,
            ],
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Order status updated',
            'data' => new OrderResource($order->load(['customer', 'items'])),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }
}
