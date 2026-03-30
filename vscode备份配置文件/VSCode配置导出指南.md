# Visual Studio Code 配置导出与导入指南

## 📋 当前配置信息

### 1. 字体配置
- **英文字体**: Consolas
- **中文字体**: SimSun (新宋体)
- **编辑器字号**: 15px
- **终端字号**: 15px
- **聊天窗口字号**: 14px

### 2. 已安装的扩展插件
由于 VS Code 命令行工具未响应，请手动查看已安装的扩展:
1. 打开 VS Code
2. 按 `Ctrl+Shift+X` 打开扩展面板
3. 查看已安装的扩展列表

**常见扩展导出命令** (如果 `code` 命令可用):
```powershell
code --list-extensions > extensions.txt
```

### 3. 核心配置项

#### 编辑器设置
- 自动保存：`afterDelay` (延迟自动保存)
- 保存时格式化：启用
- 启动编辑器：无 (不显示欢迎页面)
- 次要侧边栏：默认隐藏

#### Python 相关
- 默认解释器：`d:/python_learning/.venv/Scripts/python.exe`
- 在文件目录执行：启用
- 启动后聚焦：启用

#### Git 设置
- 自动获取：启用
- 智能提交：启用

#### 快捷键自定义
- `Shift+Enter`: 在下方插入新行
- `Ctrl+Enter`: 已重新映射 (原默认功能被覆盖)

---

## 📤 导出配置步骤

### 方法一：手动导出配置文件 (推荐)

1. **找到配置文件位置**:
   - Windows: `%APPDATA%\Code\User\`
   - 完整路径：`C:\Users\elei\AppData\Roaming\Code\User\`

2. **需要备份的文件**:
   ```
   settings.json          # 用户设置
   keybindings.json       # 快捷键绑定
   snippets/              # 代码片段文件夹 (如果有)
   ```

3. **复制这些文件到安全位置** (如云盘、Git 仓库等)

### 方法二：使用 VS Code 内置同步功能

1. 点击左下角齿轮图标 ⚙️
2. 选择"打开设置同步"
3. 使用 Microsoft 或 GitHub 账户登录
4. 开启同步选项:
   - ✅ 设置
   - ✅ 键盘快捷方式
   - ✅ 代码片段
   - ✅ 扩展

---

## 📥 导入配置步骤

### 新安装 VS Code 后:

#### 方法一：手动导入 (推荐)

1. **安装 VS Code**:
   - 下载地址：https://code.visualstudio.com/

2. **复制配置文件**:
   - 将备份的 `settings.json` 复制到:
     ```
     C:\Users\[你的用户名]\AppData\Roaming\Code\User\
     ```
   - 将备份的 `keybindings.json` 复制到同一路径

3. **安装扩展插件**:
   - 方式 A: 使用同步功能 (见方法二)
   - 方式 B: 手动安装
     ```powershell
     # 如果有 extensions.txt 文件
     Get-Content extensions.txt | ForEach-Object { code --install-extension $_ }
     ```

4. **验证配置**:
   - 打开 VS Code
   - 按 `Ctrl+,` 检查设置是否正确
   - 检查字体是否为 Consolas + SimSun
   - 检查字号是否为 15

#### 方法二：使用同步功能

1. 在新设备上打开 VS Code
2. 点击左下角齿轮图标 ⚙️
3. 选择"打开设置同步"
4. 使用相同的 Microsoft/GitHub 账户登录
5. 等待自动同步完成

---

## 🔧 快速配置脚本

如果需要快速配置，可以运行以下 PowerShell 脚本:

```powershell
# 创建配置目录
$vscodePath = "$env:APPDATA\Code\User"
New-Item -ItemType Directory -Force -Path $vscodePath | Out-Null

# 下载或复制 settings.json 到该目录
# 下载或复制 keybindings.json 到该目录

Write-Host "✅ VS Code 配置导入完成！" -ForegroundColor Green
```

---

## 📝 重要配置说明

### 字体配置详情
```json
{
  "editor.fontFamily": "Consolas,'SimSun', 'Courier New', monospace",
  "editor.fontSize": 15,
  "terminal.integrated.fontFamily": "Consolas,'SimSun'",
  "terminal.integrated.fontSize": 15
}
```

### 自动保存配置
```json
{
  "files.autoSave": "afterDelay",
  "editor.formatOnSave": true
}
```

### Python 开发配置
```json
{
  "python.defaultInterpreterPath": "d:/python_learning/.venv/Scripts/python.exe",
  "python.terminal.executeInFileDir": true,
  "python.terminal.focusAfterLaunch": true
}
```

---

## 💡 小贴士

1. **配置版本控制**: 建议将配置文件放入 Git 仓库进行版本管理
2. **定期备份**: 每次修改重要配置后备份一次
3. **跨设备同步**: 推荐使用 VS Code 内置同步功能
4. **扩展列表备份**: 
   ```powershell
   code --list-extensions > vscode-extensions.txt
   ```

---

## 🎯 验证清单

配置完成后，请检查以下项目:

- [ ] 编辑器字体显示正确 (英文 Consolas, 中文 SimSun)
- [ ] 字号大小为 15
- [ ] 终端字体显示正确
- [ ] 自动保存功能正常
- [ ] 保存时自动格式化
- [ ] Python 解释器路径正确
- [ ] Shift+Enter 快捷键可在下方插入新行
- [ ] Git 自动获取启用
- [ ] 所有必需扩展已安装

---

**生成时间**: 2026-03-29  
**VS Code 版本**: 1.113.0  
**操作系统**: Windows 22H2
