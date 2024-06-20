$directoryPath = "C:\Windows\IMECache"

# List all items in the directory
Get-ChildItem -Path $directoryPath -Recurse | ForEach-Object {
    Write-Host "Applying icacls to $($_.FullName)"
    try {
        # Replace the following icacls command with your desired parameters
        & icacls $_.FullName /grant Administrators:F /T /C /Q
    } catch {
        Write-Host "Error applying icacls to $($_.FullName): $($_.Exception.Message)" -ForegroundColor Red
    }
}
