<?php
declare(strict_types=1);

$host = 'localhost';
$db   = 'interntrack';
$user = 'root';
$pass = '';
$charset = 'utf8mb4';

$dsn = "mysql:host={$host};dbname={$db};charset={$charset}";
$options = [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES => false,
];

try {
    $pdo = new PDO($dsn, $user, $pass, $options);
} catch (PDOException $e) {
    http_response_code(500);
    exit('Koneksi database gagal. Pastikan MySQL aktif dan database interntrack sudah diimpor. Detail: ' .
        htmlspecialchars($e->getMessage(), ENT_QUOTES, 'UTF-8'));
}
