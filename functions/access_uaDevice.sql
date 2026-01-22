-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaDevice`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaDevice`
    (in_ua_deviceID INTEGER)
    RETURNS VARCHAR(300)
    READS SQL DATA
BEGIN
    DECLARE ua_device VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_uaDevice';
    SELECT name
      INTO ua_device
      FROM access_log_ua_device
     WHERE id = in_ua_deviceID;
    RETURN ua_device;
END //
DELIMITER ;
