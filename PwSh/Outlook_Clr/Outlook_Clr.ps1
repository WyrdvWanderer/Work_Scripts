# Navigating to the Outlook cache directory (replace 'Outlook version' with your actual Outlook version folder)
cd $env:LOCALAPPDATA\Microsoft\Outlook\

# Removing cache files
Get-ChildItem -Recurse | Remove-Item -ErrorAction SilentlyContinue -Force
