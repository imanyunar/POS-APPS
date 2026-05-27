<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class MenuItemResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'description' => $this->description ?? '',
            'price' => (float) $this->price,
            'category' => $this->category,
            'isAvailable' => (bool) $this->is_available,
            'estimatedPrepMinutes' => $this->estimated_prep_minutes ?? 5,
            'trackStock' => (bool) $this->track_stock,
            'stockQuantity' => $this->stock_quantity ?? 0,
            'lowStockThreshold' => $this->low_stock_threshold ?? 5,
            'createdAt' => $this->created_at?->toIso8601String(),
        ];
    }
}
