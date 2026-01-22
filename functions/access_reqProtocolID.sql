-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_reqProtocolID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_reqProtocolID`
    (in_ReqProtocol VARCHAR(20))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE reqProtocol_ID INT DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_reqProtocolID';
    SELECT id
      INTO reqProtocol_ID
      FROM access_log_reqprotocol
     WHERE name = in_ReqProtocol;
    IF reqProtocol_ID IS NULL THEN
        INSERT INTO access_log_reqprotocol (name) VALUES (in_ReqProtocol);
        SET reqProtocol_ID = LAST_INSERT_ID();
    END IF;
    RETURN reqProtocol_ID;
END //
DELIMITER ;
