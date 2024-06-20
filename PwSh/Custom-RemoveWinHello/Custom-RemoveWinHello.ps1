# Disable PIN by setting registry values 
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "AllowDomainPINLogon" -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowSignInOptions" -Name "value" -Value 0

# Remove contents inside the NGC folder
$ngcFolderPath = "C:\Windows\ServiceProfiles\LocalService\AppData\Local\Microsoft\NGC"
$backupFolderPath = "$ngcFolderPath\Backup"

# Create a backup of the NGC folder (optional)
Copy-Item -Path $ngcFolderPath -Destination $backupFolderPath -Recurse -Force

# Take ownership of the NGC folder and grant administrators full control
Start-Process -FilePath "cmd.exe" -ArgumentList '/s,/c,takeown /f C:\Windows\ServiceProfiles\LocalService\AppData\Local\Microsoft\NGC /r /d y & icacls C:\Windows\ServiceProfiles\LocalService\AppData\Local\Microsoft\NGC /grant administrators:F /t' -Verb runAs

# Remove the contents of the NGC folder
Remove-Item -Path $ngcFolderPath -Recurse -Force

# Recreate the NGC folder
New-Item -ItemType Directory -Path $ngcFolderPath | Out-Null

# Reset permissions on the NGC folder
icacls $ngcFolderPath /T /Q /C /RESET
