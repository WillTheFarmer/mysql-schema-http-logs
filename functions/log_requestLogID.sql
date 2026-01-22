-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_requestLogID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_requestLogID`
  (in_RequestLog VARCHAR(50))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE requestLog_ID INT DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'log_requestLogID';
  SELECT id
    INTO requestLog_ID
    FROM log_requestlogid
   WHERE name = in_RequestLog;
  IF requestLog_ID IS NULL THEN
    INSERT INTO log_requestlogid (name) VALUES (in_RequestLog);
    SET requestLog_ID = LAST_INSERT_ID();
  END IF;
  RETURN requestLog_ID;
END //
DELIMITER ;
