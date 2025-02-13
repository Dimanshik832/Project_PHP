<?php
session_start();
require_once 'config/db.php';

$language = $_GET['lang'] ?? $_SESSION['lang'] ?? 'en';
$_SESSION['lang'] = $language;

$translations = require "translations/{$language}.php";

$user_id = $_SESSION['user_id'] ?? null;
if (!$user_id) {
    echo $translations['not_logged_in'];
    exit();
}

$update_stmt = $conn->prepare("UPDATE notifications SET is_read = 1 WHERE user_id = ? AND is_read = 0");
$update_stmt->bind_param("i", $user_id);
$update_stmt->execute();

$stmt = $conn->prepare("
    SELECT id, message, created_at, type, is_read 
    FROM notifications 
    WHERE user_id = ? 
    ORDER BY created_at DESC
");
$stmt->bind_param("i", $user_id);
$stmt->execute();
$notifications_result = $stmt->get_result();
?>

<!DOCTYPE html>
<html lang="<?php echo htmlspecialchars($language); ?>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo htmlspecialchars($translations['notifications']); ?></title>
    <link rel="stylesheet" href="public/styles.css">
</head>
<body>
<header class="main-header">
    <div class="container">
        <h1 class="site-title"><?php echo htmlspecialchars($translations['your_notifications']); ?></h1>
        <nav class="user-navigation">
            <a href="index.php" class="nav-link"><?php echo htmlspecialchars($translations['back_to_home']); ?></a>
            <a href="logout.php" class="nav-link"><?php echo htmlspecialchars($translations['logout']); ?></a>
        </nav>
    </div>
</header>

<main class="main-content">
    <section class="notifications-section">
        <?php if ($notifications_result->num_rows > 0): ?>
            <ul class="notifications-list">
                <?php while ($notification = $notifications_result->fetch_assoc()): ?>
                    <li class="notification-item" style="background-color: <?php echo $notification['is_read'] ? '#e0e0e0' : '#ffffff'; ?>;">
                        <div class="notification-content">
                            <h3 class="notification-type"><?php echo htmlspecialchars($notification['type']); ?></h3>
                            <p class="notification-message"><?php echo nl2br(htmlspecialchars($notification['message'])); ?></p>
                            <time class="notification-timestamp"><?php echo htmlspecialchars($notification['created_at']); ?></time>
                        </div>
                    </li>
                <?php endwhile; ?>
            </ul>
        <?php else: ?>
            <p class="no-notifications"><?php echo htmlspecialchars($translations['no_notifications']); ?></p>
        <?php endif; ?>
    </section>
</main>
</body>
</html>
