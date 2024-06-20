param(
    [string]$searchRoot,
    [string]$logFolderNamePart
)

# Function to search for log directories
function Find-LogDirectories {
    param(
        [string]$Path,
        [string]$FolderNamePart
    )

    # Recursively search for directories that include the folder name part
    Get-ChildItem -Path $Path -Directory -Recurse -ErrorAction SilentlyContinue | 
        Where-Object { $_.Name -like "*$FolderNamePart*" }
}

# Check if parameters were not provided and prompt for input
if (-not $searchRoot) {
    $searchRoot = Read-Host "Enter the root directory to search (e.g., C:\)"
}
if (-not $logFolderNamePart) {
    $logFolderNamePart = Read-Host "Enter part of the log folder name to search for"
}

# Calling the function
Find-LogDirectories -Path $searchRoot -FolderNamePart $logFolderNamePart |
    Select-Object FullName |  # Selecting the full path
    ForEach-Object {
        Write-Output "Potential log directory found: $($_.FullName)"
    }
