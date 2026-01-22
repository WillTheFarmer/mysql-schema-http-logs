-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_reqQueryID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_reqQueryID`
    (in_ReqQuery VARCHAR(5000))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE reqQuery_ID INT DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_reqQueryID';
    SELECT id
      INTO reqQuery_ID
      FROM access_log_reqquery
     WHERE name = in_ReqQuery;
    IF reqQuery_ID IS NULL THEN
        INSERT INTO access_log_reqquery (name) VALUES (in_ReqQuery);
        SET reqQuery_ID = LAST_INSERT_ID();
    END IF;
    RETURN reqQuery_ID;
END //
DELIMITER ;
