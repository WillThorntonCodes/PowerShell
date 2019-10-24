#Purge folder to keep disk space free. 
#Set up in task scheduler to run every 'X' days.

#set path and file type to delete
#change wildcard accordingly
$path = "c:\dev\test\test_files\*.txt"
$count = Get-ChildItem -Path $path
$mydate = Get-Date -Format "dd-MM-yyyyHH_mm_ss"

#set error log path
#saves log files with the name format of: '01-06-201910_30_11.txt'
$errorLog = "c:\dev\test\logs\$mydate.txt" 

#purge files and write to log
if($count -ne 0){Remove-Item -Path $path -Recurse -Verbose *> $errorLog}
