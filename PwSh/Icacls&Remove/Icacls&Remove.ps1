
$directoryPath = "C:\Windows\IMECache"

# List all items in the directory except for the HealthScripts folder
Get-ChildItem -Path $directoryPath -Recurse | Where-Object { $_.FullName -notmatch 'HealthScripts' } | ForEach-Object {
    Write-Host "Processing $($_.FullName)"

    # Apply icacls (set permissions)
    try {
        Write-Host "Applying icacls to $($_.FullName)"
        & icacls $_.FullName /grant Administrators:F /T /C /Q
    } catch {
        Write-Host "Error applying icacls to $($_.FullName): $($_.Exception.Message)" -ForegroundColor Red
    }

    # Remove the item
    try {
        Write-Host "Removing $($_.FullName)"
        Remove-Item -Path $_.FullName -Force -ErrorAction Stop
    } catch {
        Write-Host "Error removing $($_.FullName): $($_.Exception.Message)" -ForegroundColor Red
    }
}
