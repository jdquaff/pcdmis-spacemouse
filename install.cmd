@echo off
rem Installs PDCLRN.xml for 3DxWare. See README.md.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1" %*
pause
