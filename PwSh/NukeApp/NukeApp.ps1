# Install software (MSI INSTALLER)
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i C:\path\to\software.msi /qn"

# Uninstall software (MSI INSTALLER)
Get-WmiObject -Class Win32_Product -Filter "Name='Software Name'" | ForEach-Object { $_.Uninstall() }
