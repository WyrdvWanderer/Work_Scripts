$directoryPath = "C:\Windows\IMECache"

# Enable debugging
$debugMode = $true

# List all items in the directory
Get-ChildItem -Path $directoryPath -Recurse | ForEach-Object {
    # Check if the item's FullName does not contain "Healthscripts"
    if ($_.FullName -notlike "*\Healthscripts\*") {
        if ($debugMode) {
            Write-Host "Processing $($_.FullName)"
        }
        
        try {
            # Apply icacls to grant permissions (Replace with your desired parameters)
            & icacls $_.FullName /grant Administrators:F /T /C /Q
            if ($debugMode) {
                Write-Host "Applied icacls to $($_.FullName)"
            }
            
            # Remove the item
            Remove-Item -Path $_.FullName -Force -ErrorAction Stop
            if ($debugMode) {
                Write-Host "Removed $($_.FullName)"
            }
        }
        catch {
            Write-Host "Error processing $($_.FullName): $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    else {
        if ($debugMode) {
            Write-Host "Excluded folder: $($_.FullName)"
        }
    }
}

# Disable debugging
$debugMode = $false

Write-Host "Script execution complete. Debugging mode disabled."
