# This script will import a list of hostnames or ip addresses and check if they are online.

$hostnames = Get-Content -Path hostnames.txt

$array = @()
$hostnames | % {
	$answer = (test-connection -ComputerName $_ -Count 1 -ErrorAction SilentlyContinue -ErrorVariable processError).Status
	if($answer -ne 'Success'){
		$answer = "Failed"
	}
	$prop = @{
		hostname = $_
		status = $answer
	}
	$obj = New-Object psobject -Property $prop
	$array += $obj
}
$array | Select-Object hostname, status
