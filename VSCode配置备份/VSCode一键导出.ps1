# VS Code配置一键导出脚本
# 使用方法：双击运行或在 PowerShell 中执行
# .\VSCode一键导出.ps1

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  Visual Studio Code配置导出工具" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# 设置备份路径为当前目录下的 VSCode_Backup 文件夹
$backupPath = Join-Path $PSScriptRoot "VSCode_Backup"
$vscodeUserPath = "$env:APPDATA\Code\User"

Write-Host "📂 备份目标位置：$backupPath`n" -ForegroundColor Yellow

# 创建备份目录
if (!(Test-Path $backupPath)) {
    New-Item -ItemType Directory -Force -Path $backupPath | Out-Null
    Write-Host "✅ 已创建备份目录" -ForegroundColor Green
}

# 配置文件列表
$configFiles = @('settings.json', 'keybindings.json')

Write-Host "`n📋 开始导出配置文件..." -ForegroundColor Cyan
Write-Host "----------------------------------------" -ForegroundColor Gray

foreach ($file in $configFiles) {
    $sourceFile = Join-Path $vscodeUserPath $file
    if (Test-Path $sourceFile) {
        Copy-Item -Path $sourceFile -Destination (Join-Path $backupPath $file) -Force
        Write-Host "✅ $file" -ForegroundColor Green
    } else {
        Write-Host "⚠️  $file (不存在)" -ForegroundColor Yellow
    }
}

# 导出代码片段
$snippetsPath = Join-Path $vscodeUserPath "snippets"
if (Test-Path $snippetsPath) {
    $snippetsBackup = Join-Path $backupPath "snippets"
    Copy-Item -Path $snippetsPath -Destination $snippetsBackup -Recurse -Force
    Write-Host "✅ 代码片段文件夹" -ForegroundColor Green
}

# 导出扩展列表
Write-Host "`n📦 正在获取扩展列表..." -ForegroundColor Cyan
try {
    $extensions = code --list-extensions 2>$null
    if ($extensions) {
        $extensions | Out-File (Join-Path $backupPath "extensions.txt") -Encoding UTF8
        Write-Host "✅ 扩展列表 (共 $($extensions.Count) 个)" -ForegroundColor Green
        
        Write-Host "`n📦 已安装的扩展:" -ForegroundColor Cyan
        Write-Host "----------------------------------------" -ForegroundColor Gray
        $extensions | ForEach-Object { 
            Write-Host "   • $_" -ForegroundColor White 
        }
    } else {
        Write-Host "⚠️  code 命令未响应，跳过扩展导出" -ForegroundColor Yellow
        Write-Host "💡 请在 VS Code 中按 Ctrl+Shift+X 查看扩展" -ForegroundColor Yellow
    }
} catch {
    Write-Host "⚠️  无法导出扩展列表" -ForegroundColor Yellow
    Write-Host "💡 请手动在 VS Code 中查看扩展面板" -ForegroundColor Yellow
}

# 生成配置摘要
Write-Host "`n📊 生成配置摘要..." -ForegroundColor Cyan
$settingsFile = Join-Path $vscodeUserPath "settings.json"
$summaryContent = @"
================================================================================
                    VS Code配置导出摘要
================================================================================
导出时间：$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
备份路径：$backupPath

================================================================================
                         配置文件清单
================================================================================
"@

foreach ($file in $configFiles) {
    $summaryContent += "`n✓ $file"
}

$snippetsBackup = Join-Path $backupPath "snippets"
if (Test-Path $snippetsBackup) {
    $summaryContent += "`n✓ snippets/ (代码片段)"
}

if (Test-Path (Join-Path $backupPath "extensions.txt")) {
    $summaryContent += "`n✓ extensions.txt (扩展列表)"
}

$summaryContent += "`n`n================================================================================
                         核心配置信息
================================================================================"

if (Test-Path $settingsFile) {
    try {
        $settings = Get-Content $settingsFile -Raw | ConvertFrom-Json
        
        $summaryContent += "`n`n【字体配置】"
        $summaryContent += "`n编辑器字体：$($settings.'editor.fontFamily')"
        $summaryContent += "`n编辑器字号：$($settings.'editor.fontSize')"
        $summaryContent += "`n终端字体：$($settings.'terminal.integrated.fontFamily')"
        $summaryContent += "`n终端字号：$($settings.'terminal.integrated.fontSize')"
        
        $summaryContent += "`n`n【重要设置】"
        $summaryContent += "`n自动保存：$($settings.'files.autoSave')"
        $summaryContent += "`n保存时格式化：$($settings.'editor.formatOnSave')"
        $summaryContent += "`n启动编辑器：$($settings.'workbench.startupEditor')"
        
        if ($settings.'python.defaultInterpreterPath') {
            $summaryContent += "`n`n【Python 配置】"
            $summaryContent += "`nPython 解释器：$($settings.'python.defaultInterpreterPath')"
        }
        
        $summaryContent += "`n`n【Git 配置】"
        $summaryContent += "`n自动获取：$($settings.'git.autofetch')"
        $summaryContent += "`n智能提交：$($settings.'git.enableSmartCommit')"
    } catch {
        $summaryContent += "`n(无法解析 settings.json)"
    }
}

$summaryContent += "`n`n================================================================================
                         导入说明
================================================================================
1. 将此整个备份文件夹复制到安全位置 (云盘、Git 仓库等)
2. 重新安装 VS Code 后，运行以下命令导入配置:

   .\VSCode配置管理.ps1 -Mode Import -BackupPath `"$backupPath`"

3. 或者手动复制文件到:
   %APPDATA%\Code\User\

4. 推荐使用 VS Code 内置同步功能 (更简单):
   - 点击左下角齿轮图标 ⚙️
   - 选择"打开设置同步"
   - 使用 Microsoft/GitHub 账户登录

================================================================================
                         验证清单
================================================================================
配置导入后，请检查以下项目:

□ 编辑器字体显示正确 (英文 Consolas, 中文 SimSun)
□ 字号大小为 15px
□ 终端字体显示正确
□ 自动保存功能正常
□ 保存时自动格式化
□ Python 解释器路径正确
□ Shift+Enter 快捷键可在下方插入新行
□ Git 自动获取启用
□ 所有必需扩展已安装

================================================================================
生成时间：$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
================================================================================
"@

$summaryContent | Out-File (Join-Path $backupPath "配置摘要.txt") -Encoding UTF8
Write-Host "✅ 配置摘要已生成" -ForegroundColor Green

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "           🎉 导出完成!" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "📁 备份位置:" -ForegroundColor Yellow
Write-Host "   $backupPath`n" -ForegroundColor White

Write-Host "📄 包含文件:" -ForegroundColor Yellow
Get-ChildItem $backupPath -Recurse -File | ForEach-Object {
    Write-Host "   • $($_.Name)" -ForegroundColor White
}

Write-Host "`n💡 下一步操作:" -ForegroundColor Yellow
Write-Host "   1. 将备份文件夹保存到安全位置 (云盘、Git 等)"
Write-Host "   2. 需要时可运行：.\VSCode配置管理.ps1 -Mode Import"
Write-Host "   3. 或使用 VS Code 内置同步功能`n"

Write-Host "按任意键退出..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
