-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaOsFamilyID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaOsFamilyID`
    (in_ua_os_family VARCHAR(300))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE ua_os_family_ID INT DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_uaOsFamilyID';
    SELECT id
      INTO ua_os_family_ID
      FROM access_log_ua_os_family
     WHERE name = in_ua_os_family;
    IF ua_os_family_ID IS NULL THEN
        INSERT INTO access_log_ua_os_family (name) VALUES (in_ua_os_family);
        SET ua_os_family_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_os_family_ID;
END //
DELIMITER ;
