-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_remoteLogName`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_remoteLogName`
    (in_RemoteLogNameID INTEGER)
    RETURNS VARCHAR(150)
    READS SQL DATA
BEGIN
    DECLARE remoteLogName VARCHAR(150) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_remoteLogName';
    SELECT name
      INTO remoteLogName
      FROM access_log_remotelogname
     WHERE id = in_RemoteLogNameID;
    RETURN remoteLogName;
END //
DELIMITER ;
