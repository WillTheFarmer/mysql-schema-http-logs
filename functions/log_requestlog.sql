-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_requestLog`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_requestLog`
  (in_RequestLogID INTEGER)
  RETURNS VARCHAR(50)
  READS SQL DATA
BEGIN
  DECLARE requestLog VARCHAR(50) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'log_requestLog';
  SELECT name
    INTO requestLog
    FROM log_requestlogid
   WHERE name = in_RequestLogID;
  RETURN requestLog;
END //
DELIMITER ;
