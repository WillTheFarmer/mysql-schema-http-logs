-- drop procedure -----------------------------------------------------------
DROP PROCEDURE IF EXISTS `parse_error_nginx_default`;
-- create procedure ---------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` PROCEDURE `parse_error_nginx_default`
(
  IN in_processName VARCHAR(100),
  IN in_importLoadID VARCHAR(20)
)
BEGIN
  -- module_name_process = module_name column in import_process - to id procedure is being run
  -- in_processName = process_name column in import_process - to id procedure OPTION is being run
  DECLARE module_name_process VARCHAR(255) DEFAULT 'parse_error_nginx_default';
  -- standard variables for processes
  DECLARE e1 INT UNSIGNED;
  DECLARE e2, e3 VARCHAR(128);
  DECLARE e4, e5 VARCHAR(64);
  DECLARE done BOOL DEFAULT false;
  DECLARE importProcessID INT UNSIGNED DEFAULT NULL;
  DECLARE importLoad_ID INT UNSIGNED DEFAULT NULL;
  DECLARE importRecordID INT UNSIGNED DEFAULT NULL;
  DECLARE importFileCheck_ID INT UNSIGNED DEFAULT NULL;
  DECLARE importFile_vhost_ID INT UNSIGNED DEFAULT NULL;
  DECLARE records_processed INT DEFAULT 0;
  DECLARE files_processed INT DEFAULT 0;
  DECLARE loads_processed INT DEFAULT 1;
  DECLARE processErrors INT DEFAULT 0;
  -- declare cursor for default format - single importLoadID
  DECLARE defaultByLoadID CURSOR FOR
      SELECT l.id
        FROM load_error_nginx_default l
  INNER JOIN import_file f
          ON l.importfileid = f.id
       WHERE l.process_status = 0
         AND f.importloadid = importLoad_ID;
  DECLARE defaultByLoadIDFile CURSOR FOR
      SELECT DISTINCT(l.importfileid)
        FROM load_error_nginx_default l
  INNER JOIN import_file f
          ON l.importfileid = f.id
       WHERE l.process_status = 0
         AND f.importloadid = importLoad_ID;
  DECLARE defaultByStatus CURSOR FOR
      SELECT l.id
        FROM load_error_nginx_default l
  INNER JOIN import_file f
          ON l.importfileid = f.id
  INNER JOIN import_load il
          ON f.importloadid = il.id
       WHERE l.process_status = 0
         AND il.completed IS NOT NULL;
  DECLARE defaultByStatusFile CURSOR FOR
      SELECT DISTINCT(l.importfileid)
        FROM load_error_nginx_default l
  INNER JOIN import_file f
          ON l.importfileid = f.id
  INNER JOIN import_load il
          ON f.importloadid = il.id
       WHERE l.process_status = 0
         AND il.completed IS NOT NULL;
  DECLARE vhostByLoadIDFile CURSOR FOR
      SELECT DISTINCT(l.importfileid)
        FROM load_error_nginx_default l
  INNER JOIN import_file f
          ON l.importfileid = f.id
       WHERE l.process_status = 0
         AND f.importloadid = importLoad_ID
         AND LOCATE(' ,', l.log_parse1)>0 OR LOCATE(' ,', l.log_parse2)>0;
  DECLARE vhostByStatusFile CURSOR FOR
      SELECT DISTINCT(l.importfileid)
        FROM load_error_nginx_default l
  INNER JOIN import_file f
          ON l.importfileid = f.id
  INNER JOIN import_load il
          ON f.importloadid = il.id
       WHERE l.process_status = 0
         AND il.completed IS NOT NULL
         AND LOCATE(' ,', l.log_parse1)>0 OR LOCATE(' ,', l.log_parse2)>0;
  -- declare NOT FOUND handler
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE, e4 = SCHEMA_NAME, e5 = CATALOG_NAME;
      CALL messageProcess( module_name_process, e1, e2, e3, e4, e5, importLoad_ID, importProcessID);
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
      FROM load_error_nginx_default l
INNER JOIN import_file f
        ON l.importfileid = f.id
INNER JOIN import_load il
        ON f.importloadid = il.id
     WHERE il.completed IS NOT NULL
       AND l.process_status = 0;
  END IF;
--  SET importProcessID = importServerProcessID('error_parse', in_processName);
  START TRANSACTION;
  IF importLoad_ID IS NULL THEN
    -- importfileformatid SET=5 in Python check if error_vhost format - 'Import File Format - 1=common,2=combined,3=vhost,4=csv2mysql,5=error_default,6=error_vhost'
    OPEN vhostByStatusFile;
  ELSE
    -- importfileformatid SET=5 in Python check if error_vhost format - 'Import File Format - 1=common,2=combined,3=vhost,4=csv2mysql,5=error_default,6=error_vhost'
    OPEN vhostByLoadIDFile;
  END IF;
  set_vhostformat: LOOP
    IF importLoad_ID IS NULL THEN
      FETCH vhostByStatusFile INTO importFile_vhost_ID;
    ELSE
      FETCH vhostByLoadIDFile INTO importFile_vhost_ID;
    END IF;
    IF done = true THEN
      LEAVE set_vhostformat;
    END IF;
    UPDATE import_file
       SET importfileformatid=6
     WHERE id = importFile_vhost_ID;
  END LOOP set_vhostformat;
  IF importLoad_ID IS NULL THEN
    CLOSE vhostByStatusFile;
  ELSE
    CLOSE vhostByLoadIDFile;
  END IF;
  -- process import_file TABLE first 
  SET done = false;
  IF importLoad_ID IS NULL THEN
    OPEN defaultByStatusFile;
  ELSE
    OPEN defaultByLoadIDFile;
  END IF;
  process_parse_file: LOOP
    IF importLoad_ID IS NULL THEN
      FETCH defaultByStatusFile INTO importFileCheck_ID;
    ELSE
      FETCH defaultByLoadIDFile INTO importFileCheck_ID;
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
    CLOSE defaultByStatusFile;
  ELSE
    CLOSE defaultByLoadIDFile;
  END IF;
  -- process records
  SET done = false;
  IF importLoad_ID IS NULL THEN
    OPEN defaultByStatus;
  ELSE
    OPEN defaultByLoadID;
  END IF;
  process_parse: LOOP
    IF importLoad_ID IS NULL THEN
      FETCH defaultByStatus INTO importRecordID;
    ELSE
      FETCH defaultByLoadID INTO importRecordID;
    END IF;
    IF done = true THEN
      LEAVE process_parse;
    END IF;
    SET records_processed = records_processed + 1;
    UPDATE load_error_nginx_default
       SET module = SUBSTR(log_mod_level,3, LOCATE(':', log_mod_level)-3),
           loglevel = SUBSTR(log_mod_level, LOCATE(':', log_mod_level)+1),
           processid = SUBSTR(log_processid_threadid, LOCATE('pid', log_processid_threadid)+4, LOCATE(':', log_processid_threadid)-LOCATE('pid', log_processid_threadid)-4),
           threadid = SUBSTR(log_processid_threadid, LOCATE('tid', log_processid_threadid)+4),
           logtime = STR_TO_DATE(SUBSTR(log_time, 2, 31),'%a %b %d %H:%i:%s.%f %Y')
     WHERE id = importRecordID;

    UPDATE load_error_nginx_default
       SET httpcode = SUBSTR(log_parse1, 2, LOCATE(':', log_parse1)-2)
     WHERE id = importRecordID AND LEFT(log_parse1, 2)=' A';
    UPDATE load_error_nginx_default
       SET httpcode = SUBSTR(log_parse2, 2, LOCATE(':', log_parse2)-2)
     WHERE id = importRecordID AND LEFT(log_parse2, 2)=' A';
    UPDATE load_error_nginx_default
       SET httpcode = SUBSTR(log_parse1, LOCATE(': AH', log_parse1)+2, LOCATE(':', log_parse1, (LOCATE(': AH', log_parse1)+2))-LOCATE(': AH', log_parse1)-2)
     WHERE id = importRecordID AND LOCATE(': AH', log_parse1)>0;

    UPDATE load_error_nginx_default
       SET httpmessage = SUBSTR(log_parse1, LOCATE(':', log_parse1)+1)
     WHERE id = importRecordID AND LEFT(log_parse1, 2)=' A';
    UPDATE load_error_nginx_default
       SET httpmessage = SUBSTR(log_parse2, LOCATE(':', log_parse2)+1)
     WHERE id = importRecordID AND LEFT(log_parse2, 2)=' A' AND LOCATE('referer:', log_parse2)=0;
    UPDATE load_error_nginx_default
       SET httpmessage = SUBSTR(log_parse2, LOCATE(':', log_parse2)+1, LOCATE(', referer:', log_parse2)-LOCATE(':', log_parse2)-1)
     WHERE id = importRecordID AND LEFT(log_parse2, 2)=' A' AND LOCATE(', referer:', log_parse2)>0;
    UPDATE load_error_nginx_default
       SET httpmessage = SUBSTR(log_parse1, LOCATE(':', log_parse1, LOCATE(': AH', log_parse1)+2)+2)
     WHERE id = importRecordID AND LOCATE(': AH', log_parse1)>0;

    UPDATE load_error_nginx_default
       SET client_name = SUBSTR(log_parse1, LOCATE('[client', log_parse1)+8)
     WHERE id = importRecordID AND LOCATE('[client', log_parse1)>0;

    UPDATE load_error_nginx_default
       SET client_port = SUBSTR(client_name, LOCATE(':', client_name)+1)
     WHERE id = importRecordID AND LOCATE(':', client_name)>0;

    UPDATE load_error_nginx_default
       SET client_name = SUBSTR(client_name, 1, LOCATE(':', client_name)-1)
     WHERE id = importRecordID AND LOCATE(':', client_name)>0;

    UPDATE load_error_nginx_default
       SET systemcode = SUBSTR(log_parse1, LOCATE('(', log_parse1), LOCATE(':', log_parse1, LOCATE('(', log_parse1))-LOCATE('(', log_parse1))
     WHERE id = importRecordID AND LOCATE('(', log_parse1)>0 AND LOCATE(':', log_parse1, LOCATE('(', log_parse1))-LOCATE('(', log_parse1)>0;

    UPDATE load_error_nginx_default
       SET systemmessage = SUBSTR(log_parse1, LOCATE(':', log_parse1) + 1)
     WHERE id = importRecordID AND LOCATE('(', log_parse1)>0 AND LOCATE(':', log_parse1, LOCATE('(', log_parse1))-LOCATE('(', log_parse1)>0 AND httpcode IS NULL;

    UPDATE load_error_nginx_default
       SET log_message_nocode = log_parse1
     WHERE id = importRecordID AND systemcode IS NULL AND httpcode IS NULL;

    UPDATE load_error_nginx_default
       SET module = SUBSTR(log_parse1, 2, LOCATE(':', log_parse1)-2)
     WHERE id = importRecordID AND systemcode IS NULL AND httpcode IS NULL AND LENGTH(module)=0 AND LOCATE(':', log_parse1)>0 AND LOCATE(' ', log_parse1, 2)>LOCATE(':', log_parse1);

    UPDATE load_error_nginx_default
       SET logmessage = SUBSTR(log_parse1, LOCATE(':', log_parse1)+1)
     WHERE id = importRecordID AND systemcode IS NULL AND httpcode IS NULL AND LOCATE(':', log_parse1)>0 AND LOCATE(' ', log_parse1,2)>LOCATE(':', log_parse1);

    UPDATE load_error_nginx_default
       SET logmessage = log_message_nocode
     WHERE id = importRecordID AND logmessage IS NULL AND log_message_nocode IS NOT NULL;

    UPDATE load_error_nginx_default
       SET referer = SUBSTR(log_parse2, LOCATE('referer:', log_parse2)+8)
     WHERE id = importRecordID AND LOCATE('referer:', log_parse2)>0;

    -- 12/07/2024 @ 4:55AM - server_name and request_log_id parsing - if either exists
    -- referer
    UPDATE load_error_nginx_default
       SET request_log_ID=SUBSTR(referer,LOCATE(' ,', referer, LOCATE(' ,', referer)+2)+2)
     WHERE id = importRecordID AND LOCATE(' ,', referer, LOCATE(' ,', referer)+2)>0;

    UPDATE load_error_nginx_default
       SET server_name=SUBSTR(referer, LOCATE(' ,',referer)+2, LOCATE(' ,',referer, LOCATE(' ,',referer)+2)-LOCATE(' ,', referer)-2)
     WHERE id = importRecordID AND LOCATE(' ,', referer, LOCATE(' ,',referer)+2)>0;

--    UPDATE load_error_nginx_default 
--       SET server_name=SUBSTR(referer, LOCATE(' ,',referer)+2) 
--     WHERE id = importRecordID AND LOCATE(' ,', referer)>0 AND server_name IS NULL;

    UPDATE load_error_nginx_default
       SET server_name=SUBSTR(referer, LOCATE(' ,',referer)+2)
     WHERE id = importRecordID AND LOCATE(' ,', referer)>0 AND LOCATE(' ,', referer, LOCATE(' ,',referer)+2)=0;

    UPDATE load_error_nginx_default
       SET referer=SUBSTR(referer, 1, LOCATE(' ,', referer))
     WHERE id = importRecordID AND LOCATE(' ,', referer)>0;
    -- logmessage
    UPDATE load_error_nginx_default
       SET request_log_ID=SUBSTR(logmessage, LOCATE(' ,', logmessage, LOCATE(' ,',logmessage)+2)+2)
     WHERE id = importRecordID AND LOCATE(' ,', logmessage, LOCATE(' ,',logmessage)+2)>0;

    UPDATE load_error_nginx_default
       SET server_name=SUBSTR(logmessage, LOCATE(' ,',logmessage)+2, LOCATE(' ,',logmessage,LOCATE(' ,',logmessage)+2)-LOCATE(' ,',logmessage)-2)
     WHERE id = importRecordID AND LOCATE(' ,', logmessage, LOCATE(' ,', logmessage)+2)>0;

--    UPDATE load_error_nginx_default
--       SET server_name=SUBSTR(logmessage, LOCATE(' ,', logmessage)+2)
--     WHERE id = importRecordID AND LOCATE(' ,', logmessage)>0 AND server_name IS NULL;

    UPDATE load_error_nginx_default
       SET server_name=SUBSTR(logmessage, LOCATE(' ,', logmessage)+2)
     WHERE id = importRecordID AND LOCATE(' ,', logmessage, LOCATE(' ,', logmessage)+2)=0 AND LOCATE(' ,', logmessage)>0;

    UPDATE load_error_nginx_default
       SET logmessage=SUBSTR(logmessage, 1, LOCATE(' ,', logmessage))
     WHERE id = importRecordID AND LOCATE(' ,', logmessage)>0;
    -- systemmessage
    UPDATE load_error_nginx_default
       SET request_log_ID=SUBSTR(systemmessage, LOCATE(' ,', systemmessage, LOCATE(' ,',systemmessage)+2)+2)
     WHERE id = importRecordID AND LOCATE(' ,', systemmessage, LOCATE(' ,', systemmessage)+2)>0;

    UPDATE load_error_nginx_default
       SET server_name=SUBSTR(systemmessage, LOCATE(' ,', systemmessage)+2, LOCATE(' ,',systemmessage,LOCATE(' ,',systemmessage)+2)-LOCATE(' ,',systemmessage)-2)
     WHERE id = importRecordID AND LOCATE(' ,',systemmessage, LOCATE(' ,', systemmessage)+2)>0;

--    UPDATE load_error_nginx_default
--       SET server_name=SUBSTR(systemmessage, LOCATE(' ,', systemmessage)+2)
--     WHERE id = importRecordID AND LOCATE(' ,', systemmessage)>0 AND server_name IS NULL;

    UPDATE load_error_nginx_default
       SET server_name=SUBSTR(systemmessage, LOCATE(' ,', systemmessage)+2)
     WHERE id = importRecordID AND LOCATE(' ,',systemmessage, LOCATE(' ,', systemmessage)+2)=0 AND LOCATE(' ,', systemmessage)>0;

    UPDATE load_error_nginx_default
       SET systemmessage=SUBSTR(systemmessage, 1, LOCATE(' ,', systemmessage))
     WHERE id = importRecordID AND LOCATE(' ,', systemmessage)>0;
    -- httpmessage
    UPDATE load_error_nginx_default
       SET request_log_ID=SUBSTR(httpmessage, LOCATE(' ,', httpmessage, LOCATE(' ,',httpmessage)+2)+2)
     WHERE id = importRecordID AND LOCATE(' ,', httpmessage, LOCATE(' ,', httpmessage)+2)>0;

    UPDATE load_error_nginx_default
       SET server_name=SUBSTR(httpmessage, LOCATE(' ,', httpmessage)+2, LOCATE(' ,', httpmessage, LOCATE(' ,', httpmessage)+2)-LOCATE(' ,', httpmessage)-2)
     WHERE id = importRecordID AND LOCATE(' ,', httpmessage, LOCATE(' ,', httpmessage)+2)>0;

--    UPDATE load_error_nginx_default
--       SET server_name=SUBSTR(httpmessage, LOCATE(' ,', httpmessage)+2)
--     WHERE id = importRecordID AND LOCATE(' ,', httpmessage)>0 AND server_name IS NULL;

    UPDATE load_error_nginx_default
       SET server_name=SUBSTR(httpmessage, LOCATE(' ,', httpmessage)+2)
     WHERE id = importRecordID AND LOCATE(' ,', httpmessage, LOCATE(' ,', httpmessage)+2)=0 AND LOCATE(' ,', httpmessage)>0;

    UPDATE load_error_nginx_default
       SET httpmessage=SUBSTR(httpmessage, 1, LOCATE(' ,', httpmessage))
     WHERE id = importRecordID AND LOCATE(' ,', httpmessage)>0;

    UPDATE load_error_nginx_default
       SET module=TRIM(module),
           loglevel=TRIM(loglevel),
           processid=TRIM(processid),
           threadid=TRIM(threadid),
           httpcode=TRIM(httpcode),
           httpmessage=TRIM(httpmessage),
           systemcode=TRIM(systemcode),
           systemmessage = TRIM(systemmessage),
           logmessage=TRIM(logmessage),
           client_name=TRIM(client_name),
           referer=TRIM(referer),
           server_name=TRIM(server_name),
           request_log_id=TRIM(request_log_id)
     WHERE id=importRecordID;
    UPDATE load_error_nginx_default SET process_status=1 WHERE id=importRecordID;
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
    CLOSE defaultByStatus;
  ELSE
    CLOSE defaultByLoadID;
  END IF;
END//
DELIMITER ;
