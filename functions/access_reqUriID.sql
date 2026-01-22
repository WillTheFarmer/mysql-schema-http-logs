-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_reqUriID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_reqUriID`
    (in_ReqUri VARCHAR(2000))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE reqUri_ID INT DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_reqUriID';
    SELECT id
      INTO reqUri_ID
      FROM access_log_requri
     WHERE name = in_ReqUri;
    IF reqUri_ID IS NULL THEN
        INSERT INTO access_log_requri (name) VALUES (in_ReqUri);
        SET reqUri_ID = LAST_INSERT_ID();
    END IF;
    RETURN reqUri_ID;
END //
DELIMITER ;
