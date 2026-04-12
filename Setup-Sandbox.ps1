# ============================================================
#  Windows Sandbox PowerShell Script
#  Hosted on GitHub - fetched and run on sandbox boot
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
# System Settings
# -------------------------------------------------------
Write-Step "Applying system settings..."

# Registry Path
$CurrentVersion = "HKCU:\Software\Microsoft\Windows\CurrentVersion"
$ExplorerAdvanced = "$CurrentVersion\Explorer\Advanced"
$Themes = "$CurrentVersion\Themes\Personalize"

# Dark Mode
Set-ItemProperty -Path $Themes -Name "AppsUseLightTheme" -Value 0
Set-ItemProperty -Path $Themes -Name "SystemUsesLightTheme" -Value 0

# Show hidden files
Set-ItemProperty -Path $ExplorerAdvanced -Name "Hidden" -Value 1

# Show file extensions
Set-ItemProperty -Path $ExplorerAdvanced -Name "HideFileExt" -Value 0

# Taskbar alignment to left
Set-ItemProperty -Path $ExplorerAdvanced -Name "TaskbarAl" -Value 0

# Hide Task View button
Set-ItemProperty -Path $ExplorerAdvanced -Name "ShowTaskViewButton" -Value 0

# Hide Search from taskbar
Set-ItemProperty -Path "$CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0

# Restart Explorer to apply changes instantly
Stop-Process -Name explorer -Force
Start-Process explorer

Write-Host "Settings applied." -ForegroundColor Green


# -------------------------------------------------------
# Configure DNS - Google 8.8.8.8 (Unencrypted)
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
# Download Proton VPN and Run Setup
# -------------------------------------------------------
Write-Host "Downloading ProtonVPN..." 

$ProtonUrl = "https://protonvpn.com/download/ProtonVPN_v4.3.13_x64.exe"
$ProtonOut = "$env:USERPROFILE\Downloads\proton.exe"

curl.exe -L $ProtonUrl -o $ProtonOut
Write-Host "Download complete. Launching installer..." -ForegroundColor Green
Start-Process $ProtonOut


# -------------------------------------------------------
# Download Brave Browser and Run Setup
# -------------------------------------------------------
Write-Host "Downloading Brave..."

$BraveUrl = "https://laptop-updates.brave.com/latest/winx64"
$BraveOut = "$env:USERPROFILE\Downloads\brave.exe"

curl.exe -L $BraveUrl -o $BraveOut
Write-Host "Download complete. Launching installer..." -ForegroundColor Green
Start-Process $BraveOut -Wait


# -------------------------------------------------------
# Overwrite Brave Preferences
# -------------------------------------------------------
Write-Step "    Applying Brave preferences..."
 
$PrefsPath = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Preferences"
$GistUrl = "https://gist.githubusercontent.com/saharansameer/b57fbd4bc2bcf9e854560861178e87a7/raw/151b11a9da81a88f2c1cf1f2ace2764a8111a211/BravePreferences"
 
# Wait for Brave to create the profile folder
$timeout = 30
$elapsed = 0
while (-not (Test-Path $PrefsPath) -and $elapsed -lt $timeout) {
    Start-Sleep -Seconds 2
    $elapsed += 2
}
 
if (Test-Path $PrefsPath) {
    Stop-Process -Name "brave" -Force
    Start-Sleep -Seconds 2
    Download-File $GistUrl $PrefsPath
    Write-Host "    Brave preferences applied." -ForegroundColor Green
} else {
    Write-Host "    Preferences file not found, skipping." -ForegroundColor Yellow
}


# -------------------------------------------------------
# All Done
# -------------------------------------------------------
Write-Host "`n============================================" -ForegroundColor Green
Write-Host "  All done!" -ForegroundColor Green
Write-Host "============================================`n" -ForegroundColor Green
