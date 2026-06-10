<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use App\Models\Transaction;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function summary(Request $request)
    {
        $workspaceId = $request->user()->workspace_id;
        $today = now()->startOfDay();

        $todayRevenue = Transaction::where('workspace_id', $workspaceId)
            ->where('created_at', '>=', $today)
            ->where('status', 'completed')
            ->sum('grand_total');

        $todayCount = Transaction::where('workspace_id', $workspaceId)
            ->where('created_at', '>=', $today)
            ->where('status', 'completed')
            ->count();

        $lowStockCount = Product::where('workspace_id', $workspaceId)
            ->where('is_active', true)
            ->whereColumn('stock', '<=', 'min_stock')
            ->count();

        $totalProducts = Product::where('workspace_id', $workspaceId)
            ->where('is_active', true)
            ->count();

        return response()->json([
            'today_revenue' => (int) $todayRevenue,
            'today_transactions' => $todayCount,
            'low_stock_count' => $lowStockCount,
            'total_products' => $totalProducts,
        ]);
    }

    public function recentTransactions(Request $request)
    {
        $transactions = Transaction::where('workspace_id', $request->user()->workspace_id)
            ->with('cashier')
            ->latest()
            ->take(10)
            ->get();

        return response()->json($transactions);
    }
}
