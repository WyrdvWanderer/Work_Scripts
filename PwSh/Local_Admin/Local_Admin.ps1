# Launch cmd.exe as a different user
Start-Process cmd.exe -Credential (Get-Credential)

# Navigate to the file location of cmd.exe twice
$cmdPath = (Get-Command cmd.exe).Source
Push-Location $cmdPath
$cmdParentPath = Split-Path $cmdPath -Parent
Push-Location $cmdParentPath

# Prompt the user to enter the user name to add to the local administrators group
$userName = Read-Host "Enter the user name to add (e.g. GOVNET\john.doe@customerservice.nsw.gov.au)"

# Add the user to the local administrators group
net localgroup administrators $userName /add