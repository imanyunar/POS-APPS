<div align="center">
  <img src="https://readme-typing-svg.demolab.com?font=Outfit&weight=600&size=30&pause=1000&color=F75C03&center=true&vCenter=true&width=600&lines=Serve+(Nadi)+OS;The+Third+Space+for+UMKM;Calm,+Premium+Workspace;Point+of+Sale+%2B+ERP" alt="Typing SVG" />
</div>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Laravel_11-FF2D20?style=for-the-badge&logo=laravel&logoColor=white" />
  <img src="https://img.shields.io/badge/Riverpod-00599C?style=for-the-badge&logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white" />
</p>

---

## 🌌 Product Vision: The Third Space

Usaha Mikro Kecil dan Menengah (UMKM) Indonesia menyumbang 60% PDB, namun software yang ada terbagi dua sisi ekstrem: **Aplikasi POS Tradisional** yang terlalu kaku dan **Enterprise ERP** yang sangat mahal & rumit.

**Serve (Project NADI)** hadir sebagai *The Daily Business Operating System*. Berbeda dengan aplikasi kasir biasa, Serve menawarkan *workspace* yang tenang, elegan, dan terpadu—terinspirasi dari UX aplikasi modern seperti Linear, Stripe, dan Notion.

> *"Saya tidak butuh sistem kasir yang rumit; saya butuh tahu pesanan apa yang pending, tugas hari ini apa, dan siapa pelanggan yang belum bayar hutangnya."*

---

## 🎯 Target Persona (Indonesian Context)

<details>
<summary><b>🛍️ Rian (31) - The Modern Instagram Merchant</b></summary>
Mengandalkan orderan kustom via WhatsApp/DM. <b>Pain Point:</b> Sulit melacak status orderan kustom & pembayaran manual. <b>Solusi Serve:</b> Kanban-Style Order Board & Instant PDF Invoice via WA.
</details>

<details>
<summary><b>🍲 Ibu Dewi (45) - Premium Home-Catering</b></summary>
Melayani katering event & korporat mingguan. <b>Pain Point:</b> Lupa alergi pelanggan, catatan khusus, dan menagih hutang invoice bulanan. <b>Solusi Serve:</b> Customer Activity Timeline & Unpaid Invoices Alerts.
</details>

---

## ✨ Fitur & UX Model (Low-Cognitive Load)

Serve membagi kehidupan bisnis ke dalam 3 pilar: **Awareness** (Dashboard), **Action** (Orders/Invoices), dan **Context** (Customers/Inventory).

- **📊 Dashboard (Today's Pulse):** Ringkasan metrik bersih (Outfit font) tanpa chart rumit. Terdapat *Activity Timeline Feed* vertikal.
- **🤝 Customer CRM:** Timeline aktivitas pelanggan terpusat (Order -> Invoice -> Notes).
- **🛒 Orders Pipeline (Workboard):** Swipe layout Kanban (Pending ➔ Processing ➔ Completed) dengan *haptic feedback*.
- **🧾 Invoice Generator:** Buat tagihan layaknya Stripe receipt, otomatis menyediakan format *copy-paste* WhatsApp polite reminder.
- **✅ Tasks & Reminders:** *Micro-interaction checkboxes* yang memuaskan untuk *to-do list* harian dapur/toko.
- **📦 Lightweight Inventory:** *Vibrant Danger Badges* untuk status stok (Merah/Kuning/Hijau).

---

## 🏗️ Tech Stack & Arsitektur

Project ini menggunakan arsitektur **Client-Server** dalam satu workspace:

### 📱 Frontend: `nadi_mobile/` (Flutter)
- **Architecture:** Feature-First / Domain-Driven Design (Presentation, Domain, Data).
- **State Management:** Riverpod (`AsyncNotifier` & `FutureProvider`).
- **Routing:** GoRouter (ShellRoute bottom navigation).
- **Design System:** Calm & Premium UI (Zinc Dark, Slate Gray, Indigo Accent) tanpa Tailwind/UI Framework pihak ketiga. Mengandalkan `ServeCard`, `ServeBadge`.

### ⚙️ Backend: `nadi_backend/` (Laravel 11)
- **Framework:** Laravel 11.x + Sanctum (Stateful API token authorization).
- **Response Format:** Modern JSON Envelope Standard (`success`, `data`, `meta`).
- **Database:** SQLite/PostgreSQL dengan optimasi B-Tree & GIN Indexes (untuk struktur JSONB di activity logs).

---

## 🚀 Panduan Instalasi (Installation)

### 1. Menjalankan Backend API (Terminal 1)
```bash
cd nadi_backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate:fresh --seed
php artisan serve
```
*(Backend berjalan di `http://127.0.0.1:8000`)*

### 2. Menjalankan Aplikasi Mobile (Terminal 2)
```bash
cd nadi_mobile
flutter pub get
flutter run -d windows  # Mode Desktop (Rekomendasi untuk Development)
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
