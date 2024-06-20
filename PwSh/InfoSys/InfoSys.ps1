$info = Get-WmiObject Win32_ComputerSystem
[PSCustomObject]@{
    ComputerName = $info.Name
    Model        = $info.Model
    Manufacturer = $info.Manufacturer
    RAM          = $info.TotalPhysicalMemory / 1GB -as [int]
    OS           = (Get-WmiObject Win32_OperatingSystem).Caption
} | Export-Csv -Path "C:\Inventory.csv" -NoTypeInformation -Append
