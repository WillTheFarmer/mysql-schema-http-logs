-- FOREIGN KEY Indexes
ALTER TABLE `access_log` DROP FOREIGN KEY `F_access_reqstatus`;
ALTER TABLE `access_log` DROP FOREIGN KEY `F_access_reqprotocol`;
ALTER TABLE `access_log` DROP FOREIGN KEY `F_access_reqmethod`;
ALTER TABLE `access_log` DROP FOREIGN KEY `F_access_requri`;
ALTER TABLE `access_log` DROP FOREIGN KEY `F_access_reqquery`;
ALTER TABLE `access_log` DROP FOREIGN KEY `F_access_remotelogname`;
ALTER TABLE `access_log` DROP FOREIGN KEY `F_access_remoteuser`;
ALTER TABLE `access_log` DROP FOREIGN KEY `F_access_useragent`;
ALTER TABLE `access_log` DROP FOREIGN KEY `F_access_cookie`;
ALTER TABLE `access_log` DROP FOREIGN KEY `F_access_importfile`;

ALTER TABLE `access_log` DROP FOREIGN KEY `F_access_client`;
ALTER TABLE `access_log` DROP FOREIGN KEY `F_access_clientport`;
ALTER TABLE `access_log` DROP FOREIGN KEY `F_access_referer`;
ALTER TABLE `access_log` DROP FOREIGN KEY `F_access_server`;
ALTER TABLE `access_log` DROP FOREIGN KEY `F_access_serverport`;
ALTER TABLE `access_log` DROP FOREIGN KEY `F_access_requestlogid`;

ALTER TABLE `error_log` DROP FOREIGN KEY `F_error_level`;
ALTER TABLE `error_log` DROP FOREIGN KEY `F_error_module`;
ALTER TABLE `error_log` DROP FOREIGN KEY `F_error_processid`;
ALTER TABLE `error_log` DROP FOREIGN KEY `F_error_threadid`;
ALTER TABLE `error_log` DROP FOREIGN KEY `F_error_httpcode`;
ALTER TABLE `error_log` DROP FOREIGN KEY `F_error_httpmessage`;
ALTER TABLE `error_log` DROP FOREIGN KEY `F_error_systemcode`;
ALTER TABLE `error_log` DROP FOREIGN KEY `F_error_systemmessage`;
ALTER TABLE `error_log` DROP FOREIGN KEY `F_error_message`;
ALTER TABLE `error_log` DROP FOREIGN KEY `F_error_importfile`;

ALTER TABLE `error_log` DROP FOREIGN KEY `F_error_client`;
ALTER TABLE `error_log` DROP FOREIGN KEY `F_error_clientport`;
ALTER TABLE `error_log` DROP FOREIGN KEY `F_error_referer`;
ALTER TABLE `error_log` DROP FOREIGN KEY `F_error_server`;
ALTER TABLE `error_log` DROP FOREIGN KEY `F_error_serverport`;
ALTER TABLE `error_log` DROP FOREIGN KEY `F_error_requestlogid`;

ALTER TABLE `log_client` DROP FOREIGN KEY `F_log_client_city`;
ALTER TABLE `log_client` DROP FOREIGN KEY `F_log_client_coordinate`;
ALTER TABLE `log_client` DROP FOREIGN KEY `F_log_client_country`;
ALTER TABLE `log_client` DROP FOREIGN KEY `F_log_client_network`;
ALTER TABLE `log_client` DROP FOREIGN KEY `F_log_client_organization`;
ALTER TABLE `log_client` DROP FOREIGN KEY `F_log_client_subdivision`;

