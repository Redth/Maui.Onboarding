
Param([String] $PackageName, [Bool] $Test)


function Get-VSIXInstallerPath {
    # Path to vswhere.exe
    $vswherePath = "${Env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"

    if (-Not (Test-Path $vswherePath)) {
        throw "vswhere.exe not found at $vswherePath"
    }

    # Run vswhere.exe to find Visual Studio installation path
    $vsInstallPath = & $vswherePath -latest -requires Microsoft.Component.MSBuild -find "Common7\IDE\VSIXInstaller.exe"

    if (-Not $vsInstallPath) {
        throw "VSIXInstaller.exe not found"
    }

    return $vsInstallPath
}

function Get-VSMarketPlaceExtension {
    [CmdLetBinding()]
    Param(
        [Parameter(ValueFromPipeline = $true,Mandatory = $true)]
        [string[]]
        $extensionName
    )
    begin {
        $body=@{
            filters = ,@{
            criteria =,@{
                    filterType=7
                    value = $null
                }
            }
            flags = 1712
        }    
    }
    process {
        foreach($Extension in $extensionName) {
            $response =  try {
                $body.filters[0].criteria[0].value = $Extension
                $Query =  $body|ConvertTo-JSON -Depth 4
                (Invoke-WebRequest -Uri "https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery?api-version=6.0-preview" -ErrorAction Stop -Body $Query -Method Post -ContentType "application/json")
            } catch [System.Net.WebException] { 
                Write-Verbose "An exception was caught: $($_.Exception.Message)"
                $_.Exception.Response 
            }
            $statusCodeInt = [int]$response.StatusCode

            if ($statusCodeInt -ge 400) {
                Write-Warning "Erreur sur l'appel d'API :  $($response.StatusDescription)"
                return
            }
            $ObjResults = ($response.Content | ConvertFrom-Json).results
    
            If ($ObjResults.resultMetadata.metadataItems.count -ne 1) {
                Write-Warning "l'extension '$Extension' n'a pas été trouvée."
                return
            }
    
            $Extension = $ObjResults.extensions
    
            $obj2Download = ($Extension.versions[0].properties | Where-Object key -eq 'Microsoft.VisualStudio.Services.Payload.FileName').value
            [PSCustomObject]@{
                displayName = $Extension.displayName
                extensionId = $Extension.extensionId
                deploymentType = ($obj2Download -split '\.')[-1]
                version = [version]$Extension.versions[0].version
                LastUpdate = [datetime]$Extension.versions[0].lastUpdated
                IsValidated = ($Extension.versions[0].flags -eq "validated")
                extensionName = $Extension.extensionName 
                publisher     = $Extension.publisher.publisherName
                SourceURL = $Extension.versions[0].assetUri +"/" + $obj2Download
                FileName = $obj2Download                     
            }             
        }
    }
}

function Install-VSExtension {
    param (
        [string]$PackageName
    )

    $vsixInstallerPath = Get-VSIXInstallerPath
    $vsixUrl = (Get-VSMarketPlaceExtension "$PackageName").SourceUrl

    $vsixPath = New-TemporaryFile

    try {
        Invoke-WebRequest -Uri $vsixUrl -OutFile $vsixPath
    }
    catch {
        Remove-Item $vsixPath -Force
        throw $_
    }


    # Install the extension
    Start-Process -FilePath $vsixInstallerPath -ArgumentList "/quiet", "/install:$vsixPath" -Wait

    # Clean up the downloaded file
    Remove-Item -Path $vsixPath -Force
}

if ($Test) {
     $vsixInstallerPath = Get-VSIXInstallerPath

     $installedExtensions = & "$vsixInstallerPath" /list | Select-String -Pattern $PackageName

    return $installedExtensions.Count -gt 0
}

# Apply the configuration
Install-VSExtension -PackageName "Redth.AndroidKeystoreSignatureTool"
