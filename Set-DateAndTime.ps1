function Set-DateAndTime {
    <#
    .SYNOPSIS
        Configures Windows to set date, time, and time zone automatically

    .DESCRIPTION
        Enables automatic NTP time synchronization, sets the time zone to
        "Singapore Standard Time", and forces an immediate clock resync.
    #>
    try {
        Write-Host "Starting Date and Time synchronization"

        # Set the 'Type' to NTP for automatic synchronization
        Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters -Name Type -Value "NTP"

        # Set the service startup type to Automatic
        Set-Service w32time -StartupType Automatic

        # Set the time zone to (UTC+08:00) Kuala Lumpur, Singapore
        Set-TimeZone -Id "Singapore Standard Time"
    
        # Configure and synchronize with a reliable time server
        Start-Service w32time -ErrorAction SilentlyContinue
        [void](w32tm /config /manualpeerlist:"time.windows.com,0x1" /syncfromflags:manual /reliable:yes /update)
        
        # Restart and resync
        Restart-Service w32time -ErrorAction SilentlyContinue
        [void](w32tm /resync /force)
        
        Write-Host "Date and Time is synced successfully" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "Failed to set the Date and Time:" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        return $false
    }
}

