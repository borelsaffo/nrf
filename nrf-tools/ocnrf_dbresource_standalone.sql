-- Copyright 2021 (C), Oracle and/or its affiliates. All rights reserved.
/*
	1. This MySQL script is intended to be run before the deployment of a standalone NRF.
	2. This MySQL script needs to be run ONLY on ONE of the MySQL nodes.
	3. Please modify the usernames, passwords according to the user's wish/will.
	4. Please modify the names of NRF's application DB, NRF's network DB and commonConfiguration DBs according to the user's wish/will.
	5. CAUTION: Check if OCNRF-Privileged-User already exists by running the following query in the mysql prompt(logged in as root MySQL User):
			select user from mysql.user where user='<OCNRF-Privileged-User-Name>';
		If the result is NOT an empty set, please comment out the line(number 34) which is creating the OCNRF-Privileged-User in the below script.
	6. CAUTION: Check if OCNRF-Application-User already exists by running the following query in the mysql prompt(logged in as root MySQL User):
			select user from mysql.user where user='<OCNRF-Application-User-Name>';
		If the result is NOT an empty set, please comment out the line(number 35) which is creating the OCNRF-Application-User in the below script.
	7. Copy this MySQL script to one of the MySQL nodes where it will be run.
		For example:
			$ kubectl cp ocnrf_dbresource_standalone.sql ndbmysqld-0:/home/mysql -n chicago -c mysqlndbcluster
	8. Connect to the MySQL node to which the script was copied.
	9. Assuming that this MySQL script is in the present working directory, it needs to be run(as root MySQL User) as shown below:
	
			[mysql@ndbmysqld-0 ~]$ ls -lrt
			total 4
			-rw-------. 1 mysql mysql 1695 Jun 10 04:12 ocnrf_dbresource_standalone.sql
			[mysql@ndbmysqld-0 ~]$
			[mysql@ndbmysqld-0 ~]$ mysql -h 127.0.0.1 -uroot -p < ocnrf_dbresource_standalone.sql
			Enter password:
			[mysql@ndbmysqld-0 ~]$
*/

-- Database Creation
CREATE DATABASE IF NOT EXISTS nrfApplicationDB CHARACTER SET utf8;
CREATE DATABASE IF NOT EXISTS nrfNetworkDB CHARACTER SET utf8;
CREATE DATABASE IF NOT EXISTS commonConfigurationDB CHARACTER SET utf8;
CREATE DATABASE IF NOT EXISTS leaderElectionDB CHARACTER SET utf8;

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
GRANT SELECT, INSERT, CREATE, ALTER, DROP, LOCK TABLES, CREATE TEMPORARY TABLES, DELETE, UPDATE, EXECUTE ON commonConfigurationDB.* TO 'nrfPrivilegedUsr'@'%';
GRANT SELECT, INSERT, CREATE, ALTER, DROP, LOCK TABLES, CREATE TEMPORARY TABLES, DELETE, UPDATE, EXECUTE ON leaderElectionDB.* TO 'nrfPrivilegedUsr'@'%';
FLUSH PRIVILEGES;

