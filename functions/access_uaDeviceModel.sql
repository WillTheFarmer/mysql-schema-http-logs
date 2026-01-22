-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaDeviceModel`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaDeviceModel`
    (in_ua_device_modelID INTEGER)
    RETURNS VARCHAR(300)
    READS SQL DATA
BEGIN
    DECLARE ua_device_model VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_uaDeviceModel';
    SELECT name
      INTO ua_device_model
      FROM access_log_ua_device_model
     WHERE id = in_ua_device_modelID;
    RETURN ua_device_model;
END //
DELIMITER ;
