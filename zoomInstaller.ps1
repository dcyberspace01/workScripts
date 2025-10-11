function zoomInstaller() {
    param (
        [string]$zoomInstaller = 'C:\temp\ZoomInstaller.exe',
        [string]$installerDownload = 'https://zoom.us/client/latest/ZoomInstaller.exe'
    )

    $downloadFolder = Split-Path $zoomInstaller

    try {
        # Ensure folder exists
        if (-not (Test-Path $downloadFolder)) {
            New-Item -ItemType Directory -Path $downloadFolder -Force | Out-Null
        }

        # If installer doesn't exist, download it
        if (-not (Test-Path $zoomInstaller)) {
            Write-Host "Zoom Installer not found. Downloading from $installerDownload..." -ForegroundColor Yellow
            Start-BitsTransfer -Source $installerDownload -Destination $zoomInstaller
        }

        # Run installer
        if (Test-Path $zoomInstaller) {
            Write-Host "Zoom Installer Found at ($zoomInstaller)"
            Start-Process -FilePath $zoomInstaller -Wait
            Write-Host "Zoom Installed"
        } else {
            throw "Zoom Installer could not be downloaded or found."
        }
    }
    catch {
        Write-Error "An error occurred during Zoom installation: $($_.Exception.Message)"
    }
}

zoomInstaller
