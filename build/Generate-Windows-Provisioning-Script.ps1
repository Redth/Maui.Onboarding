
$vsconfigBase64 = [System.Convert]::ToBase64String((Get-Content -Path '..\Provisioning\Windows\.vsconfig' -AsByteStream -Raw))
$wingetConfigBase64 = [System.Convert]::ToBase64String((Get-Content -Path '..\Provisioning\Windows\maui.winget' -AsByteStream -Raw))

(Get-Content ".\Provision-Windows-Template.ps1").Replace("[[VSCONFIG]]", $vsconfigBase64).Replace("[[WINGETCONFIG]]", $wingetConfigBase64) | Set-Content '..\ProvisionWindows.ps1'