-- UNIQUE Indexes
ALTER TABLE `log_client` ADD CONSTRAINT `U_log_client` UNIQUE (name);
ALTER TABLE `log_client_city` ADD CONSTRAINT `U_log_client_city` UNIQUE (name);
ALTER TABLE `log_client_coordinate` ADD CONSTRAINT `U_log_client_coordinate` UNIQUE (latitude, longitude);
ALTER TABLE `log_client_country` ADD CONSTRAINT `U_log_client_country` UNIQUE (country, country_code);
ALTER TABLE `log_client_network` ADD CONSTRAINT `U_log_client_network` UNIQUE (name);
ALTER TABLE `log_client_organization` ADD CONSTRAINT `U_log_client_organization` UNIQUE (name);
ALTER TABLE `log_client_subdivision` ADD CONSTRAINT `U_log_client_subdivision` UNIQUE (name);

ALTER TABLE `log_clientport` ADD CONSTRAINT `U_log_clientport` UNIQUE (name);
ALTER TABLE `log_referer` ADD CONSTRAINT `U_log_referer` UNIQUE (name);
ALTER TABLE `log_server` ADD CONSTRAINT `U_log_server` UNIQUE (name);
ALTER TABLE `log_serverport` ADD CONSTRAINT `U_log_serverport` UNIQUE (name);

ALTER TABLE `access_log_remotelogname` ADD CONSTRAINT `U_access_remotelogname` UNIQUE (name);
ALTER TABLE `access_log_remoteuser` ADD CONSTRAINT `U_access_remoteuser` UNIQUE (name);
ALTER TABLE `access_log_reqmethod` ADD CONSTRAINT `U_access_reqmethod` UNIQUE (name);
ALTER TABLE `access_log_reqprotocol` ADD CONSTRAINT `U_access_reqprotocol` UNIQUE (name);
ALTER TABLE `access_log_reqstatus` ADD CONSTRAINT `U_access_reqstatus` UNIQUE (name);

-- MySQL 9.2, the maximum key length (index length) for InnoDB tables using DYNAMIC or COMPRESSED row format is 3072 bytes and 767 bytes for REDUNDANT or COMPACT row formats.
-- MariaDB starting with 10.5 - Unique, if index type is not specified, is normally a BTREE index that can also be used by the optimizer to find rows. 
-- If the key is longer than the max key length for the used storage engine and the storage engine supports long unique index, a HASH key will be created. 
-- This enables MariaDB to enforce uniqueness for any type or number of columns.
-- lines below executed when installed on MariaDB 10.5 or higher
/*M!100500 ALTER TABLE access_log_requri ADD CONSTRAINT U_access_requri UNIQUE (name)*/;
/*M!100500 ALTER TABLE access_log_reqquery ADD CONSTRAINT U_access_reqquery UNIQUE (name)*/;
/*M!100500 ALTER TABLE access_log_useragent ADD CONSTRAINT U_access_useragent UNIQUE (name)*/;

ALTER TABLE `access_log_cookie` ADD CONSTRAINT `U_access_cookie` UNIQUE (name);

ALTER TABLE `access_log_ua` ADD CONSTRAINT `U_access_ua` UNIQUE (name);
ALTER TABLE `access_log_ua_browser` ADD CONSTRAINT `U_access_ua_browser` UNIQUE (name);
ALTER TABLE `access_log_ua_browser_family` ADD CONSTRAINT `U_access_ua_browser_family` UNIQUE (name);
ALTER TABLE `access_log_ua_browser_version` ADD CONSTRAINT `U_access_ua_browser_version` UNIQUE (name);
ALTER TABLE `access_log_ua_device` ADD CONSTRAINT `U_access_ua_device` UNIQUE (name);
ALTER TABLE `access_log_ua_device_brand` ADD CONSTRAINT `U_access_ua_device_brand` UNIQUE (name);
ALTER TABLE `access_log_ua_device_family` ADD CONSTRAINT `U_access_ua_device_family` UNIQUE (name);
ALTER TABLE `access_log_ua_device_model` ADD CONSTRAINT `U_access_ua_device_model` UNIQUE (name);
ALTER TABLE `access_log_ua_os` ADD CONSTRAINT `U_access_ua_os` UNIQUE (name);
ALTER TABLE `access_log_ua_os_family` ADD CONSTRAINT `U_access_ua_os_family` UNIQUE (name);
ALTER TABLE `access_log_ua_os_version` ADD CONSTRAINT `U_access_ua_os_version` UNIQUE (name);

