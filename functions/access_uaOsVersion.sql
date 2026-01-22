-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaOsVersion`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaOsVersion`
    (in_ua_os_versionID INTEGER)
    RETURNS VARCHAR(300)
    READS SQL DATA
BEGIN
    DECLARE ua_os_version VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_uaOsVersion';
    SELECT name
      INTO ua_os_version
      FROM access_log_ua_os_version
     WHERE id = in_ua_os_versionID;
    RETURN ua_os_version;
END //
DELIMITER ;
