-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaOsFamily`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaOsFamily`
    (in_ua_os_familyID INTEGER)
    RETURNS VARCHAR(300)
    READS SQL DATA
BEGIN
    DECLARE ua_os_family VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_uaOsFamily';
    SELECT name
      INTO ua_os_family
      FROM access_log_ua_os_family
     WHERE id = in_ua_os_familyID;
    RETURN ua_os_family;
END //
DELIMITER ;
