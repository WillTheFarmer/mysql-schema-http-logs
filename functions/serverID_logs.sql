-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `serverID_logs`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `serverID_logs`
  (in_ServerID INTEGER,
   in_Log VARCHAR(1))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE logCount INT DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'serverID_logs';
  IF in_Log = 'A' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM access_log
     WHERE serverID = in_ServerID;
  ELSEIF in_Log = 'E' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM error_log
     WHERE serverID = in_ServerID;
  END IF;
  RETURN logCount;
END //
DELIMITER ;
