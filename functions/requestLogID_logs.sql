-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `requestLogID_logs`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `requestLogID_logs`
  (in_requestLogID INTEGER,
   in_Log VARCHAR(1))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE logCount INT DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'requestLogID_logs';
  IF in_Log = 'A' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM access_log
     WHERE requestLogID = in_requestLogID;
  ELSEIF in_Log = 'E' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM error_log
     WHERE requestLogID = in_requestLogID;
  END IF;
  RETURN logCount;
END //
DELIMITER ;
