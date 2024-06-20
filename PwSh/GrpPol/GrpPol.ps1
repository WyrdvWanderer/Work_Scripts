# Enhanced script to list all GPOs and their settings, and clear a specific registry-based GPO setting

# Function to list all GPOs and their settings
function List-GPOsAndSettings {
    Get-GPO -All | ForEach-Object {
        $GPO = $_
        try {
            $GPOReportXml = Get-GPOReport -Name $GPO.DisplayName -ReportType Xml
            [xml]$GPOReport = $GPOReportXml
            Write-Output "GPO Name: $($GPO.DisplayName)"
            Write-Output "GPO Settings:"
            $GPOReport.GPO.Computer.ExtensionData.Extension.Policy | ForEach-Object {
                Write-Output "  $($_.Name)"
            }
        }
        catch {
            Write-Warning "Failed to retrieve report for GPO: $($GPO.DisplayName)"
        }
    }
}

# Function to clear a specific registry-based GPO setting
function Clear-GPORegistrySetting {
    param (
        [string]$GPOName,
        [string]$RegistryKey,
        [string]$ValueName
    )

    if (Test-Path $RegistryKey) {
        try {
            Remove-ItemProperty -Path $RegistryKey -Name $ValueName -ErrorAction Stop
            Write-Output "Successfully removed registry setting: $ValueName from $RegistryKey"
        }
        catch {
            Write-Error "Failed to remove registry setting: $ValueName from $RegistryKey"
        }
    }
    else {
        Write-Warning "Registry key does not exist: $RegistryKey"
    }

    # Refresh Group Policy
    try {
        gpupdate /force
        Write-Output "Group Policy update forced successfully."
    }
    catch {
        Write-Error "Failed to force update Group Policy."
    }
}

# Example usage
List-GPOsAndSettings

# Clear a specific registry-based GPO setting (replace placeholders with actual values)
Clear-GPORegistrySetting -GPOName "YourGPOName" -RegistryKey "HKLM\Software\Policies\YourPolicyKey" -ValueName "YourValueName"
