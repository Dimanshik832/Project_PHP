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

if (empty($_SESSION['user_id']) || $_SESSION['role'] !== 'admin') {
    header("Location: login.php");
    exit();
}
?>

<!DOCTYPE html>
<html lang="<?php echo htmlspecialchars($language); ?>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo htmlspecialchars($translations['admin_dashboard']); ?></title>
    <link rel="stylesheet" href="public/styles.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
</head>
<body>
<header class="main-header">
    <div class="container">
        <h1 class="site-title"><?php echo htmlspecialchars($translations['admin_dashboard']); ?></h1>
        <p class="welcome-message">
            <?php echo htmlspecialchars($translations['welcome']); ?>, <strong><?php echo htmlspecialchars($_SESSION['username']); ?></strong>!
        </p>
        <nav class="admin-navigation">
            <a href="index.php" class="nav-link"><?php echo htmlspecialchars($translations['home']); ?></a>
            <a href="logout.php" class="nav-link"><?php echo htmlspecialchars($translations['logout']); ?></a>
        </nav>
        <div class="language-switch">
            <a href="?lang=en" class="lang-link">English</a>
            <a href="?lang=ru" class="lang-link">Русский</a>
            <a href="?lang=pl" class="lang-link">Polski</a>
        </div>
    </div>
</header>

<main class="main-content container">
    <section class="user-management">
        <h2><?php echo htmlspecialchars($translations['user_management']); ?></h2>
        <table class="table">
            <thead>
            <tr>
                <th><?php echo htmlspecialchars($translations['id']); ?></th>
                <th><?php echo htmlspecialchars($translations['username']); ?></th>
                <th><?php echo htmlspecialchars($translations['email']); ?></th>
                <th><?php echo htmlspecialchars($translations['role']); ?></th>
                <th><?php echo htmlspecialchars($translations['actions']); ?></th>
            </tr>
            </thead>
            <tbody>
            <?php
            $result = $conn->query("SELECT id, username, email, role FROM users");
            while ($user = $result->fetch_assoc()): ?>
                <tr>
                    <td><?php echo htmlspecialchars($user['id']); ?></td>
                    <td><?php echo htmlspecialchars($user['username']); ?></td>
                    <td><?php echo htmlspecialchars($user['email']); ?></td>
                    <td><?php echo htmlspecialchars($user['role']); ?></td>
                    <td>
                        <?php if ($user['role'] !== 'admin'): ?>
                            <a href="change_role.php?id=<?php echo $user['id']; ?>&role=admin" class="btn-action"><?php echo htmlspecialchars($translations['make_admin']); ?></a>
                            <a href="delete_user.php?id=<?php echo $user['id']; ?>" onclick="return confirm('<?php echo htmlspecialchars($translations['delete_confirmation']); ?>');" class="btn-danger"><?php echo htmlspecialchars($translations['delete']); ?></a>
                        <?php else: ?>
                            <span class="badge-admin"><?php echo htmlspecialchars($translations['admin']); ?></span>
                        <?php endif; ?>
                    </td>
                </tr>
            <?php endwhile; ?>
            </tbody>
        </table>
    </section>

    <section class="management-links">
        <center><h2><?php echo htmlspecialchars($translations['management']); ?></h2></center>
        <div class="card-container">
            <div class="card">
                <h3><?php echo htmlspecialchars($translations['category_management']); ?></h3>
                <a href="manage_categories.php" class="btn-primary"><?php echo htmlspecialchars($translations['manage_categories']); ?></a>
            </div>
            <div class="card">
                <h3><?php echo htmlspecialchars($translations['product_management']); ?></h3>
                <a href="manage_products.php" class="btn-primary"><?php echo htmlspecialchars($translations['manage_products']); ?></a>
            </div>
            <div class="card">
                <h3><?php echo htmlspecialchars($translations['product_verification']); ?></h3>
                <a href="admin_verify_products.php" class="btn-primary"><?php echo htmlspecialchars($translations['verify_products']); ?></a>
            </div>
            <div class="card">
                <h3><?php echo htmlspecialchars($translations['money_transfer']); ?></h3>
                <a href="check_auction_end.php" class="btn-primary"><?php echo htmlspecialchars($translations['end_auction']); ?></a>
            </div>
        </div>
    </section>
</main>
</body>
</html>
