Param(
    [string] [Parameter(Mandatory=$true)] $DomainUserName,
    [String] $DomainUserPassword
)


# Values mentioned below needs to be edited

$DatabaseServer = “.\SQLEXPRESS”; #SPecify the instance name if SQL is not installed on default instance
$FarmName = “Ingenico”;

$ConfigDB = $FarmName+“_ConfigDB”;
$AdminContentDB = $FarmName+“_CentralAdminContent”;

$Passphrase = convertto-securestring $DomainUserPassword -asplaintext -force;

$Port = “2013”;
$Authentication = “NTLM”;
$FarmAccount = “dev.ingenico.azure\$DomainUserName”

$password = ConvertTo-SecureString $DomainUserPassword -AsPlainText -Force 
$domainCrendentials = New-Object System.Management.Automation.PSCredential ("dev.ingenico.azure\$DomainUserName", $password)

##########################################################################

############################### DO NOT EDIT ANYTHING BELOW THIS LINE #####

##########################################################################

#Start Loading SharePoint Snap-in

$snapin = (Get-PSSnapin -name Microsoft.SharePoint.PowerShell -EA SilentlyContinue)

if ($snapin -ne $null)
{
	write-host -f Green “SharePoint Snapin is loaded… No Action taken”
}
else
{
	write-host -f Yellow “SharePoint Snapin not found… Loading now”
	Add-PSSnapin Microsoft.SharePoint.PowerShell
	write-host -f Green “SharePoint Snapin is now loaded”
}

# END Loading SharePoint Snapin

# checking to see if SharePoint Binaries are installed

if((Get-WmiObject -Class Win32_Product | Where {$_.Name -eq “Microsoft SharePoint Server 2013 “}) -ne $null)

{
	write-host “Found SharePoint Server 2013 Binaries. Will create Farm now”
	New-SPConfigurationDatabase -DatabaseName $ConfigDB -DatabaseServer $DatabaseServer -FarmCredentials $domainCrendentials -Passphrase $Passphrase -AdministrationContentDatabaseName $AdminContentDB

	Remove-PSSnapin Microsoft.SharePoint.PowerShell
	Add-PSSnapin Microsoft.SharePoint.PowerShell

	Install-SPHelpCollection -All
	write-host “Installed Help Collection”

	Initialize-SPResourceSecurity
	write-host “Initialized SP Resource Security”

	Install-SPService
	write-host “Instaled Ssp service”

	Install-SPFeature -AllExistingFeatures
	write-host “Installed SP Feature”

	New-SPCentralAdministration -Port $Port
	write-host “Created Central Administration Site”

	Install-SPApplicationContent
	write-host -f Green “Installed Application Content. This was the last step.
	Farm Configuration Complete!”
}
else
{
	Write-error “SP Binaries not found”
	exit 1
}