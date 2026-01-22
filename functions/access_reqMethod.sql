-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_reqMethod`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_reqMethod`
    (in_ReqMethodID INTEGER)
    RETURNS VARCHAR(40)
    READS SQL DATA
BEGIN
    DECLARE reqMethod VARCHAR(40) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_reqMethod';
    SELECT name
      INTO reqMethod
      FROM access_log_reqmethod
     WHERE id = in_ReqMethodID;
    RETURN reqMethod;
END //
DELIMITER ;
