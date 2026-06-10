<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Product;
use App\Models\Transaction;
use App\Models\TransactionItem;
use App\Models\User;
use App\Models\Workspace;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $workspace = Workspace::create([
            'name' => 'Warung Sejahtera',
            'owner_name' => 'Budi Santoso',
            'phone' => '08123456789',
            'address' => 'Jl. Merdeka No. 123, Jakarta',
            'plan' => 'free',
        ]);

        $owner = User::create([
            'workspace_id' => $workspace->id,
            'name' => 'Budi Santoso',
            'email' => 'owner@warung.test',
            'password' => Hash::make('password'),
            'role' => 'owner',
        ]);

        $cashier = User::create([
            'workspace_id' => $workspace->id,
            'name' => 'Siti Kasir',
            'email' => 'kasir@warung.test',
            'password' => Hash::make('password'),
            'role' => 'cashier',
        ]);

        $category = Category::create([
            'workspace_id' => $workspace->id,
            'name' => 'Makanan',
        ]);

        $minuman = Category::create([
            'workspace_id' => $workspace->id,
            'name' => 'Minuman',
        ]);

        Product::create([
            'workspace_id' => $workspace->id,
            'sku' => 'MKN-001',
            'name' => 'Nasi Goreng',
            'category_id' => $category->id,
            'price' => 15000,
            'cost_price' => 10000,
            'stock' => 50,
            'min_stock' => 10,
            'unit' => 'porsi',
        ]);

        Product::create([
            'workspace_id' => $workspace->id,
            'sku' => 'MKN-002',
            'name' => 'Ayam Bakar',
            'category_id' => $category->id,
            'price' => 25000,
            'cost_price' => 18000,
            'stock' => 30,
            'min_stock' => 5,
            'unit' => 'porsi',
        ]);

        Product::create([
            'workspace_id' => $workspace->id,
            'sku' => 'MKN-003',
            'name' => 'Mie Goreng',
            'category_id' => $category->id,
            'price' => 12000,
            'cost_price' => 7000,
            'stock' => 40,
            'min_stock' => 10,
            'unit' => 'porsi',
        ]);

        Product::create([
            'workspace_id' => $workspace->id,
            'sku' => 'MIN-001',
            'name' => 'Es Teh Manis',
            'category_id' => $minuman->id,
            'price' => 5000,
            'cost_price' => 2000,
            'stock' => 100,
            'min_stock' => 20,
            'unit' => 'gelas',
        ]);

        Product::create([
            'workspace_id' => $workspace->id,
            'sku' => 'MIN-002',
            'name' => 'Jus Jeruk',
            'category_id' => $minuman->id,
            'price' => 8000,
            'cost_price' => 4000,
            'stock' => 3,
            'min_stock' => 10,
            'unit' => 'gelas',
        ]);

        Product::create([
            'workspace_id' => $workspace->id,
            'sku' => 'MIN-003',
            'name' => 'Kopi Hitam',
            'category_id' => $minuman->id,
            'price' => 10000,
            'cost_price' => 5000,
            'stock' => 60,
            'min_stock' => 15,
            'unit' => 'cangkir',
        ]);

        $transaction = Transaction::create([
            'workspace_id' => $workspace->id,
            'cashier_id' => $cashier->id,
            'total' => 43000,
            'discount' => 0,
            'grand_total' => 43000,
            'amount_paid' => 50000,
            'change' => 7000,
            'payment_method' => 'cash',
            'status' => 'completed',
        ]);

        TransactionItem::create([
            'transaction_id' => $transaction->id,
            'product_id' => 1,
            'product_name' => 'Nasi Goreng',
            'qty' => 2,
            'price' => 15000,
            'discount' => 0,
            'subtotal' => 30000,
        ]);

        TransactionItem::create([
            'transaction_id' => $transaction->id,
            'product_id' => 4,
            'product_name' => 'Es Teh Manis',
            'qty' => 1,
            'price' => 5000,
            'discount' => 0,
            'subtotal' => 5000,
        ]);
    }
}