ALTER TABLE `access_log_useragent` DROP FOREIGN KEY `F_useragent_ua`;
ALTER TABLE `access_log_useragent` DROP FOREIGN KEY `F_useragent_ua_browser`;
ALTER TABLE `access_log_useragent` DROP FOREIGN KEY `F_useragent_ua_browser_family`;
ALTER TABLE `access_log_useragent` DROP FOREIGN KEY `F_useragent_ua_browser_version`;
ALTER TABLE `access_log_useragent` DROP FOREIGN KEY `F_useragent_ua_device`;
ALTER TABLE `access_log_useragent` DROP FOREIGN KEY `F_useragent_ua_device_brand`;
ALTER TABLE `access_log_useragent` DROP FOREIGN KEY `F_useragent_ua_device_family`;
ALTER TABLE `access_log_useragent` DROP FOREIGN KEY `F_useragent_ua_device_model`;
ALTER TABLE `access_log_useragent` DROP FOREIGN KEY `F_useragent_ua_os`;
ALTER TABLE `access_log_useragent` DROP FOREIGN KEY `F_useragent_ua_os_family`;
ALTER TABLE `access_log_useragent` DROP FOREIGN KEY `F_useragent_ua_os_version`;

ALTER TABLE `import_client` DROP CONSTRAINT `F_importclient_importdevice`;

ALTER TABLE `import_file` DROP CONSTRAINT `F_importfile_importformat`;
ALTER TABLE `import_file` DROP FOREIGN KEY `F_importfile_importdevice`;
ALTER TABLE `import_file` DROP FOREIGN KEY `F_importfile_importload`;
ALTER TABLE `import_file` DROP FOREIGN KEY `F_importfile_parseprocess`;
ALTER TABLE `import_file` DROP FOREIGN KEY `F_importfile_importprocess`;

ALTER TABLE `import_process` DROP FOREIGN KEY `F_importprocess_importserver`;

ALTER TABLE `import_load` DROP FOREIGN KEY `F_importload_importclient`;

ALTER TABLE `load_access_combined` DROP FOREIGN KEY `F_load_access_combined_importfile`;
ALTER TABLE `load_access_csv` DROP FOREIGN KEY `F_load_access_csv2mysql_importfile`;
ALTER TABLE `load_access_vhost` DROP FOREIGN KEY `F_load_access_combined_vhost_importfile`;
ALTER TABLE `load_error_apache` DROP FOREIGN KEY `F_load_error_apache_importfile`;

-- indexes not needed and serve no purpose since each file would never have more than one value for process_status
-- ALTER TABLE `load_access_combined` DROP INDEX `I_load_access_combined_import_process;
-- ALTER TABLE `load_access_csv` DROP INDEX `I_load_access_csv2mysql_import_process;
-- ALTER TABLE `load_access_vhost` DROP INDEX `I_load_access_vhost_import_process;
-- ALTER TABLE `load_error_apache` DROP INDEX `I_load_error_apache_import_process;

-- UNIQUE Indexes
DROP INDEX `U_log_client` ON `log_client`;
DROP INDEX `U_log_client_city` ON `log_client_city`;
DROP INDEX `U_log_client_coordinate` ON `log_client_coordinate`;
DROP INDEX `U_log_client_country` ON `log_client_country`;
DROP INDEX `U_log_client_network` ON `log_client_network`;
DROP INDEX `U_log_client_organization` ON `log_client_organization`;
DROP INDEX `U_log_client_subdivision` ON `log_client_subdivision`;

DROP INDEX `U_log_clientport` ON `log_clientport`;
DROP INDEX `U_log_referer` ON `log_referer`;
DROP INDEX `U_log_server` ON `log_server`;
DROP INDEX `U_log_serverport` ON `log_serverport`;

DROP INDEX `U_access_remotelogname` ON `access_log_remotelogname`;
DROP INDEX `U_access_remoteuser` ON `access_log_remoteuser`;
DROP INDEX `U_access_reqmethod` ON `access_log_reqmethod`;
DROP INDEX `U_access_reqprotocol` ON `access_log_reqprotocol`;
DROP INDEX `U_access_reqstatus` ON `access_log_reqstatus`;

/*M! DROP INDEX U_access_requri ON access_log_requri;*/
/*M! DROP INDEX U_access_reqquery ON access_log_reqquery;*/
/*M! DROP INDEX U_access_useragent_name ON access_log_useragent;*/

