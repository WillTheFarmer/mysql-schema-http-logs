-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_httpMessage`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_httpMessage`
  (in_httpMessageID INTEGER)
  RETURNS VARCHAR(400)
  READS SQL DATA
BEGIN
  DECLARE httpMessage VARCHAR(400) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'error_httpMessage';
  SELECT name
    INTO httpMessage
    FROM error_log_httpmessage
    WHERE id = in_httpMessageID;
  RETURN httpMessage;
END //
DELIMITER ;
