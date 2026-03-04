# OpenRaw installer for Windows — one command, installs Rust if needed
# Usage: irm https://raw.githubusercontent.com/fdsfds3232/openraw/main/install.ps1 | iex
#
# Environment: $env:OPENRAW_VERSION = version tag | $env:OPENRAW_DESKTOP = 1 to also install desktop

$ErrorActionPreference = 'Stop'

$Repo = "fdsfds3232/openraw"
$CargoBin = Join-Path $env:USERPROFILE ".cargo\bin"

function Write-Banner {
    Write-Host ""
    Write-Host "  OpenRaw Installer" -ForegroundColor White
    Write-Host "  =================" -ForegroundColor DarkGray
    Write-Host ""
}

function Ensure-Rust {
    if (Get-Command cargo -ErrorAction SilentlyContinue) { return }
    Write-Host "  Rust not found. Downloading and installing rustup..." -ForegroundColor Yellow
    Write-Host ""
    $rustup = Join-Path $env:TEMP "rustup-init.exe"
    $arch = if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") { "aarch64-pc-windows-msvc" } else { "x86_64-pc-windows-msvc" }
    Invoke-WebRequest -Uri "https://static.rust-lang.org/rustup/dist/$arch/rustup-init.exe" -OutFile $rustup -UseBasicParsing
    & $rustup -y
    Remove-Item $rustup -ErrorAction SilentlyContinue
    $env:Path = "$CargoBin;$env:Path"
    if (-not (Get-Command cargo -ErrorAction SilentlyContinue)) {
        Write-Host "  Restart your terminal and run the install script again." -ForegroundColor Yellow
        exit 1
    }
    Write-Host "  Rust installed." -ForegroundColor Green
    Write-Host ""
}

function Install-OpenRaw {
    Write-Banner
    Ensure-Rust

    $versionArg = ""
    if ($env:OPENRAW_VERSION) {
        $versionArg = "--tag $env:OPENRAW_VERSION"
        Write-Host "  Installing OpenRaw $env:OPENRAW_VERSION..."
    }
    else {
        Write-Host "  Installing OpenRaw CLI from source..."
    }
    Write-Host ""

    cargo install --git "https://github.com/$Repo" openraw-cli $versionArg
    if ($LASTEXITCODE -ne 0) { Write-Host "  Build failed." -ForegroundColor Red; exit 1 }

    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -notlike "*$CargoBin*") {
        [Environment]::SetEnvironmentVariable("Path", "$CargoBin;$currentPath", "User")
        Write-Host "  Added $CargoBin to PATH." -ForegroundColor White
    }

    $installDesktop = $env:OPENRAW_DESKTOP -eq "1"
    if (-not $installDesktop) {
        $r = Read-Host "  Install desktop app too? [Y/n]"
        $installDesktop = ($r -eq "" -or $r -match "^[Yy]")
    }

    if ($installDesktop) {
        Write-Host ""
        Write-Host "  Installing OpenRaw Desktop (this may take a few minutes)..."
        cargo install --git "https://github.com/$Repo" openraw-desktop $versionArg
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  Desktop installed." -ForegroundColor Green
        }
    }

    $ver = & openraw --version 2>$null
    Write-Host ""
    Write-Host "  OpenRaw installed! ($ver)" -ForegroundColor White
    Write-Host ""
    Write-Host "  Get started: openraw init"
    Write-Host ""
}

Install-OpenRaw
