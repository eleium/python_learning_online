@echo off
chcp 65001 >nul
color 0A
title 一键同步到GitHub

echo ================================
echo 正在同步Git...
echo ================================

cd /d %~dp0

echo 1. 拉取最新代码
git pull origin main

echo 2. 添加所有变更
git add .

echo 3. 提交代码
set /p msg=输入更新说明(直接回车使用默认): 
if "%msg%"=="" set msg="update"
git commit -m %msg%

echo 4. 推送到GitHub
git push origin main

echo.
echo ? 同步完成！
echo.
pause