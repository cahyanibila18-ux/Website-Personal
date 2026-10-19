<?php
require_once __DIR__.'/config/koneksi.php';
$adminHash=password_hash('admin123', PASSWORD_DEFAULT);
$studentHash=password_hash('siswa123', PASSWORD_DEFAULT);
$pdo->prepare("UPDATE users SET password=? WHERE username='admin'")->execute([$adminHash]);
$pdo->prepare("UPDATE users SET password=? WHERE role='siswa'")->execute([$studentHash]);
echo "Password demo sudah diatur: admin/admin123 dan siswa001/siswa123. Sekarang HAPUS file setup_admin.php demi keamanan.";
