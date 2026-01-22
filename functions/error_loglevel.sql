-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_logLevel`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_logLevel`
  (in_loglevelID INTEGER)
  RETURNS VARCHAR(100)
  READS SQL DATA
BEGIN
  DECLARE logLevel VARCHAR(100) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'error_logLevel';
  SELECT name
    INTO logLevel
    FROM error_log_level
    WHERE id = in_loglevelID;
  RETURN logLevel;
END //
DELIMITER ;
