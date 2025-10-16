rem created by tomriddle1234 @2025 https://github.com/tomriddle1234/footageFileOrganize
@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

rem === 修改这里为你的素材目录 ===
set "src_dir=E:\Footages\20251001XinJiang\DJI\videos"

if not exist "%src_dir%" (
    echo 源目录不存在: "%src_dir%"
    pause
    exit /b 1
)

set "dlog_m_dir=%src_dir%\dlog-m"
set "dlog_dir=%src_dir%\dlog"

if not exist "%dlog_m_dir%" mkdir "%dlog_m_dir%"
if not exist "%dlog_dir%" mkdir "%dlog_dir%"

echo.
echo === 开始分析 SRT 文件并分类移动 ===
echo Source: "%src_dir%"
echo.

set "found_any=0"

for %%F in ("%src_dir%\*.SRT") do (
    set "found_any=1"
    set "srt=%%~fF"
    set "name=%%~nF"
    set "color_line="
    set "color="

    rem 捕获第一行包含 color_md 的内容
    for /f "delims=" %%A in ('findstr /i "color_md:" "%%~fF" 2^>nul') do (
        if not defined color_line set "color_line=%%A"
    )

    if defined color_line (
        echo [检测到] %%~nxF → !color_line!
        rem 将 color_line 写入临时文件避免管道解析错误
        echo !color_line!>"%temp%\_dji_color.tmp"
        findstr /i "dlog_m" "%temp%\_dji_color.tmp" >nul && set "color=dlog_m"
        findstr /i "d_log" "%temp%\_dji_color.tmp" >nul && set "color=d_log"
        del "%temp%\_dji_color.tmp" >nul 2>&1
    ) else (
        echo [未检测到 color_md] %%~nxF
    )

    if /i "!color!"=="dlog_m" (
        echo [DLOG-M] 移动 %%~nF.*
        for %%X in ("%src_dir%\%%~nF.*") do (
            if exist "%%~fX" move /Y "%%~fX" "%dlog_m_dir%" >nul
        )
    ) else if /i "!color!"=="d_log" (
        echo [DLOG] 移动 %%~nF.*
        for %%X in ("%src_dir%\%%~nF.*") do (
            if exist "%%~fX" move /Y "%%~fX" "%dlog_dir%" >nul
        )
    ) else (
        echo [跳过——未知类型] %%~nxF
    )

    echo.
)

if "%found_any%"=="0" (
    echo 没有找到任何 .SRT 文件。
)

echo.
echo === 分类完成 ===
pause
endlocal
