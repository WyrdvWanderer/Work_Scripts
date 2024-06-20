# Enable strict mode to catch undeclared variables and other issues
Set-StrictMode -Version Latest

# Prompt user for the paths to the Excel files
$file1Path = Read-Host "Please enter the full path to the first Excel file"
$file2Path = Read-Host "Please enter the full path to the second Excel file"

# Check if the Excel files exist
Write-Host "Checking if the files exist..."
if (-not (Test-Path -Path $file1Path -PathType Leaf)) {
    Write-Host "The file at path '$file1Path' does not exist."
    return
}

if (-not (Test-Path -Path $file2Path -PathType Leaf)) {
    Write-Host "The file at path '$file2Path' does not exist."
    return
}

# Extract filenames from the paths for later use in the output
$file1Name = Split-Path -Path $file1Path -Leaf
$file2Name = Split-Path -Path $file2Path -Leaf

# Start Excel COM Object
Write-Host "Starting Excel COM object..."
$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false

# Open the workbooks with exception handling
try {
    Write-Host "Opening workbook: $file1Name"
    $workbook1 = $excel.Workbooks.Open($file1Path)
} catch {
    Write-Host "Failed to open the workbook at path: $file1Path"
    $excel.Quit()
    return
}

try {
    Write-Host "Opening workbook: $file2Name"
    $workbook2 = $excel.Workbooks.Open($file2Path)
} catch {
    Write-Host "Failed to open the workbook at path: $file2Path"
    $excel.Quit()
    return
}

# Get the WorkSheets
try {
    Write-Host "Accessing sheet from $file1Name"
    $sheet1 = $workbook1.Sheets.Item(1)
} catch {
    Write-Host "Failed to access the sheet from $file1Name"
    $excel.Quit()
    return
}

try {
    Write-Host "Accessing sheet from $file2Name"
    $sheet2 = $workbook2.Sheets.Item(1)
} catch {
    Write-Host "Failed to access the sheet from $file2Name"
    $excel.Quit()
    return
}

# Function to read data from a worksheet
function Read-WorksheetData {
    param(
        $Worksheet,
        $RowCount
    )

    $data = @()

    for ($row = 2; $row -le $RowCount; $row++) {
        $name = $Worksheet.Cells.Item($row, 1).Text
        $objectId = $Worksheet.Cells.Item($row, 2).Text
        
        if (-not [string]::IsNullOrWhiteSpace($name) -and -not [string]::IsNullOrWhiteSpace($objectId)) {
            $data += [PSCustomObject]@{
                Name     = $name
                ObjectID = $objectId
            }
        }
    }

    return $data
}

# Read the 'Name' and 'Object ID' columns
try {
    Write-Host "Reading data from $file1Name"
    $range1 = $sheet1.UsedRange.Rows.Count
    $data1 = Read-WorksheetData -Worksheet $sheet1 -RowCount $range1
} catch {
    Write-Host "Failed to read data from $file1Name $_"
    $excel.Quit()
    return
}

try {
    Write-Host "Reading data from $file2Name"
    $range2 = $sheet2.UsedRange.Rows.Count
    $data2 = Read-WorksheetData -Worksheet $sheet2 -RowCount $range2
} catch {
    Write-Host "Failed to read data from $file2Name $_"
    $excel.Quit()
    return
}

# Close the workbooks
$workbook1.Close($false)
$workbook2.Close($false)
$excel.Quit()

# Release the COM objects
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($sheet1) | Out-Null
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($sheet2) | Out-Null
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($workbook1) | Out-Null
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($workbook2) | Out-Null
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()

# Compare the Object IDs and find those that don't match in both lists
$nonMatchingFrom1 = $data1 | Where-Object { $_.ObjectID -notin $data2.ObjectID }
$nonMatchingFrom2 = $data2 | Where-Object { $_.ObjectID -notin $data1.ObjectID }

# Display the non-matching Names and Object IDs
Write-Host "Entries in '$file1Name' but not in '$file2Name':"
$nonMatchingFrom1 | Format-Table -AutoSize

Write-Host "Entries in '$file2Name' but not in '$file1Name':"
$nonMatchingFrom2 | Format-Table -AutoSize