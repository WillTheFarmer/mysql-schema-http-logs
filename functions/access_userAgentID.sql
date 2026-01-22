-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_userAgentID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_userAgentID`
    (in_UserAgent VARCHAR(2000))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE userAgent_ID INT DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_userAgentID';
    SELECT id
      INTO userAgent_ID
      FROM access_log_useragent
     WHERE name = in_UserAgent;
    IF userAgent_ID IS NULL THEN
        INSERT INTO access_log_useragent (name) VALUES (in_UserAgent);
        SET userAgent_ID = LAST_INSERT_ID();
    END IF;
    RETURN userAgent_ID;
END //
DELIMITER ;
