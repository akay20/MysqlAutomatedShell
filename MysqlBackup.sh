#!/bin/bash

# Define parmaters and values excluding {} e.x "{mysql_user}" > "root"
mysqlUser="{mysql_user}"
mysqlPass="{mysql_password}"
#logFile=DatabaseBackupLogs.txt
folderName="{folder_name}/"
logFile=$folderName/DatabaseBackupLogs.txt

# Check if folder exists else Create
if [ -d "$folderName" ]
then
    mkdir -p $folderName
    chmod -R 777 $folderName
fi

# Check if log file exists else Create
if [ ! -f $logFile ]
then
    touch $logFile
    chmod -R 777 $logFile
fi

logPrint(){
  echo "Date/Time: $(date +%T_%d-%m-%y): $*\n" >> $logFile
}

sleep 2s

# Mysql Dump command
mysqldump -u $mysqlUser -P 3306 -p$mysqlPass {database_name} > $folderName/$(date +%T-%d-%m-%y)database.sql

if [ $? -eq 0 ]
then
  logPrint "Database backup successfull."
else
  logPrint "Database backup failed."
fi

sleep 3s
# Delete Database file contents of before 10days (+10)
echo "Deleted: "
find $folderName -name "*.sql" -type f -mtime +10 -print -delete >> $logFile