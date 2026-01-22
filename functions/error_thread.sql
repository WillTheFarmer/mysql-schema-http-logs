-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_thread`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_thread`
  (in_threadidID INTEGER)
  RETURNS VARCHAR(100)
  READS SQL DATA
BEGIN
  DECLARE thread VARCHAR(100) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'error_thread';
  SELECT name
    INTO thread
    FROM error_log_threadid
    WHERE id = in_threadidID;
  RETURN thread;
END //
DELIMITER ;
