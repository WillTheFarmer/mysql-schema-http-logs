-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `import_file_access_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `import_file_access_list` AS
     SELECT `ln`.`name` AS `Import File`, 
            COUNT(`l`.`id`) AS `Log Count`, 
            SUM(`l`.`reqbytes`) AS `HTTP Bytes`, 
            SUM(`l`.`bytes_sent`) AS `Bytes Sent`, 
            SUM(`l`.`bytes_received`) AS `Bytes Received`,
            SUM(`l`.`bytes_transferred`) AS `Bytes Transferred`,
            MAX(`l`.`reqtime_milli`) AS `Max Request Time`,
            MIN(`l`.`reqtime_milli`) AS `Min Request Time`,
            MAX(`l`.`reqdelay_milli`) AS `Max Delay Time`,
            MIN(`l`.`reqdelay_milli`) AS `Min Delay Time`
       FROM `import_file` `ln`
 INNER JOIN `access_log` `l` 
         ON `l`.`importfileid` = `ln`.`id`
   GROUP BY `ln`.`name`
   ORDER BY `ln`.`name`;

-- drop table -----------------------------------------------------------
DROP VIEW IF EXISTS `import_file_error_list`;
-- create table ---------------------------------------------------------
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `import_file_error_list` AS
     SELECT `ln`.`name` AS `Import File`, 
            COUNT(`l`.`id`) AS `Log Count`
       FROM `import_file` `ln`
 INNER JOIN `error_log` `l` 
         ON `l`.`importfileid` = `ln`.`id`
   GROUP BY `ln`.`name`
   ORDER BY `ln`.`name`;
