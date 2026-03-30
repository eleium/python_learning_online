# Visual Studio Code Configuration Backup

## 📦 Backup Contents

This folder contains your complete VS Code configuration for easy restoration.

### Files Included:
- **settings.json** - User preferences and settings
- **keybindings.json** - Custom keyboard shortcuts
- **Configuration_Summary.txt** - Detailed summary of your configuration

### Your Configuration Profile:

#### Font Settings:
- **Editor Font Family**: Consolas, SimSun (新宋体)
- **Editor Font Size**: 15px
- **Terminal Font Family**: Consolas, SimSun
- **Terminal Font Size**: 15px

#### Key Preferences:
- Auto Save: `afterDelay`
- Format on Save: `Enabled`
- Startup Editor: None (no welcome page)
- Secondary Sidebar: Hidden by default

#### Python Development:
- Default Interpreter: `d:/python_learning/.venv/Scripts/python.exe`
- Execute in File Directory: Enabled
- Focus After Launch: Enabled

#### Git Settings:
- Auto Fetch: Enabled
- Smart Commit: Enabled

#### Custom Shortcuts:
- **Shift+Enter**: Insert line below
- **Ctrl+Enter**: Remapped from default behavior

---

## 🚀 How to Restore Configuration

### Method 1: Quick Import Script (Recommended)

1. Open PowerShell in this directory
2. Run the import command:
   ```powershell
   .\Import-VSCode-Config.ps1
   ```

### Method 2: Manual Copy

1. Close VS Code completely
2. Copy all files from this folder to:
   ```
   %APPDATA%\Code\User\
   ```
   (Usually: C:\Users\[YourName]\AppData\Roaming\Code\User\)

3. Restart VS Code

### Method 3: VS Code Sync (Easiest for Future)

1. Open VS Code
2. Click the gear icon (⚙️) at bottom-left
3. Select "Turn on Sync"
4. Sign in with Microsoft or GitHub account
5. Your settings will sync automatically across devices

---

## ✅ Verification Checklist

After restoring, verify these items:

- [ ] Editor font displays correctly (Consolas for English, SimSun for Chinese)
- [ ] Font size is 15px
- [ ] Terminal font displays correctly
- [ ] Auto save works (files save after delay)
- [ ] Format on save works
- [ ] Python interpreter path is correct
- [ ] Shift+Enter inserts new line below
- [ ] Git auto fetch is enabled
- [ ] All extensions are installed

---

## 📋 Extensions

To view or install your extensions:

1. Open VS Code
2. Press `Ctrl+Shift+X` to open Extensions panel
3. Review and install required extensions

If you have an `extensions.txt` file, you can install all at once:
```powershell
Get-Content extensions.txt | ForEach-Object { code --install-extension $_ }
```

---

## 💡 Tips

1. **Cloud Storage**: Store this backup folder in cloud storage (OneDrive, Google Drive, etc.)
2. **Version Control**: Add this to a Git repository for version tracking
3. **Regular Updates**: Update backup after making significant configuration changes
4. **Multiple Backups**: Keep backups in multiple locations for safety

---

## 📞 Troubleshooting

### Issues after import?

1. **Restart VS Code**: Some settings require restart
2. **Check File Permissions**: Ensure you have write access
3. **Verify Paths**: Check if Python interpreter path exists
4. **Extensions Missing**: Install extensions manually or use sync

### Font not displaying correctly?

- Ensure Consolas and SimSun fonts are installed on Windows
- Go to: Settings > Text Editor > Font
- Verify font family settings

---

**Backup Created**: 2026-03-29  
**VS Code Version**: 1.113.0  
**OS**: Windows 22H2
