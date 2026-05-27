<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateInventoryItemRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'name' => 'sometimes|string|max:255',
            'sku' => 'nullable|string|max:50|unique:inventory_items,sku,' . $this->route('id'),
            'quantity' => 'sometimes|numeric|min:0',
            'unit_price' => 'nullable|numeric|min:0',
            'low_stock_threshold' => 'nullable|numeric|min:0',
            'unit' => 'sometimes|in:pcs,kg,liter,pack',
        ];
    }
}
