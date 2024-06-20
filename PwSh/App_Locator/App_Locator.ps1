# Ask the user for the name of the application
$appName = Read-Host "Please enter the name of the application you want to locate"

# Function to find traditional installations using Win32_Product
function Find-Win32Product {
    param (
        [string]$productName
    )
    $product = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq $productName }
    if ($product) {
        return $product.InstallLocation
    } else {
        return $null
    }
}

# Function to search for executables in the system PATH
function Find-Executable {
    param (
        [string]$executableName
    )
    $path = where.exe $executableName -ErrorAction SilentlyContinue
    if ($path) {
        return $path
    } else {
        return $null
    }
}

# Function to find app packages
function Find-AppPackage {
    param (
        [string]$packageName
    )
    $package = Get-AppxPackage *$packageName* -ErrorAction SilentlyContinue
    if ($package) {
        return $package.InstallLocation
    } else {
        return $null
    }
}

# Search using Win32_Product
$win32Path = Find-Win32Product $appName
if ($win32Path) {
    Write-Output "$appName installation found at: $win32Path"
} else {
    # If Win32_Product does not find it, try where.exe
    $executableSearch = "$appName.exe"
    $exePath = Find-Executable $executableSearch
    if ($exePath) {
        Write-Output "$appName installation found at: $exePath"
    } else {
        # If where.exe does not find it, try AppxPackage
        $packagePath = Find-AppPackage $appName
        if ($packagePath) {
            Write-Output "$appName installation found at: $packagePath"
        } else {
            Write-Output "$appName installation not found."
        }
    }
}
