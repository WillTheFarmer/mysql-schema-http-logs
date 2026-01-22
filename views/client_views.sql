-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_client_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_client_list` AS
     SELECT `ln`.`name` AS `Access Client Name`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `log_client` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`clientid` = `ln`.`id`
   GROUP BY `ln`.`name`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_clientcity_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_clientcity_list` AS
     SELECT `ln`.`city` AS `Access Client City`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `log_client` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`clientid` = `ln`.`id`
   GROUP BY `ln`.`city`
   ORDER BY `ln`.`city`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_clientcountry_code_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_clientcountry_code_list` AS
     SELECT `ln`.`country_code` AS `Access Client Country Code`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `log_client` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`clientid` = `ln`.`id`
   GROUP BY `ln`.`country_code`
   ORDER BY `ln`.`country_code`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_clientcountry_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_clientcountry_list` AS
     SELECT `ln`.`country` AS `Access Client Country`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `log_client` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`clientid` = `ln`.`id`
   GROUP BY `ln`.`country`
   ORDER BY `ln`.`country`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_clientsubdivision_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_clientsubdivision_list` AS
     SELECT `ln`.`subdivision` AS `Access Client Subdivision`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `log_client` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`clientid` = `ln`.`id`
   GROUP BY `ln`.`subdivision`
   ORDER BY `ln`.`subdivision`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_clientorganization_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_clientorganization_list` AS
     SELECT `ln`.`organization` AS `Access Client Organization`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `log_client` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`clientid` = `ln`.`id`
   GROUP BY `ln`.`organization`
   ORDER BY `ln`.`organization`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_clientnetwork_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_clientnetwork_list` AS
     SELECT `ln`.`network` AS `Access Client Network`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `log_client` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`clientid` = `ln`.`id`
   GROUP BY `ln`.`network`
   ORDER BY `ln`.`network`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_client_city_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_client_city_list` AS
     SELECT `ca`.`name` AS `Access Client City`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `log_client_city` `ca`
 INNER JOIN `log_client` `c` 
         ON `c`.`cityid` = `ca`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`clientid` = `c`.`id`
   GROUP BY `ca`.`name`
   ORDER BY `ca`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_client_country_code_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_client_country_code_list` AS
     SELECT `ca`.`country_code` AS `Access Client Country Code`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `log_client_country` `ca`
 INNER JOIN `log_client` `c` 
         ON `c`.`countryid` = `ca`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`clientid` = `c`.`id`
   GROUP BY `ca`.`country_code`
   ORDER BY `ca`.`country_code`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_client_country_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_client_country_list` AS
     SELECT `ca`.`country` AS `Access Client Country`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `log_client_country` `ca`
 INNER JOIN `log_client` `c` 
         ON `c`.`countryid` = `ca`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`clientid` = `c`.`id`
   GROUP BY `ca`.`country`
   ORDER BY `ca`.`country`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_client_subdivision_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_client_subdivision_list` AS
     SELECT `ca`.`name` AS `Access Client Subdivision`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `log_client_subdivision` `ca`
 INNER JOIN `log_client` `c` 
         ON `c`.`subdivisionid` = `ca`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`clientid` = `c`.`id`
   GROUP BY `ca`.`name`
   ORDER BY `ca`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_client_organization_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_client_organization_list` AS
     SELECT `ca`.`name` AS `Access Client Organization`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `log_client_organization` `ca`
 INNER JOIN `log_client` `c` 
         ON `c`.`organizationid` = `ca`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`clientid` = `c`.`id`
   GROUP BY `ca`.`name`
   ORDER BY `ca`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `access_client_network_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `access_client_network_list` AS
     SELECT `ca`.`name` AS `Access Client Network`,
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `log_client_network` `ca`
 INNER JOIN `log_client` `c` 
         ON `c`.`networkid` = `ca`.`id`
 INNER JOIN `access_log` `l` 
         ON `l`.`clientid` = `c`.`id`
   GROUP BY `ca`.`name`
   ORDER BY `ca`.`name`;
