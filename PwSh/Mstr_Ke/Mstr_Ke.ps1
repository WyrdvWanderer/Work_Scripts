# Read and Decrypt the Password
$username = Get-Content "D:\Work_Scripts\_Assets\Credentials\usrname\usrname.txt.txt"
$encryptedPassword = Get-Content "D:\Work_Scripts\_Assets\Credentials\passwrd\En-pswrd.txt" | ConvertTo-SecureString
$credential = New-Object System.Management.Automation.PSCredential($username, $encryptedPassword)

# Function to start an application as another user using the stored credentials
function Start-AsUser {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ApplicationPath,

        [Parameter(Mandatory = $false)]
        [string]$Arguments = $null
    )

    if ($null -ne $Arguments -and $Arguments -ne '') {
        Start-Process -FilePath $ApplicationPath -ArgumentList $Arguments -Credential $credential -NoNewWindow
    } else {
        Start-Process -FilePath $ApplicationPath -Credential $credential -NoNewWindow
    }
}

# Examples of starting different applications with the stored credentials
Start-AsUser -ApplicationPath "powershell.exe"
Start-AsUser -ApplicationPath "cmd.exe"
Start-AsUser -ApplicationPath "control.exe"
Start-AsUser -ApplicationPath "regedit.exe"

# You can add more applications as needed following the pattern above
