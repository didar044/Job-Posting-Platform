<?php

namespace App\Http\Requests\Invoice;

use Illuminate\Foundation\Http\FormRequest;

class InvoiceRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return false;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
          return [
            'user_id'        => ['required', 'exists:users,id'],
            'application_id' => ['required', 'exists:applications,id'],
            'amount'         => ['required', 'numeric', 'in:100'], 
            'payment_method' => ['required', 'in:stripe,sslcommerz,manual'],
            'time'           => ['nullable', 'date'],
            'payment_status' => ['required', 'in:paid, pending,cancelled'],
        ];
    }
}
