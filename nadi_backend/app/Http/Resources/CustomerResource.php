<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CustomerResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'phone' => $this->phone ?? '',
            'email' => $this->email ?? '',
            'internalNotes' => $this->internal_notes ?? '',
            'outstandingDebt' => (float) ($this->invoices_sum_total ?? 0),
            'ordersCount' => $this->orders_count ?? $this->orders?->count() ?? 0,
            'invoicesCount' => $this->invoices_count ?? $this->invoices?->count() ?? 0,
            'createdAt' => $this->created_at?->toIso8601String(),
        ];
    }
}
