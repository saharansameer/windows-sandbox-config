# ============================================================
#  Windows Sandbox Bootstrap Script
#  Hosted on GitHub - fetched and run on sandbox boot
#  Installs: Brave Browser + ProtonVPN + Updates Defender
# ============================================================

$ErrorActionPreference = "Stop"
$TempDir = "$env:TEMP\SandboxSetup"
New-Item -ItemType Directory -Force -Path $TempDir | Out-Null

function Write-Step($msg) {
    Write-Host "`n==> $msg" -ForegroundColor Cyan
}


# Bypass execution policy in PowerShell
Set-ExecutionPolicy Bypass -Scope CurrentUser -Force

# -------------------------------------------------------
# 1. Configure DNS - Google 8.8.8.8 (Unencrypted)
# -------------------------------------------------------
Write-Step "Configure Google DNS..."

$Interface = Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | Select-Object -First 1

if ($Interface) {
    Set-DnsClientServerAddress `
        -InterfaceIndex $Interface.InterfaceIndex `
        -ServerAddresses ("8.8.8.8","8.8.4.4")

    Write-Host "DNS set to 8.8.8.8 / 8.8.4.4" -ForegroundColor Green
}

# -------------------------------------------------------
# 2. Brave Browser
# -------------------------------------------------------
Write-Host "Downloading Brave..."

$BraveUrl = "https://laptop-updates.brave.com/latest/winx64"
$BraveOut = "$env:USERPROFILE\Downloads\brave.exe"

curl.exe -L $BraveUrl -o $BraveOut
Write-Host "Download complete. Launching installer..." -ForegroundColor Green
Start-Process $BraveOut

# -------------------------------------------------------
# 3. Proton VPN
# -------------------------------------------------------
Write-Host "Downloading ProtonVPN..." 

$ProtonUrl = "https://protonvpn.com/download/ProtonVPN_v4.3.13_x64.exe"
$ProtonOut = "$env:USERPROFILE\Downloads\proton.exe"

curl.exe -L $ProtonUrl -o $ProtonOut
Write-Host "Download complete. Launching installer..." -ForegroundColor Green
Start-Process $ProtonOut

# -------------------------------------------------------
# Done
# -------------------------------------------------------
Write-Host "`n============================================" -ForegroundColor Green
Write-Host "  All done! Brave + ProtonVPN are ready." -ForegroundColor Green
Write-Host "============================================`n" -ForegroundColor Green
