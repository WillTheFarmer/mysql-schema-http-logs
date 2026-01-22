-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_serverID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_serverID`
  (in_Server VARCHAR(253))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE server_ID INT DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'log_serverID';
  SELECT id
    INTO server_ID
    FROM log_server
   WHERE name = in_Server;
  IF server_ID IS NULL THEN
    INSERT INTO log_server (name) VALUES (in_Server);
    SET server_ID = LAST_INSERT_ID();
  END IF;
  RETURN server_ID;
END //
DELIMITER ;
