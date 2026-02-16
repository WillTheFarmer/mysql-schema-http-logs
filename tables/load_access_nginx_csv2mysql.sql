DROP TABLE IF EXISTS `load_access_nginx_csv2mysql`;
-- create table ---------------------------------------------------------
-- LogFormat "%v,%p,%h,%t,%I,%O,%S,%B,%{ms}T,%D,%^FB,%>s,\"%H\",\"%m\",\"%U\",\"%q\",\"%{Referer}i\",\"%{User-Agent}i\",\"%{farmwork.app}C\"" csv2mysql
CREATE TABLE `load_access_nginx_csv2mysql` (
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
    importfileid BIGINT UNSIGNED DEFAULT NULL COMMENT 'used in import process to indicate file record extractedd from',
    process_status INT NOT NULL DEFAULT 0 COMMENT 'used in parse and import processes to indicate record processed - 1=parsed, 2=imported',
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Used for LOAD DATA command for LogFormat csv2mysql to bring text files into MySQL and start the process.';
