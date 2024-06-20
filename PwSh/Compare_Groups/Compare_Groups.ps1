# Enable strict mode to catch undeclared variables and other issues
Set-StrictMode -Version Latest

# Paths to the Excel files
$file1Path = 'C:\SWTOOLS\Secure_Files\Work_Scripts\_Assets\Database\REV-CND2061LRB - Hayley Carroll.csv'
$file2Path = 'C:\SWTOOLS\Secure_Files\Work_Scripts\_Assets\Database\REV-PF0W74TL-Hayley Carroll.csv'

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
    return
}

try {
    Write-Host "Opening workbook 2..."
    $workbook2 = $excel.Workbooks.Open($file2Path)
} catch {
    Write-Host "Failed to open workbook 2: $_"
    return
}

# Get the WorkSheets
try {
    Write-Host "Accessing sheet 1..."
    $sheet1 = $workbook1.Sheets.Item(1)
} catch {
    Write-Host "Failed to access sheet 1: $_"
    return
}

try {
    Write-Host "Accessing sheet 2..."
    $sheet2 = $workbook2.Sheets.Item(1)
} catch {
    Write-Host "Failed to access sheet 2: $_"
    return
}

# Read the 'Object ID' column (assuming it is column B)
try {
    Write-Host "Reading Object IDs from sheet 1..."
    $range1 = $sheet1.UsedRange.Rows.Count
    $objectIDs1 = @($sheet1.Range("B2:B$range1").Value2 | ForEach-Object { $_ }) | Where-Object { $null -ne $_ }
} catch {
    Write-Host "Failed to read Object IDs from sheet 1: $_"
    return
}

try {
    Write-Host "Reading Object IDs from sheet 2..."
    $range2 = $sheet2.UsedRange.Rows.Count
    $objectIDs2 = @($sheet2.Range("B2:B$range2").Value2 | ForEach-Object { $_ }) | Where-Object { $null -ne $_ }
} catch {
    Write-Host "Failed to read Object IDs from sheet 2: $_"
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
$nonMatchingObjectIDs1 = $objectIDs1 | Where-Object { $_ -notin $objectIDs2 }
$nonMatchingObjectIDs2 = $objectIDs2 | Where-Object { $_ -notin $objectIDs1 }

# Display the non-matching Object IDs
Write-Host "Object IDs in the first file but not in the second:"
$nonMatchingObjectIDs1 | Format-Table -AutoSize

Write-Host "Object IDs in the second file but not in the first:"
$nonMatchingObjectIDs2 | Format-Table -AutoSize
