<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    private array $tables = [
        'customers', 'orders', 'invoices', 'invoice_items',
        'menu_items', 'inventory_items', 'order_items',
        'tasks', 'notes', 'activities',
    ];

    public function up(): void
    {
        foreach ($this->tables as $table) {
            Schema::table($table, function (Blueprint $t) use ($table) {
                $t->foreignUuid('workspace_id')->nullable()->constrained('workspaces')->cascadeOnDelete();
                $t->index('workspace_id', "idx_{$table}_workspace");
            });
        }
    }

    public function down(): void
    {
        foreach ($this->tables as $table) {
            Schema::table($table, function (Blueprint $t) {
                $t->dropConstrainedForeignId('workspace_id');
            });
        }
    }
};
