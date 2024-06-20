# Using Powershell we can add the Device to Autopilot

New-Item -Type Directory -Path "C:\HWID"
Set-Location C:\HWID
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
Install-Script -Name Get-WindowsAutopilotInfo -Force
$env:Path += ";C:\Program Files\WindowsPowerShell\Scripts"
Get-WindowsAutopilotInfo -OutputFile AutopilotHWID.csv
