<?php

namespace App\Http\Requests\Job;

use Illuminate\Foundation\Http\FormRequest;

class JobRequest extends FormRequest
{
    
    public function authorize(): bool
    {
        return true;
    }

 
    public function rules(): array
    {
        return [
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'user_id' => 'required|exists:users,id',
        ];
    }

    public function messages(): array
    {
        return [
            'title.required' => 'Job title is required.',
            'title.string' => 'Job title must be a string.',
            'title.max' => 'Job title must not exceed 255 characters.',
            'description.string' => 'Description must be a string.',
            'user_id.required' => 'User is required.',
            'user_id.exists' => 'Selected user does not exist.',
        ];
    }
}

