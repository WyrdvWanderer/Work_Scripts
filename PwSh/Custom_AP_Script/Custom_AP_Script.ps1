# Identify the USB drive
$usbDrive = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.VolumeName -eq 'MediCat v21.12' } | Select-Object -ExpandProperty DeviceID

if ($null -eq $usbDrive) {
    Write-Host "USB drive 'MediCat v21.12' not found."
    exit
}

# Set the path for the output file
$outputPath = Join-Path -Path $usbDrive -ChildPath "Documents\Auto_Pilot\AutopilotHWID.csv"

# Ensure the output directory exists
$outputDirectory = Split-Path -Path $outputPath -Parent
if (-not (Test-Path -Path $outputDirectory)) {
    New-Item -Type Directory -Path $outputDirectory | Out-Null
}

# Set an exclusion in Microsoft Defender (requires administrative privileges)
Add-MpPreference -ExclusionPath $usbDrive

# Set the execution policy for the current process
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned -Force

# Install the Get-WindowsAutopilotInfo script
Install-Script -Name Get-WindowsAutopilotInfo -Force

# Ensure the script path is in the $env:Path
$env:Path += ";C:\Program Files\WindowsPowerShell\Scripts"

# Get the Windows Autopilot Info and save it to the output file
Get-WindowsAutopilotInfo -OutputFile $outputPath
