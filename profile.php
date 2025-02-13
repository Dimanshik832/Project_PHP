<?php
session_start();
require_once 'config/db.php';

if (isset($_GET['lang'])) {
    $language = $_GET['lang'];
    $_SESSION['lang'] = $language;
} else {
    $language = $_SESSION['lang'] ?? 'en';
}
$translations = require "translations/{$language}.php";

$user_id = $_SESSION['user_id'];
$stmt = $conn->prepare("SELECT username, email FROM users WHERE id = ?");
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();
$user = $result->fetch_assoc();

$balance_result = $conn->query("SELECT balance FROM balances WHERE user_id = $user_id");
$balance = $balance_result->fetch_assoc();
$current_balance = $balance ? $balance['balance'] : 0.00;

$product_stmt = $conn->prepare("SELECT id, title, current_price, end_date FROM products WHERE user_id = ? AND is_auction = 1");
$product_stmt->bind_param("i", $user_id);
$product_stmt->execute();
$product_result = $product_stmt->get_result();
?>

<!DOCTYPE html>
<html lang="<?php echo htmlspecialchars($language); ?>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo htmlspecialchars($translations['my_profile']); ?></title>
    <link rel="stylesheet" href="public/styles.css">
</head>
<body>
<header>
    <h1><?php echo htmlspecialchars($translations['my_profile']); ?></h1>
    <a href="index.php"><?php echo htmlspecialchars($translations['back_to_home']); ?></a> |
    <a href="logout.php"><?php echo htmlspecialchars($translations['logout']); ?></a>
</header>

<div class="container">
    <div class="card">
        <h2><?php echo htmlspecialchars($translations['user_info']); ?></h2>
        <p><strong><?php echo htmlspecialchars($translations['username']); ?>:</strong> <?php echo htmlspecialchars($user['username']); ?></p>
        <p><strong><?php echo htmlspecialchars($translations['email']); ?>:</strong> <?php echo htmlspecialchars($user['email']); ?></p>
        <p><strong><?php echo htmlspecialchars($translations['balance']); ?>:</strong> <?php echo htmlspecialchars($current_balance); ?> USD</p>
        <a href="top_up_balance.php" class="button"><?php echo htmlspecialchars($translations['top_up_balance']); ?></a>
    </div>

    <div class="card">
        <h2><?php echo htmlspecialchars($translations['your_products']); ?></h2>
        <?php if ($product_result->num_rows > 0): ?>
            <ul>
                <?php while ($product = $product_result->fetch_assoc()): ?>
                    <li>
                        <strong><?php echo htmlspecialchars($product['title']); ?></strong> - <?php echo htmlspecialchars($product['current_price']); ?> USD
                        <br><em><?php echo htmlspecialchars($translations['end_date']); ?>: <?php echo htmlspecialchars($product['end_date']); ?></em>
                    </li>
                <?php endwhile; ?>
            </ul>
        <?php else: ?>
            <p><?php echo htmlspecialchars($translations['no_products']); ?></p>
        <?php endif; ?>
    </div>

    <div class="card">
        <h3><?php echo htmlspecialchars($translations['additional_options']); ?></h3>
        <p><a href="messages.php" class="button"><?php echo htmlspecialchars($translations['go_to_messages']); ?></a></p>
        <p><a href="notifications.php" class="button"><?php echo htmlspecialchars($translations['notifications']); ?></a></p>
    </div>
</div>
</body>
</html>
