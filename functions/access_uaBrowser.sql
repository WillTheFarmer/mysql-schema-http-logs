-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaBrowser`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaBrowser`
    (in_ua_browserID INTEGER)
    RETURNS VARCHAR(300)
    READS SQL DATA
BEGIN
    DECLARE ua_browser VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_uaBrowser';
    SELECT name
      INTO ua_browser
      FROM access_log_ua_browser
     WHERE id = in_ua_browserID;
    RETURN ua_browser;
END //
DELIMITER ;
