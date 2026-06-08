<div align="center">
  <img src="https://readme-typing-svg.demolab.com?font=Outfit&weight=600&size=30&pause=1000&color=533AFD&center=true&vCenter=true&width=600&lines=NADI+Business+OS;The+Third+Space+for+UMKM;Calm,+Premium+Workspace;Point+of+Sale+%2B+ERP" alt="Typing SVG" />
</div>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Laravel_11-FF2D20?style=for-the-badge&logo=laravel&logoColor=white" />
  <img src="https://img.shields.io/badge/Riverpod-00599C?style=for-the-badge&logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white" />
</p>

---

## 🌌 Product Vision: NADI (The Third Space)

Usaha Mikro Kecil dan Menengah (UMKM) Indonesia menyumbang 60% PDB, namun software yang ada terbagi dua sisi ekstrem: **Aplikasi POS Tradisional** yang terlalu kaku dan **Enterprise ERP** yang sangat mahal & rumit.

**NADI** hadir sebagai *The Daily Business Operating System*. Berbeda dengan aplikasi kasir biasa, NADI menawarkan *workspace* yang tenang, elegan, dan terpadu—secara visual mengambil pedoman dari **Stripe Design System** (Indigo & Zinc Dark).

> *"Saya tidak butuh sistem kasir yang rumit; saya butuh tahu pesanan apa yang pending, tugas hari ini apa, dan siapa pelanggan yang belum bayar hutangnya."*

---

## 🏗️ Struktur Projek Lengkap

Proyek ini menggunakan arsitektur **Client-Server** dalam satu *workspace* utama (monorepo).

```text
C:\New folder\tugas\
├── nadi_backend/              # ⚙️ Laravel 11 Backend API
│   ├── app/Models/            # (Activity, Customer, Inventory, Invoice, Order, dll)
│   ├── app/Http/Controllers/  # API Controllers (Auth, Dashboard, Orders, dll)
│   ├── database/migrations/   # Skema DB (termasuk Spatie Permissions & Workspace)
│   └── routes/api.php         # Rute API (menggunakan middleware Sanctum & Workspace)
│
├── nadi_mobile/               # 📱 Flutter Mobile App (Riverpod)
│   ├── lib/core/              # Konfigurasi inti (Theme, Colors, Dio Network, Router)
│   ├── lib/features/          # Modul Fitur (Feature-First Architecture):
│   │   ├── auth/              # Login, Register, Workspace Switch
│   │   ├── dashboard/         # Vitals (Omzet, Tasks), Activity Feed
│   │   ├── customers/         # CRM & Timeline Pelanggan
│   │   ├── inventory/         # Manajemen Stok
│   │   ├── invoices/          # Tagihan & PDF Generation
│   │   ├── menu/              # Daftar Produk/Menu
│   │   ├── notes/             # Catatan Ekstra
│   │   ├── orders/            # Sistem Pesanan (POS)
│   │   └── tasks/             # Manajemen Tugas (To-Do List)
│   └── pubspec.yaml           # Dependencies (Dio, GoRouter, Riverpod)
│
└── awesome-design-md/         # 🎨 Panduan Desain Eksternal (Blueprint)
    └── design-md/stripe/      # Aturan UI/UX Stripe yang diadaptasi oleh NADI
```

---

## ✨ Status Implementasi Saat Ini

Berikut adalah apa yang sudah berjalan dan diimplementasikan di dalam proyek ini:

1. **🎨 Stripe-Inspired Design System (Selesai):**
   - Menggunakan warna dasar `Indigo` (#533AFD) dan latar gelap `Zinc 950` (#09090B).
   - Penggunaan *Pill-shaped buttons* dan tipografi rapat (negative letter-spacing).
2. **🔌 Konektivitas Backend-Frontend (Tersambung):**
   - API endpoints di Flutter (`api_endpoints.dart`) sudah 100% selaras dengan rute Laravel (`api.php`).
   - Klien HTTP (Dio) menargetkan port `8000` (standar Laravel).
3. **🔐 Multi-Tenancy & RBAC (Proses Audit/Refactor):**
   - Backend menggunakan `spatie/laravel-permission` untuk *Role-Based Access Control*.
   - **Tingkat Akses (Lapis 2 - Toko/Workspace):**
     - **Owner:** Akses penuh untuk manajemen tagihan langganan dan pengaturan toko.
     - **Manager:** Fokus manajemen produk, laporan keuangan, dan pegawai.
     - **Cashier/Staff:** Akses transaksi penjualan, tidak bisa melihat statistik keseluruhan.
   - Saat ini sedang dalam tahap *refactor* agar semua *controller* mengambil data berdasarkan identitas Toko (`workspace_id`), bukan Pengguna pembuat (`user_id`).

---

## 🚀 Panduan Instalasi (Development)

### 1. Menjalankan Backend API (Terminal 1)
```bash
cd nadi_backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate:fresh --seed
php artisan serve --port=8000
```
*(Backend berjalan di `http://127.0.0.1:8000`)*

### 2. Menjalankan Aplikasi Mobile (Terminal 2)
```bash
cd nadi_mobile
flutter pub get
flutter run -d windows  # Mode Desktop (Rekomendasi untuk Development)
```

---

<div align="center">
  <i>Built with ✨ for Indonesian UMKM</i><br><br>
</div>
