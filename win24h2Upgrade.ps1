function Start-Windows11Upgrade {

    #URL will only last for 24 Hours. To get a URL you need to go to the Windows Site input a Language and Right Click the Download Box and Copy Address/Copy Link Address (Chrome)

    param (
        [string]$IsoUrl = "https://software.download.prss.microsoft.com/dbazure/Win11_25H2_English_x64.iso?t=96b4a81f-b724-4a5a-96c9-7741a00b52af&P1=1759931976&P2=601&P3=2&P4=yA7hT8QpB0w7tHLBFeF6BudzBjGGbS9rYH8zT6Be%2fhM%2bIB%2bsLqkQz5gADp2B1%2bvv7mQhS4TIcPQGrDo5G6HXEm5P8CmKK%2bx8JBvHDbdN6H%2bds1S7EeKJX9FGKUyBWV0zldn0I%2bHL6ZW0KPALAxKsstmVGetzAbbK1qJCMpO5vMnhUGu4DshHy4XmCBP9r%2bZPZ%2fid4YgxM2yhX7IhYsv79qyFiNu66jkaixnPsdyFDWnOSYeYUxEfzmGYzfLzHrydZey22TYMKIIB3rQzgKiNU7gr1zzYMqW1BS4WmeBb1Ns0G2SKnJCks%2bVS%2bLaIOTX1zhEaEuAudCXwwtU9a4%2fn0w%3d%3d",
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
    Start-Process -FilePath $setupPath -ArgumentList "/auto upgrade /quiet /noreboot" -Wait
    Write-Host "Upgrade Installation Is In Place. You will need to manually reboot when done"
}
Start-Windows11Upgrade