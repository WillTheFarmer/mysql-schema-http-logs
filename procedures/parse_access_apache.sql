-- drop procedure -----------------------------------------------------------
DROP PROCEDURE IF EXISTS `parse_access_apache`;
-- create procedure ---------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` PROCEDURE `parse_access_apache`
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
  DECLARE importRecordID INT DEFAULT NULL;
  DECLARE importFileCheck_ID INT DEFAULT NULL;
  DECLARE importFile_common_ID INT DEFAULT NULL;
  DECLARE records_processed INT DEFAULT 0;
  DECLARE files_processed INT DEFAULT 0;
  DECLARE loads_processed INT DEFAULT 1;
  DECLARE processErrors INT DEFAULT 0;
  -- declare cursor for csv2mysql format - All importloadIDs not processed
  DECLARE csv2mysqlStatus CURSOR FOR
      SELECT l.id
        FROM load_access_csv l
  INNER JOIN import_file f
          ON l.importfileid = f.id
  INNER JOIN import_load il
          ON f.importloadid = il.id
       WHERE l.process_status = 0
         AND il.completed IS NOT NULL;
  -- declare cursor for csv2mysql format - All importloadIDs not processed
  DECLARE csv2mysqlStatusFile CURSOR FOR
      SELECT DISTINCT(l.importfileid)
        FROM load_access_csv l
  INNER JOIN import_file f
          ON l.importfileid = f.id
  INNER JOIN import_load il
          ON f.importloadid = il.id
       WHERE l.process_status = 0
         AND il.completed IS NOT NULL;
  -- declare cursor for csv2mysql format - single importLoadID
  DECLARE csv2mysqlLoadID CURSOR FOR
      SELECT l.id
        FROM load_access_csv l
  INNER JOIN import_file f
          ON l.importfileid = f.id
       WHERE l.process_status = 0
         AND f.importloadid = importLoad_ID;
  -- declare cursor for csv2mysql format - single importLoadID
  DECLARE csv2mysqlLoadIDFile CURSOR FOR
      SELECT DISTINCT(l.importfileid)
        FROM load_access_csv l
  INNER JOIN import_file f
          ON l.importfileid = f.id
       WHERE l.process_status = 0
         AND f.importloadid = importLoad_ID;
  -- declare cursor for combined format - All importloadIDs not processed
  DECLARE vhostStatus CURSOR FOR
      SELECT l.id
        FROM load_access_vhost l
  INNER JOIN import_file f
          ON l.importfileid = f.id
  INNER JOIN import_load il
          ON f.importloadid = il.id
       WHERE l.process_status = 0
         AND il.completed IS NOT NULL;
  -- declare cursor for combined format - All importloadIDs not processed
  DECLARE vhostStatusFile CURSOR FOR
      SELECT DISTINCT(l.importfileid)
        FROM load_access_vhost l
  INNER JOIN import_file f
          ON l.importfileid = f.id
  INNER JOIN import_load il
          ON f.importloadid = il.id
       WHERE l.process_status = 0
         AND il.completed IS NOT NULL;
  -- declare cursor for combined format - single importLoadID
  DECLARE vhostLoadID CURSOR FOR
      SELECT l.id
        FROM load_access_vhost l
  INNER JOIN import_file f
          ON l.importfileid = f.id
       WHERE l.process_status = 0
         AND f.importloadid = importLoad_ID;
  -- declare cursor for combined format - single importLoadID
  DECLARE vhostLoadIDFile CURSOR FOR
      SELECT DISTINCT(l.importfileid)
        FROM load_access_vhost l
  INNER JOIN import_file f
          ON l.importfileid = f.id
       WHERE l.process_status = 0
         AND f.importloadid = importLoad_ID;
  -- declare cursor for combined format - All importloadIDs not processed
  DECLARE combinedStatus CURSOR FOR
      SELECT l.id
        FROM load_access_combined l
  INNER JOIN import_file f
          ON l.importfileid = f.id
  INNER JOIN import_load il
          ON f.importloadid = il.id
       WHERE l.process_status = 0
         AND il.completed IS NOT NULL;
  -- declare cursor for combined format - All importloadIDs not processed
  DECLARE combinedStatusFile CURSOR FOR
      SELECT DISTINCT(l.importfileid)
        FROM load_access_combined l
  INNER JOIN import_file f
          ON l.importfileid = f.id
  INNER JOIN import_load il
          ON f.importloadid = il.id
       WHERE l.process_status = 0
         AND il.completed IS NOT NULL;
  -- declare cursor for combined format - single importLoadID
  DECLARE combinedLoadID CURSOR FOR
      SELECT l.id
        FROM load_access_combined l
  INNER JOIN import_file f
          ON l.importfileid = f.id
       WHERE l.process_status = 0
         AND f.importloadid = importLoad_ID;
  -- declare cursor for combined format - single importLoadID
  DECLARE combinedLoadIDFile CURSOR FOR
      SELECT DISTINCT(l.importfileid)
        FROM load_access_combined l
  INNER JOIN import_file f
          ON l.importfileid = f.id
       WHERE l.process_status = 0
         AND f.importloadid = importLoad_ID;
  -- declare cursor for importfileformatid SET=2 in Python check if common format
  DECLARE commonStatusFile CURSOR FOR
      SELECT DISTINCT(l.importfileid)
        FROM load_access_combined l
  INNER JOIN import_file f
          ON l.importfileid = f.id
  INNER JOIN import_load il
          ON f.importloadid = il.id
       WHERE l.process_status = 0
         AND il.completed IS NOT NULL
         AND l.log_useragent IS NULL;
  -- declare cursor for importfileformatid SET=2 in Python check if common format
  DECLARE commonLoadIDFile CURSOR FOR
      SELECT DISTINCT(l.importfileid)
        FROM load_access_combined l
  INNER JOIN import_file f
          ON l.importfileid = f.id
       WHERE l.process_status = 0
         AND f.importloadid = importLoad_ID
         AND l.log_useragent IS NULL;
  -- declare NOT FOUND handler
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE, e4 = SCHEMA_NAME, e5 = CATALOG_NAME;
      CALL errorProcess('parse_access_apache', e1, e2, e3, e4, e5, importLoad_ID, importProcessID);
      SET processErrors = processErrors + 1;
      ROLLBACK;
    END;
  -- check parameters for valid values
  IF CONVERT(in_importLoadID, UNSIGNED) = 0 AND in_importLoadID != 'ALL' THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_importLoadID. Must be convert to number or be ALL';
  END IF;
  IF FIND_IN_SET(in_processName, "csv2mysql,vhost,combined") = 0 THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_processName. Must be csv2mysql, vhost OR combined';
  END IF;
  IF NOT CONVERT(in_importLoadID, UNSIGNED) = 0 THEN
    SELECT importloadid 
      INTO importLoad_ID
      FROM import_process
     WHERE id = in_importLoadID;
  END IF;
  SET importProcessID = importServerProcessID('access_parse', in_processName, importLoad_ID);
  IF importLoad_ID IS NULL THEN
    IF in_processName = 'csv2mysql' THEN
      SELECT COUNT(DISTINCT(f.importloadid))
        INTO loads_processed
        FROM load_access_csv l
  INNER JOIN import_file f
          ON l.importfileid = f.id
  INNER JOIN import_load il
          ON f.importloadid = il.id
       WHERE l.process_status = 0
         AND il.completed IS NOT NULL;
    ELSEIF in_processName = 'vhost' THEN
      SELECT COUNT(DISTINCT(f.importloadid))
        INTO loads_processed
        FROM load_access_vhost l
  INNER JOIN import_file f
          ON l.importfileid = f.id
  INNER JOIN import_load il
          ON f.importloadid = il.id
       WHERE l.process_status = 0
         AND il.completed IS NOT NULL;
    ELSEIF in_processName = 'combined' THEN
      SELECT COUNT(DISTINCT(f.importloadid))
        INTO loads_processed
        FROM load_access_combined l
  INNER JOIN import_file f
          ON l.importfileid = f.id
  INNER JOIN import_load il
          ON f.importloadid = il.id
       WHERE l.process_status = 0
         AND il.completed IS NOT NULL;
    END IF;
  END IF;	
  START TRANSACTION;
  IF in_processName = 'combined' THEN
    -- importfileformatid SET=2 in Python check if common format - 'Import File Format - 1=common,2=combined,3=vhost,4=csv2mysql,5=error_default,6=error_vhost'
    IF importLoad_ID IS NULL THEN
      OPEN commonStatusFile;
    ELSE
      OPEN commonLoadIDFile;
    END IF;
    set_commonformat: LOOP
      IF importLoad_ID IS NULL THEN
        FETCH commonStatusFile INTO importFile_common_ID;
      ELSE
        FETCH commonLoadIDFile INTO importFile_common_ID;
      END IF;
      IF done = true THEN
        LEAVE set_commonformat;
      END IF;
      UPDATE import_file
         SET importfileformatid=1
       WHERE id = importFile_common_ID;
    END LOOP set_commonformat;
    IF importLoad_ID IS NULL THEN
      CLOSE commonStatusFile;
    ELSE
      CLOSE commonLoadIDFile;
    END IF;
    SET done = false;
  END IF;
  -- process import_file TABLE first
  IF in_processName = 'csv2mysql' AND importLoad_ID IS NULL THEN
    OPEN csv2mysqlStatusFile;
  ELSEIF in_processName = 'csv2mysql' THEN
    OPEN csv2mysqlLoadIDFile;
  ELSEIF in_processName = 'vhost' AND importLoad_ID IS NULL THEN
    OPEN vhostStatusFile;
  ELSEIF in_processName = 'vhost' THEN
    OPEN vhostLoadIDFile;
  ELSEIF in_processName = 'combined' AND importLoad_ID IS NULL THEN
    OPEN combinedStatusFile;
  ELSE
    OPEN combinedLoadIDFile;
  END IF;
  process_parse_file: LOOP
  	IF in_processName = 'csv2mysql' AND importLoad_ID IS NULL THEN
      FETCH csv2mysqlStatusFile INTO importFileCheck_ID;
	  ELSEIF in_processName = 'csv2mysql' THEN
      FETCH csv2mysqlLoadIDFile INTO importFileCheck_ID;
	  ELSEIF in_processName = 'vhost' AND importLoad_ID IS NULL THEN
      FETCH vhostStatusFile INTO importFileCheck_ID;
  	ELSEIF in_processName = 'vhost' THEN
      FETCH vhostLoadIDFile INTO importFileCheck_ID;
	  ELSEIF in_processName = 'combined' AND importLoad_ID IS NULL THEN
      FETCH combinedStatusFile INTO importFileCheck_ID;
	  ELSE
      FETCH combinedLoadIDFile INTO importFileCheck_ID;
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
  IF in_processName = 'csv2mysql' AND importLoad_ID IS NULL THEN
    CLOSE csv2mysqlStatusFile;
  ELSEIF in_processName = 'csv2mysql' THEN
    CLOSE csv2mysqlLoadIDFile;
  ELSEIF in_processName = 'vhost' AND importLoad_ID IS NULL THEN
    CLOSE vhostStatusFile;
  ELSEIF in_processName = 'vhost' THEN
    CLOSE vhostLoadIDFile;
  ELSEIF in_processName = 'combined' AND importLoad_ID IS NULL THEN
    CLOSE combinedStatusFile;
  ELSE
    CLOSE combinedLoadIDFile;
  END IF;
  -- process records
  SET done = false;
  IF in_processName = 'csv2mysql' AND importLoad_ID IS NULL THEN
    OPEN csv2mysqlStatus;
  ELSEIF in_processName = 'csv2mysql' THEN
    OPEN csv2mysqlLoadID;
  ELSEIF in_processName = 'vhost' AND importLoad_ID IS NULL THEN
    OPEN vhostStatus;
	ELSEIF in_processName = 'vhost' THEN
    OPEN vhostLoadID;
	ELSEIF in_processName = 'combined' AND importLoad_ID IS NULL THEN
    OPEN combinedStatus;
	ELSE
    OPEN combinedLoadID;
  END IF;
  process_parse: LOOP
    IF in_processName = 'csv2mysql' AND importLoad_ID IS NULL THEN
      FETCH csv2mysqlStatus INTO importRecordID;
    ELSEIF in_processName = 'csv2mysql' THEN
      FETCH csv2mysqlLoadID INTO importRecordID;
    ELSEIF in_processName = 'vhost' AND importLoad_ID IS NULL THEN
      FETCH vhostStatus INTO importRecordID;
    ELSEIF in_processName = 'vhost' THEN
      FETCH vhostLoadID INTO importRecordID;
    ELSEIF in_processName = 'combined' AND importLoad_ID IS NULL THEN
      FETCH combinedStatus INTO importRecordID;
    ELSE
      FETCH combinedLoadID INTO importRecordID;
    END IF;
    IF done = true THEN
      LEAVE process_parse;
    END IF;
    SET records_processed = records_processed + 1;
    -- IF in_processName = 'csv2mysql' THEN
    -- by default, no parsing required for csv2mysql format
    IF in_processName = 'vhost' THEN
      UPDATE load_access_vhost
      SET server_name = SUBSTR(log_server, 1, LOCATE(':', log_server)-1)
      WHERE id=importRecordID AND LOCATE(':', log_server)>0;
      
      UPDATE load_access_vhost
      SET server_port = SUBSTR(log_server, LOCATE(':', log_server)+1)
      WHERE id=importRecordID AND LOCATE(':', log_server)>0;
      
      UPDATE load_access_vhost
      SET req_method = SUBSTR(first_line_request, 1, LOCATE(' ', first_line_request)-1)
      WHERE id=importRecordID AND LEFT(first_line_request, 1) RLIKE '^[A-Z]';
      
      UPDATE load_access_vhost
      SET req_uri = SUBSTR(first_line_request,LOCATE(' ', first_line_request)+1,LOCATE(' ', first_line_request, LOCATE(' ', first_line_request)+1)-LOCATE(' ', first_line_request)-1)
      WHERE id=importRecordID AND LEFT(first_line_request, 1) RLIKE '^[A-Z]';
      
      UPDATE load_access_vhost
      SET req_protocol = SUBSTR(first_line_request, LOCATE(' ', first_line_request, LOCATE(' ', first_line_request)+1))
      WHERE id=importRecordID AND LEFT(first_line_request, 1) RLIKE '^[A-Z]';
      
      UPDATE load_access_vhost
      SET req_query = SUBSTR(req_uri, LOCATE('?', req_uri))
      WHERE id=importRecordID AND LOCATE('?', req_uri)>0;
      
      UPDATE load_access_vhost
      SET req_uri = SUBSTR(req_uri, 1, LOCATE('?', req_uri)-1)
      WHERE id=importRecordID AND LOCATE('?', req_uri)>0;
      
      UPDATE load_access_vhost
      SET req_protocol = 'Invalid Request', req_method = 'Invalid Request', req_uri = 'Invalid Request'
      WHERE id=importRecordID AND LEFT(first_line_request, 1) NOT RLIKE '^[A-Z]|-';
      
      UPDATE load_access_vhost
      SET req_protocol = 'Empty Request', req_method = 'Empty Request', req_uri = 'Empty Request'
      WHERE id=importRecordID AND LEFT(first_line_request, 1) RLIKE '^-';
      
      UPDATE load_access_vhost
      SET req_protocol = TRIM(req_protocol)
      WHERE id=importRecordID;
      
      UPDATE load_access_vhost
      SET log_time = CONCAT(log_time_a, ' ', log_time_b)
      WHERE id=importRecordID;

    ELSEIF in_processName = 'combined' THEN
      UPDATE load_access_combined
      SET req_method = SUBSTR(first_line_request, 1, LOCATE(' ', first_line_request)-1)
      WHERE id=importRecordID AND LEFT(first_line_request, 1) RLIKE '^[A-Z]';
      
      UPDATE load_access_combined
      SET req_uri = SUBSTR(first_line_request, LOCATE(' ', first_line_request)+1, LOCATE(' ', first_line_request, LOCATE(' ', first_line_request)+1)-LOCATE(' ', first_line_request)-1)
      WHERE id=importRecordID AND LEFT(first_line_request, 1) RLIKE '^[A-Z]';
      
      UPDATE load_access_combined
      SET req_protocol = SUBSTR(first_line_request, LOCATE(' ', first_line_request, LOCATE(' ', first_line_request)+1))
      WHERE id=importRecordID AND LEFT(first_line_request, 1) RLIKE '^[A-Z]';
      
      UPDATE load_access_combined
      SET req_query = SUBSTR(req_uri,LOCATE('?', req_uri))
      WHERE id=importRecordID AND LOCATE('?', req_uri)>0;
      
      UPDATE load_access_combined
      SET req_uri = SUBSTR(req_uri, 1, LOCATE('?', req_uri)-1)
      WHERE id=importRecordID AND LOCATE('?', req_uri)>0;
      
      UPDATE load_access_combined
      SET req_protocol = 'Invalid Request', req_method = 'Invalid Request', req_uri = 'Invalid Request'
      WHERE id=importRecordID AND LEFT(first_line_request, 1) NOT RLIKE '^[A-Z]|-';
      
      UPDATE load_access_combined
      SET req_protocol = 'Empty Request', req_method = 'Empty Request', req_uri = 'Empty Request'
      WHERE id=importRecordID AND LEFT(first_line_request, 1) RLIKE '^-';
      
      UPDATE load_access_combined
      SET req_protocol = TRIM(req_protocol)
      WHERE id=importRecordID;
      
      UPDATE load_access_combined
      SET log_time = CONCAT(log_time_a, ' ', log_time_b)
      WHERE id=importRecordID;
    END IF;
    IF in_processName = 'csv2mysql' THEN
      UPDATE load_access_csv SET process_status=1 WHERE id=importRecordID;
    ELSEIF in_processName = 'vhost' THEN
      UPDATE load_access_vhost SET process_status=1 WHERE id=importRecordID;
    ELSE
      UPDATE load_access_combined SET process_status=1 WHERE id=importRecordID;
    END IF;
  END LOOP process_parse;
  -- to remove SQL calculating loads_processed when importLoad_ID is passed. Set=1 by default.
  IF importLoad_ID IS NOT NULL AND records_processed=0 THEN
    SET loads_processed = 0;
  END IF;
  -- update import process table
  UPDATE import_process
     SET recordsprocessed = records_processed,
         filesprocessed = files_processed,
         loadsprocessed = loads_processed,
         completed = now(),
         errorCount = processErrors,
         processSeconds = TIME_TO_SEC(TIMEDIFF(now(), started))
   WHERE id = importProcessID;
  COMMIT;
  IF in_processName = 'csv2mysql' AND importLoad_ID IS NULL THEN
    CLOSE csv2mysqlStatus;
  ELSEIF in_processName = 'csv2mysql' THEN
    CLOSE csv2mysqlLoadID;
  ELSEIF in_processName = 'vhost' AND importLoad_ID IS NULL THEN
    CLOSE vhostStatus;
  ELSEIF in_processName = 'vhost' THEN
    CLOSE vhostLoadID;
  ELSEIF in_processName = 'combined' AND importLoad_ID IS NULL THEN
    CLOSE combinedStatus;
  ELSE
    CLOSE combinedLoadID;
  END IF;
END//
DELIMITER ;
