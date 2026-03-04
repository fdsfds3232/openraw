# OpenRaw installer for Windows
# Usage: irm https://raw.githubusercontent.com/your-username/openraw/main/install.ps1 | iex
#
# Flags (via environment variables):
#   $env:OPENRAW_INSTALL_DIR = custom install directory
#   $env:OPENRAW_VERSION     = specific version tag (e.g. "v0.1.0")

$ErrorActionPreference = 'Stop'

$Repo = "your-username/openraw"
$DefaultInstallDir = Join-Path $env:USERPROFILE ".openraw\bin"
$InstallDir = if ($env:OPENRAW_INSTALL_DIR) { $env:OPENRAW_INSTALL_DIR } else { $DefaultInstallDir }

function Write-Banner {
    Write-Host ""
    Write-Host "  OpenRaw Installer" -ForegroundColor White
    Write-Host "  =================" -ForegroundColor DarkGray
    Write-Host ""
}

function Get-Architecture {
    $arch = ""
    try {
        $arch = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture.ToString()
    } catch {}

    if (-not $arch -or $arch -eq "") {
        try { $arch = $env:PROCESSOR_ARCHITECTURE } catch {}
    }

    if (-not $arch -or $arch -eq "") {
        try {
            $wmiArch = (Get-CimInstance Win32_Processor).Architecture
            if ($wmiArch -eq 9) { $arch = "AMD64" }
            elseif ($wmiArch -eq 12) { $arch = "ARM64" }
        } catch {}
    }

    if (-not $arch -or $arch -eq "") {
        if ([IntPtr]::Size -eq 8) { $arch = "X64" }
    }

    $archUpper = "$arch".ToUpper().Trim()
    switch ($archUpper) {
        { $_ -in "X64", "AMD64", "X86_64" }     { return "x86_64" }
        { $_ -in "ARM64", "AARCH64", "ARM" }     { return "aarch64" }
        default {
            Write-Host "  Unsupported architecture: $arch" -ForegroundColor Red
            Write-Host "  Try: cargo install --git https://github.com/$Repo openraw-cli" -ForegroundColor DarkGray
            exit 1
        }
    }
}

function Get-LatestVersion {
    if ($env:OPENRAW_VERSION) {
        return $env:OPENRAW_VERSION
    }

    Write-Host "  Fetching latest release..."
    try {
        $release = Invoke-RestMethod -Uri "https://api.github.com/repos/$Repo/releases/latest"
        return $release.tag_name
    }
    catch {
        Write-Host "  Could not determine latest version." -ForegroundColor Red
        Write-Host "  Install from source instead:" -ForegroundColor DarkGray
        Write-Host "    cargo install --git https://github.com/$Repo openraw-cli"
        exit 1
    }
}

function Install-OpenRaw {
    Write-Banner

    $arch = Get-Architecture
    $version = Get-LatestVersion
    $target = "${arch}-pc-windows-msvc"
    $archive = "openraw-${target}.zip"
    $url = "https://github.com/$Repo/releases/download/$version/$archive"
    $checksumUrl = "$url.sha256"

    Write-Host "  Installing OpenRaw $version for $target..."

    if (-not (Test-Path $InstallDir)) {
        New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
    }

    $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) "openraw-install"
    if (Test-Path $tempDir) { Remove-Item -Recurse -Force $tempDir }
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

    $archivePath = Join-Path $tempDir $archive
    $checksumPath = Join-Path $tempDir "$archive.sha256"

    try {
        Invoke-WebRequest -Uri $url -OutFile $archivePath -UseBasicParsing
    }
    catch {
        Write-Host "  Download failed. The release may not exist for your platform." -ForegroundColor Red
        Write-Host "  Install from source instead:" -ForegroundColor DarkGray
        Write-Host "    cargo install --git https://github.com/$Repo openraw-cli"
        Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue
        exit 1
    }

    $checksumDownloaded = $false
    try {
        Invoke-WebRequest -Uri $checksumUrl -OutFile $checksumPath -UseBasicParsing
        $checksumDownloaded = $true
    }
    catch {
        Write-Host "  Checksum file not available, skipping verification." -ForegroundColor DarkGray
    }
    if ($checksumDownloaded) {
        $expectedHash = (Get-Content $checksumPath -Raw).Split(" ")[0].Trim().ToLower()
        $actualHash = (Get-FileHash $archivePath -Algorithm SHA256).Hash.ToLower()
        if ($expectedHash -ne $actualHash) {
            Write-Host "  Checksum verification FAILED!" -ForegroundColor Red
            Write-Host "    Expected: $expectedHash" -ForegroundColor Red
            Write-Host "    Got:      $actualHash" -ForegroundColor Red
            Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue
            exit 1
        }
        Write-Host "  Checksum verified." -ForegroundColor White
    }

    Expand-Archive -Path $archivePath -DestinationPath $tempDir -Force
    $exePath = Join-Path $tempDir "openraw.exe"
    if (-not (Test-Path $exePath)) {
        $found = Get-ChildItem -Path $tempDir -Filter "openraw.exe" -Recurse | Select-Object -First 1
        if ($found) {
            $exePath = $found.FullName
        }
        else {
            Write-Host "  Could not find openraw.exe in archive." -ForegroundColor Red
            Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue
            exit 1
        }
    }

    Copy-Item -Path $exePath -Destination (Join-Path $InstallDir "openraw.exe") -Force
    Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue

    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -notlike "*$InstallDir*") {
        [Environment]::SetEnvironmentVariable("Path", "$InstallDir;$currentPath", "User")
        Write-Host "  Added $InstallDir to user PATH." -ForegroundColor White
        Write-Host "  Restart your terminal for PATH changes to take effect." -ForegroundColor DarkGray
    }

    $installedExe = Join-Path $InstallDir "openraw.exe"
    if (Test-Path $installedExe) {
        try {
            $versionOutput = & $installedExe --version 2>&1
            Write-Host ""
            Write-Host "  OpenRaw installed successfully! ($versionOutput)" -ForegroundColor White
        }
        catch {
            Write-Host ""
            Write-Host "  OpenRaw binary installed to $installedExe" -ForegroundColor White
        }
    }

    Write-Host ""
    Write-Host "  Get started:" -ForegroundColor White
    Write-Host "    openraw init"
    Write-Host ""
    Write-Host "  The setup wizard will guide you through provider selection"
    Write-Host "  and configuration."
    Write-Host ""
}

Install-OpenRaw
