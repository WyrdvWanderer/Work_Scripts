# Enable strict mode to catch undeclared variables and other issues
Set-StrictMode -Version Latest

# Paths to the Excel files
$file1Path = "C:\SWTOOLS\DEV\Work_Scripts\_Assests\WCA-5CD92242VW(Robert Sirio).csv"
$file2Path = "C:\SWTOOLS\DEV\Work_Scripts\_Assets\WCA-CND1432F9G(Robert Sirio).csv"

# Check if the Excel files exist
Write-Host "Checking if the files exist..."
if (-not (Test-Path -Path $file1Path -PathType Leaf)) {
    Write-Host "File 1 does not exist at path: $file1Path"
    return
}

if (-not (Test-Path -Path $file2Path -PathType Leaf)) {
    Write-Host "File 2 does not exist at path: $file2Path"
    return
}

# Start Excel COM Object
Write-Host "Starting Excel COM object..."
$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false

# Open the workbooks with exception handling
try {
    Write-Host "Opening workbook 1..."
    $workbook1 = $excel.Workbooks.Open($file1Path)
} catch {
    Write-Host "Failed to open workbook 1: $_"
    $excel.Quit()
    return
}

try {
    Write-Host "Opening workbook 2..."
    $workbook2 = $excel.Workbooks.Open($file2Path)
} catch {
    Write-Host "Failed to open workbook 2: $_"
    $excel.Quit()
    return
}

# Get the WorkSheets
try {
    Write-Host "Accessing sheet 1..."
    $sheet1 = $workbook1.Sheets.Item(1)
} catch {
    Write-Host "Failed to access sheet 1: $_"
    $excel.Quit()
    return
}

try {
    Write-Host "Accessing sheet 2..."
    $sheet2 = $workbook2.Sheets.Item(1)
} catch {
    Write-Host "Failed to access sheet 2: $_"
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

# Read the 'Name' and 'Object ID' columns (assuming 'Name' is column A and 'Object ID' is column B)
try {
    Write-Host "Reading Names and Object IDs from sheet 1..."
    $range1 = $sheet1.UsedRange.Rows.Count
    $data1 = Read-WorksheetData -Worksheet $sheet1 -RowCount $range1
} catch {
    Write-Host "Failed to read Names and Object IDs from sheet 1: $_"
    $excel.Quit()
    return
}

try {
    Write-Host "Reading Names and Object IDs from sheet 2..."
    $range2 = $sheet2.UsedRange.Rows.Count
    $data2 = Read-WorksheetData -Worksheet $sheet2 -RowCount $range2
} catch {
    Write-Host "Failed to read Names and Object IDs from sheet 2: $_"
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
Write-Host "Entries in the first file but not in the second:"
$nonMatchingFrom1 | Format-Table -AutoSize

Write-Host "Entries in the second file but not in the first:"
$nonMatchingFrom2 | Format-Table -AutoSize
