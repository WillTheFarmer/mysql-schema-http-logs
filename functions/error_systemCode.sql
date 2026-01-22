-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_systemCode`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_systemCode`
  (in_systemCodeID INTEGER)
  RETURNS VARCHAR(400)
  READS SQL DATA
BEGIN
  DECLARE systemCode VARCHAR(400) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'error_systemCode';
  SELECT name
    INTO systemCode
    FROM error_log_systemcode
    WHERE id = in_systemCodeID;
  RETURN systemCode;
END //
DELIMITER ;
