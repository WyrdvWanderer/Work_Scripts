# ArchAroundnFindout PowerShell Script

## Overview
The `ArchAroundnFindout.ps1` script is designed to detect the installation of Microsoft Office on a Windows system, whether it is a 32-bit or 64-bit version. It checks standard registry locations to determine the presence and details of the Office installations.

## Requirements
- Operating System: Windows
- PowerShell Version: 5.0 or later

## How the Script Works
The script performs searches in both the standard and WOW6432Node registry paths to find any installed versions of Microsoft Office. It then outputs the details including the display name, version, and architecture (32-bit or 64-bit) of each found installation.

## Script Usage
1. Launch PowerShell with administrative rights.
2. Save the script as `ArchAroundnFindout.ps1`.
3. Run the script by navigating to the directory where it is saved and typing `./ArchAroundnFindout.ps1`.
4. The script will display each Microsoft Office installation found along with its version and architecture. If no installations are found, it will notify you that no Microsoft Office installation was found.

## Example of Running the Script
- Open PowerShell.
- Execute the command: `./ArchAroundnFindout.ps1`.
- View the output for each Microsoft Office installation found or a message if none are detected.

Example: `./ArchAroundnFindout.ps1`. | get results for each Microsoft Office installation found