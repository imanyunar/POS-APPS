<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\LoginRequest;
use App\Http\Requests\RegisterRequest;
use App\Http\Resources\UserResource;
use App\Models\User;
use App\Models\Workspace;
use App\Services\RbacService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class AuthController extends Controller
{
    public function login(LoginRequest $request)
    {
        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json([
                'success' => false,
                'message' => 'Email atau password salah',
                'data' => null,
                'meta' => ['timestamp' => now()->toIso8601String()],
            ], 401);
        }

        $token = $user->createToken('serve-app')->plainTextToken;

        $workspaces = $user->workspaces()->get()->map(fn($w) => [
            'id' => $w->id,
            'name' => $w->name,
            'slug' => $w->slug,
            'role' => $w->pivot->role_in_workspace,
        ]);

        $roles = [];
        $permissions = [];
        if ($user->current_workspace_id) {
            setPermissionsTeamId($user->current_workspace_id);
            $roles = $user->getRoleNames();
            $permissions = $user->getAllPermissions()->pluck('name');
        }

        return response()->json([
            'success' => true,
            'message' => 'Login berhasil',
            'data' => [
                'user' => new UserResource($user),
                'token' => $token,
                'workspaces' => $workspaces,
                'roles' => $roles,
                'permissions' => $permissions,
            ],
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function register(RegisterRequest $request)
    {
        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
        ]);

        $workspace = Workspace::create([
            'name' => $request->name . '\'s Workspace',
            'slug' => Str::slug($request->name) . '-' . substr(md5(uniqid()), 0, 6),
            'business_type' => $request->business_type ?? 'cafe',
            'settings' => [
                'order_prefix' => 'ORD',
                'invoice_prefix' => 'INV',
                'default_tax' => 11,
            ],
        ]);

        $user->workspaces()->attach($workspace->id, ['role_in_workspace' => 'owner']);
        $user->current_workspace_id = $workspace->id;
        $user->save();

        RbacService::ensureRolesForWorkspace($workspace);

        setPermissionsTeamId($workspace->id);
        $user->assignRole('Owner');

        $token = $user->createToken('serve-app')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Registrasi berhasil',
            'data' => [
                'user' => new UserResource($user),
                'token' => $token,
                'workspaces' => [
                    [
                        'id' => $workspace->id,
                        'name' => $workspace->name,
                        'slug' => $workspace->slug,
                        'role' => 'owner',
                    ],
                ],
                'roles' => ['Owner'],
                'permissions' => RbacService::rolePermissions()['Owner'],
            ],
            'meta' => ['timestamp' => now()->toIso8601String()],
        ], 201);
    }

    public function switchWorkspace(Request $request)
    {
        $request->validate(['workspace_id' => 'required|string']);
        $user = $request->user();

        $workspace = $user->workspaces()->where('workspace_id', $request->workspace_id)->first();

        if (!$workspace) {
            return response()->json([
                'success' => false,
                'message' => 'Workspace not found',
            ], 404);
        }

        $user->setCurrentWorkspace($workspace);

        setPermissionsTeamId($workspace->id);

        return response()->json([
            'success' => true,
            'message' => 'Workspace switched',
            'data' => [
                'workspace' => [
                    'id' => $workspace->id,
                    'name' => $workspace->name,
                    'slug' => $workspace->slug,
                    'role' => $workspace->pivot->role_in_workspace,
                ],
                'roles' => $user->getRoleNames(),
                'permissions' => $user->getAllPermissions()->pluck('name'),
            ],
        ]);
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'success' => true,
            'message' => 'Logout berhasil',
            'data' => null,
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function me(Request $request)
    {
        $user = $request->user()->load('currentWorkspace');

        $workspaces = $user->workspaces()->get()->map(fn($w) => [
            'id' => $w->id,
            'name' => $w->name,
            'slug' => $w->slug,
            'role' => $w->pivot->role_in_workspace,
        ]);

        $roles = [];
        $permissions = [];
        if ($user->current_workspace_id) {
            setPermissionsTeamId($user->current_workspace_id);
            $roles = $user->getRoleNames();
            $permissions = $user->getAllPermissions()->pluck('name');
        }

        return response()->json([
            'success' => true,
            'message' => 'User retrieved',
            'data' => [
                'user' => new UserResource($user),
                'workspaces' => $workspaces,
                'roles' => $roles,
                'permissions' => $permissions,
            ],
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }
}
