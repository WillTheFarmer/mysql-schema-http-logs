-- drop procedure -----------------------------------------------------------
DROP PROCEDURE IF EXISTS `parse_access_apache_csv2mysql`;
-- create procedure ---------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` PROCEDURE `parse_access_apache_csv2mysql`
(
  IN in_processName VARCHAR(100),
  IN in_importLoadID VARCHAR(20)
)
BEGIN
  -- module_name_process = module_name column in import_process - to id procedure is being run
  -- in_processName = process_name column in import_process - to id procedure OPTION is being run
  DECLARE module_name_process VARCHAR(255) DEFAULT 'parse_access_apache_csv2mysql';
  -- standard variables for processes
  DECLARE e1 INT UNSIGNED;
  DECLARE e2, e3 VARCHAR(128);
  DECLARE e4, e5 VARCHAR(64);
  DECLARE done BOOL DEFAULT false;
  DECLARE importProcessID INT UNSIGNED DEFAULT NULL;
  DECLARE importLoad_ID INT UNSIGNED DEFAULT NULL;
  DECLARE importRecordID INT UNSIGNED DEFAULT NULL;
  DECLARE importFileCheck_ID INT UNSIGNED DEFAULT NULL;
  DECLARE importFile_common_ID INT UNSIGNED DEFAULT NULL;
  DECLARE records_processed INT DEFAULT 0;
  DECLARE files_processed INT DEFAULT 0;
  DECLARE loads_processed INT DEFAULT 1;
  DECLARE processErrors INT DEFAULT 0;
  -- declare cursor - All importloadIDs not processed
  DECLARE csv2mysqlStatus CURSOR FOR
      SELECT l.id
        FROM load_access_apache_csv2mysql l
  INNER JOIN import_file f
          ON l.importfileid = f.id
  INNER JOIN import_load il
          ON f.importloadid = il.id
       WHERE l.process_status = 0
         AND il.completed IS NOT NULL;
  -- declare cursor - file count - All importloadIDs not processed
  DECLARE csv2mysqlStatusFile CURSOR FOR
      SELECT DISTINCT(l.importfileid)
        FROM load_access_apache_csv2mysql l
  INNER JOIN import_file f
          ON l.importfileid = f.id
  INNER JOIN import_load il
          ON f.importloadid = il.id
       WHERE l.process_status = 0
         AND il.completed IS NOT NULL;
-- declare cursor - single importLoadID
  DECLARE csv2mysqlLoadID CURSOR FOR
      SELECT l.id
        FROM load_access_apache_csv2mysql l
  INNER JOIN import_file f
          ON l.importfileid = f.id
       WHERE l.process_status = 0
         AND f.importloadid = importLoad_ID;
  -- declare cursor - file count - single importLoadID
  DECLARE csv2mysqlLoadIDFile CURSOR FOR
      SELECT DISTINCT(l.importfileid)
        FROM load_access_apache_csv2mysql l
  INNER JOIN import_file f
          ON l.importfileid = f.id
       WHERE l.process_status = 0
         AND f.importloadid = importLoad_ID;
  -- declare NOT FOUND handler
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE, e4 = SCHEMA_NAME, e5 = CATALOG_NAME;
      CALL messageProcess('parse_access_apache', e1, e2, e3, e4, e5, importLoad_ID, importProcessID);
      SET processErrors = processErrors + 1;
      ROLLBACK;
    END;
  -- check parameters for valid values
  IF CONVERT(in_importLoadID, UNSIGNED) = 0 AND in_importLoadID != 'ALL' THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_importLoadID. Must be convert to number or be ALL';
  END IF;
  IF FIND_IN_SET(in_processName, "python,mysql") = 0 THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_processName. Must be python OR mysql';
  END IF;
  IF NOT CONVERT(in_importLoadID, UNSIGNED) = 0 THEN
    SELECT importloadid 
      INTO importLoad_ID
      FROM import_process
     WHERE id = in_importLoadID;
  END IF;
  SET importProcessID = importServerProcessID( module_name_process, in_processName, importLoad_ID);
  IF importLoad_ID IS NULL THEN
        SELECT COUNT(DISTINCT(f.importloadid))
          INTO loads_processed
          FROM load_access_apache_csv2mysql l
    INNER JOIN import_file f
            ON l.importfileid = f.id
    INNER JOIN import_load il
            ON f.importloadid = il.id
         WHERE l.process_status = 0
           AND il.completed IS NOT NULL;
  END IF;	
  START TRANSACTION;
  SET done = false;
  -- process import_file TABLE first
  IF importLoad_ID IS NULL THEN
    OPEN csv2mysqlStatusFile;
  ELSE
    OPEN csv2mysqlLoadIDFile;
  END IF;
  process_parse_file: LOOP
  	IF importLoad_ID IS NULL THEN
      FETCH csv2mysqlStatusFile INTO importFileCheck_ID;
	  ELSE
      FETCH csv2mysqlLoadIDFile INTO importFileCheck_ID;
    END IF;
    IF done = true THEN
      LEAVE process_parse_file;
    END IF;
    IF importFileCheck(importFileCheck_ID, importProcessID, 'parse') = 0 THEN
      ROLLBACK;
      LEAVE process_parse_file;
    END IF;
    SET files_processed = files_processed + 1;
  END LOOP process_parse_file;
  IF importLoad_ID IS NULL THEN
    CLOSE csv2mysqlStatusFile;
  ELSE
    CLOSE csv2mysqlLoadIDFile;
  END IF;
  -- process records
  SET done = false;
  IF importLoad_ID IS NULL THEN
    OPEN csv2mysqlStatus;
  ELSE
    OPEN csv2mysqlLoadID;
  END IF;
  process_parse: LOOP
    IF importLoad_ID IS NULL THEN
      FETCH csv2mysqlStatus INTO importRecordID;
    ELSE
      FETCH csv2mysqlLoadID INTO importRecordID;
    END IF;
    IF done = true THEN
      LEAVE process_parse;
    END IF;
    SET records_processed = records_processed + 1;
    -- IF in_processName = 'csv2mysql' THEN
    -- by default, no parsing required for csv2mysql format
    UPDATE load_access_apache_csv2mysql SET process_status=1 WHERE id=importRecordID;
  END LOOP process_parse;
  -- to remove SQL calculating loads_processed when importLoad_ID is passed. Set=1 by default.
  IF importLoad_ID IS NOT NULL AND records_processed=0 THEN
    SET loads_processed = 0;
  END IF;
  -- update import process table
  UPDATE import_process
     SET records_processed = records_processed,
         files_processed = files_processed,
         loads_processed = loads_processed,
         completed = now(),
         error_count = processErrors,
         module_name = module_name_process,
         process_name = in_processName,
         process_seconds = TIME_TO_SEC(TIMEDIFF(now(), started))
   WHERE id = importProcessID;
  COMMIT;
  IF importLoad_ID IS NULL THEN
    CLOSE csv2mysqlStatus;
  ELSE
    CLOSE csv2mysqlLoadID;
  END IF;
END//
DELIMITER ;
