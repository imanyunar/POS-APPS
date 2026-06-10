<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('transactions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('workspace_id')->constrained()->cascadeOnDelete();
            $table->foreignId('cashier_id')->constrained('users');
            $table->bigInteger('total')->default(0);
            $table->bigInteger('discount')->default(0);
            $table->bigInteger('grand_total')->default(0);
            $table->bigInteger('amount_paid')->default(0);
            $table->bigInteger('change')->default(0);
            $table->string('payment_method')->default('cash');
            $table->string('status')->default('completed'); // completed | refunded
            $table->text('notes')->nullable();
            $table->timestamps();
        });

        Schema::create('transaction_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('transaction_id')->constrained()->cascadeOnDelete();
            $table->foreignId('product_id')->constrained();
            $table->unsignedBigInteger('variant_id')->nullable();
            $table->string('product_name');
            $table->integer('qty')->default(1);
            $table->bigInteger('price')->default(0);
            $table->bigInteger('discount')->default(0);
            $table->bigInteger('subtotal')->default(0);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('transaction_items');
        Schema::dropIfExists('transactions');
    }
};
