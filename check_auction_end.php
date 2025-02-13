<?php
session_start();
require_once 'config/db.php';
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require 'vendor/autoload.php';

if (isset($_GET['lang'])) {
    $language = $_GET['lang'];
    $_SESSION['lang'] = $language;
} else {
    $language = $_SESSION['lang'] ?? 'en';
}
$translations = require "translations/{$language}.php";

function sendEmailNotification($user_email, $subject, $message) {
    $mail = new PHPMailer(true);

    try {
        $mail->isSMTP();
        $mail->Host = 'smtp.gmail.com';
        $mail->SMTPAuth = true;
        $mail->Username = 'tteeest78@gmail.com';
        $mail->Password = 'oquo eohl wyjg cpgu';
        $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
        $mail->Port = 587;
        $mail->CharSet = 'UTF-8';

        $mail->setFrom('tteeest78@gmail.com', 'Auction Platform');
        $mail->addAddress($user_email);

        $mail->isHTML(true);
        $mail->Subject = $subject;
        $mail->Body    = $message;

        $mail->send();
        echo $translations['notification_sent'];
    } catch (Exception $e) {
        echo "Ошибка отправки уведомления: {$mail->ErrorInfo}";
    }
}

$current_date = new DateTime();

$stmt = $conn->prepare("SELECT p.id, p.user_id, p.current_price, p.end_date 
                        FROM products p 
                        WHERE p.is_auction = 1 AND p.end_date <= ?");
$current_date_formatted = $current_date->format('Y-m-d H:i:s');
$stmt->bind_param("s", $current_date_formatted);

if (!$stmt->execute()) {
    echo $translations['query_error'] . $stmt->error;
    exit();
}
$result = $stmt->get_result();

while ($row = $result->fetch_assoc()) {
    $product_id = $row['id'];
    $seller_id = $row['user_id'];
    $winning_price = $row['current_price'];

    $stmt_seller = $conn->prepare("SELECT email FROM users WHERE id = ?");
    $stmt_seller->bind_param("i", $seller_id);
    $stmt_seller->execute();
    $seller_result = $stmt_seller->get_result();
    $seller = $seller_result->fetch_assoc();
    $seller_email = $seller['email'];

    $update_balance_stmt = $conn->prepare("UPDATE balances SET balance = balance + ? WHERE user_id = ?");
    $update_balance_stmt->bind_param("di", $winning_price, $seller_id);
    if (!$update_balance_stmt->execute()) {
        echo $translations['balance_update_error'] . $product_id;
        continue;
    }

    $notification_message = "Ваш аукцион завершен! Товары были проданы по цене: " . $winning_price . " USD. Деньги переведены на ваш баланс.";
    $notification_stmt = $conn->prepare("INSERT INTO notifications (user_id, message, type) VALUES (?, ?, 'auction_end')");
    $notification_stmt->bind_param("is", $seller_id, $notification_message);
    $notification_stmt->execute();

    $subject = $translations['auction_end_subject'];
    $email_message = $translations['auction_end_body'] . $winning_price . " USD. " . $translations['funds_transferred'];
    sendEmailNotification($seller_email, $subject, $email_message);

    $update_product_stmt = $conn->prepare("UPDATE products SET is_auction = 0 WHERE id = ?");
    $update_product_stmt->bind_param("i", $product_id);
    if (!$update_product_stmt->execute()) {
        echo $translations['product_update_error'] . $product_id;
        continue;
    }
}

echo $translations['auctions_completed'];
?>
