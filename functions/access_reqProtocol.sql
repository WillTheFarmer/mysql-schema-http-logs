-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_reqProtocol`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_reqProtocol`
    (in_ReqProtocolID INTEGER)
    RETURNS VARCHAR(20)
    READS SQL DATA
BEGIN
    DECLARE reqProtocol VARCHAR(20) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_reqProtocol';
    SELECT name
      INTO reqProtocol
      FROM access_log_reqprotocol
     WHERE id = in_ReqProtocolID;
    RETURN reqProtocol;
END //
DELIMITER ;
