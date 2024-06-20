Add My Prints Script

Overview:
The 'Add My Prints' script is designed to facilitate the deployment of printer installation scripts on Windows systems requiring administrative rights. It ensures that the necessary scripts are executed with the proper permissions, either by verifying existing administrative privileges or by prompting for administrative credentials.

Features:
- Automatic Privilege Check: Automatically determines if the script is running with administrative privileges, prompting for credentials if necessary.
- Credential Management: Securely prompts for administrative credentials to ensure the script runs with the necessary permissions.
- Script Execution: Executes a specified batch file or other script from a user-defined directory, primarily intended for printer setup.

Requirements:
- Windows PowerShell 5.1 or higher.
- Administrative credentials for execution.
- The target script (e.g., 'install.bat') must be present in the specified directory.

Usage:
1. Prepare Installation Script:
   - Place your installation script, such as a batch file for printer installation, in the desired directory.
2. Set Parameters:
   - Adjust the parameters '$installPath' and '$scriptName' within the script to point to your script's directory and the filename, respectively.
3. Run the Script:
   - Right-click on 'Add My Prints.ps1' and select 'Run with PowerShell'.
   - If not running with administrative privileges, enter your credentials when prompted.
4. Follow Prompts:
   - Enter administrative credentials when prompted to allow the script to execute with elevated privileges.

Troubleshooting:
- Script Not Running: Check the script execution policies on your system. Adjust with 'Set-ExecutionPolicy' as necessary.
- Missing Installation Path: Ensure the '$installPath' is correctly set to the directory containing your installation script.
- Credential Issues: Ensure the credentials provided have administrative rights on the system.

Notes:
- This script is designed for environments where regular administrative tasks are performed and requires careful handling of credentials.
- Always ensure that scripts run with administrative privileges are from trusted sources to avoid security risks.

======================================================================================================================================

Example:
.\Add My Prints.ps1 -installPath "C:\Path\To\Your\Script" -scriptName "install.bat"
