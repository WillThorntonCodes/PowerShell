#Run SSIS package every x time period
#Sends email when complete

do {
	try {
		#run SSIS package that creates csv from report SQL query. Outputs to .\output folder
		$cmd = @'
@ECHO OFF
DTEXEC /FILE "C:\SSIS Programs\Reports\Package.dtsx"
'@
		$cmd | cmd.exe | out-file -FilePath "C:\SSIS Programs\Reports\output\log.txt" -Append
	}
	catch {
		$_.Exception | out-file -FilePath "C:\SSIS Programs\Reports\output\log.txt" -Append
	}
	finally {
		#imports csv file
		$data = import-csv -Path "C:\SSIS Programs\Reports\output\report.csv" -Delimiter ','
		if ($null -ne $data) {
			$dataString = $data | Out-String
			$body = "The Report has run successfully! `n$dataString `n"
			Send-MailMessage -from 'ReportingServer <do-not-reply@domain.com>' -To 'test email <test.email@domain.com>' -Subject 'My Report' -Body $body -Attachments "C:\SSIS Programs\Reports\output\report.csv" -SmtpServer 'mail.domain.com'
		}
	}
}
#start script every 30 minutes
until(start-sleep -Seconds 1800)
