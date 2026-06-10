<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Transaction extends Model
{
    protected $fillable = [
        'workspace_id',
        'cashier_id',
        'total',
        'discount',
        'grand_total',
        'amount_paid',
        'change',
        'payment_method',
        'status',
        'notes',
    ];

    public function workspace()
    {
        return $this->belongsTo(Workspace::class);
    }

    public function cashier()
    {
        return $this->belongsTo(User::class, 'cashier_id');
    }

    public function items()
    {
        return $this->hasMany(TransactionItem::class);
    }
}
