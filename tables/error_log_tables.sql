-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `load_error_nginx`;
-- create table ---------------------------------------------------------
-- default format - ErrorLogFormat "[%{u}t] [%-m:%l] [pid %P:tid %T] %7F: %E: [client\ %a] %M% ,\ referer\ %{Referer}i"
-- additional format - ErrorLogFormat "[%{u}t] [%-m:%l] [pid %P:tid %T] %7F: %E: [client\ %a] %M% ,\ referer\ %{Referer}i ,%v ,%L"
CREATE TABLE `load_error_nginx` (
    log_time VARCHAR(50) DEFAULT NULL,
    log_mod_level VARCHAR(200) DEFAULT NULL,
    log_processid_threadid VARCHAR(200) DEFAULT NULL,
    log_parse1 VARCHAR(2500) DEFAULT NULL,
    log_parse2 VARCHAR(2500) DEFAULT NULL,
    log_message_nocode VARCHAR(1000) DEFAULT NULL,
    load_error VARCHAR(50) DEFAULT NULL COMMENT 'This column should always be NULL. Added to catch lines larger than designed for.',
    logtime DATETIME DEFAULT NULL,
    loglevel VARCHAR(100) DEFAULT NULL,
    module VARCHAR(200) DEFAULT NULL,
    processid VARCHAR(100) DEFAULT NULL,
    threadid VARCHAR(100) DEFAULT NULL,
    httpcode VARCHAR(200) DEFAULT NULL,
    httpmessage VARCHAR(810) DEFAULT NULL COMMENT '500 is normalized table column size + 310 - 253:server_name, 50:request_log_id, 4:commas-spaces to be removed in process_error_parse',
    systemcode VARCHAR(200) DEFAULT NULL,
    systemmessage VARCHAR(810) DEFAULT NULL COMMENT '500 is normalized table column size + 310 - 253:server_name, 50:request_log_id, 4:commas-spaces to be removed in process_error_parse',
    logmessage VARCHAR(810) DEFAULT NULL COMMENT '500 is normalized table column size + 310 - 253:server_name, 50:request_log_id, 4:commas-spaces to be removed in process_error_parse',
    referer VARCHAR(1060) DEFAULT NULL COMMENT '750 is normalized table column size + 310 - 253:server_name, 50:request_log_id, 4:commas-spaces to be removed in process_error_parse',
    client_name VARCHAR(253) DEFAULT NULL COMMENT 'Column to normalize Access & Error attributes with different names. From Error Log Format %a - Client IP (address) and port of the request.',
    client_port INT DEFAULT NULL COMMENT 'Column to normalize Access & Error attributes with different names. From Error Log Format %a - Client IP address and (port) of the request.',
    server_name VARCHAR(253) DEFAULT NULL COMMENT 'Error logs. Added to populate Server for multiple domains import. Must be poulated before import process.',
    server_port INT DEFAULT NULL COMMENT 'Error logs. Added to populate ServerPort for multiple domains import. Must be poulated before import process.',
    request_log_id VARCHAR(50) DEFAULT NULL COMMENT 'Log ID of the request',
    importfileid INT DEFAULT NULL COMMENT 'FOREIGN KEY used in import process to indicate file record extracted from',
    process_status INT NOT NULL DEFAULT 0 COMMENT 'used in parse and import processes to indicate record processed - 1=parsed, 2=imported',
    id INT AUTO_INCREMENT PRIMARY KEY
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table used for LOAD DATA command to bring text files into MySQL and start the process.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `load_error_apache`;
-- create table ---------------------------------------------------------
-- default format - ErrorLogFormat "[%{u}t] [%-m:%l] [pid %P:tid %T] %7F: %E: [client\ %a] %M% ,\ referer\ %{Referer}i"
-- additional format - ErrorLogFormat "[%{u}t] [%-m:%l] [pid %P:tid %T] %7F: %E: [client\ %a] %M% ,\ referer\ %{Referer}i ,%v ,%L"
CREATE TABLE `load_error_apache` (
    log_time VARCHAR(50) DEFAULT NULL,
    log_mod_level VARCHAR(200) DEFAULT NULL,
    log_processid_threadid VARCHAR(200) DEFAULT NULL,
    log_parse1 VARCHAR(2500) DEFAULT NULL,
    log_parse2 VARCHAR(2500) DEFAULT NULL,
    log_message_nocode VARCHAR(1000) DEFAULT NULL,
    load_error VARCHAR(50) DEFAULT NULL COMMENT 'This column should always be NULL. Added to catch lines larger than designed for.',
    logtime DATETIME DEFAULT NULL,
    loglevel VARCHAR(100) DEFAULT NULL,
    module VARCHAR(200) DEFAULT NULL,
    processid VARCHAR(100) DEFAULT NULL,
    threadid VARCHAR(100) DEFAULT NULL,
    httpcode VARCHAR(200) DEFAULT NULL,
    httpmessage VARCHAR(810) DEFAULT NULL COMMENT '500 is normalized table column size + 310 - 253:server_name, 50:request_log_id, 4:commas-spaces to be removed in process_error_parse',
    systemcode VARCHAR(200) DEFAULT NULL,
    systemmessage VARCHAR(810) DEFAULT NULL COMMENT '500 is normalized table column size + 310 - 253:server_name, 50:request_log_id, 4:commas-spaces to be removed in process_error_parse',
    logmessage VARCHAR(810) DEFAULT NULL COMMENT '500 is normalized table column size + 310 - 253:server_name, 50:request_log_id, 4:commas-spaces to be removed in process_error_parse',
    referer VARCHAR(1060) DEFAULT NULL COMMENT '750 is normalized table column size + 310 - 253:server_name, 50:request_log_id, 4:commas-spaces to be removed in process_error_parse',
    client_name VARCHAR(253) DEFAULT NULL COMMENT 'Column to normalize Access & Error attributes with different names. From Error Log Format %a - Client IP (address) and port of the request.',
    client_port INT DEFAULT NULL COMMENT 'Column to normalize Access & Error attributes with different names. From Error Log Format %a - Client IP address and (port) of the request.',
    server_name VARCHAR(253) DEFAULT NULL COMMENT 'Error logs. Added to populate Server for multiple domains import. Must be poulated before import process.',
    server_port INT DEFAULT NULL COMMENT 'Error logs. Added to populate ServerPort for multiple domains import. Must be poulated before import process.',
    request_log_id VARCHAR(50) DEFAULT NULL COMMENT 'Log ID of the request',
    importfileid INT DEFAULT NULL COMMENT 'FOREIGN KEY used in import process to indicate file record extracted from',
    process_status INT NOT NULL DEFAULT 0 COMMENT 'used in parse and import processes to indicate record processed - 1=parsed, 2=imported',
    id INT AUTO_INCREMENT PRIMARY KEY
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table used for LOAD DATA command to bring text files into MySQL and start the process.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `error_log_module`;
-- create table ---------------------------------------------------------
CREATE TABLE `error_log_module` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `error_log_level`;
-- create table ---------------------------------------------------------
CREATE TABLE `error_log_level` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `error_log_processid`;
-- create table ---------------------------------------------------------
CREATE TABLE `error_log_processid` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `error_log_threadid`;
-- create table ---------------------------------------------------------
CREATE TABLE `error_log_threadid` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `error_log_httpcode`;
-- create table ---------------------------------------------------------
CREATE TABLE `error_log_httpcode` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `error_log_httpmessage`;
-- create table ---------------------------------------------------------
CREATE TABLE `error_log_httpmessage` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(500) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `error_log_systemcode`;
-- create table ---------------------------------------------------------
CREATE TABLE `error_log_systemcode` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `error_log_systemmessage`;
-- create table ---------------------------------------------------------
CREATE TABLE `error_log_systemmessage` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(500) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `error_log_message`;
-- create table ---------------------------------------------------------
CREATE TABLE `error_log_message` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(500) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `error_log`;
-- create table ---------------------------------------------------------
CREATE TABLE `error_log` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    logged DATETIME NOT NULL,
    serverid INT DEFAULT NULL COMMENT '%v	The canonical Server of the server serving the request. Access & Error shared normalization table - log_server',
    serverportid INT DEFAULT NULL COMMENT '%p	The canonical port of the server serving the request. Access & Error shared normalization table - log_serverport',
    clientid INT DEFAULT NULL COMMENT 'This is %h - Remote hostname (default) for Access Log or %a - Client IP address and port of the request for Error and Access logs.',
    clientportid INT DEFAULT NULL COMMENT 'a% - Client IP address and port of the request - Default for Error logs and can be used in Access Log LogFormat. Port value is derived from it.',
    refererid INT DEFAULT NULL COMMENT '%{Referer}i - Access & Error shared normalization table - log_referer',
    requestlogid INT DEFAULT NULL COMMENT '%L	Log ID of the request - Access & Error shared normalization table - log_requestlogid',
    loglevelid INT DEFAULT NULL,
    moduleid INT DEFAULT NULL,
    processid INT DEFAULT NULL,
    threadid INT DEFAULT NULL,
    httpcodeid INT DEFAULT NULL,
    httpmessageid INT DEFAULT NULL,
    systemcodeid INT DEFAULT NULL,
    systemmessageid INT DEFAULT NULL,
    logmessageid INT DEFAULT NULL,
    importfileid INT NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;