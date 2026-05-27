<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Workspace;
use App\Services\RbacService;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class RbacSeeder extends Seeder
{
    public function run(): void
    {
        $workspace = Workspace::create([
            'name' => 'Demo Waroeng',
            'slug' => 'demo-waroeng',
            'business_type' => 'cafe',
            'settings' => [
                'order_prefix' => 'ORD',
                'invoice_prefix' => 'INV',
                'default_tax' => 11,
                'timezone' => 'Asia/Jakarta',
            ],
        ]);

        $admin = User::firstOrCreate(
            ['email' => 'admin@serveapp.local'],
            [
                'name' => 'Super Admin',
                'password' => Hash::make('ServeAdmin123!'),
                'current_workspace_id' => $workspace->id,
            ]
        );

        $admin->workspaces()->syncWithoutDetaching([
            $workspace->id => ['role_in_workspace' => 'super_admin'],
        ]);

        RbacService::ensureRolesForWorkspace($workspace);

        setPermissionsTeamId($workspace->id);
        $admin->assignRole('Super Admin');

        $demoUsers = [
            ['email' => 'owner@demo.waroeng', 'name' => 'Budi Pemilik', 'role' => 'Owner', 'pivot_role' => 'owner'],
            ['email' => 'manager@demo.waroeng', 'name' => 'Siti Manajer', 'role' => 'Manager', 'pivot_role' => 'manager'],
            ['email' => 'cashier@demo.waroeng', 'name' => 'Ahmad Kasir', 'role' => 'Cashier', 'pivot_role' => 'cashier'],
            ['email' => 'kitchen@demo.waroeng', 'name' => 'Rina Dapur', 'role' => 'Kitchen Staff', 'pivot_role' => 'kitchen'],
        ];

        foreach ($demoUsers as $data) {
            $user = User::firstOrCreate(
                ['email' => $data['email']],
                [
                    'name' => $data['name'],
                    'password' => Hash::make('password'),
                    'current_workspace_id' => $workspace->id,
                ]
            );

            $user->workspaces()->syncWithoutDetaching([
                $workspace->id => ['role_in_workspace' => $data['pivot_role']],
            ]);

            setPermissionsTeamId($workspace->id);
            $user->assignRole($data['role']);
        }

        $seeder = new DatabaseSeeder();
        $seeder->seedForWorkspace($admin->id, $workspace->id);
    }
}
