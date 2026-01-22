-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `error_threadID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `error_threadID`
  (in_threadid VARCHAR(100))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE thread_ID INT DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'error_threadID';
  SELECT id
    INTO thread_ID
    FROM error_log_threadid
    WHERE name = in_threadid;
  IF thread_ID IS NULL THEN
      INSERT INTO error_log_threadid (name) VALUES (in_threadid);
      SET thread_ID = LAST_INSERT_ID();
  END IF;
  RETURN thread_ID;
END //
DELIMITER ;
