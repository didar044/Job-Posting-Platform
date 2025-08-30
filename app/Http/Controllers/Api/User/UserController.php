<?php
namespace App\Http\Controllers\Api\User;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Auth;

class UserController extends Controller
{
    public function index()
    {
        $authUser = Auth::user();
        if ($authUser->hasRole('admin')) {    
            $users = User::all();
        } elseif ($authUser->hasRole('employee')) {   
            $users = User::role('jobseeker')->get();
        } else {
            return response()->json(['success' => false, 'message' => 'Unauthorized'], 403);
        }
        return response()->json(['success' => true,'data' => $users], 200);
    }

    public function store(Request $request)
    {
        
    }

    public function show(string $id)
    {
        $authUser = Auth::user();
        $user = User::findOrFail($id);
        
        if ($authUser->hasRole('admin') && $user->hasRole('employee')) {
            return response()->json(['success' => true, 'data' => $user], 200);
        } elseif ($authUser->hasRole('employee') && $user->hasRole('jobseeker')) {
            return response()->json(['success' => true, 'data' => $user], 200);
        }

        return response()->json(['success' => false, 'message' => 'Unauthorized'], 403);
    }

    public function update(Request $request, string $id)
    {
       
    }

    public function destroy(string $id)
    {
        
    }
}
