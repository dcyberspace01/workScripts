function Start-Windows11Upgrade {

    #URL will only last for 24 Hours. To get a URL you need to go to the Windows Site input a Language and Right Click the Download Box and Copy Address/Copy Link Address (Chrome)

    param (
        [string]$IsoUrl = "https://software.download.prss.microsoft.com/dbazure/Win11_25H2_English_x64.iso?t=4d4931eb-cc02-4e81-bc78-27ded91b1358&P1=1760038940&P2=601&P3=2&P4=GjCwX%2bjQkMCz%2bmi5wP0V54RlkCd60Jb4ulyOMGQkaXtppd5doD0eYCnDUKlYQIRVVK8ywYJ%2fGAYbS8aBTZv2fqPYO4zASaMlZjNe5t9WYrNQ4d%2fgSTNDKob8ZH89jI78Wztv8lk2%2fhV7fWfTfS8SEoeGjCPkukqzsiZDUkZ%2bHz1YAce4grHi6k3xwcpxgT46fVnQi2AakzqTTzv8m9gwr8j8Cado4SgsHzWoh5PjvrojzqFf8V0dmau1OmEbScKA5hTaJ98LuYb11bx2QksYP0p4INi1iR2t9xM6VclOQVC0vSDT8kVSTSSf4KbbrQ9Eyashjv5bVqiA4V45a02DBg%3d%3d",
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
    Start-Process -FilePath $setupPath -ArgumentList "/auto upgrade /eula accept" -Wait
    Write-Host "Upgrade Installation Is In Place. You will need to manually reboot when done"
}
Start-Windows11Upgrade
