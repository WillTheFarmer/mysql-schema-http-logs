-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaBrowserVersionID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaBrowserVersionID`
    (in_ua_browser_version VARCHAR(300))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE ua_browser_version_ID INT DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_uaBrowserVersionID';
    SELECT id
      INTO ua_browser_version_ID
      FROM access_log_ua_browser_version
     WHERE name = in_ua_browser_version;
    IF ua_browser_version_ID IS NULL THEN
        INSERT INTO access_log_ua_browser_version (name) VALUES (in_ua_browser_version);
        SET ua_browser_version_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_browser_version_ID;
END //
DELIMITER ;
