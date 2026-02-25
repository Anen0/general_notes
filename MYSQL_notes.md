
# `MYSQL` 

src: https://www.rosehosting.com/blog/how-to-list-all-databases-in-mysql/

	login
	sudo mysql -u <name> -p
	sudo mysql


View MYSQL timezone  
	
	SELECT @@system_time_zone;




## `MYSQL: Add user w/ permissions`

src: https://www.digitalocean.com/community/tutorials/how-to-create-a-new-user-and-grant-permissions-in-mysql  
running with no authentication plugin  

	CREATE USER 'username'@'host' IDENTIFIED BY 'password'; 

***Note***: There is a known issue with some versions of PHP that causes problems with caching_sha2_password. If you plan to use this database with a PHP application — phpMyAdmin, for example — you may want to create a user that will authenticate with the older, though still secure, `mysql_native_password` plugin instead:

	CREATE USER 'sammy'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'password';

If you got issuies with caching_sha2_password and use the db with a php application say PHPMYADMIN, use: `mysql_native_password`

	CREATE USER 'sammy'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';

If you aren’t sure, you can always create a user that authenticates with `caching_sha2_plugin` and then ALTER it later on with this command:

	ALTER USER 'sammy'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';

### grant permissions

	GRANT CREATE, ALTER, DROP, INSERT, UPDATE, DELETE, SELECT, REFERENCES, RELOAD on *.* TO 'sammy'@'localhost' WITH GRANT OPTION;

grant 'ALL PRIVILEGES' be cautious of this one since the user basically becomes like 'root' user

	GRANT ALL PRIVILEGES ON *.* TO 'sammy'@'localhost' WITH GRANT OPTION;

### delete user

	DROP USER 'username'@'localhost';


### list users
	select * from mysql.user;
	
	or

	select host, user from mysql.user;


values on the SELECT tag:
---
	Host
	User
	Select_priv
	Insert_priv
	Update_priv
	Delete_priv
	Create_priv
	Drop_priv
	Reload_priv
	Shutdown_priv
	Process_priv
	File_priv
	Grant_priv
	References_priv
	Index_priv
	Alter_priv
	Show_db_priv
	Super_priv
	Create_tmp_table_priv
	Lock_tables_priv
	Execute_priv
	Repl_slave_priv
	Repl_client_priv
	Create_view_priv
	Show_view_priv
	Create_routine_priv
	Alter_routine_priv
	Create_user_priv
	Event_priv
	Trigger_priv
	Create_tablespace_priv
	ssl_type
	ssl_cipher
	x509_issuer
	x509_subject
	max_questions
	max_updates
	max_connections
	max_user_connections
	plugin
	authentication_string
	password_expired
	password_last_changed
	password_lifetime
	account_locked
	Create_role_priv
	Drop_role_priv
	Password_reuse_history
	Password_reuse_time
	Password_require_current
	User_attributes 


## `reduce the amount of ‘user’ information shown`
	desc mysql.user;

## `connect to mysql server with password`
	mysql -u root -p

	w/o password
	mysql -u root


## `show a list of databases`
	show databases;


## `select a database`
	use "nameOfDB";


## `show list of in the database`
	show tables;

## `show columns`
	SHOW COLUMNS FROM <table>;



## `IMPORT DB from sql file in command line`:
***try*** :
	
	mysql -u username -p database_name < /path/to/file.sql

>	Note 1: It is better to use the full path of the SQL file file.sql.  
>	Note 2: Use -R and --triggers with mysqldump to keep the routines and triggers of the original database. They are not copied by default.  
>	Note 3 You may have to create the (empty) database from MySQL if it doesn't exist already and the exported SQL doesn't contain `CREATE DATABASE (exported with --no-create-db or -n option)` before you can import it.

if you are ***logged in*** mysql already:

	CREATE DATABASE <db_name>;
	mysql> use db_name;
	mysql> source backup-file.sql;


## `IMPORT data to table`
_src_ : https://stackoverflow.com/questions/3635166/how-do-i-import-csv-file-into-a-mysql-table

	LOAD DATA LOCAL INFILE  
	'c:/temp/some-file.csv'
	INTO TABLE your_awesome_table  
	FIELDS TERMINATED BY ',' 
	ENCLOSED BY '"'
	IGNORE 1 ROWS;

if not: exit and login to mysql with this command

	mysql --local_infile=1 -u <root> -p DB_name



## `EXPORT data from database`:
_src_ : https://stackoverflow.com/questions/8217578/how-to-export-databases-through-command-line

	mysqldump -u <username> -p --no-tablespaces  --databases <database_name> > /path/<export_file.sql>

## `Export specific rows`: 	
_src_ : https://stackoverflow.com/questions/15287295/how-to-export-some-rows-of-a-mysql-table-from-a-where-clause

	mysqldump -u <username> -p <database_name> <table_name> --where="Condition" > /path/<export_file.sql>

## `More info in exporting in MYSQLDUMP`

_src_ : https://electrictoolbox.com/mysqldump-selectively-dump-data/


***If you get an error in uploading databases from file***
	
	show global variables like 'local_infile';
	set global local_infile=true;



`STOPPING MYSQL service`
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
_src_ : https://linuxhint.com/change-mysql-root-password-ubuntu/

stop mysql:

	sudo systemctl stop mysql.service

or gracefully stop the service (force timeout)

	sudo systemctl stop mysql --no-block

check if it has been stopped:

	sudo systemctl status mysql.service

start mysql w/o granting the tables and networking check, set the environment variable “MYSQLD_OPTS” which MySQL uses on startup:

	sudo systemctl set-environment MYSQLD_OPTS="--skip-networking --skip-grant-tables"



`Change password policy`
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
_src_ : https://tecadmin.net/change-mysql-password-policy-level/

Login to MySQL command prompt and execute the below:

	SHOW VARIABLES LIKE 'validate_password%';


The default level is MEDIUM, we can change it to LOW by using the below query. The LOW level required only password’s length to min 8 characters:

	SET GLOBAL validate_password.policy=LOW;

To make this setting permanent edit MySQL configuration (my.cnf) file and add below settings

	sudo nano /etc/mysql/my.cnf

	[mysqld]
	validate_password.policy=LOW    (change to lesser password authentication)
	sql_mode=  						(disables strict mode in mysql, if shows "nonaggregated columns" in the error) 

more info: https://dba.stackexchange.com/questions/237048/1055-expression-1-of-select-list-is-not-in-group-by-clause-and-contains-nonag

	its default value = ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION

OR login mysql

	mysql> set global sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
	mysql> set session sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';


<!-- ------------------------------------------------------------------------------------------------------------------------- -->
## `REMOTE CONNECTION TO MYSQL`

	sudo mysql -u <database_username> -p -h <IP_address> -P <port_number>

then insert password

	-h = <hostname>
	-P = <upper case P, port number>
	-p = <lower case P, password authentication>


<!-- ------------------------------------------------------------------------------------------------------------------------- -->
## `BACKUP MYSQL DATABASE`
https://phoenixnap.com/kb/how-to-backup-restore-a-mysql-database





<!-- ------------------------------------------------------------------------------------------------------------------------- -->
## `MYSQL INDEX`

>	show which columns are indexed:

	SHOW INDEXES FROM <table_name>; 

>	create index:

	CREATE INDEX index_name ON table_name (col1, col2, ...);

>	drop index 

	ALTER TABLE table_name DROP INDEX index_name;