
#Requires -RunAsAdministrator
#Requires -PSEdition Core

if ($PSVersionTable.PSEdition -ne 'Core')
{
    Write-Error 'Please run the script in PowerShell Core (pwsh)'
    exit 1   
}

$workingDir = (Join-Path $env:Temp 'mauiprovision')

if (Test-Path $workingDir)
{
    Remove-Item -Recurse $workingDir
}

New-Item -Path $workingDir -Type Directory

$vsconfigBase64 = "[[VSCONFIG]]"
$wingetConfigBase64 = "[[WINGETCONFIG]]"

$vsconfig = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($vsconfigBase64))
$wingetConfig = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($wingetConfigBase64))


Set-Content -Path (Join-Path $workingDir '.vsconfig') -Value $vsconfig
Set-Content -Path (Join-Path $workingDir 'maui.winget') -Value $wingetConfig


Install-Module -Name Microsoft.WinGet.Configuration -AllowPrerelease
$results = (Get-WinGetConfiguration -File (Join-Path $workingDir 'maui.winget') | Invoke-WinGetConfiguration)

Write-Information $results.UnitResults
