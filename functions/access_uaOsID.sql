-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaOsID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaOsID`
    (in_ua_os VARCHAR(300))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE ua_os_ID INT DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_uaOsID'; 
    SELECT id
      INTO ua_os_ID
      FROM access_log_ua_os
     WHERE name = in_ua_os;
    IF ua_os_ID IS NULL THEN
        INSERT INTO access_log_ua_os (name) VALUES (in_ua_os);
        SET ua_os_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_os_ID;
END //
DELIMITER ;
