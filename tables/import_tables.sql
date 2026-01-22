-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `import_device`;
-- create table ---------------------------------------------------------
CREATE TABLE `import_device` (
  id INT AUTO_INCREMENT PRIMARY KEY,
  deviceid VARCHAR(150) NOT NULL,
  platformNode VARCHAR(200) NOT NULL,
  platformSystem VARCHAR(100) NOT NULL,
  platformMachine VARCHAR(100) NOT NULL,
  platformProcessor VARCHAR(200) NOT NULL,
  added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table tracks unique Windows, Linux and Mac devices loading logs to server application.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `import_client`;
-- create table ---------------------------------------------------------
CREATE TABLE `import_client` (
  id INT AUTO_INCREMENT PRIMARY KEY,
  importdeviceid INT NOT NULL,
  ipaddress VARCHAR(50) NOT NULL,
  login VARCHAR(200) NOT NULL,
  expandUser VARCHAR(200) NOT NULL,
  platformRelease VARCHAR(100) NOT NULL,
  platformVersion VARCHAR(175) NOT NULL,
  added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table tracks network, OS release, logon and IP address information. It is important to know who is loading logs.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `import_load`;
-- create table ---------------------------------------------------------
CREATE TABLE `import_load` (
  id INT AUTO_INCREMENT PRIMARY KEY,
  importclientid INT NOT NULL,
  errorCount INT DEFAULT NULL,
  processSeconds INT DEFAULT NULL,
  started DATETIME NOT NULL DEFAULT NOW(),
  completed DATETIME DEFAULT NULL,
  comments VARCHAR(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table has record for every time the Python processLogs is executed. import_process has process totals for each execution.';
DROP TABLE IF EXISTS `import_process`;
-- create table ---------------------------------------------------------
CREATE TABLE `import_process` (
  id INT AUTO_INCREMENT PRIMARY KEY,
  importloadid INT NULL COMMENT 'record added from Python Module. Foreign Key to ID in import_load table',
  importserverid INT NULL COMMENT 'record added from MySQL stored procedure. Foreign Key to ID in import_server table',
  processName VARCHAR(255) NULL COMMENT 'processID from Python config.json and "NAME" asssigned from MySQL procedure',
  moduleName VARCHAR(255) NULL COMMENT 'moduleName from Python (_file__) and "TYPE" asssigned from MySQL procedure',
  filesFound INT DEFAULT NULL,
  filesProcessed INT DEFAULT NULL COMMENT 'this was previously "files" column in old import_process table',
  recordsProcessed INT DEFAULT NULL COMMENT 'this was previously "records" column in old import_process table',
  loadsProcessed INT DEFAULT NULL COMMENT 'this was previously "loads" column in old import_process table',
  errorCount INT DEFAULT NULL,
  processSeconds INT DEFAULT NULL,
  started DATETIME NOT NULL DEFAULT NOW(),
  completed DATETIME DEFAULT NULL,
  comments VARCHAR(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Python module or MySQL stored procedure with execution totals. If completed column is NULL process failed. import_error table for details.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `import_server`;
-- create table ---------------------------------------------------------
CREATE TABLE `import_server` (
  id INT AUTO_INCREMENT PRIMARY KEY,
  dbuser VARCHAR(255) NOT NULL,
  dbhost VARCHAR(255) NOT NULL,
  dbversion VARCHAR(55) NOT NULL,
  dbsystem VARCHAR(55) NOT NULL,
  dbmachine VARCHAR(55) NOT NULL,
  dbserverid VARCHAR(75) NOT NULL,
  dbcomment VARCHAR(75) NOT NULL,
  added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table for keeping track of log processing servers and login information.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `import_file`;
-- create table ---------------------------------------------------------
CREATE TABLE `import_file` (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(300) NOT NULL,
  importdeviceid INT NOT NULL,
  importloadid INT NOT NULL,
  loadprocessid INT DEFAULT NULL,
  parseprocessid INT DEFAULT NULL,
  importprocessid INT DEFAULT NULL,
  filesize BIGINT NOT NULL,
  filecreated DATETIME NOT NULL,
  filemodified DATETIME NOT NULL,
  server_name VARCHAR(253) DEFAULT NULL COMMENT 'Common & Combined logs. Added to populate Server for multiple domains import. Must be populated before import process.',
  server_port INT DEFAULT NULL COMMENT 'Common & Combined logs. Added to populate ServerPort for multiple domains import. Must be populated before import process.',
  importfileformatid INT NOT NULL COMMENT 'Import File Format - 1=common,2=combined,3=vhost,4=csv2mysql,5=error_default,6=error_vhost',
  added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table contains all access and error log files loaded and processed. Created, modified and size of each file at time of loading is captured for auditability. Each file processed by Server Application must exist in this table.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `import_file_format`;
-- create table ---------------------------------------------------------
CREATE TABLE `import_file_format` (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  comments VARCHAR(100) DEFAULT NULL,
  added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table contains import file formats imported by application. These values are inserted in schema DDL script. This table is only added for reporting purposes.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `import_error`;
-- create table ---------------------------------------------------------
CREATE TABLE `import_error` (
  id INT AUTO_INCREMENT PRIMARY KEY,
  importloadid INT DEFAULT NULL,
  importprocessid INT DEFAULT NULL,
  module VARCHAR(300) NULL,
  mysql_errno SMALLINT UNSIGNED NULL,
  message_text VARCHAR(1000) NULL,
  returned_sqlstate VARCHAR(250) NULL,
  schema_name VARCHAR(64) NULL,
  catalog_name VARCHAR(64) NULL,
  comments VARCHAR(350) NULL,
  added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COMMENT='Application Error log. Any errors that occur in MySQL processes will be here. This is a MyISAM engine table to avoid TRANSACTION ROLLBACKS. Always look in this table for problems!';