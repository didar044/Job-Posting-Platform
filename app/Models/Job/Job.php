<?php

namespace App\Models\Job;

use Illuminate\Database\Eloquent\Model;
use App\Models\User;

class Job extends Model
{
    protected $table="hm_jobs";
    protected $fillable=['title','description','user_id'];

    public function user()
    {
        return $this->belongsTo(User::class,'user_id');
    }
}
