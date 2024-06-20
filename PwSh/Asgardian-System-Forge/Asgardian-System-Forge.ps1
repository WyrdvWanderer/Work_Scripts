# Asgardian System Forge - Post-Installation Cleanup and Setup Script

# Check if script is running as an administrator
function Assert-Admin {
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
    if (-not $isAdmin) {
        Write-Warning "Please run this script with the might of Thor (as an Administrator)!"
        exit
    }

}
# Main script logic
function Invoke-AsgardianSystemForge {
    # ASCII Art - Yggdrasil
    Write-Host @"
    .        +          .      .          .
    .            _        .                    .
 ,              /;-._,-.____        ,-----.__
((        .    (_:#::_.:::. `-._   /:, /-._, `._,
 `                 \   _|`"=:_::.`.);  \ __/ /
                     ,    `./  \:. `.   )==-'  .
   .      ., ,-=-.  ,\, +#./`   \:.  / /           .
.           \/:/`-' , ,\ '` ` `   ): , /_  -o
      .    /:+- - + +- : :- + + -:'  /(o-) \)     .
 .      ,=':  \    ` `/` ' , , ,:' `'--".--"---._/`7
  `.   (    \: \,-._` ` + '\, ,"   _,--._,---":.__/
             \:  `  X` _| _,\/'   .-'
.               ":._:`\____  /:'  /      .           .
                   \::.  :\/:'  /              +
  .                 `.:.  /:'  }      .
          .           ):_(:;   \           .
                     /:. _/ ,  |
                  . (|::.     ,`                  .
    .                |::.    {\
                     |::.\  \ `.
                     |:::(\    |
             O       |:::/{ }  |                  (o
              )  ___/#\::`/ (O "==._____   O, (O  /`
         ~~~w/w~"~~,\` `:/,-(~`"~~~~~~~~"~o~\~/~w|/~
wyrd   ~~~~~~~~~~~~~~~~~~~~~~~\\W~~~~~~~~~~~~\|/~~

"@ -ForegroundColor Cyan

    # Remove unnecessary apps
    Write-Host "Summoning the powers of Asgard to remove unwanted apps..." -ForegroundColor Yellow
    $AppsToRemove = @(
        "Microsoft.BingWeather",
        "Microsoft.GetHelp",
        "Microsoft.Skype",
        "microsoft.windowscommunicationsapps", # Mail and Calendar
        "Microsoft.YourPhone",
        "Microsoft.XboxApp", # Xbox Console Companion
        "Microsoft.MSPaint", # Paint 3D
        "Microsoft.MixedReality.Portal", # Mixed Reality Portal
        "Microsoft.People",
        "Microsoft.ZuneVideo", # Movies & TV
        "Microsoft.GetHelp", # Get Help
        "Microsoft.MicrosoftSolitaireCollection", # Solitaire Collection
        "Microsoft.MicrosoftStickyNotes", # Sticky Notes
        "Microsoft.GamingApp", # Xbox Game Bar
        "Microsoft.PowerAutomateDesktop", # Power Automate Desktop
        "Microsoft.Office.OneNote" # OneNote
        # Add any other apps you wish to remove
    )
    $totalApps = $AppsToRemove.Count
    $currentApp = 0
    foreach ($App in $AppsToRemove) {
        $currentApp++
        $percentComplete = ($currentApp / $totalApps) * 100
        Write-Progress -Activity "Removing Unwanted Apps" -Status "Launching the valkyrie: $App" -PercentComplete $percentComplete
        Get-AppxPackage -Name $App | Remove-AppxPackage
        Get-AppxPackage -AllUsers -Name $App | Remove-AppxPackage
        Start-Sleep -Seconds 2 # Simulating a delay for demonstration
    }
    Write-Progress -Activity "Removing Unwanted Apps" -Completed

    # Creating a new user account
    Write-Host "Crafting a new warrior for the realms..." -ForegroundColor Green
    $Username = Read-Host "Enter the username for the new account"
    $Password = Read-Host "Enter the password for the new account" -AsSecureString
    $Group = Read-Host "Enter the group for the new account (e.g., Administrators, Users)"
    New-LocalUser -Name $Username -Password $Password -Description "Created by Wyrd's script"
    Add-LocalGroupMember -Group $Group -Member $Username
    Write-Host "New user $Username created and added to $Group group."

    # Enable or disable RDP
    $RdpChoice = Read-Host "Shall we open the Bifrost? (Y/N)"
    if ($RdpChoice -eq 'Y') {
        Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -Value 0
        Write-Host "RDP has been enabled."
    }
    else {
        Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -Value 1
        Write-Host "RDP has been disabled."
    }

    # Enable WSL (Windows Subsystem for Linux)
    Write-Host "Enabling Windows Subsystem for Linux..." -ForegroundColor Blue
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    Write-Host "WSL has been enabled. A restart may be required."

    # Create a new folder and add it to Defender's exceptions
    $FolderPath = "C:\Scripts"
    if (-not (Test-Path $FolderPath)) {
        New-Item -Path $FolderPath -ItemType Directory
    }
    Add-MpPreference -ExclusionPath $FolderPath
    Write-Host "Folder $FolderPath created and added to Defender's exceptions."

    # Attempt to locate the Medicat USB drive
    $MedicatDrive = Get-WmiObject Win32_Volume | Where-Object { $_.Label -eq 'Medicat' } | Select-Object -ExpandProperty DriveLetter
    if (-not $MedicatDrive) {
        Write-Error "The Bifrost couldn't locate the Medicat realm (USB drive)."
        exit
    }

    # Define the path to the Installers directory on the Medicat USB drive
    $InstallerDirectory = Join-Path -Path $MedicatDrive -ChildPath "Installers"
    if (-not (Test-Path -Path $InstallerDirectory)) {
        Write-Error "The Installers directory does not exist on the Medicat USB drive at path: $InstallerDirectory"
        exit
    }

    # List of applications to install from the Medicat USB drive
    $AppList = @(
        "Advanced_IP_Scanner_2.5.4594.1.exe",
        "googlechromestandaloneenterprise64.msi",
        "Ninite 7Zip FileZilla KLite Codecs RealVNC Server Installer.exe"
        # Ensure these are the exact filenames of the installers on the USB
    )

    # Install each application
    foreach ($App in $AppList) {
        $InstallerPath = Join-Path -Path $InstallerDirectory -ChildPath $App
    
        if (Test-Path -Path $InstallerPath) {
            Write-Host "Found installer: $InstallerPath"
            Write-Host "Installing $App..."
    
            # Determine the command based on the file type
            $processArgs = if ($App -like "*.msi") {
                @('msiexec.exe', "/i `"$InstallerPath`" /qn")
            }
            elseif ($App -like "*Ninite*") {
                @("`"$InstallerPath`"", "/silent")
            }
            else {
                @("`"$InstallerPath`"", "/S")
            }
    
            # Execute the installer
            Start-Process -FilePath $processArgs[0] -ArgumentList $processArgs[1] -Wait -NoNewWindow
            Write-Host "$($ExtraApp.Name) has been installed."
        }
        else {
            Write-Host "Skipped installation of $($ExtraApp.Name)."
        }
    }
    else {
        @("`"$InstallerPath`"", "/S")
    }
} 
Write-Host "Installation process from Medicat USB drive completed."

Invoke-AsgardianSystemForge
