-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_remoteUserID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_remoteUserID`
    (in_RemoteUser VARCHAR(150))
    RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE remoteUser_ID INT DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_remoteUserID';
    SELECT id
      INTO remoteUser_ID
      FROM access_log_remoteuser
     WHERE name = in_RemoteUser;
    IF remoteUser_ID IS NULL THEN
        INSERT INTO access_log_remoteuser (name) VALUES (in_RemoteUser);
        SET remoteUser_ID = LAST_INSERT_ID();
    END IF;
    RETURN remoteUser_ID;
END //
DELIMITER ;
