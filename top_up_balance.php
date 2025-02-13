<?php
session_start();
require_once 'config/db.php';

if (empty($_SESSION['user_id'])) {
    header("Location: login.php");
    exit();
}

if (isset($_GET['lang'])) {
    $language = $_GET['lang'];
    $_SESSION['lang'] = $language;
} else {
    $language = $_SESSION['lang'] ?? 'en';
}

$translations = require "translations/{$language}.php";
$user_id = $_SESSION['user_id'];

$balance_result = $conn->query("SELECT balance FROM balances WHERE user_id = $user_id");
$balance = $balance_result->fetch_assoc();
$current_balance = $balance ? $balance['balance'] : 0.00;


if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $amount_to_add = $_POST['amount'] ?? 0;

    if ($amount_to_add > 0) {
        if ($balance) {
            $new_balance = $current_balance + $amount_to_add;
            $update_balance_stmt = $conn->prepare("UPDATE balances SET balance = ? WHERE user_id = ?");
            $update_balance_stmt->bind_param("di", $new_balance, $user_id);
            $update_balance_stmt->execute();
        } else {
            $insert_balance_stmt = $conn->prepare("INSERT INTO balances (user_id, balance) VALUES (?, ?)");
            $insert_balance_stmt->bind_param("id", $user_id, $amount_to_add);
            $insert_balance_stmt->execute();
        }

        header("Location: profile.php");
        exit();
    } else {
        $error_message = $translations['positive_amount_required'];
    }
}
?>

<!DOCTYPE html>
<html lang="<?php echo htmlspecialchars($language); ?>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo htmlspecialchars($translations['top_up_balance']); ?></title>
    <link rel="stylesheet" href="public/styles.css">
</head>
<body>
<header class="main-header">
    <div class="container">
        <h1 class="site-title"><?php echo htmlspecialchars($translations['top_up_balance']); ?></h1>
        <nav class="user-navigation">
            <a href="index.php" class="nav-link"><?php echo htmlspecialchars($translations['back_to_home']); ?></a>
            <a href="profile.php" class="nav-link"><?php echo htmlspecialchars($translations['my_profile']); ?></a>
        </nav>
        <div class="language-switch">
            <a href="?lang=en" class="lang-link">English</a>
            <a href="?lang=ru" class="lang-link">Русский</a>
            <a href="?lang=pl" class="lang-link">Polski</a>
        </div>
    </div>
</header>

<main class="container">
    <div class="card">
        <h2><?php echo htmlspecialchars($translations['current_balance']); ?>: <?php echo htmlspecialchars($current_balance); ?> USD</h2>

        <?php if (!empty($error_message)): ?>
            <p class="error"><?php echo htmlspecialchars($error_message); ?></p>
        <?php endif; ?>

        <form method="POST" class="form-container">
            <div class="form-group">
                <label for="amount"><?php echo htmlspecialchars($translations['enter_amount']); ?>:</label>
                <input type="number" id="amount" name="amount" step="0.01" min="1" class="form-input" placeholder="<?php echo htmlspecialchars($translations['amount_placeholder']); ?>" required>
            </div>
            <button type="submit" class="btn-submit"><?php echo htmlspecialchars($translations['top_up_balance']); ?></button>
        </form>
    </div>
</main>
</body>
</html>
