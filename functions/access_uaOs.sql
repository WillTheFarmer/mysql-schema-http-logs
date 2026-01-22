-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `access_uaOs`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `access_uaOs`
    (in_ua_osID INTEGER)
    RETURNS VARCHAR(300)
    READS SQL DATA
BEGIN
    DECLARE ua_os VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'access_uaOs';
    SELECT name
      INTO ua_os
      FROM access_log_ua_os
     WHERE id = in_ua_osID;
    RETURN ua_os;
END //
DELIMITER ;
