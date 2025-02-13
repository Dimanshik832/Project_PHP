-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Время создания: Фев 13 2025 г., 07:20
-- Версия сервера: 10.4.32-MariaDB
-- Версия PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `auction_db`
--

-- --------------------------------------------------------

--
-- Структура таблицы `auctions`
--

CREATE TABLE `auctions` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `current_bid` decimal(10,2) DEFAULT 0.00,
  `bid_count` int(11) DEFAULT 0,
  `end_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `balances`
--

CREATE TABLE `balances` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `balance` decimal(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `balances`
--

INSERT INTO `balances` (`id`, `user_id`, `balance`) VALUES
(2, 6, 126422.00),
(3, 7, 99999999.99),
(4, 9, 100.00),
(5, 10, 115.00),
(7, 13, 10000.00);

-- --------------------------------------------------------

--
-- Структура таблицы `bids`
--

CREATE TABLE `bids` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `bids`
--

INSERT INTO `bids` (`id`, `product_id`, `user_id`, `amount`, `created_at`) VALUES
(73, 45, 10, 30.00, '2025-01-24 00:36:38'),
(75, 46, 10, 3.00, '2025-01-24 00:53:38'),
(78, 46, 9, 50.00, '2025-01-24 01:01:46'),
(79, 47, 10, 123.00, '2025-01-24 08:54:57'),
(80, 49, 9, 150.00, '2025-01-24 09:02:39'),
(81, 47, 9, 125.00, '2025-01-24 09:14:10'),
(82, 47, 10, 126.00, '2025-01-24 09:22:47'),
(84, 52, 6, 10.00, '2025-01-24 09:31:55'),
(88, 53, 6, 15.00, '2025-01-25 23:40:45');

-- --------------------------------------------------------

--
-- Структура таблицы `blocked_users`
--

CREATE TABLE `blocked_users` (
  `id` int(11) NOT NULL,
  `blocker_id` int(11) NOT NULL,
  `blocked_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `blocked_users`
--

INSERT INTO `blocked_users` (`id`, `blocker_id`, `blocked_id`) VALUES
(1, 6, 7);

-- --------------------------------------------------------

--
-- Структура таблицы `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `parent_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `categories`
--

