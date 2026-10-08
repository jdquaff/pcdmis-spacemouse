# Changelog

Notable changes to this project are listed here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and versions follow
[Semantic Versioning](https://semver.org/).

## Unreleased

### Added

- `CONTRIBUTING.md` with how to report problems and propose changes, and the
  safety rules every profile change must keep.
- A **Bug report** issue form that asks for the PC-DMIS, 3DxWare and
  SpaceMouse details needed to diagnose a problem.

## 1.0.0 - 2026-10-08

First release. Tested on PC-DMIS 2024.2 with 3DxWare 10.9.13 (driver
17.9.13) and a wireless SpaceMouse on the 3Dconnexion Universal Receiver.

### Added

- `PDCLRN.xml`, a 3DxWare 10 profile for PC-DMIS. It targets PC-DMIS's legacy
  3D-mouse connection, which registers with the driver as `PDCLRN`. It sends
  PC-DMIS no raw 6-axis motion, which froze the Graphic Display. Instead,
  3DxWare performs PC-DMIS's own mouse gestures:
  - slide and lift/push: pan (right-button drag)
  - pull/push: zoom (mouse wheel)
  - tilt and spin: 3D rotate (middle-button drag)
  - roll: 2D rotate (Alt + right-button drag)
- Button mappings:
  - Fit (right button on SpaceMouse Wireless): Scale to Fit (`Ctrl+Z`).
  - Menu (left button): a PC-DMIS radial menu with Translate mode, Draw probe
    path, 3Dconnexion Settings, and Esc.
  - SpaceMouse Pro 1 / 2 / 4: Translate mode, Draw probe path, and
    3Dconnexion Settings. Esc, Alt, Shift, and Ctrl act as keyboard keys.
  - Every other button does nothing, so none sends inherited shortcuts such
    as Cut or Paste into the Edit window.
- Motion handling:
  - The Dominant axis filter is on for every 3D-mouse model, so pan, rotate,
    and roll never hold mouse buttons or Alt at the same time.
  - Response is linear 1:1. 3DxWare's default for legacy programs is a 4×
    scale with a 1.7 response curve.
  - Per-axis deadbands keep a resting hand from holding a mouse button down.
- `install.cmd` and `uninstall.cmd`, double-click installers built on
  `install.ps1`. The installer copies the profile into
  `%APPDATA%\3Dconnexion\3DxWare\Cfg` and moves any other PC-DMIS profile to
  a dated backup folder. Nothing is deleted.
- `README.md` with installation, PC-DMIS setup, a first test, tuning, and
  troubleshooting.
- MIT license (`LICENSE`) and a License section in the README.

