<?php
if (session_status() === PHP_SESSION_NONE) session_start();

function e($value): string {
    return htmlspecialchars((string)($value ?? ''), ENT_QUOTES, 'UTF-8');
}
function redirect(string $url): never {
    header("Location: {$url}");
    exit;
}
function flash(string $type, string $message): void {
    $_SESSION['flash'] = ['type' => $type, 'message' => $message];
}
function csrf_token(): string {
    if (empty($_SESSION['csrf_token'])) $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
    return $_SESSION['csrf_token'];
}
function csrf_check(): void {
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $token = $_POST['csrf_token'] ?? '';
        if (!is_string($token) || !hash_equals($_SESSION['csrf_token'] ?? '', $token)) {
            http_response_code(419);
            exit('Permintaan tidak valid. Muat ulang halaman lalu coba lagi.');
        }
    }
}
function require_login(): void {
    if (empty($_SESSION['user'])) { $root = '/' . explode('/', trim($_SERVER['SCRIPT_NAME'], '/'))[0] . '/'; redirect($root . 'index.php'); }
}
function require_admin(): void {
    require_login();
    if (($_SESSION['user']['role'] ?? '') !== 'admin') {
        flash('danger', 'Halaman ini hanya dapat diakses admin/pembimbing.');
        $root = '/' . explode('/', trim($_SERVER['SCRIPT_NAME'], '/'))[0] . '/'; redirect($root . 'dashboard.php');
    }
}
function current_user(): array { return $_SESSION['user'] ?? []; }
function status_pkl(float $persen): string {
    if ($persen >= 90) return 'Sangat Baik';
    if ($persen >= 75) return 'Baik';
    if ($persen >= 60) return 'Perlu Perhatian';
    return 'Perlu Pembinaan';
}
function rupiah($angka): string { return 'Rp ' . number_format((float)$angka, 0, ',', '.'); }
