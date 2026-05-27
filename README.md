<div align="center">
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=600&size=30&pause=1000&color=F75C03&center=true&vCenter=true&width=600&lines=Serve+Operating+System;Empowering+UMKM+Globally;Point+of+Sale+%2B+ERP;Smart+Business+Management" alt="Typing SVG" />
</div>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white" />
  <img src="https://img.shields.io/badge/Riverpod-00599C?style=for-the-badge&logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white" />
  
</p>

---

## 🚀 Apa itu Serve OS?

**Serve** (sebelumnya Nadi) adalah ekosistem *Operating System* terpadu untuk UMKM (Usaha Mikro, Kecil, dan Menengah). Menggabungkan kekuatan **Point of Sale (POS)** yang responsif dengan **Enterprise Resource Planning (ERP)** ringan, Serve dirancang untuk membuat manajemen bisnis kuliner dan retail menjadi sangat mudah dan elegan.

Dibuat dengan memprioritaskan performa tinggi, UI/UX modern (Glassmorphism & Micro-animations), serta fleksibilitas pengelolaan secara *real-time*.

---

## ✨ Fitur Utama (Features)

<details>
<summary><b>👨‍👩‍👧‍👦 Manajemen Pelanggan (CRM)</b></summary>
Pencatatan database pelanggan, riwayat transaksi, dan pelacakan hutang piutang (Outstanding Debt).
</details>

<details>
<summary><b>🍽️ Master Data Menu</b></summary>
Kelola kategori, harga, estimasi waktu masak, dan sinkronisasi otomatis dengan batas stok minimum inventaris.
</details>

<details>
<summary><b>📦 Manajemen Inventaris Real-Time</b></summary>
Pencatatan SKU, harga modal, tracking stok, dan *alert* visual (Merah/Kuning/Hijau) saat stok menipis atau habis.
</details>

<details>
<summary><b>🛒 Point of Sale (Kasir Pintar)</b></summary>
Proses pemesanan sangat cepat, dukungan tipe pesanan (Dine-in / Takeaway), kalkulasi subtotal, dan sinkronisasi layar dapur (Kitchen Display/Status Tracking).
</details>

<details>
<summary><b>🧾 Invoice Builder</b></summary>
Pembuatan tagihan profesional secara dinamis dengan kustomisasi pajak, tenggat waktu (Due Date), dan status pembayaran instan (Mark as Paid).
</details>

<details>
<summary><b>📈 Dashboard Analytics & Timeline</b></summary>
Layar pemantauan metrik finansial harian dan *log timeline* historis untuk audit aktivitas operasional.
</details>

---

## 🏗️ Arsitektur Aplikasi

Project ini menggunakan arsitektur **Client-Server** yang dipisah menjadi dua *repository* utama dalam satu *workspace*:

1. **`nadi_mobile/` (Frontend - Flutter)**
   - **Layer Architecture:** Domain-Driven Design (Presentation, Domain, Data).
   - **State Management:** Riverpod (`AsyncNotifier` & `FutureProvider`).
   - **Routing:** GoRouter (Support Deep Linking & Nested Navigation).
   - **Theming:** Custom Theme Data (Sleek UI, Base Colors: Indigo & Tangerine).

2. **`nadi_backend/` (Backend - Laravel 11)**
   - **Framework:** Laravel 11.x (PHP 8.2+).
   - **API Standards:** RESTful JSON API.
   - **Database:** SQLite (Bisa diskalakan ke MySQL/PostgreSQL).

---

## ⚙️ Panduan Instalasi (Installation)

### 1. Menjalankan Backend (Laravel)
```bash
cd nadi_backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate:fresh --seed
php artisan serve
```
*API akan berjalan di: `http://127.0.0.1:8000`*

### 2. Menjalankan Mobile App (Flutter)
Buka terminal baru:
```bash
cd nadi_mobile
flutter pub get
flutter run -d windows  # Atau gunakan emulator Android / Chrome
```

---

## 🎨 Design Philosophy
Aplikasi ini tidak menggunakan Tailwind. Desain UI murni dibuat dari *scratch* (Vanilla Flutter Widgets) untuk memastikan:
- **Rich Aesthetics:** Transisi mulus dan palet warna yang premium (WaroengColors / ServeColors).
- **Dynamic UX:** Setiap tombol dan *card* memiliki *visual feedback* yang responsif.
- **Scalability:** Penggunaan `const` dan *reusable custom widgets* (`ServeCard`, `ServeBadge`, `ServeEmptyState`).

---

<div align="center">
  <i>Build by Vermont Automated Digital</i><br><br>
  <img src="https://capsule-render.vercel.app/api?type=waving&color=F75C03&height=100&section=footer" />
</div>
