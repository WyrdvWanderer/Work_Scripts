$Username = "$env:USERDOMAIN\$env:USERNAME"
$IsAdmin = $false

$localAdminGroup = Get-WmiObject Win32_Group -Filter "LocalAccount=True AND SID='S-1-5-32-544'"

# Escape the backslashes and other special characters in the group's path
$escapedPath = $localAdminGroup.__PATH -replace '\\', '\\\\'

$localAdminGroupMembers = Get-WmiObject Win32_GroupUser -Filter "GroupComponent = `"$escapedPath`""

foreach ($user in $localAdminGroupMembers) {
    if ($user.PartComponent -like "*$Username*") {
        $IsAdmin = $true
        break
    }
}

# Report the result based on your preferred method
