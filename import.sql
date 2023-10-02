DROP TABLE IF EXISTS `character_jobs`;
CREATE TABLE IF NOT EXISTS `character_jobs` (
    `charId` int(10) NOT NULL,
    `job` longtext DEFAULT 'unemployed',
    `job_grade` int(10) DEFAULT 0,
    `on_duty` text DEFAULT 'false',
    `salary` int(10) DEFAULT 0,
    `time_to_salary` int(10) DEFAULT 0,
    `gang` longtext DEFAULT NULL,
    `gang_grade` int(10) DEFAULT 0,
    PRIMARY KEY (`charId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `job_experience`;
CREATE TABLE IF NOT EXISTS `job_experience` (
    `charId` int(10) NOT NULL,
    `job` longtext NOT NULL,
    `experience` int(10) DEFAULT 0,
    PRIMARY KEY (`charId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;