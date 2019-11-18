#Split-Files.ps1
#Split files into smaller files if the initial file contains more than 10000 rows
#Incoming files go to the staging folder 
#Work is done in the temp folder

$stagingFolder = "C:\dev\Staging"
$tempFolder = "C:\dev\Temp\"
$inboxFolder = "C:\dev\Inbox\"
$archiveFolder = "C:\dev\Archive"
$limit = 999 #Use 1 less from desired limit to account for the inserted header

#read csv files from source and determine if they are more than row limit
$files = Get-ChildItem -Path $stagingFolder
$files | ForEach-Object{
  $fileLines = Get-Content $_.FullName
  if($fileLines.Length -gt $limit){
    $name = $_.BaseName

    #if over limit, splits the file into chunks and writes them to temp folder
    $i = 0
    Get-Content $_.FullName -ReadCount $limit | 
    ForEach-Object{
      $i++
      $_ | Out-File $tempFolder$i$name.txt      
    }
  }
}

#converts text files in temp folder into csv format
$textFiles = Get-ChildItem -Path $tempFolder
$textFiles | ForEach-Object{

    #if file is the first in the series, get header from first row
    if($_.FullName.Contains("[header column value]")){
        $header = Get-Content -Path $_.FullName -first 1 #get header row
    }

    #if file does not contain a header, inserts header
    if(!((Get-Content -path $_.fullname -first 1).Contains("[header column value]"))){
         $header+"`r`n"+(Get-Content $_.FullName -Raw) | #-Raw flag maintains formating!!
         out-file -FilePath $tempFolder$($_.BaseName).txt
    }
    Import-Csv $_.FullName -Delimiter "," |
    Export-Csv "$inboxFolder$($_.BaseName).csv" -NoTypeInformation
}

#empty temp and staging folder
Remove-Item -Path $tempFolder*
Remove-Item -Path $stagingFolder*

#move inbox files to archive folder
Move-Item -Path $inboxFolder* -Destination $archiveFolder
