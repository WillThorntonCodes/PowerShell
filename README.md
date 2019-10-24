# PowerShell
PS scripts for automation tasks
Scripts I have created over the past year(2018-2019) for various projects.

## Script name: PurgeFolder.ps1
Reason or need: An application print server creates PDF files of each print job and stores them on the HDD. The files are not deleted automatically after their usefullness. I was asked to create a automated task to delete the contents of the folder every three days. This script will check the folder for files and delete them accordingly. Verbose output is sent to a log file. Created a batch file and set it up to exceute this .PS1 in Task Scheduler to run every third day. 

## Script name: xmlToCsv.ps1
Reason or need: Moving over to new finance software and need to export finance data from Oracle to MSSQL. MRO vendor provided an API to interface with the backend of the application. API uses SOAP for transactions. I wrote a C# console application to make the SOAP requests and converts them to XML. This script is then called from the console application and converts the XML into CSV then invokes CMD.exe to run an SSIS package that bulk loads the data into a DB.
