-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 17, 2024 at 01:09 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.1.17

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `vegetables`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_sp_book` (`userID` INT)   begin
	DELETE FROM orders
  where id_user = userID
  ORDER BY id DESC
  LIMIT 1 ;
  select max(id) as orderId
	from orders
	where id_user = userID;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_book` (`userID` INT)   begin
	insert into orders(id, id_user) values ((SELECT MAX( id )+1 FROM orders cust), userID);
	select max(id) as orderId
	from orders
	where id_user = userID;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_createUser` (`userName` VARCHAR(255), `userPhone` VARCHAR(255), `userAddress` VARCHAR(255), `userEmail` VARCHAR(255), `userPassword` VARCHAR(255))   begin
	INSERT INTO users(name, phone, address, email, password) 
				 VALUES (userName, userPhone, userAddress, userEmail, userPassword);
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_createVeg` (`nameVeg` VARCHAR(255), `weightVeg` INT, `priceVeg` INT, `idType` INT, `idOrig` INT)   begin
	INSERT INTO vegetables(name, weight, price, id_veg_type, id_orig)
	VALUES (nameVeg, weightVeg, priceVeg, idType, idOrig);
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_deleteUser` (`userID` INT)   begin
	DELETE FROM users WHERE id=userID;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_deleteVeg` (`vegID` INT)   begin
	DELETE FROM vegetables WHERE id=vegID;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getOrderDetails` (`orderID` INT)   begin
	select O.id as id, V.name as item, OD.amount as amount, OD.price as price
	from orders O join order_details OD on O.id = OD.id_order
								join vegetables V on OD.id_veg = V.id
	where O.id = orderID;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getVegeDetail` (`vegeID` INT)   begin
  select V.id, V.name, V.price, V.price, V.sale_price, V.image, V.weight, SUM(W.stock) stock, W.expired_date, V.id_veg_type, O.planting_place, O.seed
  from vegetables V JOIN veg_types VT ON V.id_veg_type=VT.id
  JOIN originals O ON V.id_orig=O.id
  LEFT JOIN warehouse W ON V.id=W.id_vegetable
  where V.id=vegeID AND (W.expired_date > CURRENT_DATE OR W.expired_date IS NULL)
  GROUP BY V.id, V.name;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getVegeInOrder` (`orderID` INT)   begin
	SELECT V.name, V.weight, OD.price, V.image, OD.amount
  FROM order_details OD JOIN vegetables V ON OD.id_veg = V.id
  WHERE OD.id_order = orderID;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_searchVegByKey` (`searchKey` VARCHAR(255))   begin
	SELECT V.id as ID, V.name as NAME, V.weight as WEIGHT, V.price as PRICE, 
					T.name as TYPE, O.seed as SEED, O.planting_place as PLANTING
	FROM vegetables V JOIN veg_types T ON T.id=V.id_veg_type JOIN originals O ON V.id_orig=O.id
	WHERE V.name like (SELECT CONCAT('%',searchKey,'%'));
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_selectFromCart` (`userID` INT)   begin
		SELECT * FROM carts WHERE id_user=userID;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_selectOrderOfUser` (`userID` INT)   begin
	SELECT O.id as ID, O.order_time as ORDER_TIME, O.delivery_time as DELIVERY_TIME, S.name as STATUS
	FROM users U JOIN orders O ON U.id=O.id_user 
								JOIN status S ON O.id_status=S.id
	WHERE U.id = userID;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_selectUserByID` (`userID` INT)   begin
		SELECT id as ID, name AS NAME, address AS ADDRESS, email as EMAIL, phone as PHONE
		FROM users
		WHERE id = userID;
 end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_selectVegByID` (`vegID` INT)   begin
		SELECT V.id as ID, V.name as NAME, V.weight as WEIGHT, V.price as PRICE, 
						T.name as TYPE, O.seed as SEED, O.planting_place as PLANTING
		FROM vegetables V JOIN veg_types T ON T.id=V.id_veg_type JOIN originals O ON V.id_orig=O.id
		WHERE V.id = vegID;
 end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_selectVegByType` (`vegtypeID` INT)   begin
		SELECT V.id as ID, V.name as NAME, V.weight as WEIGHT, V.price as PRICE, 
						T.name as TYPE, O.seed as SEED, O.planting_place as PLANTING
		FROM vegetables V JOIN veg_types T ON T.id=V.id_veg_type JOIN originals O ON V.id_orig=O.id
		WHERE T.id = vegtypeID;
 end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_selectVegInCartByUser` (`userID` INT)   begin
	select V.id, V.image, V.`name`, V.weight, V.price, V.sale_price, C.amount
	from users U join carts C on U.id = C.id_user
								join vegetables V on C.id_veg = V.id
	where U.id = userID;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_updateOrderState` (`orderID` INT, `stateID` INT)   begin
		UPDATE orders SET id_status=stateID WHERE id=orderID;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_updateUser` (`userID` INT, `userName` VARCHAR(255), `userPhone` VARCHAR(255), `userAddress` VARCHAR(255), `userEmail` VARCHAR(255), `userPassword` VARCHAR(255))   begin
			UPDATE users
			SET name=userName, email=userEmail, phone=userPhone, address=userAddress, password=userPassword
			WHERE id = userID;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_updateVeg` (`vegID` INT, `vegName` VARCHAR(255), `vegWeight` INT, `vegPrice` INT, `idVegType` INT, `idOrig` INT)   begin
			UPDATE vegetables
			SET name=vegName, weight=vegWeight, price=vegPrice, id_veg_type=idVegType, id_orig=idOrig
			WHERE id = vegID;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `carts`
--

CREATE TABLE `carts` (
  `id_user` int(10) NOT NULL,
  `id_veg` int(10) NOT NULL,
  `amount` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `feedbacks`
--

CREATE TABLE `feedbacks` (
  `id` int(10) NOT NULL,
  `id_user` int(10) NOT NULL,
  `id_veg` int(10) NOT NULL,
  `comment` varchar(255) DEFAULT NULL,
  `vote` int(255) NOT NULL DEFAULT 5,
  `time` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `feedbacks`
--

INSERT INTO `feedbacks` (`id`, `id_user`, `id_veg`, `comment`, `vote`, `time`) VALUES
(1, 16, 7, 'Bí rất ngon ạ, nên mua nha mọi người!', 4, '2022-05-04 12:56:11'),
(3, 19, 7, 'Sản phẩm tốt, ngon, đáng mua ạ!', 3, '2022-05-04 15:09:24'),
(4, 19, 4, 'Bắp chuối rất mềm, ngon, sạch!', 5, '2022-05-04 16:31:36'),
(5, 19, 3, 'Bắp cải tươi ngon lắm ạ!', 5, '2022-05-04 16:33:33'),
(6, 19, 3, '', 5, '2022-05-04 16:34:03'),
(7, 19, 3, '', 5, '2022-05-04 16:41:50'),
(8, 19, 8, '', 5, '2022-05-04 17:35:24'),
(9, 19, 8, '', 4, '2022-05-04 17:35:32'),
(10, 16, 88, 'Rất ngon ạ!', 5, '2022-05-05 02:00:49'),
(11, 16, 62, 'Nấm tươi ngon lắm ạ!', 5, '2022-05-05 02:03:03'),
(12, 16, 8, 'Bí rất ngon ạ, nên mua nha mọi người!', 5, '2022-05-05 02:06:00'),
(13, 16, 3, 'Bắp cải dở', 1, '2022-05-05 04:29:33'),
(14, 16, 10, 'Bông bí rất tươi ngon!', 5, '2022-05-05 07:54:18'),
(15, 16, 24, 'Cải rất non, tươi ngon lắm ạ!', 5, '2022-05-05 08:05:46'),
(16, 16, 5, '', 5, '2022-05-05 12:13:36'),
(17, 16, 5, 'Bắp non ngon ngọt lắm ạ!', 5, '2022-05-05 12:14:24'),
(18, 16, 6, '', 4, '2022-05-05 12:14:48'),
(19, 16, 14, 'Rất tươi ngon ạ mọi người ơi!!!', 4, '2022-05-05 12:15:07'),
(20, 16, 41, 'Dưa leo rất tươi ngon, em mua đắp mặt rất thích ạ!', 5, '2022-05-05 12:16:06'),
(23, 16, 7, '', 5, '2022-05-09 09:25:51'),
(24, 16, 7, 'Bí rất ngon ạ, nên mua nha mọi người!', 5, '2022-05-09 09:30:40'),
(25, 16, 11, 'Bông hẹ tươi ngon lắm ạ!', 5, '2022-05-10 06:16:46'),
(26, 16, 4, 'Bắp chuối tươi ngon lắm ạ!', 5, '2022-05-11 09:20:11'),
(33, 29, 1, '', 4, '2023-11-24 12:09:42');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(10) NOT NULL,
  `id_user` int(10) NOT NULL,
  `id_status` int(10) NOT NULL DEFAULT 1,
  `order_time` timestamp(6) NULL DEFAULT current_timestamp(6),
  `delivery_time` timestamp(6) NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `id_user`, `id_status`, `order_time`, `delivery_time`) VALUES
(56, 16, 3, '2023-10-07 09:43:42.327672', '2023-10-07 09:43:42.327672'),
(61, 16, 4, '2021-12-14 05:55:21.312294', '2021-12-14 05:55:21.312294'),
(62, 16, 2, '2021-12-14 07:31:16.713191', '2021-12-14 07:31:16.713191'),
(87, 16, 1, '2022-05-17 01:22:56.622451', '2022-05-17 01:22:56.622451'),
(92, 19, 2, '2022-05-17 01:30:19.516525', '2022-05-17 01:30:19.516525'),
(93, 19, 3, '2022-05-17 01:56:18.276478', '2022-05-17 01:56:18.276478'),
(94, 16, 1, '2022-05-17 02:59:39.024253', '2022-05-17 02:59:39.024253'),
(95, 19, 2, '2022-06-17 02:36:00.065099', '2022-06-17 02:36:00.065099'),
(96, 29, 3, '2023-11-24 10:51:26.965922', '2023-11-24 11:27:12.989546'),
(97, 29, 4, '2023-11-24 11:29:54.003237', '2023-11-24 11:41:21.277183'),
(98, 28, 1, '2023-11-25 07:09:05.792027', '2023-11-25 07:09:05.792027'),
(99, 28, 2, '2023-11-27 01:48:27.069217', '2023-11-27 01:51:36.636803'),
(100, 28, 1, '2023-11-27 02:01:13.254298', '2023-11-27 02:01:13.254298'),
(101, 28, 1, '2023-11-27 02:03:31.659018', '2023-11-27 02:03:31.659018');

-- --------------------------------------------------------

--
-- Table structure for table `order_details`
--

CREATE TABLE `order_details` (
  `id_order` int(10) NOT NULL,
  `id_veg` int(10) NOT NULL,
  `amount` int(10) NOT NULL,
  `price` decimal(10,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `order_details`
--

INSERT INTO `order_details` (`id_order`, `id_veg`, `amount`, `price`) VALUES
(56, 7, 1, 3000),
(56, 25, 1, 10000),
(61, 7, 2, 3000),
(61, 10, 2, 5000),
(61, 16, 1, 8000),
(62, 13, 1, 20000),
(62, 18, 2, 10000),
(62, 25, 2, 10000),
(87, 2, 1, 5000),
(87, 3, 1, 10000),
(92, 7, 2, 3000),
(92, 9, 1, 15000),
(93, 6, 3, 5000),
(93, 7, 2, 3000),
(94, 2, 10, 5000),
(94, 16, 2, 8000),
(94, 45, 3, 15000),
(95, 40, 1, 6500),
(96, 2, 1, 10000),
(97, 1, 1, 4000),
(98, 1, 3, 4000),
(99, 1, 1, 4000),
(99, 2, 1, 10000),
(100, 2, 1, 10000),
(101, 2, 3, 10000);

-- --------------------------------------------------------

--
-- Table structure for table `originals`
--

CREATE TABLE `originals` (
  `id` int(10) NOT NULL,
  `seed` varchar(255) NOT NULL,
  `planting_place` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `originals`
--

INSERT INTO `originals` (`id`, `seed`, `planting_place`) VALUES
(1, 'Công ty cổ phần giống cây trồng trung ương (Vinaseed)', 'Hợp tác xã Long Khê, huyện Cần Đước, tỉnh Long An'),
(2, 'Tổng công ty rau quả nông sản', 'Cánh đồng nông sản sạch, xã Hòa Bình, huyện Trà Ôn, tỉnh Vĩnh Long'),
(3, 'Công ty hạt giống Sen Vàng', 'Khu nhà kính nông sản, xã An Bình, huyện Long Hồ, tỉnh Vĩnh Long '),
(4, 'Công ty cổ phần giống cây trồng Miền Nam', 'Mô hình cánh đồng mơ ước tại xã Hòa An, huyện Phụng Hiệp, tỉnh Hậu Giang'),
(5, 'Công ty hạt giống Bình Minh', 'Vùng trồng rau an toàn của xã Thân Cửu Nghĩa, huyện Châu Thành, tỉnh Tiền Giang'),
(6, 'Công ty cổ phần Giống Mới', 'Mô hình cánh đồng mơ ước tại xã Long Thạnh, huyện Châu Thành A, tỉnh Hậu Giang'),
(7, 'Công ty TNHH thương mại dịch vụ Vườn Xinh', 'Vùng trồng rau an toàn của xã Bình Phan, huyện chợ Gạo, tỉnh Tiền Giang'),
(8, 'Công ty CP Hệ sinh thái công nghệ Việt Nam', 'Nông trại Rau sạch, TP. Đà Lạt, tỉnh Lâm Đồng.');

-- --------------------------------------------------------

--
-- Table structure for table `status`
--

CREATE TABLE `status` (
  `id` int(10) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `status`
--

INSERT INTO `status` (`id`, `name`) VALUES
(1, 'Chưa xử lý'),
(2, 'Đang chuẩn bị'),
(3, 'Đang giao'),
(4, 'Đã giao'),
(5, 'Đã thanh toán');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) NOT NULL,
  `name` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `role` int(10) NOT NULL DEFAULT 1,
  `avatar` varchar(255) NOT NULL DEFAULT 'default.jpg',
  `exp_date` varchar(250) DEFAULT NULL,
  `reset_link_token` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `phone`, `address`, `password`, `email`, `role`, `avatar`, `exp_date`, `reset_link_token`) VALUES
(1, 'Quản trị viên', '0', '0', '$2y$10$PSjh6WIWKin1nqUL8WzOK.0cCuaZSDMMgKsiqUywLdibX2OTc2H02', 'admin@gmail.com', 0, 'default.jpg', '', ''),
(3, 'Nguyễn Hoàng Thông', '0358309329', '12 đường Lý Tự Trọng, phường An Lạc, quận Ninh Kiều, TP.Cần Thơ', '$10$N4Z94bbYBtCvHt21NnJQZuqDkY4DfMk3Q/QvxJ/y5ZPlBPbLaCIUy', 'thong@gmail.com', 1, 'default.jpg', '', ''),
(4, 'Hầu Diễm Xuân', '0123763585', '45 đường Trần Hưng Đạo, phường Xuân Khánh, quận Ninh Kiều, TP.Cần Thơ', '$10$N4Z94bbYBtCvHt21NnJQZuqDkY4DfMk3Q/QvxJ/y5ZPlBPbLaCIUy', 'xuan@gmail.com', 1, 'default.jpg', '', ''),
(5, 'Phạm Chí Trung', '0925385162', '82 đường Trần Văn Hoài, phường Xuân Khánh, quận Ninh Kiều, TP.Cần Thơ', '$10$N4Z94bbYBtCvHt21NnJQZuqDkY4DfMk3Q/QvxJ/y5ZPlBPbLaCIUy', 'trung@gmail.com', 1, 'default.jpg', '', ''),
(6, 'Đoàn Duy Thanh', '0873174284', '97 đường Hùng Vương, phường An Cư, quận Ninh Kiều, TP.Cần Thơ', '$10$N4Z94bbYBtCvHt21NnJQZuqDkY4DfMk3Q/QvxJ/y5ZPlBPbLaCIUy', 'thanh@gmail.com', 1, 'default.jpg', '', ''),
(7, 'Nguyễn Huỳnh Hoàng Phúc', '0836109481', '48 đường Trần Ngọc Quế, phường Xuân Khánh, quận Ninh Kiều, TP.Cần Thơ', '$10$N4Z94bbYBtCvHt21NnJQZuqDkY4DfMk3Q/QvxJ/y5ZPlBPbLaCIUy', 'phuc@gmail.com', 1, 'default.jpg', '', ''),
(8, 'Trần Văn Thiệt', '0927385387', '55 đường Trần Ngọc Quế, phường Xuân Khánh, quận Ninh Kiều, TP.Cần Thơ', '$10$N4Z94bbYBtCvHt21NnJQZuqDkY4DfMk3Q/QvxJ/y5ZPlBPbLaCIUy', 'thiet@gmail.com', 1, 'default.jpg', '', ''),
(9, 'Đinh Thị Thúy Lựu', '0391278359', '132 đường Mậu Thân, phường Xuân Khánh, quận Ninh Kiều, TP.Cần Thơ', '$10$N4Z94bbYBtCvHt21NnJQZuqDkY4DfMk3Q/QvxJ/y5ZPlBPbLaCIUy', 'luu@gmail.com', 1, 'default.jpg', '', ''),
(10, 'Trịnh Kim Chi', '0331489511', '228 đường Nguyễn Trãi, phường Cái Khế, quận Ninh Kiều, TP.Cần Thơ', '$10$N4Z94bbYBtCvHt21NnJQZuqDkY4DfMk3Q/QvxJ/y5ZPlBPbLaCIUy', 'chi@gmail.com', 1, 'default.jpg', '', ''),
(11, 'Trần Phương Thảo', '0702137273', '312 đường Nguyễn Văn Linh, phường Hưng Lợi, quận Ninh Kiều, TP.Cần Thơ', '$10$N4Z94bbYBtCvHt21NnJQZuqDkY4DfMk3Q/QvxJ/y5ZPlBPbLaCIUy', 'thao@gmail.com', 1, 'default.jpg', '', ''),
(12, 'Lê Minh Kha', '0987654321', 'Hẻm 49, đường Trần Hoàng Na, phường Hưng Lợi, quận Ninh Kiều, TP. Cần Thơ', '123', 'kha@gmail.com', 1, 'default.jpg', '', ''),
(15, 'Huỳnh Quốc Nhật', '0987654321', 'Hẻm 49, đường Trần Hoàng Na, phường Hưng Lợi, quận Ninh Kiều, TP. Cần Thơ', '12345', 'nhat@gmail.com', 1, 'default.jpg', '', ''),
(16, 'Nguyễn Tùng Lâm', '0123456789', 'Hưng Lợi, Ninh Kiều, Cần Thơ', '$2y$10$N4Z94bbYBtCvHt21NnJQZuqDkY4DfMk3Q/QvxJ/y5ZPlBPbLaCIUy', 'tunglam@gmail.com', 1, 'default.jpg', '', ''),
(17, 'Kiều Thị Khanh', '0338307449', '113 Bế Văn Đàn, P. An Khánh, Q. Ninh Kiều, Cần Thơ', '$2y$10$QVO.1J6.ZqYEEL1fU/zbV.z5oCQt1bkSLgcNZTvYiXLA3giMti51.', 'khanh@gmail.com', 1, 'default.jpg', '', ''),
(18, 'Nguyễn Hữu Lợi', '0338307449', 'Xã Thới Hòa, huyện Trà Ôn, tỉnh Vĩnh Long', '$2y$10$BHbzrhdowEJ6djtqVwOtA.vapbB57jAu5m46kSTbM5yuhu0jGWyO6', 'loi@gmail.com', 1, 'default.jpg', '', ''),
(19, 'Nguyễn Văn Lâm', '0338307449', 'Nguyễn Văn Linh, P.Hưng Lợi, Q.Ninh Kiều, TP.Cần Thơ', '$2y$10$gJ8HPt3/AwM5MugGJpUYI.66NcFrmQuifiBhdVFQhLgMfZIyOQN.m', 'lamnguyen@gmail.com', 1, 'default.jpg', '', ''),
(28, 'luan', '123', 'ha noi', '$2y$10$50lNxAeNSHWFROKkvlBbPuffUBvSRwe7l5B6qoZ0gf87daO40XSRK', 'luanb2014670@student.ctu.edu.vn', 1, 'default.jpg', '2023-11-28 02:53:25', 'fd8266ddceba3218905ce08d14ff4cd66322'),
(29, 'a', '123', 'Hanoi', '$2y$10$PSjh6WIWKin1nqUL8WzOK.0cCuaZSDMMgKsiqUywLdibX2OTc2H02', 'luanga316@gmail.com', 1, 'default.jpg', '2023-11-26 07:44:17', 'c49d3acc90afe2059d248cc1454fdbc36132'),
(68, 'asd', '012345678910', 'Hai Phong', '$2y$10$12E5VMBpCXQPd7br3FSsMeLaBxphfL6gQHxMYKnppIVOxQEpojuC2', 'trungb2014801@student.ctu.edu.vn', 1, 'default.jpg', '2023-10-27 10:28:29', '1f505d06911f88a524aae974760d99bb880');

-- --------------------------------------------------------

--
-- Table structure for table `vegetables`
--

CREATE TABLE `vegetables` (
  `id` int(10) NOT NULL,
  `id_veg_type` int(10) NOT NULL,
  `id_orig` int(10) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `weight` int(10) DEFAULT 500,
  `price` decimal(10,0) NOT NULL,
  `sale` int(10) DEFAULT 0,
  `sale_price` decimal(10,0) DEFAULT NULL,
  `display` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `vegetables`
--

INSERT INTO `vegetables` (`id`, `id_veg_type`, `id_orig`, `name`, `image`, `weight`, `price`, `sale`, `sale_price`, `display`) VALUES
(1, 1, 2, 'Bạc hà', '1.jpg', 500, 5000, 1, 4000, 1),
(2, 1, 1, 'Bắp cải tím', '2.jpg', 1000, 10000, 0, NULL, 0),
(3, 1, 1, 'Bắp cải trắng', '3.jpg', 1000, 10000, 0, NULL, 0),
(4, 1, 1, 'Bắp chuối bào', '4.jpg', 500, 15000, 0, NULL, 0),
(5, 3, 1, 'Bắp non', '5.jpg', 500, 20000, 0, NULL, 0),
(6, 3, 1, 'Bầu', '6.jpg', 500, 5000, 1, 1500, 0),
(7, 3, 1, 'Bí đao', '7.jpg', 500, 5000, 1, 2000, 0),
(8, 3, 1, 'Bí Đỏ', '8.jpg', 500, 5000, 1, 4000, 0),
(9, 3, 1, 'Bí ngòi', '9.jpg', 500, 15000, 0, NULL, 0),
(10, 5, 1, 'Bông bí', '10.jpg', 500, 8000, 0, NULL, 0),
(11, 5, 1, 'Bông hẹ', '11.jpg', 500, 10000, 0, NULL, 0),
(12, 5, 1, 'Bông so đũa', '12.jpg', 500, 8000, 0, NULL, 0),
(13, 5, 2, 'Bông thiên lý', '13.jpg', 500, 20000, 0, NULL, 0),
(14, 3, 2, 'Cà chua', '14.jpg', 500, 6000, 0, NULL, 0),
(15, 3, 2, 'Cà pháo', '15.jpg', 500, 20000, 0, NULL, 0),
(16, 2, 2, 'Cà rốt', '16.jpg', 500, 8000, 0, NULL, 0),
(17, 3, 2, 'Cà tím', '17.jpg', 500, 7000, 0, NULL, 0),
(18, 1, 2, 'Cải bẹ dưa', '18.jpg', 500, 10000, 0, NULL, 0),
(19, 1, 3, 'Cải bẹ dún', '19.jpg', 500, 10000, 0, NULL, 0),
(20, 1, 3, 'Cải bẹ xanh', '20.jpg', 500, 10000, 0, NULL, 0),
(21, 1, 3, 'Cải bó xôi', '21.jpg', 500, 15000, 0, NULL, 0),
(22, 1, 3, 'Cải ngọt', '22.jpg', 500, 10000, 0, NULL, 0),
(23, 1, 3, 'Cải thảo', '23.jpg', 500, 10000, 0, NULL, 0),
(24, 1, 4, 'Cải xà lách', '24.jpg', 500, 10000, 1, 7500, 0),
(25, 1, 4, 'Xà lách tím', '25.jpg', 500, 15000, 1, 12000, 0),
(26, 1, 4, 'Xà lách xoong', '26.jpg', 500, 15000, 0, NULL, 0),
(27, 1, 4, 'Xà lách lụa', '27.jpg', 500, 15000, 0, NULL, 0),
(28, 1, 5, 'Cần dày lá', '28.jpg', 500, 5000, 0, NULL, 0),
(29, 1, 5, 'Cần tây', '29.jpg', 500, 10000, 0, NULL, 0),
(30, 1, 5, 'Cần ô', '30.jpg', 500, 15000, 0, NULL, 0),
(31, 3, 5, 'Chanh', '31.jpg', 500, 20000, 0, NULL, 0),
(32, 2, 6, 'Củ cải trắng', '32.jpg', 500, 5000, 0, NULL, 0),
(33, 2, 6, 'Củ dền', '33.jpg', 500, 7000, 0, NULL, 0),
(34, 3, 6, 'Đậu bắp', '34.jpg', 500, 8000, 0, NULL, 0),
(35, 1, 6, 'Đậu đũa', '35.jpg', 500, 7000, 0, NULL, 0),
(36, 1, 6, 'Đậu Hà Lan', '36.jpg', 500, 8000, 0, NULL, 0),
(37, 1, 7, 'Đậu que', '37.jpg', 500, 8000, 0, NULL, 0),
(38, 1, 7, 'Đậu rồng', '38.jpg', 500, 14000, 0, NULL, 0),
(39, 1, 7, 'Đậu ván', '39.jpg', 500, 15000, 0, NULL, 0),
(40, 3, 7, 'Dưa gang', '40.jpg', 500, 6500, 0, NULL, 0),
(41, 3, 7, 'Dưa leo', '41.jpg', 500, 12500, 0, NULL, 0),
(42, 2, 7, 'Gừng', '42.jpg', 500, 6000, 0, NULL, 0),
(43, 1, 7, 'Hành lá', '43.jpg', 500, 10000, 0, NULL, 0),
(44, 2, 8, 'Hành tây', '44.jpg', 500, 6000, 0, NULL, 0),
(45, 2, 8, 'Hành tím', '45.jpg', 500, 15000, 0, NULL, 0),
(46, 1, 8, 'Hẹ', '46.jpg', 500, 15000, 0, NULL, 0),
(47, 2, 8, 'Khoai cao', '47.jpg', 500, 12000, 0, NULL, 0),
(48, 2, 8, 'Khoai môn', '48.jpg', 500, 12000, 0, NULL, 0),
(49, 2, 8, 'Khoai lang', '49.jpg', 500, 10000, 0, NULL, 0),
(50, 2, 1, 'Khoai lang tím', '50.jpg', 500, 7000, 0, NULL, 0),
(51, 2, 1, 'Khoai mì', '51.jpg', 500, 6500, 0, NULL, 0),
(52, 2, 1, 'Khoai mỡ', '52.jpg', 500, 12000, 0, NULL, 0),
(53, 2, 1, 'Khoai tây', '53.jpg', 500, 7000, 0, NULL, 0),
(54, 2, 1, 'Khoai từ', '54.jpg', 500, 5000, 0, NULL, 0),
(55, 3, 1, 'Khổ qua', '55.jpg', 500, 10000, 0, NULL, 0),
(56, 1, 1, 'Lá lốt', '56.jpg', 500, 5000, 0, NULL, 0),
(57, 1, 2, 'Măng tây', '57.jpg', 500, 20000, 0, NULL, 0),
(58, 1, 2, 'Mồng tơi', '58.jpg', 500, 5000, 0, NULL, 0),
(59, 3, 2, 'Mướp', '59.jpg', 500, 7000, 0, NULL, 0),
(60, 4, 2, 'Nấm bào ngư', '60.jpg', 500, 15000, 0, NULL, 0),
(61, 4, 2, 'Nấm đông cô', '61.jpg', 500, 15000, 0, NULL, 0),
(62, 4, 3, 'Nấm kim châm', '62.jpg', 500, 15000, 0, NULL, 0),
(63, 4, 3, 'Nấm rơm', '63.jpg', 500, 40000, 0, NULL, 0),
(64, 2, 3, 'Nghệ', '64.jpg', 500, 6000, 0, NULL, 0),
(65, 1, 5, 'Ngò gai', '65.jpg', 500, 4500, 0, NULL, 0),
(66, 1, 7, 'Ngò om', '66.jpg', 500, 4500, 0, NULL, 0),
(67, 1, 4, 'Ngò rí', '67.jpg', 500, 7000, 0, NULL, 0),
(68, 3, 8, 'Ớt chuông', '68.jpg', 500, 30000, 0, NULL, 0),
(69, 3, 4, 'Ớt đỏ', '69.jpg', 500, 25000, 0, NULL, 0),
(70, 1, 7, 'Rau dền', '70.jpg', 500, 10000, 0, NULL, 0),
(71, 1, 3, 'Rau diếp cá', '71.jpg', 500, 7500, 0, NULL, 0),
(72, 1, 6, 'Rau húng nhũi', '72.jpg', 500, 5000, 0, NULL, 0),
(73, 1, 2, 'Rau húng quế', '73.jpg', 500, 5000, 0, NULL, 0),
(74, 1, 7, 'Rau má', '74.jpg', 500, 12500, 0, NULL, 0),
(75, 1, 6, 'Rau muống', '75.jpg', 500, 5000, 0, NULL, 0),
(76, 1, 8, 'Rau nhút', '76.jpg', 500, 8000, 0, NULL, 0),
(77, 1, 8, 'Rau răm', '77.jpg', 500, 13500, 0, NULL, 0),
(78, 2, 6, 'Riềng', '78.jpg', 500, 6500, 0, NULL, 0),
(79, 3, 4, 'Su hào', '79.jpg', 500, 5000, 0, NULL, 0),
(80, 1, 6, 'Bông cải trắng', '80.jpg', 500, 10000, 0, NULL, 0),
(81, 1, 2, 'Bông cải xanh', '81.jpg', 500, 10000, 0, NULL, 0),
(82, 1, 3, 'Thì là', '82.jpg', 500, 5000, 0, NULL, 0),
(83, 1, 5, 'Tía tô', '83.jpg', 500, 15500, 0, NULL, 0),
(84, 2, 1, 'Tỏi', '84.jpg', 500, 12000, 0, NULL, 0),
(85, 1, 5, 'Sả', '85.jpg', 500, 6000, 0, NULL, 0),
(86, 5, 3, 'Bông điên điển', '86.jpg', 500, 40000, 0, NULL, 0),
(87, 5, 6, 'Bông súng', '87.jpg', 500, 10000, 0, NULL, 0),
(88, 3, 8, 'Dưa lưới', '88.jpg', 1000, 35000, 0, NULL, 0),
(89, 1, 1, 'Giá đậu', '89.jpg', 500, 5000, 0, NULL, 0),
(90, 4, 7, 'Nấm mèo', '90.jpg', 500, 40000, 0, NULL, 0),
(91, 1, 5, 'Măng tre', '91.jpg', 500, 30000, 0, NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `veg_types`
--

CREATE TABLE `veg_types` (
  `id` int(10) NOT NULL,
  `name` varchar(255) NOT NULL,
  `image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `veg_types`
