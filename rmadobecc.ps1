# Get all installed programs
$installedPrograms = Get-WmiObject -Class Win32_Product

# Filter for Adobe applications
$adobePrograms = $installedPrograms | Where-Object { $_.Name -like 'Adobe*' }

# Iterate over Adobe applications
foreach ($program in $adobePrograms) {
    # Check if the program is not Adobe Acrobat
    if ($program.Name -ne 'Adobe Acrobat') {
        # Uninstall the program
        Write-Host "Uninstalling $($program.Name)"
        $program.Uninstall()
    }
}
