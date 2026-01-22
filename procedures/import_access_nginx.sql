-- drop procedure -----------------------------------------------------------
DROP PROCEDURE IF EXISTS `import_access_nginx`;
-- create procedure ---------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` PROCEDURE `import_access_nginx`
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
  DECLARE importFile_ID INT DEFAULT NULL;
  DECLARE records_processed INT DEFAULT 0;
  DECLARE files_processed INT DEFAULT 0;
  DECLARE loads_processed INT DEFAULT 1;
  DECLARE processErrors INT DEFAULT 0;
  -- LOAD DATA staging table column variables
  DECLARE logTime VARCHAR(50) DEFAULT NULL;
  DECLARE logTimeConverted DATETIME DEFAULT now();
  DECLARE remoteLogName VARCHAR(150) DEFAULT NULL;
  DECLARE remoteUser VARCHAR(150) DEFAULT NULL;
  DECLARE bytesReceived INT DEFAULT 0;
  DECLARE bytesSent INT DEFAULT 0;
  DECLARE bytesTransferred INT DEFAULT 0;
  DECLARE reqTimeMilli INT DEFAULT 0;
  DECLARE reqTimeMicro INT DEFAULT 0;
  DECLARE reqDelayMilli INT DEFAULT 0;
  DECLARE reqBytes INT DEFAULT 0;
  DECLARE reqStatus INT DEFAULT 0;
  DECLARE reqProtocol VARCHAR(30) DEFAULT NULL;
  DECLARE reqMethod VARCHAR(50) DEFAULT NULL;
  DECLARE reqUri VARCHAR(2000) DEFAULT NULL;
  DECLARE reqQuery VARCHAR(5000) DEFAULT NULL;
  DECLARE reqQueryConverted VARCHAR(5000) DEFAULT NULL;
  DECLARE referer VARCHAR(1000) DEFAULT NULL;
  DECLARE refererConverted VARCHAR(1000) DEFAULT NULL;
  DECLARE userAgent VARCHAR(1000) DEFAULT NULL;
  DECLARE logCookie VARCHAR(400) DEFAULT NULL;
  DECLARE logCookieConverted VARCHAR(400) DEFAULT NULL;
  DECLARE client VARCHAR(253) DEFAULT NULL;
  DECLARE server VARCHAR(253) DEFAULT NULL;
  DECLARE serverPort INT DEFAULT NULL;
  DECLARE serverFile VARCHAR(253) DEFAULT NULL;
  DECLARE serverPortFile INT DEFAULT NULL;
  DECLARE requestLogID VARCHAR(50) DEFAULT NULL;
  DECLARE importFile VARCHAR(300) DEFAULT NULL;
  -- Primary IDs for the normalized Attribute tables
  DECLARE remoteLogName_Id,
          remoteUser_Id,
          reqStatus_Id,
          reqProtocol_Id,
          reqMethod_Id,
          reqUri_Id,
          reqQuery_Id,
          referer_Id,
          userAgent_Id,
          logCookie_Id,
          client_Id,
          server_Id,
          serverPort_Id,
          requestLog_Id INT DEFAULT NULL;
  -- declare cursor for combined format - All importloadIDs not processed
  DECLARE combinedStatus CURSOR FOR
      SELECT l.remote_host,
             l.remote_logname,
             l.remote_user,
             l.log_time,
             l.req_bytes,
             l.req_status,
             l.req_protocol,
             l.req_method,
             l.req_uri,
             l.req_query,
             l.log_referer,
             l.log_useragent,
             l.server_name,
             l.server_port,
             l.importfileid,
             f.server_name server_name_file,
             f.server_port server_port_file,
             l.id
        FROM load_access_nginx l
  INNER JOIN import_file f
          ON l.importfileid = f.id
       WHERE l.process_status = 1;
  -- declare cursor for combined format - All importloadIDs not processed
  DECLARE combinedStatusFile CURSOR FOR
      SELECT DISTINCT(l.importfileid)
        FROM load_access_nginx l
  INNER JOIN import_file f
          ON l.importfileid = f.id
       WHERE l.process_status = 1;
  -- declare cursor for combined format - single importLoadID
  DECLARE combinedLoadID CURSOR FOR
      SELECT l.remote_host,
             l.remote_logname,
             l.remote_user,
             l.log_time,
             l.req_bytes,
             l.req_status,
             l.req_protocol,
             l.req_method,
             l.req_uri,
             l.req_query,
             l.log_referer,
             l.log_useragent,
             l.server_name,
             l.server_port,
             l.importfileid,
             f.server_name server_name_file,
             f.server_port server_port_file,
             l.id
        FROM load_access_nginx l
  INNER JOIN import_file f
          ON l.importfileid = f.id
       WHERE l.process_status = 1
         AND f.importloadid = importLoad_ID;
  -- declare cursor for combined format - single importLoadID
  DECLARE combinedLoadIDFile CURSOR FOR
      SELECT DISTINCT(l.importfileid)
        FROM load_access_nginx l
  INNER JOIN import_file f
          ON l.importfileid = f.id
       WHERE l.process_status = 1
         AND f.importloadid = importLoad_ID;
  -- declare NOT FOUND handler
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE, e4 = SCHEMA_NAME, e5 = CATALOG_NAME;
      CALL errorProcess('import_access_nginx', e1, e2, e3, e4, e5, importLoad_ID, importProcessID);
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
  SET importProcessID = importServerProcessID('access_import', in_processName, importLoad_ID);
  IF importLoad_ID IS NULL THEN
    IF in_processName = 'csv2mysql' THEN
      SELECT COUNT(DISTINCT(f.importloadid))
        INTO loads_processed
        FROM load_access_csv l
  INNER JOIN import_file f
          ON l.importfileid = f.id
       WHERE l.process_status = 1;
      ELSEIF in_processName = 'vhost' THEN
      SELECT COUNT(DISTINCT(f.importloadid))
        INTO loads_processed
        FROM load_access_vhost l
  INNER JOIN import_file f
          ON l.importfileid = f.id
       WHERE l.process_status = 1;
    ELSEIF in_processName = 'combined' THEN
      SELECT COUNT(DISTINCT(f.importloadid))
        INTO loads_processed
        FROM load_access_nginx l
  INNER JOIN import_file f
          ON l.importfileid = f.id
       WHERE l.process_status = 1;
    END IF;
  END IF;
--  SET importProcessID = importServerProcessID('access_import', in_processName);
  START TRANSACTION;
  -- process import_file TABLE first
  IF in_processName = 'combined' AND importLoad_ID IS NULL THEN
    OPEN combinedStatusFile;
  ELSE
    OPEN combinedLoadIDFile;
  END IF;
  process_import_file: LOOP
    IF in_processName = 'combined' AND importLoad_ID IS NULL THEN
      FETCH combinedStatusFile INTO importFileCheck_ID;
    ELSE
      FETCH combinedLoadIDFile INTO importFileCheck_ID;
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
  IF in_processName = 'combined' AND importLoad_ID IS NULL THEN
    CLOSE combinedStatusFile;
  ELSE
    CLOSE combinedLoadIDFile;
  END IF;
  -- process records
  SET done = false;
  IF in_processName = 'combined' AND importLoad_ID IS NULL THEN
    OPEN combinedStatus;
  ELSE
    OPEN combinedLoadID;
  END IF;
  process_import: LOOP
    IF in_processName = 'combined' AND importLoad_ID IS NULL THEN
      FETCH combinedStatus INTO
            client,
            remoteLogName,
            remoteUser,
            logTime,
            reqBytes,
            reqStatus,
            reqProtocol,
            reqMethod,
            reqUri,
            reqQuery,
            referer,
            userAgent,
            server,
            serverPort,
            importFile_ID,
            serverFile,
            serverPortFile,
            importRecordID; 
    ELSE
      FETCH combinedLoadID INTO
            client,
            remoteLogName,
            remoteUser,
            logTime,
            reqBytes,
            reqStatus,
            reqProtocol,
            reqMethod,
            reqUri,
            reqQuery,
            referer,
            userAgent,
            server,
            serverPort,
            importFile_ID,
            serverFile,
            serverPortFile,
            importRecordID;
    END IF;
    IF done = true THEN
      LEAVE process_import;
    END IF;
    SET records_processed = records_processed + 1;
    SET remoteLogName_Id = null,
        remoteUser_Id = null,
        reqStatus_Id = null,
        reqProtocol_Id = null,
        reqMethod_Id = null,
        reqUri_Id = null,
        reqQuery_Id = null,
        referer_Id = null,
        userAgent_Id = null,
        logCookie_Id = null,
        client_Id = null,
        server_Id = null,
        serverPort_Id = null,
        requestLog_Id = null;
    -- any customizing for business needs should be done here before normalization functions called.
    -- convert import staging columns - reqQuery, referer, log_time and log_cookie in import for audit purposes
    IF LOCATE("?", reqQuery)>0 THEN
      SET reqQueryConverted = SUBSTR(reqQuery, LOCATE("?", reqQuery)+1);
    ELSE
      SET reqQueryConverted = reqQuery;
    END IF;
    IF LOCATE("?", referer)>0 THEN
      SET refererConverted = SUBSTR(referer,1,LOCATE("?", referer)-1);
    ELSE
      SET refererConverted = referer;
    END IF;
    IF LOCATE("[", logTime)>0 THEN
      SET logTimeConverted = STR_TO_DATE(SUBSTR(logTime, 2, 20), '%d/%b/%Y:%H:%i:%s');
    ELSE
      SET logTimeConverted = STR_TO_DATE(SUBSTR(logTime, 1, 20), '%d/%b/%Y:%H:%i:%s');
    END IF;
    IF logCookie IS NULL OR logCookie = '-' THEN
      SET logCookieConverted = NULL;
    ELSEIF LOCATE('.', logCookie) > 0 THEN
      SET logCookieConverted = SUBSTR(logCookie, 3, LOCATE('.', logCookie)-3);
    ELSE
      SET logCookieConverted = logCookie;
    END IF;
    -- normalize import staging table
    IF reqProtocol IS NOT NULL THEN
      SET reqProtocol_Id = access_reqProtocolID(reqProtocol);
    END IF;
    IF reqMethod IS NOT NULL THEN
      SET reqMethod_Id = access_reqMethodID(reqMethod);
    END IF;
    IF reqStatus IS NOT NULL THEN
      SET reqStatus_Id = access_reqStatusID(reqStatus);
    END IF;
    IF reqUri IS NOT NULL THEN
      SET reqUri_Id = access_reqUriID(reqUri);
    END IF;
    IF reqQueryConverted IS NOT NULL THEN
      SET reqQuery_Id = access_reqQueryID(reqQueryConverted);
    END IF;
    IF remoteLogName IS NOT NULL AND remoteLogName != '-' THEN
      SET remoteLogName_Id = access_remoteLogNameID(remoteLogName);
    END IF;
    IF remoteUser IS NOT NULL AND remoteUser != '-' THEN
      SET remoteUser_Id = access_remoteUserID(remoteUser);
    END IF;
    IF userAgent IS NOT NULL THEN
      SET userAgent_Id = access_userAgentID(userAgent);
    END IF;
    IF logCookieConverted IS NOT NULL THEN
      SET logCookie_Id = access_cookieID(logCookieConverted);
    END IF;
    IF refererConverted IS NOT NULL AND refererConverted != '-' THEN
      SET referer_Id = log_refererID(refererConverted);
    END IF;
    IF client IS NOT NULL THEN
      SET client_Id = log_clientID(client);
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
    INSERT INTO access_log
      (logged,
       bytes_received,
       bytes_sent,
       bytes_transferred,
       reqtime_milli,
       reqtime_micro,
       reqdelay_milli,
       reqbytes,
       reqstatusid,
       reqprotocolid,
       reqmethodid,
       requriid,
       reqqueryid,
       remotelognameid,
       remoteuserid,
       useragentid,
       cookieid,
       refererid,
       clientid,
       serverid,
       serverportid,
       requestlogid,
       importfileid)
    VALUES
      (logTimeConverted,
       bytesReceived,
       bytesSent,
       bytesTransferred,
       reqTimeMilli,
       reqTimeMicro,
       reqDelayMilli,
       reqBytes,
       reqStatus_Id,
       reqProtocol_Id,
       reqMethod_Id,
       reqUri_Id,
       reqQuery_Id,
       remoteLogName_Id,
       remoteUser_Id,
       userAgent_Id,
       logCookie_Id,
       referer_Id,
       client_Id,
       server_Id,
       serverPort_Id,
       requestLog_Id,
       importFile_ID);
    UPDATE load_access_nginx SET process_status=2 WHERE id=importRecordID;
  END LOOP process_import;
  -- to remove SQL calculating loads_processed when importLoad_ID is passed. Set=1 by default.
  IF importLoad_ID IS NOT NULL AND records_processed=0 THEN
    SET loads_processed = 0;
  END IF;
  -- update import server process table
  UPDATE import_process
     SET recordsprocessed = records_processed,
         filesprocessed = files_processed,
         loadsprocessed = loads_processed,
         completed = now(),
         errorCount = processErrors,
         processSeconds = TIME_TO_SEC(TIMEDIFF(now(), started))
   WHERE id = importProcessID;
  COMMIT;
  IF in_processName = 'combined' AND importLoad_ID IS NULL THEN
    CLOSE combinedStatus;
  ELSE
    CLOSE combinedLoadID;
  END IF;
END//
DELIMITER ;
