<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\Request;

class CategoryController extends Controller
{
    public function index(Request $request)
    {
        $categories = Category::where('workspace_id', $request->user()->workspace_id)
            ->with('children')
            ->whereNull('parent_id')
            ->latest()
            ->get();

        return response()->json($categories);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'parent_id' => 'nullable|exists:categories,id',
        ]);

        $validated['workspace_id'] = $request->user()->workspace_id;

        $category = Category::create($validated);

        return response()->json($category, 201);
    }

    public function update(Request $request, Category $category)
    {
        if ($category->workspace_id !== $request->user()->workspace_id) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        $validated = $request->validate([
            'name' => 'sometimes|string|max:255',
            'parent_id' => 'nullable|exists:categories,id',
        ]);

        $category->update($validated);

        return response()->json($category);
    }

    public function destroy(Request $request, Category $category)
    {
        if ($category->workspace_id !== $request->user()->workspace_id) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        $category->products()->update(['category_id' => null]);
        $category->children()->update(['parent_id' => null]);
        $category->delete();

        return response()->json(['message' => 'Kategori dihapus.']);
    }
}
