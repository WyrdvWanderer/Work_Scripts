# Check for 64-bit Office in the standard location
$office64 = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object {$_.DisplayName -like "*Microsoft Office*"}

# Check for 32-bit Office in the WOW6432Node location
$office32 = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object {$_.DisplayName -like "*Microsoft Office*"}

# Combine the results
$office = $office64 + $office32

# Display the results, if any
if ($office) {
    $office | Select-Object DisplayName, DisplayVersion, @{Name="Architecture"; Expression={if ($_.PSPath -like "*Wow6432Node*") {"32-bit"} else {"64-bit"}}}
} else {
    "No Microsoft Office installation found."
}
