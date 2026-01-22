-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_moduleID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_moduleID`
  (in_module VARCHAR(100))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE moduleID INT DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'error_moduleID';
  SELECT id
    INTO moduleID
    FROM error_log_module
    WHERE name = in_module;
  IF moduleID IS NULL THEN
      INSERT INTO error_log_module (name) VALUES (in_module);
      SET moduleID = LAST_INSERT_ID();
  END IF;
  RETURN moduleID;
END //
DELIMITER ;
