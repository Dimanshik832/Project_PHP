<?php
session_start();
require_once 'config/db.php';

$language = $_GET['lang'] ?? $_SESSION['lang'] ?? 'en';
$_SESSION['lang'] = $language;
$translations = require "translations/{$language}.php";

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = trim($_POST['username'] ?? '');
    $email = trim($_POST['email'] ?? '');
    $password = trim($_POST['password'] ?? '');

    if ($username && $email && $password) {
        $hashed_password = password_hash($password, PASSWORD_DEFAULT);

        $check_stmt = $conn->prepare("SELECT id FROM users WHERE email = ? OR username = ?");
        $check_stmt->bind_param("ss", $email, $username);
        $check_stmt->execute();
        $check_result = $check_stmt->get_result();

        if ($check_result->num_rows > 0) {
            $error_message = $translations['user_exists'];
        } else {
            $stmt = $conn->prepare("INSERT INTO users (username, email, password, role) VALUES (?, ?, ?, 'user')");
            $stmt->bind_param("sss", $username, $email, $hashed_password);

            if ($stmt->execute()) {
                $success_message = $translations['registration_success'] . " <a href='login.php'>" . $translations['login'] . "</a>";
            } else {
                $error_message = $translations['error'] . ": " . htmlspecialchars($stmt->error);
            }
        }
    } else {
        $error_message = $translations['fill_all_fields'];
    }
}
?>

<!DOCTYPE html>
<html lang="<?php echo htmlspecialchars($language); ?>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo htmlspecialchars($translations['register']); ?></title>
    <link rel="stylesheet" href="public/styles.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
</head>
<body>
<header class="main-header">
    <div class="container">
        <h1 class="site-title"><?php echo htmlspecialchars($translations['register']); ?></h1>
        <div class="language-switch">
            <a href="?lang=en" class="lang-link">English</a>
            <a href="?lang=ru" class="lang-link">Русский</a>
            <a href="?lang=pl" class="lang-link">Polski</a>
        </div>
    </div>
</header>

<main class="main-content">
    <section class="form-container">
        <?php if (!empty($success_message)): ?>
            <div class="success-message"><?php echo $success_message; ?></div>
        <?php elseif (!empty($error_message)): ?>
            <div class="error-message"><?php echo $error_message; ?></div>
        <?php endif; ?>

        <form method="POST" action="register.php" class="form">
            <div class="form-group">
                <label for="username"><?php echo htmlspecialchars($translations['username']); ?>:</label>
                <input type="text" id="username" name="username" class="form-input" placeholder="<?php echo htmlspecialchars($translations['enter_username']); ?>" required>
            </div>

            <div class="form-group">
                <label for="email"><?php echo htmlspecialchars($translations['email']); ?>:</label>
                <input type="email" id="email" name="email" class="form-input" placeholder="<?php echo htmlspecialchars($translations['enter_email']); ?>" required>
            </div>

            <div class="form-group">
                <label for="password"><?php echo htmlspecialchars($translations['password']); ?>:</label>
                <input type="password" id="password" name="password" class="form-input" placeholder="<?php echo htmlspecialchars($translations['enter_password']); ?>" required>
            </div>

            <button type="submit" class="btn-primary"><?php echo htmlspecialchars($translations['register_button']); ?></button>
        </form>

        <div class="form-footer">
            <p><?php echo htmlspecialchars($translations['already_have_account']); ?> <a href="login.php" class="form-link"><?php echo htmlspecialchars($translations['login']); ?></a></p>
        </div>
    </section>
</main>
</body>
</html>
