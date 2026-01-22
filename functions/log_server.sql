-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_server`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_server`
  (in_ServerID INTEGER)
  RETURNS VARCHAR(253)
  READS SQL DATA
BEGIN
  DECLARE server VARCHAR(253) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'log_server';
  SELECT name
    INTO server
    FROM log_server
   WHERE id = in_ServerID;
  RETURN server;
END //
DELIMITER ;
