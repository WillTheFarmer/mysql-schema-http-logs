-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_remoteLogNameID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_remoteLogNameID`
    (in_RemoteLogName VARCHAR(150))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE remoteLogName_ID INT DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_remoteLogNameID';
    SELECT id
      INTO remoteLogName_ID
      FROM access_log_remotelogname
     WHERE name = in_RemoteLogName;
    IF remoteLogName_ID IS NULL THEN
        INSERT INTO access_log_remotelogname (name) VALUES (in_RemoteLogName);
        SET remoteLogName_ID = LAST_INSERT_ID();
    END IF;
    RETURN remoteLogName_ID;
END //
DELIMITER ;
