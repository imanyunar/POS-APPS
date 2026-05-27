<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckPermission
{
    public function handle(Request $request, Closure $next, string $permission): Response
    {
        $user = $request->user();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthenticated',
            ], 401);
        }

        if ($user->hasPermissionTo($permission)) {
            return $next($request);
        }

        return response()->json([
            'success' => false,
            'message' => 'Forbidden: you do not have permission to perform this action',
        ], 403);
    }
}
