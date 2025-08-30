<?php

use App\Http\Controllers\Api\Job\JobController;
use App\Http\Controllers\Api\User\UserController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\Auth\AuthController;
use App\Http\Controllers\Api\Application\ApplicationController;
use App\Http\Controllers\Api\Analytics\Company_AnalyticsController;


// Route::get('/user', function (Request $request) {
//     return $request->user();
// })->middleware('auth:sanctum');


// Auth routes
Route::group(['middleware' => 'api', 'prefix' => 'auth'], function ($router) {
    Route::post('/register', [AuthController::class, 'register'])->name('register');
    Route::post('/login', [AuthController::class, 'login'])->name('login');

    // Protected routes
    Route::middleware('auth:api')->group(function () {
        Route::post('/logout', [AuthController::class, 'logout'])->name('logout');
        Route::post('/refresh', [AuthController::class, 'refresh'])->name('refresh');
        Route::post('/me', [AuthController::class, 'me'])->name('me');
    });

});


// Protected routes
Route::middleware(['auth:api'])->group(function () {
      
    //Admin Route
    Route::middleware('role:admin')->group(function () {
        Route::apiResource('users', UserController::class);
        Route::apiResource('jobs', JobController::class);
        Route::resource('applications', ApplicationController::class);
        // Stripe webhook route separately
        Route::post('applications/stripe/webhook', [ApplicationController::class, 'webhook']);
        // Analytics route
        Route::get('analytics/company', [Company_AnalyticsController::class, 'index']);
    });


    //Employee Route
    Route::middleware('role:employee')->group(function () {
       Route::apiResource('jobs', JobController::class);
       Route::resource('applications', ApplicationController::class)->except(['create', 'edit']);
       //accept/reject
       Route::patch('applications/{id}/status', [ApplicationController::class, 'updateStatus']);
    });


    //jobseeke Route
     Route::middleware('role:jobseeker')->group(function () {
       Route::apiResource('jobs', JobController::class)->only('index');
       // Stripe webhook route separately
       Route::post('applications/stripe/webhook', [ApplicationController::class, 'webhook']);
    });
});


//Public Route 
Route::apiResource('jobs', JobController::class)->only('index');

 

