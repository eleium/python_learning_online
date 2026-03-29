# VS Code配置导出/导入脚本
# 功能：一键导出或导入 Visual Studio Code 的用户配置

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('Export', 'Import')]
    [string]$Mode,
    
    [Parameter(Mandatory=$false)]
    [string]$BackupPath = "$env:USERPROFILE\VSCode_Backup"
)

$vscodeUserPath = "$env:APPDATA\Code\User"
$configFiles = @('settings.json', 'keybindings.json')

function Export-VSCodeConfig {
    param([string]$destination)
    
    Write-Host "`n🚀 开始导出 VS Code配置..." -ForegroundColor Cyan
    
    # 创建备份目录
    if (!(Test-Path $destination)) {
        New-Item -ItemType Directory -Force -Path $destination | Out-Null
        Write-Host "✅ 创建备份目录：$destination" -ForegroundColor Green
    }
    
    # 导出配置文件
    foreach ($file in $configFiles) {
        $sourceFile = Join-Path $vscodeUserPath $file
        if (Test-Path $sourceFile) {
            Copy-Item -Path $sourceFile -Destination (Join-Path $destination $file) -Force
            Write-Host "✅ 已导出：$file" -ForegroundColor Green
        } else {
            Write-Host "⚠️  文件不存在：$file" -ForegroundColor Yellow
        }
    }
    
    # 导出代码片段
    $snippetsPath = Join-Path $vscodeUserPath "snippets"
    if (Test-Path $snippetsPath) {
        $snippetsDest = Join-Path $destination "snippets"
        Copy-Item -Path $snippetsPath -Destination $snippetsDest -Recurse -Force
        Write-Host "✅ 已导出：代码片段文件夹" -ForegroundColor Green
    }
    
    # 尝试导出扩展列表
    try {
        $extensionsList = code --list-extensions 2>$null
        if ($extensionsList) {
            $extensionsList | Out-File (Join-Path $destination "extensions.txt") -Encoding UTF8
            Write-Host "✅ 已导出：扩展插件列表" -ForegroundColor Green
            
            # 显示安装的扩展
            Write-Host "`n📦 已安装的扩展:" -ForegroundColor Cyan
            $extensionsList | ForEach-Object { Write-Host "   • $_" -ForegroundColor White }
        }
    } catch {
        Write-Host "⚠️  无法导出扩展列表 (code 命令不可用)" -ForegroundColor Yellow
        Write-Host "💡 请手动在 VS Code 中查看扩展面板 (Ctrl+Shift+X)" -ForegroundColor Yellow
    }
    
    # 导出配置摘要
    $summaryFile = Join-Path $destination "配置摘要.txt"
    @"
VS Code配置导出摘要
====================
导出时间：$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
导出路径：$destination

配置文件:
$($configFiles | ForEach-Object { "  - $_" })

字体配置:
$(if (Test-Path (Join-Path $vscodeUserPath 'settings.json')) {
    $settings = Get-Content (Join-Path $vscodeUserPath 'settings.json') -Raw | ConvertFrom-Json
    "  编辑器字体：$($settings.'editor.fontFamily')"
    "  编辑器字号：$($settings.'editor.fontSize')"
    "  终端字体：$($settings.'terminal.integrated.fontFamily')"
    "  终端字号：$($settings.'terminal.integrated.fontSize')"
})

重要设置:
$(if (Test-Path (Join-Path $vscodeUserPath 'settings.json')) {
    $settings = Get-Content (Join-Path $vscodeUserPath 'settings.json') -Raw | ConvertFrom-Json
    "  自动保存：$($settings.'files.autoSave')"
    "  保存时格式化：$($settings.'editor.formatOnSave')"
    "  Python 解释器：$($settings.'python.defaultInterpreterPath')"
})
"@ | Out-File $summaryFile -Encoding UTF8
    Write-Host "✅ 已导出：配置摘要" -ForegroundColor Green
    
    Write-Host "`n🎉 VS Code配置导出完成!" -ForegroundColor Green
    Write-Host "📁 备份位置：$destination" -ForegroundColor Cyan
    Write-Host "`n💡 提示：请将此文件夹保存到安全位置 (如云盘、Git 仓库等)" -ForegroundColor Yellow
}

function Import-VSCodeConfig {
    param([string]$source)
    
    Write-Host "`n🚀 开始导入 VS Code配置..." -ForegroundColor Cyan
    
    if (!(Test-Path $source)) {
        Write-Host "❌ 错误：备份路径不存在：$source" -ForegroundColor Red
        exit 1
    }
    
    # 确保 VS Code 用户目录存在
    if (!(Test-Path $vscodeUserPath)) {
        New-Item -ItemType Directory -Force -Path $vscodeUserPath | Out-Null
        Write-Host "✅ 创建 VS Code 用户目录：$vscodeUserPath" -ForegroundColor Green
    }
    
    # 导入配置文件
    foreach ($file in $configFiles) {
        $sourceFile = Join-Path $source $file
        if (Test-Path $sourceFile) {
            Copy-Item -Path $sourceFile -Destination (Join-Path $vscodeUserPath $file) -Force
            Write-Host "✅ 已导入：$file" -ForegroundColor Green
        } else {
            Write-Host "⚠️  备份中未找到：$file" -ForegroundColor Yellow
        }
    }
    
    # 导入代码片段
    $snippetsSource = Join-Path $source "snippets"
    if (Test-Path $snippetsSource) {
        $snippetsDest = Join-Path $vscodeUserPath "snippets"
        Copy-Item -Path $snippetsSource -Destination $snippetsDest -Recurse -Force
        Write-Host "✅ 已导入：代码片段文件夹" -ForegroundColor Green
    }
    
    # 导入扩展 (如果 extensions.txt 存在)
    $extensionsFile = Join-Path $source "extensions.txt"
    if (Test-Path $extensionsFile) {
        Write-Host "`n📦 准备安装扩展插件..." -ForegroundColor Cyan
        try {
            $extensions = Get-Content $extensionsFile
            foreach ($ext in $extensions) {
                if ($ext -match '\S') {  # 跳过空行
                    Write-Host "   正在安装：$ext" -ForegroundColor Gray
                    code --install-extension $ext 2>$null | Out-Null
                }
            }
            Write-Host "✅ 扩展安装完成!" -ForegroundColor Green
            Write-Host "💡 提示：某些扩展可能需要重启 VS Code 才能生效" -ForegroundColor Yellow
        } catch {
            Write-Host "⚠️  无法自动安装扩展 (code 命令不可用)" -ForegroundColor Yellow
            Write-Host "💡 请手动安装扩展或使用 VS Code 同步功能" -ForegroundColor Yellow
        }
    }
    
    Write-Host "`n🎉 VS Code配置导入完成!" -ForegroundColor Green
    Write-Host "⚠️  请重启 VS Code 以使所有配置生效" -ForegroundColor Yellow
    Write-Host "`n💡 验证清单:" -ForegroundColor Cyan
    Write-Host "   ✓ 检查编辑器字体 (Consolas + SimSun)" -ForegroundColor White
    Write-Host "   ✓ 检查字号大小 (15px)" -ForegroundColor White
    Write-Host "   ✓ 检查自动保存功能" -ForegroundColor White
    Write-Host "   ✓ 检查快捷键 (Shift+Enter)" -ForegroundColor White
}

# 主程序
if ($Mode -eq 'Export') {
    Export-VSCodeConfig -destination $BackupPath
} elseif ($Mode -eq 'Import') {
    Import-VSCodeConfig -source $BackupPath
}