ALTER TABLE `error_log_httpcode` ADD CONSTRAINT `U_error_httpcode` UNIQUE (name);
ALTER TABLE `error_log_httpmessage` ADD CONSTRAINT `U_error_httpmessage` UNIQUE (name);
ALTER TABLE `error_log_level` ADD CONSTRAINT `U_error_level` UNIQUE (name);
ALTER TABLE `error_log_message` ADD CONSTRAINT `U_error_message` UNIQUE (name);
ALTER TABLE `error_log_module` ADD CONSTRAINT `U_error_module` UNIQUE (name);
ALTER TABLE `error_log_processid` ADD CONSTRAINT `U_error_processid` UNIQUE (name);
ALTER TABLE `error_log_systemcode` ADD CONSTRAINT `U_error_systemcode` UNIQUE (name);
ALTER TABLE `error_log_systemmessage` ADD CONSTRAINT `U_error_systemmessage` UNIQUE (name);
ALTER TABLE `error_log_threadid` ADD CONSTRAINT `U_error_threadid` UNIQUE (name);

ALTER TABLE `import_file` ADD CONSTRAINT `U_import_file` UNIQUE (importdeviceid, name);
ALTER TABLE `import_file_format` ADD CONSTRAINT `U_import_file_format` UNIQUE (name);
ALTER TABLE `import_server` ADD CONSTRAINT `U_import_server` UNIQUE(dbuser, dbhost, dbversion, dbsystem, dbmachine, dbserverid);
ALTER TABLE `import_device` ADD CONSTRAINT `U_import_device` UNIQUE(deviceid, platformNode, platformSystem, platformMachine, platformProcessor);
ALTER TABLE `import_client` ADD CONSTRAINT `U_import_client` UNIQUE(importdeviceid, ipaddress, login, expandUser, platformRelease, platformVersion);

-- FOREIGN KEY Indexes
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_reqstatus` FOREIGN KEY (reqstatusid) REFERENCES `access_log_reqstatus`(id);
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_reqprotocol` FOREIGN KEY (reqprotocolid) REFERENCES `access_log_reqprotocol`(id);
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_reqmethod` FOREIGN KEY (reqmethodid) REFERENCES `access_log_reqmethod`(id);
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_requri` FOREIGN KEY (requriid) REFERENCES `access_log_requri`(id);
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_reqquery` FOREIGN KEY (reqqueryid) REFERENCES `access_log_reqquery`(id);
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_remotelogname` FOREIGN KEY (remotelognameid) REFERENCES `access_log_remotelogname`(id);
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_remoteuser` FOREIGN KEY (remoteuserid) REFERENCES `access_log_remoteuser`(id);
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_useragent` FOREIGN KEY (useragentid) REFERENCES `access_log_useragent`(id);
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_cookie` FOREIGN KEY (cookieid) REFERENCES `access_log_cookie`(id);
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_importfile` FOREIGN KEY (importfileid) REFERENCES `import_file`(id);

