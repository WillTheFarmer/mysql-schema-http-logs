-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaDeviceBrand`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaDeviceBrand`
    (in_ua_device_brandID INTEGER)
    RETURNS VARCHAR(300)
    READS SQL DATA
BEGIN
    DECLARE ua_device_brand VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_uaDeviceBrand';
    SELECT name
      INTO ua_device_brand
      FROM access_log_ua_device_brand
     WHERE name = in_ua_device_brandID;
    RETURN ua_device_brand;
END //
DELIMITER ;
