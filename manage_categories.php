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
    die($translations['access_denied']);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['category_name'])) {
    $category_name = $_POST['category_name'];

    if (!empty($category_name)) {
        $stmt = $conn->prepare("INSERT INTO categories (name) VALUES (?)");
        $stmt->bind_param("s", $category_name);

        if ($stmt->execute()) {
            $category_id = $conn->insert_id;

            $stmt_translation = $conn->prepare("INSERT INTO category_translations (category_id, language_code, translated_name) VALUES (?, ?, ?)");
            $stmt_translation->bind_param("iss", $category_id, $language, $category_name);
            $stmt_translation->execute();

            $success_message = $translations['category_added_success'];
        } else {
            $error_message = $translations['category_add_error'];
        }
    } else {
        $error_message = $translations['category_name_empty'];
    }
}

if (isset($_GET['delete']) && is_numeric($_GET['delete'])) {
    $category_id = $_GET['delete'];

    $stmt_check = $conn->prepare("SELECT COUNT(*) FROM products WHERE category_id = ?");
    $stmt_check->bind_param("i", $category_id);
    $stmt_check->execute();
    $stmt_check->bind_result($count);
    $stmt_check->fetch();
    $stmt_check->close();

    if ($count > 0) {
        $error_message = $translations['category_in_use_error'];
    } else {
        $stmt_delete = $conn->prepare("DELETE FROM categories WHERE id = ?");
        $stmt_delete->bind_param("i", $category_id);

        if ($stmt_delete->execute()) {
            $stmt_delete_translation = $conn->prepare("DELETE FROM category_translations WHERE category_id = ?");
            $stmt_delete_translation->bind_param("i", $category_id);
            $stmt_delete_translation->execute();

            $success_message = $translations['category_deleted_success'];
        } else {
            $error_message = $translations['category_delete_error'];
        }
    }
}

$category_query = "SELECT c.id, IFNULL(ct.translated_name, c.name) AS name
                   FROM categories c
                   LEFT JOIN category_translations ct ON c.id = ct.category_id AND ct.language_code = ?";
$stmt = $conn->prepare($category_query);
$stmt->bind_param('s', $language);
$stmt->execute();
$categories = $stmt->get_result();
?>

<!DOCTYPE html>
<html lang="<?php echo htmlspecialchars($language); ?>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo htmlspecialchars($translations['manage_categories']); ?></title>
    <link rel="stylesheet" href="public/styles.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
</head>
<body>
<header class="main-header">
    <div class="container">
        <h1 class="site-title"><?php echo htmlspecialchars($translations['manage_categories']); ?></h1>
        <nav class="user-navigation">
            <a href="admin_dashboard.php" class="nav-link"><?php echo htmlspecialchars($translations['back_to_dashboard']); ?></a>
            <a href="index.php" class="nav-link"><?php echo htmlspecialchars($translations['back_to_home']); ?></a>
        </nav>
    </div>
</header>

<main class="main-content">
    <?php if (!empty($success_message)): ?>
        <div class="alert alert-success">
            <?php echo htmlspecialchars($success_message); ?>
        </div>
    <?php endif; ?>

    <?php if (!empty($error_message)): ?>
        <div class="alert alert-error">
            <?php echo htmlspecialchars($error_message); ?>
        </div>
    <?php endif; ?>

    <section class="category-list">
        <h2><?php echo htmlspecialchars($translations['category_list']); ?></h2>
        <table class="table">
            <thead>
            <tr>
                <th><?php echo htmlspecialchars($translations['id']); ?></th>
                <th><?php echo htmlspecialchars($translations['category_name']); ?></th>
                <th><?php echo htmlspecialchars($translations['actions']); ?></th>
            </tr>
            </thead>
            <tbody>
            <?php while ($row = $categories->fetch_assoc()): ?>
                <tr>
                    <td><?php echo htmlspecialchars($row['id']); ?></td>
                    <td><?php echo htmlspecialchars($row['name']); ?></td>
                    <td>
                        <a href="?delete=<?php echo $row['id']; ?>" class="btn-danger" onclick="return confirm('<?php echo htmlspecialchars($translations['delete_confirmation']); ?>');"><?php echo htmlspecialchars($translations['delete']); ?></a>
                    </td>
                </tr>
            <?php endwhile; ?>
            </tbody>
        </table>
    </section>

    <section class="add-category">
        <h2><?php echo htmlspecialchars($translations['add_category']); ?></h2>
        <form method="POST" action="" class="form-container">
            <div class="form-group">
                <label for="category_name"><?php echo htmlspecialchars($translations['category_name']); ?></label>
                <input type="text" id="category_name" name="category_name" class="form-input" required>
            </div>
            <button type="submit" class="btn-primary"><?php echo htmlspecialchars($translations['add']); ?></button>
        </form>
    </section>

    <div class="language-switch">
        <a href="?lang=en" class="lang-link">English</a>
        <a href="?lang=ru" class="lang-link">Русский</a>
        <a href="?lang=pl" class="lang-link">Polski</a>
    </div>
</main>
</body>
</html>
