<?php
session_start();
require_once 'config/db.php';

if (empty($_SESSION['user_id']) || $_SESSION['role'] !== 'admin') {
    header("Location: login.php");
    exit();
}

$user_id = $_GET['id'] ?? null;

if (!$user_id || $user_id == $_SESSION['user_id']) {
    echo "<script type='text/javascript'>
            alert('{$translations['product_not_found']}');
          </script>";
    exit();
}

$delete_balance_stmt = $conn->prepare("DELETE FROM balances WHERE user_id = ?");
$delete_balance_stmt->bind_param("i", $user_id);
$delete_balance_stmt->execute();
$delete_balance_stmt->close();

$delete_bids_stmt = $conn->prepare("DELETE FROM bids WHERE user_id = ?");
$delete_bids_stmt->bind_param("i", $user_id);
$delete_bids_stmt->execute();
$delete_bids_stmt->close();

// Удаляем товары пользователя
$delete_products_stmt->bind_param("i", $user_id);
$delete_products_stmt->execute();
$delete_products_stmt->close();

$delete_user_stmt = $conn->prepare("DELETE FROM users WHERE id = ?");
$delete_user_stmt->bind_param("i", $user_id);

if ($delete_user_stmt->execute()) {
    echo "<script type='text/javascript'>
            window.onload = function() {
                var notification = document.createElement('div');
                notification.className = 'notification success';
                notification.innerHTML = '{$translations['delete_user']}';
                document.body.appendChild(notification);
                notification.style.display = 'block';
                setTimeout(function() {
                    notification.style.display = 'none';
                }, 5000);
            };
          </script>";
} else {
    echo "<script type='text/javascript'>
            window.onload = function() {
                var notification = document.createElement('div');
                notification.className = 'notification error';
                notification.innerHTML = '{$translations['error_delete_user']}';
                document.body.appendChild(notification);
                notification.style.display = 'block';
                setTimeout(function() {
                    notification.style.display = 'none';
                }, 5000);
            };
          </script>";
}

header("Location: admin_dashboard.php");
exit();
?>
