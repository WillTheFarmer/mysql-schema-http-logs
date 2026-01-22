-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_httpCode`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_httpCode`
  (in_httpCodeID INTEGER)
  RETURNS VARCHAR(400)
  READS SQL DATA
BEGIN
  DECLARE httpCode VARCHAR(400) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'error_httpCode';
  SELECT name
    INTO httpCode
    FROM error_log_httpcode
    WHERE id = in_httpCodeID;
  RETURN httpCode;
END //
DELIMITER ;
