function zoomUninstaller() {
    param (
        [string]$zipPath = 'C:\temp\CleanZoom.zip',
        [string]$uninstallDownload = 'https://assets.zoom.us/docs/msi-templates/CleanZoom.zip',
        [string]$extractPath = 'C:\temp\CleanZoom'
    )
    $zoomUninstaller = "$extractPath\CleanZoom.exe"

   try {
    $tempFolder = Split-Path $zipPath
     if (-not(Test-Path $tempFolder)) {
        New-Item -ItemType Directory -Path $tempFolder -Force | Out-Null
     } 
     if (-not (Test-Path $zoomUninstaller)) {
        Start-BitsTransfer -Source $uninstallDownload -Destination $zipPath
        Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force
        
        
     }
     if (Test-Path $zoomUninstaller) {
        <# Action to perform if the condition is true #>
        Write-Host "Now Uninstalling Zoom"
        Start-Process -FilePath $zoomUninstaller -wait
        Write-Host "Zoom Uninstalled"
     } else {
        throw "Zoom Uninstaller Could Not Be Started..."
     }
   }
   catch {
    Write-Error "An error occurred during Zoom installation: $($_.Exception.Message)"
   }
}   

zoomUninstaller

