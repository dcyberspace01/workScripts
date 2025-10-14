function Start-Windows11Upgrade {

    #URL will only last for 24 Hours. To get a URL you need to go to the Windows Site input a Language and Right Click the Download Box and Copy Address/Copy Link Address (Chrome)

    param (
        [string]$IsoUrl = "https://software.download.prss.microsoft.com/dbazure/Win11_25H2_English_x64.iso?t=747ec434-beb2-45a1-a445-be96d3c02f57&P1=1760547660&P2=601&P3=2&P4=prlkveeUcEYv2AVy5aASVS0k3%2bT4u0UJeHyxP06rnLJWqTMfwY92qVUnne0l%2bQGPGZKKORUCoyvBDCBGSZqAAMiABsJojrXBnGPrEjyfMmSQljdoO9GsEg1NtrbuPg7oSNAN9Sc3p3u30QXkAzqMLxTTihErgOY4e4awH22LWJ9xbnLV%2fd4VV3YZJ6k1Oj%2bUMyrfmRyZI%2b0%2bV0vXq%2fSFN5qs7ZDFbeYn5e9ymU%2bdSeg3lGF7vZf7xXgvg1BMXT5LOQe1H%2bBdc60mVcjE1pobt3%2fuqeRx7etX7z8vm5dWAptRq3OkUNfEuiPHYkMAYR2hyMjQqgc6IZJzsyYyPP7I%2fA%3d%3d",
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
