# Maui.Onboarding
Docs, scripts, helpers, and more to configure your environment easily for .NET MAUI development

## Provisioning
The Provisioning directory provides scripts and examples of how to quickly provision your machine with all of the software, tooling, and configuration changes you might need to develop .NET MAUI.

### Windows
Windows makes use of WinGet using a `[name].winget` configuration file which defines resources to be installed / applied using the PowerShell Desired System Configuration packages.
There's also a `.vsconfig` file which specifies the necessary Visual Studio components to be installed.
