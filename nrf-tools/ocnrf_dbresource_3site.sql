-- Copyright 2021 (C), Oracle and/or its affiliates. All rights reserved.
/*
	1. This MySQL script is intended to be run before the deployment of a 3-site Geo-Redundant NRF and the database replication MUST be UP between all three sites.
	2. This MySQL script needs to be run ONLY on ONE of the MySQL nodes of ONLY one site(among the the 3 sites present).
	3. Please modify the usernames, passwords according to the user's wish/will.
	4. Please modify the names of NRF's application DB, NRF's network DB and commonConfiguration DBs according to the user's wish/will.
	5. CAUTION: Check if OCNRF-Privileged-User already exists by running the following query in the mysql prompt(logged in as root MySQL User):
			select user from mysql.user where user='<OCNRF-Privileged-User Name>';
		If the result is NOT an empty set, please comment out the line(number 40) which is creating the OCNRF Privileged-User in the below script.
	6. CAUTION: Check if OCNRF-Application-User already exists by running the following query in the mysql prompt(logged in as root MySQL User):
			select user from mysql.user where user='<OCNRF-Application-User-Name>';
		If the result is NOT an empty set, please comment out the line(number 41) which is creating the OCNRF APPLICATION User in the below script.
	7. Copy this MySQL script to one of the MySQL nodes of the site where it will be run.
		For example:
			$ kubectl cp ocnrf_dbresource_3site.sql ndbmysqld-0:/home/mysql -n <namespace> -c <containerName, like: mysqlndbcluster>
	8. Connect to the MySQL node to which the script was copied.
	9. Assuming that this MySQL script is in the present working directory, it needs to be run(as root MySQL User) as shown below:
	
			[mysql@ndbmysqld-0 ~]$ ls -lrt
			total 4
			-rw-r--r--. 1 mysql mysql 3861 Nov 11 08:27 ocnrf_dbresource_3site.sql
			[mysql@ndbmysqld-0 ~]$
			[mysql@ndbmysqld-0 ~]$ mysql -h 127.0.0.1 -uroot -p < ocnrf_dbresource_3site.sql
			Enter password:
			[mysql@ndbmysqld-0 ~]$
	10. There must be no errors while running this MySQL script and the shell-prompt must silently return without any error
*/

-- Database Creation
CREATE DATABASE IF NOT EXISTS nrfApplicationDB CHARACTER SET utf8;
CREATE DATABASE IF NOT EXISTS nrfNetworkDB CHARACTER SET utf8;
CREATE DATABASE IF NOT EXISTS commonConfigurationDB1 CHARACTER SET utf8;
CREATE DATABASE IF NOT EXISTS commonConfigurationDB2 CHARACTER SET utf8;
CREATE DATABASE IF NOT EXISTS commonConfigurationDB3 CHARACTER SET utf8;
CREATE DATABASE IF NOT EXISTS leaderElectionDB1 CHARACTER SET utf8;
CREATE DATABASE IF NOT EXISTS leaderElectionDB2 CHARACTER SET utf8;
CREATE DATABASE IF NOT EXISTS leaderElectionDB3 CHARACTER SET utf8;

-- User Creation
CREATE USER 'nrfPrivilegedUsr'@'%' IDENTIFIED WITH mysql_native_password BY 'nrfPrivilegedPasswd';
CREATE USER 'nrfApplicationUsr'@'%' IDENTIFIED WITH mysql_native_password BY 'nrfApplicationPasswd';

-- Grant privileges
GRANT NDB_STORED_USER ON *.* TO 'nrfPrivilegedUsr'@'%' WITH GRANT OPTION;
GRANT NDB_STORED_USER ON *.* TO 'nrfApplicationUsr'@'%' WITH GRANT OPTION;

GRANT SELECT, INSERT, CREATE, ALTER, DROP, INDEX, LOCK TABLES, CREATE TEMPORARY TABLES, DELETE, UPDATE, EXECUTE ON nrfApplicationDB.* TO 'nrfPrivilegedUsr'@'%';
GRANT SELECT, INSERT, CREATE, ALTER, DROP, LOCK TABLES, CREATE TEMPORARY TABLES, DELETE, UPDATE, EXECUTE ON nrfNetworkDB.* TO 'nrfPrivilegedUsr'@'%';
GRANT SELECT, INSERT, LOCK TABLES, DELETE, UPDATE, EXECUTE ON nrfApplicationDB.* TO 'nrfApplicationUsr'@'%';
GRANT SELECT ON replication_info.* TO 'nrfApplicationUsr'@'%';
GRANT SELECT, INSERT, CREATE, ALTER, DROP, LOCK TABLES, CREATE TEMPORARY TABLES, DELETE, UPDATE, EXECUTE ON commonConfigurationDB1.* TO 'nrfPrivilegedUsr'@'%';
GRANT SELECT, INSERT, CREATE, ALTER, DROP, LOCK TABLES, CREATE TEMPORARY TABLES, DELETE, UPDATE, EXECUTE ON commonConfigurationDB2.* TO 'nrfPrivilegedUsr'@'%';
GRANT SELECT, INSERT, CREATE, ALTER, DROP, LOCK TABLES, CREATE TEMPORARY TABLES, DELETE, UPDATE, EXECUTE ON commonConfigurationDB3.* TO 'nrfPrivilegedUsr'@'%';
GRANT SELECT, INSERT, CREATE, ALTER, DROP, LOCK TABLES, CREATE TEMPORARY TABLES, DELETE, UPDATE, EXECUTE ON leaderElectionDB1.* TO 'nrfPrivilegedUsr'@'%';
GRANT SELECT, INSERT, CREATE, ALTER, DROP, LOCK TABLES, CREATE TEMPORARY TABLES, DELETE, UPDATE, EXECUTE ON leaderElectionDB2.* TO 'nrfPrivilegedUsr'@'%';
GRANT SELECT, INSERT, CREATE, ALTER, DROP, LOCK TABLES, CREATE TEMPORARY TABLES, DELETE, UPDATE, EXECUTE ON leaderElectionDB3.* TO 'nrfPrivilegedUsr'@'%';

FLUSH PRIVILEGES;
