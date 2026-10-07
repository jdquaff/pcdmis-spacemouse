<#
.SYNOPSIS
    Installs (or removes) the PC-DMIS profile for 3Dconnexion 3DxWare 10.

.DESCRIPTION
    Copies PC-DMIS.xml into the current user's 3DxWare configuration folder
    (%APPDATA%\3Dconnexion\3DxWare\Cfg). Any other profile in that folder that
    also targets PCDLRN.exe would compete with this one, so it is moved to a
    backup folder next to Cfg (never deleted).

    Close PC-DMIS before running, then restart the 3Dconnexion driver
    (simplest: sign out and back in, or reboot) so it reloads its profiles.

.PARAMETER Uninstall
    Removes PC-DMIS.xml from the Cfg folder (a backup copy is kept).

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File .\install.ps1

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File .\install.ps1 -Uninstall
#>
param(
    [switch]$Uninstall
)

$ErrorActionPreference = 'Stop'

$profileName = 'PC-DMIS.xml'
$source      = Join-Path $PSScriptRoot $profileName
$cfgDir      = Join-Path $env:APPDATA '3Dconnexion\3DxWare\Cfg'
$target      = Join-Path $cfgDir $profileName
$stamp       = Get-Date -Format 'yyyyMMdd-HHmmss'
$backupDir   = Join-Path $env:APPDATA "3Dconnexion\3DxWare\Cfg-backup-$stamp"

function Backup-File([string]$path) {
    if (-not (Test-Path $backupDir)) {
        New-Item -ItemType Directory -Path $backupDir | Out-Null
    }
    Move-Item -LiteralPath $path -Destination $backupDir
    Write-Host "  moved $(Split-Path $path -Leaf) -> $backupDir"
}

if (Get-Process -Name 'PCDLRN' -ErrorAction SilentlyContinue) {
    Write-Warning 'PC-DMIS is running. Close it before restarting the 3Dconnexion driver.'
}

if ($Uninstall) {
    if (Test-Path -LiteralPath $target) {
        Backup-File $target
        Write-Host 'Removed the PC-DMIS profile. Restart the 3Dconnexion driver (or sign out and back in).'
    } else {
        Write-Host "Nothing to remove: $target does not exist."
    }
    return
}

if (-not (Test-Path -LiteralPath $source)) {
    throw "Cannot find $profileName next to this script ($PSScriptRoot)."
}

# Refuse to install a file that is not well-formed XML.
[xml](Get-Content -LiteralPath $source -Raw) | Out-Null

if (-not (Test-Path $cfgDir)) {
    New-Item -ItemType Directory -Path $cfgDir | Out-Null
}

Write-Host "3DxWare user configuration folder: $cfgDir"

# Move aside our previous copy and any other profile that claims PCDLRN.exe.
@(Get-ChildItem -LiteralPath $cfgDir -Filter '*.xml') | ForEach-Object {
    $isOurs       = $_.Name -ieq $profileName
    $claimsPcdlrn = Select-String -LiteralPath $_.FullName -Pattern 'PCDLRN' -SimpleMatch -Quiet
    if ($isOurs -or $claimsPcdlrn) {
        Backup-File $_.FullName
    }
}

Copy-Item -LiteralPath $source -Destination $target
Write-Host "Installed $target"
Write-Host ''
Write-Host 'Next: restart the 3Dconnexion driver (sign out and back in, or reboot),'
Write-Host 'then open PC-DMIS and follow "First-run check" in README.md.'
