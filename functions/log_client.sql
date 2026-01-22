-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_client`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_client`
  (in_clientID INTEGER)
  RETURNS VARCHAR(253)
  READS SQL DATA
BEGIN
  DECLARE client VARCHAR(253) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'log_client';
  SELECT name
    INTO client
    FROM log_client
   WHERE id = in_clientID;
  RETURN client;
END //
DELIMITER ;
