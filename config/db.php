<?php
// config/db.php

$host = 'localhost';
$db = 'auction_db';
$user = 'root';
$pass = '';

// Создание подключения
$conn = new mysqli($host, $user, $pass, $db);

// Проверка подключения
if ($conn->connect_error) {
    die("Ошибка подключения: " . $conn->connect_error);
}

