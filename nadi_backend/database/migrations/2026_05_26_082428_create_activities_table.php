<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('activities', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->foreignUuid('customer_id')->nullable()->constrained('customers')->nullOnDelete();
            $table->string('type'); // 'order_created', 'invoice_paid', 'note_added'
            $table->jsonb('details')->nullable(); // structured JSON data for flexible payloads
            $table->timestamps();
            
            // GIN index for rapid queries on custom JSONB timeline payloads
            // Use simple index for broad compatibility, or DB::statement for actual GIN depending on DB engine.
            $table->index('user_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('activities');
    }
};
