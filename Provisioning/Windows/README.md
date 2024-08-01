# Windows Provisioning

## WinGet

```shell
pwsh
Install-Module -Name Microsoft.WinGet.Configuration -AllowPrerelease
Get-WinGetConfiguration -File ./maui.winget | Invoke-WinGetConfiguration
```
