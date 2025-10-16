@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

rem === 设置目录 ===
set "source_dir=E:\Footages\source"
set "match_dir=E:\Footages\match"
set "target_dir=E:\Footages\target"

rem === 如果目标目录不存在则创建 ===
if not exist "%target_dir%" mkdir "%target_dir%"

echo.
echo 正在匹配文件名（不含扩展名）并移动...
echo.

rem === 遍历源目录下的所有文件 ===
for %%A in ("%source_dir%\*") do (
    set "name=%%~nA"
    rem 在匹配目录中查找同名文件（任意扩展名）
    for %%B in ("%match_dir%\!name!.*") do (
        if exist "%%~fB" (
            echo 移动: %%~nxB
            move /Y "%%~fB" "%target_dir%" >nul
        )
    )
)

echo.
echo === 处理完成 ===
pause
