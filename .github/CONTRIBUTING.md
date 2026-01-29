Thoroughly researched and tested all Apache log formats. I have not done that for NGINX yet. I read documentation and several online sources. 

NGINX standard access and error format log files in `/data/nginx_combined/` and `/data/nginx_error/` are from a NGINX server.

MySQL stored procedure code for NGINX are stripped down copies of Apache twin. Contains only code required for `combined` format.

`parse_acces_nginx.sql`, `import_access_nginx.sql`, `parse_error_nginx.sql`, `import_error_nginx.sql`

are copies of:

`parse_acces_apache.sql`, `parse_error_apache.sql`, `import_access_apache.sql`, `import_error_apache.sql`

Anyone with NGINX log files who wants to contribute NGINX log format knowledge or import data results would be helpful and welcomed.

Anyone with MySQL procedural and NGINX log format knowledge would be helpful.

If you find this repository valuable to your database application development monetary contributions are appreciated. Repository has my ***Buy Me a Coffee*** :coffee: link.

Monetary :moneybag: contributions made will encourage [Web Interface](https://github.com/WillTheFarmer/mysql-to-apache-echarts) repository development continuation for this MySQL or MariaDB schema populated by [httpLogs2MySQL](https://github.com/willthefarmer/http-logs-to-mysql) repository.

This repository exists because I volunteer at local nonprofit that provides food and clothing for those in need. The Director is familiar with MySQL and wanted to import Apache website logs into MySQL tables. At that meeting I knew little about Apache but lots about MySQL. I thought it would be a couple days to research existing solutions and offered to investigate.

Surprisingly none I found performed any data normalization and were very primitive. The lack of existing relational database open-source solutions led to creation of this solution.

March 2025 I had conservatively 1200 hours :hourglass_flowing_sand: of researching existing solutions, database design and SQL/Python development. The January 2026 Python code re-design added another 300 hours. It is much more time then I intended to invest but it did produce my first open-source software.
