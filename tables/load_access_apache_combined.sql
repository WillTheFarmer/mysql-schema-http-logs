DROP TABLE IF EXISTS `load_access_apache_combined`;
-- create table ---------------------------------------------------------
-- LogFormat "%h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" combined
-- LogFormat "%h %l %u %t \"%r\" %>s %O" common
CREATE TABLE `load_access_apache_combined` (
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
    importfileid BIGINT UNSIGNED DEFAULT NULL COMMENT 'used in import process to indicate file record extractedd from',
    process_status INT NOT NULL DEFAULT 0 COMMENT 'used in parse and import processes to indicate record processed - 1=parsed, 2=imported',
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Used for LOAD DATA command for LogFormat combined and common to bring text files into MySQL and start the process.';
