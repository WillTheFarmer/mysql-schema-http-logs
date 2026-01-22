-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_level_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_level_list` AS
     SELECT `ln`.`name` AS `Error Log Level`, 
            COUNT(`l`.`id`) AS `Log Count`
       FROM `error_log_level` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`loglevelid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_module_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_module_list` AS
     SELECT `ln`.`name` AS `Error Log Module`,
            COUNT(`l`.`id`) AS `Log Count`
       FROM `error_log_module` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`moduleid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_processid_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_processid_list` AS
     SELECT `ln`.`name` AS `Error Log ProcessID`,
            COUNT(`l`.`id`) AS `Log Count`
       FROM `error_log_processid` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`processid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_threadid_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_threadid_list` AS
     SELECT `ln`.`name` AS `Error Log ThreadID`,
            COUNT(`l`.`id`) AS `Log Count`
       FROM `error_log_threadid` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`threadid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_processid_threadid_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_processid_threadid_list` AS
     SELECT `pid`.`name` AS `ProcessID`,
            `tid`.`name` AS `ThreadID`,
            COUNT(`l`.`id`) AS `Log Count`
       FROM `error_log` `l`
 INNER JOIN `error_log_processid` `pid`
         ON `l`.`processid` = `pid`.`id`
 INNER JOIN `error_log_threadid` `tid`
         ON `l`.`threadid` = `tid`.`id`
   GROUP BY `pid`.`id`,
            `tid`.`id`
   ORDER BY `pid`.`name`,
            `tid`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_httpCode_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_httpCode_list` AS
     SELECT `ln`.`name` AS `Error Log http Code`,
            COUNT(`l`.`id`) AS `Log Count`
       FROM `error_log_httpcode` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`httpcodeid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_httpMessage_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_httpMessage_list` AS
     SELECT `ln`.`name` AS `Error Log http Message`,
            COUNT(`l`.`id`) AS `Log Count`
       FROM `error_log_httpmessage` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`httpmessageid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_systemCode_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_systemCode_list` AS
     SELECT `ln`.`name` AS `Error Log System Code`,
            COUNT(`l`.`id`) AS `Log Count`
       FROM `error_log_systemcode` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`systemcodeid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;


-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_systemMessage_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_systemMessage_list` AS
     SELECT `ln`.`name` AS `Error Log System Message`,
            COUNT(`l`.`id`) AS `Log Count`
       FROM `error_log_systemmessage` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`systemmessageid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_message_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_message_list` AS
     SELECT `ln`.`name` AS `Error Log Message`,
            COUNT(`l`.`id`) AS `Log Count`
       FROM `error_log_message` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`logmessageid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_client_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_client_list` AS
     SELECT `ln`.`name` AS `Error Log Client Name`,
            COUNT(`l`.`id`) AS `Log Count`
       FROM `log_client` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`clientid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_clientport_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_clientport_list` AS
     SELECT `ln`.`name` AS `Error Log Client Port`,
            COUNT(`l`.`id`) AS `Log Count`
       FROM `log_clientport` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`clientportid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_client_clientport_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_client_clientport_list` AS
     SELECT `cn`.`name` AS `Error Log Server Name`,
            `cp`.`name` AS `Server Port`,
            COUNT(`l`.`id`) AS `Log Count` 
       FROM `error_log` `l`
 INNER JOIN `log_client` `cn`
         ON `cn`.`id` = `l`.`clientid`
 INNER JOIN `log_clientport` `cp`
         ON `cp`.`id` = `l`.`clientportid`
   GROUP BY `l`.`clientid`,
            `l`.`clientportid`
   ORDER BY `cn`.`name`,
            `cp`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_referer_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_referer_list` AS
     SELECT `ln`.`name` AS `Error Log Referer`,
            COUNT(`l`.`id`) AS `Log Count`
       FROM `log_referer` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`refererid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_server_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_server_list` AS
     SELECT `ln`.`name` AS `Error Log Server Name`,
            COUNT(`l`.`id`) AS `Log Count` 
       FROM `log_server` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`serverid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_serverport_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_serverport_list` AS
     SELECT `ln`.`name` AS `Error Log Server Port`,
            COUNT(`l`.`id`) AS `Log Count` 
       FROM `log_serverport` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`serverportid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_server_serverport_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_server_serverport_list` AS
     SELECT `sn`.`name` AS `Error Log Server Name`,
            `sp`.`name` AS `Server Port`,
            COUNT(`l`.`id`) AS `Log Count` 
       FROM `error_log` `l`
 INNER JOIN `log_server` `sn`
         ON `sn`.`id` = `l`.`serverid`
 INNER JOIN `log_serverport` `sp`
         ON `sp`.`id` = `l`.`serverportid`
   GROUP BY `l`.`serverid`,
            `l`.`serverportid`
   ORDER BY `sn`.`name`,
	          `sp`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_importfile_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_importfile_list` AS
     SELECT `ln`.`name` AS `Error Log Import File`, 
            COUNT(`l`.`id`) AS `Log Count`
       FROM `import_file` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`importfileid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_period_year_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_period_year_list` AS
     SELECT YEAR(l.logged) 'Year',
            COUNT(`l`.`id`) AS `Log Count`
       FROM `error_log` `l`
   GROUP BY YEAR(l.logged)
   ORDER BY 'Year'; 

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_period_month_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_period_month_list` AS
    SELECT YEAR(l.logged) 'Year',
           MONTH(l.logged) 'Month',
           COUNT(`l`.`id`) AS `Log Count`
      FROM `error_log` `l`
  GROUP BY YEAR(l.logged),
           MONTH(l.logged)
  ORDER BY 'Year',
           'Month'; 

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_period_week_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_period_week_list` AS
     SELECT YEAR(l.logged) 'Year',
            MONTH(l.logged) 'Month',
            WEEK(l.logged) 'Week',
            COUNT(`l`.`id`) AS `Log Count`
       FROM `error_log` `l`
   GROUP BY YEAR(l.logged),
            MONTH(l.logged),
            WEEK(l.logged)
   ORDER BY 'Year',
            'Month',
            'Week'; 

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_period_day_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_period_day_list` AS
     SELECT YEAR(l.logged) 'Year',
            MONTH(l.logged) 'Month',
            DAY(l.logged) 'Day',
            COUNT(`l`.`id`) AS `Log Count`
       FROM `error_log` `l`
   GROUP BY YEAR(l.logged),
            MONTH(l.logged),
            DAY(l.logged)
   ORDER BY 'Year',
            'Month',
            'Day'; 

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `error_period_hour_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `error_period_hour_list` AS
     SELECT YEAR(l.logged) 'Year',
            MONTH(l.logged) 'Month',
            DAY(l.logged) 'Day',
            HOUR(l.logged) 'Hour',
            COUNT(`l`.`id`) AS `Log Count`
       FROM `error_log` `l`
   GROUP BY YEAR(l.logged),
            MONTH(l.logged),
            DAY(l.logged),
            HOUR(l.logged)
   ORDER BY 'Year',
            'Month',
            'Day',
            'Hour';
     