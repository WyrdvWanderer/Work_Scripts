$Username = "$env:USERDOMAIN\$env:USERNAME"
$IsAdmin = $false

$localAdminGroup = Get-WmiObject Win32_Group -Filter "LocalAccount=True AND SID='S-1-5-32-544'"

$localAdminGroupMembers = Get-WmiObject Win32_GroupUser -Filter "GroupComponent = `"$($localAdminGroup.__PATH)`""

foreach ($user in $localAdminGroupMembers) {
    if ($user.PartComponent -like "*$Username*") {
        $IsAdmin = $true
        break
    }
}

# Report the result somehow, e.g., write to a log file or a custom event in the Event Viewer.