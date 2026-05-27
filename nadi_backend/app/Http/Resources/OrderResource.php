<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class OrderResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'orderNumber' => $this->order_number,
            'customerName' => $this->customer?->name ?? 'Unknown',
            'customerId' => $this->customer_id,
            'status' => $this->status,
            'orderType' => $this->order_type ?? 'dine-in',
            'tableNumber' => $this->table_number,
            'totalAmount' => (float) $this->total_amount,
            'notes' => $this->notes ?? '',
            'items' => OrderItemResource::collection($this->whenLoaded('items')),
            'customer' => new CustomerResource($this->whenLoaded('customer')),
            'createdAt' => $this->created_at?->toIso8601String(),
            'dueDate' => $this->due_date?->toIso8601String(),
        ];
    }
}
