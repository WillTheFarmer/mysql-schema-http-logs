-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_referer`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_referer`
  (in_RefererID INTEGER)
  RETURNS VARCHAR(1000)
  READS SQL DATA
BEGIN
  DECLARE referer VARCHAR(1000) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'log_referer';
  SELECT name
    INTO referer
    FROM log_referer
   WHERE id = in_RefererID;
  RETURN referer;
END //
DELIMITER ;
