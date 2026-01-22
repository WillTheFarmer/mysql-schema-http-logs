-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `load_access_nginx`;
-- create table ---------------------------------------------------------
-- LogFormat "%h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" combined
-- LogFormat "%h %l %u %t \"%r\" %>s %O" common
CREATE TABLE `load_access_nginx` (
    remote_host VARCHAR(300) DEFAULT NULL COMMENT '253 characters is the maximum length of full domain name. Renamed as client and clientport in normalization to share with Error Logs',
    remote_logname VARCHAR(150) DEFAULT NULL COMMENT 'This will return a dash unless mod_ident is present and IdentityCheck is set On.',
    remote_user VARCHAR(150) DEFAULT NULL COMMENT 'Remote user if the request was authenticated. May be bogus if return status (%s) is 401 (unauthorized).',
    log_time_a VARCHAR(21) DEFAULT NULL COMMENT 'due to MySQL LOAD DATA LOCAL INFILE limitations can not have 2 OPTIONALLY ENCLOSED BY "" and []. It is easier with 2 columns for this data',
    log_time_b VARCHAR(6) DEFAULT NULL COMMENT 'to simplify import and use MySQL LOAD DATA LOCAL INFILE. I have python script to import standard combined but this keeps it all in MySQL',
    first_line_request VARCHAR(8190) DEFAULT NULL COMMENT 'contains req_method, req_uri, req_query, req_protocol - Default:	LimitRequestLine 8190 - https://httpd.apache.org/docs/2.2/mod/core.html#limitrequestline',
    req_status INT DEFAULT NULL,
    req_bytes INT DEFAULT NULL,
    log_referer VARCHAR(750) DEFAULT NULL COMMENT '1000 characters should be more than enough for domain.',
    log_useragent VARCHAR(1000) DEFAULT NULL COMMENT 'No strict size limit of User-Agent string is defined by official standards or specifications. 2 years of production logs found useragents longer than 1000 are hack attempts.',
    load_error VARCHAR(50) DEFAULT NULL COMMENT 'This column should always be NULL. Added to catch lines larger than designed for.',
    log_time VARCHAR(28) DEFAULT NULL,
    req_protocol VARCHAR(30) DEFAULT NULL COMMENT 'parsed from first_line_request in import',
    req_method VARCHAR(50) DEFAULT NULL COMMENT 'parsed from first_line_request in import',
    req_uri VARCHAR(2000) DEFAULT NULL COMMENT 'parsed from first_line_request in import. URLs under 2000 characters work in any combination of client and server software and search engines.',
    req_query VARCHAR(3390) DEFAULT NULL COMMENT 'parsed from first_line_request in import. Can not make 5000 due to table max length. From reviewing 3 years of production logs no query strings were over 2165.',
    server_name VARCHAR(253) DEFAULT NULL COMMENT 'Common & Combined logs. Added to populate Server for multiple domains import. Must be poulated before import process.',
    server_port INT DEFAULT NULL COMMENT 'Common & Combined logs. Added to populate ServerPort for multiple domains import. Must be poulated before import process.',
    importfileid INT DEFAULT NULL COMMENT 'used in import process to indicate file record extractedd from',
    process_status INT NOT NULL DEFAULT 0 COMMENT 'used in parse and import processes to indicate record processed - 1=parsed, 2=imported',
    id INT AUTO_INCREMENT PRIMARY KEY
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Used for LOAD DATA command for LogFormat combined and common to bring text files into MySQL and start the process.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `load_access_csv`;
-- create table ---------------------------------------------------------
-- LogFormat "%v,%p,%h,%t,%I,%O,%S,%B,%{ms}T,%D,%^FB,%>s,\"%H\",\"%m\",\"%U\",\"%q\",\"%{Referer}i\",\"%{User-Agent}i\",\"%{farmwork.app}C\"" csv2mysql
CREATE TABLE `load_access_csv` (
    server_name VARCHAR(253) DEFAULT NULL COMMENT '253 characters is the maximum length of full domain name, including dots: e.g. www.example.com = 15 characters.',
    server_port INT DEFAULT NULL,
    remote_host VARCHAR(300) DEFAULT NULL COMMENT '253 characters is the maximum length of full domain name. Renamed as client and clientport in normalization to share with Error Logs',
    remote_logname VARCHAR(150) DEFAULT NULL COMMENT 'This will return a dash unless mod_ident is present and IdentityCheck is set On.',
    remote_user VARCHAR(150) DEFAULT NULL COMMENT 'Remote user if the request was authenticated. May be bogus if return status (%s) is 401 (unauthorized).',
    log_time VARCHAR(28) DEFAULT NULL,
    bytes_received INT DEFAULT NULL,
    bytes_sent INT DEFAULT NULL,
    bytes_transferred INT DEFAULT NULL,
    reqtime_milli INT DEFAULT NULL,
    reqtime_micro INT DEFAULT NULL,
    reqdelay_milli INT DEFAULT NULL,
    req_bytes INT DEFAULT NULL,
    req_status INT DEFAULT NULL,
    req_protocol VARCHAR(30) DEFAULT NULL,
    req_method VARCHAR(50) DEFAULT NULL,
    req_uri VARCHAR(2000) DEFAULT NULL COMMENT 'URLs under 2000 characters work in any combination of client and server software and search engines.',
    req_query VARCHAR(5000) DEFAULT NULL COMMENT 'The %q query string can get long with AJAX REST database updates passing recordsets can get BIG but 2000 to 3000 should be MAX used.',
    log_referer VARCHAR(750) DEFAULT NULL COMMENT '1000 characters should be more than enough for domain.',
    log_useragent VARCHAR(1000) DEFAULT NULL COMMENT 'No strict size limit of User-Agent string is defined by official standards or specifications. 2 years of production logs found useragents longer than 1000 are hack attempts.',
    log_cookie VARCHAR(400) DEFAULT NULL COMMENT 'Use to store any Cookie VARNAME. ie - session ID in application cookie to relate with login tables on server.',
    request_log_id VARCHAR(50) DEFAULT NULL COMMENT 'The request log ID from the error log (or - if nothing has been logged to the error log for this request). Look for the matching error log line to see what request caused what error.',
    load_error VARCHAR(10) DEFAULT NULL COMMENT 'This column should always be NULL. Added to catch lines larger than designed for.',
    importfileid INT DEFAULT NULL COMMENT 'used in import process to indicate file record extractedd from',
    process_status INT NOT NULL DEFAULT 0 COMMENT 'used in parse and import processes to indicate record processed - 1=parsed, 2=imported',
    id INT AUTO_INCREMENT PRIMARY KEY
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Used for LOAD DATA command for LogFormat csv2mysql to bring text files into MySQL and start the process.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `load_access_combined`;
-- create table ---------------------------------------------------------
-- LogFormat "%h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" combined
-- LogFormat "%h %l %u %t \"%r\" %>s %O" common
CREATE TABLE `load_access_combined` (
    remote_host VARCHAR(300) DEFAULT NULL COMMENT '253 characters is the maximum length of full domain name. Renamed as client and clientport in normalization to share with Error Logs',
    remote_logname VARCHAR(150) DEFAULT NULL COMMENT 'This will return a dash unless mod_ident is present and IdentityCheck is set On.',
    remote_user VARCHAR(150) DEFAULT NULL COMMENT 'Remote user if the request was authenticated. May be bogus if return status (%s) is 401 (unauthorized).',
    log_time_a VARCHAR(21) DEFAULT NULL COMMENT 'due to MySQL LOAD DATA LOCAL INFILE limitations can not have 2 OPTIONALLY ENCLOSED BY "" and []. It is easier with 2 columns for this data',
    log_time_b VARCHAR(6) DEFAULT NULL COMMENT 'to simplify import and use MySQL LOAD DATA LOCAL INFILE. I have python script to import standard combined but this keeps it all in MySQL',
    first_line_request VARCHAR(8190) DEFAULT NULL COMMENT 'contains req_method, req_uri, req_query, req_protocol - Default:	LimitRequestLine 8190 - https://httpd.apache.org/docs/2.2/mod/core.html#limitrequestline',
    req_status INT DEFAULT NULL,
    req_bytes INT DEFAULT NULL,
    log_referer VARCHAR(750) DEFAULT NULL COMMENT '1000 characters should be more than enough for domain.',
    log_useragent VARCHAR(1000) DEFAULT NULL COMMENT 'No strict size limit of User-Agent string is defined by official standards or specifications. 2 years of production logs found useragents longer than 1000 are hack attempts.',
    load_error VARCHAR(50) DEFAULT NULL COMMENT 'This column should always be NULL. Added to catch lines larger than designed for.',
    log_time VARCHAR(28) DEFAULT NULL,
    req_protocol VARCHAR(30) DEFAULT NULL COMMENT 'parsed from first_line_request in import',
    req_method VARCHAR(50) DEFAULT NULL COMMENT 'parsed from first_line_request in import',
    req_uri VARCHAR(2000) DEFAULT NULL COMMENT 'parsed from first_line_request in import. URLs under 2000 characters work in any combination of client and server software and search engines.',
    req_query VARCHAR(3390) DEFAULT NULL COMMENT 'parsed from first_line_request in import. Can not make 5000 due to table max length. From reviewing 3 years of production logs no query strings were over 2165.',
    server_name VARCHAR(253) DEFAULT NULL COMMENT 'Common & Combined logs. Added to populate Server for multiple domains import. Must be poulated before import process.',
    server_port INT DEFAULT NULL COMMENT 'Common & Combined logs. Added to populate ServerPort for multiple domains import. Must be poulated before import process.',
    importfileid INT DEFAULT NULL COMMENT 'used in import process to indicate file record extractedd from',
    process_status INT NOT NULL DEFAULT 0 COMMENT 'used in parse and import processes to indicate record processed - 1=parsed, 2=imported',
    id INT AUTO_INCREMENT PRIMARY KEY
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Used for LOAD DATA command for LogFormat combined and common to bring text files into MySQL and start the process.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `load_access_vhost`;
-- create table ---------------------------------------------------------
-- LogFormat "%v:%p %h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" vhost_combined
CREATE TABLE `load_access_vhost` (
    log_server VARCHAR(300) DEFAULT NULL COMMENT '253 characters is the maximum length of full domain name, including dots: e.g. www.example.com = 15 characters. plus : plus 6 for port',
    remote_host VARCHAR(300) DEFAULT NULL COMMENT '253 characters is the maximum length of full domain name. Renamed as client and clientport in normalization to share with Error Logs',
    remote_logname VARCHAR(150) DEFAULT NULL COMMENT 'This will return a dash unless mod_ident is present and IdentityCheck is set On.',
    remote_user VARCHAR(150) DEFAULT NULL COMMENT 'Remote user if the request was authenticated. May be bogus if return status (%s) is 401 (unauthorized).',
    log_time_a VARCHAR(21) DEFAULT NULL COMMENT 'due to MySQL LOAD DATA LOCAL INFILE limitations can not have 2 OPTIONALLY ENCLOSED BY "" and []. It is easier with 2 columns for this data',
    log_time_b VARCHAR(6) DEFAULT NULL COMMENT 'to simplify import and use MySQL LOAD DATA LOCAL INFILE. I have python script to import standard combined but this keeps it all in MySQL',
    first_line_request VARCHAR(8190) DEFAULT NULL COMMENT 'contains req_method, req_uri, req_query, req_protocol - Default:	LimitRequestLine 8190 - https://httpd.apache.org/docs/2.2/mod/core.html#limitrequestline',
    req_status INT DEFAULT NULL,
    req_bytes INT DEFAULT NULL,
    log_referer VARCHAR(750) DEFAULT NULL COMMENT '1000 characters should be more than enough for domain.',
    log_useragent VARCHAR(1000) DEFAULT NULL COMMENT 'No strict size limit of User-Agent string is defined by official standards or specifications. 2 years of production logs found useragents longer than 1000 are hack attempts.',
    load_error VARCHAR(50) DEFAULT NULL COMMENT 'This column should always be NULL. Added to catch lines larger than designed for.',
    log_time VARCHAR(28) DEFAULT NULL,
    server_name VARCHAR(253) DEFAULT NULL COMMENT '253 characters is the maximum length of full domain name, including dots: e.g. www.example.com = 15 characters.',
    server_port INT DEFAULT NULL,
    req_protocol VARCHAR(30) DEFAULT NULL COMMENT 'parsed from first_line_request in import',
    req_method VARCHAR(50) DEFAULT NULL COMMENT 'parsed from first_line_request in import',
    req_uri VARCHAR(2000) DEFAULT NULL COMMENT 'parsed from first_line_request in import. URLs under 2000 characters work in any combination of client and server software and search engines.',
    req_query VARCHAR(3090) DEFAULT NULL COMMENT 'parsed from first_line_request in import. Can not make 5000 due to table max length. From reviewing 3 years of production logs no query strings were over 2165.',
    importfileid INT DEFAULT NULL COMMENT 'used in import process to indicate file record extractedd from',
    process_status INT NOT NULL DEFAULT 0 COMMENT 'used in parse and import processes to indicate record processed - 1=parsed, 2=imported',
    id INT AUTO_INCREMENT PRIMARY KEY
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Used for LOAD DATA command for LogFormat vhost to bring text files into MySQL and start the process.';
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_reqstatus`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_reqstatus` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name INT NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_reqprotocol`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_reqprotocol` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_reqmethod`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_reqmethod` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_requri`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_requri` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(2000) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_reqquery`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_reqquery` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(5000) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_remotelogname`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_remotelogname` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_remoteuser`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_remoteuser` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_useragent`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_useragent` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(1000) NOT NULL,
    ua VARCHAR(300) DEFAULT NULL,
    ua_browser VARCHAR(300) DEFAULT NULL,
    ua_browser_family VARCHAR(300) DEFAULT NULL,
    ua_browser_version VARCHAR(300) DEFAULT NULL,
    ua_device VARCHAR(300) DEFAULT NULL,
    ua_device_family VARCHAR(300) DEFAULT NULL,
    ua_device_brand VARCHAR(300) DEFAULT NULL,
    ua_device_model VARCHAR(300) DEFAULT NULL,
    ua_os VARCHAR(300) DEFAULT NULL,
    ua_os_family VARCHAR(300) DEFAULT NULL,
    ua_os_version VARCHAR(300) DEFAULT NULL,
    uaid INT DEFAULT NULL,
    uabrowserid INT DEFAULT NULL,
    uabrowserfamilyid INT DEFAULT NULL,
    uabrowserversionid INT DEFAULT NULL,
    uadeviceid INT DEFAULT NULL,
    uadevicefamilyid INT DEFAULT NULL,
    uadevicebrandid INT DEFAULT NULL,
    uadevicemodelid INT DEFAULT NULL,
    uaosid INT DEFAULT NULL,
    uaosfamilyid INT DEFAULT NULL,
    uaosversionid INT DEFAULT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_ua`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_ua` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_ua_browser`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_ua_browser` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_ua_browser_family`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_ua_browser_family` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_ua_browser_version`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_ua_browser_version` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_ua_device`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_ua_device` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_ua_device_family`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_ua_device_family` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_ua_device_brand`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_ua_device_brand` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_ua_device_model`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_ua_device_model` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_ua_os`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_ua_os` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_ua_os_family`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_ua_os_family` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_ua_os_version`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_ua_os_version` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log_cookie`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log_cookie` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(400) NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- drop table -----------------------------------------------------------
DROP TABLE IF EXISTS `access_log`;
-- create table ---------------------------------------------------------
CREATE TABLE `access_log` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    logged DATETIME NOT NULL,
    serverid INT DEFAULT NULL COMMENT '%v	The canonical Server of the server serving the request. Access & Error shared normalization table - log_server',
    serverportid INT DEFAULT NULL COMMENT '%p	The canonical port of the server serving the request. Access & Error shared normalization table - log_serverport',
    clientid INT DEFAULT NULL COMMENT 'This is %h - Remote hostname (default) for Access Log or %a - Client IP address and port of the request for Error and Access logs.',
    clientportid INT DEFAULT NULL COMMENT 'a% - Client IP address and port of the request - Default for Error logs and can be used in Access Log LogFormat. Port value is derived from it.',
    refererid INT DEFAULT NULL COMMENT '%{Referer}i - Access & Error shared normalization table - log_referer',
    requestlogid INT DEFAULT NULL COMMENT '%L	Log ID of the request - Access & Error shared normalization table - log_requestlogid',
    bytes_received INT NOT NULL,
    bytes_sent INT NOT NULL,
    bytes_transferred INT NOT NULL,
    reqtime_milli INT NOT NULL,
    reqtime_micro INT NOT NULL,
    reqdelay_milli INT NOT NULL,
    reqbytes INT NOT NULL,
    reqstatusid INT DEFAULT NULL,
    reqprotocolid INT DEFAULT NULL,
    reqmethodid INT DEFAULT NULL,
    requriid INT DEFAULT NULL,
    reqqueryid INT DEFAULT NULL,
    remoteuserid INT DEFAULT NULL,
    remotelognameid INT DEFAULT NULL,
    cookieid INT DEFAULT NULL,
    useragentid INT DEFAULT NULL,
    importfileid INT NOT NULL,
    added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table is core table for access logs and contains foreign keys to relate to log attribute tables.';