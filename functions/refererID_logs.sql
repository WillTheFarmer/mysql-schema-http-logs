-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `refererID_logs`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `refererID_logs`
  (in_refererID INTEGER,
   in_Log VARCHAR(1))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE logCount INT DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'refererID_logs';
  IF in_Log = 'A' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM access_log
     WHERE refererID = in_refererID;
  ELSEIF in_Log = 'E' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM error_log
     WHERE refererID = in_refererID;
  END IF;
  RETURN logCount;
END //
DELIMITER ;
