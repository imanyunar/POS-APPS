<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreMenuItemRequest;
use App\Http\Resources\MenuItemResource;
use App\Models\MenuItem;
use Illuminate\Http\Request;

class MenuItemController extends Controller
{
    public function index(Request $request)
    {
        $query = MenuItem::where('user_id', $request->user()->id);

        if ($category = $request->category) {
            $query->where('category', $category);
        }

        $items = $query->orderBy('category')->orderBy('name')->get();

        return response()->json([
            'success' => true,
            'message' => 'Menu items retrieved',
            'data' => MenuItemResource::collection($items),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function store(StoreMenuItemRequest $request)
    {
        $item = MenuItem::create([
            'user_id' => $request->user()->id,
            'name' => $request->name,
            'description' => $request->description,
            'price' => $request->price,
            'category' => $request->category,
            'estimated_prep_minutes' => $request->estimatedPrepMinutes ?? 5,
            'track_stock' => $request->trackStock ?? false,
            'stock_quantity' => $request->stockQuantity ?? 0,
            'low_stock_threshold' => $request->lowStockThreshold ?? 5,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Menu item created',
            'data' => new MenuItemResource($item),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ], 201);
    }

    public function show(Request $request, string $id)
    {
        $item = MenuItem::where('user_id', $request->user()->id)->findOrFail($id);

        return response()->json([
            'success' => true,
            'message' => 'Menu item retrieved',
            'data' => new MenuItemResource($item),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function update(StoreMenuItemRequest $request, string $id)
    {
        $item = MenuItem::where('user_id', $request->user()->id)->findOrFail($id);
        $item->update([
            'name' => $request->name,
            'description' => $request->description,
            'price' => $request->price,
            'category' => $request->category,
            'is_available' => $request->isAvailable ?? $item->is_available,
            'estimated_prep_minutes' => $request->estimatedPrepMinutes ?? 5,
            'track_stock' => $request->trackStock ?? false,
            'stock_quantity' => $request->stockQuantity ?? 0,
            'low_stock_threshold' => $request->lowStockThreshold ?? 5,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Menu item updated',
            'data' => new MenuItemResource($item),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function destroy(Request $request, string $id)
    {
        $item = MenuItem::where('user_id', $request->user()->id)->findOrFail($id);
        $item->delete();

        return response()->json([
            'success' => true,
            'message' => 'Menu item deleted',
            'data' => null,
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function toggleAvailability(Request $request, string $id)
    {
        $item = MenuItem::where('user_id', $request->user()->id)->findOrFail($id);
        $item->update(['is_available' => !$item->is_available]);

        return response()->json([
            'success' => true,
            'message' => 'Menu item availability toggled',
            'data' => new MenuItemResource($item),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }
}
