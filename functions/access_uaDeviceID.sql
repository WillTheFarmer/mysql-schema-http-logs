-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaDeviceID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaDeviceID`
    (in_ua_device VARCHAR(300))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE ua_device_ID INT DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_uaDeviceID'; 
    SELECT id
      INTO ua_device_ID
      FROM access_log_ua_device
     WHERE name = in_ua_device;
    IF ua_device_ID IS NULL THEN
        INSERT INTO access_log_ua_device (name) VALUES (in_ua_device);
        SET ua_device_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_device_ID;
END //
DELIMITER ;
