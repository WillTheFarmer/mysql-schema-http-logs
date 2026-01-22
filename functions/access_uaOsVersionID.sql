-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaOsVersionID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaOsVersionID`
    (in_ua_os_version VARCHAR(300))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE ua_os_version_ID INT DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_uaOsVersionID';
    SELECT id
      INTO ua_os_version_ID
      FROM access_log_ua_os_version
     WHERE name = in_ua_os_version;
    IF ua_os_version_ID IS NULL THEN
        INSERT INTO access_log_ua_os_version (name) VALUES (in_ua_os_version);
        SET ua_os_version_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_os_version_ID;
END //
DELIMITER ;
