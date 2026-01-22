-- drop procedure -----------------------------------------------------------
DROP PROCEDURE IF EXISTS `normalize_useragent`;
-- create procedure ---------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` PROCEDURE `normalize_useragent`
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
  DECLARE importProcessID INT DEFAULT NULL;
  DECLARE importLoad_ID INT DEFAULT NULL;
  DECLARE records_processed INT DEFAULT 0;
  DECLARE files_processed INT DEFAULT 1;
  DECLARE processErrors INT DEFAULT 0;
  -- LOAD DATA staging table column variables
  DECLARE v_ua VARCHAR(200) DEFAULT NULL;
  DECLARE v_ua_browser VARCHAR(200) DEFAULT NULL;
  DECLARE v_ua_browser_family VARCHAR(200) DEFAULT NULL;
  DECLARE v_ua_browser_version VARCHAR(200) DEFAULT NULL;
  DECLARE v_ua_os VARCHAR(200) DEFAULT NULL;
  DECLARE v_ua_os_family VARCHAR(200) DEFAULT NULL;
  DECLARE v_ua_os_version VARCHAR(200) DEFAULT NULL;
  DECLARE v_ua_device VARCHAR(200) DEFAULT NULL;
  DECLARE v_ua_device_family VARCHAR(200) DEFAULT NULL;
  DECLARE v_ua_device_brand VARCHAR(200) DEFAULT NULL;
  DECLARE v_ua_device_model VARCHAR(200) DEFAULT NULL;
  DECLARE userAgent_id INT DEFAULT NULL;
  -- Primary IDs for the normalized Attribute tables
  DECLARE ua_id,
          uabrowser_id,
          uabrowserfamily_id,
          uabrowserversion_id,
          uaos_id,
          uaosfamily_id,
          uaosversion_id,
          uadevice_id,
          uadevicefamily_id,
          uadevicebrand_id,
          uadevicemodel_id INT DEFAULT NULL;
  -- declare cursor for userAgent format
  DECLARE userAgent CURSOR FOR
    SELECT ua,
           ua_browser,
           ua_browser_family,
           ua_browser_version,
           ua_os,
           ua_os_family,
           ua_os_version,
           ua_device,
           ua_device_family,
           ua_device_brand,
           ua_device_model,
           id
      FROM access_log_useragent
     WHERE uaid IS NULL;
  -- declare NOT FOUND handler
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE, e4 = SCHEMA_NAME, e5 = CATALOG_NAME;
      CALL errorProcess('normalize_useragent', e1, e2, e3, e4, e5, importLoad_ID, importProcessID);
      SET processErrors = processErrors + 1;
      ROLLBACK;
    END;
  -- check parameters for valid values
  IF CONVERT(in_importLoadID, UNSIGNED) = 0 AND in_importLoadID != 'ALL' THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_importLoadID. Must be convert to number or be ALL';
  END IF;
  IF LENGTH(in_processName) < 8 THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_processName. Must be minimum of 8 characters';
  END IF;
  IF NOT CONVERT(in_importLoadID, UNSIGNED) = 0 THEN
    SELECT importloadid 
      INTO importLoad_ID
      FROM import_process
     WHERE id = in_importLoadID;
  END IF;
  SET importProcessID = importServerProcessID('normalize_useragent', in_processName, importLoad_ID);
  OPEN userAgent;
  START TRANSACTION;
  process_normalize: LOOP
    FETCH userAgent
     INTO v_ua,
          v_ua_browser,
          v_ua_browser_family,
          v_ua_browser_version,
          v_ua_os,
          v_ua_os_family,
          v_ua_os_version,
          v_ua_device,
          v_ua_device_family,
          v_ua_device_brand,
          v_ua_device_model,
          userAgent_id;
    IF done = true THEN
      LEAVE process_normalize;
    END IF;
    SET records_processed = records_processed + 1;
    SET ua_id = null,
        uabrowser_id = null,
        uabrowserfamily_id = null,
        uabrowserversion_id = null,
        uaos_id = null,
        uaosfamily_id = null,
        uaosversion_id = null,
        uadevice_id = null,
        uadevicefamily_id = null,
        uadevicebrand_id = null,
        uadevicemodel_id = null;
        -- normalize import staging table
    IF v_ua IS NOT NULL THEN
      SET ua_Id = access_uaID(v_ua);
    END IF;
    IF v_ua_browser IS NOT NULL THEN
      SET uabrowser_id = access_uaBrowserID(v_ua_browser);
    END IF;
    IF v_ua_browser_family IS NOT NULL THEN
      SET uabrowserfamily_id = access_uaBrowserFamilyID(v_ua_browser_family);
    END IF;
    IF v_ua_browser_version IS NOT NULL THEN
      SET uabrowserversion_id = access_uaBrowserVersionID(v_ua_browser_version);
    END IF;
    IF v_ua_os IS NOT NULL THEN
      SET uaos_id = access_uaOsID(v_ua_os);
    END IF;
    IF v_ua_os_family IS NOT NULL THEN
      SET uaosfamily_id = access_uaOsFamilyID(v_ua_os_family);
    END IF;
    IF v_ua_os_version IS NOT NULL THEN
      SET uaosversion_id = access_uaOsVersionID(v_ua_os_version);
    END IF;
    IF v_ua_device IS NOT NULL THEN
      SET uadevice_id = access_uaDeviceID(v_ua_device);
    END IF;
    IF v_ua_device_family IS NOT NULL THEN
      SET uadevicefamily_id = access_uaDeviceFamilyID(v_ua_device_family);
    END IF;
    IF v_ua_device_brand IS NOT NULL THEN
      SET uadevicebrand_id = access_uaDeviceBrandID(v_ua_device_brand);
    END IF;
    IF v_ua_device_model IS NOT NULL THEN
      SET uadevicemodel_id = access_uaDeviceModelID(v_ua_device_model);
    END IF;
    UPDATE access_log_useragent
       SET uaid = ua_id,
           uabrowserid = uabrowser_id,
           uabrowserfamilyid = uabrowserfamily_id,
           uabrowserversionid = uabrowserversion_id,
           uaosid = uaos_id,
           uaosfamilyid = uaosfamily_id,
           uaosversionid = uaosversion_id,
           uadeviceid = uadevice_id,
           uadevicefamilyid = uadevicefamily_id,
           uadevicebrandid = uadevicebrand_id,
           uadevicemodelid = uadevicemodel_id
     WHERE id = userAgent_id;
  END LOOP;
  -- to remove SQL calculating files_processed when records_processed = 0. Set=1 by default.
  IF records_processed=0 THEN
    SET files_processed = 0;
  END IF;
  -- update import process table
	UPDATE import_process
     SET recordsprocessed = records_processed,
         filesprocessed = files_processed,
         completed = now(),
         errorCount = processErrors,
         processSeconds = TIME_TO_SEC(TIMEDIFF(now(), started))
   WHERE id = importProcessID;
	COMMIT;
    -- close the cursor
	CLOSE userAgent;
END//
DELIMITER ;
