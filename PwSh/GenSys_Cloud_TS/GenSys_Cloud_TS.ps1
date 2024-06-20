# Clearing Edge Cache
Write-Output "Clearing Edge Cache..."
Remove-Item -Path "$env:LOCALAPPDATA\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\AC\*" -Recurse -Force

# Clearing Chrome Cache
Write-Output "Clearing Chrome Cache..."
Remove-Item -Path "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\*" -Recurse -Force

# Trigger Windows Update Check
Write-Output "Checking for Windows Updates..."
Start-Process "ms-settings:windowsupdate-action"

# List potential applications using the microphone
Write-Output "Listing applications that might be using the microphone..."
Get-Process | Where-Object { $_.MainWindowTitle -ne "" } | Format-Table Id, Name, MainWindowTitle -AutoSize

# Reset Audio Settings
Write-Output "Resetting Audio Settings..."
Get-PnpDevice -Class AudioEndpoint | Where-Object { $_.Status -eq "OK" } | ForEach-Object { Disable-PnpDevice -InstanceId $_.InstanceId -Confirm:$false; Enable-PnpDevice -InstanceId $_.InstanceId -Confirm:$false }

# Check Genesys Cloud Services Status
Write-Output "Checking Genesys Cloud Services status..."
# Assuming 'GenesysCloudServiceName' is the service name, replace it with the actual service name if different
$serviceStatus = Get-Service | Where-Object { $_.Name -like "*Genesys*" }
If ($serviceStatus.Status -ne "Running") {
    Write-Output "Starting Genesys Cloud Services..."
    Start-Service -Name $serviceStatus.Name
}

# Verify Communication Ports
Write-Output "Verifying Communication Ports for Genesys Cloud..."
# Example ports, replace with actual required ports
$ports = @(80, 443, 5060, 5061)
foreach ($port in $ports) {
    Test-NetConnection -ComputerName your.genesys.cloud -Port $port | Format-Table ComputerName, RemoteAddress, RemotePort, TcpTestSucceeded -AutoSize
}

# Enhanced Audio Troubleshooting
Write-Output "Enhanced Audio Troubleshooting..."
# Add additional troubleshooting steps specific to Genesys cloud audio issues here

# Consider adding checks for specific drivers or software updates related to audio devices, if known to be a common issue
