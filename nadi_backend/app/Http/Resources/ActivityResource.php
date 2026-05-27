<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ActivityResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'type' => $this->type,
            'details' => $this->details,
            'customerId' => $this->customer_id,
            'customerName' => $this->customer?->name,
            'createdAt' => $this->created_at?->toIso8601String(),
        ];
    }
}
