<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class InventoryItemResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'sku' => $this->sku ?? '',
            'quantity' => $this->quantity ?? 0,
            'unitPrice' => (float) $this->unit_price,
            'unit' => $this->unit ?? 'pcs',
            'status' => $this->status ?? 'in_stock',
            'lowStockThreshold' => $this->low_stock_threshold ?? 5,
            'createdAt' => $this->created_at?->toIso8601String(),
        ];
    }
}
