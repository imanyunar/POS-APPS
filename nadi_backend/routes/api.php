<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\DashboardController;
use App\Http\Controllers\Api\CustomerController;
use App\Http\Controllers\Api\OrderController;
use App\Http\Controllers\Api\InvoiceController;
use App\Http\Controllers\Api\MenuItemController;
use App\Http\Controllers\Api\InventoryItemController;
use App\Http\Controllers\Api\TaskController;
use App\Http\Controllers\Api\NoteController;

// Public routes
Route::post('/auth/login', [AuthController::class, 'login']);
Route::post('/auth/register', [AuthController::class, 'register']);

// Protected routes
Route::middleware(['auth:sanctum', 'workspace'])->group(function () {
    // Auth
    Route::post('/auth/logout', [AuthController::class, 'logout']);
    Route::get('/auth/me', [AuthController::class, 'me']);
    Route::post('/auth/switch-workspace', [AuthController::class, 'switchWorkspace']);

    // Dashboard — minimum role: viewer
    Route::middleware('permission:view_dashboard')->group(function () {
        Route::get('/dashboard/vitals', [DashboardController::class, 'getVitals']);
        Route::get('/dashboard/activities', [DashboardController::class, 'getActivities']);
    });

    // Customers — minimum role: cashier
    Route::middleware('permission:manage_customers')->group(function () {
        Route::get('/customers', [CustomerController::class, 'index']);
        Route::post('/customers', [CustomerController::class, 'store']);
        Route::get('/customers/{id}', [CustomerController::class, 'show']);
        Route::put('/customers/{id}', [CustomerController::class, 'update']);
        Route::delete('/customers/{id}', [CustomerController::class, 'destroy']);
        Route::get('/customers/{id}/orders', [CustomerController::class, 'orders']);
        Route::get('/customers/{id}/invoices', [CustomerController::class, 'invoices']);
        Route::get('/customers/{id}/timeline', [CustomerController::class, 'timeline']);
    });

    // Orders — minimum role: cashier
    Route::middleware('permission:manage_orders')->group(function () {
        Route::get('/orders', [OrderController::class, 'index']);
        Route::post('/orders', [OrderController::class, 'store']);
        Route::get('/orders/{id}', [OrderController::class, 'show']);
        Route::put('/orders/{id}', [OrderController::class, 'update']);
        Route::delete('/orders/{id}', [OrderController::class, 'destroy']);
        Route::patch('/orders/{id}/status', [OrderController::class, 'updateStatus']);
    });

    // Invoices — minimum role: cashier
    Route::middleware('permission:manage_payments')->group(function () {
        Route::get('/invoices', [InvoiceController::class, 'index']);
        Route::post('/invoices', [InvoiceController::class, 'store']);
        Route::get('/invoices/{id}', [InvoiceController::class, 'show']);
        Route::delete('/invoices/{id}', [InvoiceController::class, 'destroy']);
        Route::patch('/invoices/{id}/mark-paid', [InvoiceController::class, 'markPaid']);
    });

    // Menu Items
    Route::middleware('permission:manage_inventory')->group(function () {
        Route::get('/menu-items', [MenuItemController::class, 'index']);
        Route::post('/menu-items', [MenuItemController::class, 'store']);
        Route::get('/menu-items/{id}', [MenuItemController::class, 'show']);
        Route::put('/menu-items/{id}', [MenuItemController::class, 'update']);
        Route::delete('/menu-items/{id}', [MenuItemController::class, 'destroy']);
        Route::patch('/menu-items/{id}/toggle-availability', [MenuItemController::class, 'toggleAvailability']);
    });

    // Inventory
    Route::middleware('permission:manage_inventory')->group(function () {
        Route::get('/inventory', [InventoryItemController::class, 'index']);
        Route::post('/inventory', [InventoryItemController::class, 'store']);
        Route::get('/inventory/{id}', [InventoryItemController::class, 'show']);
        Route::put('/inventory/{id}', [InventoryItemController::class, 'update']);
        Route::delete('/inventory/{id}', [InventoryItemController::class, 'destroy']);
        Route::get('/inventory/low-stock', [InventoryItemController::class, 'lowStock']);
    });

    // Tasks
    Route::middleware('permission:manage_tasks')->group(function () {
        Route::get('/tasks', [TaskController::class, 'index']);
        Route::post('/tasks', [TaskController::class, 'store']);
        Route::get('/tasks/{id}', [TaskController::class, 'show']);
        Route::put('/tasks/{id}', [TaskController::class, 'update']);
        Route::delete('/tasks/{id}', [TaskController::class, 'destroy']);
        Route::patch('/tasks/{id}/toggle', [TaskController::class, 'toggle']);
    });

    // Notes
    Route::middleware('permission:manage_notes')->group(function () {
        Route::get('/notes', [NoteController::class, 'index']);
        Route::post('/notes', [NoteController::class, 'store']);
        Route::get('/notes/{id}', [NoteController::class, 'show']);
        Route::put('/notes/{id}', [NoteController::class, 'update']);
        Route::delete('/notes/{id}', [NoteController::class, 'destroy']);
    });
});
