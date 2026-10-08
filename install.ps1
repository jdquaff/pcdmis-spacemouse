<#
.SYNOPSIS
    Installs (or removes) the PC-DMIS profile for 3Dconnexion 3DxWare 10.

.DESCRIPTION
    Copies PDCLRN.xml into the current user's 3DxWare configuration folder
    (%APPDATA%\3Dconnexion\3DxWare\Cfg). Any other 3DxWare profile there for
    PC-DMIS (for example the PDCLRN.xml that 3DxWare creates itself) would
    compete with this one, so it is moved to a backup folder next to Cfg.
    Nothing is deleted.

    Double-click install.cmd (or uninstall.cmd) to run this with the window
    kept open. Close PC-DMIS first, and afterwards restart 3DxWare (sign out
    of Windows and back in, or reboot) so it reloads its profiles.

.PARAMETER Uninstall
    Moves PDCLRN.xml out of the Cfg folder into a backup folder.

.EXAMPLE
    powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1

.EXAMPLE
    powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Uninstall
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

# True for a 3DxWare application profile that targets PC-DMIS, by executable
# (PCDLRN.exe), legacy SDK name (PDCLRN) or profile ID (ID_PDCLRN).
function Test-PcdmisProfile([string]$path) {
    try {
        $xml = [xml](Get-Content -LiteralPath $path -Raw)
    } catch {
        return $false
    }
    $root = $xml.DocumentElement
    if ($null -eq $root -or $root.LocalName -ne 'AppCfg') {
        return $false
    }
    $values = @($root.SelectNodes(
        'AppInfo/Signature/ExecutableName | AppInfo/Signature/SiOpenAppName | CfgProperties/ID') |
        ForEach-Object { $_.InnerText.Trim() })
    return [bool]($values -match '^(PCDLRN(\\?\.exe)?|PDCLRN|ID_PDCLRN)$')
}

if (Get-Process -Name 'PCDLRN' -ErrorAction SilentlyContinue) {
    Write-Warning 'PC-DMIS is running. Save your work and close it before restarting 3DxWare.'
}

if ($Uninstall) {
    if (Test-Path -LiteralPath $target) {
        Backup-File $target
        Write-Host 'Removed the PC-DMIS profile. Restart 3DxWare (sign out and back in, or reboot).'
        Write-Host 'Note: 3DxWare then goes back to its default, which freezes PC-DMIS when the cap moves.'
    } else {
        Write-Host "Nothing to remove: $target does not exist."
    }
    return
}

if (-not (Test-Path -LiteralPath $source)) {
    throw "Cannot find $profileName next to this script ($PSScriptRoot). Unzip the whole download first."
}
if ((Resolve-Path -LiteralPath $PSScriptRoot).Path.TrimEnd('\') -ieq $cfgDir.TrimEnd('\')) {
    throw "Run this from the unzipped download folder, not from $cfgDir."
}

# Refuse to install a file that is not well-formed XML.
[xml](Get-Content -LiteralPath $source -Raw) | Out-Null

if (-not (Test-Path -LiteralPath $cfgDir)) {
    New-Item -ItemType Directory -Path $cfgDir | Out-Null
}

Write-Host "3DxWare user configuration folder: $cfgDir"

# Move aside every existing PC-DMIS profile, including our own earlier copy
# and the PDCLRN.xml that 3DxWare writes when settings change.
@(Get-ChildItem -LiteralPath $cfgDir -Filter '*.xml' -File) | ForEach-Object {
    if (Test-PcdmisProfile $_.FullName) {
        Backup-File $_.FullName
    }
}

Copy-Item -LiteralPath $source -Destination $target
Write-Host "Installed $target"
Write-Host ''
Write-Host 'Next: restart 3DxWare (sign out of Windows and back in, or reboot),'
Write-Host 'then follow "First test" in README.md.'
