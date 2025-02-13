<?php
session_start();
require_once 'config/db.php';

if (empty($_SESSION['user_id']) || $_SESSION['role'] !== 'admin') {
    header("Location: login.php");
    exit();
}

$user_id = $_GET['id'] ?? null;
$new_role = $_GET['role'] ?? null;

if (!$user_id || !in_array($new_role, ['admin', 'user'])) {
    echo "Некорректные данные.";
    exit();
}

$stmt = $conn->prepare("UPDATE users SET role = ? WHERE id = ?");
$stmt->bind_param("si", $new_role, $user_id);

if ($stmt->execute()) {
    echo "Роль успешно обновлена.";
} else {
    echo "Ошибка при обновлении роли.";
}

header("Location: admin_dashboard.php");
exit();
?>
