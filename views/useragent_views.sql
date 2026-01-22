-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_useragent_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_useragent_list` AS
     SELECT `ln`.`name` AS `Access Log UserAgent`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_useragent` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `ln`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_useragent_pretty_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_useragent_pretty_list` AS
     SELECT `ln`.`ua` AS `Access Log Pretty User Agent`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_useragent` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `ln`.`id`
   GROUP BY `ln`.`ua`
   ORDER BY `ln`.`ua`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_useragent_os_browser_device_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_useragent_os_browser_device_list` AS
     SELECT `ln`.`ua_os_family` AS `Operating System`,
            `ln`.`ua_browser_family` AS `Browser`,
            `ln`.`ua_device_family` AS `Device`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_useragent` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `ln`.`id`
   GROUP BY `ln`.`ua_os_family`,
            `ln`.`ua_browser_family`,
            `ln`.`ua_device_family`
   ORDER BY `ln`.`ua_os_family`, 
            `ln`.`ua_browser_family`,
            `ln`.`ua_device_family`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_useragent_browser_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_useragent_browser_list` AS
     SELECT `ln`.`ua_browser` AS `Browser`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_useragent` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `ln`.`id`
   GROUP BY `ln`.`ua_browser`
   ORDER BY `ln`.`ua_browser`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_useragent_browser_family_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_useragent_browser_family_list` AS
     SELECT `ln`.`ua_browser_family` AS `Browser Family`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_useragent` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `ln`.`id`
   GROUP BY `ln`.`ua_browser_family`
   ORDER BY `ln`.`ua_browser_family`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_useragent_browser_version_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_useragent_browser_version_list` AS
     SELECT `ln`.`ua_browser_version` AS `Browser Version`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_useragent` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `ln`.`id`
   GROUP BY `ln`.`ua_browser_version`
   ORDER BY `ln`.`ua_browser_version`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_useragent_device_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_useragent_device_list` AS
     SELECT `ln`.`ua_device` AS `Device`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_useragent` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `ln`.`id`
   GROUP BY `ln`.`ua_device`
   ORDER BY `ln`.`ua_device`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_useragent_device_brand_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_useragent_device_brand_list` AS
     SELECT `ln`.`ua_device_brand` AS `Device Brand`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_useragent` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `ln`.`id`
   GROUP BY `ln`.`ua_device_brand`
   ORDER BY `ln`.`ua_device_brand`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_useragent_device_family_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_useragent_device_family_list` AS
     SELECT `ln`.`ua_device_family` AS `Device Family`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_useragent` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `ln`.`id`
   GROUP BY `ln`.`ua_device_family`
   ORDER BY `ln`.`ua_device_family`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_useragent_device_model_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_useragent_device_model_list` AS
     SELECT `ln`.`ua_device_model` AS `Device Model`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_useragent` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `ln`.`id`
   GROUP BY `ln`.`ua_device_model`
   ORDER BY `ln`.`ua_device_model`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_useragent_os_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_useragent_os_list` AS
     SELECT `ln`.`ua_os` AS `Operating System`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_useragent` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `ln`.`id`
   GROUP BY `ln`.`ua_os`
   ORDER BY `ln`.`ua_os`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_useragent_os_family_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_useragent_os_family_list` AS
     SELECT `ln`.`ua_os_family` AS `Operating System Family`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_useragent` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `ln`.`id`
   GROUP BY `ln`.`ua_os_family`
   ORDER BY `ln`.`ua_os_family`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_useragent_os_version_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_useragent_os_version_list` AS
     SELECT `ln`.`ua_os_version` AS `Operating System Version`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_useragent` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `ln`.`id`
   GROUP BY `ln`.`ua_os_version`
   ORDER BY `ln`.`ua_os_version`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_ua_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_ua_list` AS
     SELECT `ln`.`name` AS `Access Log User Agent`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_ua` `ln`
 INNER JOIN `access_log_useragent` `lua` 
         ON `lua`.`uaid` = `ln`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `lua`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_ua_browser_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_ua_browser_list` AS
    SELECT `ln`.`name` AS `Browser`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_ua_browser` `ln`
 INNER JOIN `access_log_useragent` `lua` 
         ON `lua`.`uabrowserid` = `ln`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `lua`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_ua_browser_family_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_ua_browser_family_list` AS
     SELECT `ln`.`name` AS `Browser Family`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_ua_browser_family` `ln`
 INNER JOIN `access_log_useragent` `lua` 
         ON `lua`.`uabrowserfamilyid` = `ln`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `lua`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_ua_browser_version_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_ua_browser_version_list` AS
    SELECT `ln`.`name` AS `Browser Version`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_ua_browser_version` `ln`
 INNER JOIN `access_log_useragent` `lua` 
         ON `lua`.`uabrowserversionid` = `ln`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `lua`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_ua_device_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_ua_device_list` AS
    SELECT `ln`.`name` AS `Device`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_ua_device` `ln`
 INNER JOIN `access_log_useragent` `lua` 
         ON `lua`.`uadeviceid` = `ln`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `lua`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_ua_device_brand_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_ua_device_brand_list` AS
    SELECT `ln`.`name` AS `Device Brand`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_ua_device_brand` `ln`
 INNER JOIN `access_log_useragent` `lua` 
         ON `lua`.`uadevicebrandid` = `ln`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `lua`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_ua_device_family_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_ua_device_family_list` AS
    SELECT `ln`.`name` AS `Device Family`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_ua_device_family` `ln`
 INNER JOIN `access_log_useragent` `lua` 
         ON `lua`.`uadevicefamilyid` = `ln`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `lua`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_ua_device_model_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_ua_device_model_list` AS
     SELECT `ln`.`name` AS `Device Model`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_ua_device_model` `ln`
 INNER JOIN `access_log_useragent` `lua` 
         ON `lua`.`uadevicefamilyid` = `ln`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `lua`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_ua_os_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_ua_os_list` AS
    SELECT `ln`.`name` AS `Operating System`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_ua_os` `ln`
 INNER JOIN `access_log_useragent` `lua` 
         ON `lua`.`uaosid` = `ln`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `lua`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_ua_os_family_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_ua_os_family_list` AS
     SELECT `ln`.`name` AS `Operating System Family`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_ua_os_family` `ln`
 INNER JOIN `access_log_useragent` `lua` 
         ON `lua`.`uaosfamilyid` = `ln`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `lua`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_ua_os_version_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_ua_os_version_list` AS
     SELECT `ln`.`name` AS `Operating System Version`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `access_log_ua_os_version` `ln`
 INNER JOIN `access_log_useragent` `lua` 
         ON `lua`.`uaosversionid` = `ln`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`useragentid` = `lua`.`id`
   GROUP BY `ln`.`id`
   ORDER BY `ln`.`name`;
