# Database designed for HTTP log data analysis
![Entity Relationship Diagram](./images/entity_relationship_diagram.png)
## DDL for tables, indexes, views, function, procedures & constraints
All SQL files and Python build file used in schema database application development is here. Individual Function and Procedure files make applying modifications much simplier in Visual Studio Code.

The Python build script assembles all SQL script files together into the single `create_http_logs.sql` file that is included in repository [httpLogs2MySQL](https://github.com/willthefarmer/http-logs-to-mysql) repository.

### 1. NGINX formats and procedural code
From documentation read NGINX standard access logformat is same as Apache combined. I have not verified by examining NGINX data yet.

Apache log formats have been thoroughly researched and tested. NGINX log formats have not.

Repository NGINX files are standard access and error formats from new NGINX server

NGINX log files in `/data/nginx_combined/` and `/data/nginx_error/` are from new NGINX server.

Each log format has a Stored Procedure. More information will be added over new few days. 

### 2. Database
Before running `create_http_logs.sql` if User Account `root`@`localhost` does not exist on installation server open 
file and perform a ***Find and Replace*** using a User Account with DBA Role on installation server. Copy below:
```
root`@`localhost`
```
Rename above <sup>user</sup> to a <sup>user</sup> on your server. For example - `root`@`localhost` to `dbadmin`@`localhost`

The easiest way to install is use database Command Line Client. Login as User with DBA Role and execute the following:
```
source path/create_http_logs.sql
```
Only MySQL server must be configured in `my.ini`, `mysqld.cnf` or `my.cnf` depending on platform with following: 
```
[mysqld]
local-infile=1
```
### 3. Create database USER & GRANTS
To minimize data exposure and breach risks create a database USER for Python module with GRANTS to only schema objects and privileges required to execute import processes. Replace hostname from `localhost` to hostname of installed database if different.
Use  `scripts/mysql_user_and_grants.sql` in repository.

## Database runs on MySQL & MariaDB
Python handles polling of log file folders and executing database LOAD DATA, Procedures, Functions and SQL Statements. Python drives the application but MySQL or MariaDB does all Data Manipulation & Processing.

This is a fast, reliable processing application with detailed logging and two stages of data parsing.

First stage is performed in `LOAD DATA LOCAL INFILE` statements with data-driven "log format" selection of LOAD settings and load_ staging tables.

Second stage is performed in MySQL modules: `parse_access_apache`, `parse_access_nginx`, `parse_error_apache`, `parse_error_nginx`

HTTP Access and Error data normalization and import is done in MySQL modules: `import_access_apache, import_access_nginx, import_error_apache, import_error_nginx`

Client IP GeoData is retrieved with Python. Data normalization & import is done in MySQL module: `normalize_client`

User Agent String is parsed with Python. Data normalization & import is done in MySQL module: `normalize_useragent`

Application determines what files have been processed using `import_file` TABLE.

Each imported file has record with name, path, size, created, modified attributes inserted during `process_logs`.

## Application runs on Windows, Linux & MacOS
![json Config Lists](./images/json_config_lists.png)
## Python handles File Processing & Database handles Data Processing
The Python application repository is [httpLogs2MySQL](https://github.com/willthefarmer/http-logs-to-mysql) which is a JSON data-driven Python application to automate importing Access & Error files, normalizing log data into database and generating a well-documented data lineage audit trail.

Multiple Access and Error logs and formats can be loaded, parsed and imported along with User Agent parsing and IP Address Geolocation retrieval processes within a single `main:process_files` execution. 

## Visual Interface App
in my development queue [MySQL2ApacheECharts](https://github.com/willthefarmer/mysql-to-apache-echarts) is a ***visualization tool*** for the database schema. The Web interface consists of [Express](https://github.com/expressjs/express) web application frameworks with [W2UI](https://github.com/vitmalina/w2ui) drill-down data grids for Data Point Details 
& [Apache ECharts](https://github.com/apache/echarts) frameworks for Data Visualization.
