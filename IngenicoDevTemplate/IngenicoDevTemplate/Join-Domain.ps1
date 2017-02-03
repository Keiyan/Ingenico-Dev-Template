#
# Join_Domain.ps1
#
Param(
    [string] [Parameter(Mandatory=$true)] $DomainUserName,
    [String] $DomainUserPassword
)

$ip = (Test-Connection -ComputerName "devsharepointad" -Count 1).IPV4Address.IPAddressToString
$password = ConvertTo-SecureString $DomainUserPassword -AsPlainText -Force 
$domainCrendentials = New-Object System.Management.Automation.PSCredential ("dev.ingenico.azure\$DomainUserName", $password)

Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ($ip)
Add-Computer -DomainName "dev.ingenico.azure" -Credential $domainCrendentials -Restart

