# Send files from a folder to an FTP account
# Leverage WinSCP to perform FTP process

try{
    $report = Get-ChildItem -Path 'c:\scripts\reports\*' -Recurse

    $myDate = Get-Date -Format 'yyyy-dd-MM_hhmmss'
    if(($report|ForEach-Object{$_.name.contains("processed_")}) -contains $false){

        Add-Type -Path 'c:\WinSCP-5.15.3-Automation\WinSCPnet.dll'
        $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
        Protocol = [WinSCP.Protocol]::sftp
        HostName = 'sftp.sample.com'
        UserName = 'username'
        Password = 'password'
        SshHostkeyFingerprint = 'ssh-rsa 2048 [key]'
        }
        $session = New-Object WinSCP.Session
        $session.SessionLogPath = 'c:\scripts\logs\ftplog.txt'
        $session.Open($sessionOptions)
 
        try{
            $report | ForEach-Object{
                if(!$_.Name.contains("processed_")){
                    $transferOptions = New-Object WinSCP.TransferOptions
                    $transferOptions.TransferMode = [WinSCP.TransferMode]::Binary
                    $transferResult = $session.PutFiles($_.fullName,"/",$false,$transferOptions)
                    $transferResult.Check()
                    foreach($transfer in $transferResult.Transfers){
                        $time = get-date
                        Write-Output $time "Uploaded $($transfer.FileName) succeeded!" | out-file -FilePath "c:\scripts\logs\sendlog.txt" -Append
                    }
                    $newname = $_.Name
                    Rename-Item -Path $_.FullName -NewName $("processed_$myDate")$($newname)
                }
            }
        }
        finally{
            $session.Dispose()
        }
    }
}
 catch{
     $time = get-date
    logError($time,$_)
 }
 finally{
    $session.Dispose()
}

function logError($errTime, $err){
    Write-Output "$errTime : error:$($err.Exception.Message)" | out-file -FilePath "c:\reports\logs\errorlog.txt" -Append
}
