-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_process`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_process`
  (in_processidID INTEGER)
  RETURNS VARCHAR(100)
  READS SQL DATA
BEGIN
  DECLARE process  VARCHAR(100) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'error_process';
  SELECT name
    INTO process
    FROM error_log_processid
    WHERE id = in_processidID;
  RETURN process;
END //
DELIMITER ;
