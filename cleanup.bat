
@echo off
title Windows Recycle Bin Cleaner
color 0B

echo ======================================
echo       RECYCLE BIN CLEANER
echo ======================================
echo.

PowerShell.exe -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction Stop"

if %errorlevel% equ 0 (
    echo.
    echo [SUCCESS] Recycle Bin cleaned!
) else (
    echo.
    echo [INFO] Recycle Bin is empty or access was denied.
)

echo.
pause
