<?php

namespace Database\Seeders;

use App\Models\Customer;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Invoice;
use App\Models\InvoiceItem;
use App\Models\MenuItem;
use App\Models\InventoryItem;
use App\Models\Task;
use App\Models\Note;
use App\Models\Activity;
use Carbon\Carbon;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $this->call(RbacSeeder::class);
    }

    public function seedForWorkspace(string $userId, string $workspaceId): void
    {
        $rina = Customer::create([
            'id' => Str::uuid(), 'user_id' => $userId, 'workspace_id' => $workspaceId,
            'name' => 'Rina Amelia', 'phone' => '+6281234567890',
            'internal_notes' => 'Regular kopi susu, suka duduk di outdoor.',
        ]);

        $agus = Customer::create([
            'id' => Str::uuid(), 'user_id' => $userId, 'workspace_id' => $workspaceId,
            'name' => 'Pak Agus', 'phone' => '+6289876543210',
            'internal_notes' => 'Catering kantor, pesan nasi box setiap Jumat.',
        ]);

        $dewi = Customer::create([
            'id' => Str::uuid(), 'user_id' => $userId, 'workspace_id' => $workspaceId,
            'name' => 'Dwi Putri', 'phone' => '+6285551234567',
            'internal_notes' => 'Takeaway dessert, alergi kacang.',
        ]);

        $kopiSusu = MenuItem::create([
            'id' => Str::uuid(), 'user_id' => $userId, 'workspace_id' => $workspaceId,
            'name' => 'Kopi Susu Aren', 'description' => 'Espresso + susu + gula aren',
            'price' => 25000, 'category' => 'minuman',
            'estimated_prep_minutes' => 3, 'track_stock' => true,
            'stock_quantity' => 50, 'low_stock_threshold' => 10,
        ]);

        $croissant = MenuItem::create([
            'id' => Str::uuid(), 'user_id' => $userId, 'workspace_id' => $workspaceId,
            'name' => 'Croissant Coklat', 'description' => 'Croissant isi coklat Belgian',
            'price' => 35000, 'category' => 'snack',
            'estimated_prep_minutes' => 5,
        ]);

        $nasiGoreng = MenuItem::create([
            'id' => Str::uuid(), 'user_id' => $userId, 'workspace_id' => $workspaceId,
            'name' => 'Nasi Goreng Spesial', 'description' => 'Nasi goreng dengan telur, ayam, udang',
            'price' => 45000, 'category' => 'makanan',
            'estimated_prep_minutes' => 10,
        ]);

        $esTeh = MenuItem::create([
            'id' => Str::uuid(), 'user_id' => $userId, 'workspace_id' => $workspaceId,
            'name' => 'Es Teh Manis', 'description' => 'Teh hitam dengan gula batu',
            'price' => 10000, 'category' => 'minuman',
            'estimated_prep_minutes' => 2,
        ]);

        $matcha = MenuItem::create([
            'id' => Str::uuid(), 'user_id' => $userId, 'workspace_id' => $workspaceId,
            'name' => 'Matcha Latte', 'description' => 'Matcha premium dengan susu oat',
            'price' => 32000, 'category' => 'minuman',
            'estimated_prep_minutes' => 4, 'track_stock' => true,
            'stock_quantity' => 30, 'low_stock_threshold' => 5,
        ]);

        $order1 = Order::create([
            'id' => Str::uuid(), 'user_id' => $userId, 'workspace_id' => $workspaceId,
            'customer_id' => $rina->id,
            'order_number' => 'ORD-20260526-001', 'status' => 'pending',
            'total_amount' => 60000, 'order_type' => 'dine-in', 'table_number' => '3',
        ]);

        OrderItem::create([
            'id' => Str::uuid(), 'order_id' => $order1->id, 'menu_item_id' => $kopiSusu->id,
            'item_name' => 'Kopi Susu Aren', 'quantity' => 2, 'unit_price' => 25000, 'total' => 50000,
        ]);

        OrderItem::create([
            'id' => Str::uuid(), 'order_id' => $order1->id, 'menu_item_id' => $croissant->id,
            'item_name' => 'Croissant Coklat', 'quantity' => 1, 'unit_price' => 35000, 'total' => 35000,
        ]);

        $order2 = Order::create([
            'id' => Str::uuid(), 'user_id' => $userId, 'workspace_id' => $workspaceId,
            'customer_id' => $dewi->id,
            'order_number' => 'ORD-20260526-002', 'status' => 'preparing',
            'total_amount' => 32000, 'order_type' => 'takeaway',
        ]);

        OrderItem::create([
            'id' => Str::uuid(), 'order_id' => $order2->id, 'menu_item_id' => $matcha->id,
            'item_name' => 'Matcha Latte', 'quantity' => 1, 'unit_price' => 32000, 'total' => 32000,
        ]);

        $order3 = Order::create([
            'id' => Str::uuid(), 'user_id' => $userId, 'workspace_id' => $workspaceId,
            'customer_id' => $agus->id,
            'order_number' => 'ORD-20260525-003', 'status' => 'completed',
            'total_amount' => 135000, 'order_type' => 'delivery',
        ]);

        OrderItem::create([
            'id' => Str::uuid(), 'order_id' => $order3->id, 'menu_item_id' => $nasiGoreng->id,
            'item_name' => 'Nasi Goreng Spesial', 'quantity' => 3, 'unit_price' => 45000, 'total' => 135000,
        ]);

        $inv1 = Invoice::create([
            'id' => Str::uuid(), 'user_id' => $userId, 'workspace_id' => $workspaceId,
            'customer_id' => $dewi->id,
            'invoice_number' => 'INV-20260526-001', 'status' => 'unpaid',
            'subtotal' => 32000, 'tax' => 0, 'total' => 32000,
            'due_date' => Carbon::now()->addDays(7),
        ]);

        InvoiceItem::create([
            'id' => Str::uuid(), 'invoice_id' => $inv1->id,
            'name' => 'Matcha Latte', 'quantity' => 1, 'unit_price' => 32000, 'total' => 32000,
        ]);

        $inv2 = Invoice::create([
            'id' => Str::uuid(), 'user_id' => $userId, 'workspace_id' => $workspaceId,
            'customer_id' => $rina->id,
            'invoice_number' => 'INV-20260520-001', 'status' => 'paid',
            'subtotal' => 85000, 'tax' => 0, 'total' => 85000,
            'due_date' => Carbon::now()->subDays(2),
        ]);

        InvoiceItem::create([
            'id' => Str::uuid(), 'invoice_id' => $inv2->id,
            'name' => 'Kopi Susu Aren', 'quantity' => 2, 'unit_price' => 25000, 'total' => 50000,
        ]);

        InvoiceItem::create([
            'id' => Str::uuid(), 'invoice_id' => $inv2->id,
            'name' => 'Croissant Coklat', 'quantity' => 1, 'unit_price' => 35000, 'total' => 35000,
        ]);

        InventoryItem::create([
            'id' => Str::uuid(), 'user_id' => $userId, 'workspace_id' => $workspaceId,
            'name' => 'Susu UHT Full Cream', 'sku' => 'SUSU-001',
            'quantity' => 12, 'unit_price' => 18000, 'unit' => 'liter',
            'low_stock_threshold' => 5, 'status' => 'in_stock',
        ]);

        InventoryItem::create([
            'id' => Str::uuid(), 'user_id' => $userId, 'workspace_id' => $workspaceId,
            'name' => 'Kopi Arabika Gayo', 'sku' => 'KOPI-001',
            'quantity' => 3, 'unit_price' => 85000, 'unit' => 'kg',
            'low_stock_threshold' => 5, 'status' => 'low_stock',
        ]);

        InventoryItem::create([
            'id' => Str::uuid(), 'user_id' => $userId, 'workspace_id' => $workspaceId,
            'name' => 'Tepung Terigu', 'sku' => 'TPG-001',
            'quantity' => 0, 'unit_price' => 12000, 'unit' => 'kg',
            'low_stock_threshold' => 10, 'status' => 'out_of_stock',
        ]);

        Task::create(['id' => Str::uuid(), 'user_id' => $userId, 'workspace_id' => $workspaceId, 'title' => 'Nyalakan mesin kopi', 'category' => 'opening', 'sort_order' => 1]);
        Task::create(['id' => Str::uuid(), 'user_id' => $userId, 'workspace_id' => $workspaceId, 'title' => 'Set meja & kursi', 'category' => 'opening', 'sort_order' => 2]);
        Task::create(['id' => Str::uuid(), 'user_id' => $userId, 'workspace_id' => $workspaceId, 'title' => 'Cek stok bahan baku', 'category' => 'opening', 'sort_order' => 3]);
        Task::create(['id' => Str::uuid(), 'user_id' => $userId, 'workspace_id' => $workspaceId, 'title' => 'Bersihkan area dapur', 'category' => 'closing', 'sort_order' => 1]);
        Task::create(['id' => Str::uuid(), 'user_id' => $userId, 'workspace_id' => $workspaceId, 'title' => 'Hitung kas harian', 'category' => 'closing', 'sort_order' => 2]);
        Task::create(['id' => Str::uuid(), 'user_id' => $userId, 'workspace_id' => $workspaceId, 'title' => 'Order stok susu ke supplier', 'category' => 'daily']);
        Task::create(['id' => Str::uuid(), 'user_id' => $userId, 'workspace_id' => $workspaceId, 'title' => 'Follow up catering Pak Agus', 'category' => 'daily']);

        Note::create(['id' => Str::uuid(), 'user_id' => $userId, 'workspace_id' => $workspaceId, 'title' => 'Nomor Supplier Susu', 'content' => 'Pak Budi (0821-xxxx-xxxx) - antar setiap Senin & Kamis', 'category' => 'supplier', 'is_pinned' => true]);
        Note::create(['id' => Str::uuid(), 'user_id' => $userId, 'workspace_id' => $workspaceId, 'customer_id' => $dewi->id, 'title' => 'Alergi Dwi Putri', 'content' => 'ALERGI KACANG! Jangan pakai topping kacang untuk dessert.', 'category' => 'customer', 'is_pinned' => true]);
        Note::create(['id' => Str::uuid(), 'user_id' => $userId, 'workspace_id' => $workspaceId, 'title' => 'Resep Baru: Es Kopi Gula Aren', 'content' => 'Campur: 15ml gula aren cair, double shot espresso, 200ml susu full cream. Sajikan dengan es batu.', 'category' => 'kitchen']);

        Activity::create(['id' => Str::uuid(), 'user_id' => $userId, 'workspace_id' => $workspaceId, 'customer_id' => $rina->id, 'type' => 'order_created', 'details' => ['order_number' => 'ORD-20260526-001', 'total' => 60000]]);
        Activity::create(['id' => Str::uuid(), 'user_id' => $userId, 'workspace_id' => $workspaceId, 'customer_id' => $dewi->id, 'type' => 'invoice_created', 'details' => ['invoice_number' => 'INV-20260526-001', 'total' => 32000]]);
    }
}
