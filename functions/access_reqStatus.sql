-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_reqStatus`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_reqStatus`
    (in_ReqStatusID INTEGER)
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE reqStatus INT DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_reqStatus';
    SELECT name
      INTO reqStatus
      FROM access_log_reqstatus
     WHERE id = in_ReqStatusID;
    RETURN reqStatus;
END //
DELIMITER ;
