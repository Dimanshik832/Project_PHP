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

if (empty($_SESSION['role']) || $_SESSION['role'] !== 'admin') {
    die($translations['access_denied']);
}

if (isset($_GET['delete']) && is_numeric($_GET['delete'])) {
    $productId = (int)$_GET['delete'];

    $stmt = $conn->prepare("SELECT user_id, amount FROM bids WHERE product_id = ? ORDER BY created_at DESC LIMIT 1");
    $stmt->bind_param("i", $productId);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $last_bid = $result->fetch_assoc();
        $last_user_id = $last_bid['user_id'];
        $last_bid_amount = $last_bid['amount'];

        $update_balance_stmt = $conn->prepare("UPDATE balances SET balance = balance + ? WHERE user_id = ?");
        $update_balance_stmt->bind_param("di", $last_bid_amount, $last_user_id);
        $update_balance_stmt->execute();
    }

    $conn->query("DELETE FROM bids WHERE product_id = $productId");

    $conn->query("DELETE FROM products WHERE id = $productId");

    header("Location: manage_products.php");
    exit();
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['product_id'], $_POST['category_id'])) {
    $productId = (int)$_POST['product_id'];
    $categoryId = (int)$_POST['category_id'];
    $conn->query("UPDATE products SET category_id = $categoryId WHERE id = $productId");
    header("Location: manage_products.php");
    exit();
}

$query = "SELECT c.id, COALESCE(ct.translated_name, c.name) AS category_name 
          FROM categories c 
          LEFT JOIN category_translations ct ON c.id = ct.category_id AND ct.language_code = ?";

$stmt = $conn->prepare($query);
$stmt->bind_param("s", $language);
$stmt->execute();
$result = $stmt->get_result();
?>

<!DOCTYPE html>
<html lang="<?php echo htmlspecialchars($language); ?>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo htmlspecialchars($translations['manage_products']); ?></title>
    <link rel="stylesheet" href="public/styles.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
</head>
<body>
<header class="main-header">
    <div class="container">
        <h1 class="site-title"><?php echo htmlspecialchars($translations['manage_products']); ?></h1>
        <nav class="user-navigation">
            <a href="admin_dashboard.php" class="nav-link"><?php echo htmlspecialchars($translations['back_to_dashboard']); ?></a>
            <a href="index.php" class="nav-link"><?php echo htmlspecialchars($translations['back_to_home']); ?></a>
        </nav>
    </div>
</header>

<main class="main-content">
    <section class="product-list">
        <table class="table">
            <thead>
            <tr>
                <th><?php echo htmlspecialchars($translations['id']); ?></th>
                <th><?php echo htmlspecialchars($translations['product_name']); ?></th>
                <th><?php echo htmlspecialchars($translations['current_price']); ?></th>
                <th><?php echo htmlspecialchars($translations['category']); ?></th>
                <th><?php echo htmlspecialchars($translations['auction']); ?></th>
                <th><?php echo htmlspecialchars($translations['actions']); ?></th>
            </tr>
            </thead>
            <tbody>
            <?php
            $result = $conn->query("
                SELECT 
                    p.id, 
                    p.title, 
                    p.current_price, 
                    p.is_auction, 
                    p.category_id, 
                    c.name AS category_name 
                FROM products p
                LEFT JOIN categories c ON p.category_id = c.id
            ");
            while ($row = $result->fetch_assoc()): ?>
                <tr>
                    <td><?php echo $row['id']; ?></td>
                    <td><?php echo htmlspecialchars($row['title']); ?></td>
                    <td><?php echo htmlspecialchars($row['current_price']); ?> USD</td>
                    <td>
                        <form method="POST" class="inline-form">
                            <select name="category_id" class="form-select">
                                <?php
                                $categories = $conn->query("SELECT c.id, COALESCE(ct.translated_name, c.name) AS category_name 
                                                            FROM categories c 
                                                            LEFT JOIN category_translations ct ON c.id = ct.category_id AND ct.language_code = '$language'");
                                while ($category = $categories->fetch_assoc()): ?>
                                    <option value="<?php echo $category['id']; ?>"
                                        <?php echo ($category['id'] == $row['category_id']) ? 'selected' : ''; ?>>
                                        <?php echo htmlspecialchars($category['category_name']); ?>
                                    </option>
                                <?php endwhile; ?>
                            </select>
                            <input type="hidden" name="product_id" value="<?php echo $row['id']; ?>">
                            <button type="submit" class="btn-primary"><?php echo htmlspecialchars($translations['save']); ?></button>
                        </form>
                    </td>
                    <td><?php echo $row['is_auction'] ? $translations['yes'] : $translations['no']; ?></td>
                    <td>
                        <a href="?delete=<?php echo $row['id']; ?>" class="btn-danger" onclick="return confirm('<?php echo htmlspecialchars($translations['delete_confirmation']); ?>');"><?php echo htmlspecialchars($translations['delete']); ?></a>
                    </td>
                </tr>
            <?php endwhile; ?>
            </tbody>
        </table>
    </section>
</main>
</body>
</html>
