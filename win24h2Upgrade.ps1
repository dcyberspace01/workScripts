function Start-Windows11Upgrade {

    #URL will only last for 24 Hours. To get a URL you need to go to the Windows Site input a Language and Right Click the Download Box and Copy Address/Copy Link Address (Chrome)

    param (
        [string]$IsoUrl = "https://software.download.prss.microsoft.com/dbazure/Win11_25H2_English_x64.iso?t=f1a3f565-993b-4ed4-93df-160b2d6ad371&P1=1760205999&P2=601&P3=2&P4=VBxR2jQvC1HG%2bnSrwq7xJULiP6bSprqMhjd3Ldcgp39hyyivOu2I%2bbrUqIrmMQUtqEsppqtRxX1ox1zpGekAJC1gXfov21OSF6oCoaIOPh6LUw%2bENqAmYmd96rXLGUR42qOAF3IvtbM2bT8fLxA05G1q4tfXKAPIdJHVQP67JTNiuCJMKD4l4VQQDw7uvDWrvYFDv6hFUzHFJIs5uDSkHHFnIeuDwNLKHsFiiW4useAZKqMvwNzx5KVx2e3rAdAAkqKR3bWPHr0KsDwSfRxWQz1CCGrs9iwm8GrguQ4HfiaYinVWdoTnu0FOnKnyu3GuLRb7WEDnIK4vTnzIp%2fNqFg%3d%3d",
        [string]$IsoPath = "C:\Temp\windows11.iso"
    )

    if (-not ( Test-Path $IsoPath)) {
        Write-Error "ISO volume not found. Performing ISO Download Now..."
        Write-Host "Downloading Windows 11 ISO..."
        Start-BitsTransfer -Source $IsoUrl -Destination $IsoPath
    } else {
        Write-Host "ISO is already downloaded..."
    }

    Write-Host "Mounting ISO..."
    Mount-DiskImage -ImagePath $IsoPath
    Start-Sleep -Seconds 5  # Allow time for mount

    $isoDrive = (Get-Volume | Where-Object { $_.FileSystemLabel -like "CCCOMA_X64FRE_EN-US_DV9" }).DriveLetter

    if (-not $isoDrive) {
        Write-Error "ISO volume not found. Check the label or mount status."
        return
    }

    $setupPath = "$isoDrive`:\setup.exe"
    Write-Host "Starting the Windows 24H2 upgrade"
    Start-Process -FilePath $setupPath -ArgumentList "/auto upgrade /noreboot" -Wait
    Write-Host "Upgrade Installation Is In Place. You will need to manually reboot when done"
}
Start-Windows11Upgrade
