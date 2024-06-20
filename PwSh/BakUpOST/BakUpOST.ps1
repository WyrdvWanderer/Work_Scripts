# PowerShell Script to rename OST file and restart Outlook

# Define the OST file location (Change this to your actual OST file path)
$ostFilePath = "C:\Users\$env:USERNAME\AppData\Local\Microsoft\Outlook\your_email_address.ost"

# Check if the OST file exists
if (Test-Path $ostFilePath) {

    # Rename the OST file
    Rename-Item -Path $ostFilePath -NewName "$ostFilePath.bak"

    # Display a message
    Write-Host "OST file renamed successfully. Starting Outlook..."

    # Start Outlook
    Start-Process "outlook.exe"

} else {
    Write-Host "OST file not found at $ostFilePath. Please check the location."
}
