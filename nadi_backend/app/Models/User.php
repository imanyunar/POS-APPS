<?php

namespace App\Models;

use Database\Factories\UserFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Spatie\Permission\Traits\HasRoles;

class User extends Authenticatable
{
    /** @use HasFactory<UserFactory> */
    use HasApiTokens, HasFactory, Notifiable, HasRoles;

    protected $fillable = [
        'name',
        'email',
        'password',
        'current_workspace_id',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }

    public function currentWorkspace(): BelongsTo
    {
        return $this->belongsTo(Workspace::class, 'current_workspace_id');
    }

    public function workspaces(): BelongsToMany
    {
        return $this->belongsToMany(Workspace::class, 'workspace_user')
            ->withPivot('role_in_workspace')
            ->withTimestamps();
    }

    public function setCurrentWorkspace(Workspace $workspace): void
    {
        $this->current_workspace_id = $workspace->id;
        $this->save();
    }

    public function customers() { return $this->hasMany(Customer::class); }
    public function orders() { return $this->hasMany(Order::class); }
    public function invoices() { return $this->hasMany(Invoice::class); }
    public function tasks() { return $this->hasMany(Task::class); }
    public function notes() { return $this->hasMany(Note::class); }
    public function menuItems() { return $this->hasMany(MenuItem::class); }
    public function inventoryItems() { return $this->hasMany(InventoryItem::class); }
    public function activities() { return $this->hasMany(Activity::class); }
}
