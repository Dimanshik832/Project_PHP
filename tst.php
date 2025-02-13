<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Тест уведомлений</title>
</head>
<body>
<h1>Тест уведомлений</h1>

<form method="POST" action="email_notifications.php">
    <h3>Новое сообщение:</h3>
    <input type="hidden" name="new_message" value="1">
    <label for="receiver_id">ID получателя: </label>
    <input type="number" name="receiver_id" required>
    <button type="submit">Отправить сообщение</button>
</form>

<form method="POST" action="email_notifications.php">
    <h3>Перебитая ставка:</h3>
    <input type="hidden" name="bid_beat" value="1">
    <label for="product_id">ID товара: </label>
    <input type="number" name="product_id" required>
    <label for="bid_amount">Ставка: </label>
    <input type="number" name="bid_amount" required>
    <button type="submit">Перебить ставку</button>
</form>

<form method="POST" action="email_notifications.php">
    <h3>Завершение аукциона:</h3>
    <input type="hidden" name="auction_end" value="1">
    <button type="submit">Завершить аукцион</button>
</form>
</body>
</html>
