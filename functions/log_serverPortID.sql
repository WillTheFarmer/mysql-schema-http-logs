-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_serverPortID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_serverPortID`
  (in_ServerPort INTEGER)
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE serverPort_ID INT DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'log_serverPortID';
  SELECT id
    INTO serverPort_ID
    FROM log_serverport
   WHERE name = in_ServerPort;
  IF serverPort_ID IS NULL THEN
    INSERT INTO log_serverport (name) VALUES (in_ServerPort);
    SET serverPort_ID = LAST_INSERT_ID();
  END IF;
  RETURN serverPort_ID;
END //
DELIMITER ;
