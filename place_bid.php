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
    $language = $_SESSION['lang'] ?? 'ru';
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

if (!isset($_POST['product_id'], $_POST['bid_amount'], $_SESSION['user_id'])) {
    echo $translations['missing_parameters'];
    exit();
}

$product_id = $_POST['product_id'];
$bid_amount = $_POST['bid_amount'];
$user_id = $_SESSION['user_id'];

$product_stmt = $conn->prepare("SELECT user_id, current_price, start_price FROM products WHERE id = ?");
$product_stmt->bind_param("i", $product_id);
$product_stmt->execute();
$product_result = $product_stmt->get_result();

if ($product_result->num_rows === 0) {
    echo $translations['product_not_found'];
    exit();
}

$product = $product_result->fetch_assoc();

if ($product['user_id'] === $user_id) {
    echo $translations['cannot_bid_own_product'];
    exit();
}

$min_price = $product['start_price'];

if ($bid_amount < $min_price) {
    echo $translations['bid_too_low'];
    exit();
}

$balance_result = $conn->query("SELECT balance FROM balances WHERE user_id = $user_id");
$balance = $balance_result->fetch_assoc();
$current_balance = $balance ? $balance['balance'] : 0.00;

if ($current_balance < $bid_amount) {
    echo $translations['insufficient_funds'];
    exit();
}

$stmt = $conn->prepare("SELECT user_id, amount FROM bids WHERE product_id = ? ORDER BY created_at DESC LIMIT 1");
$stmt->bind_param("i", $product_id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $previous_bid = $result->fetch_assoc();
    $previous_user_id = $previous_bid['user_id'];
    $previous_bid_amount = $previous_bid['amount'];

    if ($bid_amount <= $previous_bid_amount) {
        echo $translations['bid_should_be_higher'] . " ($previous_bid_amount USD)";
        exit();
    }

    $update_balance_stmt = $conn->prepare("UPDATE balances SET balance = balance + ? WHERE user_id = ?");
    $update_balance_stmt->bind_param("di", $previous_bid_amount, $previous_user_id);
    $update_balance_stmt->execute();

    $notification_stmt = $conn->prepare("INSERT INTO notifications (user_id, message, type) VALUES (?, ?, 'bid_outbid')");
    $notification_stmt->bind_param("is", $previous_user_id, $translations['outbid_message']);
    $notification_stmt->execute();

    $stmt_bidder = $conn->prepare("SELECT email FROM users WHERE id = ?");
    $stmt_bidder->bind_param("i", $previous_user_id);
    $stmt_bidder->execute();
    $bidder_result = $stmt_bidder->get_result();
    $bidder = $bidder_result->fetch_assoc();

    $subject = $translations['outbid_subject'];
    $email_message = $translations['outbid_body'] . $previous_bid_amount . " USD" . $translations['outbid_body2'] . $bid_amount . " USD" ;
    sendEmailNotification($bidder['email'], $subject, $email_message);
}


$stmt = $conn->prepare("INSERT INTO bids (product_id, user_id, amount) VALUES (?, ?, ?)");
$stmt->bind_param("iid", $product_id, $user_id, $bid_amount);
if ($stmt->execute()) {

    $new_balance = $current_balance - $bid_amount;
    $update_balance_stmt = $conn->prepare("UPDATE balances SET balance = ? WHERE user_id = ?");
    $update_balance_stmt->bind_param("di", $new_balance, $user_id);
    $update_balance_stmt->execute();


    $update_price_stmt = $conn->prepare("UPDATE products SET current_price = ? WHERE id = ?");
    $update_price_stmt->bind_param("di", $bid_amount, $product_id);
    $update_price_stmt->execute();

    echo $translations['bid_successful'];
    header("Location: product_details.php?id=" . $product_id);
    exit();
} else {
    echo $translations['bid_error'];
}
?>
