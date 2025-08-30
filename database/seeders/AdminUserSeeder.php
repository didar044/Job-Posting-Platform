<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class AdminUserSeeder extends Seeder
{
    public function run()
    {
        $admin = User::firstOrCreate([
            'email' => 'admin@hireme.com'
        ], [
            'name' => 'Admin User',
            'password' => Hash::make('password123')
        ]);

        $admin->assignRole('admin');
    }
}
