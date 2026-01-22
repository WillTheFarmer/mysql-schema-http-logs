-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_systemMessage`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_systemMessage`
  (in_systemMessageID INTEGER)
  RETURNS VARCHAR(400)
  READS SQL DATA
BEGIN
  DECLARE systemMessage VARCHAR(400) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'error_systemMessage';
  SELECT name
    INTO systemMessage
    FROM error_log_systemmessage
    WHERE id = in_systemMessageID;
  RETURN systemMessage;
END //
DELIMITER ;
