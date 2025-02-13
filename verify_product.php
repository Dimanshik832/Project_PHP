<?php
session_start();
require_once 'config/db.php';

if ($_SESSION['role'] !== 'admin') {
    header("Location: index.php");
    exit();
}

$product_id = $_GET['id'] ?? null;
if (!$product_id) {
    echo "Товар не найден.";
    exit();
}

$stmt = $conn->prepare("UPDATE products SET is_verified = 1 WHERE id = ?");
$stmt->bind_param("i", $product_id);

if ($stmt->execute()) {
    header("Location: admin_verify_products.php");
} else {
    echo "Ошибка при верификации товара.";
}
?>
