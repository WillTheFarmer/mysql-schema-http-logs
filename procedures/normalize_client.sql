-- drop procedure -----------------------------------------------------------
DROP PROCEDURE IF EXISTS `normalize_client`;
-- create procedure ---------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` PROCEDURE `normalize_client`
(
  IN in_processName VARCHAR(100),
  IN in_importLoadID VARCHAR(20)
)
BEGIN
  -- standard variables for processes
  DECLARE e1 INT UNSIGNED;
  DECLARE e2, e3 VARCHAR(128);
  DECLARE e4, e5 VARCHAR(64);
  DECLARE done BOOL DEFAULT false;
  DECLARE importProcessID INT UNSIGNED DEFAULT NULL;
  DECLARE importLoad_ID INT UNSIGNED DEFAULT NULL;
  DECLARE records_processed INT DEFAULT 0;
  DECLARE files_processed INT DEFAULT 1;
  DECLARE processErrors INT DEFAULT 0;
  -- LOAD DATA staging table column variables
  DECLARE v_country_code VARCHAR(20) DEFAULT NULL;
  DECLARE v_country VARCHAR(150) DEFAULT NULL;
  DECLARE v_subdivision VARCHAR(250) DEFAULT NULL;
  DECLARE v_city VARCHAR(250) DEFAULT NULL;
  DECLARE v_latitude DECIMAL(10,8) DEFAULT NULL;
  DECLARE v_longitude DECIMAL(11,8) DEFAULT NULL;
  DECLARE v_organization VARCHAR(500) DEFAULT NULL;
  DECLARE v_network VARCHAR(100) DEFAULT NULL;
  DECLARE recid INT UNSIGNED DEFAULT NULL;
  -- Primary IDs for the normalized Attribute tables
  DECLARE country_id,
          subdivision_id,
          city_id,
          coordinate_id,
          organization_id,
          network_id INT UNSIGNED DEFAULT NULL;
  -- declare cursor for log_client format
  DECLARE logClient CURSOR FOR
      SELECT country_code,
             country,
             subdivision,
             city,
             latitude,
             longitude,
             organization,
             network,
             id
        FROM log_client
       WHERE countryid IS NULL;
  -- declare NOT FOUND handler
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE, e4 = SCHEMA_NAME, e5 = CATALOG_NAME;
      CALL messageProcess('normalize_client', e1, e2, e3, e4, e5, importLoad_ID, importProcessID);
      SET processErrors = processErrors + 1;
      ROLLBACK;
    END;
  -- check parameters for valid values
  IF CONVERT(in_importLoadID, UNSIGNED) = 0 AND in_importLoadID != 'ALL' THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_importLoadID. Must be convert to number or be ALL';
  END IF;
  IF LENGTH(in_processName) < 6 THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_processName. Must be minimum of 6 characters';
  END IF;
  IF NOT CONVERT(in_importLoadID, UNSIGNED) = 0 THEN
    SELECT importloadid 
      INTO importLoad_ID
      FROM import_process
     WHERE id = in_importLoadID;
  END IF;
  SET importProcessID = importServerProcessID('normalize_client', in_processName, importLoad_ID);
  OPEN logClient;
  START TRANSACTION;
  process_normalize: LOOP
    FETCH logClient
     INTO v_country_code,
          v_country,
          v_subdivision,
          v_city,
          v_latitude,
          v_longitude,
          v_organization,
          v_network,
          recid;
    IF done = true THEN
      LEAVE process_normalize;
    END IF;
    SET records_processed = records_processed + 1;
    SET country_id = null,
        subdivision_id = null,
        city_id = null,
        coordinate_id = null,
        organization_id = null,
        network_id = null;
    -- normalize import staging table
    IF v_country IS NOT NULL AND LENGTH(v_country) > 0 THEN
      SET country_id = log_clientCountryID(v_country, v_country_code);
    END IF;
    IF v_subdivision IS NOT NULL AND LENGTH(v_subdivision) > 0 THEN
      SET subdivision_id = log_clientSubdivisionID(v_subdivision);
    END IF;
    IF v_city IS NOT NULL AND LENGTH(v_city) > 0 THEN
      SET city_id = log_clientCityID(v_city);
    END IF;
    IF v_latitude IS NOT NULL AND LENGTH(v_latitude) > 0 THEN
      SET coordinate_id = log_clientCoordinateID(v_latitude, v_longitude);
    END IF;
    IF v_organization IS NOT NULL AND LENGTH(v_organization) > 0 THEN
      SET organization_id = log_clientOrganizationID(v_organization);
    END IF;
    IF v_network IS NOT NULL AND LENGTH(v_network) > 0 THEN
      SET network_id = log_clientNetworkID(v_network);
    END IF;
    UPDATE log_client
       SET countryid = country_id,
           subdivisionid = subdivision_id,
           cityid = city_id,
           coordinateid = coordinate_id,
           organizationid = organization_id,
           networkid = network_id
     WHERE id = recid;
  END LOOP;
  -- to remove SQL calculating files_processed when records_processed = 0. Set=1 by default.
  IF records_processed=0 THEN
    SET files_processed = 0;
  END IF;
  -- update import process table
  UPDATE import_process
     SET records_processed = records_processed,
         files_processed = files_processed,
         completed = now(),
         error_count = processErrors,
         process_seconds = TIME_TO_SEC(TIMEDIFF(now(), started))
   WHERE id = importProcessID;
  COMMIT;
  -- close the cursor
  CLOSE logClient;
END//
DELIMITER ;
