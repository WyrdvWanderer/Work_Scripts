# App Locator PowerShell Script

## Overview
This PowerShell script dynamically locates the installation path of any specified application on Windows systems by searching through the registry. It allows the user to input the application name during execution, enhancing flexibility and usability.

## Requirements
- Operating System: Windows
- PowerShell Version: 5.0 or later

## How the Script Works
The script searches through both 32-bit and 64-bit registry paths for uninstallation entries within the Windows system registry. It checks these entries for a display name that includes the application name input by the user. If found, the installation path is outputted; if not, a message indicating the application was not found is displayed.

## Script Usage
1. Launch PowerShell with administrative rights.
2. Save the script as `App_Locator.ps1`.
3. Run the script by navigating to the directory where it is saved and typing `./App_Locator.ps1`.
4. When prompted, enter the name of the application you want to locate.
5. The script will display the installation path of the application if found; otherwise, it will notify you that the application was not found.

## Example of Running the Script
- Open PowerShell.
- Execute the command: `./App_Locator.ps1`.
- Input at the prompt: `MindManager2012`.
- View the output for the location of the application or a message if it is not found.
Example: ./App_Locator.ps1 | then follow the prompts