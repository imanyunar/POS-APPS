<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Workspace extends Model
{
    use HasUuids;

    protected $fillable = [
        'name', 'slug', 'business_type', 'currency',
        'timezone', 'settings', 'is_active',
    ];

    protected function casts(): array
    {
        return [
            'settings' => 'array',
            'is_active' => 'boolean',
        ];
    }

    public function users(): BelongsToMany
    {
        return $this->belongsToMany(User::class, 'workspace_user')
            ->withPivot('role_in_workspace')
            ->withTimestamps();
    }

    public function customers(): HasMany { return $this->hasMany(Customer::class); }
    public function orders(): HasMany { return $this->hasMany(Order::class); }
    public function invoices(): HasMany { return $this->hasMany(Invoice::class); }
    public function menuItems(): HasMany { return $this->hasMany(MenuItem::class); }
    public function inventoryItems(): HasMany { return $this->hasMany(InventoryItem::class); }
    public function tasks(): HasMany { return $this->hasMany(Task::class); }
    public function notes(): HasMany { return $this->hasMany(Note::class); }
}
