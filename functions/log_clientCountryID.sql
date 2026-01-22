-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_clientCountryID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_clientCountryID`
  (in_country VARCHAR(150),
   in_country_code VARCHAR(20)
  )
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE clientCountry_ID INT DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'log_clientCountryID';
  SELECT id
    INTO clientCountry_ID
    FROM log_client_country
   WHERE country = in_country
     AND country_code = in_country_code;
  IF clientCountry_ID IS NULL THEN
    INSERT INTO log_client_country (country, country_code) VALUES (in_country, in_country_code);
    SET clientCountry_ID = LAST_INSERT_ID();
  END IF;
  RETURN clientCountry_ID;
END //
DELIMITER ;
