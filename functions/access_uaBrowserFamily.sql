-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaBrowserFamily`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaBrowserFamily`
    (in_ua_browser_familyID INTEGER)
    RETURNS VARCHAR(300)
    READS SQL DATA
BEGIN
    DECLARE ua_browser_family VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_uaBrowserFamily';
    SELECT name
      INTO ua_browser_family
      FROM access_log_ua_browser_family
     WHERE id = in_ua_browser_familyID;
    RETURN ua_browser_family;
END //
DELIMITER ;
