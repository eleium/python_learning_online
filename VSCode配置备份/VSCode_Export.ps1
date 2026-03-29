# VS Code Configuration Export Script
# Usage: Double-click or run in PowerShell: .\VSCode_Export.ps1

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  Visual Studio Code Export Tool" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Set backup path to VSCode_Backup folder in current directory
$backupPath = Join-Path $PSScriptRoot "VSCode_Backup"
$vscodeUserPath = "$env:APPDATA\Code\User"

Write-Host "Backup target: $backupPath`n" -ForegroundColor Yellow

# Create backup directory
if (!(Test-Path $backupPath)) {
    New-Item -ItemType Directory -Force -Path $backupPath | Out-Null
    Write-Host "[OK] Backup directory created" -ForegroundColor Green
}

# Config files list
$configFiles = @('settings.json', 'keybindings.json')

Write-Host "`nExporting configuration files..." -ForegroundColor Cyan
Write-Host "----------------------------------------" -ForegroundColor Gray

foreach ($file in $configFiles) {
    $sourceFile = Join-Path $vscodeUserPath $file
    if (Test-Path $sourceFile) {
        Copy-Item -Path $sourceFile -Destination (Join-Path $backupPath $file) -Force
        Write-Host "[OK] $file" -ForegroundColor Green
    } else {
        Write-Host "[WARN] $file (not found)" -ForegroundColor Yellow
    }
}

# Export snippets
$snippetsPath = Join-Path $vscodeUserPath "snippets"
if (Test-Path $snippetsPath) {
    $snippetsBackup = Join-Path $backupPath "snippets"
    Copy-Item -Path $snippetsPath -Destination $snippetsBackup -Recurse -Force
    Write-Host "[OK] Snippets folder" -ForegroundColor Green
}

# Export extensions list
Write-Host "`nGetting extensions list..." -ForegroundColor Cyan
try {
    $extensions = code --list-extensions 2>$null
    if ($extensions) {
        $extensions | Out-File (Join-Path $backupPath "extensions.txt") -Encoding UTF8
        Write-Host "[OK] Extensions list ($($extensions.Count) installed)" -ForegroundColor Green
        
        Write-Host "`nInstalled Extensions:" -ForegroundColor Cyan
        Write-Host "----------------------------------------" -ForegroundColor Gray
        $extensions | ForEach-Object { 
            Write-Host "   * $_" -ForegroundColor White 
        }
    } else {
        Write-Host "[WARN] code command not responding, skipping extensions export" -ForegroundColor Yellow
        Write-Host "[TIP] Press Ctrl+Shift+X in VS Code to view extensions" -ForegroundColor Yellow
    }
} catch {
    Write-Host "[WARN] Cannot export extensions list" -ForegroundColor Yellow
    Write-Host "[TIP] View extensions panel in VS Code manually" -ForegroundColor Yellow
}

# Generate configuration summary
Write-Host "`nGenerating configuration summary..." -ForegroundColor Cyan
$settingsFile = Join-Path $vscodeUserPath "settings.json"
$summaryContent = @"
================================================================================
                    VS Code Configuration Summary
================================================================================
Export Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
Backup Path: $backupPath

================================================================================
                         Configuration Files
================================================================================
"@

foreach ($file in $configFiles) {
    $summaryContent += "`n- $file"
}

$snippetsBackup = Join-Path $backupPath "snippets"
if (Test-Path $snippetsBackup) {
    $summaryContent += "`n- snippets/ (Code Snippets)"
}

if (Test-Path (Join-Path $backupPath "extensions.txt")) {
    $summaryContent += "`n- extensions.txt (Extensions List)"
}

$summaryContent += "`n`n================================================================================
                         Core Configuration
================================================================================"

if (Test-Path $settingsFile) {
    try {
        $settings = Get-Content $settingsFile -Raw | ConvertFrom-Json
        
        $summaryContent += "`n`n[Font Configuration]"
        $summaryContent += "`nEditor Font: $($settings.'editor.fontFamily')"
        $summaryContent += "`nEditor Font Size: $($settings.'editor.fontSize')"
        $summaryContent += "`nTerminal Font: $($settings.'terminal.integrated.fontFamily')"
        $summaryContent += "`nTerminal Font Size: $($settings.'terminal.integrated.fontSize')"
        
        $summaryContent += "`n`n[Important Settings]"
        $summaryContent += "`nAuto Save: $($settings.'files.autoSave')"
        $summaryContent += "`nFormat On Save: $($settings.'editor.formatOnSave')"
        $summaryContent += "`nStartup Editor: $($settings.'workbench.startupEditor')"
        
        if ($settings.'python.defaultInterpreterPath') {
            $summaryContent += "`n`n[Python Configuration]"
            $summaryContent += "`nPython Interpreter: $($settings.'python.defaultInterpreterPath')"
        }
        
        $summaryContent += "`n`n[Git Configuration]"
        $summaryContent += "`nAuto Fetch: $($settings.'git.autofetch')"
        $summaryContent += "`nSmart Commit: $($settings.'git.enableSmartCommit')"
    } catch {
        $summaryContent += "`n(Unable to parse settings.json)"
    }
}

$summaryContent += "`n`n================================================================================
                         Import Instructions
================================================================================
1. Copy this entire backup folder to a safe location (cloud storage, Git repo, etc.)
2. After reinstalling VS Code, run:

   .\VSCode_Config_Manager.ps1 -Mode Import -BackupPath `"$backupPath`"

3. Or manually copy files to:
   %APPDATA%\Code\User\

4. Recommended: Use VS Code Built-in Sync (Easier):
   - Click gear icon at bottom-left
   - Select Turn on Sync
   - Sign in with Microsoft/GitHub account

================================================================================
                         Verification Checklist
================================================================================
After importing, verify these items:

[ ] Editor font displays correctly (English: Consolas, Chinese: SimSun)
[ ] Font size is 15px
[ ] Terminal font displays correctly
[ ] Auto save works properly
[ ] Format on save works properly
[ ] Python interpreter path is correct
[ ] Shift+Enter inserts line below
[ ] Git auto fetch enabled
[ ] All required extensions installed

================================================================================
Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
================================================================================
"@

$summaryContent | Out-File (Join-Path $backupPath "Configuration_Summary.txt") -Encoding UTF8
Write-Host "[OK] Configuration summary generated" -ForegroundColor Green

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "           Export Complete!" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "Backup Location:" -ForegroundColor Yellow
Write-Host "   $backupPath`n" -ForegroundColor White

Write-Host "Included Files:" -ForegroundColor Yellow
Get-ChildItem $backupPath -Recurse -File | ForEach-Object {
    Write-Host "   * $($_.Name)" -ForegroundColor White
}

Write-Host "`nNext Steps:" -ForegroundColor Yellow
Write-Host "   1. Save backup folder to safe location (cloud, Git, etc.)"
Write-Host "   2. To restore: .\VSCode_Config_Manager.ps1 -Mode Import"
Write-Host "   3. Or use VS Code built-in sync feature`n"

Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
