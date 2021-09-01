CREATE TABLE IF NOT EXISTS `user_fines` (
  `id` int NOT NULL AUTO_INCREMENT,
  `owner` varchar(55) NOT NULL,
  `ownerCharId` int(2) NULL,
  `ownerName` varchar(255) NOT NULL,
  `price` int(55) NOT NULL,
  `fine` varchar(255) NOT NULL,
  `giver` varchar(55) NOT NULL,
  `giverCharId` int(2) NOT NULL,
  `giverName` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
