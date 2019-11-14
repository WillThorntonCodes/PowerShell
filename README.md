# PowerShell
PS scripts for automation tasks
Scripts I have created over the past year(2018-2019) for various projects.

## PurgeFolder.ps1
Reason or need: An application print server creates PDF files of each print job and stores them on the HDD. The files are not deleted automatically after their usefullness. I was asked to create a automated task to delete the contents of the folder every three days. This script will check the folder for files and delete them accordingly. Verbose output is sent to a log file. Created a batch file and set it up to exceute this .PS1 in Task Scheduler to run every third day. 

## xmlToCsv.ps1
Reason or need: Moving over to new finance software and need to export finance data from Oracle to MSSQL. MRO vendor provided an API to interface with the backend of the application. API uses SOAP for transactions. I wrote a C# console application to make the SOAP requests and converts them to XML. This script is then called from the console application and converts the XML into CSV then invokes CMD.exe to run an SSIS package that bulk loads the data into a DB.

## FTPSendFiles.ps1
Reason: Workgroups have reports and other types of files that must bw sent to vendors via FTP. Created a script to automate sending these files as determined. The workgroup will drop the files to a folder, the script will scan the folder for files. When found, WinSCP is invoked and will send the files. After they are sent, the files are renamed with the prefix of "processed_[date]" appended to the filename. Next time script runs it will not resend the processed files.

## RunSSISPackage.ps1
Reason: Workgroup wanted an SSRS report to run and send a notification when the report was not null. SSRS does not have a way to do this internally. I placed the query into an SSIS package that outputs the returned data into a CSV. This script runs the SSIS package and checks the CSV for data if not null, it sends an email to the manager with the CSV attachment. NOTE: The query in the report I wrote this for only returns data if it is present at a given timeframe. Normally, data clears within 30 mins so the report will not send all that often.
