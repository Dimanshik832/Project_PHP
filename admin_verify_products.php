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

if ($_SESSION['role'] !== 'admin') {
    header('Location: index.php');
    exit();
}

if (isset($_GET['action']) && isset($_GET['product_id'])) {
    $action = $_GET['action'];
    $product_id = $_GET['product_id'];

    if ($action === 'verify') {
        $stmt = $conn->prepare("UPDATE products SET is_verified = 1 WHERE id = ?");
        $stmt->bind_param("i", $product_id);
        $stmt->execute();
    } elseif ($action === 'delete') {
        $stmt = $conn->prepare("DELETE FROM products WHERE id = ?");
        $stmt->bind_param("i", $product_id);
        $stmt->execute();
    }
}

$query = "SELECT p.id, p.title, p.description, p.start_price, p.current_price, p.end_date, p.image, p.category_id, p.user_id, c.name AS category_name, u.username 
          FROM products p 
          JOIN categories c ON p.category_id = c.id
          JOIN users u ON p.user_id = u.id 
          WHERE p.is_verified = 0";

$result = $conn->query($query);
?>

<!DOCTYPE html>
<html lang="<?php echo htmlspecialchars($language); ?>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo htmlspecialchars($translations['verify_products']); ?></title>
    <link rel="stylesheet" href="public/styles.css">
</head>
<body>

<header class="main-header">
    <div class="container">
        <h1 class="site-title"><?php echo htmlspecialchars($translations['verify_products']); ?></h1>
        <nav class="user-navigation">
            <a href="admin_dashboard.php" class="nav-link"><?php echo htmlspecialchars($translations['back_to_dashboard']); ?></a>
            <a href="index.php" class="nav-link"><?php echo htmlspecialchars($translations['back_to_home']); ?></a>
        </nav>
    </div>
</header>

<main class="main-content container">
    <div class="table-container">
        <table class="table">
            <thead>
            <tr>
                <th><?php echo htmlspecialchars($translations['title']); ?></th>
                <th><?php echo htmlspecialchars($translations['description']); ?></th>
                <th><?php echo htmlspecialchars($translations['start_price']); ?></th>
                <th><?php echo htmlspecialchars($translations['current_price']); ?></th>
                <th><?php echo htmlspecialchars($translations['end_date']); ?></th>
                <th><?php echo htmlspecialchars($translations['image']); ?></th>
                <th><?php echo htmlspecialchars($translations['category']); ?></th>
                <th><?php echo htmlspecialchars($translations['user']); ?></th>
                <th><?php echo htmlspecialchars($translations['actions']); ?></th>
            </tr>
            </thead>
            <tbody>
            <?php if ($result->num_rows > 0): ?>
                <?php while ($row = $result->fetch_assoc()): ?>
                    <tr>
                        <td><?php echo htmlspecialchars($row['title']); ?></td>
                        <td><?php echo htmlspecialchars($row['description']); ?></td>
                        <td><?php echo htmlspecialchars($row['start_price']) . " USD"; ?></td>
                        <td><?php echo htmlspecialchars($row['current_price']) . " USD"; ?></td>
                        <td><?php echo htmlspecialchars($row['end_date']); ?></td>
                        <td><img src="<?php echo $row['image'] ?: 'img/no_image.jpg'; ?>" alt="Фото товара" class="product-image"></td>
                        <td><?php echo htmlspecialchars($row['category_name']); ?></td>
                        <td><?php echo htmlspecialchars($row['username']); ?></td>
                        <td class="actions">
                            <a href="admin_verify_products.php?action=verify&product_id=<?php echo $row['id']; ?>" class="btn-action"><?php echo htmlspecialchars($translations['verify']); ?></a>
                            <a href="admin_verify_products.php?action=delete&product_id=<?php echo $row['id']; ?>" class="btn-danger" onclick="return confirm('<?php echo htmlspecialchars($translations['delete_confirmation']); ?>');"><?php echo htmlspecialchars($translations['delete']); ?></a>
                        </td>
                    </tr>
                <?php endwhile; ?>
            <?php else: ?>
                <tr>
                    <td colspan="9"><?php echo htmlspecialchars($translations['no_products']); ?></td>
                </tr>
            <?php endif; ?>
            </tbody>
        </table>
    </div>
</main>
</body>
</html>
