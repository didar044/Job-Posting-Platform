<?php

namespace App\Http\Requests\Application;

use Illuminate\Foundation\Http\FormRequest;

class ApplicationRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
         return [
                'user_id'       => ['required', 'exists:users,id'],
                'hm_job_id'     => ['required', 'exists:hm_jobs,id'],
                'cover_letter'  => ['nullable', 'string'],
                'cv_file'       => ['required','file','mimes:pdf,docx','max:5120'],
                'status'        => ['in:pending,accepted,rejected'],
            ];
    }
    public function messages()
    {
        return [
            'cv_file.mimes' => 'CV must be a PDF or DOCX file.',
            'cv_file.max'   => 'CV may not be greater than 5 MB.',
        ];
    }
}
