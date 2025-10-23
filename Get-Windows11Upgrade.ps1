# To run this command from your terminal 
# 1. Enter  Set-ExecutionPolicy Bypass -Scope Process
# 2. Enter & ([scriptblock]::create((irm "https://raw.githubusercontent.com/dcyberspace01/workScripts/main/Get-Windows11Upgrade.ps1")))
function Start-Windows11Upgrade {

    #URL will only last for 24 Hours. To get a URL you need to go to the Windows Site input a Language and Right Click the 64-bit Download Box and Copy Address/Copy Link Address (Chrome)

    param (
        [string]$IsoUrl = "https://software.download.prss.microsoft.com/dbazure/Win11_25H2_English_x64.iso?t=738039d6-4bdc-4078-845c-fc1caa5a3d75&P1=1761312944&P2=601&P3=2&P4=LL7hh1u8aUsCGkVA8cGXTACWhnD17aw0md6E9jNKlTPJmBA6ydOsQUeFBFy2Iv4bMc7Rcp4sZmLBOhDizx8Z1AHmJTklwpGXnI6HLd1BWH3GkS9pvn1zFd4e7SWxgP%2fYp3YHoBtSLD6CtB2%2boPQtZL8HYFMZz9%2bEDvv0IZepgY6LPe048H8dlZJhOvh7AYCcX05xyTy8MBdlpqihryXca1k%2bHKAS4GwCvi0VZQ4sbKMn%2b2bIC%2bnp1Kh8cOKAaV5mS56W%2b3VGmoMahlDSQ2Y44fG%2bGK1sSbgpUoB%2bR%2buSnsrYGoDTOh3zOQGBb92o0NHW%2bxMxMBi6w2Mo60kojSAamg%3d%3d",
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


