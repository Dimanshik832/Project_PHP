<?php
session_start();
require_once 'config/db.php';
require 'vendor/autoload.php';

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

if (isset($_GET['lang'])) {
    $language = $_GET['lang'];
    $_SESSION['lang'] = $language;
} else {
    $language = $_SESSION['lang'] ?? 'en';
}
$translations = require "translations/{$language}.php";

$user_id = $_SESSION['user_id'] ?? null;
$receiver_id = $_GET['user_id'] ?? null;

if (!$user_id || !$receiver_id) {
    echo $translations['user_not_found'];
    exit();
}

$stmt = $conn->prepare("SELECT username, email FROM users WHERE id = ?");
$stmt->bind_param("i", $receiver_id);
$stmt->execute();
$receiver_result = $stmt->get_result();

if ($receiver_result->num_rows === 0) {
    echo $translations['user_not_found'];
    exit();
}

$receiver = $receiver_result->fetch_assoc();

$stmt = $conn->prepare("
    SELECT m.message, m.created_at, u.username 
    FROM messages m
    JOIN users u ON m.sender_id = u.id
    WHERE (m.sender_id = ? AND m.receiver_id = ?) OR (m.sender_id = ? AND m.receiver_id = ?)
    ORDER BY m.created_at ASC
");
$stmt->bind_param("iiii", $user_id, $receiver_id, $receiver_id, $user_id);
$stmt->execute();
$messages_result = $stmt->get_result();

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['message'])) {
    $message = trim($_POST['message']);

    if (!empty($message)) {
        $stmt = $conn->prepare("INSERT INTO messages (sender_id, receiver_id, message) VALUES (?, ?, ?)");
        $stmt->bind_param("iis", $user_id, $receiver_id, $message);
        $stmt->execute();

        $notification_message = "{$translations['you_received_message']} {$receiver['username']}.";
        $stmt = $conn->prepare("INSERT INTO notifications (user_id, message, type) VALUES (?, ?, 'message')");
        $stmt->bind_param("is", $receiver_id, $notification_message);
        $stmt->execute();

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
            $mail->addAddress($receiver['email']);
            $mail->isHTML(true);
            $mail->Subject = $translations['new_message_subject'];
            $mail->Body = $translations['new_message_body'];

            $mail->send();
        } catch (Exception $e) {
        }
    }
}
?>

<!DOCTYPE html>
<html lang="<?php echo htmlspecialchars($language); ?>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo htmlspecialchars($translations['chat_with']); ?> <?php echo htmlspecialchars($receiver['username']); ?></title>
    <link rel="stylesheet" href="public/styles.css">
</head>
<body>
<header class="main-header">
    <div class="container">
        <h1 class="site-title"><?php echo htmlspecialchars($translations['chat_with']); ?> <?php echo htmlspecialchars($receiver['username']); ?></h1>
        <a href="messages.php" class="back-link"><?php echo htmlspecialchars($translations['back_to_chats']); ?></a>
    </div>
</header>

<main class="chat-container">
    <section class="messages">
        <?php while ($message = $messages_result->fetch_assoc()): ?>
            <div class="message">
                <strong><?php echo htmlspecialchars($message['username']); ?>:</strong>
                <p><?php echo nl2br(htmlspecialchars($message['message'])); ?></p>
                <em><?php echo $message['created_at']; ?></em>
            </div>
        <?php endwhile; ?>
    </section>

    <section class="send-message">
        <form method="POST" action="" class="form-container">
            <textarea name="message" class="form-textarea" placeholder="<?php echo htmlspecialchars($translations['write_message']); ?>" required></textarea>
            <button type="submit" class="btn-primary"><?php echo htmlspecialchars($translations['send_message_button']); ?></button>
        </form>
    </section>
</main>
</body>
</html>
