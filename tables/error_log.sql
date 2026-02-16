DROP TABLE IF EXISTS `error_log`;
-- create table ---------------------------------------------------------
CREATE TABLE `error_log` (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    logged DATETIME NOT NULL,
    serverid INT UNSIGNED DEFAULT NULL COMMENT '%v	The canonical Server of the server serving the request. Access & Error shared normalization table - log_server',
    serverportid INT UNSIGNED DEFAULT NULL COMMENT '%p	The canonical port of the server serving the request. Access & Error shared normalization table - log_serverport',
    clientid BIGINT UNSIGNED DEFAULT NULL COMMENT 'This is %h - Remote hostname (default) for Access Log or %a - Client IP address and port of the request for Error and Access logs.',
    clientportid INT UNSIGNED DEFAULT NULL COMMENT 'a% - Client IP address and port of the request - Default for Error logs and can be used in Access Log LogFormat. Port value is derived from it.',
    refererid INT UNSIGNED DEFAULT NULL COMMENT '%{Referer}i - Access & Error shared normalization table - log_referer',
    requestlogid BIGINT UNSIGNED DEFAULT NULL COMMENT '%L	Log ID of the request - Access & Error shared normalization table - log_requestlogid',
    loglevelid INT UNSIGNED DEFAULT NULL,
    moduleid INT UNSIGNED DEFAULT NULL,
    processid INT UNSIGNED DEFAULT NULL,
    threadid INT UNSIGNED DEFAULT NULL,
    httpcodeid INT UNSIGNED DEFAULT NULL,
    httpmessageid INT UNSIGNED DEFAULT NULL,
    systemcodeid INT UNSIGNED DEFAULT NULL,
    systemmessageid INT UNSIGNED DEFAULT NULL,
    logmessageid INT UNSIGNED DEFAULT NULL,
    importfileid BIGINT UNSIGNED NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
