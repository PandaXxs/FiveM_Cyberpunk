CREATE TABLE `delta_players`
(
    `identifier` VARCHAR(80) NOT NULL,
    `groups`     TEXT        NOT NULL,
    `data`       TEXT        NOT NULL,
    PRIMARY KEY (`identifier`)
) ENGINE = InnoDB;

CREATE TABLE `delta_groups`
(
    `identifier`  VARCHAR(80) NOT NULL,
    `label`       VARCHAR(50) NOT NULL,
    `powerIndex`  INT         NOT NULL,
    `permissions` TEXT        NOT NULL,
    `color`       VARCHAR(50) NOT NULL,
    `data`        TEXT        NOT NULL,
    PRIMARY KEY (`identifier`),
    UNIQUE (`powerIndex`)
) ENGINE = InnoDB;