DROP INDEX `U_access_cookie` ON `access_log_cookie`;

DROP INDEX `U_access_ua` ON `access_log_ua`;
DROP INDEX `U_access_ua_browser` ON `access_log_ua_browser`;
DROP INDEX `U_access_ua_browser_family` ON `access_log_ua_browser_family`;
DROP INDEX `U_access_ua_browser_version` ON `access_log_ua_browser_version`;
DROP INDEX `U_access_ua_device` ON `access_log_ua_device`;
DROP INDEX `U_access_ua_device_brand` ON `access_log_ua_device_brand`;
DROP INDEX `U_access_ua_device_family` ON `access_log_ua_device_family`;
DROP INDEX `U_access_ua_device_model` ON `access_log_ua_device_model`;
DROP INDEX `U_access_ua_os` ON `access_log_ua_os`;
DROP INDEX `U_access_ua_os_family` ON `access_log_ua_os_family`;
DROP INDEX `U_access_ua_os_version` ON `access_log_ua_os_version`;

DROP INDEX `U_error_httpcode` ON `error_log_httpcode`;
DROP INDEX `U_error_httpmessage` ON `error_log_httpmessage`;
DROP INDEX `U_error_level` ON `error_log_level`;
DROP INDEX `U_error_message` ON `error_log_message`;
DROP INDEX `U_error_module` ON `error_log_module`;
DROP INDEX `U_error_processid` ON `error_log_processid`;
DROP INDEX `U_error_systemcode` ON `error_log_systemcode`;
DROP INDEX `U_error_systemmessage` ON `error_log_systemmessage`;
DROP INDEX `U_error_threadid` ON `error_log_threadid`;

DROP INDEX `U_import_file` ON `import_file`;
DROP INDEX `U_import_format` ON `import_format`;
DROP INDEX `U_import_server` ON `import_server`;
DROP INDEX `U_import_device` ON `import_device`;
DROP INDEX `U_import_client` ON `import_client`;

DROP INDEX `F_access_reqstatus` ON `access_log`;
DROP INDEX `F_access_reqprotocol` ON `access_log`;
DROP INDEX `F_access_reqmethod` ON `access_log`;
DROP INDEX `F_access_requri` ON `access_log`;
DROP INDEX `F_access_reqquery` ON `access_log`;
DROP INDEX `F_access_remotelogname` ON `access_log`;
DROP INDEX `F_access_remoteuser` ON `access_log`;
DROP INDEX `F_access_useragent` ON `access_log`;
DROP INDEX `F_access_cookie` ON `access_log`;
DROP INDEX `F_access_importfile` ON `access_log`;

-- MySQL drops this index and used compound index to enforce FOREIGN KEY
-- DROP INDEX `F_access_client` ON `access_log`;
DROP INDEX `F_access_clientport` ON `access_log`;
DROP INDEX `F_access_referer` ON `access_log`;
-- MySQL drops this index and used compound index to enforce FOREIGN KEY
-- DROP INDEX `F_access_server` ON `access_log`;
DROP INDEX `F_access_serverport` ON `access_log`;
DROP INDEX `F_access_requestlogid` ON `access_log`;

DROP INDEX `F_error_level` ON `error_log`;
DROP INDEX `F_error_module` ON `error_log`;
-- MySQL drops this index and used compound index to enforce FOREIGN KEY
-- DROP INDEX `F_error_processid` ON `error_log`;
DROP INDEX `F_error_threadid` ON `error_log`;
DROP INDEX `F_error_httpcode` ON `error_log`;
DROP INDEX `F_error_httpmessage` ON `error_log`;
DROP INDEX `F_error_systemcode` ON `error_log`;
DROP INDEX `F_error_systemmessage` ON `error_log`;
DROP INDEX `F_error_message` ON `error_log`;
DROP INDEX `F_error_importfile` ON `error_log`;

