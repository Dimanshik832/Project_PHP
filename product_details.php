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

$product_id = $_GET['id'] ?? null;

if (!$product_id) {
    echo $translations['product_not_found'];
    exit();
}

$stmt = $conn->prepare("SELECT p.*, u.username FROM products p JOIN users u ON p.user_id = u.id WHERE p.id = ?");
$stmt->bind_param("i", $product_id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    echo $translations['product_not_found'];
    exit();
}

$product = $result->fetch_assoc();

$is_auction = $product['is_auction'];

$user_id = $_SESSION['user_id'] ?? null;
$current_balance = 0.00;

if ($user_id) {
    $balance_result = $conn->prepare("SELECT balance FROM balances WHERE user_id = ?");
    $balance_result->bind_param("i", $user_id);
    $balance_result->execute();
    $balance = $balance_result->get_result()->fetch_assoc();
    $current_balance = $balance ? $balance['balance'] : 0.00;
}


$last_bid_stmt = $conn->prepare("SELECT amount FROM bids WHERE product_id = ? ORDER BY created_at DESC LIMIT 1");
$last_bid_stmt->bind_param("i", $product_id);
$last_bid_stmt->execute();
$last_bid_result = $last_bid_stmt->get_result();
$last_bid = $last_bid_result->fetch_assoc();
$last_bid_amount = $last_bid ? $last_bid['amount'] : 0;
?>

<!DOCTYPE html>
<html lang="<?php echo htmlspecialchars($language); ?>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo htmlspecialchars($translations['product_details']); ?></title>
    <link rel="stylesheet" href="public/styles.css">
</head>
<body>
<header>
    <h1><?php echo htmlspecialchars($translations['product_details']); ?></h1>
    <a href="index.php"><?php echo htmlspecialchars($translations['back_to_home']); ?></a> |
    <a href="logout.php"><?php echo htmlspecialchars($translations['logout']); ?></a>
</header>

<div class="container">
    <div class="card">
        <h3><?php echo htmlspecialchars($product['title']); ?></h3>
        <p><strong><?php echo htmlspecialchars($translations['description']); ?>:</strong> <?php echo htmlspecialchars($product['description']); ?></p>
        <p><strong><?php echo htmlspecialchars($translations['price']); ?>:</strong> <?php echo htmlspecialchars($product['current_price'] ?? $product['start_price']); ?> USD</p>
        <?php if ($is_auction): ?>
            <p><strong><?php echo htmlspecialchars($translations['auction']); ?>:</strong> <?php echo htmlspecialchars($translations['yes']); ?></p>
            <p><strong><?php echo htmlspecialchars($translations['end_date']); ?>:</strong> <?php echo htmlspecialchars($product['end_date']); ?></p>
            <p><strong><?php echo htmlspecialchars($translations['your_balance']); ?>:</strong> <?php echo htmlspecialchars($current_balance); ?> USD</p>
        <?php else: ?>
            <p><strong><?php echo htmlspecialchars($translations['auction']); ?>:</strong> <?php echo htmlspecialchars($translations['no']); ?></p>
        <?php endif; ?>
    </div>

    <?php if ($is_auction && !empty($user_id)): ?>
        <div class="card">
            <h3><?php echo htmlspecialchars($translations['place_bid']); ?></h3>
            <form method="POST" action="place_bid.php">
                <input type="hidden" name="product_id" value="<?php echo $product_id; ?>">
                <div class="form-group">
                    <label for="bid_amount"><?php echo htmlspecialchars($translations['enter_bid']); ?>:</label>
                    <input type="number" id="bid_amount" name="bid_amount" step="0.01" required>
                </div>
                <div class="form-group">
                    <button type="submit" <?php echo $current_balance < 1 ? 'disabled' : ''; ?>><?php echo htmlspecialchars($translations['place_bid']); ?></button>
                </div>
            </form>
        </div>
    <?php endif; ?>

    <div class="card">
        <h3><?php echo htmlspecialchars($translations['seller_info']); ?></h3>
        <p><strong><?php echo htmlspecialchars($translations['seller']); ?>:</strong> <?php echo htmlspecialchars($product['username']); ?></p>
        <?php if ($user_id && $user_id != $product['user_id']): ?>
            <form method="POST" action="send_message.php">
                <textarea name="message" placeholder="<?php echo htmlspecialchars($translations['message_placeholder']); ?>" required></textarea>
                <input type="hidden" name="product_id" value="<?php echo $product_id; ?>">
                <input type="hidden" name="receiver_id" value="<?php echo $product['user_id']; ?>">
                <button type="submit"><?php echo htmlspecialchars($translations['send_message']); ?></button>
            </form>
        <?php endif; ?>
    </div>

    <div class="card">
        <h3><?php echo htmlspecialchars($translations['bid_history']); ?></h3>
        <table>
            <thead>
            <tr>
                <th><?php echo htmlspecialchars($translations['user']); ?></th>
                <th><?php echo htmlspecialchars($translations['amount']); ?></th>
                <th><?php echo htmlspecialchars($translations['date']); ?></th>
            </tr>
            </thead>
            <tbody>
            <?php
            $history_stmt = $conn->prepare("SELECT b.amount, u.username, b.created_at FROM bids b JOIN users u ON b.user_id = u.id WHERE b.product_id = ? ORDER BY b.created_at DESC");
            $history_stmt->bind_param("i", $product_id);
            $history_stmt->execute();
            $history_result = $history_stmt->get_result();

            if ($history_result->num_rows > 0):
                while ($bid = $history_result->fetch_assoc()): ?>
                    <tr>
                        <td><?php echo htmlspecialchars($bid['username']); ?></td>
                        <td><?php echo htmlspecialchars($bid['amount']); ?> USD</td>
                        <td><?php echo htmlspecialchars($bid['created_at']); ?></td>
                    </tr>
                <?php endwhile;
            else: ?>
                <tr>
                    <td colspan="3"><?php echo htmlspecialchars($translations['no_bids']); ?></td>
                </tr>
            <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
