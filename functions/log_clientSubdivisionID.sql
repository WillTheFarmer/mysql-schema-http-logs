-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_clientSubdivisionID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_clientSubdivisionID`
  (in_subdivision VARCHAR(250))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE clientSubdivision_ID INT DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'log_clientSubdivisionID';
  SELECT id
    INTO clientSubdivision_ID
    FROM log_client_subdivision
   WHERE name = in_subdivision;
  IF clientSubdivision_ID IS NULL THEN
    INSERT INTO log_client_subdivision (name) VALUES (in_subdivision);
    SET clientSubdivision_ID = LAST_INSERT_ID();
  END IF;
  RETURN clientSubdivision_ID;
END //
DELIMITER ;
