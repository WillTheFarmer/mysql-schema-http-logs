-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `clientPortID_logs`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `clientPortID_logs`
  (in_clientPortID INTEGER,
   in_Log VARCHAR(1))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE logCount INT DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'clientPortID_logs';
  IF in_Log = 'A' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM access_log
     WHERE clientPortID = in_clientPortID;
  ELSEIF in_Log = 'E' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM error_log
     WHERE clientPortID = in_clientPortID;
  END IF;
  RETURN logCount;
END //
DELIMITER ;
