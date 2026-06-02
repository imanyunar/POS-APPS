<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

abstract class Controller
{
    protected function workspaceId(Request $request): string
    {
        return (string) $request->attributes->get('workspace')->id;
    }
}
