-- Database Schema for SkyChauffeur (Plane Borrow System)
-- Database: plane_borrow

CREATE DATABASE IF NOT EXISTS `plane_borrow` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `plane_borrow`;

-- --------------------------------------------------------
-- Table structure for table `users`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `users` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `username` VARCHAR(100) NOT NULL UNIQUE,
  `email` VARCHAR(100) NOT NULL UNIQUE,
  `password` VARCHAR(255) NOT NULL,
  `role_id` INT NOT NULL COMMENT '1 = Student, 2 = Staff, 3 = Lecturer',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Table structure for table `plane`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `plane` (
  `planeID` INT AUTO_INCREMENT PRIMARY KEY,
  `planeName` VARCHAR(100) NOT NULL,
  `planeTitle` VARCHAR(100) DEFAULT 'General Aviation',
  `status` INT DEFAULT 1 COMMENT '1 = Available, 0 = Unavailable, 2 = Pending/Borrowed',
  `category` VARCHAR(50) DEFAULT 'Commercial',
  `seat` VARCHAR(20) DEFAULT '4 SEAT',
  `planeDescription` TEXT,
  `tailNumber` VARCHAR(50),
  `image` VARCHAR(100) DEFAULT 'airplane.jpg',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Table structure for table `rqtPlane`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `rqtPlane` (
  `requestID` INT AUTO_INCREMENT PRIMARY KEY,
  `planeID` INT NOT NULL,
  `rqtBy` INT NOT NULL,
  `bDate` DATE NOT NULL,
  `rDate` DATE NOT NULL,
  `rqtStatus` INT DEFAULT 0 COMMENT '0 = Pending, 1 = Approved, 2 = Rejected',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`planeID`) REFERENCES `plane`(`planeID`) ON DELETE CASCADE,
  FOREIGN KEY (`rqtBy`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Table structure for table `history`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `history` (
  `historyId` INT AUTO_INCREMENT PRIMARY KEY,
  `planeId` INT NOT NULL,
  `rqtBy` INT NOT NULL,
  `bDate` DATE NOT NULL,
  `rDate` DATE NOT NULL,
  `approved` INT DEFAULT NULL,
  `Lender` INT DEFAULT NULL,
  `ApprovedStatus` INT DEFAULT 1 COMMENT '1 = Approved, 0 = Rejected',
  `ReturnStaus` INT DEFAULT 0 COMMENT '1 = Returned, 0 = Not Returned',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`planeId`) REFERENCES `plane`(`planeID`) ON DELETE CASCADE,
  FOREIGN KEY (`rqtBy`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Seed Initial Data
-- Passwords are hashed with SHA-256 for: "password123"
-- SHA-256("password123") = ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f
-- --------------------------------------------------------

INSERT INTO `users` (`id`, `username`, `email`, `password`, `role_id`) VALUES
(1, 'student1', 'student1@example.com', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 1),
(2, 'staff1', 'staff1@example.com', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 2),
(3, 'lecturer1', 'lecturer1@example.com', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 3)
ON DUPLICATE KEY UPDATE `username`=`username`;

INSERT INTO `plane` (`planeID`, `planeName`, `planeTitle`, `status`, `category`, `seat`, `planeDescription`, `tailNumber`, `image`) VALUES
(1, 'Diamond DA40', 'General Aviation', 1, 'Single-Engine', '4 SEAT', 'Modern four-seat, single-engine light aircraft ideal for flight training and cross-country touring.', 'HS-DA40', 'Diamond DA40.png'),
(2, 'CESSNA 172', 'General Aviation', 1, 'Single-Engine', '4 SEAT', 'The most successful aircraft in history, reliable, stable, and widely used for primary flight training.', 'HS-C172', 'CESSANA 172.png'),
(3, 'Cirrus SR-22T', 'General Aviation', 1, 'High-Performance', '5 SEAT', 'Composite high-performance aircraft equipped with Cirrus Airframe Parachute System (CAPS).', 'HS-SR22', 'Cirrus SR-22T.png'),
(4, 'Beechcraft Bonanza G36', 'General Aviation', 1, 'Piston', '6 SEAT', 'Top-tier luxury piston single offering first-class comfort, speed, and spacious 6-seat configuration.', 'HS-G36', 'Beechcraft Bonanza G36.png'),
(5, 'Embraer Phenom 300', 'Business Jet', 1, 'Twin-Jet', '8 SEAT', 'One of the best-selling light jets in the world with superior range and speed.', 'HS-P300', 'Embraer Phonom 300.png'),
(6, 'Gulfstream G280', 'Business Jet', 1, 'Twin-Jet', '10 SEAT', 'Super-midsize business jet delivering exceptional transcontinental speed and agility.', 'HS-G280', 'Gulfstream G280.png')
ON DUPLICATE KEY UPDATE `planeName`=`planeName`;
