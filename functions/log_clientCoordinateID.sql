-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_clientCoordinateID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_clientCoordinateID`
  (in_latitude DECIMAL(10,8),
   in_longitude DECIMAL(11,8)
  )
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE clientCoordinate_ID INT DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'log_clientCoordinateID';
  SELECT id
    INTO clientCoordinate_ID
    FROM log_client_coordinate
   WHERE latitude = in_latitude
     AND longitude = in_longitude;
  IF clientCoordinate_ID IS NULL THEN
    INSERT INTO log_client_coordinate (latitude, longitude) VALUES (in_latitude, in_longitude);
    SET clientCoordinate_ID = LAST_INSERT_ID();
  END IF;
  RETURN clientCoordinate_ID;
END //
DELIMITER ;
