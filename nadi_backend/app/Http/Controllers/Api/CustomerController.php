<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreCustomerRequest;
use App\Http\Resources\ActivityResource;
use App\Http\Resources\CustomerResource;
use App\Http\Resources\InvoiceResource;
use App\Http\Resources\OrderResource;
use App\Models\Activity;
use App\Models\Customer;
use Illuminate\Http\Request;

class CustomerController extends Controller
{
    public function index(Request $request)
    {
        $query = Customer::where('user_id', $request->user()->id)
            ->withCount(['orders', 'invoices'])
            ->withSum(['invoices' => fn($q) => $q->where('status', 'unpaid')], 'total');

        if ($search = $request->search) {
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                  ->orWhere('phone', 'like', "%{$search}%");
            });
        }

        $customers = $query->orderBy('name')->get();

        return response()->json([
            'success' => true,
            'message' => 'Customers retrieved',
            'data' => CustomerResource::collection($customers),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function store(StoreCustomerRequest $request)
    {
        $customer = Customer::create([
            'user_id' => $request->user()->id,
            'name' => $request->name,
            'phone' => $request->phone,
            'email' => $request->email,
            'internal_notes' => $request->internalNotes,
        ]);

        Activity::create([
            'user_id' => $request->user()->id,
            'customer_id' => $customer->id,
            'type' => 'customer_created',
            'details' => ['customer_name' => $customer->name],
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Customer created',
            'data' => new CustomerResource($customer),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ], 201);
    }

    public function show(Request $request, string $id)
    {
        $customer = Customer::where('user_id', $request->user()->id)
            ->with(['orders' => fn($q) => $q->latest(), 'invoices' => fn($q) => $q->latest(), 'activities' => fn($q) => $q->latest()])
            ->findOrFail($id);

        return response()->json([
            'success' => true,
            'message' => 'Customer retrieved',
            'data' => new CustomerResource($customer),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function update(StoreCustomerRequest $request, string $id)
    {
        $customer = Customer::where('user_id', $request->user()->id)->findOrFail($id);
        $customer->update([
            'name' => $request->name,
            'phone' => $request->phone,
            'email' => $request->email,
            'internal_notes' => $request->internalNotes,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Customer updated',
            'data' => new CustomerResource($customer),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function destroy(Request $request, string $id)
    {
        $customer = Customer::where('user_id', $request->user()->id)->findOrFail($id);
        $customer->delete();

        return response()->json([
            'success' => true,
            'message' => 'Customer deleted',
            'data' => null,
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function orders(Request $request, string $id)
    {
        $customer = Customer::where('user_id', $request->user()->id)->findOrFail($id);

        return response()->json([
            'success' => true,
            'message' => 'Customer orders retrieved',
            'data' => OrderResource::collection($customer->orders()->latest()->get()),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function invoices(Request $request, string $id)
    {
        $customer = Customer::where('user_id', $request->user()->id)->findOrFail($id);

        return response()->json([
            'success' => true,
            'message' => 'Customer invoices retrieved',
            'data' => InvoiceResource::collection($customer->invoices()->latest()->get()),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function timeline(Request $request, string $id)
    {
        $customer = Customer::where('user_id', $request->user()->id)->findOrFail($id);

        return response()->json([
            'success' => true,
            'message' => 'Customer timeline retrieved',
            'data' => ActivityResource::collection($customer->activities()->latest()->get()),
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }
}