INSERT INTO `categories` (`id`, `name`, `parent_id`) VALUES
(1, 'Electronics', NULL),
(2, 'Clothing', NULL),
(3, 'Books', NULL),
(4, 'Home appliances', NULL),
(5, 'Computers and accessories', NULL),
(6, 'Mobile phones', NULL),
(7, 'Shoes', NULL),
(8, 'Accessories', NULL),
(9, 'Toys', NULL),
(10, 'Sports and outdoors', NULL),
(11, 'Health and beauty', NULL),
(12, 'Home and garden', NULL),
(13, 'Food products', NULL),
(14, 'Automobiles and motorcycles', NULL),
(15, 'Musical Instruments', NULL),
(16, 'Antiques', NULL),
(17, 'Collectibles', NULL),
(18, 'Art and Antiques', NULL),
(19, 'Pet supplies\n', NULL),
(20, 'Furniture', NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `category_translations`
--

CREATE TABLE `category_translations` (
  `id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `language_code` varchar(2) NOT NULL,
  `translated_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `category_translations`
--

INSERT INTO `category_translations` (`id`, `category_id`, `language_code`, `translated_name`) VALUES
(1, 1, 'ru', 'Электроника'),
(2, 1, 'pl', 'Elektronika'),
(3, 2, 'ru', 'Одежда'),
(4, 2, 'pl', 'Odzież'),
(5, 3, 'ru', 'Книги'),
(6, 3, 'pl', 'Książki'),
(7, 4, 'ru', 'Бытовая техника'),
(8, 4, 'pl', 'Sprzęt AGD'),
(9, 5, 'ru', 'Компьютеры и аксессуары'),
(10, 5, 'pl', 'Komputery i akcesoria'),
(11, 6, 'ru', 'Мобильные телефоны'),
(12, 6, 'pl', 'Telefony komórkowe'),
(13, 7, 'ru', 'Обувь'),
(14, 7, 'pl', 'Obuwie'),
(15, 8, 'ru', 'Аксессуары'),
(16, 8, 'pl', 'Akcesoria'),
(17, 9, 'ru', 'Игрушки'),
(18, 9, 'pl', 'Zabawki'),
(19, 10, 'ru', 'Спорт и отдых'),
(20, 10, 'pl', 'Sport i rekreacja'),
(21, 11, 'ru', 'Здоровье и красота'),
(22, 11, 'pl', 'Zdrowie i uroda'),
(23, 12, 'ru', 'Дом и сад'),
(24, 12, 'pl', 'Dom i ogród'),
(25, 13, 'ru', 'Продукты питания'),
(26, 13, 'pl', 'Produkty spożywcze'),
(27, 14, 'ru', 'Автомобили и мотоциклы'),
(28, 14, 'pl', 'Samochody i motocykle'),
(29, 15, 'ru', 'Музыкальные инструменты'),
(30, 15, 'pl', 'Instrumenty muzyczne'),
(31, 16, 'ru', 'Антиквариат'),
(32, 16, 'pl', 'Antyki'),
(33, 17, 'ru', 'Коллекционные предметы'),
(34, 17, 'pl', 'Przedmioty kolekcjonerskie'),
(35, 18, 'ru', 'Искусство и антиквариат'),
(36, 18, 'pl', 'Sztuka i antyki'),
(37, 19, 'ru', 'Товары для домашних животных'),
(38, 19, 'pl', 'Artykuły dla zwierząt'),
(39, 20, 'ru', 'Мебель'),
(40, 20, 'pl', 'Meble');

-- --------------------------------------------------------

--
-- Структура таблицы `messages`
--

CREATE TABLE `messages` (
  `id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `messages`
--

INSERT INTO `messages` (`id`, `sender_id`, `receiver_id`, `message`, `created_at`) VALUES
(2, 6, 7, '123', '2025-01-22 16:51:13'),
(3, 7, 6, '321', '2025-01-22 16:51:30'),
(4, 6, 7, '456', '2025-01-22 17:06:52'),
(5, 7, 6, '654\r\n', '2025-01-22 17:07:19'),
(6, 10, 6, '31', '2025-01-22 17:16:05'),
(7, 6, 10, '1', '2025-01-22 18:37:08'),
(8, 6, 10, '123', '2025-01-22 18:37:46'),
(9, 6, 10, '321', '2025-01-22 18:37:48'),
(10, 6, 10, '123', '2025-01-22 18:37:50'),
(11, 6, 10, '123', '2025-01-22 18:37:53'),
(12, 6, 10, '123', '2025-01-22 18:37:57'),
(13, 6, 10, 'test', '2025-01-22 18:38:50'),
(14, 6, 10, 's', '2025-01-22 18:38:56'),
(15, 6, 10, 'd', '2025-01-22 18:39:00'),
(16, 6, 10, 'f', '2025-01-22 18:39:03'),
(17, 6, 10, 'test', '2025-01-22 18:57:12'),
(18, 6, 10, 'f', '2025-01-22 19:06:24'),
(19, 6, 10, 'd', '2025-01-22 19:06:44'),
(20, 6, 10, 'f', '2025-01-22 19:06:48'),
(21, 6, 10, 'f', '2025-01-22 19:06:51'),
(22, 7, 10, 'hi', '2025-01-22 19:27:45'),
(23, 7, 10, 'hii', '2025-01-22 19:28:50'),
(24, 7, 10, 'f', '2025-01-22 19:31:09'),
(25, 7, 10, 'f', '2025-01-22 19:31:14'),
(26, 7, 10, 'd', '2025-01-22 19:31:16'),
(27, 7, 10, 'testing', '2025-01-22 19:37:03'),
(28, 7, 10, 'twwww', '2025-01-22 19:38:47'),
(29, 6, 10, 'test', '2025-01-23 00:29:26'),
(30, 6, 10, 'test', '2025-01-23 00:29:50'),
(31, 6, 10, 'helllo', '2025-01-23 12:51:32'),
(32, 6, 7, 'C:\\xampp\\htdocs\\my_auction_project\\chat.php</b> on line <b>126</b><br />\r\n\" required>б', '2025-01-23 19:50:06'),
(33, 6, 7, 'C:\\xampp\\htdocs\\my_auction_project\\chat.php</b> on line <b>126</b><br />\r\n\" required>б', '2025-01-23 19:50:10'),
(34, 6, 7, 'C:\\xampp\\htdocs\\my_auction_project\\chat.php</b> on line <b>126</b><br />\r\n\" required>б', '2025-01-23 19:50:12'),
(35, 6, 7, 'C:\\xampp\\htdocs\\my_auction_project\\chat.php</b> on line <b>126</b><br />\r\n\" required>б', '2025-01-23 19:50:14'),
(36, 6, 7, 'C:\\xampp\\htdocs\\my_auction_project\\chat.php</b> on line <b>126</b><br />\r\n\" required>б', '2025-01-23 19:52:22'),
(37, 6, 7, 'C:\\xampp\\htdocs\\my_auction_project\\chat.php</b> on line <b>126</b><br />\r\n\" required>б', '2025-01-23 19:55:53'),
(38, 6, 7, 'C:\\xampp\\htdocs\\my_auction_project\\chat.php</b> on line <b>126</b><br />\r\n\" required>б', '2025-01-23 19:57:38'),
(39, 6, 7, 'C:\\xampp\\htdocs\\my_auction_project\\chat.php</b> on line <b>126</b><br />\r\n\" required>б', '2025-01-23 19:58:03'),
(40, 6, 7, 'C:\\xampp\\htdocs\\my_auction_project\\chat.php</b> on line <b>126</b><br />\r\n\" required>б', '2025-01-23 20:01:05'),
(41, 6, 7, 'C:\\xampp\\htdocs\\my_auction_project\\chat.php</b> on line <b>126</b><br />\r\n\" required>б', '2025-01-23 20:01:19'),
(42, 6, 7, 'C:\\xampp\\htdocs\\my_auction_project\\chat.php</b> on line <b>126</b><br />\r\n\" required>б', '2025-01-23 20:05:02'),
(43, 6, 7, 'C:\\xampp\\htdocs\\my_auction_project\\chat.php</b> on line <b>126</b><br />\r\n\" required>б', '2025-01-23 20:05:57'),
(44, 6, 7, 'f', '2025-01-23 20:06:00'),
(45, 6, 7, 'fff', '2025-01-23 20:06:04'),
(46, 6, 7, 'test', '2025-01-23 20:06:14'),
(47, 6, 7, 'test', '2025-01-23 20:06:20'),
(48, 6, 7, 'test', '2025-01-23 20:06:52'),
(49, 6, 10, 'аааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааа', '2025-01-23 20:08:28'),
(50, 6, 10, 'а', '2025-01-23 20:08:31'),
(51, 6, 10, 'а', '2025-01-23 20:11:15'),
(52, 6, 10, 'а', '2025-01-23 20:11:46'),
(53, 6, 10, 'а', '2025-01-23 20:11:58'),
(54, 6, 10, 'а', '2025-01-23 20:13:45'),
(55, 6, 10, 'а', '2025-01-23 20:13:54'),
(56, 6, 10, 'а', '2025-01-23 20:15:28'),
(57, 6, 10, 'а', '2025-01-23 20:16:46'),
(58, 6, 10, 'а', '2025-01-23 20:18:27'),
(59, 6, 10, 'а', '2025-01-23 20:20:48'),
(60, 6, 10, 'а', '2025-01-23 20:20:56'),
(61, 6, 10, 'а', '2025-01-23 20:20:59'),
(62, 6, 10, 'а', '2025-01-23 20:24:10'),
(63, 6, 10, 'а', '2025-01-23 20:25:11'),
(64, 6, 10, 'а', '2025-01-23 20:33:21'),
(65, 6, 10, 'а', '2025-01-23 20:34:20'),
(66, 6, 10, 'а', '2025-01-23 20:35:43'),
(67, 6, 10, 'а', '2025-01-23 20:36:14'),
(68, 6, 10, 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffff', '2025-01-23 20:36:27'),
(69, 6, 10, 'fffffffffffffffffffffffffffffffffffffff', '2025-01-23 20:36:32'),
(70, 6, 10, 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff', '2025-01-23 20:36:43'),
(71, 6, 10, 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff', '2025-01-23 20:36:45'),
(72, 6, 10, 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff\r\n\r\nffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff', '2025-01-23 20:36:49'),
(73, 6, 10, 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff\r\n\r\nffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff', '2025-01-23 20:36:51'),
(74, 6, 10, '1', '2025-01-23 20:45:42'),
(75, 6, 10, 'ааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааа', '2025-01-23 20:45:53'),
(76, 6, 10, 'а', '2025-01-23 20:46:33'),
(77, 6, 10, '1', '2025-01-23 20:50:08'),
(78, 6, 10, '1', '2025-01-23 20:50:12'),
(79, 6, 10, '1', '2025-01-23 20:50:15'),
(80, 6, 10, '1', '2025-01-23 20:50:20'),
(81, 6, 10, '12', '2025-01-23 20:50:23'),
(82, 6, 10, '12', '2025-01-23 20:50:28'),
(83, 6, 10, 'а', '2025-01-23 20:55:46'),
(84, 6, 10, 'а', '2025-01-23 21:27:03'),
(85, 6, 10, 'а', '2025-01-23 22:14:17'),
(86, 6, 10, 'а', '2025-01-23 22:22:27'),
(87, 6, 10, 'а', '2025-01-23 22:22:48'),
(88, 6, 10, '25', '2025-01-23 22:52:42'),
(89, 6, 10, '123', '2025-01-23 22:53:31'),
(90, 6, 10, 'test', '2025-01-24 08:25:37'),
(91, 6, 10, 'hello', '2025-01-24 12:37:09'),
(92, 6, 10, 'hello2', '2025-01-24 12:37:31'),
(93, 6, 10, 'hello2', '2025-01-24 12:37:52'),
(94, 6, 10, 'hello2', '2025-01-24 12:38:15'),
(95, 6, 10, 'hello2', '2025-01-24 12:38:28'),
(96, 7, 13, 'who are you', '2025-01-25 15:45:05'),
(97, 7, 13, 'http://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phpvv', '2025-01-25 15:48:21');
INSERT INTO `messages` (`id`, `sender_id`, `receiver_id`, `message`, `created_at`) VALUES
(98, 7, 13, 'http://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phphttp://localhost:63342/my_auction_project/index.phpvv', '2025-01-25 15:48:29');

-- --------------------------------------------------------

--
-- Структура таблицы `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `type` varchar(50) NOT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `type`, `message`, `is_read`, `created_at`) VALUES
(1, 7, 'bid_outbid', 'Ваша ставка была перебита! Новая ставка составляет: 2 USD', 1, '2025-01-22 17:26:20'),
(2, 7, 'bid_outbid', 'Ваша ставка была перебита! Новая ставка составляет: 3 USD', 1, '2025-01-22 17:57:24'),
(3, 10, 'bid_outbid', 'Ваша ставка была перебита! Новая ставка составляет: 5 USD', 1, '2025-01-22 17:57:36'),
(4, 7, 'bid_outbid', 'Ваша ставка была перебита! Новая ставка составляет: 7 USD', 1, '2025-01-22 18:17:58'),
(5, 10, 'bid_outbid', 'Ваша ставка была перебита! Новая ставка составляет: 10 USD', 1, '2025-01-22 18:18:10'),
(6, 7, 'bid_outbid', 'Ваша ставка была перебита! Новая ставка составляет: 11 USD', 1, '2025-01-22 18:33:25'),
(7, 10, 'bid_outbid', 'Ваша ставка была перебита! Новая ставка составляет: 12 USD', 1, '2025-01-22 18:33:48'),
(8, 10, 'new_message', '123', 1, '2025-01-22 18:37:46'),
(9, 10, 'new_message', '321', 1, '2025-01-22 18:37:48'),
(10, 10, 'new_message', '123', 1, '2025-01-22 18:37:50'),
(11, 10, 'new_message', '123', 1, '2025-01-22 18:37:53'),
(12, 10, 'new_message', '123', 1, '2025-01-22 18:37:57'),
(13, 10, 'new_message', 'test', 1, '2025-01-22 18:38:50'),
(14, 10, 'new_message', 's', 1, '2025-01-22 18:38:56'),
(15, 10, 'new_message', 'd', 1, '2025-01-22 18:39:00'),
(16, 10, 'new_message', 'f', 1, '2025-01-22 18:39:03'),
(17, 7, 'bid_outbid', 'Ваша ставка была перебита! Новая ставка составляет: 13 USD', 1, '2025-01-22 18:58:38'),
(18, 10, 'bid_outbid', 'Ваша ставка была перебита! Новая ставка составляет: 15 USD', 1, '2025-01-22 18:58:48'),
(19, 10, 'message', 'Вы получили новое сообщение от пользователя 7.', 1, '2025-01-22 19:01:55'),
(20, 7, 'bid', 'Ваша ставка на товар \'1\' была перебита.', 1, '2025-01-22 19:03:21'),
(21, 10, 'message', 'Вы получили новое сообщение от пользователя 7.', 1, '2025-01-22 19:03:53'),
(22, 7, 'auction_end', 'Ваш аукцион завершен, и вы получили деньги.', 1, '2025-01-22 19:04:51'),
(23, 7, 'bid', 'Ваша ставка на товар \'1\' была перебита.', 1, '2025-01-22 19:05:22'),
(24, 10, 'new_message', 'f', 1, '2025-01-22 19:06:24'),
(25, 10, 'new_message', 'd', 1, '2025-01-22 19:06:44'),
(26, 10, 'new_message', 'f', 1, '2025-01-22 19:06:48'),
(27, 10, 'new_message', 'f', 1, '2025-01-22 19:06:51'),
(28, 7, 'bid_outbid', 'Ваша ставка была перебита! Новая ставка составляет: 16 USD', 1, '2025-01-22 19:07:57'),
(29, 10, 'bid_outbid', 'Ваша ставка была перебита! Новая ставка составляет: 17 USD', 1, '2025-01-22 19:08:06'),
(30, 7, 'bid_outbid', 'Ваша ставка была перебита! Новая ставка составляет: 18 USD', 1, '2025-01-22 19:09:13'),
(31, 10, 'bid', 'Ваша ставка на товар \'1\' была перебита.', 1, '2025-01-22 19:10:23'),
(32, 7, 'bid', 'Ваша ставка на товар \'1\' была перебита.', 1, '2025-01-22 19:12:00'),
(33, 7, 'bid', 'Ваша ставка на товар \'1\' была перебита.', 1, '2025-01-22 19:20:33'),
(34, 7, 'bid', 'Ваша ставка на товар \'1\' была перебита.', 1, '2025-01-22 19:21:13'),
(35, 10, 'bid', 'Ваша ставка на товар \'1\' была перебита.', 1, '2025-01-22 19:22:01'),
(36, 7, 'bid', 'Ваша ставка на товар \'1\' была перебита.', 1, '2025-01-22 19:22:57'),
(37, 10, 'bid_outbid', 'Ваша ставка была перебита! Новая ставка составляет: 19 USD', 1, '2025-01-22 19:23:45'),
(38, 10, 'new_message', 'hii', 1, '2025-01-22 19:28:50'),
(39, 10, 'message', 'Вы получили новое сообщение от пользователя 7.', 1, '2025-01-22 19:30:03'),
(40, 10, 'new_message', 'f', 1, '2025-01-22 19:31:09'),
(41, 10, 'new_message', 'f', 1, '2025-01-22 19:31:14'),
(42, 10, 'new_message', 'd', 1, '2025-01-22 19:31:16'),
(43, 10, 'message', 'Вы получили новое сообщение от пользователя 7.', 1, '2025-01-22 19:37:03'),
(44, 10, 'message', 'Вы получили новое сообщение от пользователя 7.', 1, '2025-01-22 19:38:47'),
(45, 7, 'bid_outbid', 'Ваша ставка была перебита! Новая ставка составляет: 20 USD', 1, '2025-01-22 19:41:44'),
(46, 10, 'bid_outbid', 'Ваша ставка была перебита! Новая ставка составляет: 21 USD', 1, '2025-01-22 19:41:58'),
(47, 10, 'auction_end', 'Ваш аукцион завершен! Товары были проданы по цене: 22.00 USD', 1, '2025-01-22 19:46:31'),
(48, 10, 'message', 'You received a new message from DmytroMorozov.', 1, '2025-01-23 00:29:26'),
(49, 10, 'message', 'Otrzymałeś nową wiadomość od DmytroMorozov.', 1, '2025-01-23 00:29:50'),
(50, 10, 'message', 'Вы получили новое сообщение от DmytroMorozov.', 1, '2025-01-23 12:51:32'),
(51, 10, 'message', 'Вы получили новое сообщение от DmytroMorozov.', 1, '2025-01-23 20:50:08'),
(52, 10, 'message', 'Вы получили новое сообщение от DmytroMorozov.', 1, '2025-01-23 20:50:12'),
(53, 10, 'message', 'Вы получили новое сообщение от DmytroMorozov.', 1, '2025-01-23 20:50:15'),
(54, 10, 'message', 'Вы получили новое сообщение от DmytroMorozov.', 1, '2025-01-23 20:50:20'),
(55, 10, 'message', 'Вы получили новое сообщение от DmytroMorozov.', 1, '2025-01-23 20:50:23'),
(56, 10, 'message', 'Вы получили новое сообщение от DmytroMorozov.', 1, '2025-01-23 20:50:28'),
(57, 10, 'message', 'Вы получили новое сообщение от DmytroMorozov.', 1, '2025-01-23 20:55:46'),
(58, 10, 'message', 'Вы получили новое сообщение от DmytroMorozov.', 1, '2025-01-23 21:27:03'),
(59, 10, 'message', 'Вы получили новое сообщение от DmytroMorozov.', 1, '2025-01-23 22:14:17'),
(60, 10, 'message', 'Вы получили новое сообщение от DmytroMorozov.', 1, '2025-01-23 22:22:27'),
(61, 10, 'message', 'Вы получили новое сообщение от DmytroMorozov.', 1, '2025-01-23 22:22:48'),
(62, 7, 'bid_outbid', 'Ваша ставка была перебита! Новая ставка составляет: 25 USD', 1, '2025-01-23 22:53:05'),
(63, 10, 'message', 'Вы получили новое сообщение от DmytroMorozov.', 1, '2025-01-23 22:53:31'),
(64, 10, 'bid_outbid', 'Ваша ставка была перебита! Новая ставка составляет: 40 USD', 1, '2025-01-23 23:36:59'),
(65, 6, 'auction_end', 'Ваш аукцион завершен! Товары были проданы по цене: 40.00 USD', 0, '2025-01-23 23:45:42'),
(66, 10, 'bid_outbid', 'Ваша ставка была перебита! Новая ставка составляет: ', 1, '2025-01-23 23:54:35'),
(67, 7, 'bid_outbid', 'Ваша ставка была перебита! Новая ставка составляет: ', 1, '2025-01-23 23:54:49'),
(68, 7, 'bid_outbid', 'Ваша ставка была перебита! Новая ставка составляет: ', 1, '2025-01-24 00:01:44'),
(69, 10, 'bid_outbid', 'Ваша ставка была перебита! Новая ставка составляет: ', 0, '2025-01-24 08:14:07'),
(70, 9, 'bid_outbid', 'Ваша ставка была перебита! Новая ставка составляет: ', 0, '2025-01-24 08:22:44'),
(71, 10, 'bid_outbid', 'Ваша ставка была перебита! Новая ставка составляет: ', 0, '2025-01-24 08:24:18'),
(72, 10, 'message', 'You received a new message from DmytroMorozov.', 0, '2025-01-24 08:25:37'),
(73, 6, 'bid_outbid', 'Ваша ставка была перебита! Новая ставка составляет: ', 0, '2025-01-24 08:32:06'),
(74, 7, 'bid_outbid', 'Twoja oferta została przebita! Nowa oferta wynosi: ', 0, '2025-01-24 12:35:39'),
(75, 10, 'message', 'You received a new message from DmytroMorozov.', 0, '2025-01-24 12:37:09'),
(76, 10, 'message', 'You received a new message from DmytroMorozov.', 0, '2025-01-24 12:37:31'),
(77, 10, 'message', 'You received a new message from DmytroMorozov.', 0, '2025-01-24 12:37:52'),
(78, 10, 'message', 'You received a new message from DmytroMorozov.', 0, '2025-01-24 12:38:15'),
(79, 10, 'message', 'You received a new message from DmytroMorozov.', 0, '2025-01-24 12:38:28'),
(80, 13, 'message', 'You received a new message from nazartretiakov.', 0, '2025-01-25 15:48:22'),
(81, 13, 'message', 'You received a new message from nazartretiakov.', 0, '2025-01-25 15:48:29'),
(82, 6, 'auction_end', 'Ваш аукцион завершен! Товары были проданы по цене: 3213.00 USD. Деньги переведены на ваш баланс.', 0, '2025-01-25 15:51:32'),
(83, 6, 'auction_end', 'Ваш аукцион завершен! Товары были проданы по цене: 123124.00 USD. Деньги переведены на ваш баланс.', 0, '2025-01-25 15:51:33'),
(84, 10, 'auction_end', 'Ваш аукцион завершен! Товары были проданы по цене: 15.00 USD. Деньги переведены на ваш баланс.', 0, '2025-01-25 15:51:36'),
(85, 7, 'bid_outbid', 'Ваша ставка была перебита! Новая ставка составляет: ', 0, '2025-01-25 22:40:43');

-- --------------------------------------------------------

--
-- Структура таблицы `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_auction` tinyint(1) DEFAULT 0,
  `start_price` decimal(10,2) DEFAULT NULL,
  `current_price` decimal(10,2) DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `is_verified` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `products`
--

INSERT INTO `products` (`id`, `user_id`, `title`, `description`, `category_id`, `price`, `created_at`, `is_auction`, `start_price`, `current_price`, `end_date`, `image`, `is_verified`) VALUES
(45, 6, 'Test', '13', 13, 0.00, '2025-01-23 23:35:23', 0, 30.00, 40.00, '2025-01-24 00:40:00', 'uploads/photo_2023-10-25_18-04-45.jpg', 1),
(46, 6, '1', '1', 9, 0.00, '2025-01-23 23:53:12', 1, 2.00, 50.00, '2026-11-11 22:22:00', 'uploads/photo_2023-10-25_18-04-44.jpg', 1),
(47, 6, '123', '123', 10, 0.00, '2025-01-24 07:49:51', 1, 123.00, 200.00, '2026-10-11 11:11:00', 'uploads/photo_2023-10-25_18-04-44.jpg', 1),
(48, 6, '132', '12321', 15, 0.00, '2025-01-24 07:50:08', 0, 3213.00, 3213.00, '2025-01-25 11:25:00', 'uploads/photo_2023-10-25_18-04-45.jpg', 1),
(49, 6, '123', '123', 11, 0.00, '2025-01-24 07:51:18', 1, 123.00, 150.00, '2026-01-24 11:11:00', 'uploads/photo_2023-10-25_18-04-44 (3).jpg', 1),
(50, 6, '321', '321', 11, 0.00, '2025-01-24 07:51:33', 1, 321.00, 321.00, '2026-01-24 11:01:00', 'uploads/photo_2023-10-25_18-04-44 (4).jpg', 1),
(51, 6, '4213', '124241', 12, 0.00, '2025-01-24 07:52:49', 0, 123124.00, 123124.00, '2025-01-25 11:00:00', 'uploads/photo_2023-10-25_18-04-44 (3).jpg', 1),
(52, 10, '321', '123', 15, 0.00, '2025-01-24 08:31:31', 0, 10.00, 15.00, '2025-01-24 09:35:00', 'uploads/photo_2023-10-25_18-04-43.jpg', 1),
(53, 13, 'papaja', 'the best fruit', 13, 0.00, '2025-01-25 15:38:56', 1, 5.00, 15.00, '2025-01-27 16:37:00', 'uploads/papaya.jpg', 1);

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `role` enum('user','admin') NOT NULL DEFAULT 'user'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `created_at`, `role`) VALUES
(6, 'admin', 'admin@gmail.com', '$2y$10$SP2CdIR4NqRQlvhqt250dugDDlGgzk8/WNypsSbl6Ln/sc/P41Hoy', '2025-01-20 19:27:33', 'admin'),
(7, 'user', 'user@gmail.com', '$2y$10$QEhSRYI30NfathafN1nA3.8LW/.aAZyIZqLguYgd7592AD7iCpqaW', '2025-01-20 19:44:08', 'user'),
(9, 'user2', 'user2@gmail.com', '$2y$10$h6DIubYqKuyMWRlZ6BowwOZpL0YfNl/XJcbD5W4D/t0Am5Ucnb8pG', '2025-01-20 21:56:56', 'user'),
(10, 'DmytroMorozov', 'dm3348412@gmail.com', '$2y$10$vuGmHoh9z/nxzAWe8WoHruaN09vPpkuwOYCmqFdq/5mucquciq4cq', '2025-01-22 17:12:47', 'user'),
(13, 'nazartretiakov', 'nazartretyakov2005@gmail.com', '$2y$10$Syth87PoiNNF4VDPrRHPnuyAoB95fkgRQFh/axqgilpIeAjgvwLei', '2025-01-25 15:34:24', 'admin');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `auctions`
--
ALTER TABLE `auctions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`);

