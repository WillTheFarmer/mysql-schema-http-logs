-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaDeviceFamilyID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaDeviceFamilyID`
    (in_ua_device_family VARCHAR(300))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE ua_device_family_ID INT DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_uaDeviceFamilyID';
    SELECT id
      INTO ua_device_family_ID
      FROM access_log_ua_device_family
     WHERE name = in_ua_device_family;
    IF ua_device_family_ID IS NULL THEN
        INSERT INTO access_log_ua_device_family (name) VALUES (in_ua_device_family);
        SET ua_device_family_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_device_family_ID;
END //
DELIMITER ;
