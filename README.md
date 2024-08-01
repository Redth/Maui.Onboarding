# Maui.Onboarding
Docs, scripts, helpers, and more to configure your environment easily for .NET MAUI development

## Provisioning
The Provisioning directory provides scripts and examples of how to quickly provision your machine with all of the software, tooling, and configuration changes you might need to develop .NET MAUI.

### Windows
Windows makes use of WinGet configurations using both `user.winget` and `elevated.winget` configuration files which define resources to be installed / applied using the PowerShell Desired System Configuration packages.
There's also a `.vsconfig` file which specifies the necessary Visual Studio components to be installed.

All of these files get packaged as base64 strings into a boostrap wrapper .ps1 provisioning script which can be downloaded and executed directly with the command:

```
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://github.com/Redth/Maui.Onboarding/releases/latest/download/ProvisionWindows.ps1'))
```
