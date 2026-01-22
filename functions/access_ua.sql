-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_ua`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_ua`
    (in_uaID INTEGER)
    RETURNS VARCHAR(300)
    READS SQL DATA
BEGIN
    DECLARE ua VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_ua';
    SELECT name
      INTO ua
      FROM access_log_ua
     WHERE id = in_uaID;
    RETURN ua;
END //
DELIMITER ;
