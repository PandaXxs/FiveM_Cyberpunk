CREATE TABLE `emotes_favorites` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
	`favorites` TEXT NULL DEFAULT '{}' COLLATE 'utf8_general_ci',
	PRIMARY KEY (`identifier`) USING BTREE,
	INDEX `id` (`id`) USING BTREE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE TABLE `emotes_keybinds` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
	`keybinds` TEXT NULL DEFAULT '{}' COLLATE 'utf8_general_ci',
	PRIMARY KEY (`identifier`) USING BTREE,
	INDEX `id` (`id`) USING BTREE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;