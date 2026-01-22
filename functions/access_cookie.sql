-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_cookie`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_cookie`
    (in_CookieID INTEGER)
    RETURNS VARCHAR(400)
    READS SQL DATA
BEGIN
    DECLARE cookie VARCHAR(400) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_cookie';
    SELECT name
      INTO cookie
      FROM access_log_cookie
     WHERE id = in_CookieID;
    RETURN cookie;
END //
DELIMITER ;
