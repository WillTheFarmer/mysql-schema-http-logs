-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_module`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_module`
  (in_module INTEGER)
  RETURNS VARCHAR(100)
  READS SQL DATA
BEGIN
  DECLARE module VARCHAR(100) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'error_module';
  SELECT name
    INTO module
    FROM error_log_module
    WHERE id = in_moduleID;
  RETURN module;
END //
DELIMITER ;
