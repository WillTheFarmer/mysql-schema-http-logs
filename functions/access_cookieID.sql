-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_cookieID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_cookieID`
    (in_Cookie VARCHAR(400))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE cookie_ID INT DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_cookieID';
    SELECT id
      INTO cookie_ID
      FROM access_log_cookie
     WHERE name = in_Cookie;
    IF cookie_ID IS NULL THEN
        INSERT INTO access_log_cookie (name) VALUES (in_Cookie);
        SET cookie_ID = LAST_INSERT_ID();
    END IF;
    RETURN cookie_ID;
END //
DELIMITER ;
