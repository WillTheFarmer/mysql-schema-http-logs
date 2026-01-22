-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `log_referer`;
-- create table ---------------------------------------------------------
CREATE TABLE `log_referer` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(750) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table is used by Access and Error logs.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `log_server`;
-- create table ---------------------------------------------------------
CREATE TABLE `log_server` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(253) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table is used by Access and Error logs.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `log_serverport`;
-- create table ---------------------------------------------------------
CREATE TABLE `log_serverport` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name INT NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table is used by Access and Error logs.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `log_client`;
-- create table ---------------------------------------------------------
CREATE TABLE `log_client` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(253) NOT NULL,
    country_code VARCHAR(20) DEFAULT NULL,
    country VARCHAR(150) DEFAULT NULL,
    subdivision VARCHAR(250) DEFAULT NULL,
    city VARCHAR(250) DEFAULT NULL,
    latitude decimal(10,8) DEFAULT NULL,
    longitude decimal(11,8) DEFAULT NULL,
    organization varchar(500) DEFAULT NULL,
    network varchar(100) DEFAULT NULL,
    countryid INT DEFAULT NULL,
    subdivisionid INT DEFAULT NULL,
    cityid INT DEFAULT NULL,
    coordinateid INT DEFAULT NULL,
    organizationid INT DEFAULT NULL,
    networkid INT DEFAULT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table is used by Access and Error logs.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `log_client_city`;
-- create table ---------------------------------------------------------
CREATE TABLE `log_client_city` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(250) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table is used by Access and Error logs.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `log_client_coordinate`;
-- create table ---------------------------------------------------------
CREATE TABLE `log_client_coordinate` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    latitude decimal(10,8) DEFAULT NULL,
    longitude decimal(11,8) DEFAULT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table is used by Access and Error logs.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `log_client_country`;
-- create table ---------------------------------------------------------
CREATE TABLE `log_client_country` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    country VARCHAR(150) NOT NULL,
    country_code VARCHAR(20) DEFAULT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table is used by Access and Error logs.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `log_client_network`;
-- create table ---------------------------------------------------------
CREATE TABLE `log_client_network` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table is used by Access and Error logs.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `log_client_organization`;
-- create table ---------------------------------------------------------
CREATE TABLE `log_client_organization` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(500) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table is used by Access and Error logs.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `log_client_subdivision`;
-- create table ---------------------------------------------------------
CREATE TABLE `log_client_subdivision` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(250) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table is used by Access and Error logs.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `log_clientport`;
-- create table ---------------------------------------------------------
CREATE TABLE `log_clientport` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name INT NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table is used by Access and Error logs.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `log_requestlogid`;
-- create table ---------------------------------------------------------
CREATE TABLE `log_requestlogid` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table is used by Access and Error logs.';