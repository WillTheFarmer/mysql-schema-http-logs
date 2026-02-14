-- drop procedure -----------------------------------------------------------
DROP PROCEDURE IF EXISTS `import_error_apache_default`;
-- create procedure ---------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` PROCEDURE `import_error_apache_default`
(
  IN in_processName VARCHAR(100),
  IN in_importLoadID VARCHAR(20)
)
BEGIN
  -- module_name_process = module_name column in import_process - to id procedure is being run
  -- in_processName = process_name column in import_process - to id procedure OPTION is being run
  DECLARE module_name_process VARCHAR(255) DEFAULT 'import_error_apache_default';
  -- standard variables for processes
  DECLARE e1 INT UNSIGNED;
  DECLARE e2, e3 VARCHAR(128);
  DECLARE e4, e5 VARCHAR(64);
  DECLARE done BOOL DEFAULT false;
  DECLARE importProcessID INT UNSIGNED DEFAULT NULL;
  DECLARE importLoad_ID INT UNSIGNED DEFAULT NULL;
  DECLARE importRecordID INT UNSIGNED DEFAULT NULL;
  DECLARE importFile_ID INT UNSIGNED DEFAULT NULL;
  DECLARE importFileCheck_ID INT UNSIGNED DEFAULT NULL;
  DECLARE records_processed INT DEFAULT 0;
  DECLARE files_processed INT DEFAULT 0;
  DECLARE loads_processed INT DEFAULT 1;
  DECLARE processErrors INT DEFAULT 0;
  -- LOAD DATA staging table column variables
  DECLARE log_time DATETIME DEFAULT now();
  DECLARE log_level VARCHAR(100) DEFAULT NULL;
  DECLARE log_module VARCHAR(100) DEFAULT NULL;
  DECLARE log_processid VARCHAR(100) DEFAULT NULL;
  DECLARE log_threadid VARCHAR(100) DEFAULT NULL;
  DECLARE log_httpCode VARCHAR(400) DEFAULT NULL;
  DECLARE log_httpMessage VARCHAR(400) DEFAULT NULL;
  DECLARE log_systemCode VARCHAR(400) DEFAULT NULL;
  DECLARE log_systemMessage VARCHAR(400) DEFAULT NULL;
  DECLARE log_message VARCHAR(500) DEFAULT NULL;
  DECLARE log_referer VARCHAR(1000) DEFAULT NULL;
  DECLARE refererConverted VARCHAR(1000) DEFAULT NULL;
  DECLARE client VARCHAR(253) DEFAULT NULL;
  DECLARE clientPort VARCHAR(100) DEFAULT NULL;
  DECLARE server VARCHAR(253) DEFAULT NULL;
  DECLARE serverPort INT DEFAULT NULL;
  DECLARE requestLogID VARCHAR(50) DEFAULT NULL;
  DECLARE serverFile VARCHAR(253) DEFAULT NULL;
  DECLARE serverPortFile INT DEFAULT NULL;
  DECLARE importFile VARCHAR(300) DEFAULT NULL;
  -- Primary IDs for the normalized Attribute tables
  DECLARE logLevel_Id,
          module_Id,
          process_Id,
          thread_Id,
          httpCode_Id,
          httpMessage_Id,
          systemCode_Id,
          systemMessage_Id,
          logMessage_Id,
          referer_Id,
          client_Id,
          clientPort_Id,
          server_Id,
          serverPort_Id,
          requestLog_Id INT DEFAULT NULL;
	-- declare cursor for default format - single importLoadID
  DECLARE defaultByLoadID CURSOR FOR
      SELECT l.logtime,
             l.loglevel,
             l.module,
             l.processid,
             l.threadid,
             l.httpcode,
             l.httpmessage,
             l.systemcode,
             l.systemmessage,
             l.logmessage,
             l.referer,
             l.client_name,
             l.client_port,
             l.server_name,
             l.server_port,
             l.request_log_id,
             l.importfileid,
             f.server_name server_name_file,
             f.server_port server_port_file,
             l.id
        FROM load_error_apache_default l
  INNER JOIN import_file f
          ON l.importfileid = f.id
       WHERE l.process_status = 1
         AND f.importloadid = importLoad_ID;
  DECLARE defaultByLoadIDFile CURSOR FOR
      SELECT DISTINCT(l.importfileid)
        FROM load_error_apache_default l
  INNER JOIN import_file f
          ON l.importfileid = f.id
       WHERE l.process_status = 1
         AND f.importloadid = importLoad_ID;
  DECLARE defaultByStatus CURSOR FOR
      SELECT l.logtime,
             l.loglevel,
             l.module,
             l.processid,
             l.threadid,
             l.httpcode,
             l.httpmessage,
             l.systemcode,
             l.systemmessage,
             l.logmessage,
             l.referer,
             l.client_name,
             l.client_port,
             l.server_name,
             l.server_port,
             l.request_log_id,
             l.importfileid,
             f.server_name server_name_file,
             f.server_port server_port_file,
             l.id
        FROM load_error_apache_default l
  INNER JOIN import_file f
          ON l.importfileid = f.id
       WHERE l.process_status = 1;
  DECLARE defaultByStatusFile CURSOR FOR
     SELECT DISTINCT(l.importfileid)
       FROM load_error_apache_default l
 INNER JOIN import_file f
         ON l.importfileid = f.id
      WHERE l.process_status = 1;
  -- declare NOT FOUND handler
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE, e4 = SCHEMA_NAME, e5 = CATALOG_NAME;
      CALL messageProcess('import_error_apache', e1, e2, e3, e4, e5, importLoad_ID, importProcessID);
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
    SET importLoad_ID = CONVERT(in_importLoadID, UNSIGNED);
  END IF;
  IF NOT CONVERT(in_importLoadID, UNSIGNED) = 0 THEN
    SELECT importloadid 
      INTO importLoad_ID
      FROM import_process
     WHERE id = in_importLoadID;
  END IF;
  SET importProcessID = importServerProcessID(module_name_process, in_processName, importLoad_ID);
  IF importLoad_ID IS NULL THEN
    SELECT COUNT(DISTINCT(f.importloadid))
      INTO loads_processed
      FROM load_error_apache_default l
INNER JOIN import_file f
        ON l.importfileid = f.id
     WHERE l.process_status = 1;
  END IF;
  START TRANSACTION;
  -- process import_file TABLE first 
  IF importLoad_ID IS NULL THEN
    OPEN defaultByStatusFile;
  ELSE
    OPEN defaultByLoadIDFile;
  END IF;
  process_import_file: LOOP
    IF importLoad_ID IS NULL THEN
      FETCH defaultByStatusFile INTO importFileCheck_ID;
    ELSE
      FETCH defaultByLoadIDFile INTO importFileCheck_ID;
    END IF;
    IF done = true THEN
      LEAVE process_import_file;
    END IF;
    IF importFileCheck(importFileCheck_ID, importProcessID, 'import') = 0 THEN
      ROLLBACK;
      LEAVE process_import_file;
    END IF;
    SET files_processed = files_processed + 1;
  END LOOP process_import_file;
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
  process_import: LOOP
    IF importLoad_ID IS NULL THEN
      FETCH defaultByStatus INTO
            log_time,
            log_level,
            log_module,
            log_processid,
            log_threadid,
            log_httpCode,
            log_httpMessage,
            log_systemCode,
            log_systemMessage,
            log_message,
            log_referer,
            client,
            clientPort,
            server,
            serverPort,
            requestLogID,
            importFile_ID,
            serverFile,
            serverPortFile,
            importRecordID;
    ELSE
      FETCH defaultByLoadID INTO
            log_time,
            log_level,
            log_module,
            log_processid,
            log_threadid,
            log_httpCode,
            log_httpMessage,
            log_systemCode,
            log_systemMessage,
            log_message,
            log_referer,
            client,
            clientPort,
            server,
            serverPort,
            requestLogID,
            importFile_ID,
            serverFile,
            serverPortFile,
            importRecordID;
    END IF;
    IF done = true THEN
      LEAVE process_import;
    END IF;
    SET records_processed = records_processed + 1;
    SET logLevel_Id = null,
        module_Id = null,
        process_Id = null,
        thread_Id = null,
        httpCode_Id = null,
        httpMessage_Id = null,
        systemCode_Id = null,
        systemMessage_Id = null,
        logMessage_Id = null,
        referer_Id = null,
        client_Id = null,
        clientPort_Id = null,
        server_Id = null,
        serverPort_Id = null,
        requestLog_Id = null;
    -- any customizing for business needs should be done here before normalization functions called.
    -- convert staging columns - log_referer in import for audit purposes
    IF LOCATE("?", log_referer)>0 THEN
      SET refererConverted = SUBSTR(log_referer, 1, LOCATE("?", log_referer)-1);
    ELSE
      SET refererConverted = log_referer;
    END IF;
    -- normalize import staging table 
    IF log_level IS NOT NULL THEN
      SET logLevel_Id = error_logLevelID(log_level);
    END IF;
    IF log_module IS NOT NULL THEN
      SET module_Id = error_moduleID(log_module);
    END IF;
    IF log_processid IS NOT NULL THEN
      SET process_Id = error_processID(log_processid);
    END IF;
    IF log_threadid IS NOT NULL THEN
      SET thread_Id = error_threadID(log_threadid);
    END IF;
    IF log_httpCode IS NOT NULL THEN
      SET httpCode_Id = error_httpCodeID(log_httpCode);
    END IF;
    IF log_httpMessage IS NOT NULL THEN
      SET httpMessage_Id = error_httpMessageID(log_httpMessage);
    END IF;
    IF log_systemCode IS NOT NULL THEN
      SET systemCode_Id = error_systemCodeID(log_systemCode);
    END IF;
    IF log_systemMessage IS NOT NULL THEN
      SET systemMessage_Id = error_systemMessageID(log_systemMessage);
    END IF;
    IF log_message IS NOT NULL THEN
      SET logMessage_id = error_logMessageID(log_message);
    END IF;
    IF refererConverted IS NOT NULL AND refererConverted != '-' THEN
      SET referer_Id = log_refererID(refererConverted);
    END IF;
    IF client IS NOT NULL THEN
      SET client_id = log_clientID(client);
    END IF;
    IF clientPort IS NOT NULL THEN
      SET clientPort_id = log_clientPortID(clientPort);
    END IF;
    IF server IS NOT NULL THEN
      SET server_Id = log_serverID(server);
    ELSEIF serverFile IS NOT NULL THEN
      SET server_Id = log_serverID(serverFile);
    END IF;
    IF serverPort IS NOT NULL THEN
      SET serverPort_Id = log_serverPortID(serverPort);
    ELSEIF serverPortFile IS NOT NULL THEN
      SET serverPort_Id = log_serverPortID(serverPortFile);
    END IF;
    IF requestLogID IS NOT NULL AND requestLogID != '-' THEN
      IF server_Id IS NOT NULL THEN
        SET requestLogID = CONCAT(requestLogID, '_', CONVERT(server_Id, CHAR));
      END IF;
      SET requestLog_Id = log_requestLogID(requestLogID);
    END IF;
    INSERT INTO error_log
       (logged,
        loglevelid,
        moduleid,
        processid,
        threadid,
        httpcodeid,
        httpmessageid,
        systemcodeid,
        systemmessageid,
        logmessageid,
        refererid,
        clientid,
        clientportid,
        serverid,
        serverportid,
        requestlogid, 
        importfileid) 
    VALUES
       (log_time,
        logLevel_Id,
        module_Id,
        process_Id,
        thread_Id,
        httpCode_Id,
        httpMessage_Id,
        systemCode_Id,
        systemMessage_Id,
        logMessage_Id,
        referer_Id,
        client_Id,
        clientPort_Id,
        server_Id,
        serverPort_Id,
        requestLog_Id,
        importFile_ID);
    UPDATE load_error_apache_default SET process_status=2 WHERE id=importRecordID;
  END LOOP process_import;
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
