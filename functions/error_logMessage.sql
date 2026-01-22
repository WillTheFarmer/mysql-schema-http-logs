-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_logMessage`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_logMessage`
  (in_messageID INTEGER)
  RETURNS VARCHAR(500)
  READS SQL DATA
BEGIN
  DECLARE logMessage VARCHAR(500) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'error_logMessage';
  SELECT name
    INTO logMessage
    FROM error_log_message
    WHERE id = in_messageID;
  RETURN logMessage;
END //
DELIMITER ;
