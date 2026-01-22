-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_serverPort`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_serverPort`
  (in_ServerPortID INTEGER)
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE serverPort INT DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'log_serverPort';
  SELECT name
    INTO serverPort
    FROM log_serverport
   WHERE id = in_ServerPortID;
  RETURN serverPort;
END //
DELIMITER ;