-- MySQL drops this index and uses compound index to enforce FOREIGN KEY
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_client` FOREIGN KEY (clientid) REFERENCES `log_client`(id);
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_clientport` FOREIGN KEY (clientportid) REFERENCES `log_clientport`(id);
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_referer` FOREIGN KEY (refererid) REFERENCES `log_referer`(id);
-- MySQL drops this index and uses compound index to enforce FOREIGN KEY
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_server` FOREIGN KEY (serverid) REFERENCES `log_server`(id);
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_serverport` FOREIGN KEY (serverportid) REFERENCES `log_serverport`(id);
ALTER TABLE `access_log` ADD CONSTRAINT `F_access_requestlogid` FOREIGN KEY (requestlogid) REFERENCES `log_requestlogid`(id);

ALTER TABLE `error_log` ADD CONSTRAINT `F_error_level` FOREIGN KEY (loglevelid) REFERENCES `error_log_level`(id);
ALTER TABLE `error_log` ADD CONSTRAINT `F_error_module` FOREIGN KEY (moduleid) REFERENCES `error_log_module`(id);
-- MySQL drops this index and uses compound index to enforce FOREIGN KEY
ALTER TABLE `error_log` ADD CONSTRAINT `F_error_processid` FOREIGN KEY (processid) REFERENCES `error_log_processid`(id);
ALTER TABLE `error_log` ADD CONSTRAINT `F_error_threadid` FOREIGN KEY (threadid) REFERENCES `error_log_threadid`(id);
ALTER TABLE `error_log` ADD CONSTRAINT `F_error_httpcode` FOREIGN KEY (httpcodeid) REFERENCES `error_log_httpcode`(id);
ALTER TABLE `error_log` ADD CONSTRAINT `F_error_httpmessage` FOREIGN KEY (httpmessageid) REFERENCES `error_log_httpmessage`(id);
ALTER TABLE `error_log` ADD CONSTRAINT `F_error_systemcode` FOREIGN KEY (systemcodeid) REFERENCES `error_log_systemcode`(id);
ALTER TABLE `error_log` ADD CONSTRAINT `F_error_systemmessage` FOREIGN KEY (systemmessageid) REFERENCES `error_log_systemmessage`(id);
ALTER TABLE `error_log` ADD CONSTRAINT `F_error_message` FOREIGN KEY (logmessageid) REFERENCES `error_log_message`(id);
ALTER TABLE `error_log` ADD CONSTRAINT `F_error_importfile` FOREIGN KEY (importfileid) REFERENCES `import_file`(id);

-- MySQL drops this index and uses compound index to enforce FOREIGN KEY
ALTER TABLE `error_log` ADD CONSTRAINT `F_error_client` FOREIGN KEY (clientid) REFERENCES `log_client`(id);
ALTER TABLE `error_log` ADD CONSTRAINT `F_error_clientport` FOREIGN KEY (clientportid) REFERENCES `log_clientport`(id);
ALTER TABLE `error_log` ADD CONSTRAINT `F_error_referer` FOREIGN KEY (refererid) REFERENCES `log_referer`(id);
-- MySQL drops this index and uses compound index to enforce FOREIGN KEY
ALTER TABLE `error_log` ADD CONSTRAINT `F_error_server` FOREIGN KEY (serverid) REFERENCES `log_server`(id);
ALTER TABLE `error_log` ADD CONSTRAINT `F_error_serverport` FOREIGN KEY (serverportid) REFERENCES `log_serverport`(id);
ALTER TABLE `error_log` ADD CONSTRAINT `F_error_requestlogid` FOREIGN KEY (requestlogid) REFERENCES `log_requestlogid`(id);

ALTER TABLE `log_client` ADD CONSTRAINT `F_log_client_city` FOREIGN KEY (cityid) REFERENCES `log_client_city`(id);
ALTER TABLE `log_client` ADD CONSTRAINT `F_log_client_coordinate` FOREIGN KEY (coordinateid) REFERENCES `log_client_coordinate`(id);
ALTER TABLE `log_client` ADD CONSTRAINT `F_log_client_country` FOREIGN KEY (countryid) REFERENCES `log_client_country`(id);
ALTER TABLE `log_client` ADD CONSTRAINT `F_log_client_network` FOREIGN KEY (networkid) REFERENCES `log_client_network`(id);
ALTER TABLE `log_client` ADD CONSTRAINT `F_log_client_organization` FOREIGN KEY (organizationid) REFERENCES `log_client_organization`(id);
ALTER TABLE `log_client` ADD CONSTRAINT `F_log_client_subdivision` FOREIGN KEY (subdivisionid) REFERENCES `log_client_subdivision`(id);

ALTER TABLE `access_log_useragent` ADD CONSTRAINT `F_useragent_ua` FOREIGN KEY (uaid) REFERENCES `access_log_ua`(id);
ALTER TABLE `access_log_useragent` ADD CONSTRAINT `F_useragent_ua_browser` FOREIGN KEY (uabrowserid) REFERENCES `access_log_ua_browser`(id);
ALTER TABLE `access_log_useragent` ADD CONSTRAINT `F_useragent_ua_browser_family` FOREIGN KEY (uabrowserfamilyid) REFERENCES `access_log_ua_browser_family`(id);
ALTER TABLE `access_log_useragent` ADD CONSTRAINT `F_useragent_ua_browser_version` FOREIGN KEY (uabrowserversionid) REFERENCES `access_log_ua_browser_version`(id);
ALTER TABLE `access_log_useragent` ADD CONSTRAINT `F_useragent_ua_device` FOREIGN KEY (uadeviceid) REFERENCES `access_log_ua_device`(id);
ALTER TABLE `access_log_useragent` ADD CONSTRAINT `F_useragent_ua_device_brand` FOREIGN KEY (uadevicebrandid) REFERENCES `access_log_ua_device_brand`(id);
ALTER TABLE `access_log_useragent` ADD CONSTRAINT `F_useragent_ua_device_family` FOREIGN KEY (uadevicefamilyid) REFERENCES `access_log_ua_device_family`(id);
ALTER TABLE `access_log_useragent` ADD CONSTRAINT `F_useragent_ua_device_model` FOREIGN KEY (uadevicemodelid) REFERENCES `access_log_ua_device_model`(id);
ALTER TABLE `access_log_useragent` ADD CONSTRAINT `F_useragent_ua_os` FOREIGN KEY (uaosid) REFERENCES `access_log_ua_os`(id);
ALTER TABLE `access_log_useragent` ADD CONSTRAINT `F_useragent_ua_os_family` FOREIGN KEY (uaosfamilyid) REFERENCES `access_log_ua_os_family`(id);
ALTER TABLE `access_log_useragent` ADD CONSTRAINT `F_useragent_ua_os_version` FOREIGN KEY (uaosversionid) REFERENCES `access_log_ua_os_version`(id);

ALTER TABLE `import_client` ADD CONSTRAINT `F_importclient_importdevice` FOREIGN KEY (importdeviceid) REFERENCES `import_device`(id);

ALTER TABLE `import_file` ADD CONSTRAINT `F_importfile_format` FOREIGN KEY (importfileformatid) REFERENCES `import_file_format`(id);
ALTER TABLE `import_file` ADD CONSTRAINT `F_importfile_device` FOREIGN KEY (importdeviceid) REFERENCES `import_device`(id);
ALTER TABLE `import_file` ADD CONSTRAINT `F_importfile_importload` FOREIGN KEY (importloadid) REFERENCES `import_load`(id);
ALTER TABLE `import_file` ADD CONSTRAINT `F_importfile_load_process` FOREIGN KEY (loadprocessid) REFERENCES `import_process`(id);
ALTER TABLE `import_file` ADD CONSTRAINT `F_importfile_parse_process` FOREIGN KEY (parseprocessid) REFERENCES `import_process`(id);
ALTER TABLE `import_file` ADD CONSTRAINT `F_importfile_import_process` FOREIGN KEY (importprocessid) REFERENCES `import_process`(id);

ALTER TABLE `import_process` ADD CONSTRAINT `F_process_importload` FOREIGN KEY (importloadid) REFERENCES `import_load`(id);
ALTER TABLE `import_process` ADD CONSTRAINT `F_process_importserver` FOREIGN KEY (importserverid) REFERENCES `import_server`(id);

ALTER TABLE `import_load` ADD CONSTRAINT `F_importload_importclient` FOREIGN KEY (importclientid) REFERENCES `import_client`(id);

ALTER TABLE `load_access_combined` ADD CONSTRAINT `F_load_access_combined_importfile` FOREIGN KEY (importfileid) REFERENCES `import_file`(id);
ALTER TABLE `load_access_csv` ADD CONSTRAINT `F_load_access_csv2mysql_importfile` FOREIGN KEY (importfileid) REFERENCES `import_file`(id);
ALTER TABLE `load_access_vhost` ADD CONSTRAINT `F_load_access_combined_vhost_importfile` FOREIGN KEY (importfileid) REFERENCES `import_file`(id);
ALTER TABLE `load_error_apache` ADD CONSTRAINT `F_load_error_apache_importfile` FOREIGN KEY (importfileid) REFERENCES `import_file`(id);

-- Additional Indexes
ALTER TABLE `access_log` ADD INDEX `I_access_log_logged` (logged);
ALTER TABLE `access_log` ADD INDEX `I_access_log_serverid_logged` (serverid, logged);
ALTER TABLE `access_log` ADD INDEX `I_access_log_serverid_serverportid` (serverid, serverportid);
ALTER TABLE `access_log` ADD INDEX `I_access_log_clientid_clientportid` (clientid, clientportid);

ALTER TABLE `error_log` ADD INDEX `I_error_log_logged` (logged);
ALTER TABLE `error_log` ADD INDEX `I_error_log_serverid_logged` (serverid, logged);
ALTER TABLE `error_log` ADD INDEX `I_error_log_serverid_serverportid` (serverid, serverportid);
ALTER TABLE `error_log` ADD INDEX `I_error_log_clientid_clientportid` (clientid, clientportid);
ALTER TABLE `error_log` ADD INDEX `I_error_log_processid_threadid` (processid, threadid);

ALTER TABLE `load_access_combined` ADD INDEX `I_load_access_combined_process` (process_status);
ALTER TABLE `load_access_csv` ADD INDEX `I_load_access_csv2mysql_process` (process_status);
ALTER TABLE `load_access_vhost` ADD INDEX `I_load_access_vhost_process` (process_status);
ALTER TABLE `load_error_apache` ADD INDEX `I_load_error_apache_process` (process_status);

-- indexes for parse and retrieve processes
ALTER TABLE `log_client` ADD INDEX `I_log_client_country_code` (country_code);
ALTER TABLE `access_log_useragent` ADD INDEX `I_access_log_useragent_ua` (ua);