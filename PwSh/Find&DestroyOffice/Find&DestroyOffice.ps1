function Uninstall-Office {
    param (
        [string]$UninstallString
    )
    Start-Process "cmd.exe" -ArgumentList "/c $UninstallString" -Wait -NoNewWindow
}

function Install-Office {
    param (
        [string]$SetupPath,
        [string]$ConfigFile
    )
    Start-Process "cmd.exe" -ArgumentList "/c `"$SetupPath`" /configure `"$ConfigFile`"" -Wait -NoNewWindow
}

# Check for 64-bit Office in the standard location
$office64 = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "*Microsoft Office*" }

# Check for 32-bit Office in the WOW6432Node location
$office32 = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "*Microsoft Office*" }

# Combine the results
$office = $office64 + $office32

# Display and uninstall the found Office installations, if any
if ($office) {
    $office | ForEach-Object {
        $arch = if ($_.PSPath -like "*Wow6432Node*") { "32-bit" } else { "64-bit" }
        Write-Output "Found $($_.DisplayName) version $($_.DisplayVersion) architecture $arch"

        # Assuming the UninstallString is available and correct
        if ($_.UninstallString) {
            Write-Output "Uninstalling $($_.DisplayName)..."
            Uninstall-Office -UninstallString $_.UninstallString
        }
        else {
            Write-Output "UninstallString not found. Manual uninstallation may be required."
        }
    }
}
else {
    Write-Output "No Microsoft Office installation found."
}

# Install a new version of Office
# Provide the path to the Office setup and configuration file
$setupPath = "C:\Path\To\Office\Setup.exe"
$configFile = "C:\Path\To\Configuration\File.xml"
Write-Output "Starting Office installation..."
Install-Office -SetupPath $setupPath -ConfigFile $configFile
