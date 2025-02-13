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

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = $_POST['email'];
    $password = $_POST['password'];

    $stmt = $conn->prepare("SELECT id, username, password, role FROM users WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $stmt->store_result();

    if ($stmt->num_rows > 0) {
        $stmt->bind_result($id, $username, $hashed_password, $role);
        $stmt->fetch();

        if (password_verify($password, $hashed_password)) {
            $_SESSION['user_id'] = $id;
            $_SESSION['username'] = $username;
            $_SESSION['role'] = $role;

            if ($role === 'admin') {
                header("Location: admin_dashboard.php");
            } else {
                header("Location: index.php");
            }
            exit();
        } else {
            $error = $translations['wrong_password'];
        }
    } else {
        $error = $translations['user_not_found'];
    }
}
?>

<!DOCTYPE html>
<html lang="<?php echo htmlspecialchars($language); ?>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo htmlspecialchars($translations['login_title']); ?></title>
    <link rel="stylesheet" href="public/styles.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
</head>
<body>
<header class="main-header">
    <div class="container">
        <h1 class="site-title"><?php echo htmlspecialchars($translations['login_title']); ?></h1>
        <div class="language-switch">
            <a href="?lang=en" class="lang-link">English</a>
            <a href="?lang=ru" class="lang-link">Русский</a>
            <a href="?lang=pl" class="lang-link">Polski</a>
        </div>
    </div>
</header>

<main class="main-content">
    <section class="form-container">
        <?php if (!empty($error)): ?>
            <div class="error-message">
                <?php echo htmlspecialchars($error); ?>
            </div>
        <?php endif; ?>

        <form method="POST" action="login.php" class="form">
            <div class="form-group">
                <label for="email"><?php echo htmlspecialchars($translations['email']); ?>:</label>
                <input type="email" id="email" name="email" class="form-input" placeholder="<?php echo htmlspecialchars($translations['enter_email']); ?>" required>
            </div>

            <div class="form-group">
                <label for="password"><?php echo htmlspecialchars($translations['password']); ?>:</label>
                <input type="password" id="password" name="password" class="form-input" placeholder="<?php echo htmlspecialchars($translations['enter_password']); ?>" required>
            </div>

            <button type="submit" class="btn-primary"><?php echo htmlspecialchars($translations['login_button']); ?></button>
        </form>

        <div class="form-footer">
            <p><?php echo htmlspecialchars($translations['no_account']); ?> <a href="register.php" class="form-link"><?php echo htmlspecialchars($translations['register']); ?></a></p>
        </div>
    </section>
</main>
</body>
</html>
