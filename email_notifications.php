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
        echo $translations['email_send_error'] . ": {$mail->ErrorInfo}";
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    if (isset($_POST['new_message'])) {
        $user_id = $_SESSION['user_id'];
        $receiver_id = $_POST['receiver_id'];

        $stmt = $conn->prepare("SELECT email FROM users WHERE id = ?");
        $stmt->bind_param("i", $receiver_id);
        $stmt->execute();
        $result = $stmt->get_result();
        $receiver = $result->fetch_assoc();

        if ($receiver) {
            $subject = $translations['new_message_subject'];
            $message = $translations['new_message_body'];

            sendEmailNotification($receiver['email'], $subject, $message);

            $notification_message = $translations['new_message_notification'] . " $user_id.";
            $notification_type = 'message';
            $insert_notification = $conn->prepare("INSERT INTO notifications (user_id, message, type) VALUES (?, ?, ?)");
            $insert_notification->bind_param("iss", $receiver_id, $notification_message, $notification_type);
            $insert_notification->execute();
        }
    }

    if (isset($_POST['bid_beat'])) {
        $user_id = $_SESSION['user_id'];
        $product_id = $_POST['product_id'];
        $bid_amount = $_POST['bid_amount'];

        $stmt = $conn->prepare("SELECT p.user_id, p.title, b.amount AS previous_bid_amount, u.email, b.user_id AS previous_bidder_id
                                FROM products p 
                                JOIN bids b ON p.id = b.product_id 
                                JOIN users u ON p.user_id = u.id
                                WHERE p.id = ?
                                ORDER BY b.created_at DESC LIMIT 1");
        $stmt->bind_param("i", $product_id);
        $stmt->execute();
        $result = $stmt->get_result();
        $product = $result->fetch_assoc();

        if ($product) {
            $stmt_bidder = $conn->prepare("SELECT email FROM users WHERE id = ?");
            $stmt_bidder->bind_param("i", $product['previous_bidder_id']);
            $stmt_bidder->execute();
            $bidder_result = $stmt_bidder->get_result();
            $bidder = $bidder_result->fetch_assoc();

            $subject = $translations['bid_beaten_subject'];
            $message = $translations['bid_beaten_body'];

            sendEmailNotification($bidder['email'], $subject, $message);

            $notification_message = $translations['bid_beaten_notification'];
            $notification_type = 'bid';
            $insert_notification = $conn->prepare("INSERT INTO notifications (user_id, message, type) VALUES (?, ?, ?)");
            $insert_notification->bind_param("iss", $product['previous_bidder_id'], $notification_message, $notification_type);
            $insert_notification->execute();
        }
    }

    if (isset($_POST['auction_end'])) {
        $user_id = $_SESSION['user_id'];

        $stmt = $conn->prepare("SELECT email FROM users WHERE id = ?");
        $stmt->bind_param("i", $user_id);
        $stmt->execute();
        $result = $stmt->get_result();
        $user = $result->fetch_assoc();
        $user_email = $user['email'];

        $subject = $translations['auction_end_subject'];
        $message = $translations['auction_end_body'];

        sendEmailNotification($user_email, $subject, $message);

        $notification_message = $translations['auction_end_notification'];
        $notification_type = 'auction_end';
        $insert_notification = $conn->prepare("INSERT INTO notifications (user_id, message, type) VALUES (?, ?, ?)");
        $insert_notification->bind_param("iss", $user_id, $notification_message, $notification_type);
        $insert_notification->execute();
    }
} else {
    echo $translations['no_data_to_process'];
}
?>

