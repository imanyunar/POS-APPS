<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class SetWorkspace
{
    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user();

        if (!$user) {
            return $next($request);
        }

        $headerWorkspaceId = $request->header('X-Workspace-Id');

        if ($headerWorkspaceId) {
            $workspace = $user->workspaces()
                ->where('workspace_id', $headerWorkspaceId)
                ->first();

            if ($workspace) {
                $user->current_workspace_id = $workspace->id;
                $request->attributes->set('workspace', $workspace);
                setPermissionsTeamId($workspace->id);
            }
        } elseif ($user->current_workspace_id) {
            $workspace = $user->currentWorkspace()->first();
            if ($workspace) {
                $request->attributes->set('workspace', $workspace);
                setPermissionsTeamId($workspace->id);
            }
        }

        if (!$request->attributes->has('workspace')) {
            $firstWorkspace = $user->workspaces()->first();
            if ($firstWorkspace) {
                $user->current_workspace_id = $firstWorkspace->id;
                $user->save();
                $request->attributes->set('workspace', $firstWorkspace);
                setPermissionsTeamId($firstWorkspace->id);
            }
        }

        return $next($request);
    }
}
