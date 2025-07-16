Write-Host "#### Server info ####`n"

# Server name
Write-Host "Servername: $($env:COMPUTERNAME)"

# IP addresses
$ips = Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike "169.*"} | Select-Object -ExpandProperty IPAddress
Write-Host "IP(s): $($ips -join ', ')"

# Operating System
$os = Get-CimInstance -ClassName Win32_OperatingSystem
Write-Host "Betriebssystem: $($os.Caption) $($os.Version) $($os.OSArchitecture)"

Write-Host "`n`n#### RAM Status ####`n"

$totalRAM = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
$freeRAM = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
$usedRAM = [math]::Round($totalRAM - $freeRAM, 2)
$usedPct = [math]::Round(($usedRAM / $totalRAM) * 100, 1)

Write-Host "Total RAM: $totalRAM GB"
Write-Host "Used RAM: $usedRAM GB ($usedPct`%)"
Write-Host "Free RAM: $freeRAM GB"

Write-Host "`n`n#### Festplattenstatus ####`n"

# Disk usage
Get-PSDrive -PSProvider FileSystem | ForEach-Object {
    if ($_.Used -ne $null -and $_.Free -ne $null -and ($_.Used + $_.Free) -ne 0) {
        $total = $_.Used + $_.Free
        $usedPct = $_.Used / $total
        "{0}: {1} used / {2} total ({3:P1} used)" -f $_.Name, 
            ("{0:N2} GB" -f ($_.Used / 1GB)),
            ("{0:N2} GB" -f ($total / 1GB)),
            $usedPct
    } else {
        "{0}: No size information available" -f $_.Name
    }
}

Write-Host "`n`n#### Blockgeräte ####`n"

# Block device info
Get-PhysicalDisk | ForEach-Object {
    $sizeGB = "{0:N2} GB" -f ($_.Size / 1GB)
    [PSCustomObject]@{
        DeviceID           = $_.DeviceID
        FriendlyName       = $_.FriendlyName
        MediaType          = $_.MediaType
        Size               = $sizeGB
        OperationalStatus  = $_.OperationalStatus
    }
} | Format-Table -AutoSize

# Volume mountpoints
Write-Host "`n`n#### Volumes ####`n"
Get-Volume | ForEach-Object {
    [PSCustomObject]@{
        DriveLetter     = $_.DriveLetter
        FileSystemLabel = $_.FileSystemLabel
        FileSystem      = $_.FileSystem
        SizeRemaining   = "{0:N2} GB" -f ($_.SizeRemaining / 1GB)
        Size            = "{0:N2} GB" -f ($_.Size / 1GB)
    }
} | Format-Table -AutoSize

