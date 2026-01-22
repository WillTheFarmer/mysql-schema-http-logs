-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_logLevelID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_logLevelID`
  (in_loglevel VARCHAR(100))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE logLevelID INT DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'error_logLevelID';
  SELECT id
    INTO logLevelID
    FROM error_log_level
    WHERE name = in_loglevel;
  IF logLevelID IS NULL THEN
      INSERT INTO error_log_level (name) VALUES (in_loglevel);
      SET logLevelID = LAST_INSERT_ID();
  END IF;
  RETURN logLevelID;
END //
DELIMITER ;
