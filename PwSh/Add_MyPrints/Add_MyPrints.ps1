function Run-AsAdmin {
    param (
        [string]$installPath,
        [string]$scriptName
    )

    # Get the current script's full path
    $currentScript = $MyInvocation.MyCommand.Definition

    # Get administrator credentials
    $credentials = Get-Credential -Message "Please enter administrator credentials to continue"

    # Create and start a new PowerShell process with the provided credentials
    Start-Process powershell.exe -Credential $credentials -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$currentScript`" -installPath `"$installPath`" -scriptName `"$scriptName`"" -Wait
}

param (
    [string]$installPath = "C:\SafeQ6\FSP_6_65_2\Printer_deployment_scripts",
    [string]$scriptName = "install.bat"
)

# Check if the script is running with administrative privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Output "Script is not running with administrative privileges. Requesting credentials to run as admin."
    Run-AsAdmin -installPath $installPath -scriptName $scriptName
}
else {
    # The script has administrative privileges, proceed with the installation
    if (Test-Path $installPath) {
        # Change directory to the installation path
        Set-Location -Path $installPath

        # Execute the installation batch file with administrative privileges
        Start-Process ".\$scriptName" -NoNewWindow -Wait

        # Output completion message
        Write-Output "Installation complete. Please set a default printer if required."
    }
    else {
        Write-Error "Installation path does not exist. Please check the path and try again."
    }
}
