Start-Process winget -ArgumentList "install Microsoft.PowerShell --accept-package-agreements --accept-source-agreements --nowarn" -Wait

$workingDir = (Join-Path $env:Temp 'mauiprovision')

if (Test-Path $workingDir)
{
    Remove-Item -Recurse $workingDir
}

New-Item -Path $workingDir -Type Directory

$vsconfigBase64 = "[[VSCONFIG]]"
$elevatedWingetConfigBase64 = "[[ELEVATEDWINGET]]"
$userWingetConfigBase64 = "[[USERWINGET]]"

$vsconfig = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($vsconfigBase64))
$elevatedWingetConfig = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($elevatedWingetConfigBase64))
$userWingetConfig = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($userWingetConfigBase64))

$elevatedWingetConfigPath = (Join-Path $workingDir 'elevated.winget')
$userWingetConfigPath = (Join-Path $workingDir 'user.winget')

Set-Content -Path (Join-Path $workingDir '.vsconfig') -Value $vsconfig
Set-Content -Path $elevatedWingetConfigPath -Value $elevatedWingetConfig
Set-Content -Path $userWingetConfigPath -Value $userWingetConfig

Start-Process pwsh -ArgumentList "-Command &{ Install-Module -Name Microsoft.WinGet.Configuration -AllowPrerelease; Write-Information (Get-WinGetConfiguration -File $elevatedWingetConfigPath | Invoke-WinGetConfiguration -AcceptConfigurationAgreements).UnitResults }" -Verb runAs -Wait
Start-Process pwsh -ArgumentList "-Command &{ Install-Module -Name Microsoft.WinGet.Configuration -AllowPrerelease; Write-Information (Get-WinGetConfiguration -File $userWingetConfigPath | Invoke-WinGetConfiguration -AcceptConfigurationAgreements).UnitResults }" -Wait
