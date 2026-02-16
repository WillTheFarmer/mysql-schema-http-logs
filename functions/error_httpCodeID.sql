-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_httpCodeID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_httpCodeID`
  (in_httpCode VARCHAR(400))
  RETURNS INT
  READS SQL DATA
BEGIN
  DECLARE httpCodeID INT DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'error_httpCodeID';
  SELECT id
    INTO httpCodeID
    FROM error_log_httpcode
    WHERE name = in_httpCode;
  IF httpCodeID IS NULL THEN
      INSERT INTO error_log_httpcode (name) VALUES (in_httpCode);
      SET httpCodeID = LAST_INSERT_ID();
  END IF;
  RETURN httpCodeID;
END //
DELIMITER ;
