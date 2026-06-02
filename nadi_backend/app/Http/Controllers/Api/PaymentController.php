<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Invoice;
use App\Models\Activity;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class PaymentController extends Controller
{
    public function createPaymentLink(Request $request)
    {
        $request->validate([
            'invoice_id' => 'required|string|exists:invoices,id',
        ]);

        $invoice = Invoice::with('customer')
            ->where('user_id', $request->user()->id)
            ->findOrFail($request->invoice_id);

        if ($invoice->status === 'paid') {
            return response()->json([
                'success' => false,
                'message' => 'Invoice sudah dibayar',
                'data' => null,
                'meta' => ['timestamp' => now()->toIso8601String()],
            ], 400);
        }

        $externalId = 'INV-' . $invoice->id . '-' . now()->timestamp;

        $payload = [
            'external_id' => $externalId,
            'amount' => (int) $invoice->total,
            'description' => 'Pembayaran invoice ' . $invoice->invoiceNumber,
            'customer' => [
                'name' => $invoice->customer?->name ?? 'Umum',
                'email' => $invoice->customer?->email,
                'phone' => $invoice->customer?->phone,
            ],
            'success_redirect_url' => config('app.frontend_url') . '/invoices/' . $invoice->id . '?status=success',
            'failure_redirect_url' => config('app.frontend_url') . '/invoices/' . $invoice->id . '?status=failed',
        ];

        try {
            $gatewayUrl = config('payment.gateway_url');
            $apiKey = config('payment.api_key');

            if ($gatewayUrl && $apiKey) {
                $response = Http::withHeaders([
                    'Authorization' => 'Basic ' . base64_encode($apiKey . ':'),
                    'Content-Type' => 'application/json',
                ])->post($gatewayUrl . '/v2/charge', $payload);

                if ($response->successful()) {
                    $data = $response->json();

                    Activity::create([
                        'user_id' => $request->user()->id,
                        'customer_id' => $invoice->customer_id,
                        'type' => 'payment_link_created',
                        'details' => [
                            'invoice_id' => $invoice->id,
                            'invoice_number' => $invoice->invoiceNumber,
                            'amount' => $invoice->total,
                            'payment_url' => $data['invoice_url'] ?? null,
                        ],
                    ]);

                    return response()->json([
                        'success' => true,
                        'message' => 'Link pembayaran berhasil dibuat',
                        'data' => [
                            'invoice_id' => $invoice->id,
                            'payment_url' => $data['invoice_url'] ?? null,
                            'external_id' => $externalId,
                            'amount' => $invoice->total,
                        ],
                        'meta' => ['timestamp' => now()->toIso8601String()],
                    ]);
                }
            }

            return response()->json([
                'success' => true,
                'message' => 'Link pembayaran simulasi berhasil dibuat',
                'data' => [
                    'invoice_id' => $invoice->id,
                    'payment_url' => config('app.frontend_url') . '/pay/' . $externalId,
                    'external_id' => $externalId,
                    'amount' => $invoice->total,
                ],
                'meta' => ['timestamp' => now()->toIso8601String()],
            ]);
        } catch (\Exception $e) {
            Log::error('Payment gateway error: ' . $e->getMessage());

            return response()->json([
                'success' => false,
                'message' => 'Gagal membuat link pembayaran',
                'data' => null,
                'meta' => ['timestamp' => now()->toIso8601String()],
            ], 500);
        }
    }

    public function handleWebhook(Request $request)
    {
        $payload = $request->all();
        $externalId = $payload['external_id'] ?? null;

        Log::info('Payment webhook received', ['payload' => $payload]);

        if (!$externalId) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid payload: missing external_id',
            ], 400);
        }

        $invoiceId = str_replace('INV-', '', $externalId);
        $invoiceId = substr($invoiceId, 0, strrpos($invoiceId, '-'));

        $invoice = Invoice::find($invoiceId);

        if (!$invoice) {
            Log::warning('Invoice not found for webhook', ['external_id' => $externalId]);
            return response()->json([
                'success' => false,
                'message' => 'Invoice not found',
            ], 404);
        }

        $status = $payload['status'] ?? ($payload['transaction_status'] ?? null);

        if ($status === 'SETTLEMENT' || $status === 'capture' || $status === 'success') {
            $invoice->update(['status' => 'paid']);

            Activity::create([
                'user_id' => $invoice->user_id,
                'customer_id' => $invoice->customer_id,
                'type' => 'invoice_paid',
                'details' => [
                    'invoice_id' => $invoice->id,
                    'invoice_number' => $invoice->invoiceNumber,
                    'amount' => $invoice->total,
                    'payment_method' => $payload['payment_method'] ?? 'online',
                    'external_id' => $externalId,
                ],
            ]);
        }

        return response()->json([
            'success' => true,
            'message' => 'Webhook processed successfully',
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }

    public function getPaymentStatus(Request $request, string $invoiceId)
    {
        $invoice = Invoice::where('user_id', $request->user()->id)
            ->findOrFail($invoiceId);

        return response()->json([
            'success' => true,
            'message' => 'Status pembayaran',
            'data' => [
                'invoice_id' => $invoice->id,
                'invoice_number' => $invoice->invoiceNumber,
                'status' => $invoice->status,
                'total' => $invoice->total,
            ],
            'meta' => ['timestamp' => now()->toIso8601String()],
        ]);
    }
}
