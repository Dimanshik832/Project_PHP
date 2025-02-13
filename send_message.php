<?php
session_start();
require_once 'config/db.php';

$message = $_POST['message'] ?? null;
$receiver_id = $_POST['receiver_id'] ?? null;

if (!$message || !$receiver_id) {
    echo "Ошибка: недостающие параметры.";
    exit();
}

$sender_id = $_SESSION['user_id'];

$stmt = $conn->prepare("INSERT INTO messages (sender_id, receiver_id, message) VALUES (?, ?, ?)");
$stmt->bind_param("iis", $sender_id, $receiver_id, $message);

if ($stmt->execute()) {
    header("Location: chat.php?user_id=$receiver_id");
    exit();
} else {
    echo "Ошибка при отправке сообщения.";
}
?>

