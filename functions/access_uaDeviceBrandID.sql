-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaDeviceBrandID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaDeviceBrandID`
    (in_ua_device_brand VARCHAR(300))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE ua_device_brand_ID INT DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_uaDeviceBrandID';
    SELECT id
      INTO ua_device_brand_ID
      FROM access_log_ua_device_brand
     WHERE name = in_ua_device_brand;
    IF ua_device_brand_ID IS NULL THEN
        INSERT INTO access_log_ua_device_brand (name) VALUES (in_ua_device_brand);
        SET ua_device_brand_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_device_brand_ID;
END //
DELIMITER ;
