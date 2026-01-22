-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaDeviceModelID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaDeviceModelID`
    (in_ua_device_model VARCHAR(300))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE ua_device_model_ID INT DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_uaDeviceModelID';
    SELECT id
      INTO ua_device_model_ID
      FROM access_log_ua_device_model
     WHERE name = in_ua_device_model;
    IF ua_device_model_ID IS NULL THEN
        INSERT INTO access_log_ua_device_model (name) VALUES (in_ua_device_model);
        SET ua_device_model_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_device_model_ID;
END //
DELIMITER ;
