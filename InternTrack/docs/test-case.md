# Test Case InternTrack

| No | Fitur | Skenario | Hasil yang diharapkan |
|---:|---|---|---|
| 1 | Login | Username dan password benar | Berhasil masuk ke dashboard sesuai peran |
| 2 | Login | Password salah | Login ditolak dan pesan kesalahan tampil |
| 3 | Login | Username kosong | Validasi browser menolak pengiriman |
| 4 | Siswa | Tambah data lengkap | Data tersimpan di database |
| 5 | Siswa | NIS kosong | Data ditolak dan validasi tampil |
| 6 | Siswa | NIS duplikat | Data ditolak |
| 7 | Siswa | Cari berdasarkan nama/NIS | Data yang cocok ditampilkan |
| 8 | Penempatan | Tanggal selesai sebelum tanggal mulai | Data ditolak |
| 9 | Jurnal | Tanggal atau kegiatan kosong | Data ditolak |
| 10 | Absensi | Pilih status Hadir | Data absensi tersimpan |
| 11 | Absensi | Input absensi siswa dan tanggal sama | Data lama diperbarui, tidak membuat duplikat |
| 12 | Monitoring | Nilai di atas 100 | Data ditolak |
| 13 | Laporan | Cetak laporan ke PDF | Dialog cetak browser muncul |
| 14 | Hak akses | Siswa membuka URL admin | Akses ditolak/dialihkan |
| 15 | Logout | Pengguna klik keluar | Session berakhir dan kembali ke login |

## Pseudocode utama

### Login
```text
MULAI
Baca username dan password
JIKA salah satu kosong, tampilkan validasi
JIKA tidak, cari akun berdasarkan username
JIKA akun ditemukan dan password cocok:
    simpan identitas akun ke session
    arahkan ke dashboard
JIKA TIDAK:
    tampilkan "Username atau password salah"
SELESAI
```

### Input jurnal
```text
MULAI
Periksa session pengguna
Jika peran siswa, gunakan ID siswa dari session
Baca tanggal dan kegiatan
Jika tanggal atau kegiatan kosong, tampilkan validasi
Jika lengkap, simpan jurnal ke database
Tampilkan pesan berhasil
SELESAI
```

### Status berdasarkan persentase kehadiran
```text
Jika persentase >= 90: Sangat Baik
Jika persentase >= 75: Baik
Jika persentase >= 60: Perlu Perhatian
Selain itu: Perlu Pembinaan
```
