-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_clientPortID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_clientPortID`
  (in_ClientPort INTEGER)
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE clientPort_ID INT DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'log_clientPortID';
  SELECT id
    INTO clientPort_ID
    FROM log_clientport
   WHERE name = in_ClientPort;
  IF clientPort_ID IS NULL THEN
    INSERT INTO log_clientport (name) VALUES (in_ClientPort);
    SET clientPort_ID = LAST_INSERT_ID();
  END IF;
  RETURN clientPort_ID;
END //
DELIMITER ;
