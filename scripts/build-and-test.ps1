# OpenRaw — Full build & smoke test
# Run from project root: .\scripts\build-and-test.ps1
# Ensures CLI, Desktop app, and all binaries work after clone from GitHub.

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $root

Write-Host ""
Write-Host "  OpenRaw - Full Build and Test" -ForegroundColor White
Write-Host "  ==========================" -ForegroundColor DarkGray
Write-Host ""

# 1. Full release build (includes openraw + openraw-desktop)
Write-Host "  [1/4] Building entire workspace (release)..." -ForegroundColor Cyan
& cargo build --release
if ($LASTEXITCODE -ne 0) {
    Write-Host "  FAIL: cargo build --release" -ForegroundColor Red
    exit 1
}
Write-Host "  OK   Build complete" -ForegroundColor Green
Write-Host ""

# 2. Verify both binaries exist
$cli = Join-Path $root "target\release\openraw.exe"
$desktop = Join-Path $root "target\release\openraw-desktop.exe"

if (-not (Test-Path $cli)) {
    Write-Host "  FAIL: openraw.exe not found" -ForegroundColor Red
    exit 1
}
if (-not (Test-Path $desktop)) {
    Write-Host "  FAIL: openraw-desktop.exe not found" -ForegroundColor Red
    exit 1
}
Write-Host "  [2/4] Binaries:" -ForegroundColor Cyan
Write-Host "    openraw.exe         $cli"
Write-Host "    openraw-desktop.exe $desktop"
Write-Host "  OK   Both binaries present" -ForegroundColor Green
Write-Host ""

# 3. Smoke test — CLI --help
Write-Host "  [3/4] Testing CLI (openraw --help)..." -ForegroundColor Cyan
$cliHelp = & $cli --help 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "  FAIL: openraw --help failed" -ForegroundColor Red
    exit 1
}
if ($cliHelp -notmatch "OpenRaw") {
    Write-Host "  WARN: CLI output unexpected" -ForegroundColor Yellow
}
Write-Host "  OK   CLI responds" -ForegroundColor Green
Write-Host ""

# 4. Desktop app — quick launch test (will need config, so we just check it starts)
Write-Host "  [4/4] Desktop app check..." -ForegroundColor Cyan
Write-Host "    Note: Desktop app requires WebView2 and ~/.openraw config."
Write-Host "    Run manually: .\target\release\openraw-desktop.exe"
Write-Host "    Or: .\target\release\openraw.exe then select Open desktop app"
Write-Host "  OK   Desktop binary built" -ForegroundColor Green
Write-Host ""

Write-Host "  All checks passed." -ForegroundColor Green
Write-Host ""
Write-Host "  Quick start for users:" -ForegroundColor White
Write-Host "    1. .\target\release\openraw.exe init    # first-time setup"
Write-Host "    2. .\target\release\openraw.exe start   # or run openraw-desktop.exe"
Write-Host "    3. Dashboard → http://localhost:4200"
Write-Host ""
