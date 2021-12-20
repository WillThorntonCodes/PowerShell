#script to show DNS PTR from a list of IPs

$file = "ips.txt"                                                               
$ips = get-content -Path $file

$ips | % {
Resolve-DnsName $_ -server 8.8.8.8 -type PTR -ErrorAction SilentlyContinue | Sel
ect-Object NameHost -ExpandProperty NameHost
}
