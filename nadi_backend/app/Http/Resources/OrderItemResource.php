<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class OrderItemResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'menuItemId' => $this->menu_item_id,
            'itemName' => $this->item_name,
            'quantity' => $this->quantity,
            'unitPrice' => (float) $this->unit_price,
            'total' => (float) $this->total,
            'notes' => $this->notes ?? '',
        ];
    }
}
