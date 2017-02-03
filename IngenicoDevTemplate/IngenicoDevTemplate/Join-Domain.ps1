#
# Join_Domain.ps1
#
Param(
    [string] [Parameter(Mandatory=$true)] $DomainJoinUserName,
    [SecureString] $DomainJoinUserPassword
)

$ip = (Test-Connection -ComputerName "devsharepointad" -Count 1).IPV4Address.IPAddressToString
$domainCrendentials = New-Object System.Management.Automation.PSCredential ($DomainJoinUserName, $DomainJoinUserPassword)

Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ($ip)
Add-Computer -DomainName "dev.ingenico.azure" -Credential $domainCrendentials -Restart

