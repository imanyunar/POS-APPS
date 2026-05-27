<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreInventoryItemRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array
    {
        return [
            'name' => 'required|string|max:255',
            'sku' => 'nullable|string|max:50',
            'quantity' => 'required|integer|min:0',
            'unitPrice' => 'nullable|numeric|min:0',
            'unit' => 'required|in:pcs,kg,liter,pack',
            'lowStockThreshold' => 'nullable|integer|min:0',
        ];
    }
}
