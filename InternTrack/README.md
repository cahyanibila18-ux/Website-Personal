# InternTrack — Sistem Monitoring Kegiatan PKL

Aplikasi web PHP Native + MySQL/MariaDB untuk tugas UKK RPL.

## Persyaratan
- XAMPP (Apache + MySQL)
- PHP 8.0+ direkomendasikan
- MySQL/MariaDB

## Cara instalasi
1. Ekstrak folder `InternTrack` ke `C:\xampp\htdocs\`.
2. Jalankan Apache dan MySQL melalui XAMPP Control Panel.
3. Buka `http://localhost/phpmyadmin`.
4. Pilih tab **Import**, lalu impor `InternTrack/database/interntrack.sql`.
5. Buka `http://localhost/InternTrack/`.
6. Login menggunakan akun demo di bawah.

## Akun demo
- Admin: `admin` / `admin123`
- Siswa: `siswa001` / `siswa123`
- Siswa tambahan: `siswa002` / `siswa123`

**Penting:** akun demo sudah disiapkan di SQL. Jika password tidak cocok karena hash tidak terbaca pada konfigurasi PHP tertentu, buka `http://localhost/InternTrack/setup_admin.php` satu kali untuk mengatur ulang password demo, lalu segera hapus file `setup_admin.php`. Ubah password demo melalui menu Profil sebelum aplikasi digunakan untuk data nyata.

## Struktur folder
```text
InternTrack/
├── assets/style.css
├── auth/                 # disiapkan untuk pengembangan autentikasi lanjutan
├── config/
│   ├── app.php
│   └── koneksi.php
├── admin/
│   ├── siswa.php
│   ├── perusahaan.php
│   ├── pembimbing.php
│   ├── penempatan.php
│   └── monitoring.php
├── database/
│   ├── interntrack.sql
│   └── reset_password.sql
├── laporan/index.php
├── partials/header.php
├── partials/footer.php
├── index.php
├── dashboard.php
├── jurnal.php
├── absensi.php
├── profil.php
└── logout.php
```

## Fitur
- Login berbasis peran admin dan siswa.
- Dashboard dinamis mengambil angka dari database.
- CRUD data siswa, perusahaan, pembimbing, penempatan, jurnal, dan monitoring.
- Input absensi dengan status Hadir, Izin, Sakit, Alpa dan rekap persentase.
- Siswa hanya melihat dan mengelola jurnal/absensinya sendiri.
- Pencarian data serta filter kelas, status penempatan, dan tanggal absensi.
- Laporan data siswa PKL, kehadiran, dan monitoring; dapat dicetak atau disimpan sebagai PDF.
- Validasi input, prepared statements, password hashing, token CSRF, dan session login.

## Catatan untuk pengembangan
- Data dummy awal sengaja disediakan untuk demonstrasi.
- Untuk data nyata, gunakan password kuat, HTTPS, backup database, dan pembatasan akses sesuai kebutuhan sekolah.
- Penghitungan status PKL pada laporan kehadiran mengikuti ketentuan soal: >=90% Sangat Baik, 75–89% Baik, 60–74% Perlu Perhatian, <60% Perlu Pembinaan.
