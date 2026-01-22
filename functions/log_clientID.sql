-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_clientID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_clientID`
  (in_client VARCHAR(253))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE client_ID INT DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'log_clientID';
  SELECT id
    INTO client_ID
    FROM log_client
   WHERE name = in_client;
  IF client_ID IS NULL THEN
    INSERT INTO log_client (name) VALUES (in_client);
    SET client_ID = LAST_INSERT_ID();
  END IF;
  RETURN client_ID;
END //
DELIMITER ;
