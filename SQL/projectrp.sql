-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost
-- Généré le : mer. 01 mars 2023 à 18:44
-- Version du serveur : 10.3.36-MariaDB-0+deb10u2
-- Version de PHP : 7.3.31-1~deb10u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `titidev`
--

-- --------------------------------------------------------

--
-- Structure de la table `addon_account`
--

CREATE TABLE `addon_account` (
  `name` varchar(60) NOT NULL,
  `label` varchar(100) NOT NULL,
  `shared` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `addon_account`
--

INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
('bank_savings', 'Savings account', 0),
('caution', 'caution', 0),
('society_ambulance', 'Ambulance', 1),
('society_cardealer', 'Concessionnaire', 1),
('society_circlebar', 'Circlebar\r\n', 1),
('society_mechanic', 'Mécanicien', 1),
('society_police', 'Police', 1),
('society_unipunk', 'Unipunk', 1),
('society_yellowpunk', 'Yellow Punk', 1);

-- --------------------------------------------------------

--
-- Structure de la table `addon_account_data`
--

CREATE TABLE `addon_account_data` (
  `id` int(11) NOT NULL,
  `account_name` varchar(100) DEFAULT NULL,
  `money` int(11) NOT NULL,
  `owner` varchar(54) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `addon_account_data`
--

INSERT INTO `addon_account_data` (`id`, `account_name`, `money`, `owner`) VALUES
(2, 'society_police', 0, NULL),
(3, 'society_ambulance', 0, NULL),
(4, 'society_mechanic', 0, NULL),
(9, 'bank_savings', 0, 'char1:88fa041731c1df91525e9989b886d9b5ad6a823e'),
(10, 'caution', 0, 'char1:88fa041731c1df91525e9989b886d9b5ad6a823e'),
(11, 'society_cardealer', 0, NULL),
(12, 'society_circlebar', 990, NULL),
(13, 'society_unipunk', 19987, NULL),
(14, 'society_yellowpunk', 0, NULL),
(15, 'bank_savings', 0, 'char1:8340435dc4123fabfe5375ca9adc59d4080a1ffc'),
(16, 'caution', 0, 'char1:8340435dc4123fabfe5375ca9adc59d4080a1ffc'),
(17, 'bank_savings', 0, 'char1:25eef2569a0c022520feace01c62c4dfb720b62b'),
(18, 'caution', 0, 'char1:25eef2569a0c022520feace01c62c4dfb720b62b');

-- --------------------------------------------------------

--
-- Structure de la table `addon_inventory`
--

CREATE TABLE `addon_inventory` (
  `name` varchar(60) NOT NULL,
  `label` varchar(100) NOT NULL,
  `shared` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `addon_inventory`
--

INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
('society_ambulance', 'EMS', 1),
('society_cardealer', 'Concesionnaire', 1),
('society_circlebar', 'Circlebar', 1),
('society_mechanic', 'Mechanic', 1),
('society_police', 'Police', 1),
('society_unipunk', 'Unipunk\n', 1),
('society_yellowpunk', 'Yellow Punk', 1);

-- --------------------------------------------------------

--
-- Structure de la table `addon_inventory_items`
--

CREATE TABLE `addon_inventory_items` (
  `id` int(11) NOT NULL,
  `inventory_name` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `count` int(11) NOT NULL,
  `owner` varchar(54) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `banking`
--

CREATE TABLE `banking` (
  `identifier` varchar(54) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `amount` int(64) DEFAULT NULL,
  `time` bigint(20) DEFAULT NULL,
  `ID` int(11) NOT NULL,
  `balance` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `banking`
--

INSERT INTO `banking` (`identifier`, `type`, `amount`, `time`, `ID`, `balance`) VALUES
('char1:88fa041731c1df91525e9989b886d9b5ad6a823e', 'DEPOSIT', 10000, 1677339916000, 1, 10000),
('char1:88fa041731c1df91525e9989b886d9b5ad6a823e', 'DEPOSIT', 10000, 1677340245000, 2, 10000),
('char1:88fa041731c1df91525e9989b886d9b5ad6a823e', 'DEPOSIT', 10, 1677340252000, 3, 10010),
('char1:88fa041731c1df91525e9989b886d9b5ad6a823e', 'WITHDRAW', 10, 1677340268000, 4, 50190),
('char1:88fa041731c1df91525e9989b886d9b5ad6a823e', 'WITHDRAW', 50190, 1677340276000, 5, 0),
('char1:88fa041731c1df91525e9989b886d9b5ad6a823e', 'DEPOSIT', 120190, 1677340289000, 6, 120190),
('char1:88fa041731c1df91525e9989b886d9b5ad6a823e', 'WITHDRAW', 10000, 1677340561000, 7, 40000);

-- --------------------------------------------------------

--
-- Structure de la table `billing`
--

CREATE TABLE `billing` (
  `id` int(11) NOT NULL,
  `identifier` varchar(54) DEFAULT NULL,
  `sender` varchar(60) NOT NULL,
  `target_type` varchar(50) NOT NULL,
  `target` varchar(40) NOT NULL,
  `label` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `cardealer_vehicles`
--

CREATE TABLE `cardealer_vehicles` (
  `id` int(11) NOT NULL,
  `vehicle` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `crypto`
--

CREATE TABLE `crypto` (
  `identifier` varchar(54) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `amount` int(64) DEFAULT NULL,
  `time` bigint(20) DEFAULT NULL,
  `ID` int(11) NOT NULL,
  `balance` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `crypto`
--

INSERT INTO `crypto` (`identifier`, `type`, `amount`, `time`, `ID`, `balance`) VALUES
('char1:25eef2569a0c022520feace01c62c4dfb720b62b', 'TRANSFER_RECEIVE', 100, 1677607240000, 1, 100);

-- --------------------------------------------------------

--
-- Structure de la table `datastore`
--

CREATE TABLE `datastore` (
  `name` varchar(60) NOT NULL,
  `label` varchar(100) NOT NULL,
  `shared` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `datastore`
--

INSERT INTO `datastore` (`name`, `label`, `shared`) VALUES
('property', 'Property', 1),
('society_ambulance', 'EMS', 1),
('society_circlebar', 'Circlebar', 1),
('society_mechanic', 'Mechanic', 1),
('society_police', 'Police', 1),
('society_unipunk', 'Unipunk', 1),
('society_yellowpunk', 'Yellow Punk', 1),
('user_ears', 'Ears', 0),
('user_glasses', 'Glasses', 0),
('user_helmet', 'Helmet', 0),
('user_mask', 'Mask', 0);

-- --------------------------------------------------------

--
-- Structure de la table `datastore_data`
--

CREATE TABLE `datastore_data` (
  `id` int(11) NOT NULL,
  `name` varchar(60) NOT NULL,
  `owner` varchar(54) DEFAULT NULL,
  `data` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `datastore_data`
--

INSERT INTO `datastore_data` (`id`, `name`, `owner`, `data`) VALUES
(1, 'society_police', NULL, '{}'),
(2, 'society_ambulance', NULL, '{}'),
(3, 'society_mechanic', NULL, '{}'),
(6, 'user_ears', 'char1:88fa041731c1df91525e9989b886d9b5ad6a823e', '{}'),
(7, 'user_helmet', 'char1:88fa041731c1df91525e9989b886d9b5ad6a823e', '{}'),
(8, 'user_mask', 'char1:88fa041731c1df91525e9989b886d9b5ad6a823e', '{}'),
(9, 'user_glasses', 'char1:88fa041731c1df91525e9989b886d9b5ad6a823e', '{}'),
(10, 'property', NULL, '{}'),
(11, 'property', NULL, '{}'),
(12, 'property', NULL, '{}'),
(13, 'society_circlebar', NULL, '\'{}\''),
(14, 'society_unipunk', NULL, '\'{}\''),
(15, 'society_yellowpunk', NULL, '\'{}\''),
(16, 'property', NULL, '{}'),
(17, 'property', NULL, '{}'),
(18, 'property', NULL, '{}'),
(19, 'property', NULL, '{}'),
(20, 'property', NULL, '{}'),
(21, 'property', NULL, '{}'),
(22, 'property', NULL, '{}'),
(23, 'property', NULL, '{}'),
(24, 'property', NULL, '{}'),
(25, 'property', NULL, '{}'),
(26, 'property', NULL, '{}'),
(27, 'property', NULL, '{}'),
(28, 'property', NULL, '{}'),
(29, 'user_ears', 'char1:8340435dc4123fabfe5375ca9adc59d4080a1ffc', '{}'),
(30, 'user_helmet', 'char1:8340435dc4123fabfe5375ca9adc59d4080a1ffc', '{}'),
(31, 'user_mask', 'char1:8340435dc4123fabfe5375ca9adc59d4080a1ffc', '{}'),
(32, 'user_glasses', 'char1:8340435dc4123fabfe5375ca9adc59d4080a1ffc', '{}'),
(33, 'property', NULL, '{}'),
(34, 'property', NULL, '{}'),
(35, 'property', NULL, '{}'),
(36, 'user_ears', 'char1:25eef2569a0c022520feace01c62c4dfb720b62b', '{}'),
(37, 'user_helmet', 'char1:25eef2569a0c022520feace01c62c4dfb720b62b', '{}'),
(38, 'user_mask', 'char1:25eef2569a0c022520feace01c62c4dfb720b62b', '{}'),
(39, 'user_glasses', 'char1:25eef2569a0c022520feace01c62c4dfb720b62b', '{}'),
(40, 'property', NULL, '{}');

-- --------------------------------------------------------

--
-- Structure de la table `delta_groups`
--

CREATE TABLE `delta_groups` (
  `identifier` varchar(54) NOT NULL,
  `label` varchar(50) NOT NULL,
  `powerIndex` int(11) NOT NULL,
  `permissions` text NOT NULL,
  `color` varchar(50) NOT NULL,
  `data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `delta_groups`
--

INSERT INTO `delta_groups` (`identifier`, `label`, `powerIndex`, `permissions`, `color`, `data`) VALUES
('dev', 'Développeur', 1000, '[\"*\"]', 'white', '[]');

-- --------------------------------------------------------

--
-- Structure de la table `delta_players`
--

CREATE TABLE `delta_players` (
  `identifier` varchar(54) NOT NULL,
  `groups` text NOT NULL,
  `data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `delta_players`
--

INSERT INTO `delta_players` (`identifier`, `groups`, `data`) VALUES
('license:25eef2569a0c022520feace01c62c4dfb720b62b', '[\"dev\"]', '[]'),
('license:88fa041731c1df91525e9989b886d9b5ad6a823e', '[\"dev\"]', '[]');

-- --------------------------------------------------------

--
-- Structure de la table `items`
--

CREATE TABLE `items` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `weight` int(11) NOT NULL DEFAULT 1,
  `rare` tinyint(4) NOT NULL DEFAULT 0,
  `can_remove` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `jobs`
--

CREATE TABLE `jobs` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) DEFAULT NULL,
  `whitelisted` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `jobs`
--

INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
('ambulance', 'EMS', 0),
('cardealer', 'Concessionnaire', 0),
('circlebar', 'Circlebar', 0),
('mechanic', 'Mécanicien', 0),
('police', 'LSPD', 0),
('unemployed', 'Unemployed', 0),
('unipunk', 'Unipunk', 0),
('yellowpunk', 'Yellow Punk', 0);

-- --------------------------------------------------------

--
-- Structure de la table `job_grades`
--

CREATE TABLE `job_grades` (
  `id` int(11) NOT NULL,
  `job_name` varchar(50) DEFAULT NULL,
  `grade` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `salary` int(11) NOT NULL,
  `skin_male` longtext NOT NULL,
  `skin_female` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `job_grades`
--

INSERT INTO `job_grades` (`id`, `job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
(1, 'unemployed', 0, 'unemployed', 'Sans Emploie', 200, '{}', '{}'),
(2, 'police', 0, 'recruit', 'Cadet', 20, '{}', '{}'),
(3, 'police', 1, 'officer', 'Officier', 40, '{}', '{}'),
(4, 'police', 2, 'sergeant', 'Sergent', 60, '{}', '{}'),
(5, 'police', 3, 'coboss', 'Lieutenant', 85, '{}', '{}'),
(6, 'police', 4, 'boss', 'Le Pacha', 100, '{}', '{}'),
(22, 'ambulance', 0, 'ambulance', 'Recrue', 20, '{\"tshirt_2\":0,\"hair_color_1\":5,\"glasses_2\":3,\"shoes\":9,\"torso_2\":3,\"hair_color_2\":0,\"pants_1\":24,\"glasses_1\":4,\"hair_1\":2,\"sex\":0,\"decals_2\":0,\"tshirt_1\":15,\"helmet_1\":8,\"helmet_2\":0,\"arms\":92,\"face\":19,\"decals_1\":60,\"torso_1\":13,\"hair_2\":0,\"skin\":34,\"pants_2\":5}', '{\"tshirt_2\":3,\"decals_2\":0,\"glasses\":0,\"hair_1\":2,\"torso_1\":73,\"shoes\":1,\"hair_color_2\":0,\"glasses_1\":19,\"skin\":13,\"face\":6,\"pants_2\":5,\"tshirt_1\":75,\"pants_1\":37,\"helmet_1\":57,\"torso_2\":0,\"arms\":14,\"sex\":1,\"glasses_2\":0,\"decals_1\":0,\"hair_2\":0,\"helmet_2\":0,\"hair_color_1\":0}'),
(23, 'ambulance', 1, 'doctor', 'Sauveteur', 40, '{\"tshirt_2\":0,\"hair_color_1\":5,\"glasses_2\":3,\"shoes\":9,\"torso_2\":3,\"hair_color_2\":0,\"pants_1\":24,\"glasses_1\":4,\"hair_1\":2,\"sex\":0,\"decals_2\":0,\"tshirt_1\":15,\"helmet_1\":8,\"helmet_2\":0,\"arms\":92,\"face\":19,\"decals_1\":60,\"torso_1\":13,\"hair_2\":0,\"skin\":34,\"pants_2\":5}', '{\"tshirt_2\":3,\"decals_2\":0,\"glasses\":0,\"hair_1\":2,\"torso_1\":73,\"shoes\":1,\"hair_color_2\":0,\"glasses_1\":19,\"skin\":13,\"face\":6,\"pants_2\":5,\"tshirt_1\":75,\"pants_1\":37,\"helmet_1\":57,\"torso_2\":0,\"arms\":14,\"sex\":1,\"glasses_2\":0,\"decals_1\":0,\"hair_2\":0,\"helmet_2\":0,\"hair_color_1\":0}'),
(24, 'ambulance', 2, 'coboss', 'Protecteur', 60, '{\"tshirt_2\":0,\"hair_color_1\":5,\"glasses_2\":3,\"shoes\":9,\"torso_2\":3,\"hair_color_2\":0,\"pants_1\":24,\"glasses_1\":4,\"hair_1\":2,\"sex\":0,\"decals_2\":0,\"tshirt_1\":15,\"helmet_1\":8,\"helmet_2\":0,\"arms\":92,\"face\":19,\"decals_1\":60,\"torso_1\":13,\"hair_2\":0,\"skin\":34,\"pants_2\":5}', '{\"tshirt_2\":3,\"decals_2\":0,\"glasses\":0,\"hair_1\":2,\"torso_1\":73,\"shoes\":1,\"hair_color_2\":0,\"glasses_1\":19,\"skin\":13,\"face\":6,\"pants_2\":5,\"tshirt_1\":75,\"pants_1\":37,\"helmet_1\":57,\"torso_2\":0,\"arms\":14,\"sex\":1,\"glasses_2\":0,\"decals_1\":0,\"hair_2\":0,\"helmet_2\":0,\"hair_color_1\":0}'),
(25, 'ambulance', 3, 'boss', 'Directeur', 80, '{\"tshirt_2\":0,\"hair_color_1\":5,\"glasses_2\":3,\"shoes\":9,\"torso_2\":3,\"hair_color_2\":0,\"pants_1\":24,\"glasses_1\":4,\"hair_1\":2,\"sex\":0,\"decals_2\":0,\"tshirt_1\":15,\"helmet_1\":8,\"helmet_2\":0,\"arms\":92,\"face\":19,\"decals_1\":60,\"torso_1\":13,\"hair_2\":0,\"skin\":34,\"pants_2\":5}', '{\"tshirt_2\":3,\"decals_2\":0,\"glasses\":0,\"hair_1\":2,\"torso_1\":73,\"shoes\":1,\"hair_color_2\":0,\"glasses_1\":19,\"skin\":13,\"face\":6,\"pants_2\":5,\"tshirt_1\":75,\"pants_1\":37,\"helmet_1\":57,\"torso_2\":0,\"arms\":14,\"sex\":1,\"glasses_2\":0,\"decals_1\":0,\"hair_2\":0,\"helmet_2\":0,\"hair_color_1\":0}'),
(26, 'mechanic', 0, 'recrue', 'Apprenti', 12, '{}', '{}'),
(27, 'mechanic', 1, 'novice', 'Dépanneur', 24, '{}', '{}'),
(28, 'mechanic', 2, 'experimente', 'Expérimenter', 36, '{}', '{}'),
(29, 'mechanic', 3, 'coboss', 'Chef', 48, '{}', '{}'),
(30, 'mechanic', 4, 'boss', 'Patron', 0, '{}', '{}'),
(41, 'cardealer', 0, 'recruit', 'Recrue', 10, '{}', '{}'),
(42, 'cardealer', 1, 'novice', 'Novice', 25, '{}', '{}'),
(43, 'cardealer', 2, 'experienced', 'Experimente', 40, '{}', '{}'),
(44, 'cardealer', 3, 'boss', 'Patron', 0, '{}', '{}'),
(61, 'unipunk', 0, 'videur', 'Videur', 10, '{}', '{}'),
(62, 'unipunk', 1, 'barman', 'Barman', 10, '{}', '{}'),
(63, 'unipunk', 2, 'coboss', 'Bras-droit', 10, '{}', '{}'),
(64, 'unipunk', 3, 'boss', 'Patron', 10, '{}', '{}'),
(65, 'yellowpunk', 0, 'videur', 'Videur', 10, '{}', '{}'),
(66, 'yellowpunk', 1, 'barman', 'Barman', 10, '{}', '{}'),
(67, 'yellowpunk', 2, 'coboss', 'Bras-droit', 10, '{}', '{}'),
(68, 'yellowpunk', 3, 'boss', 'Patron', 10, '{}', '{}'),
(69, 'circlebar', 0, 'videur', 'Videur', 10, '{}', '{}'),
(70, 'circlebar', 1, 'barman', 'Barman', 10, '{}', '{}'),
(71, 'circlebar', 2, 'coboss', 'Bras-droit', 10, '{}', '{}'),
(72, 'circlebar', 3, 'boss', 'Patron', 10, '{}', '{}');

-- --------------------------------------------------------

--
-- Structure de la table `licenses`
--

CREATE TABLE `licenses` (
  `type` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `licenses`
--

INSERT INTO `licenses` (`type`, `label`) VALUES
('drive', 'Permis de conduire'),
('drive_bike', 'Permis deux roues'),
('drive_truck', 'Permis poids lourd'),
('weapon', 'Permis de port d\'arme');

-- --------------------------------------------------------

--
-- Structure de la table `mdt_codes`
--

CREATE TABLE `mdt_codes` (
  `id` int(11) NOT NULL,
  `code` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `mdt_evidences`
--

CREATE TABLE `mdt_evidences` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `images` mediumtext DEFAULT NULL,
  `players` mediumtext DEFAULT NULL,
  `description` mediumtext NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `mdt_fines`
--

CREATE TABLE `mdt_fines` (
  `id` int(11) NOT NULL,
  `code` varchar(255) DEFAULT NULL,
  `name` mediumtext DEFAULT NULL,
  `amount` int(11) DEFAULT 0,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `mdt_incidents`
--

CREATE TABLE `mdt_incidents` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` mediumtext DEFAULT NULL,
  `players` mediumtext DEFAULT NULL,
  `cops` mediumtext DEFAULT NULL,
  `vehicles` mediumtext DEFAULT NULL,
  `evidences` mediumtext DEFAULT NULL,
  `fines` mediumtext DEFAULT NULL,
  `jail` mediumtext DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `mdt_jail`
--

CREATE TABLE `mdt_jail` (
  `id` int(11) NOT NULL,
  `name` mediumtext DEFAULT NULL,
  `time` int(11) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `mdt_warrants`
--

CREATE TABLE `mdt_warrants` (
  `id` int(11) NOT NULL,
  `wtype` varchar(255) NOT NULL,
  `players` mediumtext NOT NULL DEFAULT '[]',
  `house` varchar(255) DEFAULT NULL,
  `reason` mediumtext NOT NULL,
  `description` mediumtext NOT NULL,
  `done` tinyint(1) NOT NULL DEFAULT 0,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `multicharacter_slots`
--

CREATE TABLE `multicharacter_slots` (
  `identifier` varchar(54) NOT NULL,
  `slots` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `outfits`
--

CREATE TABLE `outfits` (
  `id` int(11) NOT NULL,
  `identifier` varchar(54) DEFAULT NULL,
  `name` longtext DEFAULT NULL,
  `ped` longtext DEFAULT NULL,
  `components` longtext DEFAULT NULL,
  `props` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `owned_vehicles`
--

CREATE TABLE `owned_vehicles` (
  `owner` varchar(54) DEFAULT NULL,
  `plate` varchar(12) NOT NULL,
  `vehicle` longtext DEFAULT NULL,
  `type` varchar(20) NOT NULL DEFAULT 'car',
  `job` varchar(20) DEFAULT NULL,
  `stored` tinyint(4) NOT NULL DEFAULT 0,
  `parking` varchar(60) DEFAULT NULL,
  `pound` varchar(60) DEFAULT NULL,
  `glovebox` longtext DEFAULT NULL,
  `trunk` longtext DEFAULT NULL,
  `mdt_image` mediumtext DEFAULT NULL,
  `mdt_description` mediumtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `ox_inventory`
--

CREATE TABLE `ox_inventory` (
  `owner` varchar(54) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `data` longtext DEFAULT NULL,
  `lastupdated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `phone_ads`
--

CREATE TABLE `phone_ads` (
  `id` int(11) NOT NULL,
  `owner` varchar(54) DEFAULT NULL,
  `category` varchar(50) DEFAULT 'default',
  `author` varchar(255) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `content` varchar(512) DEFAULT NULL,
  `data` varchar(255) DEFAULT NULL,
  `image` varchar(255) NOT NULL DEFAULT '',
  `time` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `phone_chats`
--

CREATE TABLE `phone_chats` (
  `id` int(11) NOT NULL,
  `owner` varchar(54) DEFAULT NULL,
  `number` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL DEFAULT 'Unknown',
  `photo` varchar(512) NOT NULL DEFAULT '',
  `members` mediumtext DEFAULT NULL,
  `settings` text DEFAULT NULL,
  `lastOpened` bigint(20) DEFAULT 0,
  `lastMessage` bigint(20) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `phone_contacts`
--

CREATE TABLE `phone_contacts` (
  `id` int(11) NOT NULL,
  `owner` varchar(54) DEFAULT NULL,
  `number` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL DEFAULT 'Unknown',
  `photo` varchar(512) DEFAULT '',
  `tag` varchar(255) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `phone_darkgroups`
--

CREATE TABLE `phone_darkgroups` (
  `id` int(11) NOT NULL,
  `invitecode` varchar(50) DEFAULT NULL,
  `owner` varchar(54) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `photo` varchar(512) NOT NULL DEFAULT '',
  `maxmembers` int(11) DEFAULT 0,
  `members` mediumtext DEFAULT NULL,
  `bannedmembers` mediumtext DEFAULT NULL,
  `lastMessage` bigint(20) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `phone_darkmessages`
--

CREATE TABLE `phone_darkmessages` (
  `from` varchar(255) DEFAULT NULL,
  `to` int(11) DEFAULT NULL,
  `message` varchar(512) DEFAULT NULL,
  `attachments` mediumtext DEFAULT NULL,
  `time` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `phone_mail`
--

CREATE TABLE `phone_mail` (
  `id` int(11) NOT NULL,
  `owner` varchar(54) DEFAULT NULL,
  `subject` varchar(50) DEFAULT NULL,
  `starred` tinyint(1) NOT NULL DEFAULT 0,
  `mail` longtext DEFAULT NULL,
  `trash` tinyint(1) NOT NULL DEFAULT 0,
  `muted` tinyint(1) NOT NULL DEFAULT 0,
  `lastOpened` bigint(20) NOT NULL DEFAULT 0,
  `lastMail` bigint(20) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `phone_mailaccounts`
--

CREATE TABLE `phone_mailaccounts` (
  `address` varchar(50) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `password` varchar(60) DEFAULT NULL,
  `photo` varchar(255) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `phone_messages`
--

CREATE TABLE `phone_messages` (
  `from` varchar(255) DEFAULT NULL,
  `to` varchar(255) DEFAULT NULL,
  `message` varchar(512) DEFAULT NULL,
  `attachments` mediumtext DEFAULT NULL,
  `time` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `phone_transactions`
--

CREATE TABLE `phone_transactions` (
  `id` int(11) NOT NULL,
  `from` varchar(255) DEFAULT NULL,
  `to` varchar(255) DEFAULT NULL,
  `amount` int(11) NOT NULL DEFAULT 0,
  `time` bigint(20) DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `phone_tweets`
--

CREATE TABLE `phone_tweets` (
  `id` int(11) NOT NULL,
  `reply` int(11) DEFAULT NULL,
  `authorId` int(11) DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL,
  `authorimg` varchar(255) DEFAULT NULL,
  `authorrank` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `content` varchar(255) DEFAULT NULL,
  `image` varchar(255) NOT NULL DEFAULT '',
  `views` int(11) NOT NULL DEFAULT 0,
  `likes` int(11) NOT NULL DEFAULT 0,
  `time` bigint(20) DEFAULT NULL,
  `likers` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `phone_twitteraccounts`
--

CREATE TABLE `phone_twitteraccounts` (
  `id` int(11) NOT NULL,
  `owner` varchar(54) DEFAULT NULL,
  `nickname` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `password` varchar(60) DEFAULT NULL,
  `picture` varchar(512) NOT NULL DEFAULT '',
  `banner` varchar(512) NOT NULL DEFAULT '#000',
  `rank` varchar(50) NOT NULL DEFAULT 'default',
  `joinedat` datetime DEFAULT current_timestamp(),
  `blockedusers` longtext DEFAULT NULL,
  `followers` longtext DEFAULT NULL,
  `following` longtext DEFAULT NULL,
  `banneduntil` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `rented_vehicles`
--

CREATE TABLE `rented_vehicles` (
  `vehicle` varchar(60) NOT NULL,
  `plate` varchar(12) NOT NULL,
  `player_name` varchar(255) NOT NULL,
  `base_price` int(11) NOT NULL,
  `rent_price` int(11) NOT NULL,
  `owner` varchar(54) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `society_moneywash`
--

CREATE TABLE `society_moneywash` (
  `id` int(11) NOT NULL,
  `identifier` varchar(54) DEFAULT NULL,
  `society` varchar(60) NOT NULL,
  `amount` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `identifier` varchar(54) NOT NULL,
  `accounts` longtext DEFAULT NULL,
  `group` varchar(50) DEFAULT 'user',
  `inventory` longtext DEFAULT NULL,
  `job` varchar(20) DEFAULT 'unemployed',
  `job_grade` int(11) DEFAULT 0,
  `loadout` longtext DEFAULT NULL,
  `position` varchar(255) DEFAULT '{"x":-269.4,"y":-955.3,"z":31.2,"heading":205.8}',
  `firstname` varchar(16) DEFAULT NULL,
  `lastname` varchar(16) DEFAULT NULL,
  `dateofbirth` varchar(10) DEFAULT NULL,
  `sex` varchar(1) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `skin` longtext DEFAULT NULL,
  `status` longtext DEFAULT NULL,
  `is_dead` tinyint(1) NOT NULL DEFAULT 0,
  `deaths` int(255) NOT NULL DEFAULT 0,
  `id` int(11) NOT NULL,
  `disabled` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `last_seen` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `pincode` int(11) DEFAULT NULL,
  `mdt_image` mediumtext DEFAULT NULL,
  `mdt_height` int(11) DEFAULT NULL,
  `mdt_description` mediumtext DEFAULT NULL,
  `last_property` longtext DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `iban` varchar(50) DEFAULT NULL,
  `twitteraccount` int(11) DEFAULT NULL,
  `twitterban` datetime DEFAULT NULL,
  `settings` longtext DEFAULT NULL,
  `notes` longtext DEFAULT NULL,
  `reminders` longtext DEFAULT NULL,
  `playlists` longtext DEFAULT NULL,
  `photos` longtext DEFAULT NULL,
  `blockednumbers` longtext DEFAULT NULL,
  `darkchatuser` mediumtext DEFAULT NULL,
  `mailaccount` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`identifier`, `accounts`, `group`, `inventory`, `job`, `job_grade`, `loadout`, `position`, `firstname`, `lastname`, `dateofbirth`, `sex`, `height`, `skin`, `status`, `is_dead`, `deaths`, `id`, `disabled`, `created_at`, `last_seen`, `pincode`, `mdt_image`, `mdt_height`, `mdt_description`, `last_property`, `phone`, `iban`, `twitteraccount`, `twitterban`, `settings`, `notes`, `reminders`, `playlists`, `photos`, `blockednumbers`, `darkchatuser`, `mailaccount`) VALUES
('char1:25eef2569a0c022520feace01c62c4dfb720b62b', '{\"bank\":50400,\"money\":200,\"crypto\":0}', 'admin', '[{\"name\":\"money\",\"slot\":1,\"count\":200}]', 'unemployed', 0, '[]', '{\"y\":-1458.06591796875,\"z\":31.183837890625,\"heading\":187.08660888671876,\"x\":-175.6879119873047}', 'George', 'Mayers', '01/01/1995', 'm', 125, '{\"hair\":{\"style\":0,\"color\":0,\"highlight\":0},\"props\":[{\"drawable\":-1,\"prop_id\":0,\"texture\":-1},{\"drawable\":-1,\"prop_id\":1,\"texture\":-1},{\"drawable\":-1,\"prop_id\":2,\"texture\":-1},{\"drawable\":-1,\"prop_id\":6,\"texture\":-1},{\"drawable\":-1,\"prop_id\":7,\"texture\":-1}],\"model\":\"mp_m_freemode_01\",\"tattoos\":[],\"headBlend\":{\"skinSecond\":0,\"shapeSecond\":0,\"skinFirst\":0,\"skinMix\":0,\"shapeFirst\":0,\"shapeMix\":0},\"components\":[{\"component_id\":0,\"texture\":0,\"drawable\":0},{\"component_id\":1,\"texture\":0,\"drawable\":0},{\"component_id\":2,\"texture\":0,\"drawable\":0},{\"component_id\":3,\"texture\":0,\"drawable\":0},{\"component_id\":4,\"texture\":0,\"drawable\":0},{\"component_id\":5,\"texture\":0,\"drawable\":0},{\"component_id\":6,\"texture\":0,\"drawable\":0},{\"component_id\":7,\"texture\":0,\"drawable\":0},{\"component_id\":8,\"texture\":0,\"drawable\":0},{\"component_id\":9,\"texture\":0,\"drawable\":0},{\"component_id\":10,\"texture\":0,\"drawable\":0},{\"component_id\":11,\"texture\":0,\"drawable\":0}],\"faceFeatures\":{\"chinBoneSize\":0,\"cheeksWidth\":0,\"jawBoneBackSize\":0,\"cheeksBoneWidth\":0,\"nosePeakLowering\":0,\"eyeBrownHigh\":0,\"eyeBrownForward\":0,\"chinBoneLenght\":0,\"nosePeakHigh\":0,\"noseBoneTwist\":0,\"lipsThickness\":0,\"noseWidth\":0,\"chinBoneLowering\":0,\"noseBoneHigh\":0,\"jawBoneWidth\":0,\"chinHole\":0,\"neckThickness\":0,\"eyesOpening\":0,\"cheeksBoneHigh\":0,\"nosePeakSize\":0},\"eyeColor\":-1,\"headOverlays\":{\"lipstick\":{\"style\":0,\"color\":0,\"opacity\":0},\"bodyBlemishes\":{\"style\":0,\"color\":0,\"opacity\":0},\"blemishes\":{\"style\":0,\"color\":0,\"opacity\":0},\"complexion\":{\"style\":0,\"color\":0,\"opacity\":0},\"blush\":{\"style\":0,\"color\":0,\"opacity\":0},\"eyebrows\":{\"style\":0,\"color\":0,\"opacity\":0},\"moleAndFreckles\":{\"style\":0,\"color\":0,\"opacity\":0},\"chestHair\":{\"style\":0,\"color\":0,\"opacity\":0},\"beard\":{\"style\":0,\"color\":0,\"opacity\":0},\"makeUp\":{\"style\":0,\"color\":0,\"opacity\":0},\"ageing\":{\"style\":0,\"color\":0,\"opacity\":0},\"sunDamage\":{\"style\":0,\"color\":0,\"opacity\":0}}}', '[{\"name\":\"drunk\",\"val\":0,\"percent\":0.0},{\"name\":\"addiction\",\"val\":0,\"percent\":0.0},{\"name\":\"hunger\",\"val\":922500,\"percent\":92.25},{\"name\":\"thirst\",\"val\":941875,\"percent\":94.1875}]', 0, 0, 9, 0, '2023-02-28 17:58:46', '2023-02-28 18:11:58', NULL, NULL, NULL, NULL, NULL, '340-2178', '391401', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('char1:8340435dc4123fabfe5375ca9adc59d4080a1ffc', '{\"money\":0,\"crypto\":0,\"bank\":50200}', 'user', '[]', 'unemployed', 0, '[]', '{\"heading\":56.69291305541992,\"x\":102.19779968261719,\"y\":-612.936279296875,\"z\":44.91650390625}', 'Pierre', 'Gardin', '12/12/1985', 'm', 185, '{\"headBlend\":{\"skinMix\":0,\"skinSecond\":0,\"shapeSecond\":0,\"shapeFirst\":0,\"shapeMix\":0,\"skinFirst\":0},\"headOverlays\":{\"blemishes\":{\"style\":0,\"opacity\":0,\"color\":0},\"eyebrows\":{\"style\":0,\"opacity\":0,\"color\":0},\"beard\":{\"style\":0,\"opacity\":0,\"color\":0},\"blush\":{\"style\":0,\"opacity\":0,\"color\":0},\"complexion\":{\"style\":0,\"opacity\":0,\"color\":0},\"bodyBlemishes\":{\"style\":0,\"opacity\":0,\"color\":0},\"lipstick\":{\"style\":0,\"opacity\":0,\"color\":0},\"makeUp\":{\"style\":0,\"opacity\":0,\"color\":0},\"ageing\":{\"style\":0,\"opacity\":0,\"color\":0},\"moleAndFreckles\":{\"style\":0,\"opacity\":0,\"color\":0},\"chestHair\":{\"style\":0,\"opacity\":0,\"color\":0},\"sunDamage\":{\"style\":0,\"opacity\":0,\"color\":0}},\"components\":[{\"drawable\":0,\"texture\":0,\"component_id\":0},{\"drawable\":0,\"texture\":0,\"component_id\":1},{\"drawable\":0,\"texture\":0,\"component_id\":2},{\"drawable\":0,\"texture\":0,\"component_id\":3},{\"drawable\":0,\"texture\":0,\"component_id\":4},{\"drawable\":0,\"texture\":0,\"component_id\":5},{\"drawable\":0,\"texture\":0,\"component_id\":6},{\"drawable\":0,\"texture\":0,\"component_id\":7},{\"drawable\":0,\"texture\":0,\"component_id\":8},{\"drawable\":0,\"texture\":0,\"component_id\":9},{\"drawable\":0,\"texture\":0,\"component_id\":10},{\"drawable\":0,\"texture\":0,\"component_id\":11}],\"eyeColor\":-1,\"props\":[{\"drawable\":-1,\"texture\":-1,\"prop_id\":0},{\"drawable\":-1,\"texture\":-1,\"prop_id\":1},{\"drawable\":-1,\"texture\":-1,\"prop_id\":2},{\"drawable\":-1,\"texture\":-1,\"prop_id\":6},{\"drawable\":-1,\"texture\":-1,\"prop_id\":7}],\"tattoos\":[],\"faceFeatures\":{\"nosePeakHigh\":0,\"eyeBrownForward\":0,\"chinBoneLowering\":0,\"chinBoneLenght\":0,\"cheeksWidth\":0,\"noseWidth\":0,\"lipsThickness\":0,\"eyesOpening\":0,\"eyeBrownHigh\":0,\"cheeksBoneHigh\":0,\"neckThickness\":0,\"nosePeakSize\":0,\"nosePeakLowering\":0,\"jawBoneBackSize\":0,\"noseBoneHigh\":0,\"chinHole\":0,\"noseBoneTwist\":0,\"jawBoneWidth\":0,\"chinBoneSize\":0,\"cheeksBoneWidth\":0},\"hair\":{\"style\":0,\"highlight\":-1,\"color\":-1},\"model\":\"a_m_m_hillbilly_01\"}', '[{\"val\":0,\"name\":\"drunk\",\"percent\":0.0},{\"val\":0,\"name\":\"addiction\",\"percent\":0.0},{\"val\":945000,\"name\":\"hunger\",\"percent\":94.5},{\"val\":958750,\"name\":\"thirst\",\"percent\":95.875}]', 0, 0, 8, 0, '2023-02-28 14:13:43', '2023-02-28 14:23:12', NULL, NULL, NULL, NULL, NULL, '481-1537', '408153', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('char1:88fa041731c1df91525e9989b886d9b5ad6a823e', '{\"crypto\":0,\"bank\":45400,\"money\":29302}', 'admin', '[{\"count\":29302,\"slot\":1,\"name\":\"money\"}]', 'ambulance', 3, '[]', '{\"x\":351.6000061035156,\"y\":-584.8219604492188,\"z\":43.180908203125,\"heading\":79.37007904052735}', 'Alexy', 'Keyzer', '01/03/1995', 'm', 178, '{\"eyeColor\":-1,\"components\":[{\"component_id\":0,\"texture\":0,\"drawable\":0},{\"component_id\":1,\"texture\":0,\"drawable\":0},{\"component_id\":2,\"texture\":0,\"drawable\":0},{\"component_id\":3,\"texture\":0,\"drawable\":0},{\"component_id\":4,\"texture\":0,\"drawable\":0},{\"component_id\":5,\"texture\":0,\"drawable\":0},{\"component_id\":6,\"texture\":0,\"drawable\":0},{\"component_id\":7,\"texture\":0,\"drawable\":0},{\"component_id\":8,\"texture\":0,\"drawable\":0},{\"component_id\":9,\"texture\":0,\"drawable\":0},{\"component_id\":10,\"texture\":0,\"drawable\":0},{\"component_id\":11,\"texture\":0,\"drawable\":0}],\"tattoos\":[],\"headOverlays\":{\"blemishes\":{\"style\":0,\"color\":0,\"opacity\":0},\"beard\":{\"style\":0,\"color\":0,\"opacity\":0},\"chestHair\":{\"style\":0,\"color\":0,\"opacity\":0},\"moleAndFreckles\":{\"style\":0,\"color\":0,\"opacity\":0},\"ageing\":{\"style\":0,\"color\":0,\"opacity\":0},\"makeUp\":{\"style\":0,\"color\":0,\"opacity\":0},\"sunDamage\":{\"style\":0,\"color\":0,\"opacity\":0},\"eyebrows\":{\"style\":0,\"color\":0,\"opacity\":0},\"bodyBlemishes\":{\"style\":0,\"color\":0,\"opacity\":0},\"complexion\":{\"style\":0,\"color\":0,\"opacity\":0},\"blush\":{\"style\":0,\"color\":0,\"opacity\":0},\"lipstick\":{\"style\":0,\"color\":0,\"opacity\":0}},\"faceFeatures\":{\"chinBoneLowering\":0,\"neckThickness\":0,\"nosePeakHigh\":0,\"chinHole\":0,\"lipsThickness\":0,\"noseWidth\":0,\"eyeBrownForward\":0,\"nosePeakSize\":0,\"cheeksBoneWidth\":0,\"jawBoneWidth\":0,\"cheeksBoneHigh\":0,\"noseBoneHigh\":0,\"jawBoneBackSize\":0,\"chinBoneLenght\":0,\"eyeBrownHigh\":0,\"cheeksWidth\":0,\"chinBoneSize\":0,\"nosePeakLowering\":0,\"eyesOpening\":0,\"noseBoneTwist\":0},\"headBlend\":{\"shapeFirst\":0,\"shapeSecond\":0,\"shapeMix\":0,\"skinFirst\":0,\"skinSecond\":0,\"skinMix\":0},\"hair\":{\"style\":0,\"highlight\":0,\"color\":0},\"model\":\"mp_m_freemode_01\",\"props\":[{\"drawable\":-1,\"prop_id\":0,\"texture\":-1},{\"drawable\":-1,\"prop_id\":1,\"texture\":-1},{\"drawable\":-1,\"prop_id\":2,\"texture\":-1},{\"drawable\":-1,\"prop_id\":6,\"texture\":-1},{\"drawable\":-1,\"prop_id\":7,\"texture\":-1}]}', '[{\"val\":0,\"name\":\"drunk\",\"percent\":0.0},{\"val\":0,\"name\":\"addiction\",\"percent\":0.0},{\"val\":126200,\"name\":\"hunger\",\"percent\":12.62},{\"val\":219650,\"name\":\"thirst\",\"percent\":21.965}]', 0, 0, 7, 0, '2023-02-25 15:55:23', '2023-02-28 19:01:08', NULL, 'https://media.discordapp.net/attachments/1079841204516180039/1080193004431757393/screenshot.jpg', NULL, NULL, NULL, '747-9024', '784702', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `user_licenses`
--

CREATE TABLE `user_licenses` (
  `id` int(11) NOT NULL,
  `type` varchar(60) NOT NULL,
  `owner` varchar(54) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `vehicles`
--

CREATE TABLE `vehicles` (
  `id` int(11) NOT NULL,
  `name` varchar(60) NOT NULL,
  `model` varchar(60) NOT NULL,
  `price` varchar(7) DEFAULT NULL,
  `category` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `vehicles`
--

INSERT INTO `vehicles` (`id`, `name`, `model`, `price`, `category`) VALUES
(2, 'Adder', 'adder', '2000000', 'super'),
(3, 'Akuma', 'AKUMA', '25000', 'motorcycles'),
(4, 'Alpha', 'alpha', '60000', 'sports'),
(6, 'Asea', 'asea', '5500', 'sedans'),
(7, 'Autarch', 'autarch', '2000000', 'super'),
(8, 'Avarus', 'avarus', '18000', 'motorcycles'),
(9, 'Bagger', 'bagger', '18000', 'motorcycles'),
(10, 'Baller', 'baller2', '50000', 'suvs'),
(11, 'Baller Sport', 'baller3', '60000', 'suvs'),
(12, 'Banshee', 'banshee', '70000', 'sports'),
(13, 'Banshee 900R', 'banshee2', '255000', 'super'),
(14, 'Bati 801', 'bati', '30000', 'motorcycles'),
(15, 'Bati 801RR', 'bati2', '35000', 'motorcycles'),
(16, 'Bestia GTS', 'bestiagts', '55000', 'sports'),
(17, 'BF400', 'bf400', '40000', 'motorcycles'),
(18, 'Bf Injection', 'bfinjection', '16000', 'offroad'),
(19, 'Bifta', 'bifta', '12000', 'offroad'),
(20, 'Bison', 'bison', '45000', 'vans'),
(21, 'Blade', 'blade', '15000', 'muscle'),
(22, 'Blazer', 'blazer', '6500', 'offroad'),
(23, 'Blazer Sport', 'blazer4', '8500', 'offroad'),
(25, 'Blista', 'blista', '8000', 'compacts'),
(26, 'BMX (velo)', 'bmx', '160', 'motorcycles'),
(27, 'Bobcat XL', 'bobcatxl', '32000', 'vans'),
(28, 'Brawler', 'brawler', '45000', 'offroad'),
(29, 'Brioso R/A', 'brioso', '18000', 'compacts'),
(30, 'Btype', 'btype', '150000', 'sportsclassics'),
(31, 'Btype Hotroad', 'btype2', '80000', 'sportsclassics'),
(32, 'Btype Luxe', 'btype3', '150000', 'sportsclassics'),
(33, 'Buccaneer', 'buccaneer', '18000', 'muscle'),
(34, 'Buccaneer Rider', 'buccaneer2', '24000', 'muscle'),
(35, 'Buffalo', 'buffalo', '12000', 'sports'),
(36, 'Buffalo S', 'buffalo2', '20000', 'sports'),
(37, 'Bullet', 'bullet', '90000', 'super'),
(38, 'Burrito', 'burrito3', '19000', 'vans'),
(39, 'Camper', 'camper', '42000', 'vans'),
(40, 'Carbonizzare', 'carbonizzare', '75000', 'sports'),
(41, 'Carbon RS', 'carbonrs', '70000', 'motorcycles'),
(42, 'Casco', 'casco', '38000', 'sportsclassics'),
(43, 'Cavalcade', 'cavalcade2', '55000', 'suvs'),
(44, 'Cheetah', 'cheetah', '375000', 'super'),
(45, 'Chimera', 'chimera', '38000', 'motorcycles'),
(46, 'Chino', 'chino', '15000', 'muscle'),
(47, 'Chino Luxe', 'chino2', '19000', 'muscle'),
(48, 'Cliffhanger', 'cliffhanger', '15000', 'motorcycles'),
(49, 'Cognoscenti Cabrio', 'cogcabrio', '55000', 'coupes'),
(50, 'Cognoscenti', 'cognoscenti', '55000', 'sedans'),
(51, 'Comet', 'comet2', '100000', 'sports'),
(52, 'Comet 5', 'comet5', '300000', 'sports'),
(53, 'Contender', 'contender', '70000', 'suvs'),
(54, 'Coquette', 'coquette', '65000', 'sports'),
(55, 'Coquette Classic', 'coquette2', '80000', 'sportsclassics'),
(56, 'Coquette BlackFin', 'coquette3', '100000', 'muscle'),
(57, 'Cruiser (velo)', 'cruiser', '510', 'motorcycles'),
(58, 'Cyclone', 'cyclone', '2000000', 'super'),
(59, 'Daemon', 'daemon', '18000', 'motorcycles'),
(60, 'Daemon High', 'daemon2', '18000', 'motorcycles'),
(61, 'Defiler', 'defiler', '25000', 'motorcycles'),
(62, 'Deluxo', 'deluxo', '9999999', 'sportsclassics'),
(63, 'Dominator', 'dominator', '35000', 'muscle'),
(64, 'Double T', 'double', '35000', 'motorcycles'),
(65, 'Dubsta', 'dubsta', '45000', 'suvs'),
(66, 'Dubsta Luxuary', 'dubsta2', '60000', 'suvs'),
(67, 'Bubsta 6x6', 'dubsta3', '1000000', 'offroad'),
(68, 'Dukes', 'dukes', '28000', 'muscle'),
(69, 'Dune Buggy', 'dune', '8000', 'offroad'),
(70, 'Elegy', 'elegy2', '38500', 'sports'),
(71, 'Emperor', 'emperor', '8500', 'sedans'),
(72, 'Enduro', 'enduro', '35000', 'motorcycles'),
(73, 'Entity XF', 'entityxf', '2000000', 'super'),
(74, 'Esskey', 'esskey', '35000', 'motorcycles'),
(75, 'Exemplar', 'exemplar', '15000', 'coupes'),
(76, 'F620', 'f620', '40000', 'coupes'),
(77, 'Faction', 'faction', '20000', 'muscle'),
(78, 'Faction Rider', 'faction2', '30000', 'muscle'),
(79, 'Faction XL', 'faction3', '40000', 'muscle'),
(80, 'Faggio', 'faggio', '1900', 'motorcycles'),
(81, 'Vespa', 'faggio2', '2800', 'motorcycles'),
(82, 'Felon', 'felon', '42000', 'coupes'),
(83, 'Felon GT', 'felon2', '55000', 'coupes'),
(84, 'Feltzer', 'feltzer2', '200000', 'sports'),
(85, 'Stirling GT', 'feltzer3', '65000', 'sportsclassics'),
(86, 'Fixter (velo)', 'fixter', '225', 'motorcycles'),
(87, 'FMJ', 'fmj', '2000000', 'super'),
(88, 'Fhantom', 'fq2', '17000', 'suvs'),
(89, 'Fugitive', 'fugitive', '12000', 'sedans'),
(90, 'Furore GT', 'furoregt', '45000', 'sports'),
(91, 'Fusilade', 'fusilade', '40000', 'sports'),
(92, 'Gargoyle', 'gargoyle', '16500', 'motorcycles'),
(93, 'Gauntlet', 'gauntlet', '30000', 'muscle'),
(94, 'Gang Burrito', 'gburrito', '45000', 'vans'),
(95, 'Burrito', 'gburrito2', '29000', 'vans'),
(96, 'Glendale', 'glendale', '6500', 'sedans'),
(97, 'Grabger', 'granger', '50000', 'suvs'),
(98, 'Gresley', 'gresley', '47500', 'suvs'),
(99, 'GT 500', 'gt500', '1200000', 'sportsclassics'),
(100, 'Guardian', 'guardian', '300000', 'offroad'),
(101, 'Hakuchou', 'hakuchou', '55000', 'motorcycles'),
(102, 'Hakuchou Sport', 'hakuchou2', '60000', 'motorcycles'),
(103, 'Hermes', 'hermes', '535000', 'muscle'),
(104, 'Hexer', 'hexer', '12000', 'motorcycles'),
(105, 'Hotknife', 'hotknife', '125000', 'muscle'),
(106, 'Huntley S', 'huntley', '40000', 'suvs'),
(107, 'Hustler', 'hustler', '625000', 'muscle'),
(108, 'Infernus', 'infernus', '1800000', 'super'),
(109, 'Innovation', 'innovation', '40000', 'motorcycles'),
(110, 'Intruder', 'intruder', '7500', 'sedans'),
(111, 'Issi', 'issi2', '10000', 'compacts'),
(112, 'Jackal', 'jackal', '38000', 'coupes'),
(113, 'Jester', 'jester', '200000', 'sports'),
(114, 'Jester(Racecar)', 'jester2', '135000', 'sports'),
(115, 'Journey', 'journey', '6500', 'vans'),
(116, 'Kamacho', 'kamacho', '3000000', 'offroad'),
(117, 'Khamelion', 'khamelion', '50000', 'sports'),
(118, 'Kuruma', 'kuruma', '120000', 'sports'),
(119, 'Landstalker', 'landstalker', '35000', 'suvs'),
(120, 'RE-7B', 'le7b', '2500000', 'super'),
(121, 'Lynx', 'lynx', '70000', 'sports'),
(122, 'Mamba', 'mamba', '70000', 'sports'),
(123, 'Manana', 'manana', '12800', 'sportsclassics'),
(124, 'Manchez', 'manchez', '25000', 'motorcycles'),
(125, 'Massacro', 'massacro', '90000', 'sports'),
(126, 'Massacro(Racecar)', 'massacro2', '130000', 'sports'),
(127, 'Mesa', 'mesa', '16000', 'suvs'),
(128, 'Mesa Trail', 'mesa3', '40000', 'suvs'),
(129, 'Minivan', 'minivan', '13000', 'vans'),
(130, 'Monroe', 'monroe', '180000', 'sportsclassics'),
(131, 'The Liberator', 'monster', '2000000', 'offroad'),
(132, 'Moonbeam', 'moonbeam', '18000', 'vans'),
(133, 'Moonbeam Rider', 'moonbeam2', '35000', 'vans'),
(134, 'Nemesis', 'nemesis', '20000', 'motorcycles'),
(135, 'Neon', 'neon', '2500000', 'sports'),
(136, 'Nightblade', 'nightblade', '70000', 'motorcycles'),
(137, 'Nightshade', 'nightshade', '65000', 'muscle'),
(138, '9F', 'ninef', '65000', 'sports'),
(139, '9F Cabrio', 'ninef2', '80000', 'sports'),
(140, 'Omnis', 'omnis', '35000', 'sports'),
(142, 'Oracle XS', 'oracle2', '35000', 'coupes'),
(143, 'Osiris', 'osiris', '2000000', 'super'),
(144, 'Panto', 'panto', '10000', 'compacts'),
(145, 'Paradise', 'paradise', '19000', 'vans'),
(146, 'Pariah', 'pariah', '2500000', 'sports'),
(147, 'Patriot', 'patriot', '55000', 'suvs'),
(148, 'PCJ-600', 'pcj', '30000', 'motorcycles'),
(149, 'Penumbra', 'penumbra', '28000', 'sports'),
(150, 'Pfister', 'pfister811', '85000', 'super'),
(151, 'Phoenix', 'phoenix', '12500', 'muscle'),
(152, 'Picador', 'picador', '18000', 'muscle'),
(153, 'Pigalle', 'pigalle', '20000', 'sportsclassics'),
(154, 'Prairie', 'prairie', '12000', 'compacts'),
(155, 'Premier', 'premier', '8000', 'sedans'),
(156, 'Primo Custom', 'primo2', '14000', 'sedans'),
(157, 'X80 Proto', 'prototipo', '3500000', 'super'),
(158, 'Radius', 'radi', '29000', 'suvs'),
(159, 'raiden', 'raiden', '1375000', 'sports'),
(160, 'Rapid GT', 'rapidgt', '35000', 'sports'),
(161, 'Rapid GT Convertible', 'rapidgt2', '45000', 'sports'),
(162, 'Rapid GT3', 'rapidgt3', '80000', 'sportsclassics'),
(163, 'Reaper', 'reaper', '2000000', 'super'),
(164, 'Rebel', 'rebel2', '35000', 'offroad'),
(165, 'Regina', 'regina', '5000', 'sedans'),
(166, 'Retinue', 'retinue', '615000', 'sportsclassics'),
(167, 'Revolter', 'revolter', '174000', 'sports'),
(168, 'riata', 'riata', '110000', 'offroad'),
(169, 'Rocoto', 'rocoto', '45000', 'suvs'),
(170, 'Ruffian', 'ruffian', '18000', 'motorcycles'),
(172, 'Rumpo', 'rumpo', '15000', 'vans'),
(173, 'Rumpo Trail', 'rumpo3', '19500', 'vans'),
(174, 'Sabre Turbo', 'sabregt', '20000', 'muscle'),
(175, 'Sabre GT', 'sabregt2', '25000', 'muscle'),
(176, 'Sanchez', 'sanchez', '25000', 'motorcycles'),
(177, 'Sanchez Sport', 'sanchez2', '19000', 'motorcycles'),
(178, 'Sanctus', 'sanctus', '70000', 'motorcycles'),
(179, 'Sandking', 'sandking', '55000', 'offroad'),
(180, 'Savestra', 'savestra', '50000', 'sportsclassics'),
(181, 'SC 1', 'sc1', '2200000', 'super'),
(182, 'Schafter', 'schafter2', '25000', 'sedans'),
(183, 'Schafter V12', 'schafter3', '50000', 'sports'),
(184, 'Scorcher (velo)', 'scorcher', '280', 'motorcycles'),
(185, 'Seminole', 'seminole', '10000', 'suvs'),
(186, 'Sentinel', 'sentinel', '32000', 'coupes'),
(187, 'Sentinel XS', 'sentinel2', '40000', 'coupes'),
(188, 'Sentinel3', 'sentinel3', '45000', 'sports'),
(189, 'Seven 70', 'seven70', '180000', 'sports'),
(190, 'ETR1', 'sheava', '320000', 'super'),
(191, 'Shotaro Concept', 'shotaro', '320000', 'motorcycles'),
(192, 'Slam Van', 'slamvan3', '11500', 'muscle'),
(193, 'Sovereign', 'sovereign', '22000', 'motorcycles'),
(194, 'Stinger', 'stinger', '60000', 'sportsclassics'),
(195, 'Stinger GT', 'stingergt', '75000', 'sportsclassics'),
(196, 'Streiter', 'streiter', '50000', 'sports'),
(197, 'Stretch', 'stretch', '300000', 'sedans'),
(199, 'Sultan', 'sultan', '15000', 'sports'),
(200, 'Sultan RS', 'sultanrs', '160000', 'super'),
(201, 'Super Diamond', 'superd', '130000', 'sedans'),
(202, 'Surano', 'surano', '50000', 'sports'),
(203, 'Surfer', 'surfer', '12000', 'vans'),
(204, 'T20', 't20', '2000000', 'super'),
(205, 'Tailgater', 'tailgater', '30000', 'sedans'),
(206, 'Tampa', 'tampa', '16000', 'muscle'),
(207, 'Drift Tampa', 'tampa2', '80000', 'sports'),
(208, 'Thrust', 'thrust', '80000', 'motorcycles'),
(209, 'Tri bike (velo)', 'tribike3', '100', 'motorcycles'),
(210, 'Trophy Truck', 'trophytruck', '600000', 'offroad'),
(211, 'Trophy Truck Limited', 'trophytruck2', '600000', 'offroad'),
(212, 'Tropos', 'tropos', '50000', 'sports'),
(213, 'Turismo R', 'turismor', '1800000', 'super'),
(214, 'Tyrus', 'tyrus', '2000000', 'super'),
(215, 'Vacca', 'vacca', '900000', 'super'),
(216, 'Vader', 'vader', '30000', 'motorcycles'),
(217, 'Verlierer', 'verlierer2', '200000', 'sports'),
(218, 'Vigero', 'vigero', '12500', 'muscle'),
(219, 'Virgo', 'virgo', '14000', 'muscle'),
(220, 'Viseris', 'viseris', '80000', 'sportsclassics'),
(222, 'Voltic', 'voltic', '90000', 'super'),
(223, 'Voltic 2', 'voltic2', '3830400', 'super'),
(224, 'Voodoo', 'voodoo', '7200', 'muscle'),
(225, 'Vortex', 'vortex', '9800', 'motorcycles'),
(226, 'Warrener', 'warrener', '4000', 'sedans'),
(227, 'Washington', 'washington', '9000', 'sedans'),
(228, 'Windsor', 'windsor', '95000', 'coupes'),
(229, 'Windsor Drop', 'windsor2', '125000', 'coupes'),
(230, 'Woflsbane', 'wolfsbane', '19000', 'motorcycles'),
(231, 'XLS', 'xls', '32000', 'suvs'),
(232, 'Yosemite', 'yosemite', '150000', 'muscle'),
(233, 'Youga', 'youga', '10800', 'vans'),
(234, 'Youga Luxuary', 'youga2', '14500', 'vans'),
(235, 'Z190', 'z190', '120000', 'sportsclassics'),
(236, 'Zentorno', 'zentorno', '3000000', 'super'),
(237, 'Zion', 'zion', '26000', 'coupes'),
(238, 'Zion Cabrio', 'zion2', '2000', 'coupes'),
(239, 'Zombie', 'zombiea', '40000', 'motorcycles'),
(240, 'Zombie Luxuary', 'zombieb', '50000', 'motorcycles'),
(241, 'Z-Type', 'ztype', '1220000', 'sportsclassics');

-- --------------------------------------------------------

--
-- Structure de la table `vehicle_categories`
--

CREATE TABLE `vehicle_categories` (
  `name` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `vehicle_categories`
--

INSERT INTO `vehicle_categories` (`name`, `label`) VALUES
('compacts', 'Compacts'),
('coupes', 'Coupés'),
('motorcycles', 'Motos'),
('muscle', 'Muscle'),
('offroad', 'Off Road'),
('sedans', 'Sedans'),
('sports', 'Sports'),
('sportsclassics', 'Sports Classics'),
('super', 'Super'),
('suvs', 'SUVs'),
('vans', 'Vans');

-- --------------------------------------------------------

--
-- Structure de la table `vehicle_sold`
--

CREATE TABLE `vehicle_sold` (
  `client` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `plate` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `soldby` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `addon_account`
--
ALTER TABLE `addon_account`
  ADD PRIMARY KEY (`name`);

--
-- Index pour la table `addon_account_data`
--
ALTER TABLE `addon_account_data`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `index_addon_account_data_account_name_owner` (`account_name`,`owner`),
  ADD KEY `index_addon_account_data_account_name` (`account_name`);

--
-- Index pour la table `addon_inventory`
--
ALTER TABLE `addon_inventory`
  ADD PRIMARY KEY (`name`);

--
-- Index pour la table `addon_inventory_items`
--
ALTER TABLE `addon_inventory_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `index_addon_inventory_items_inventory_name_name` (`inventory_name`,`name`),
  ADD KEY `index_addon_inventory_items_inventory_name_name_owner` (`inventory_name`,`name`,`owner`),
  ADD KEY `index_addon_inventory_inventory_name` (`inventory_name`);

--
-- Index pour la table `banking`
--
ALTER TABLE `banking`
  ADD PRIMARY KEY (`ID`);

--
-- Index pour la table `billing`
--
ALTER TABLE `billing`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `cardealer_vehicles`
--
ALTER TABLE `cardealer_vehicles`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `crypto`
--
ALTER TABLE `crypto`
  ADD PRIMARY KEY (`ID`);

--
-- Index pour la table `datastore`
--
ALTER TABLE `datastore`
  ADD PRIMARY KEY (`name`);

--
-- Index pour la table `datastore_data`
--
ALTER TABLE `datastore_data`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `index_datastore_data_name_owner` (`name`,`owner`),
  ADD KEY `index_datastore_data_name` (`name`);

--
-- Index pour la table `delta_groups`
--
ALTER TABLE `delta_groups`
  ADD PRIMARY KEY (`identifier`),
  ADD UNIQUE KEY `powerIndex` (`powerIndex`);

--
-- Index pour la table `delta_players`
--
ALTER TABLE `delta_players`
  ADD PRIMARY KEY (`identifier`);

--
-- Index pour la table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`name`);

--
-- Index pour la table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`name`);

--
-- Index pour la table `job_grades`
--
ALTER TABLE `job_grades`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `licenses`
--
ALTER TABLE `licenses`
  ADD PRIMARY KEY (`type`);

--
-- Index pour la table `mdt_codes`
--
ALTER TABLE `mdt_codes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `code` (`code`);

--
-- Index pour la table `mdt_evidences`
--
ALTER TABLE `mdt_evidences`
  ADD PRIMARY KEY (`id`),
  ADD KEY `name` (`name`);

--
-- Index pour la table `mdt_fines`
--
ALTER TABLE `mdt_fines`
  ADD PRIMARY KEY (`id`),
  ADD KEY `code` (`code`);

--
-- Index pour la table `mdt_incidents`
--
ALTER TABLE `mdt_incidents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `name` (`name`);

--
-- Index pour la table `mdt_jail`
--
ALTER TABLE `mdt_jail`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `mdt_warrants`
--
ALTER TABLE `mdt_warrants`
  ADD PRIMARY KEY (`id`),
  ADD KEY `wtype` (`wtype`);

--
-- Index pour la table `multicharacter_slots`
--
ALTER TABLE `multicharacter_slots`
  ADD PRIMARY KEY (`identifier`) USING BTREE,
  ADD KEY `slots` (`slots`) USING BTREE;

--
-- Index pour la table `outfits`
--
ALTER TABLE `outfits`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_UNIQUE` (`id`);

--
-- Index pour la table `owned_vehicles`
--
ALTER TABLE `owned_vehicles`
  ADD PRIMARY KEY (`plate`);

--
-- Index pour la table `ox_inventory`
--
ALTER TABLE `ox_inventory`
  ADD UNIQUE KEY `owner` (`owner`,`name`);

--
-- Index pour la table `phone_ads`
--
ALTER TABLE `phone_ads`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`);

--
-- Index pour la table `phone_chats`
--
ALTER TABLE `phone_chats`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`);

--
-- Index pour la table `phone_contacts`
--
ALTER TABLE `phone_contacts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`);

--
-- Index pour la table `phone_darkgroups`
--
ALTER TABLE `phone_darkgroups`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`);

--
-- Index pour la table `phone_mail`
--
ALTER TABLE `phone_mail`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`);

--
-- Index pour la table `phone_mailaccounts`
--
ALTER TABLE `phone_mailaccounts`
  ADD UNIQUE KEY `address` (`address`);

--
-- Index pour la table `phone_transactions`
--
ALTER TABLE `phone_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`);

--
-- Index pour la table `phone_tweets`
--
ALTER TABLE `phone_tweets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`);

--
-- Index pour la table `phone_twitteraccounts`
--
ALTER TABLE `phone_twitteraccounts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`);

--
-- Index pour la table `rented_vehicles`
--
ALTER TABLE `rented_vehicles`
  ADD PRIMARY KEY (`plate`);

--
-- Index pour la table `society_moneywash`
--
ALTER TABLE `society_moneywash`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`identifier`),
  ADD UNIQUE KEY `id` (`id`);

--
-- Index pour la table `user_licenses`
--
ALTER TABLE `user_licenses`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `vehicle_categories`
--
ALTER TABLE `vehicle_categories`
  ADD PRIMARY KEY (`name`);

--
-- Index pour la table `vehicle_sold`
--
ALTER TABLE `vehicle_sold`
  ADD PRIMARY KEY (`plate`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `addon_account_data`
--
ALTER TABLE `addon_account_data`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT pour la table `addon_inventory_items`
--
ALTER TABLE `addon_inventory_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `banking`
--
ALTER TABLE `banking`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pour la table `billing`
--
ALTER TABLE `billing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `cardealer_vehicles`
--
ALTER TABLE `cardealer_vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `crypto`
--
ALTER TABLE `crypto`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `datastore_data`
--
ALTER TABLE `datastore_data`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT pour la table `job_grades`
--
ALTER TABLE `job_grades`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

--
-- AUTO_INCREMENT pour la table `mdt_codes`
--
ALTER TABLE `mdt_codes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `mdt_evidences`
--
ALTER TABLE `mdt_evidences`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `mdt_fines`
--
ALTER TABLE `mdt_fines`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `mdt_incidents`
--
ALTER TABLE `mdt_incidents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `mdt_jail`
--
ALTER TABLE `mdt_jail`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `mdt_warrants`
--
ALTER TABLE `mdt_warrants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `outfits`
--
ALTER TABLE `outfits`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `phone_ads`
--
ALTER TABLE `phone_ads`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `phone_chats`
--
ALTER TABLE `phone_chats`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `phone_contacts`
--
ALTER TABLE `phone_contacts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `phone_darkgroups`
--
ALTER TABLE `phone_darkgroups`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `phone_mail`
--
ALTER TABLE `phone_mail`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `phone_transactions`
--
ALTER TABLE `phone_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `phone_tweets`
--
ALTER TABLE `phone_tweets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `phone_twitteraccounts`
--
ALTER TABLE `phone_twitteraccounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `society_moneywash`
--
ALTER TABLE `society_moneywash`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT pour la table `user_licenses`
--
ALTER TABLE `user_licenses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=242;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
