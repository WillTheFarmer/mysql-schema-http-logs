-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_refererID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_refererID`
  (in_Referer VARCHAR(1000))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE referer_ID INT DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'log_refererID';
  SELECT id
    INTO referer_ID
    FROM log_referer
   WHERE name = in_Referer;
  IF referer_ID IS NULL THEN
    INSERT INTO log_referer (name) VALUES (in_Referer);
    SET referer_ID = LAST_INSERT_ID();
  END IF;
  RETURN referer_ID;
END //
DELIMITER ;
