<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('orders', function (Blueprint $table) {
            $table->enum('order_type', ['dine-in', 'takeaway', 'delivery'])->default('dine-in')->after('total_amount');
            $table->string('table_number')->nullable()->after('order_type');
            $table->text('notes')->nullable()->after('due_date');
        });
    }

    public function down(): void
    {
        Schema::table('orders', function (Blueprint $table) {
            $table->dropColumn(['order_type', 'table_number', 'notes']);
        });
    }
};
