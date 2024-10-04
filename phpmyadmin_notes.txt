Increase execution times
------------------------------------
For Xampp version on Windows

Add this line to xampp\phpmyadmin\config.inc.php
    $cfg['ExecTimeLimit'] = 6000;
    // Zero for no limit


And Change xampp\php\php.ini to
    post_max_size = 750M        // zero for no limit
    upload_max_filesize = 750M   
    max_execution_time = 5000   
    max_input_time = 5000       // -1 for no limit
    memory_limit = 20000M


And change xampp\mysql\bin\my.ini
    max_allowed_packet = 200M

----------------------------------------
Upload large SQL to phpmyadmin when its too big via CMD(admin)  (windows)

https://medium.com/@amar.sky9100_12759/2-ways-to-import-large-sql-files-to-mysql-database-ef045e89d82a
or
https://www.thecodedeveloper.com/import-large-sql-files-xampp/

1)Go to xampp\mysql\bin
2)Open CMD with admin rigths
3)Run the command to import database 
    mysql -u username -p -v database_name < "/path/file.sql"       // make sure your path should be correct to the.sql file i.e

    Where:
    username – your MySQL username. e.g. root
    database_name – database name you are importing to
    /path/file.sql – full path to your .sql file