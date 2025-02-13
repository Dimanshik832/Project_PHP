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
?>

<!DOCTYPE html>
<html lang="<?php echo htmlspecialchars($language); ?>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo htmlspecialchars($translations['welcome']); ?></title>
    <link rel="stylesheet" href="public/styles.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
</head>
<body>
<header class="main-header">
    <div class="container">
        <h1 class="site-title"><?php echo htmlspecialchars($translations['welcome']); ?></h1>
        <nav class="user-navigation">
            <?php if (!empty($_SESSION['username'])): ?>
                <span class="user-greeting"><?php echo htmlspecialchars($translations['hello']); ?>, <?php echo htmlspecialchars($_SESSION['username']); ?>!</span>
                <a href="admin_dashboard.php" class="nav-link"><?php echo htmlspecialchars($translations['admin_dashboard']); ?></a>
                <a href="profile.php" class="nav-link"><?php echo htmlspecialchars($translations['profile']); ?></a>
                <a href="add_product.php" class="nav-link"><?php echo htmlspecialchars($translations['add_product']); ?></a>
                <a href="logout.php" class="nav-link"><?php echo htmlspecialchars($translations['logout']); ?></a>
            <?php else: ?>
                <a href="login.php" class="nav-link"><?php echo htmlspecialchars($translations['login']); ?></a>
                <a href="register.php" class="nav-link"><?php echo htmlspecialchars($translations['register']); ?></a>
            <?php endif; ?>
            <a href="?lang=en" class="lang-link">English</a>
            <a href="?lang=ru" class="lang-link">Русский</a>
            <a href="?lang=pl" class="lang-link">Polski</a>
        </nav>
    </div>
</header>

<main class="main-content container">
    <section class="product-filter">
        <h2><?php echo htmlspecialchars($translations['product_list']); ?></h2>
        <form method="GET" action="index.php" class="filter-form">
            <div class="form-group">
                <input type="text" name="search_keyword" class="form-input" placeholder="<?php echo htmlspecialchars($translations['search_placeholder']); ?>" value="<?php echo htmlspecialchars($_GET['search_keyword'] ?? ''); ?>">
            </div>
            <div class="form-group">
                <select name="category_filter" class="form-select">
                    <option value=""><?php echo htmlspecialchars($translations['all_categories']); ?></option>
                    <?php
                    $category_query = "SELECT c.id, IFNULL(ct.translated_name, c.name) AS name
                                       FROM categories c
                                       LEFT JOIN category_translations ct ON c.id = ct.category_id AND ct.language_code = ?";
                    $stmt = $conn->prepare($category_query);
                    $stmt->bind_param('s', $language);
                    $stmt->execute();
                    $categories = $stmt->get_result();
                    while ($category = $categories->fetch_assoc()):
                        echo "<option value='{$category['id']}'" . (isset($_GET['category_filter']) && $_GET['category_filter'] == $category['id'] ? " selected" : "") . ">" . htmlspecialchars($category['name']) . "</option>";
                    endwhile;
                    ?>
                </select>
            </div>
            <div class="form-group">
                <input type="number" name="min_price" class="form-input" placeholder="<?php echo htmlspecialchars($translations['min_price']); ?>" value="<?php echo htmlspecialchars($_GET['min_price'] ?? ''); ?>">
            </div>
            <div class="form-group">
                <input type="number" name="max_price" class="form-input" placeholder="<?php echo htmlspecialchars($translations['max_price']); ?>" value="<?php echo htmlspecialchars($_GET['max_price'] ?? ''); ?>">
            </div>
            <button type="submit" class="btn-submit"><?php echo htmlspecialchars($translations['apply_filters']); ?></button>
        </form>
    </section>

    <section class="product-grid">
        <?php
        $category_filter = $_GET['category_filter'] ?? '';
        $min_price = $_GET['min_price'] ?? '';
        $max_price = $_GET['max_price'] ?? '';
        $search_keyword = $_GET['search_keyword'] ?? '';

        $query = "SELECT p.id, p.title, p.current_price, p.image, p.category_id, 
                         IFNULL(ct.translated_name, c.name) AS category_name
                  FROM products p
                  LEFT JOIN categories c ON p.category_id = c.id
                  LEFT JOIN category_translations ct ON c.id = ct.category_id AND ct.language_code = ?
                  WHERE p.is_auction = 1 AND p.is_verified = 1 AND p.end_date > NOW()";

        $params = [$language];
        if ($category_filter) {
            $query .= " AND p.category_id = ?";
            $params[] = $category_filter;
        }
        if ($min_price) {
            $query .= " AND p.current_price >= ?";
            $params[] = $min_price;
        }
        if ($max_price) {
            $query .= " AND p.current_price <= ?";
            $params[] = $max_price;
        }
        if ($search_keyword) {
            $query .= " AND p.title LIKE ?";
            $params[] = "%$search_keyword%";
        }

        $stmt = $conn->prepare($query);
        $stmt->bind_param(str_repeat('s', count($params)), ...$params);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows > 0): ?>
            <?php while ($row = $result->fetch_assoc()): ?>
                <div class="product-card">
                    <img src="<?php echo htmlspecialchars($row['image'] ?: 'img/no_image.jpg'); ?>" alt="<?php echo htmlspecialchars($row['title']); ?>" class="product-image">
                    <h3 class="product-title"><?php echo htmlspecialchars($row['title']); ?></h3>
                    <p class="product-price"><?php echo htmlspecialchars($row['current_price']); ?> USD</p>
                    <p class="product-category"><?php echo htmlspecialchars($translations['category']); ?>: <?php echo htmlspecialchars($row['category_name']); ?></p>
                    <a href="product_details.php?id=<?php echo $row['id']; ?>" class="btn-details"><?php echo htmlspecialchars($translations['details']); ?></a>
                </div>
            <?php endwhile; ?>
        <?php else: ?>
            <p class="no-products"><?php echo htmlspecialchars($translations['no_products']); ?></p>
        <?php endif; ?>
    </section>
</main>
</body>
</html>

