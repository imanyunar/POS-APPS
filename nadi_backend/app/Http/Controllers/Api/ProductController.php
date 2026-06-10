<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    public function index(Request $request)
    {
        $query = Product::where('workspace_id', $request->user()->workspace_id)
            ->where('is_active', true) // BUG-10 fix: hanya tampilkan produk aktif
            ->with('category');

        if ($request->has('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                  ->orWhere('sku', 'like', "%{$search}%");
            });
        }

        if ($request->has('category_id')) {
            $query->where('category_id', $request->category_id);
        }

        if ($request->has('stock_low')) {
            $query->whereColumn('stock', '<=', 'min_stock');
        }

        $products = $query->latest()->paginate(20);

        return response()->json($products);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'sku' => 'nullable|string|max:50|unique:products,sku',
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'category_id' => 'nullable|exists:categories,id',
            'price' => 'required|integer|min:0',
            'cost_price' => 'required|integer|min:0',
            'stock' => 'required|integer|min:0',
            'min_stock' => 'required|integer|min:0',
            'unit' => 'required|string|max:50',
        ]);

        $validated['workspace_id'] = $request->user()->workspace_id;

        $product = Product::create($validated);

        return response()->json($product->load('category'), 201);
    }

    public function show(Request $request, Product $product)
    {
        if ($product->workspace_id !== $request->user()->workspace_id) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        return response()->json($product->load('category', 'variants'));
    }

    public function update(Request $request, Product $product)
    {
        if ($product->workspace_id !== $request->user()->workspace_id) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        $validated = $request->validate([
            'sku' => 'nullable|string|max:50|unique:products,sku,' . $product->id,
            'name' => 'sometimes|string|max:255',
            'description' => 'nullable|string',
            'category_id' => 'nullable|exists:categories,id',
            'price' => 'sometimes|integer|min:0',
            'cost_price' => 'sometimes|integer|min:0',
            'stock' => 'sometimes|integer|min:0',
            'min_stock' => 'sometimes|integer|min:0',
            'unit' => 'sometimes|string|max:50',
            'is_active' => 'sometimes|boolean',
        ]);

        $product->update($validated);

        return response()->json($product->load('category'));
    }

    public function destroy(Request $request, Product $product)
    {
        if ($product->workspace_id !== $request->user()->workspace_id) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        $product->update(['is_active' => false]);

        return response()->json(['message' => 'Produk dinonaktifkan.']);
    }
}
