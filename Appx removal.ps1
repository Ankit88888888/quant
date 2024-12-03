Import-Module Appx
Import-Module Dism

# Get all packages  Where PublisherId -eq 8wekyb3d8bbwe and remove them
Get-AppxPackage -AllUsers | Where PublisherId -eq 8wekyb3d8bbwe | Remove-AppxPackage

# Get all packages from DISM
$packages = dism /online /get-packages

# Filter packages containing 'handwriting'
$targetPackages = $packages -split "`r`n" | Where-Object { $_ -like "*handwriting*" }

# Extract package names
$packageNames = $targetPackages | ForEach-Object {
    if ($_ -match "Package Identity : (?<name>.*)") {
        $Matches.name.trim()
    }
}

# Remove each identified package
foreach ($pkg in $packageNames) {
    if ($pkg) {
        Write-Host "Removing package: $pkg"
        dism /online /remove-package /packagename:$pkg /NoRestart
    }
}

Write-Host "Done removing packages."