<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Role;
use Spatie\Permission\Models\Permission;
use App\Models\User;

class RolePermissionSeeder extends Seeder
{
    public function run(): void
    {
        // Roles
        $admin = Role::firstOrCreate(['name' => 'admin']);
        $employee = Role::firstOrCreate(['name' => 'employee']);
        $jobseeker = Role::firstOrCreate(['name' => 'jobseeker']);

        // Permissions
        $permissions = [
            'view all users', 'view all jobs', 'view all applications',
            'filter applications', 'accept application', 'reject application',
            'apply for jobs', 'view own applications'
        ];

        foreach($permissions as $perm){
            Permission::firstOrCreate(['name'=>$perm]);
        }

        // Assign Permissions
        $admin->syncPermissions(Permission::all());
        $employee->syncPermissions(['view all applications','accept application','reject application']);
        $jobseeker->syncPermissions(['apply for jobs','view own applications']);

        // Optional: Assign default roles to existing users
        User::where('email','admin@example.com')->first()?->assignRole($admin);
        User::where('email','employee@example.com')->first()?->assignRole($employee);

        // All other users default to jobseeker
        $users = User::whereNotIn('email',['admin@example.com','employee@example.com'])->get();
        foreach($users as $user){
            $user->assignRole($jobseeker);
        }
    }
}
