<?php
require_once __DIR__ . '/../config/app.php';
require_login();
$pageTitle = $pageTitle ?? 'Dashboard';
$role = current_user()['role'] ?? 'siswa';
$root = '/' . explode('/', trim($_SERVER['SCRIPT_NAME'], '/'))[0] . '/';
$nav = [
    ['Dashboard','dashboard.php','▦','all'],
    ['Data Siswa','admin/siswa.php','♙','admin'],
    ['Perusahaan','admin/perusahaan.php','▤','admin'],
    ['Pembimbing','admin/pembimbing.php','♧','admin'],
    ['Penempatan PKL','admin/penempatan.php','⌖','admin'],
    ['Jurnal Kegiatan','jurnal.php','▣','all'],
    ['Absensi','absensi.php','✓','all'],
    ['Monitoring','admin/monitoring.php','◉','admin'],
    ['Laporan','laporan/index.php','▤','admin'],
];
?>
<!doctype html><html lang="id"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title><?=e($pageTitle)?> - InternTrack</title><link rel="stylesheet" href="<?=$root?>assets/style.css"></head><body>
<div class="layout"><aside class="sidebar"><div class="brand">Intern<span>Track</span></div><div class="nav-label">Menu utama</div>
<?php foreach($nav as $item): if($item[3]==='admin' && $role!=='admin') continue; ?>
<a class="nav-link <?=basename($_SERVER['PHP_SELF'])===basename($item[1])?'active':''?>" href="<?=e($root . $item[1])?>"><?=$item[2]?> &nbsp; <?=e($item[0])?></a>
<?php endforeach; ?><div class="nav-label" style="margin-top:18px">Akun</div><a class="nav-link" href="<?=$root?>profil.php">⚙ &nbsp; Profil Saya</a><a class="nav-link" href="<?=$root?>logout.php">↪ &nbsp; Keluar</a></aside>
<main class="main"><header class="topbar"><strong><?=e($pageTitle)?></strong><span class="muted"><?=e(current_user()['nama'] ?? 'Pengguna')?> · <?=e(ucfirst($role))?></span></header><section class="content">
<?php if(!empty($_SESSION['flash'])): $f=$_SESSION['flash']; unset($_SESSION['flash']); ?><div class="alert <?=e($f['type'])?>"><?=e($f['message'])?></div><?php endif; ?>
