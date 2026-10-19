<?php
require_once __DIR__.'/config/app.php'; require_once __DIR__.'/config/koneksi.php';
require_login(); $pageTitle='Dashboard';
$role=current_user()['role'];
if($role==='admin'){
 $stats=[
 ['Total Siswa PKL',(int)$pdo->query("SELECT COUNT(*) FROM siswa")->fetchColumn(),'♙'],
 ['Perusahaan',(int)$pdo->query("SELECT COUNT(*) FROM perusahaan")->fetchColumn(),'▤'],
 ['Pembimbing',(int)$pdo->query("SELECT COUNT(*) FROM pembimbing")->fetchColumn(),'♧'],
 ['PKL Aktif',(int)$pdo->query("SELECT COUNT(*) FROM penempatan WHERE status='Aktif'")->fetchColumn(),'⌖'],
 ['PKL Selesai',(int)$pdo->query("SELECT COUNT(*) FROM penempatan WHERE status='Selesai'")->fetchColumn(),'✓'],
 ['Jurnal Hari Ini',(int)$pdo->query("SELECT COUNT(*) FROM jurnal WHERE tanggal=CURDATE()")->fetchColumn(),'▣'],
 ['Siswa Perlu Perhatian',(int)$pdo->query("SELECT COUNT(*) FROM (SELECT s.id, CASE WHEN COUNT(a.id)=0 THEN 0 ELSE SUM(a.status='Hadir')/COUNT(a.id)*100 END persen FROM siswa s LEFT JOIN absensi a ON a.siswa_id=s.id GROUP BY s.id HAVING persen<75) x")->fetchColumn(),'!']
 ];
 $recent=$pdo->query("SELECT j.tanggal,s.nama,j.kegiatan FROM jurnal j JOIN siswa s ON s.id=j.siswa_id ORDER BY j.tanggal DESC,j.id DESC LIMIT 6")->fetchAll();
} else {
 $sid=(int)(current_user()['siswa_id']??0);
 $q=$pdo->prepare("SELECT COUNT(*) FROM jurnal WHERE siswa_id=?");$q->execute([$sid]);$journals=(int)$q->fetchColumn();
 $q=$pdo->prepare("SELECT COUNT(*) FROM absensi WHERE siswa_id=? AND status='Hadir'");$q->execute([$sid]);$hadir=(int)$q->fetchColumn();
 $q=$pdo->prepare("SELECT COUNT(*) FROM absensi WHERE siswa_id=?");$q->execute([$sid]);$total=(int)$q->fetchColumn();
 $q=$pdo->prepare("SELECT p.status,pr.nama AS perusahaan,p.tanggal_mulai,p.tanggal_selesai FROM penempatan p JOIN perusahaan pr ON pr.id=p.perusahaan_id WHERE p.siswa_id=? ORDER BY p.id DESC LIMIT 1");$q->execute([$sid]);$placement=$q->fetch();
 $stats=[['Jurnal Tercatat',$journals,'▣'],['Kehadiran',$total?round($hadir/$total*100).'%':'0%','✓'],['Status PKL',$placement['status']??'Belum Ada','⌖']];
 $q=$pdo->prepare("SELECT tanggal,kegiatan FROM jurnal WHERE siswa_id=? ORDER BY tanggal DESC,id DESC LIMIT 6");$q->execute([$sid]);$recent=$q->fetchAll();
}
include __DIR__.'/partials/header.php';
?>
<div class="page-head"><div><h1>Halo, <?=e(current_user()['nama'])?> 👋</h1><div class="muted">Ringkasan aktivitas Praktik Kerja Lapangan.</div></div><?php if($role==='siswa'):?><a class="btn" href="jurnal.php?action=create">＋ Tulis Jurnal</a><?php endif;?></div>
<div class="grid"><?php foreach($stats as $s):?><div class="card"><span class="stat-icon"><?=$s[2]?></span><div class="stat-label"><?=e($s[0])?></div><div class="stat-value"><?=e($s[1])?></div><div class="muted" style="font-size:12px">Data tersimpan di database</div></div><?php endforeach;?></div>
<?php if($role==='siswa' && !empty($placement)):?><div class="card"><h3>Penempatan PKL Saya</h3><p><b><?=e($placement['perusahaan'])?></b> · <span class="badge success"><?=e($placement['status'])?></span></p><p class="muted"><?=e($placement['tanggal_mulai'])?> sampai <?=e($placement['tanggal_selesai'])?></p></div><?php endif;?>
<div class="card"><div class="page-head" style="margin-bottom:10px"><div><h3 style="margin:0">Aktivitas Terbaru</h3><span class="muted">Catatan jurnal terbaru</span></div><a href="<?= $role==='admin'?'jurnal.php':'jurnal.php' ?>">Lihat semua →</a></div><div class="table-wrap"><table><thead><tr><th>Tanggal</th><?php if($role==='admin'):?><th>Siswa</th><?php endif;?><th>Kegiatan</th></tr></thead><tbody><?php foreach($recent as $r):?><tr><td><?=e($r['tanggal'])?></td><?php if($role==='admin'):?><td><?=e($r['nama'])?></td><?php endif;?><td><?=e($r['kegiatan'])?></td></tr><?php endforeach;?><?php if(!$recent):?><tr><td colspan="3" class="empty">Belum ada aktivitas jurnal.</td></tr><?php endif;?></tbody></table></div></div>
<?php include __DIR__.'/partials/footer.php'; ?>
