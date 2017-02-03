#
# Join_Domain.ps1
#
Param(
    [string] [Parameter(Mandatory=$true)] $DomainUserName,
    [SecureString] $DomainUserPassword
)

$ip = (Test-Connection -ComputerName "devsharepointad" -Count 1).IPV4Address.IPAddressToString
$domainCrendentials = New-Object System.Management.Automation.PSCredential ($DomainUserName, $DomainUserPassword)

Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ($ip)
Add-Computer -DomainName "dev.ingenico.azure" -Credential $domainCrendentials -Restart

