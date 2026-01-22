DROP FUNCTION IF EXISTS `access_remoteUser`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_remoteUser`
    (in_RemoteUserID INTEGER)
    RETURNS VARCHAR(150)
    READS SQL DATA
BEGIN
    DECLARE remoteUser VARCHAR(150) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_remoteUser';
    SELECT name
      INTO remoteUser
      FROM access_log_remoteuser
     WHERE id = in_RemoteUserID;
    RETURN remoteUser;
END //
DELIMITER ;
