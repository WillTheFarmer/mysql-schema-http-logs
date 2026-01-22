-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_clientCityID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_clientCityID`
  (in_city VARCHAR(250))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE clientCity_ID INT DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'log_clientCityID';
  SELECT id
    INTO clientCity_ID
    FROM log_client_city
   WHERE name = in_city;
  IF clientCity_ID IS NULL THEN
    INSERT INTO log_client_city (name) VALUES (in_city);
    SET clientCity_ID = LAST_INSERT_ID();
  END IF;
  RETURN clientCity_ID;
END //
DELIMITER ;
