# ============================================================
#  Author      : Sameer Saharan (github.com/saharansameer)
#
#  Description : Automated setup script for Windows Sandbox.
#                Runs on sandbox boot to configure system settings
#                and set up a clean, usable isolated environment.
#
#  Actions:
#    - Applies system settings
#    - Downloads and extracts portable apps to Program Files
#    - Downloads and launches installers for system-level apps
#    - Creates desktop shortcuts for all installed apps
#
#  Installs:
#    1. Proton VPN              - VPN Client
#    2. qBittorrent             - Torrent Client
#    3. Notepad++               - Text Editor
#    4. VLC                     - Media Player
#    5. Brave Browser           - Web Browser
# ============================================================

# ============================================================
# START
# ============================================================

# Relaunch self in a visible window
if (-not $env:SANDBOX_VISIBLE) {
    $env:SANDBOX_VISIBLE = "1"
    Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -NoExit -File `"$PSCommandPath`"" -WindowStyle Normal
    exit
}

# Utilities
function Write-Step($msg) {
    Write-Host "`n==> $msg" -ForegroundColor Green
}

# Folder Path
$ProgramFiles = "C:\Program Files"
$Downloads = "$env:USERPROFILE\Downloads"
$Desktop = "$env:USERPROFILE\Desktop"

# Bypass execution policy in PowerShell
Set-ExecutionPolicy Bypass -Scope CurrentUser -Force

# -------------------------------------------------------
# Update System Settings
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

Write-Step "Settings applied."

# -------------------------------------------------------
# Configure DNS - Google 8.8.8.8 (Unencrypted)
# -------------------------------------------------------
Write-Step "Configure Google DNS..."

$Interface = Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | Select-Object -First 1

if ($Interface) {
    Set-DnsClientServerAddress `
        -InterfaceIndex $Interface.InterfaceIndex `
        -ServerAddresses ("8.8.8.8","8.8.4.4")

    Write-Step "DNS set to 8.8.8.8 / 8.8.4.4"
}

# ---------------------------------------------------------
# Download and Install Programs
# ---------------------------------------------------------

# Load manifest from remote JSON
Write-Step "Fetching manifest..."
$AppsList = Invoke-RestMethod -Uri "https://gist.githubusercontent.com/saharansameer/ee8a7fe89a6fb98d970a5d13588e1bdd/raw/2eb300ec09a6c9f38728a4daebbbeedba086501f/programs.json"
Write-Step "Manifest loaded."

# Install each app based on method defined in manifest
foreach ($App in $AppsList) {
    # Handle EXE Installers
     if ($App.Method -eq "INSTALLER") {
        $InstallerOutPath = "$Downloads\$($App.Name).exe"

        # Download installer
        Write-Step "Downloading $($App.Name)..."
        curl.exe -L $App.DownloadUrl -o $InstallerOutPath
        Write-Step "Download complete. Launching $($App.Name) Installer..."

        # Run installer, optionally wait for completion
        if ($App.Wait) {
            Write-Step "Waiting for $($App.Name) installation to complete..."
            Start-Process $InstallerOutPath -Wait
        } else {
            Start-Process $InstallerOutPath
        }
    }
    # Handle Zip Extraction
    elseif ($App.Method -eq "PORTABLE") {
        $ZipOutPath = "$Downloads\$($App.Name).zip"
        $ZipExtractPath = "$ProgramFiles\$($App.Name)"

        # Download Zip 
        Write-Step "Downloading $($App.Name)..."
        curl.exe -L $App.DownloadUrl -o $ZipOutPath

        # Extract Zip to specified path
        Write-Step "Download complete. Extracting $($App.Name)..."
        Expand-Archive -Path $ZipOutPath -DestinationPath $ZipExtractPath -Force

        # Clean-up after extraction
        Write-Step "$($App.Name) extracted to $($ZipExtractPath)"
        Remove-Item $ZipOutPath -Force
    }
}

# -------------------------------------------------------
# Overwrite Brave Preferences
# -------------------------------------------------------
& {
    Write-Step "Applying Brave preferences..."
 
    $PrefsPath = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Preferences"
    $GistUrl = "https://gist.githubusercontent.com/saharansameer/b57fbd4bc2bcf9e854560861178e87a7/raw/151b11a9da81a88f2c1cf1f2ace2764a8111a211/BravePreferences"
    
    # Wait for Brave to create the profile folder
    $timeout = 60
    $elapsed = 0
    while (-not (Test-Path $PrefsPath) -and $elapsed -lt $timeout) {
        Start-Sleep -Seconds 2
        $elapsed += 2
    }
    
    if (Test-Path $PrefsPath) {
        Stop-Process -Name "brave" -Force
        Start-Sleep -Seconds 2
        Invoke-WebRequest -Uri $GistUrl -OutFile $PrefsPath -UseBasicParsing
        Write-Step "Brave preferences applied."
    } else {
        Write-Step "Preferences file not found, skipping."
    }
}

# -------------------------------------------------------
# Create Desktop Shortcuts
# -------------------------------------------------------
$WshShell = New-Object -ComObject WScript.Shell

$Shortcuts = @(
    @{ Name = "Notepad++";   Exe = "$ProgramFiles\NotepadPlusPlus\notepad++.exe" },
    @{ Name = "VLC";         Exe = "$ProgramFiles\VLC\vlc-3.0.23\vlc.exe" },
    @{ Name = "qBittorrent"; Exe = "$ProgramFiles\qBittorrent\qbittorrent.exe" }
)

foreach ($App in $Shortcuts) {
    $Shortcut = $WshShell.CreateShortcut("$Desktop\$($App.Name).lnk")
    $Shortcut.TargetPath = $App.Exe
    $Shortcut.Save()
    Write-Step "Desktop Shortcut created for $($App.Name)"
}

# Final Execution
Write-Step "`n============================================" 
Write-Step "  All Done!"
Write-Step "============================================`n"

# ============================================================
# END
# ============================================================