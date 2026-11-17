@echo off
title Windows Debloater
color 0A

:: Check for Administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Please right-click this file and select "Run as administrator".
    pause
    exit /b
)

echo ========================================================
echo           Windows Bloatware Removal Script
echo ========================================================
echo.
echo [1/4] Removing common pre-installed bloatware apps...

:: List of safe-to-remove built-in Microsoft apps
set "apps=Microsoft.BingNews Microsoft.BingWeather Microsoft.GetHelp Microsoft.Getstarted Microsoft.MicrosoftOfficeHub Microsoft.MicrosoftSolitaireCollection Microsoft.People Microsoft.WindowsFeedbackHub Microsoft.YourPhone Microsoft.ZuneMusic Microsoft.ZuneVideo Clipchamp.Clipchamp Microsoft.Todos Microsoft.PowerAutomateDesktop Microsoft.Teams"

for %%a in (%apps%) do (
    echo Removing %%a...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-AppxPackage -AllUsers *%%a* | Remove-AppxPackage -ErrorAction SilentlyContinue"
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-AppxProvisionedPackage -Online | Where-Object DisplayName -Like '*%%a*' | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue" >nul
)

echo.
echo [2/4] Removing Xbox apps...
set "xbox=Microsoft.XboxApp Microsoft.XboxGameOverlay Microsoft.XboxGamingOverlay Microsoft.XboxIdentityProvider Microsoft.XboxSpeechToTextOverlay"
for %%x in (%xbox%) do (
    echo Removing %%x...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-AppxPackage -AllUsers *%%x* | Remove-AppxPackage -ErrorAction SilentlyContinue"
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-AppxProvisionedPackage -Online | Where-Object DisplayName -Like '*%%x*' | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue" >nul
)

echo.
echo [3/4] Disabling Telemetry and Copilot via Registry...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f >nul

echo.
echo [4/4] Uninstalling OneDrive...
taskkill /f /im OneDrive.exe >nul 2>&1
if exist "%SystemRoot%\System32\OneDriveSetup.exe" (
    "%SystemRoot%\System32\OneDriveSetup.exe" /uninstall
)
if exist "%SystemRoot%\SysWOW64\OneDriveSetup.exe" (
    "%SystemRoot%\SysWOW64\OneDriveSetup.exe" /uninstall
)

echo.
echo ========================================================
echo Cleanup Complete! Please restart your PC to apply changes.
echo ========================================================
pause
