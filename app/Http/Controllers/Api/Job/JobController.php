<?php

namespace App\Http\Controllers\Api\Job;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use App\Models\Job\Job;
use App\Http\Requests\Job\JobRequest;
class JobController extends Controller
{
    public function index()
    {
        try {
            $jobs = Job::with('user')->latest()->paginate(10);
            return response()->json(['success' => true,'data' => $jobs], 200);
        } catch (\Exception $e) {
            Log::error('Job Index Error: '.$e->getMessage());
            return response()->json(['success' => false, 'message' => 'Failed to fetch jobs'], 500);
        }
    }

    public function store(JobRequest $request)
    {
        try {
            $job = Job::create($request->validated());
            return response()->json(['success' => true, 'data' => $job], 201);
        } catch (\Exception $e) {
            Log::error('Job Store Error: '.$e->getMessage());
            return response()->json(['success' => false, 'message' => 'Failed to create job'], 500);
        }
    }

    public function show($id)
    {
        try {
            $job = Job::with('user')->findOrFail($id);
            return response()->json(['success' => true, 'data' => $job], 200);
        } catch (\Exception $e) {
            Log::error('Job Show Error: '.$e->getMessage());
            return response()->json(['success' => false, 'message' => 'Job not found'], 404);
        }
    }

    public function update(JobRequest $request, $id)
    {
        try {
            $job = Job::findOrFail($id);
            $job->update($request->validated());
            return response()->json(['success' => true, 'data' => $job], 200);
        } catch (\Exception $e) {
            Log::error('Job Update Error: '.$e->getMessage());
            return response()->json(['success' => false, 'message' => 'Failed to update job'], 500);
        }
    }

    public function destroy($id)
    {
        try {
            $job = Job::findOrFail($id);
            $job->delete();
            return response()->json(['success' => true, 'message' => 'Job deleted successfully'], 200);
        } catch (\Exception $e) {
            Log::error('Job Destroy Error: '.$e->getMessage());
            return response()->json(['success' => false, 'message' => 'Failed to delete job'], 500);
        }
    }
}

