-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaBrowserID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaBrowserID`
    (in_ua_browser VARCHAR(300))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE ua_browser_ID INT DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_uaBrowserID';
    SELECT id
      INTO ua_browser_ID
      FROM access_log_ua_browser
     WHERE name = in_ua_browser;
    IF ua_browser_ID IS NULL THEN
        INSERT INTO access_log_ua_browser (name) VALUES (in_ua_browser);
        SET ua_browser_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_browser_ID;
END //
DELIMITER ;
