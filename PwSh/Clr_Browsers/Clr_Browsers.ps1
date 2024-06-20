# Define cache paths for Chrome, Firefox, and Edge on Windows 10
$chromeCachePath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache"
$firefoxCachePath = "$env:APPDATA\Mozilla\Firefox\Profiles"
$edgeCachePath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache"

# Function to clear cache
function Clear-BrowserCache {
    param (
        [string]$path
    )
    if (Test-Path $path) {
        Get-ChildItem $path -Recurse | Remove-Item -Force -Recurse
        Write-Output "Cleared cache at $path"
    } else {
        Write-Output "Cache path not found: $path"
    }
}

# Clear cache for Chrome, Firefox, and Edge
Clear-BrowserCache -path $chromeCachePath

# For Firefox, we need to find each profile directory
if (Test-Path $firefoxCachePath) {
    $profiles = Get-ChildItem $firefoxCachePath
    foreach ($profile in $profiles) {
        $firefoxProfileCachePath = Join-Path $profile.FullName "cache2"
        Clear-BrowserCache -path $firefoxProfileCachePath
    }
}

Clear-BrowserCache -path $edgeCachePath
