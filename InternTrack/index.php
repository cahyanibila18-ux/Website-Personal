<?php
require_once __DIR__.'/config/app.php';
require_once __DIR__.'/config/koneksi.php';
if (!empty($_SESSION['user'])) redirect('dashboard.php');
$error='';
if($_SERVER['REQUEST_METHOD']==='POST'){
    csrf_check();
    $username=trim($_POST['username']??''); $password=$_POST['password']??'';
    if($username===''||$password==='') $error='Username dan password wajib diisi.';
    else {
        $stmt=$pdo->prepare("SELECT id,nama,username,password,role,siswa_id FROM users WHERE username=? LIMIT 1");
        $stmt->execute([$username]); $u=$stmt->fetch();
        if($u && password_verify($password,$u['password'])){
            session_regenerate_id(true);
            $_SESSION['user']=['id'=>(int)$u['id'],'nama'=>$u['nama'],'username'=>$u['username'],'role'=>$u['role'],'siswa_id'=>$u['siswa_id']];
            redirect('dashboard.php');
        } else $error='Username atau password salah.';
    }
}
?>
<!doctype html><html lang="id"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Login - InternTrack</title><link rel="stylesheet" href="assets/style.css"></head><body><div class="login-page"><section class="login-art"><div style="font-size:18px;font-weight:800;letter-spacing:2px">INTERNTRACK / PKL MONITORING</div><h1>Pantau PKL.<br>Kelola progres.</h1><p>Satu ruang untuk mengelola data siswa, penempatan, jurnal kegiatan, kehadiran, dan monitoring PKL dengan lebih rapi.</p><div style="margin-top:35px;color:#bfdbfe">SMK · Rekayasa Perangkat Lunak</div></section><section class="login-box"><form class="login-card" method="post"><div style="font-size:12px;font-weight:800;letter-spacing:2px;color:#3157c8;margin-bottom:18px">INTERNTRACK</div><h2>Selamat datang</h2><p class="muted">Masuk untuk melanjutkan ke sistem.</p><?php if($error):?><div class="alert danger"><?=e($error)?></div><?php endif;?><input type="hidden" name="csrf_token" value="<?=e(csrf_token())?>"><div class="field"><label>Username</label><input name="username" required autocomplete="username" placeholder="Masukkan username"></div><div class="field"><label>Password</label><input type="password" name="password" required autocomplete="current-password" placeholder="Masukkan password"></div><button class="btn" type="submit">Login ke InternTrack →</button><div class="small-note">Akun demo admin: <b>admin</b> / <b>admin123</b><br>Akun demo siswa: <b>siswa001</b> / <b>siswa123</b><br>Ganti password demo sebelum digunakan sungguhan.</div></form></section></div></body></html>
