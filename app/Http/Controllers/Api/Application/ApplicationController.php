<?php

namespace App\Http\Controllers\Api\Application;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Application\Application;
use App\Models\Invoice\Invoice;
use App\Http\Requests\Application\ApplicationRequest;
use App\Http\Requests\Invoice\InvoiceRequest;
use Stripe\Stripe;
use Stripe\Checkout\Session;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class ApplicationController extends Controller
{

    public function index()
    {
        $applications = Application::with('invoice')->get();
        return response()->json($applications);
    }


    public function store(ApplicationRequest $request)
    {
        // Upload CV temporarily
        $cvPath = $request->file('cv_file')->store('temp/cvs', 'public');

        // Create Stripe Checkout session
        Stripe::setApiKey(env('STRIPE_SECRET'));

        $session = Session::create([
            'payment_method_types' => ['card'],
            'line_items' => [
                [
                    'price_data' => [
                        'currency' => 'usd',
                        'product_data' => [
                            'name' => 'Job Application Payment',
                        ],
                        'unit_amount' => 1 * 100,
                    ],
                    'quantity' => 1,
                ]
            ],
            'mode' => 'payment',
            'success_url' => env('FRONTEND_URL') . '/payment-success',
            'cancel_url' => env('FRONTEND_URL') . '/payment-cancel',
            'metadata' => [
                'user_id' => $request->user_id,
                'hm_job_id' => $request->hm_job_id,
                'cv_path' => $cvPath,
                'cover_letter' => $request->cover_letter ?? '',
            ],
        ]);

        return response()->json([
            'sessionId' => $session->id,
            'url' => $session->url,
        ]);
    }


    public function show($id)
    {
        $application = Application::with('invoice')->findOrFail($id);
        return response()->json($application);
    }


    public function update(Request $request, $id)
    {
        $application = Application::findOrFail($id);

        $request->validate([
            'status' => 'in:pending,accepted,rejected',
            'cover_letter' => 'nullable|string',
        ]);

        $application->update($request->only(['status', 'cover_letter']));

        return response()->json([
            'message' => 'Application updated successfully',
            'application' => $application,
        ]);
    }


    public function destroy($id)
    {
        $application = Application::findOrFail($id);
        if ($application->cv_file) {
            Storage::disk('public')->delete($application->cv_file);
        }
        $application->delete();

        return response()->json([
            'message' => 'Application deleted successfully',
        ]);
    }

    /**
     * Stripe Webhook: create application + invoice after successful payment
     */
    public function webhook(Request $request)
    {
        $payload = $request->getContent();
        $sigHeader = $request->header('Stripe-Signature');
        $endpointSecret = env('STRIPE_WEBHOOK_SECRET');

        try {
            $event = \Stripe\Webhook::constructEvent($payload, $sigHeader, $endpointSecret);

            if ($event->type === 'checkout.session.completed') {
                $session = $event->data->object;

                $userId = $session->metadata->user_id;
                $jobId = $session->metadata->hm_job_id;
                $cvPath = $session->metadata->cv_path;
                $coverLetter = $session->metadata->cover_letter;

                DB::transaction(function () use ($userId, $jobId, $cvPath, $coverLetter) {
                    // Move CV from temp to final folder
                    $finalCvPath = str_replace('temp/', '', $cvPath);
                    Storage::disk('public')->move($cvPath, $finalCvPath);

                    // Create application
                    $application = Application::create([
                        'user_id' => $userId,
                        'hm_job_id' => $jobId,
                        'cover_letter' => $coverLetter,
                        'cv_file' => $finalCvPath,
                        'status' => 'pending',
                    ]);

                    // Create invoice
                    Invoice::create([
                        'user_id' => $userId,
                        'application_id' => $application->id,
                        'amount' => 100,
                        'payment_method' => 'stripe',
                        'payment_status' => 'paid',
                        'time' => now(),
                    ]);
                });
            }

            return response()->json(['status' => 'success']);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 400);
        }
    }

    /**
     * Update the status of an application (accepted/rejected)
     */
        public function updateStatus(Request $request, $id)
        {
            // Validate request
            $request->validate([
                'status' => 'required|in:pending,accepted,rejected',
            ]);

            try {
                $application = Application::findOrFail($id); // throws ModelNotFoundException if not found

                $application->status = $request->status;
                $application->save();

                return response()->json(['success' => true,'message' => "Application status updated to {$request->status}",'application' => $application,], 200);

            } catch (\Exception $e) {
                return response()->json(['success' => false,'message' => 'Failed to update status','error' => $e->getMessage(),], 500);
            }
        }
}