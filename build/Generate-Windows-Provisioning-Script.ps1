
$vsconfigBase64 = [System.Convert]::ToBase64String((Get-Content -Path '..\Provisioning\Windows\.vsconfig' -AsByteStream -Raw))
$elevatedWingetConfigBase64 = [System.Convert]::ToBase64String((Get-Content -Path '..\Provisioning\Windows\elevated.winget' -AsByteStream -Raw))
$userWingetConfigBase64 = [System.Convert]::ToBase64String((Get-Content -Path '..\Provisioning\Windows\user.winget' -AsByteStream -Raw))

(Get-Content ".\Provision-Windows-Template.ps1").Replace("[[VSCONFIG]]", $vsconfigBase64).Replace("[[ELEVATEDWINGET]]", $elevatedWingetConfigBase64).Replace("[[USERWINGET]]", $userWingetConfigBase64) | Set-Content '..\ProvisionWindows.ps1'