-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `serverPortID_logs`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `serverPortID_logs`
  (in_serverPortID INTEGER,
   in_Log VARCHAR(1))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE logCount INT DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'serverPortID_logs';
  IF in_Log = 'A' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM access_log
     WHERE serverPortID = in_serverPortID;
  ELSEIF in_Log = 'E' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM error_log
     WHERE serverPortID = in_serverPortID;
  END IF;
  RETURN logCount;
END //
DELIMITER ;
