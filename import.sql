CREATE TABLE `character_jobs` (
    `id` int(10) NOT NULL AUTO_INCREMENT,
    `charid` int(10) NOT NULL,
    `job` longtext DEFAULT 'unemployed',
    `job_grade` int(10) DEFAULT 0,
    `gang` longtext DEFAULT NULL,
    `gang_grade` int(10) DEFAULT 0,
    `salary` int(10) DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;