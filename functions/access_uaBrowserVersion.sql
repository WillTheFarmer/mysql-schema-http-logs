-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaBrowserVersion`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaBrowserVersion`
    (in_ua_browser_versionID INTEGER)
    RETURNS VARCHAR(300)
    READS SQL DATA
BEGIN
    DECLARE ua_browser_version VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_uaBrowserVersion';
    SELECT name
      INTO ua_browser_version
      FROM access_log_ua_browser_version
     WHERE id = in_ua_browser_versionID;
    RETURN ua_browser_version;
END //
DELIMITER ;
