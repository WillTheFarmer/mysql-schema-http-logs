-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_reqStatusID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_reqStatusID`
    (in_ReqStatus INTEGER)
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE reqStatus_ID INT DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_reqStatusID';
    SELECT id
      INTO reqStatus_ID
      FROM access_log_reqstatus
     WHERE name = in_ReqStatus;
    IF reqStatus_ID IS NULL THEN
        INSERT INTO access_log_reqstatus (name) VALUES (in_ReqStatus);
        SET reqStatus_ID = LAST_INSERT_ID();
    END IF;
    RETURN reqStatus_ID;
END //
DELIMITER ;
