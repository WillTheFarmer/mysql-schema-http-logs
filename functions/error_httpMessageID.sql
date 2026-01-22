-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_httpMessageID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_httpMessageID`
  (in_httpMessage VARCHAR(400))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE httpMessageID INT DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'error_httpMessageID';
  SELECT id
    INTO httpMessageID
    FROM error_log_httpmessage
    WHERE name = in_httpMessage;
  IF httpMessageID IS NULL THEN
      INSERT INTO error_log_httpmessage (name) VALUES (in_httpMessage);
      SET httpMessageID = LAST_INSERT_ID();
  END IF;
  RETURN httpMessageID;
END //
DELIMITER ;
