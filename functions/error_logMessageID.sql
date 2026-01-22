-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_logMessageID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_logMessageID`
  (in_message VARCHAR(500))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE messageID INT DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'error_logMessageID';
  SELECT id
    INTO messageID
    FROM error_log_message
    WHERE name = in_message;
  IF messageID IS NULL THEN
      INSERT INTO error_log_message (name) VALUES (in_message);
      SET messageID = LAST_INSERT_ID();
  END IF;
  RETURN messageID;
END //
DELIMITER ;
