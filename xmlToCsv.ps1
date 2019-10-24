#Convert XML data to CSV then bulk load into a DB

$startDate = get-date

#path to xml file
[xml]$mydoc = get-content \\reportingServer\c$\soap2csv\records\output\records.xml

#invoke xmlnamespacemanager 
[System.Xml.XmlNamespaceManager]$ns = $mydoc.NameTable
$ns.AddNamespace("soapenv", $mydoc.DocumentElement.NamespaceURI)

#select node from XML tree
$node = $mydoc.SelectNodes("//soapenv:Envelope/*/*/*/NodeName",$ns)

#empty array to store data from xml
$array = @()

$node | ForEach-Object{

#build object
$Object = New-Object -TypeName PSObject

#if child nodes have children get them as well
$_.childNodes | ForEach-Object {
    if($_.childNodes.childNodes){
        $_.childNodes | ForEach-Object{
        $val = $_."#text" -replace "'", "''"
        Add-Member -InputObject $Object -MemberType NoteProperty -Name $_.name -Value $val -Force
        }
    }
    #convert UTC to Eastern time
    if($_.name -eq "Date"){
        $tz = [System.TimeZoneInfo]::GetSystemTimeZones() | 
        Where-Object { $_.Id -eq "US Eastern Standard Time" }
        $utc = [System.TimeZoneInfo]::GetSystemTimeZones() | 
        Where-Object { $_.Id -eq "UTC" }
        $tempTime = $_."#text" -replace '.000Z',''
        $time = (([datetime]::ParseExact($tempTime,"yyyy-MM-ddTHH:mm:ss",$null)))
        $newTime = [System.TimeZoneInfo]::ConvertTime($time,$utc,$tz).ToString("yyyy-MM-ddTHH:mm:ss")
        $val = $newTime
        Add-Member -InputObject $Object -MemberType NoteProperty -Name $_.name -Value $val -Force
    }
    if($_.name -eq "created_Date"){
        $tz = [System.TimeZoneInfo]::GetSystemTimeZones() | 
        Where-Object { $_.Id -eq "US Eastern Standard Time" }
        $utc = [System.TimeZoneInfo]::GetSystemTimeZones() | 
        Where-Object { $_.Id -eq "UTC" }
        $tempTime = $_."#text" -replace '.000Z',''
        $time = (([datetime]::ParseExact($tempTime,"yyyy-MM-ddTHH:mm:ss",$null)))
        $newTime = [System.TimeZoneInfo]::ConvertTime($time,$utc,$tz).ToString("yyyy-MM-ddTHH:mm:ss")
        $val = $newTime
        Add-Member -InputObject $Object -MemberType NoteProperty -Name $_.name -Value $val -Force
    }
    else{
        $val = $_."#text" -replace "'", "''"
        Add-Member -InputObject $Object -MemberType NoteProperty -Name $_.name -Value $val -Force
    }
}

#add object to array
$array += $Object
}

# Creates CSV file with '|' as the delimiter, issues when using a ',' because some records have commas in the description
Write-Output $array | Sort-Object 'Date' -Descending | Export-Csv -Path \\reportingServer\c$\soap2csv\records\output\Records.csv -NoTypeInformation -Delimiter "|"

#invoke cmd.exe and run SSIS package which will input csv data into a DB
$cmd = @'
@ECHO OFF
DTEXEC /FILE "\\reportingServer\c$\soap2csv\records\SSIS\recordsFlatFile\Package.dtsx"
'@
$cmd | cmd.exe

#get date and time of when completed and email to me
$endDate = Get-Date
Send-MailMessage -from 'reportingServer <reportingserver@email.com>' -To 'Willie Thornotn <connect@willthornton.me>' -Subject 'Report Job Complete' -Body "Job started on $startDate and ended on $endDate"  -SmtpServer 'mail.email.com'
