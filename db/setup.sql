--
-- SETUP
--
DROP DATABASE IF EXISTS `lent_weather`;
CREATE DATABASE `lent_weather`;
USE `lent_weather`;

--
-- DDL
--

DROP TABLE IF EXISTS `tosse_datapoint`;
DROP TABLE IF EXISTS `sunne_datapoint`;

CREATE TABLE `tosse_datapoint`(
    `date_time` DATETIME NOT NULL,
    `temp` DECIMAL(3,1) NOT NULL,
    `wind_speed_ms`DECIMAL(3,1) NOT NULL,
    `wind_gust_ms` DECIMAL(3,1) NOT NULL,
    `wind_direction_deg` INT NOT NULL,
    `pressure_hpa` DECIMAL(5,1) NOT NULL,

    PRIMARY KEY (`date_time`)
);

CREATE TABLE `sunne_datapoint`(
    `date_time` DATETIME NOT NULL,
    `humidity` INT,
    `cloudbase_low` INT,

    PRIMARY KEY (`date_time`)
);

--
-- Insert data
--
LOAD DATA LOCAL INFILE '/docker-entrypoint-initdb.d/csv/2022.csv'
INTO TABLE `tosse_datapoint`
CHARSET utf8
FIELDS
    TERMINATED BY ','
    ENCLOSED BY '"'
LINES
    TERMINATED BY '\n'
IGNORE 1 LINES
(date_time, temp, wind_speed_ms, wind_gust_ms, wind_direction_deg, pressure_hpa)
;

LOAD DATA LOCAL INFILE '/docker-entrypoint-initdb.d/csv/2023.csv'
INTO TABLE `tosse_datapoint`
CHARSET utf8
FIELDS
    TERMINATED BY ','
    ENCLOSED BY '"'
LINES
    TERMINATED BY '\n'
IGNORE 1 LINES
(date_time, temp, wind_speed_ms, wind_gust_ms, wind_direction_deg, pressure_hpa)
;

LOAD DATA LOCAL INFILE '/docker-entrypoint-initdb.d/csv/sunne_a.csv'
INTO TABLE `sunne_datapoint`
CHARSET utf8
FIELDS
    TERMINATED BY ','
    ENCLOSED BY '"'
LINES
    TERMINATED BY '\n'
IGNORE 1 LINES
(date_time, humidity, cloudbase_low)
;

SHOW WARNINGS;

--
-- Create a view to filter unwanted data
--
CREATE VIEW `tosse_filtered` AS
SELECT * FROM `tosse_datapoint`
WHERE `pressure_hpa` <= 1045;

DELIMITER ;;

--
-- Procedure for getting data
--
CREATE PROCEDURE get_data()
BEGIN
    SELECT * FROM `tosse_filtered`;
END;;

--
-- Procedure for getting data with daily averages
--
CREATE PROCEDURE get_daily_average()
BEGIN
    SELECT 
        DATE(`date_time`) AS date,
        ROUND(AVG(`temp`), 1) AS `avg_temp`,
        ROUND(AVG(`wind_speed_ms`), 1) AS `avg_wind_speed`,
        ROUND(AVG(`wind_gust_ms`), 1) AS `avg_wind_gust`,
        ROUND(AVG(`wind_direction_deg`)) AS `avg_wind_direction`,
        ROUND(AVG(`pressure_hpa`), 1) AS `avg_pressure`
    FROM 
        `tosse_filtered`
    GROUP BY 
        DATE(`date_time`);
END;;

--
-- Procedure for getting data with weekly averages
--
CREATE PROCEDURE get_weekly_average()
BEGIN
    SELECT 
        YEARWEEK(`date_time`) AS `year_week`,
        ROUND(AVG(`temp`), 1) AS `avg_temp`,
        ROUND(AVG(`wind_speed_ms`), 1) AS `avg_wind_speed`,
        ROUND(AVG(`wind_gust_ms`), 1) AS `avg_wind_gust`,
        ROUND(AVG(`wind_direction_deg`), 0) AS `avg_wind_direction`,
        ROUND(AVG(`pressure_hpa`), 1) AS `avg_pressure`
    FROM 
        `tosse_filtered`
    WHERE 
        `pressure_hpa` <= 1040
    GROUP BY 
        YEARWEEK(`date_time`);
END;;

--
-- Procedure for getting data with montly averages
--
CREATE PROCEDURE get_monthly_average()
BEGIN
    SELECT 
        YEAR(`date_time`) AS `year`,
        MONTH(`date_time`) AS `month`,
        ROUND(AVG(`temp`), 1) AS `avg_temp`,
        ROUND(AVG(`wind_speed_ms`), 1) AS `avg_wind_speed`,
        ROUND(AVG(`wind_gust_ms`), 1) AS `avg_wind_gust`,
        ROUND(AVG(`wind_direction_deg`), 0) AS `avg_wind_direction`,
        ROUND(AVG(`pressure_hpa`), 1) AS `avg_pressure`
    FROM 
        `tosse_filtered`
    GROUP BY 
        YEAR(`date_time`), MONTH(`date_time`);
END;;

--
-- Procedure for getting data
--
CREATE PROCEDURE get_data_single_day(
    `p_day` DATE
)
BEGIN
    SELECT
        `tf`.*,
        `sd`.`humidity`,
        `sd`.`cloudbase_low`
    FROM `tosse_filtered` AS `tf`
    JOIN 
        `sunne_datapoint` AS `sd`
    ON `tf`.`date_time` = `sd`.`date_time`
    WHERE
        DATE(`tf`.`date_time`) = `p_day`;
END;;

DELIMITER ;