-- MySQL drops this index when DROP CONSTRAINT to enforce FOREIGN KEY
-- DROP INDEX `F_error_client` ON `error_log`;
DROP INDEX `F_error_clientport` ON `error_log`;
DROP INDEX `F_error_referer` ON `error_log`;
-- MySQL drops this index when DROP CONSTRAINT to enforce FOREIGN KEY
-- DROP INDEX `F_error_server` ON `error_log`;
DROP INDEX `F_error_serverport` ON `error_log`;
DROP INDEX `F_error_requestlogid` ON `error_log`;

DROP INDEX `F_log_client_city` ON `log_client`;
DROP INDEX `F_log_client_coordinate` ON `log_client`;
DROP INDEX `F_log_client_country` ON `log_client`;
DROP INDEX `F_log_client_network` ON `log_client`;
DROP INDEX `F_log_client_organization` ON `log_client`;
DROP INDEX `F_log_client_subdivision` ON `log_client`;

DROP INDEX `F_useragent_ua` ON `access_log_useragent`;
DROP INDEX `F_useragent_ua_browser` ON `access_log_useragent`;
DROP INDEX `F_useragent_ua_browser_family` ON `access_log_useragent`;
DROP INDEX `F_useragent_ua_browser_version` ON `access_log_useragent`;
DROP INDEX `F_useragent_ua_device` ON `access_log_useragent`;
DROP INDEX `F_useragent_ua_device_brand` ON `access_log_useragent`;
DROP INDEX `F_useragent_ua_device_family` ON `access_log_useragent`;
DROP INDEX `F_useragent_ua_device_model` ON `access_log_useragent`;
DROP INDEX `F_useragent_ua_os` ON `access_log_useragent`;
DROP INDEX `F_useragent_ua_os_family` ON `access_log_useragent`;
DROP INDEX `F_useragent_ua_os_version` ON `access_log_useragent`;

-- MySQL drops this index and used compound index to enforce FOREIGN KEY
-- DROP INDEX `F_importclient_importdevice` ON `import_client`;

DROP INDEX `F_importfile_importformat` ON `import_file`;
-- MySQL drops this index and used compound index to enforce FOREIGN KEY
-- DROP INDEX `F_importfile_importdevice` ON `import_file`;
DROP INDEX `F_importfile_importload` ON `import_file`;
DROP INDEX `F_importfile_parseprocess` ON `import_file`;
DROP INDEX `F_importfile_importprocess` ON `import_file`;

DROP INDEX `F_importprocess_importserver` ON `import_process`;

DROP INDEX `F_importload_importclient` ON `import_load`;

DROP INDEX `F_load_access_combined_importfile` ON `load_access_combined`;
DROP INDEX `F_load_access_csv2mysql_importfile` ON `load_access_csv`;
DROP INDEX `F_load_access_combined_vhost_importfile` ON `load_access_vhost`;
DROP INDEX `F_load_error_apache_importfile` ON `load_error_apache`;

-- Additional Indexes
DROP INDEX `I_access_log_logged` ON `access_log`;
DROP INDEX `I_access_log_serverid_logged` ON `access_log`;
DROP INDEX `I_access_log_serverid_serverportid` ON `access_log`;
DROP INDEX `I_access_log_clientid_clientportid` ON `access_log`;

DROP INDEX `I_error_log_logged` ON `error_log`;
DROP INDEX `I_error_log_serverid_logged` ON `error_log`;
DROP INDEX `I_error_log_serverid_serverportid` ON `error_log`;
DROP INDEX `I_error_log_clientid_clientportid` ON `error_log`;
DROP INDEX `I_error_log_processid_threadid` ON `error_log`;

DROP INDEX `I_load_access_combined_process` ON `load_access_combined`;
DROP INDEX `I_load_access_csv2mysql_process` ON `load_access_csv`;
DROP INDEX `I_load_access_vhost_process` ON `load_access_vhost`;
DROP INDEX `I_load_error_apache_process` ON `load_error_apache`;

-- indexes for parse and retrieve processes
DROP INDEX `I_log_client_country_code` ON `log_client`;
DROP INDEX `I_access_log_useragent_ua` ON `access_log_useragent`;