--
-- Индексы таблицы `balances`
--
ALTER TABLE `balances`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Индексы таблицы `bids`
--
ALTER TABLE `bids`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Индексы таблицы `blocked_users`
--
ALTER TABLE `blocked_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `blocker_id` (`blocker_id`,`blocked_id`),
  ADD KEY `blocked_id` (`blocked_id`);

--
-- Индексы таблицы `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `parent_id` (`parent_id`);

--
-- Индексы таблицы `category_translations`
--
ALTER TABLE `category_translations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `category_id` (`category_id`,`language_code`);

--
-- Индексы таблицы `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sender_id` (`sender_id`),
  ADD KEY `receiver_id` (`receiver_id`);

--
-- Индексы таблицы `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Индексы таблицы `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `category_id` (`category_id`);
ALTER TABLE `products` ADD FULLTEXT KEY `title` (`title`,`description`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `auctions`
--
ALTER TABLE `auctions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `balances`
--
ALTER TABLE `balances`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `bids`
--
ALTER TABLE `bids`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=89;

--
-- AUTO_INCREMENT для таблицы `blocked_users`
--
ALTER TABLE `blocked_users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT для таблицы `category_translations`
--
ALTER TABLE `category_translations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT для таблицы `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=99;

--
-- AUTO_INCREMENT для таблицы `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=86;

--
-- AUTO_INCREMENT для таблицы `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `auctions`
--
ALTER TABLE `auctions`
  ADD CONSTRAINT `auctions_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Ограничения внешнего ключа таблицы `balances`
--
ALTER TABLE `balances`
  ADD CONSTRAINT `balances_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Ограничения внешнего ключа таблицы `bids`
--
ALTER TABLE `bids`
  ADD CONSTRAINT `bids_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `bids_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Ограничения внешнего ключа таблицы `blocked_users`
--
ALTER TABLE `blocked_users`
  ADD CONSTRAINT `blocked_users_ibfk_1` FOREIGN KEY (`blocker_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `blocked_users_ibfk_2` FOREIGN KEY (`blocked_id`) REFERENCES `users` (`id`);

--
-- Ограничения внешнего ключа таблицы `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`);

--
-- Ограничения внешнего ключа таблицы `category_translations`
--
ALTER TABLE `category_translations`
  ADD CONSTRAINT `category_translations_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`id`);

--
-- Ограничения внешнего ключа таблицы `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Ограничения внешнего ключа таблицы `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `products_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
