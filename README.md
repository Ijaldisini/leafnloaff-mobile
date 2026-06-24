# Leaf N Loaff Mobile Application

Leaf N Loaff adalah aplikasi mobile berbasis Flutter yang dirancang untuk memfasilitasi pemesanan produk bakery dan cafe. Aplikasi ini memiliki dua antarmuka pengguna yang terintegrasi dalam satu sistem, yaitu untuk Admin (pengelola toko) dan Customer (pelanggan). Proyek ini dibangun dengan menerapkan arsitektur MVVM (Model-View-ViewModel) untuk memastikan kode terstruktur dengan baik dan mudah dikembangkan.

## Kredensial Pengujian (Testing Credentials)

Gunakan akun berikut untuk masuk ke dalam aplikasi dan menguji fungsionalitas sistem. Pastikan database backend Anda telah diinisialisasi dengan data berikut:

### Akun Admin
* **Email / Username**: leafnloaf@gmail.com
* **Password**: calonsiio

### Akun Customer
* **Email / Username**: testing@gmail.com
* **Password**: 123123

## Fitur Utama

Aplikasi ini dibagi menjadi dua modul besar yang menyesuaikan peran pengguna yang sedang masuk.

### Fitur Customer
* **Autentikasi Pengguna**: Login, registrasi akun baru, dan verifikasi OTP.
* **Katalog Menu**: Eksplorasi produk, melihat detail menu, dan membaca ulasan produk.
* **Keranjang Belanja & Checkout**: Penambahan item ke keranjang dan proses pembuatan pesanan.
* **Integrasi Pembayaran**: Proses transaksi aman yang terintegrasi dengan Midtrans Payment Gateway.
* **Manajemen Alamat**: Penambahan dan pemilihan alamat pengiriman menggunakan integrasi Maps.
* **Voucher & Diskon**: Pemilihan dan penggunaan kode voucher untuk potongan harga.
* **Riwayat Pesanan**: Pelacakan status pesanan aktif dan riwayat transaksi sebelumnya.
* **Sistem Ulasan**: Penulisan ulasan dan pemberian rating untuk pesanan yang telah selesai.
* **Manajemen Profil**: Pengeditan data profil pengguna.

### Fitur Admin
* **Dashboard Statistik**: Tinjauan performa penjualan dan pesanan secara langsung.
* **Manajemen Menu**: Operasi CRUD (Create, Read, Update, Delete) untuk produk, lengkap dengan fitur pratinjau.
* **Manajemen Pesanan**: Pemantauan pesanan masuk, pembaruan status pesanan, dan pengecekan detail transaksi.
* **Manajemen Voucher**: Pembuatan dan pengaturan masa berlaku voucher diskon.
* **Manajemen Notifikasi**: Pengiriman pembaruan atau promosi langsung kepada pelanggan.
* **Ulasan & Rating**: Pemantauan ulasan yang diberikan oleh pelanggan terhadap produk.
* **Laporan Ekspor PDF**: Pembuatan dan pengunduhan laporan penjualan atau pesanan dalam format PDF.

## Struktur Direktori Proyek

Proyek ini menggunakan pola desain MVVM. Berikut adalah penjelasan struktur direktori utama pada folder `lib/`:

```text
lib/
|-- models/                  # Representasi data (Address, Cart, Menu, Order, User, Voucher, dll.)
|-- services/                # Lapisan komunikasi dengan API dan SDK pihak ketiga
|   |-- admin/               # Layanan spesifik untuk mengelola data admin
|   |-- cust/                # Layanan spesifik untuk mengelola data pelanggan
|   |-- maps/                # Layanan integrasi peta dan lokasi
|   |-- payments/            # Layanan gateway pembayaran (Midtrans)
|   |-- pdf/                 # Layanan generator laporan PDF
|   `-- auth_service.dart    # Layanan autentikasi
|-- utils/                   # Fungsi utilitas global (Image picker, Helper notifikasi)
|-- viewmodels/              # Logika state management (MVVM)
|   |-- admin/               # Logika antarmuka untuk fitur admin
|   `-- cust/                # Logika antarmuka untuk fitur pelanggan
|-- views/                   # Layar antarmuka pengguna (UI)
|   |-- admin/               # Halaman dasbor, manajemen pesanan, menu admin
|   `-- cust/                # Halaman beranda, keranjang, checkout pelanggan
|-- widgets/                 # Komponen UI kustom yang dapat digunakan kembali
`-- main.dart                # Entry point utama aplikasi
```

## Prasyarat Instalasi

Sebelum memulai pengembangan, pastikan Anda telah memasang dependensi berikut di perangkat Anda:

1. Flutter SDK (Versi stabil terbaru disarankan)
2. Dart SDK
3. Android Studio atau Visual Studio Code
4. Emulator Android / Simulator iOS atau perangkat fisik

## Cara Menjalankan Aplikasi

Ikuti langkah-langkah di bawah ini untuk menjalankan proyek di komputer lokal Anda:

1. Kloning Repositori

```
bash

git clone [https://github.com/ijaldisini/leafnloaff-mobile.git](https://github.com/ijaldisini/leafnloaff-mobile.git)
cd leafnloaff-mobile
```

2. Unduh Dependensi Package

Jalankan perintah berikut untuk mengunduh semua pustaka yang digunakan dalam proyek:

```
bash

flutter pub get
```

3. Konfigurasi Pihak Ketiga (Penting)

* Midtrans: Konfigurasikan Client Key pada lib/services/payments/midtrans_service.dart.
* Google Maps: Masukkan API Key Anda pada android/app/src/main/AndroidManifest.xml dan berkas konfigurasi iOS.
* Backend API: Sesuaikan base URL API pada direktori services/ dengan server lokal atau produksi Anda.

4. Kompilasi dan Jalankan

Pilih perangkat target (emulator atau fisik) dan jalankan aplikasi dengan perintah:

```
bash

flutter run
```

## Teknologi dan Pustaka Utama

Proyek ini sangat bergantung pada beberapa integrasi eksternal untuk menjalankan fiturnya secara optimal:

* **State Management**: Digunakan dalam folder viewmodels/ untuk menjembatani data dan UI.
* **Midtrans**: Untuk pemrosesan pembayaran digital di sisi pelanggan.
* **Google Maps Flutter**: Untuk fungsionalitas penentuan titik alamat pengiriman.
* **PDF / Printing**: Terletak di layanan pdf_export_service.dart untuk membuat cetak laporan pesanan.
* **Image Picker**: Digunakan untuk mengunggah gambar menu atau mengubah foto profil.
