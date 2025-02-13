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

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['title'], $_POST['description'], $_POST['start_price'], $_POST['end_date'], $_POST['category_id'])) {
    $title = $_POST['title'];
    $description = $_POST['description'];
    $start_price = $_POST['start_price'];
    $end_date = $_POST['end_date'];
    $category_id = $_POST['category_id'];

    $image = null;
    if (isset($_FILES['image']) && $_FILES['image']['error'] === UPLOAD_ERR_OK) {
        $image = 'uploads/' . basename($_FILES['image']['name']);
        move_uploaded_file($_FILES['image']['tmp_name'], $image);
    }

    $stmt = $conn->prepare("INSERT INTO products (title, description, start_price, current_price, user_id, is_auction, is_verified, end_date, image, category_id) 
                        VALUES (?, ?, ?, ?, ?, 1, 0, ?, ?, ?)");
    $stmt->bind_param("ssddissi", $title, $description, $start_price, $start_price, $_SESSION['user_id'], $end_date, $image, $category_id);

    if ($stmt->execute()) {
        echo "<script type='text/javascript'>
                window.onload = function() {
                    var notification = document.createElement('div');
                    notification.className = 'notification';
                    notification.innerHTML = '{$translations['product_added_for_verification']}';
                    document.body.appendChild(notification);
                    notification.style.display = 'block';
                    setTimeout(function() {
                        notification.style.display = 'none';
                    }, 5000);
                };
              </script>";
    } else {
        echo "<script type='text/javascript'>
                window.onload = function() {
                    alert('{$translations['error']}');
                };
              </script>";
    }
}
?>

<!DOCTYPE html>
<html lang="<?php echo htmlspecialchars($language); ?>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo htmlspecialchars($translations['add_product']); ?></title>
    <link rel="stylesheet" href="public/styles.css">
    <style>
        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            background-color: #4CAF50;
            color: white;
            padding: 15px;
            border-radius: 5px;
            display: none;
            z-index: 1000;
        }
    </style>
</head>
<body>
<header>
    <h1><?php echo htmlspecialchars($translations['add_product']); ?></h1>
    <a href="index.php"><?php echo htmlspecialchars($translations['back_to_home']); ?></a> |
    <a href="logout.php"><?php echo htmlspecialchars($translations['logout']); ?></a>
</header>

<main class="main-content container">
    <section class="form-section">
        <form method="POST" action="" enctype="multipart/form-data" class="form-container">
            <div class="form-group">
                <label for="title"><?php echo htmlspecialchars($translations['title']); ?>:</label>
                <input type="text" id="title" name="title" class="form-input" required>
            </div>

            <div class="form-group">
                <label for="description"><?php echo htmlspecialchars($translations['description']); ?>:</label>
                <textarea id="description" name="description" class="form-textarea" required></textarea>
            </div>

            <div class="form-group">
                <label for="start_price"><?php echo htmlspecialchars($translations['start_price']); ?>:</label>
                <input type="number" id="start_price" name="start_price" class="form-input" step="0.01" required>
            </div>

            <div class="form-group">
                <label for="end_date"><?php echo htmlspecialchars($translations['end_date']); ?>:</label>
                <input type="datetime-local" id="end_date" name="end_date" class="form-input" required>
            </div>

            <div class="form-group">
                <label for="category_id"><?php echo htmlspecialchars($translations['category']); ?>:</label>
                <select id="category_id" name="category_id" class="form-select" required>
                    <option value=""><?php echo htmlspecialchars($translations['select_category']); ?></option>
                    <?php
                    $category_query = "SELECT c.id, IFNULL(ct.translated_name, c.name) AS name FROM categories c
                                       LEFT JOIN category_translations ct ON c.id = ct.category_id AND ct.language_code = ?";
                    $stmt = $conn->prepare($category_query);
                    $stmt->bind_param('s', $language);
                    $stmt->execute();
                    $categories = $stmt->get_result();
                    while ($category = $categories->fetch_assoc()): ?>
                        <option value="<?php echo $category['id']; ?>">
                            <?php echo htmlspecialchars($category['name']); ?>
                        </option>
                    <?php endwhile; ?>
                </select>
            </div>

            <div class="form-group">
                <label for="image"><?php echo htmlspecialchars($translations['product_image']); ?>:</label>
                <input type="file" id="image" name="image" class="form-input" accept="image/*">
            </div>

            <button type="submit" class="btn-submit"><?php echo htmlspecialchars($translations['add_product_button']); ?></button>
        </form>
        <a href="index.php" class="back-link"><?php echo htmlspecialchars($translations['back_to_home']); ?></a>
    </section>
</main>
</body>
</html>


