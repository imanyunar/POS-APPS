# Agentic Plan — Aplikasi Kasir Mobile

## Ringkasan Proyek

Aplikasi kasir mobile cross-platform (Flutter atau React Native) untuk UMKM Indonesia, fleksibel dari warung kecil hingga multi-outlet. Fokus pada tiga modul utama: transaksi & pembayaran, manajemen stok/inventori, dan laporan & analitik. Backend menggunakan Laravel 11 dan dapat diintegrasikan langsung ke ekosistem **NADI Business OS**.

---

## Tujuan & Batasan

### Tujuan
- Menghasilkan aplikasi kasir yang dapat berjalan di Android dan iOS dari satu codebase
- Mendukung alur transaksi cepat (scan → keranjang → bayar → struk) tanpa hambatan UX
- Menyediakan manajemen stok real-time dengan notifikasi stok menipis
- Menghasilkan laporan penjualan yang actionable untuk pemilik UMKM
- Dapat digunakan secara standalone maupun terintegrasi dengan NADI Business OS via `workspace_id`

### Batasan (Fase Awal)
- Tidak ada fitur multi-cabang di fase MVP (direncanakan fase 4)
- Offline mode ditargetkan fase 4, bukan MVP
- Fitur loyalty/membership pelanggan tidak masuk scope awal
- Akuntansi lanjutan (neraca, jurnal) di luar scope — fokus pada laba rugi sederhana

---

## Arsitektur Sistem

### Stack Teknologi

| Layer | Pilihan Utama | Alternatif |
|---|---|---|
| Mobile | Flutter (Dart) | React Native (TypeScript) |
| Backend | Laravel 11 | — |
| Database | MySQL / PostgreSQL | SQLite (offline lokal) |
| Cache | Redis | — |
| Payment | Midtrans | Xendit |
| Print | Bluetooth thermal (ESC/POS) | — |
| Push notif | Firebase FCM | — |
| Storage | S3-compatible (foto produk) | Cloudflare R2 |
| State management | Riverpod (Flutter) / Zustand (RN) | — |

### Keputusan Framework

**Rekomendasi: Flutter**
- Performa rendering native tanpa bridge overhead
- Kamera barcode lebih stabil via `mobile_scanner`
- UI kasir yang responsif dan konsisten di Android & iOS
- Cocok untuk jangka panjang jika NADI OS ingin punya design system sendiri

**Gunakan React Native jika:** timeline sangat ketat dan tim sudah familiar dengan React/TypeScript dari proyek VMM RME atau Nawa Promosindo.

---

## Struktur Modul

### Modul 1 — Transaksi & Pembayaran

**Alur utama:**
```
Kasir buka sesi
  → Scan barcode / cari produk manual
  → Tambah ke keranjang (ubah qty, tambah diskon item)
  → Pilih metode bayar (Cash / QRIS / Transfer)
  → Proses pembayaran
  → Generate struk (print Bluetooth / kirim WhatsApp)
  → Stok otomatis berkurang
  → Catat transaksi ke database
```

**Fitur detail:**
- Scan barcode via kamera (paket: `mobile_scanner` / `react-native-camera`)
- Keranjang: add/remove item, ubah qty, diskon per item atau total
- Metode bayar: cash (hitung kembalian), QRIS via Midtrans, kartu debit/kredit
- Struk digital: PDF atau WhatsApp deep link
- Struk fisik: Bluetooth ESC/POS printer
- Retur/refund transaksi dengan alasan
- Hold transaksi (parkir order)

**API endpoints (Laravel):**
```
POST   /api/transactions          — buat transaksi baru
GET    /api/transactions          — riwayat transaksi (filter: tanggal, kasir)
GET    /api/transactions/{id}     — detail transaksi
POST   /api/transactions/{id}/refund  — proses retur
GET    /api/products/search       — cari produk (query, barcode)
```

---

### Modul 2 — Manajemen Stok & Inventori

**Alur utama:**
```
Input produk baru
  → Isi nama, SKU, harga jual, HPP, stok awal, foto
  → Tentukan kategori & varian (opsional)
  → Set batas stok minimum (trigger alert)
  → Produk aktif di kasir
```

**Fitur detail:**
- CRUD produk: nama, SKU/barcode, harga jual, HPP, satuan, foto
- Kategori produk (hierarki 1 level)
- Varian produk: ukuran, warna, rasa (dengan stok terpisah per varian)
- Alert stok menipis: push notification via FCM saat stok ≤ minimum
- Stock opname: hitung fisik, bandingkan sistem, submit adjustment
- Riwayat mutasi stok: log semua in/out dengan timestamp & alasan
- Import produk via CSV (bulk upload)

