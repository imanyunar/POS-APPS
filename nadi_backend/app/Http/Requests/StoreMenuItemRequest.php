<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreMenuItemRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array
    {
        return [
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'price' => 'required|numeric|min:0',
            'category' => 'required|in:makanan,minuman,snack,dessert',
            'estimatedPrepMinutes' => 'nullable|integer|min:0',
            'trackStock' => 'nullable|boolean',
            'stockQuantity' => 'nullable|integer|min:0',
            'lowStockThreshold' => 'nullable|integer|min:0',
        ];
    }
}