--

INSERT INTO `veg_types` (`id`, `name`, `image`) VALUES
(1, 'Rau', '1.jpg'),
(2, 'Củ', '2.jpg'),
(3, 'Quả', '3.jpg'),
(4, 'Nấm', '4.jpg'),
(5, 'Bông', '5.jpg'),
(6, 'Hạt', '6.jpg');

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_userlist`
-- (See below for the actual view)
--
CREATE TABLE `v_userlist` (
`ID` int(10)
,`NAME` varchar(255)
,`PHONE` varchar(255)
,`ADDRESS` varchar(255)
,`EMAIL` varchar(255)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_veglist`
-- (See below for the actual view)
--
CREATE TABLE `v_veglist` (
`ID` int(10)
,`NAME` varchar(255)
,`WEIGHT` int(10)
,`PRICE` decimal(10,0)
,`TYPE` varchar(255)
,`SEED` varchar(255)
,`PLANTING` varchar(255)
);

-- --------------------------------------------------------

--
-- Table structure for table `warehouse`
--

CREATE TABLE `warehouse` (
  `id` int(11) NOT NULL,
  `id_vegetable` int(11) NOT NULL,
  `entry_date` date NOT NULL DEFAULT current_timestamp(),
  `expired_date` date DEFAULT NULL,
  `quantity` float(11,3) NOT NULL,
  `stock` float(11,3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `warehouse`
--

INSERT INTO `warehouse` (`id`, `id_vegetable`, `entry_date`, `expired_date`, `quantity`, `stock`) VALUES
(1, 2, '2023-11-11', '2023-11-29', 100.000, 100.000),
(2, 2, '2023-11-12', '2023-11-03', 500.000, 49.000),
(6, 2, '2023-11-21', '2023-11-21', 150.000, 145.000),
(9, 1, '2023-11-22', '2023-11-30', 10.000, 1.500);

-- --------------------------------------------------------

--
-- Structure for view `v_userlist`
--
DROP TABLE IF EXISTS `v_userlist`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_userlist`  AS SELECT `users`.`id` AS `ID`, `users`.`name` AS `NAME`, `users`.`phone` AS `PHONE`, `users`.`address` AS `ADDRESS`, `users`.`email` AS `EMAIL` FROM `users` ;

-- --------------------------------------------------------

--
-- Structure for view `v_veglist`
--
DROP TABLE IF EXISTS `v_veglist`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_veglist`  AS SELECT `v`.`id` AS `ID`, `v`.`name` AS `NAME`, `v`.`weight` AS `WEIGHT`, `v`.`price` AS `PRICE`, `t`.`name` AS `TYPE`, `o`.`seed` AS `SEED`, `o`.`planting_place` AS `PLANTING` FROM ((`vegetables` `v` join `veg_types` `t` on(`t`.`id` = `v`.`id_veg_type`)) join `originals` `o` on(`v`.`id_orig` = `o`.`id`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `carts`
--
ALTER TABLE `carts`
  ADD PRIMARY KEY (`id_user`,`id_veg`) USING BTREE,
  ADD KEY `fk_cart_veg` (`id_veg`) USING BTREE;

--
-- Indexes for table `feedbacks`
--
ALTER TABLE `feedbacks`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `fbk_user` (`id_user`) USING BTREE,
  ADD KEY `fbk_veg` (`id_veg`) USING BTREE;

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `fk_oder_status` (`id_status`) USING BTREE,
  ADD KEY `fk_order_user` (`id_user`) USING BTREE;

--
-- Indexes for table `order_details`
--
ALTER TABLE `order_details`
  ADD PRIMARY KEY (`id_order`,`id_veg`) USING BTREE,
  ADD KEY `fk_veg_detail` (`id_veg`) USING BTREE;

--
-- Indexes for table `originals`
--
ALTER TABLE `originals`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `status`
--
ALTER TABLE `status`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `vegetables`
--
ALTER TABLE `vegetables`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `fk_veg_type` (`id_veg_type`) USING BTREE,
  ADD KEY `fk_veg_orig` (`id_orig`) USING BTREE;

--
-- Indexes for table `veg_types`
--
ALTER TABLE `veg_types`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `warehouse`
--
ALTER TABLE `warehouse`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_ware_vege` (`id_vegetable`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `feedbacks`
--
ALTER TABLE `feedbacks`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=129;

--
-- AUTO_INCREMENT for table `originals`
--
ALTER TABLE `originals`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `status`
--
ALTER TABLE `status`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;

--
-- AUTO_INCREMENT for table `vegetables`
--
ALTER TABLE `vegetables`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=104;

--
-- AUTO_INCREMENT for table `veg_types`
--
ALTER TABLE `veg_types`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `warehouse`
--
ALTER TABLE `warehouse`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `carts`
--
ALTER TABLE `carts`
  ADD CONSTRAINT `fk_cart_user` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `fk_cart_veg` FOREIGN KEY (`id_veg`) REFERENCES `vegetables` (`id`);

--
-- Constraints for table `feedbacks`
--
ALTER TABLE `feedbacks`
  ADD CONSTRAINT `fbk_user` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `fbk_veg` FOREIGN KEY (`id_veg`) REFERENCES `vegetables` (`id`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_oder_status` FOREIGN KEY (`id_status`) REFERENCES `status` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_order_user` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_details`
--
ALTER TABLE `order_details`
  ADD CONSTRAINT `fk_order_detail` FOREIGN KEY (`id_order`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_veg_detail` FOREIGN KEY (`id_veg`) REFERENCES `vegetables` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `vegetables`
--
ALTER TABLE `vegetables`
  ADD CONSTRAINT `fk_veg_orig` FOREIGN KEY (`id_orig`) REFERENCES `originals` (`id`),
  ADD CONSTRAINT `fk_veg_type` FOREIGN KEY (`id_veg_type`) REFERENCES `veg_types` (`id`);

--
-- Constraints for table `warehouse`
--
ALTER TABLE `warehouse`
  ADD CONSTRAINT `fk_ware_vege` FOREIGN KEY (`id_vegetable`) REFERENCES `vegetables` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
