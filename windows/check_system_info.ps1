Write-Host "#### Server info ####`n"

# Server name
Write-Host "Servername: $($env:COMPUTERNAME)"

# IP addresses
$ips = Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike "169.*"} | Select-Object -ExpandProperty IPAddress
Write-Host "IP(s): $($ips -join ', ')"

# Operating System
$os = Get-CimInstance -ClassName Win32_OperatingSystem
Write-Host "Betriebssystem: $($os.Caption) $($os.Version) $($os.OSArchitecture)"

Write-Host "`n#### Festplattenstatus ####`n"

# Disk usage
Get-PSDrive -PSProvider FileSystem | ForEach-Object {
    "{0}: {1} used / {2} total ({3:P1} used)" -f $_.Name, 
        "{0:N2} GB" -f (($_.Used / 1GB)),
        "{0:N2} GB" -f (($_.Used + $_.Free) / 1GB),
        ($_.Used / ($_.Used + $_.Free))
}

Write-Host "`n#### Blockgeräte ####`n"

# Block device info
Get-PhysicalDisk | Select-Object DeviceID, FriendlyName, MediaType, Size, OperationalStatus | Format-Table -AutoSize

# Volume mountpoints
Write-Host "`n#### Volumes ####`n"
Get-Volume | Select-Object DriveLetter, FileSystemLabel, FileSystem, SizeRemaining, Size | Format-Table -AutoSize
