-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaDeviceFamily`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaDeviceFamily`
    (in_ua_device_familyID INTEGER)
    RETURNS VARCHAR(300)
    READS SQL DATA
BEGIN
    DECLARE ua_device_family VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_uaDeviceFamily';
    SELECT name
      INTO ua_device_family
      FROM access_log_ua_device_family
     WHERE id = in_ua_device_familyID;
    RETURN ua_device_family;
END //
DELIMITER ;
