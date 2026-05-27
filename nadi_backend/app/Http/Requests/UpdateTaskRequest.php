<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateTaskRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'title' => 'sometimes|string|max:255',
            'description' => 'nullable|string',
            'is_completed' => 'sometimes|boolean',
            'category' => 'sometimes|in:opening,closing,daily,recurring',
            'due_date' => 'nullable|date',
            'sort_order' => 'nullable|integer|min:0',
        ];
    }
}
