<?php
require_once __DIR__.'/../config/app.php'; require_once __DIR__.'/../config/koneksi.php'; require_admin();
$pageTitle='Data Siswa';
$errors=[];
if($_SERVER['REQUEST_METHOD']==='POST'){csrf_check();$action=$_POST['action']??'';
 $id=(int)($_POST['id']??0);$nis=trim($_POST['nis']??'');$nama=trim($_POST['nama']??'');$kelas=trim($_POST['kelas']??'');$jurusan=trim($_POST['jurusan']??'');$no_hp=trim($_POST['no_hp']??'');
 if($action!=='delete'){
  if($nis===''||$nama==='')$errors[]='NIS dan nama wajib diisi.';
  $q=$pdo->prepare("SELECT id FROM siswa WHERE nis=? AND id<>?");$q->execute([$nis,$id]);if($q->fetch())$errors[]='NIS sudah digunakan.';
  if(!$errors){if($action==='create'){$q=$pdo->prepare("INSERT INTO siswa(nis,nama,kelas,jurusan,no_hp) VALUES(?,?,?,?,?)");$q->execute([$nis,$nama,$kelas,$jurusan,$no_hp]);flash('success','Data siswa berhasil ditambahkan.');}
   else {$q=$pdo->prepare("UPDATE siswa SET nis=?,nama=?,kelas=?,jurusan=?,no_hp=? WHERE id=?");$q->execute([$nis,$nama,$kelas,$jurusan,$no_hp,$id]);flash('success','Data siswa berhasil diperbarui.');}redirect('siswa.php');}
 }else{$pdo->prepare("DELETE FROM siswa WHERE id=?")->execute([$id]);flash('success','Data siswa dihapus.');redirect('siswa.php');}
}
$edit=null;if(isset($_GET['edit'])){$q=$pdo->prepare("SELECT * FROM siswa WHERE id=?");$q->execute([(int)$_GET['edit']]);$edit=$q->fetch();}
$search=trim($_GET['q']??'');$kelasFilter=trim($_GET['kelas']??'');
$sql="SELECT s.* FROM siswa s WHERE (s.nis LIKE ? OR s.nama LIKE ?)";$params=["%$search%","%$search%"];if($kelasFilter!==''){$sql.=" AND s.kelas=?";$params[]=$kelasFilter;}$sql.=" ORDER BY s.nama";$q=$pdo->prepare($sql);$q->execute($params);$rows=$q->fetchAll();
$classes=$pdo->query("SELECT DISTINCT kelas FROM siswa WHERE kelas<>'' ORDER BY kelas")->fetchAll(PDO::FETCH_COLUMN);
include __DIR__.'/../partials/header.php';
?>
<div class="page-head"><div><h1>Data Siswa</h1><div class="muted">Kelola identitas peserta PKL.</div></div><a class="btn" href="siswa.php#form">＋ Tambah Siswa</a></div>
<?php foreach($errors as $er):?><div class="alert danger"><?=e($er)?></div><?php endforeach;?>
<div class="card" id="form"><h3><?=$edit?'Edit Siswa':'Tambah Siswa'?></h3><form method="post"><input type="hidden" name="csrf_token" value="<?=e(csrf_token())?>"><input type="hidden" name="action" value="<?=$edit?'update':'create'?>"><input type="hidden" name="id" value="<?=e($edit['id']??'')?>"><div class="form-grid">
<?php foreach([['nis','NIS'],['nama','Nama Lengkap'],['kelas','Kelas'],['jurusan','Jurusan'],['no_hp','No. HP']] as $f):?><div class="field"><label><?=e($f[1])?><?=in_array($f[0],['nis','nama'])?' *':''?></label><input name="<?=e($f[0])?>" value="<?=e($edit[$f[0]]??'')?>" <?=in_array($f[0],['nis','nama'])?'required':''?>></div><?php endforeach;?>
</div><div class="form-actions"><button class="btn">Simpan</button><?php if($edit):?><a class="btn secondary" href="siswa.php">Batal</a><?php endif;?></div></form></div>
<div class="card"><form class="filters" method="get"><input name="q" placeholder="Cari nama atau NIS..." value="<?=e($search)?>"><select name="kelas"><option value="">Semua kelas</option><?php foreach($classes as $c):?><option <?= $kelasFilter===$c?'selected':''?> value="<?=e($c)?>"><?=e($c)?></option><?php endforeach;?></select><button class="btn">Cari / Filter</button><a class="btn secondary" href="siswa.php">Reset</a></form><div class="table-wrap"><table><thead><tr><th>NIS</th><th>Nama</th><th>Kelas</th><th>Jurusan</th><th>No. HP</th><th>Aksi</th></tr></thead><tbody><?php foreach($rows as $r):?><tr><td><?=e($r['nis'])?></td><td><b><?=e($r['nama'])?></b></td><td><?=e($r['kelas'])?></td><td><?=e($r['jurusan'])?></td><td><?=e($r['no_hp'])?></td><td><div class="actions"><a class="btn secondary small" href="siswa.php?edit=<?=$r['id']?>#form">Edit</a><form method="post" data-confirm="Hapus data siswa ini?"><input type="hidden" name="csrf_token" value="<?=e(csrf_token())?>"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="<?=$r['id']?>"><button class="btn danger small">Hapus</button></form></div></td></tr><?php endforeach;?><?php if(!$rows):?><tr><td colspan="6" class="empty">Data siswa tidak ditemukan.</td></tr><?php endif;?></tbody></table></div></div>
<?php include __DIR__.'/../partials/footer.php';?>
