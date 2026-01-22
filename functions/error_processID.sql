-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_processID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_processID`
  (in_processid VARCHAR(100))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE process_ID INT DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'error_processID';
  SELECT id
    INTO process_ID
    FROM error_log_processid
    WHERE name = in_processid;
  IF process_ID IS NULL THEN
      INSERT INTO error_log_processid (name) VALUES (in_processid);
      SET process_ID = LAST_INSERT_ID();
  END IF;
  RETURN process_ID;
END //
DELIMITER ;