**API endpoints (Laravel):**
```
GET    /api/products              — list produk (filter: kategori, stok rendah)
POST   /api/products              — tambah produk
PUT    /api/products/{id}         — update produk
DELETE /api/products/{id}         — hapus / nonaktifkan produk
GET    /api/products/{id}/history — riwayat mutasi stok
POST   /api/stock/adjustment      — stock opname adjustment
POST   /api/stock/import          — import CSV
```

---

### Modul 3 — Laporan & Analitik

**Laporan yang tersedia:**

| Laporan | Isi | Periode |
|---|---|---|
| Ringkasan harian | Total omzet, jumlah transaksi, rata-rata transaksi | Hari ini / kemarin |
| Produk terlaris | Ranking berdasarkan qty terjual atau omzet | Bebas |
| Laba rugi sederhana | Pendapatan − HPP = laba kotor | Mingguan / bulanan |
| Performa kasir | Omzet per kasir, jumlah transaksi | Harian / bulanan |
| Stok kritis | Produk di bawah minimum stok | Real-time |

**Fitur detail:**
- Dashboard grafik (bar chart omzet per hari, pie chart kategori produk)
- Filter periode: hari ini, 7 hari, 30 hari, custom range
- Export laporan ke PDF dan Excel
- Share laporan via WhatsApp / email

**API endpoints (Laravel):**
```
GET    /api/reports/summary       — ringkasan omzet (periode)
GET    /api/reports/top-products  — produk terlaris
GET    /api/reports/profit-loss   — laba rugi sederhana
GET    /api/reports/cashier       — performa per kasir
GET    /api/reports/export        — download PDF / Excel
```

---

## Database Schema (Ringkasan)

```sql
workspaces          — id, name, owner_id, plan, created_at
users               — id, workspace_id, name, email, role (owner|cashier)
products            — id, workspace_id, sku, name, category_id, price, cost_price,
                      stock, min_stock, unit, image_url, is_active
product_variants    — id, product_id, name, sku, price, stock
categories          — id, workspace_id, name, parent_id
transactions        — id, workspace_id, cashier_id, total, discount, tax,
                      payment_method, status, created_at
transaction_items   — id, transaction_id, product_id, variant_id, qty, price, discount
stock_movements     — id, workspace_id, product_id, type (sale|adjustment|return),
                      qty_change, qty_after, note, created_at
```

> **Catatan multi-tenancy:** Semua tabel utama menggunakan `workspace_id` sebagai filter,
> konsisten dengan refactor NADI Business OS yang sedang berjalan.

---

## Navigasi & Screen Map

```
App
├── Auth
│   ├── Login screen
│   └── PIN lock (re-auth cepat)
│
├── Kasir (tab utama)
│   ├── POS screen (keranjang + produk grid)
│   ├── Pembayaran screen
│   └── Struk screen
│
├── Produk & Stok
│   ├── List produk
│   ├── Detail / edit produk
│   ├── Tambah produk
│   ├── Kategori
│   └── Stock opname
│
├── Transaksi
│   ├── Riwayat transaksi
│   └── Detail transaksi (+ retur)
│
├── Laporan
│   ├── Dashboard ringkasan
│   ├── Laporan produk
│   ├── Laporan laba rugi
│   └── Export
│
└── Pengaturan
    ├── Profil toko
    ├── Kelola kasir (user)
    ├── Printer Bluetooth
    └── Integrasi NADI OS
```

---

## Fase Pengembangan

### Fase 1 — MVP (4–6 minggu)
**Target:** Bisa dipakai kasir warung/toko kecil

- [ ] Setup project Flutter/RN + repository + CI/CD dasar
- [ ] Auth: login email+password, role owner & kasir
- [ ] CRUD produk (tanpa varian, tanpa foto dulu)
- [ ] POS screen: cari produk manual, keranjang, hitung total
- [ ] Pembayaran cash (hitung kembalian)
- [ ] Catat transaksi ke database
- [ ] Stok otomatis berkurang setelah transaksi
- [ ] Riwayat transaksi sederhana
- [ ] Deploy backend ke staging

**Deliverable:** APK beta untuk internal testing

---

### Fase 2 — Stok & Pembayaran (3–4 minggu)
**Target:** Siap untuk UMKM menengah

- [ ] Scan barcode via kamera
- [ ] Foto produk (upload ke cloud storage)
- [ ] Kategori produk
- [ ] Varian produk (ukuran/warna)
- [ ] Alert stok menipis (FCM)
- [ ] Integrasi QRIS via Midtrans
- [ ] Struk: print Bluetooth thermal
- [ ] Struk digital: WhatsApp share
- [ ] Retur/refund transaksi
- [ ] Import produk via CSV

