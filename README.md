# PowerShell
PS scripts for automation tasks
Scripts I have created over the past year(2018-2019) for various projects.

Script name: PurgeFolder
Reason or need: An application print server creates PDF files of each print job and stores them on the HDD. The files are not deleted automatically after their usefullness. I was asked to create a automated task to delete the contents of the folder every three days. This script will check the folder for files and delete them accordingly. Verbose output is sent to a log file. Created a batch file and set it up to exceute this .PS1 in Task Scheduler to run every third day. 
