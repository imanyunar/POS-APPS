<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreTaskRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array
    {
        return [
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'category' => 'required|in:opening,closing,daily,recurring',
            'dueDate' => 'nullable|date',
            'sortOrder' => 'nullable|integer',
        ];
    }
}
