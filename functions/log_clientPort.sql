-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_clientPort`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_clientPort`
  (in_ClientPortID INTEGER)
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE clientPort INT DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'log_clientPort';
  SELECT name
    INTO clientPort
    FROM log_clientport
   WHERE id = in_ClientPortID;
  RETURN clientPort;
END //
DELIMITER ;
