param([Parameter(Mandatory=$true)][string]$chocoPackages)

Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

$chocoPackages.Split(";") | ForEach {
    $command = "cinst " + $_ + " -y -force"
    #$command | Out-File $LogFile -Append
    $sb = [scriptblock]::Create("$command")

    # Use the current user profile
    Invoke-Command -ScriptBlock $sb -ArgumentList $chocoPackages
}
