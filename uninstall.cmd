@echo off
rem Removes the PC-DMIS profile from 3DxWare. See README.md.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1" -Uninstall
pause
