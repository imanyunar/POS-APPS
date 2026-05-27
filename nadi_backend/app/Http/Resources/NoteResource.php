<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class NoteResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'content' => $this->content ?? '',
            'category' => $this->category,
            'isPinned' => (bool) $this->is_pinned,
            'customerId' => $this->customer_id,
            'customerName' => $this->customer?->name,
            'createdAt' => $this->created_at?->toIso8601String(),
        ];
    }
}
