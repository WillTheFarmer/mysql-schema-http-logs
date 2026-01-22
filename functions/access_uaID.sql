-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaID`
    (in_ua VARCHAR(300))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE ua_ID INT DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_uaID';
    SELECT id
      INTO ua_ID
      FROM access_log_ua
     WHERE name = in_ua;
    IF ua_ID IS NULL THEN
        INSERT INTO access_log_ua (name) VALUES (in_ua);
        SET ua_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_ID;
END //
DELIMITER ;
