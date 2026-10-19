CREATE DATABASE IF NOT EXISTS interntrack CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE interntrack;
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS monitoring;
DROP TABLE IF EXISTS absensi;
DROP TABLE IF EXISTS jurnal;
DROP TABLE IF EXISTS penempatan;
DROP TABLE IF EXISTS pembimbing;
DROP TABLE IF EXISTS perusahaan;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS siswa;
SET FOREIGN_KEY_CHECKS=1;

CREATE TABLE siswa (
 id INT AUTO_INCREMENT PRIMARY KEY,
 nis VARCHAR(30) NOT NULL UNIQUE,
 nama VARCHAR(120) NOT NULL,
 kelas VARCHAR(30) DEFAULT '',
 jurusan VARCHAR(100) DEFAULT 'Rekayasa Perangkat Lunak',
 no_hp VARCHAR(25) DEFAULT '',
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE users (
 id INT AUTO_INCREMENT PRIMARY KEY,
 nama VARCHAR(120) NOT NULL,
 username VARCHAR(60) NOT NULL UNIQUE,
 password VARCHAR(255) NOT NULL,
 role ENUM('admin','siswa') NOT NULL DEFAULT 'siswa',
 siswa_id INT NULL UNIQUE,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_users_siswa FOREIGN KEY (siswa_id) REFERENCES siswa(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE perusahaan (
 id INT AUTO_INCREMENT PRIMARY KEY,
 nama VARCHAR(150) NOT NULL,
 alamat TEXT,
 bidang VARCHAR(100),
 kontak VARCHAR(60),
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE pembimbing (
 id INT AUTO_INCREMENT PRIMARY KEY,
 nama VARCHAR(120) NOT NULL,
 nip VARCHAR(50),
 no_hp VARCHAR(25),
 email VARCHAR(120),
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE penempatan (
 id INT AUTO_INCREMENT PRIMARY KEY,
 siswa_id INT NOT NULL,
 perusahaan_id INT NOT NULL,
 pembimbing_id INT NOT NULL,
 tanggal_mulai DATE NOT NULL,
 tanggal_selesai DATE NOT NULL,
 status ENUM('Belum Mulai','Aktif','Selesai') NOT NULL DEFAULT 'Belum Mulai',
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_penempatan_siswa FOREIGN KEY (siswa_id) REFERENCES siswa(id) ON DELETE CASCADE,
 CONSTRAINT fk_penempatan_perusahaan FOREIGN KEY (perusahaan_id) REFERENCES perusahaan(id) ON DELETE RESTRICT,
 CONSTRAINT fk_penempatan_pembimbing FOREIGN KEY (pembimbing_id) REFERENCES pembimbing(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE jurnal (
 id INT AUTO_INCREMENT PRIMARY KEY,
 siswa_id INT NOT NULL,
 tanggal DATE NOT NULL,
 kegiatan TEXT NOT NULL,
 hasil TEXT,
 kendala TEXT,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_jurnal_siswa FOREIGN KEY (siswa_id) REFERENCES siswa(id) ON DELETE CASCADE,
 INDEX idx_jurnal_tanggal(tanggal)
) ENGINE=InnoDB;

CREATE TABLE absensi (
 id INT AUTO_INCREMENT PRIMARY KEY,
 siswa_id INT NOT NULL,
 tanggal DATE NOT NULL,
 status ENUM('Hadir','Izin','Sakit','Alpa') NOT NULL,
 catatan VARCHAR(255) DEFAULT '',
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_absensi_siswa FOREIGN KEY (siswa_id) REFERENCES siswa(id) ON DELETE CASCADE,
 UNIQUE KEY uniq_absensi_siswa_tanggal(siswa_id,tanggal),
 INDEX idx_absensi_tanggal(tanggal)
) ENGINE=InnoDB;

CREATE TABLE monitoring (
 id INT AUTO_INCREMENT PRIMARY KEY,
 siswa_id INT NOT NULL,
 tanggal DATE NOT NULL,
 catatan TEXT NOT NULL,
 nilai TINYINT UNSIGNED NOT NULL,
 rekomendasi TEXT,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_monitoring_siswa FOREIGN KEY (siswa_id) REFERENCES siswa(id) ON DELETE CASCADE,
 INDEX idx_monitoring_tanggal(tanggal),
 CONSTRAINT chk_nilai CHECK (nilai BETWEEN 0 AND 100)
) ENGINE=InnoDB;

INSERT INTO siswa(nis,nama,kelas,jurusan,no_hp) VALUES
('2026001','Alya Putri','XI RPL 1','Rekayasa Perangkat Lunak','081234567801'),
('2026002','Bima Pratama','XI RPL 1','Rekayasa Perangkat Lunak','081234567802'),
('2026003','Citra Lestari','XI RPL 2','Rekayasa Perangkat Lunak','081234567803'),
('2026004','Daffa Ramadhan','XI RPL 2','Rekayasa Perangkat Lunak','081234567804'),
('2026005','Nadia Safitri','XI RPL 1','Rekayasa Perangkat Lunak','081234567805');

-- Password demo: admin123 dan siswa123. Hash bcrypt di bawah dibuat untuk password tersebut.
INSERT INTO users(nama,username,password,role,siswa_id) VALUES
('Administrator','admin','$2y$12$/TkB3iJ6ZNbA5O17y3CBKOGQaGoZQdcbIVUyfT3SlLPGCVetXuNxe','admin',NULL),
('Alya Putri','siswa001','$2y$12$/T810B4/XyhFwOKIfaCINOtYLHoYBgr4HNlyWI8aLLBZchjvUH9FG','siswa',1),
('Bima Pratama','siswa002','$2y$12$/T810B4/XyhFwOKIfaCINOtYLHoYBgr4HNlyWI8aLLBZchjvUH9FG','siswa',2),
('Citra Lestari','siswa003','$2y$12$/T810B4/XyhFwOKIfaCINOtYLHoYBgr4HNlyWI8aLLBZchjvUH9FG','siswa',3);

INSERT INTO perusahaan(nama,alamat,bidang,kontak) VALUES
('PT Digital Semarang','Jl. Pemuda, Semarang','Teknologi Informasi','024-555001'),
('CV Kreatif Media','Jl. Gajahmada, Semarang','Desain dan Digital','024-555002'),
('Dinas Komunikasi dan Informatika','Semarang','Pemerintahan / IT','024-555003'),
('Studio Web Nusantara','Banyumanik, Semarang','Pengembangan Web','024-555004'),
('Techno Solusi','Tembalang, Semarang','IT Support','024-555005'),
('PT Aplikasi Maju','Semarang','Software House','024-555006'),
('Kantor Data Kita','Semarang','Pengolahan Data','024-555007'),
('Digital Karya','Semarang','Digital Marketing','024-555008'),
('Web Cerdas','Semarang','Web Development','024-555009'),
('Sistem Pintar','Semarang','Sistem Informasi','024-555010');

INSERT INTO pembimbing(nama,nip,no_hp,email) VALUES
('Agus Setiawan','198501012010011001','081200000001','agus@example.test'),
('Dewi Anggraini','198702022011012002','081200000002','dewi@example.test'),
('Rudi Hartono','198303032009011003','081200000003','rudi@example.test'),
('Siti Rahmawati','198804042012012004','081200000004','siti@example.test'),
('Bambang Wijaya','198205052008011005','081200000005','bambang@example.test'),
('Nina Kartika','198906062013012006','081200000006','nina@example.test'),
('Fajar Nugroho','198107072007011007','081200000007','fajar@example.test'),
('Lina Marlina','198908082014012008','081200000008','lina@example.test'),
('Hendra Saputra','198009092006011009','081200000009','hendra@example.test'),
('Maya Puspita','198910102015012010','081200000010','maya@example.test');

INSERT INTO penempatan(siswa_id,perusahaan_id,pembimbing_id,tanggal_mulai,tanggal_selesai,status) VALUES
(1,1,1,'2026-09-01','2026-12-01','Aktif'),
(2,2,2,'2026-09-01','2026-12-01','Aktif'),
(3,3,3,'2026-09-01','2026-12-01','Aktif'),
(4,4,4,'2026-09-01','2026-12-01','Aktif'),
(5,5,5,'2026-09-01','2026-12-01','Aktif');

INSERT INTO jurnal(siswa_id,tanggal,kegiatan,hasil,kendala) VALUES
(1,CURDATE(),'Mempelajari alur kerja dan aturan di tempat PKL','Memahami prosedur kerja','Belum ada kendala'),
(2,CURDATE(),'Membantu memperbarui konten website','Konten berhasil diperbarui','Perlu menyesuaikan gambar'),
(3,DATE_SUB(CURDATE(),INTERVAL 1 DAY),'Membuat rancangan tampilan halaman','Rancangan awal selesai','Perlu revisi warna'),
(4,DATE_SUB(CURDATE(),INTERVAL 1 DAY),'Mempelajari struktur database','Memahami tabel dasar',''),
(5,DATE_SUB(CURDATE(),INTERVAL 2 DAY),'Melakukan pengujian halaman web','Menemukan beberapa masukan','');

INSERT INTO absensi(siswa_id,tanggal,status,catatan) VALUES
(1,CURDATE(),'Hadir',''),
(2,CURDATE(),'Hadir',''),
(3,CURDATE(),'Izin','Izin keperluan keluarga'),
(4,CURDATE(),'Hadir',''),
(5,CURDATE(),'Hadir','');

INSERT INTO monitoring(siswa_id,tanggal,catatan,nilai,rekomendasi) VALUES
(1,CURDATE(),'Mampu berkomunikasi dengan baik dan menyelesaikan tugas.',88,'Pertahankan kedisiplinan dan tingkatkan dokumentasi'),
(2,CURDATE(),'Aktif belajar dan mengikuti arahan pembimbing.',82,'Latihan pengujian mandiri'),
(3,CURDATE(),'Memiliki ide desain yang baik.',78,'Tingkatkan konsistensi layout'),
(4,CURDATE(),'Memahami tugas dasar dengan cukup baik.',85,'Perbanyak latihan SQL'),
(5,CURDATE(),'Dapat menyelesaikan pekerjaan tepat waktu.',90,'Pertahankan kinerja');


-- Tambahan data dummy agar memenuhi jumlah minimum pada lembar UKK.
INSERT INTO siswa(nis,nama,kelas,jurusan,no_hp) VALUES
('2026006','Rizky Maulana','XI RPL 1','Rekayasa Perangkat Lunak','081234567806'),
('2026007','Putri Amelia','XI RPL 2','Rekayasa Perangkat Lunak','081234567807'),
('2026008','Fikri Hidayat','XI RPL 1','Rekayasa Perangkat Lunak','081234567808'),
('2026009','Intan Permata','XI RPL 2','Rekayasa Perangkat Lunak','081234567809'),
('2026010','Yoga Pratama','XI RPL 1','Rekayasa Perangkat Lunak','081234567810'),
('2026011','Nabila Zahra','XI RPL 2','Rekayasa Perangkat Lunak','081234567811'),
('2026012','Rafi Akbar','XI RPL 1','Rekayasa Perangkat Lunak','081234567812'),
('2026013','Dinda Maharani','XI RPL 2','Rekayasa Perangkat Lunak','081234567813'),
('2026014','Andi Saputra','XI RPL 1','Rekayasa Perangkat Lunak','081234567814'),
('2026015','Salsa Nirmala','XI RPL 2','Rekayasa Perangkat Lunak','081234567815'),
('2026016','Farhan Alfi','XI RPL 1','Rekayasa Perangkat Lunak','081234567816'),
('2026017','Ayu Lestari','XI RPL 2','Rekayasa Perangkat Lunak','081234567817'),
('2026018','Galih Prakoso','XI RPL 1','Rekayasa Perangkat Lunak','081234567818'),
('2026019','Mutiara Sari','XI RPL 2','Rekayasa Perangkat Lunak','081234567819'),
('2026020','Ilham Firmansyah','XI RPL 1','Rekayasa Perangkat Lunak','081234567820'),
('2026021','Vina Oktavia','XI RPL 2','Rekayasa Perangkat Lunak','081234567821'),
('2026022','Ardiansyah Putra','XI RPL 1','Rekayasa Perangkat Lunak','081234567822'),
('2026023','Laras Wulandari','XI RPL 2','Rekayasa Perangkat Lunak','081234567823'),
('2026024','Kevin Aditya','XI RPL 1','Rekayasa Perangkat Lunak','081234567824'),
('2026025','Niken Puspita','XI RPL 2','Rekayasa Perangkat Lunak','081234567825');

INSERT INTO users(nama,username,password,role,siswa_id)
SELECT nama, CONCAT('siswa',LPAD(id,3,'0')), '$2y$12$/T810B4/XyhFwOKIfaCINOtYLHoYBgr4HNlyWI8aLLBZchjvUH9FG', 'siswa', id
FROM siswa WHERE id BETWEEN 6 AND 25;

INSERT INTO penempatan(siswa_id,perusahaan_id,pembimbing_id,tanggal_mulai,tanggal_selesai,status) VALUES
(6,6,6,'2026-09-01','2026-12-01','Aktif'),
(7,7,7,'2026-09-01','2026-12-01','Aktif'),
(8,8,8,'2026-09-01','2026-12-01','Aktif'),
(9,9,9,'2026-09-01','2026-12-01','Aktif'),
(10,10,10,'2026-09-01','2026-12-01','Aktif');

INSERT INTO jurnal(siswa_id,tanggal,kegiatan,hasil,kendala) VALUES
(1,DATE_SUB(CURDATE(),INTERVAL 1 DAY),'Membuat wireframe halaman login','Wireframe selesai',''),
(2,DATE_SUB(CURDATE(),INTERVAL 2 DAY),'Menguji formulir website','Validasi berjalan',''),
(3,DATE_SUB(CURDATE(),INTERVAL 2 DAY),'Memperbaiki tata letak halaman','Tampilan lebih rapi',''),
(4,DATE_SUB(CURDATE(),INTERVAL 3 DAY),'Membuat query SELECT database','Data berhasil ditampilkan',''),
(5,DATE_SUB(CURDATE(),INTERVAL 3 DAY),'Mempelajari Git dan version control','Memahami commit dasar',''),
(6,CURDATE(),'Membuat dokumentasi pekerjaan','Dokumentasi awal selesai',''),
(7,CURDATE(),'Menguji tampilan responsif','Tampilan mobile diperiksa',''),
(8,CURDATE(),'Membuat halaman profil','Halaman profil dibuat',''),
(9,CURDATE(),'Membantu input data inventaris','Data tersimpan',''),
(10,CURDATE(),'Memeriksa tautan navigasi','Tautan berfungsi',''),
(11,CURDATE(),'Mempelajari dasar API','Memahami request dan response',''),
(12,CURDATE(),'Membuat diagram alur proses','Flowchart selesai',''),
(13,CURDATE(),'Memperbaiki validasi input','Validasi ditambahkan',''),
(14,CURDATE(),'Membuat desain tabel laporan','Desain laporan selesai',''),
(15,CURDATE(),'Menguji fitur pencarian','Pencarian sesuai kata kunci',''),
(16,CURDATE(),'Membuat halaman data','Halaman data dibuat',''),
(17,CURDATE(),'Merapikan CSS aplikasi','Style diperbarui',''),
(18,CURDATE(),'Membuat struktur database','Struktur awal selesai',''),
(19,CURDATE(),'Melakukan backup data latihan','File backup dibuat',''),
(20,CURDATE(),'Menguji proses login','Login diuji',''),
(21,CURDATE(),'Membuat halaman dashboard','Dashboard awal selesai',''),
(22,CURDATE(),'Mencatat hasil pengujian','Catatan pengujian lengkap',''),
(23,CURDATE(),'Mempelajari keamanan password','Memahami hashing password',''),
(24,CURDATE(),'Memeriksa tampilan laporan','Laporan diperiksa',''),
(25,CURDATE(),'Menyusun ringkasan kegiatan PKL','Ringkasan selesai','');

INSERT INTO absensi(siswa_id,tanggal,status,catatan) VALUES
(6,CURDATE(),'Hadir',''),(7,CURDATE(),'Hadir',''),(8,CURDATE(),'Hadir',''),
(9,CURDATE(),'Hadir',''),(10,CURDATE(),'Izin','Keperluan keluarga'),
(11,CURDATE(),'Hadir',''),(12,CURDATE(),'Sakit','Surat izin disampaikan'),
(13,CURDATE(),'Hadir',''),(14,CURDATE(),'Hadir',''),(15,CURDATE(),'Hadir',''),
(16,CURDATE(),'Hadir',''),(17,CURDATE(),'Hadir',''),(18,CURDATE(),'Alpa','Belum ada keterangan'),
(19,CURDATE(),'Hadir',''),(20,CURDATE(),'Hadir',''),(21,CURDATE(),'Hadir',''),
(22,CURDATE(),'Hadir',''),(23,CURDATE(),'Hadir',''),(24,CURDATE(),'Izin','Izin sekolah'),
(25,CURDATE(),'Hadir',''),
(1,DATE_SUB(CURDATE(),INTERVAL 1 DAY),'Hadir',''),(2,DATE_SUB(CURDATE(),INTERVAL 1 DAY),'Hadir',''),
(3,DATE_SUB(CURDATE(),INTERVAL 1 DAY),'Hadir',''),(4,DATE_SUB(CURDATE(),INTERVAL 1 DAY),'Hadir',''),
(5,DATE_SUB(CURDATE(),INTERVAL 1 DAY),'Hadir','');

INSERT INTO monitoring(siswa_id,tanggal,catatan,nilai,rekomendasi) VALUES
(6,CURDATE(),'Mengerjakan tugas dengan teliti.',84,'Tingkatkan dokumentasi'),
(7,CURDATE(),'Mampu bekerja sama dalam tim.',87,'Pertahankan komunikasi'),
(8,CURDATE(),'Memahami instruksi pembimbing.',80,'Latihan mandiri lebih rutin'),
(9,CURDATE(),'Konsisten menyelesaikan tugas.',86,'Tingkatkan pengujian'),
(10,CURDATE(),'Menunjukkan perkembangan yang baik.',89,'Pertahankan disiplin');
