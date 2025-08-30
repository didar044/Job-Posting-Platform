<?php

namespace App\Models\Invoice;

use Illuminate\Database\Eloquent\Model;
use App\Models\User;
use App\Models\Application\Application;

class Invoice extends Model
{   
    protected $table="invoices";
    protected $fillable = [
        'user_id',
        'application_id',
        'amount',
        'payment_method',
        'time',
        'payment_status',
    ];

    public function user()
    {
        return $this->belongsTo(User::class,'user_id');
    }

    public function application()
    {
        return $this->belongsTo(Application::class,'application_id');
    }
}
