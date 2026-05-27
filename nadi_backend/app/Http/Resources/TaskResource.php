<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class TaskResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'description' => $this->description ?? '',
            'isCompleted' => (bool) $this->is_completed,
            'category' => $this->category,
            'dueDate' => $this->due_date?->toIso8601String(),
            'completedAt' => $this->completed_at?->toIso8601String(),
            'sortOrder' => $this->sort_order ?? 0,
            'createdAt' => $this->created_at?->toIso8601String(),
        ];
    }
}
