# to remove an application named 'ExampleApp'
$appName = "ExampleApp"
$paths = @(
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Run"
)

foreach ($path in $paths) {
    if (Get-ItemProperty -Path $path -Name $appName -ErrorAction SilentlyContinue) {
        Remove-ItemProperty -Path $path -Name $appName
    }
}
