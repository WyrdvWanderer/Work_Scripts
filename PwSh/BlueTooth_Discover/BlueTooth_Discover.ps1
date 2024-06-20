$query = "SELECT * FROM Win32_PnPEntity WHERE Service = 'BthLEEnum'"
Get-WmiObject -Query $query | ForEach-Object {
    $name = $_.Name
    $status = $_.Status
    $deviceId = $_.DeviceID
    $macAddress = $deviceId -split "_"
    $mac = $macAddress[-1] -replace '(.{2})', '$1:' -replace ':$',''
    [PSCustomObject]@{
        DeviceName = $name
        Status = $status
        MACAddress = $mac.ToUpper()
    }
}
