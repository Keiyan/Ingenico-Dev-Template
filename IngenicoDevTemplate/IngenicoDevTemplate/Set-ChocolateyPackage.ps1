param([Parameter(Mandatory=$true)][string]$chocoPackages)

Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

# Create temp folder because normal one is in C:\Windows and that can cause problems
New-Item -Path 'C:\Temp' -ItemType Directory | Out-Null
[Environment]::SetEnvironmentVariable('TEMP', 'C:\Temp') #make the change permanent
$command = 'choco config set cachelocation C:\Temp'
$sb = [scriptblock]::Create("$command")

# Use the current user profile
Invoke-Command -ScriptBlock $sb -ArgumentList $chocoPackages

$chocoPackages.Split(";") | ForEach {
    $command = "cinst " + $_ + " -y -force"
    #$command | Out-File $LogFile -Append
    $sb = [scriptblock]::Create("$command")

    # Use the current user profile
    Invoke-Command -ScriptBlock $sb -ArgumentList $chocoPackages
}
