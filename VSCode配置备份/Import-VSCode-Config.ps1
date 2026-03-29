# VS Code Configuration Import Script
# This script will restore your VS Code settings from backup

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  VS Code Configuration Import Tool" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$backupPath = $PSScriptRoot
$vscodeUserPath = "$env:APPDATA\Code\User"

Write-Host "Source: $backupPath" -ForegroundColor Yellow
Write-Host "Target: $vscodeUserPath`n" -ForegroundColor Yellow

# Ensure VS Code user directory exists
if (!(Test-Path $vscodeUserPath)) {
    Write-Host "Creating VS Code user directory..." -ForegroundColor Gray
    New-Item -ItemType Directory -Force -Path $vscodeUserPath | Out-Null
}

# Import configuration files
Write-Host "Importing configuration files..." -ForegroundColor Cyan
Write-Host "----------------------------------------" -ForegroundColor Gray

$configFiles = @('settings.json', 'keybindings.json')

foreach ($file in $configFiles) {
    $sourceFile = Join-Path $backupPath $file
    $targetFile = Join-Path $vscodeUserPath $file
    
    if (Test-Path $sourceFile) {
        Copy-Item -Path $sourceFile -Destination $targetFile -Force
        Write-Host "[OK] $file imported successfully" -ForegroundColor Green
    } else {
        Write-Host "[WARN] $file not found in backup" -ForegroundColor Yellow
    }
}

# Import snippets folder
$snippetsSource = Join-Path $backupPath "snippets"
$snippetsTarget = Join-Path $vscodeUserPath "snippets"

if (Test-Path $snippetsSource) {
    Copy-Item -Path $snippetsSource -Destination $snippetsTarget -Recurse -Force
    Write-Host "[OK] Snippets folder imported" -ForegroundColor Green
}

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "           Import Complete!" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Green

Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "   1. Restart VS Code completely" -ForegroundColor White
Write-Host "   2. Verify your settings (Ctrl+,)" -ForegroundColor White
Write-Host "   3. Check font display (Consolas + SimSun)" -ForegroundColor White
Write-Host "   4. Test Shift+Enter shortcut" -ForegroundColor White
Write-Host "   5. Install extensions if needed" -ForegroundColor White

Write-Host "`nImportant: Please restart VS Code for all settings to take effect.`n" -ForegroundColor Yellow

Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
