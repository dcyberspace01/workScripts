function Start-Windows11Upgrade {

    #URL will only last for 24 Hours. To get a URL you need to go to the Windows Site input a Language and Right Click the Download Box and Copy Address/Copy Link Address (Chrome)

    param (
        [string]$IsoUrl = "https://software.download.prss.microsoft.com/dbazure/Win11_25H2_English_x64.iso?t=37229edb-d6e5-4119-995b-8e4bdc505747&P1=1760644547&P2=601&P3=2&P4=R5t2iDZAhJcUcActry8KJrr53ay3IzFqVKAA84cR5KoO%2bKPJv9I%2fttuSKKmdsl3e%2fnWO%2bnvJZsp%2f68ukqZCvOWcQir1%2bm%2b%2f6G6KecXhnsXjSaCrB%2fC92RYrhSApMJ0cA0m%2bP%2fxlknUdWNMo8S4iFEeoVCMOhU9z1H2%2fRU7f7KWr1Oi9pSHUv04TBJ1H3KIGuYuBeIa7S%2fE7UMhDdSOwCb7E0DEXAdFWH3yTrU6NBt6qDIApRWKDuq8NxC%2b%2fNOa%2f%2bobJTsT4mUrRN6f4g2mueeKadNpbtMbSvySjn%2b6qpburUI%2bDLy1uYN%2fyXAARYO24ORjUlaQuAFHVKlpdg%2bjmvug%3d%3d",
        [string]$IsoPath = "C:\Temp\windows11.iso"
    )

    if (-not ( Test-Path $IsoPath)) {
        Write-Error "ISO volume not found. Performing ISO Download Now..."
        Write-Host "Downloading Windows 11 ISO..."
        New-Item -Path "C:\Temp" -ItemType Directory | Out-Null
        Start-BitsTransfer -Source $IsoUrl -Destination "C:\Temp"
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