**Deliverable:** APK untuk pilot tester (5–10 toko)

---

### Fase 3 — Laporan & Multi-user (3–4 minggu)
**Target:** Pemilik toko bisa monitor bisnis

- [ ] Dashboard laporan dengan grafik
- [ ] Laporan produk terlaris
- [ ] Laporan laba rugi sederhana (butuh field HPP)
- [ ] Filter periode laporan
- [ ] Export PDF & Excel
- [ ] Manajemen kasir (tambah, nonaktifkan, reset PIN)
- [ ] Laporan performa per kasir
- [ ] Stock opname
- [ ] Riwayat mutasi stok

**Deliverable:** Release ke Play Store (early access)

---

### Fase 4 — Polish & Scale (2–3 minggu)
**Target:** Production-ready, skala bebas

- [ ] Offline mode: SQLite lokal + background sync saat online
- [ ] Multi-outlet: pilih outlet saat login
- [ ] Diskon: per item, per transaksi, promo waktu terbatas
- [ ] Integrasi penuh NADI Business OS (SSO via workspace)
- [ ] Performance profiling & optimasi query N+1
- [ ] End-to-end testing (Detox / Maestro)
- [ ] Publish iOS (App Store)
- [ ] Monitoring error (Sentry)

**Deliverable:** v1.0 production release

---

## Konvensi Kode

### Struktur Folder (Flutter)
```
lib/
├── core/
│   ├── api/          — HTTP client, interceptors, endpoint constants
│   ├── models/       — data models + JSON serialization
│   ├── services/     — business logic (auth, cart, print, payment)
│   └── utils/        — formatter, validator, helper
├── features/
│   ├── auth/
│   ├── pos/          — POS screen, cart, payment
│   ├── products/     — CRUD produk, stok
│   ├── transactions/ — riwayat, detail, retur
│   └── reports/      — dashboard, laporan, export
├── shared/
│   ├── widgets/      — komponen reusable
│   └── theme/        — warna, typography, spacing
└── main.dart
```

### Naming & Style
- Model: `PascalCase` — `TransactionItem`, `ProductVariant`
- Endpoint: `snake_case` — `/api/stock_movements`
- File Flutter: `snake_case` — `pos_screen.dart`
- Semua response API: JSON dengan `snake_case` key
- Tanggal/waktu: ISO 8601 (`2025-06-09T14:30:00+07:00`)
- Mata uang: integer (rupiah tanpa desimal) — `150000` bukan `150000.00`

---

## Integrasi NADI Business OS

Karena backend NADI OS sudah menggunakan Laravel 11 dengan multi-tenancy berbasis `workspace_id`, aplikasi kasir ini dapat diintegrasikan dengan cara:

1. **Shared authentication** — gunakan token API yang sama, tambahkan claim `workspace_id` di JWT
2. **Shared database** — tabel `products`, `transactions`, `stock_movements` sudah kompatibel dengan schema di atas
3. **Endpoint prefix** — gunakan prefix `/api/pos/` untuk membedakan dari modul NADI lainnya
4. **Refactor filter** — konsisten dengan task yang sedang berjalan: semua query menggunakan `workspace_id`, bukan `user_id`

Dengan pendekatan ini, pemilik UMKM yang sudah pakai NADI OS cukup install aplikasi kasir dan login dengan akun yang sama — data langsung tersinkron.

---

## Risiko & Mitigasi

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Koneksi internet tidak stabil | Transaksi gagal tersimpan | Offline mode (fase 4) + retry queue |
| Printer Bluetooth tidak kompatibel | Struk tidak bisa dicetak | Test dengan 3+ model printer populer; fallback ke PDF |
| QRIS timeout dari Midtrans | Pembayaran menggantung | Polling status + timeout 30 detik + fallback cash |
| Stok race condition (multi-kasir) | Stok minus | Pessimistic lock di database saat update stok |
| Ukuran APK besar | Instalasi lambat | Code splitting, lazy load gambar, target < 30MB |

---

## Referensi

- [Midtrans Snap API](https://docs.midtrans.com/reference/backend-integration)
- [ESC/POS Bluetooth Flutter](https://pub.dev/packages/esc_pos_bluetooth)
- [mobile_scanner (barcode)](https://pub.dev/packages/mobile_scanner)
- [Riverpod state management](https://riverpod.dev)
- NADI Business OS — internal repo (workspace multi-tenancy branch)