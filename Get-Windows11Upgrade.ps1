# To run this command from your terminal 
# 1. Enter  Set-ExecutionPolicy Bypass -Scope Process
# 2. Enter & ([scriptblock]::create((irm "https://raw.githubusercontent.com/dcyberspace01/workScripts/main/Get-Windows11Upgrade.ps1")))
function Start-Windows11Upgrade {

    #URL will only last for 24 Hours. To get a URL you need to go to the Windows Site input a Language and Right Click the 64-bit Download Box and Copy Address/Copy Link Address (Chrome)

    param (
        [string]$IsoUrl = "https://software.download.prss.microsoft.com/dbazure/Win11_25H2_English_x64.iso?t=b9c6ef25-3c2e-4b21-9696-7f3e4f9c0218&P1=1761657793&P2=601&P3=2&P4=1bV%2bTC4CMTf7cqAojOpDGjDdW%2bsuYGAwNoqQhq3V5oyMywzwcM2qnyKyfn9kSBD4OiMOwbkvdX0vdmy9crMGze4g2JeWkwv15aAZgT6WqPYOfzB0JovbbF6KCwgPKd4JLlEc8%2bGEjAwHO5l%2fuzQP1qYkCHhfbX4pmJItQY6CT%2bo4Z2%2fhaH6YM5Rc5ZXe%2fLbv1Yd3EYr3U30Nfpqlqaz40%2b9VK%2fA6LWCHCDRiaPpPSB7Lo%2fILPk1ENUg7vNlq7RVu8mE%2fbSoIRtjHbHscXTDCbxaLCzKP%2bgExeVjY9iOwgoGSGurT25SqlP%2b7LrRXNFzg8%2bU3YHrw1x1VaNr1S8621w%3d%3d",
        [string]$IsoPath = "C:\Temp\windows11.iso"
    )

    if (-not ( Test-Path $IsoPath)) {

      Write-Host "ISO volume not found. Performing ISO Download Now..."
      Write-Host "Downloading Windows 11 ISO..."
      $isoFolder = Split-Path $IsoPath
              
      if (-not (Test-Path $isoFolder)) {
        
        New-Item -Path $isoFolder -ItemType Directory | Out-Null

      }

      Start-BitsTransfer -Source $IsoUrl -Destination "$IsoPath"
    }  else {

      
         Write-Host "ISO is already downloaded..."

    }

    Write-Host "Mounting ISO..."
    Mount-DiskImage -ImagePath $IsoPath
    Start-Sleep -Seconds 5  # Allow time for mount

    $isoDrive = (Get-Volume | Where-Object { $_.FileSystemLabel -like "CCCOMA_X64FRE_EN-US_DV9" }).DriveLetter

    if (-not $isoDrive) {
    
      Write-Host "ISO volume not found. Check the label or mount status."
    
    }

    $setupPath = "$isoDrive`:\setup.exe"
    Write-Host "Starting the Windows 24H2 upgrade"
    Start-Process -FilePath $setupPath -ArgumentList "/auto upgrade /noreboot" -Wait
    Write-Host "Upgrade Installation Is In Place. You will need to manually reboot when done"

}

Start-Windows11Upgrade



