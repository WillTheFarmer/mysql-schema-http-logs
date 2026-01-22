-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_systemMessageID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_systemMessageID`
  (in_systemMessage VARCHAR(400))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE systemMessageID INT DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'error_systemMessageID';
  SELECT id
    INTO systemMessageID
    FROM error_log_systemmessage
    WHERE name = in_systemMessage;
  IF systemMessageID IS NULL THEN
      INSERT INTO error_log_systemmessage (name) VALUES (in_systemMessage);
      SET systemMessageID = LAST_INSERT_ID();
  END IF;
  RETURN systemMessageID;
END //
DELIMITER ;
