-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_clientNetworkID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_clientNetworkID`
  (in_network VARCHAR(100))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE clientNetwork_ID INT DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'log_clientNetworkID';
  SELECT id
    INTO clientNetwork_ID
    FROM log_client_network
   WHERE name = in_network;
  IF clientNetwork_ID IS NULL THEN
    INSERT INTO log_client_network (name) VALUES (in_network);
    SET clientNetwork_ID = LAST_INSERT_ID();
  END IF;
  RETURN clientNetwork_ID;
END //
DELIMITER ;
