<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\ActivityResource;
use App\Models\Activity;
use App\Models\Invoice;
use App\Models\InventoryItem;
use App\Models\Order;
use App\Models\Task;
use Carbon\Carbon;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function getVitals(Request $request)
    {
        $workspaceId = $request->attributes->get('workspace')->id;
        $today = Carbon::today();

        $todayRevenue = Invoice::where('workspace_id', $workspaceId)
            ->where('status', 'paid')
            ->whereDate('created_at', $today)
            ->sum('total');

        $activeOrdersCount = Order::where('workspace_id', $workspaceId)
            ->whereIn('status', ['pending', 'preparing', 'ready'])
            ->count();

        $pendingInvoices = Invoice::where('workspace_id', $workspaceId)
            ->where('status', 'unpaid');
        $pendingInvoicesCount = $pendingInvoices->count();
        $pendingInvoicesAmount = $pendingInvoices->sum('total');

        $lowStockCount = InventoryItem::where('workspace_id', $workspaceId)
            ->where('status', 'low_stock')
            ->count();

        $todayTasksCompleted = Task::where('workspace_id', $workspaceId)
            ->where('is_completed', true)
            ->whereDate('updated_at', $today)
            ->count();

        return response()->json([
            'success' => true,
            'message' => 'Dashboard vitals retrieved',
            'data' => [
                'todayRevenue' => (float) $todayRevenue,
                'activeOrdersCount' => $activeOrdersCount,
                'pendingInvoicesCount' => $pendingInvoicesCount,
                'pendingInvoicesAmount' => (float) $pendingInvoicesAmount,
                'lowStockCount' => $lowStockCount,
                'todayTasksCompleted' => $todayTasksCompleted,
            ],
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function getActivities(Request $request)
    {
        $activities = Activity::where('workspace_id', $request->attributes->get('workspace')->id)
            ->with('customer')
            ->latest()
            ->take(20)
            ->get();

        return response()->json([
            'success' => true,
            'message' => 'Activities retrieved',
            'data' => ActivityResource::collection($activities),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }
}
