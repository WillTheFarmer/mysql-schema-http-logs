-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_userAgent`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_userAgent`
    (in_UserAgentID INTEGER)
    RETURNS VARCHAR(2000)
    READS SQL DATA
BEGIN
    DECLARE userAgent VARCHAR(2000) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_userAgent';
    SELECT name
      INTO userAgent
      FROM access_log_useragent
     WHERE id = in_UserAgentID;
    RETURN userAgent;
END //
DELIMITER ;
