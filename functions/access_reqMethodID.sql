-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_reqMethodID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_reqMethodID`
    (in_ReqMethod VARCHAR(40))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE reqMethod_ID INT DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_reqMethodID';
    SELECT id
      INTO reqMethod_ID
      FROM access_log_reqmethod
     WHERE name = in_ReqMethod;
    IF reqMethod_ID IS NULL THEN
        INSERT INTO access_log_reqmethod (name) VALUES (in_ReqMethod);
        SET reqMethod_ID = LAST_INSERT_ID();
    END IF;
    RETURN reqMethod_ID;
END //
DELIMITER ;
