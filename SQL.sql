CREATE TABLE IF NOT EXISTS `owned_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(50) NOT NULL,
  `plate` varchar(10) NOT NULL,
  `vehicle_props` longtext NOT NULL,
  `state` longtext NOT NULL,
  `fuel` float NOT NULL DEFAULT 100,
  `engine` float NOT NULL DEFAULT 1000.0,
  `body` float NOT NULL DEFAULT 1000.0,
  `tarp` int(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_plate` (`plate`),
  KEY `owner_index` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
