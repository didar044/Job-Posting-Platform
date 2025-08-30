<?php

namespace App\Http\Controllers\Api\Analytics;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Invoice\Invoice;
use App\Models\Job\Job;
use App\Models\Application\Application;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class Company_AnalyticsController extends Controller
{
    public function index()
    {
        try {
            // Total invoice amount
             $invoice_amount = Invoice::all();
                $total_amount = 0;
                foreach ($invoice_amount as $total) {
                    $total_amount += $total->amount;
                };

            // Total employees and jobseekers
            $total_employee = DB::table('hm_model_has_roles')->where('role_id', 2)->count();
            $total_jobseeker = DB::table('hm_model_has_roles')->where('role_id', 3)->count();

            // Total applications by status
            $total_application = Application::count();
            $total_application_pending = Application::where('status','pending')->count();
            $total_application_reject = Application::where('status','rejected')->count();
            $total_application_accept = Application::where('status','accepted')->count();

            // Applications today
            $todayApplications = Application::whereDate('created_at', Carbon::today())->count();

       

            $data = [
                "total_users" => User::count(),
                "total_amount" => $total_amount,
                "total_job_circular" => Job::count(),
                "total_application" => $total_application,
                "total_application_pending" => $total_application_pending,
                "total_application_reject" => $total_application_reject,
                "total_application_accept" => $total_application_accept,
                "total_employee" => $total_employee,
                "total_jobseeker" => $total_jobseeker,
                "today_applications" => $todayApplications,
            ];

            return response()->json(["success" => true,"data" => $data ], 200);

        } catch (\Exception $e) {
            // Catch any error and return a JSON response
            return response()->json(["success" => false, "message" => "Something went wrong","error" => $e->getMessage()], 500);
        }
    }
}

 
