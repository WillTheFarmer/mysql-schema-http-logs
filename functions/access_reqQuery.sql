-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_reqQuery`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_reqQuery`
    (in_ReqQueryID INTEGER)
    RETURNS VARCHAR(5000)
    READS SQL DATA
BEGIN
    DECLARE reqQuery VARCHAR(5000) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_reqQuery';
    SELECT name
      INTO reqQuery
      FROM access_log_reqquery
     WHERE id = in_ReqQueryID;
    RETURN reqQuery;
END //
DELIMITER ;
