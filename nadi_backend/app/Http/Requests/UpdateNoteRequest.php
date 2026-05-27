<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateNoteRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'title' => 'sometimes|string|max:255',
            'content' => 'nullable|string',
            'category' => 'sometimes|in:operational,supplier,customer,kitchen',
            'customer_id' => 'nullable|exists:customers,id',
            'is_pinned' => 'nullable|boolean',
        ];
    }
}
