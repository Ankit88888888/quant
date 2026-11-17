# Require Administrator privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Please run PowerShell as Administrator to clean system directories."
    exit
}

Write-Host "Starting system cleanup..." -ForegroundColor Cyan

# 1. Stop Windows Update services temporarily to unlock update cache files
Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
Stop-Service -Name bits -Force -ErrorAction SilentlyContinue

# 2. Define target directories (cleans contents while preserving the root folders)
$TargetPaths = @(
    "$env:TEMP\*",                                  # Current user Temp
    "$env:SystemRoot\Temp\*",                       # System Windows Temp
    "$env:SystemRoot\Prefetch\*",                   # Windows Prefetch
    "$env:SystemRoot\SoftwareDistribution\Download\*", # Windows Update cache
    "$env:LOCALAPPDATA\Microsoft\Windows\INetCache\*"  # Internet Explorer/System cache
)

foreach ($Path in $TargetPaths) {
    if (Test-Path ($Path -replace '\*$', '')) {
        Write-Host "Cleaning: $Path" -ForegroundColor Gray
        Remove-Item -Path $Path -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# 3. Empty the Recycle Bin
Write-Host "Emptying Recycle Bin..." -ForegroundColor Gray
Clear-RecycleBin -Force -ErrorAction SilentlyContinue

# 4. Restart Windows Update services
Start-Service -Name wuauserv -ErrorAction SilentlyContinue
Start-Service -Name bits -ErrorAction SilentlyContinue

# 5. Optional: Run built-in Windows Disk Cleanup silently for system files
Write-Host "Running Windows Disk Cleanup (cleanmgr)..." -ForegroundColor Gray
Start-Process -FilePath "$env:SystemRoot\System32\cleanmgr.exe" -ArgumentList "/verylowdisk" -Wait

Write-Host "System cleanup complete!" -ForegroundColor Green
