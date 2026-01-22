-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `log_clientOrganizationID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `log_clientOrganizationID`
  (in_organization VARCHAR(500))
  RETURNS INTEGER
  READS SQL DATA
BEGIN
  DECLARE clientOrganization_ID INT DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'log_clientOrganizationID';
  SELECT id
    INTO clientOrganization_ID
    FROM log_client_organization
   WHERE name = in_organization;
  IF clientOrganization_ID IS NULL THEN
    INSERT INTO log_client_organization (name) VALUES (in_organization);
    SET clientOrganization_ID = LAST_INSERT_ID();
  END IF;
  RETURN clientOrganization_ID;
END //
DELIMITER ;
