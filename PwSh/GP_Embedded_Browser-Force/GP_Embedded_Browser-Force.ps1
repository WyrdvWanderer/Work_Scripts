# PowerShell Script to Troubleshoot PanGPS Embedded Browser Issues

# Change the default browser setting in registry
Set-ItemProperty -Path "HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect\Settings" -Name "default-browser" -Value "NO"

# Restart the PanGPS Service
Restart-Service -Name PanGPS

# Remove the user-specific key (optional, can be uncommented if required)
# Get the user's SID
#$userSid = (New-Object System.Security.Principal.NTAccount($env:USERNAME)).Translate([System.Security.Principal.SecurityIdentifier]).Value

# Remove the registry key
#Remove-Item -Path "HKU:\$userSid\Software\Palo Alto Networks" -Recurse

# Print completion message
Write-Output "Script executed successfully. Please verify if the issue is resolved. If not, consider uncommenting and running the user-specific key removal section."

