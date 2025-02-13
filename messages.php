<?php
session_start();
require_once 'config/db.php';

$language = $_GET['lang'] ?? $_SESSION['lang'] ?? 'en';
$_SESSION['lang'] = $language;

$translations = require "translations/{$language}.php";

if (empty($_SESSION['user_id'])) {
    header("Location: login.php");
    exit();
}

$user_id = $_SESSION['user_id'];

$query = "
    SELECT DISTINCT u.id AS user_id, u.username 
    FROM messages m 
    JOIN users u ON m.sender_id = u.id OR m.receiver_id = u.id
    WHERE (m.sender_id = ? OR m.receiver_id = ?) AND u.id != ?
";
$stmt = $conn->prepare($query);
$stmt->bind_param("iii", $user_id, $user_id, $user_id);
$stmt->execute();
$chat_list = $stmt->get_result();
?>

<!DOCTYPE html>
<html lang="<?php echo htmlspecialchars($language); ?>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo htmlspecialchars($translations['chats']); ?></title>
    <link rel="stylesheet" href="public/styles.css">
</head>
<body>
<header class="main-header">
    <div class="container">
        <h1 class="site-title"><?php echo htmlspecialchars($translations['your_chats']); ?></h1>
        <nav class="user-navigation">
            <a href="index.php" class="nav-link"><?php echo htmlspecialchars($translations['back_to_home']); ?></a>
            <a href="logout.php" class="nav-link"><?php echo htmlspecialchars($translations['logout']); ?></a>
        </nav>
    </div>
</header>

<main class="main-content">
    <section class="chat-list">
        <h2><?php echo htmlspecialchars($translations['chat_list']); ?>:</h2>
        <?php if ($chat_list->num_rows > 0): ?>
            <ul class="chat-list-container">
                <?php while ($chat = $chat_list->fetch_assoc()): ?>
                    <li class="chat-list-item">
                        <a href="chat.php?user_id=<?php echo $chat['user_id']; ?>" class="chat-link">
                            <?php echo htmlspecialchars($chat['username']); ?>
                        </a>
                    </li>
                <?php endwhile; ?>
            </ul>
        <?php else: ?>
            <p class="no-chats"><?php echo htmlspecialchars($translations['no_chats']); ?></p>
        <?php endif; ?>
    </section>
</main>
</body>
</html>
