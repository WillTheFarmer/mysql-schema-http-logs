-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_reqUri`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_reqUri`
    (in_ReqUriID INTEGER)
    RETURNS VARCHAR(2000)
    READS SQL DATA
BEGIN
    DECLARE reqUri VARCHAR(2000) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_reqUri';
    SELECT name
      INTO reqUri
      FROM access_log_requri
     WHERE id = in_ReqUriID;
    RETURN reqUri;
END //
DELIMITER ;
