-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_systemCodeID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_systemCodeID`
  (in_systemCode VARCHAR(400))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE systemCodeID INT DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'error_systemCodeID';
  SELECT id
    INTO systemCodeID
    FROM error_log_systemcode
    WHERE name = in_systemCode;
  IF systemCodeID IS NULL THEN
      INSERT INTO error_log_systemcode (name) VALUES (in_systemCode);
      SET systemCodeID = LAST_INSERT_ID();
  END IF;
  RETURN systemCodeID;
END //
DELIMITER ;
