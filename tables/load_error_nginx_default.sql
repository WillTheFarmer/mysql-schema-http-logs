-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `load_error_nginx_default`;
-- create table ---------------------------------------------------------
-- default format - ErrorLogFormat "[%{u}t] [%-m:%l] [pid %P:tid %T] %7F: %E: [client\ %a] %M% ,\ referer\ %{Referer}i"
-- additional format - ErrorLogFormat "[%{u}t] [%-m:%l] [pid %P:tid %T] %7F: %E: [client\ %a] %M% ,\ referer\ %{Referer}i ,%v ,%L"
CREATE TABLE `load_error_nginx_default` (
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
    importfileid BIGINT UNSIGNED DEFAULT NULL COMMENT 'FOREIGN KEY used in import process to indicate file record extracted from',
    process_status INT NOT NULL DEFAULT 0 COMMENT 'used in parse and import processes to indicate record processed - 1=parsed, 2=imported',
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table used for LOAD DATA command to bring text files into MySQL and start the process.';
