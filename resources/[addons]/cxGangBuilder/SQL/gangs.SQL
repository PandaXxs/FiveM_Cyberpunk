CREATE TABLE `gangs` (
	`gangId` INT(11) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`label` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`positions` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`blips` LONGTEXT NULL DEFAULT '{}' COLLATE 'utf8mb4_general_ci',
	`storage` LONGTEXT NULL DEFAULT '{}' COLLATE 'utf8mb4_general_ci',
	`weapons` LONGTEXT NULL DEFAULT '{}' COLLATE 'utf8mb4_general_ci',
	`perms` LONGTEXT NULL DEFAULT '{}' COLLATE 'utf8mb4_general_ci',
	`money` LONGTEXT NULL DEFAULT '{"black_money":0,"money":0}' COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`gangId`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=1
;

CREATE TABLE `gangs_vehicles` (
	`gang_name` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`vehicle` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`plate` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`stored` TINYINT(1) NULL DEFAULT '0'
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;
