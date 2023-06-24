CREATE TABLE `character_jobs` (
    `userid` mediumint(8) NOT NULL,
    `charid` int(10) NOT NULL,
    `job` longtext DEFAULT '{"Unemployed":true}'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;