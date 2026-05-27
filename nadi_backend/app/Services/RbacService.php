<?php

namespace App\Services;

use App\Models\Workspace;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\Models\Role;

class RbacService
{
    public static function defaultPermissions(): array
    {
        return [
            'manage_orders',
            'manage_inventory',
            'manage_customers',
            'manage_staff',
            'manage_payments',
            'manage_tasks',
            'manage_notes',
            'view_reports',
            'manage_settings',
            'manage_workspace',
            'manage_kitchen',
            'view_dashboard',
        ];
    }

    public static function rolePermissions(): array
    {
        return [
            'Super Admin' => [
                'manage_orders', 'manage_inventory', 'manage_customers',
                'manage_staff', 'manage_payments', 'manage_tasks',
                'manage_notes', 'view_reports', 'manage_settings',
                'manage_workspace', 'manage_kitchen', 'view_dashboard',
            ],
            'Owner' => [
                'manage_orders', 'manage_inventory', 'manage_customers',
                'manage_staff', 'manage_payments', 'manage_tasks',
                'manage_notes', 'view_reports', 'manage_settings',
                'manage_workspace', 'manage_kitchen', 'view_dashboard',
            ],
            'Manager' => [
                'manage_orders', 'manage_inventory', 'manage_customers',
                'manage_payments', 'manage_tasks', 'manage_notes',
                'view_reports', 'manage_kitchen', 'view_dashboard',
            ],
            'Cashier' => [
                'manage_orders', 'manage_customers', 'manage_payments',
                'view_dashboard',
            ],
            'Kitchen Staff' => [
                'manage_kitchen', 'manage_orders', 'view_dashboard',
            ],
            'Staff' => [
                'manage_tasks', 'manage_notes', 'view_dashboard',
            ],
            'Viewer' => [
                'view_reports', 'view_dashboard',
            ],
        ];
    }

    public static function ensurePermissions(): void
    {
        foreach (self::defaultPermissions() as $perm) {
            Permission::firstOrCreate(['name' => $perm, 'guard_name' => 'web']);
        }
    }

    public static function ensureRolesForWorkspace(Workspace $workspace): void
    {
        self::ensurePermissions();

        foreach (self::rolePermissions() as $roleName => $perms) {
            $role = Role::firstOrCreate([
                'name' => $roleName,
                'guard_name' => 'web',
                'workspace_id' => $workspace->id,
            ]);
            $role->syncPermissions($perms);
        }
    }

    public static function assignRoleInWorkspace(
        \App\Models\User $user,
        Workspace $workspace,
        string $roleName
    ): void {
        setPermissionsTeamId($workspace->id);
        $user->assignRole($roleName);
    }
}
