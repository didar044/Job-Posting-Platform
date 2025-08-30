<?php

namespace App\Models\Application;

use Illuminate\Database\Eloquent\Model;
use App\Models\Job\Job;
use App\Models\User;

class Application extends Model
{
    protected $table = 'applications'; 

    protected $fillable = [
        'user_id',
        'hm_job_id',
        'cover_letter',
        'cv_file',
        'status',
    ];

   
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    
    public function job()
    {
        return $this->belongsTo(Job::class, 'hm_job_id');
    }
}
