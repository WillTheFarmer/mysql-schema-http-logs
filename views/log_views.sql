-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `log_client_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `log_client_list` AS
SELECT `name` AS `Client Name`,
       `clientID_logs`(id, 'A') AS `Access Log Count`, 
       `clientID_logs`(id, 'E') AS `Error Log Count` 
  FROM `log_client`
ORDER BY `name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `log_clientport_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `log_clientport_list` AS
SELECT `name` AS `Client Port`,
       `clientPortID_logs`(id, 'A') AS `Access Log Count`, 
       `clientPortID_logs`(id, 'E') AS `Error Log Count` 
  FROM `log_clientport`
ORDER BY `name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `log_referer_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `log_referer_list` AS
SELECT `name` AS `Referer`,
       `refererID_logs`(id, 'A') AS `Access Log Count`, 
       `refererID_logs`(id, 'E') AS `Error Log Count` 
  FROM `log_referer`
ORDER BY `name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `log_requestlog_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `log_requestlog_list` AS
SELECT `name` AS `Request Log`,
       `requestlogID_logs`(id, 'A') AS `Access Log Count`, 
       `requestlogID_logs`(id, 'E') AS `Error Log Count` 
  FROM `log_requestlogid`
ORDER BY `name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `log_server_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `log_server_list` AS
SELECT `name` AS `Server Name`,
       `serverID_logs`(id, 'A') AS `Access Log Count`, 
       `serverID_logs`(id, 'E') AS `Error Log Count` 
  FROM `log_server`
ORDER BY `name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `log_serverport_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `log_serverport_list` AS
SELECT `name` AS `Server Port`,
       `serverPortID_logs`(id, 'A') AS `Access Log Count`, 
       `serverPortID_logs`(id, 'E') AS `Error Log Count` 
  FROM `log_serverport`
ORDER BY `name`;
