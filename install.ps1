<#
.SYNOPSIS
    Installs (or removes) the PC-DMIS profile for 3Dconnexion 3DxWare 10.

.DESCRIPTION
    Copies PDCLRN.xml into the current user's 3DxWare configuration folder
    (%APPDATA%\3Dconnexion\3DxWare\Cfg). Any other profile there for PC-DMIS
    (it mentions PCDLRN or PDCLRN, such as the one 3DxWare creates itself)
    would compete with this one, so it is moved to a backup folder next to Cfg.
    Nothing is deleted.

    Close PC-DMIS before running, then restart 3DxWare (simplest: sign out
    of Windows and back in, or reboot) so it reloads its profiles.

.PARAMETER Uninstall
    Moves PDCLRN.xml out of the Cfg folder into a backup folder.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File .\install.ps1

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File .\install.ps1 -Uninstall
#>
param(
    [switch]$Uninstall
)

$ErrorActionPreference = 'Stop'

$profileName = 'PDCLRN.xml'
$source      = Join-Path $PSScriptRoot $profileName
$cfgDir      = Join-Path $env:APPDATA '3Dconnexion\3DxWare\Cfg'
$target      = Join-Path $cfgDir $profileName
$stamp       = Get-Date -Format 'yyyyMMdd-HHmmss'
$backupDir   = Join-Path $env:APPDATA "3Dconnexion\3DxWare\Cfg-backup-$stamp"

function Backup-File([string]$path) {
    if (-not (Test-Path -LiteralPath $backupDir)) {
        New-Item -ItemType Directory -Path $backupDir | Out-Null
    }
    Move-Item -LiteralPath $path -Destination $backupDir
    Write-Host "  moved $(Split-Path $path -Leaf) -> $backupDir"
}

if (Get-Process -Name 'PCDLRN' -ErrorAction SilentlyContinue) {
    Write-Warning 'PC-DMIS is running. Save your work and close it before restarting 3DxWare.'
}

if ($Uninstall) {
    if (Test-Path -LiteralPath $target) {
        Backup-File $target
        Write-Host 'Removed the PC-DMIS profile. Restart 3DxWare (sign out and back in, or reboot).'
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

if (-not (Test-Path -LiteralPath $cfgDir)) {
    New-Item -ItemType Directory -Path $cfgDir | Out-Null
}

Write-Host "3DxWare user configuration folder: $cfgDir"

# Move aside every existing profile that targets PC-DMIS, including our own
# earlier copy and the PDCLRN.xml that 3DxWare writes when settings change.
@(Get-ChildItem -LiteralPath $cfgDir -Filter '*.xml') | ForEach-Object {
    $targetsPcdmis = Select-String -LiteralPath $_.FullName -Pattern 'PCDLRN', 'PDCLRN' -SimpleMatch -Quiet
    if ($targetsPcdmis) {
        Backup-File $_.FullName
    }
}

Copy-Item -LiteralPath $source -Destination $target
Write-Host "Installed $target"
Write-Host ''
Write-Host 'Next: restart 3DxWare (sign out of Windows and back in, or reboot),'
Write-Host 'then follow "First test" in README.md.'
