#####################################################################################################
# Powershell script that will scan and fix unquoted paths
#####################################################################################################

# Function to scan for unquoted paths
function Get-UnquotedServicePaths {
    Write-Host "Scanning registry for unquoted service paths..."

    $unquotedPaths = @()
    $registryPaths = @(
        "HKLM:\System\CurrentControlSet\Services",
        "HKLM:\System\ControlSet001\Services"
    )

    foreach ($regPath in $registryPaths) {
        Get-ChildItem -Path $regPath | ForEach-Object {
            $imagePath = (Get-ItemProperty -Path $_.PSPath).ImagePath -ErrorAction SilentlyContinue
            if ($imagePath -and $imagePath -notmatch '^".*"$') {
                $unquotedPaths += [PSCustomObject]@{
                    Service  = $_.PSChildName
                    Path     = $imagePath
                    Registry = $_.PSPath
                }
            }
        }
    }
    return $unquotedPaths
}

# Function to fix unquoted paths
function Fix-UnquotedServicePaths {
    param (
        [Parameter(Mandatory = $true)]
        [Array]$ServicesToFix
    )

    foreach ($service in $ServicesToFix) {
        Write-Host "Fixing unquoted path for service: $($service.Service)" -ForegroundColor Yellow

        $quotedPath = '"' + $service.Path + '"'
        Set-ItemProperty -Path $service.Registry -Name ImagePath -Value $quotedPath -ErrorAction SilentlyContinue

        if ($?) {
            Write-Host "Successfully fixed: $($service.Service)" -ForegroundColor Green
        } else {
            Write-Host "Failed to fix: $($service.Service)" -ForegroundColor Red
        }
    }
}

# Main Execution
$unquotedServices = Get-UnquotedServicePaths
if ($unquotedServices.Count -eq 0) {
    Write-Host "No unquoted service paths found." -ForegroundColor Green
} else {
    Write-Host "Found $($unquotedServices.Count) unquoted service paths."
    $unquotedServices | Format-Table -AutoSize

   
    $confirm = Read-Host "Do you want to fix these paths? (Y/N)"
    if ($confirm -match "^Y|y") {
        Fix-UnquotedServicePaths -ServicesToFix $unquotedServices
    } else {
        Write-Host "Operation cancelled by user." -ForegroundColor Yellow
    }
}
