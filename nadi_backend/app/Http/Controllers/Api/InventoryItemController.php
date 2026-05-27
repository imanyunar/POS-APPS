<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreInventoryItemRequest;
use App\Http\Resources\InventoryItemResource;
use App\Models\Activity;
use App\Models\InventoryItem;
use Illuminate\Http\Request;

class InventoryItemController extends Controller
{
    public function index(Request $request)
    {
        $query = InventoryItem::where('user_id', $request->user()->id);

        if ($status = $request->status) {
            $query->where('status', $status);
        }

        $items = $query->orderBy('name')->get();

        return response()->json([
            'success' => true,
            'message' => 'Inventory items retrieved',
            'data' => InventoryItemResource::collection($items),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function store(StoreInventoryItemRequest $request)
    {
        $quantity = $request->quantity ?? 0;
        $status = $quantity <= 0 ? 'out_of_stock' : ($quantity <= ($request->lowStockThreshold ?? 5) ? 'low_stock' : 'in_stock');

        $item = InventoryItem::create([
            'user_id' => $request->user()->id,
            'name' => $request->name,
            'sku' => $request->sku,
            'quantity' => $quantity,
            'unit_price' => $request->unitPrice ?? 0,
            'unit' => $request->unit,
            'low_stock_threshold' => $request->lowStockThreshold ?? 5,
            'status' => $status,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Inventory item created',
            'data' => new InventoryItemResource($item),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ], 201);
    }

    public function show(Request $request, string $id)
    {
        $item = InventoryItem::where('user_id', $request->user()->id)->findOrFail($id);

        return response()->json([
            'success' => true,
            'message' => 'Inventory item retrieved',
            'data' => new InventoryItemResource($item),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function update(StoreInventoryItemRequest $request, string $id)
    {
        $item = InventoryItem::where('user_id', $request->user()->id)->findOrFail($id);

        $quantity = $request->quantity ?? 0;
        $threshold = $request->lowStockThreshold ?? $item->low_stock_threshold;
        $status = $quantity <= 0 ? 'out_of_stock' : ($quantity <= $threshold ? 'low_stock' : 'in_stock');

        $item->update([
            'name' => $request->name,
            'sku' => $request->sku,
            'quantity' => $quantity,
            'unit_price' => $request->unitPrice ?? 0,
            'unit' => $request->unit,
            'low_stock_threshold' => $threshold,
            'status' => $status,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Inventory item updated',
            'data' => new InventoryItemResource($item),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function destroy(Request $request, string $id)
    {
        $item = InventoryItem::where('user_id', $request->user()->id)->findOrFail($id);
        $item->delete();

        return response()->json([
            'success' => true,
            'message' => 'Inventory item deleted',
            'data' => null,
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function lowStock(Request $request)
    {
        $items = InventoryItem::where('user_id', $request->user()->id)
            ->whereIn('status', ['low_stock', 'out_of_stock'])
            ->orderBy('quantity')
            ->get();

        return response()->json([
            'success' => true,
            'message' => 'Low stock items retrieved',
            'data' => InventoryItemResource::collection($items),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }
}
