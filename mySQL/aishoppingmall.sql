-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 29, 2020 at 07:23 AM
-- Server version: 10.4.13-MariaDB
-- PHP Version: 7.4.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `aishoppingmall`
--

-- --------------------------------------------------------

--
-- Table structure for table `menu_table`
--

CREATE TABLE `menu_table` (
  `id` int(11) NOT NULL,
  `idShop` text COLLATE utf8_unicode_ci NOT NULL,
  `nameFood` text COLLATE utf8_unicode_ci NOT NULL,
  `pathFood` text COLLATE utf8_unicode_ci NOT NULL,
  `price` text COLLATE utf8_unicode_ci NOT NULL,
  `detail` text COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `menu_table`
--

INSERT INTO `menu_table` (`id`, `idShop`, `nameFood`, `pathFood`, `price`, `detail`) VALUES
(1, '2', 'All Cafe\'', '/aishoppingmall/Food/food431655.jpg', '20', 'discount'),
(5, '2', 'maxim coffee', '/aishoppingmall/Food/food132132.jpg', '170', 'Freeze Dried Coffee'),
(6, '2', 'ปาท่องโก๋', '/aishoppingmall/Food/food231777.jpg', '20', 'หวานน้อย กรอบนาน'),
(8, '2', 'น้ำเต้าหู้', '/aishoppingmall/Food/food533876.jpg', '7', 'หวานน้อยอร่อยมาก'),
(14, '2', 'Whey protein', '/aishoppingmall/Food/food49426.jpg', '1499', 'ช็อคโกแลต'),
(15, '2', 'ไอศกรีมไผ่ทอง', '/aishoppingmall/Food/food233064.jpg', '15', 'อร่อยมาก'),
(16, '16', 'Roll Cake', '/aishoppingmall/Food/food657454.jpg', '25', 'ไส้ทูน่า\nไส้หวาน'),
(17, '16', 'ต้มมะระ', '/aishoppingmall/Food/food967388.jpg', '55', 'กลมกล่อม'),
(19, '15', 'Whey protein', '/aishoppingmall/Food/food49426.jpg', '1499', 'ช็อคโกแลต');

-- --------------------------------------------------------

--
-- Table structure for table `order_table`
--

CREATE TABLE `order_table` (
  `id` int(11) NOT NULL,
  `orderDateTime` text COLLATE utf8_unicode_ci NOT NULL,
  `idShop` text COLLATE utf8_unicode_ci NOT NULL,
  `nameShop` text COLLATE utf8_unicode_ci NOT NULL,
  `distance` text COLLATE utf8_unicode_ci NOT NULL,
  `transport` text COLLATE utf8_unicode_ci NOT NULL,
  `idFood` text COLLATE utf8_unicode_ci NOT NULL,
  `nameFood` text COLLATE utf8_unicode_ci NOT NULL,
  `price` text COLLATE utf8_unicode_ci NOT NULL,
  `amount` text COLLATE utf8_unicode_ci NOT NULL,
  `sum` text COLLATE utf8_unicode_ci NOT NULL,
  `rider` text COLLATE utf8_unicode_ci NOT NULL,
  `status` text COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `order_table`
--

INSERT INTO `order_table` (`id`, `orderDateTime`, `idShop`, `nameShop`, `distance`, `transport`, `idFood`, `nameFood`, `price`, `amount`, `sum`, `rider`, `status`) VALUES
(1, '$orderDateTime', '$idShop', '$nameShop', '$distance', '$transport', '$idFood', '$nameFood', '$price', '$amount', '$sum', '$rider', '$status');

-- --------------------------------------------------------

--
-- Table structure for table `user_table`
--

CREATE TABLE `user_table` (
  `id` int(11) NOT NULL,
  `chooseType` text COLLATE utf8_unicode_ci NOT NULL,
  `name` text COLLATE utf8_unicode_ci NOT NULL,
  `user` text COLLATE utf8_unicode_ci NOT NULL,
  `password` text COLLATE utf8_unicode_ci NOT NULL,
  `nameShop` text COLLATE utf8_unicode_ci NOT NULL,
  `address` text COLLATE utf8_unicode_ci NOT NULL,
  `phone` text COLLATE utf8_unicode_ci NOT NULL,
  `urlPicture` text COLLATE utf8_unicode_ci NOT NULL,
  `lat` text COLLATE utf8_unicode_ci NOT NULL,
  `lng` text COLLATE utf8_unicode_ci NOT NULL,
  `token` text COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `user_table`
--

INSERT INTO `user_table` (`id`, `chooseType`, `name`, `user`, `password`, `nameShop`, `address`, `phone`, `urlPicture`, `lat`, `lng`, `token`) VALUES
(1, 'User', 'อัยย์User', 'uuuu', '1234', '', '', '', '', '', '', ''),
(2, 'Shop', 'อัยย์Shop', 'ssss', '1234', 'อัยย์ Shop', '253/1394 หมู่บ้านพูนสินธานี3 \r\nซ.เคหะร่มเกล้า64 แขวงคลองสองต้นนุ่น \r\nเขตลาดกระบัง กรุงเทพฯ 10520', '0958043660', '/aishoppingmall/Shop/editShop21254.jpg', '13.792108', '100.703160', 'token'),
(3, 'Rider', 'อัยย์Rider', 'rrrr', '1234', '', '', '', '', '', '', ''),
(13, 'n/a', 'aa', 'ss', 'dd', '', '', '', '', '', '', ''),
(14, 'Shop', 'qqqqq', 'wwww', '1234', '', '', '', '', '', '', ''),
(15, 'Shop', 'aiNerv86', 'ainerv', '1234', 'aiNerv86', 'เะีกเ', '0987565', '/aishoppingmall/Shop/shop694170.jpg', '13.758513', '100.566138', ''),
(16, 'Shop', 'shop1', 'aishop', '1234', 'AiShop', 'misteen', '0958043660', '/aishoppingmall/Shop/shop261142.jpg', '13.738092', '100.560491', '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `menu_table`
--
ALTER TABLE `menu_table`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_table`
--
ALTER TABLE `order_table`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_table`
--
ALTER TABLE `user_table`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `menu_table`
--
ALTER TABLE `menu_table`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `order_table`
--
ALTER TABLE `order_table`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `user_table`
--
ALTER TABLE `user_table`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
