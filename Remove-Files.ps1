function Remove-Files {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Directory,
        [int]$Days = 0
    )
    <#
    .SYNOPSIS
        Removes files older than a specified number of days from a directory.

    .DESCRIPTION
        This function recursively searches a specified directory and deletes all
        files whose 'LastWriteTime' property is older than the number of days
        specified by the '-Days' parameter. The default value for '-Days' is 0,
        which means it will attempt to delete all files immediately. Locked or
        inaccessible files are skipped.
    #>
    try {
        if (Test-Path $Directory) {
            foreach ($Item in Get-ChildItem $Directory -File -Recurse) {
                try {
                    if ($Item.LastWriteTime -lt (Get-Date).AddDays(-$Days)) {
                        Remove-Item $Item -Recurse -Force -ErrorAction Stop
                    }
                }
                catch { Write-Host "Skipping locked file: '$Item'" }
            }
        }
        else {
            Write-Host "Path not found: $Directory" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "Failed to remove files in '$Directory': $($_.Exception.Message)" -ForegroundColor Red
    }
}

