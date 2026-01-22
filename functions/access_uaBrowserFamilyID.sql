-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaBrowserFamilyID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaBrowserFamilyID`
    (in_ua_browser_family VARCHAR(300))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE ua_browser_family_ID INT DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_uaBrowserFamilyID';
    SELECT id
      INTO ua_browser_family_ID
      FROM access_log_ua_browser_family
     WHERE name = in_ua_browser_family;
    IF ua_browser_family_ID IS NULL THEN
        INSERT INTO access_log_ua_browser_family (name) VALUES (in_ua_browser_family);
        SET ua_browser_family_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_browser_family_ID;
END //
DELIMITER ;
