# Contributing

Thanks for helping make SpaceMice work better in PC-DMIS. Bug reports from
other PC-DMIS setups are especially useful, because the profile has only been
tested on a few combinations of PC-DMIS, 3DxWare, and SpaceMouse.

Everyone taking part is expected to follow the
[Code of Conduct](CODE_OF_CONDUCT.md).

## Reporting a problem

If the problem could affect machine safety, or lets the installer do
something harmful, follow [SECURITY.md](SECURITY.md) and report it privately
instead of opening an issue.

First try the Troubleshooting section of the [README](README.md). If that
doesn't help, open an issue using the **Bug report** form. It asks for:

- your PC-DMIS version, 3DxWare version, and SpaceMouse model
- whether the PC-DMIS radial menu appears
- which motions misbehave, and what they do instead
- your current `%APPDATA%\3Dconnexion\3DxWare\Cfg\PDCLRN.xml`. 3DxWare
  rewrites this file when you change settings, so the copy on your machine
  may differ from the one in this repository.

## Proposing a change

1. Fork the repository and create a branch.
2. Make your change. If it changes what users see or do, update the README
   too.
3. Test it on real hardware:
   - Run `install.cmd`, sign out of Windows and back in, and follow **First
     test** in the README.
   - Test with PC-DMIS offline, or with the CMM idle and not executing.
4. Add a line under **Unreleased** in [CHANGELOG.md](CHANGELOG.md).
5. Open a pull request. Say which PC-DMIS version, 3DxWare version, and
   SpaceMouse model you tested with, and what you tried.

### Rules for `PDCLRN.xml`

These rules keep the profile safe to use next to a CMM. Pull requests that
break them won't be merged.

- **Never send PC-DMIS raw motion.** Every axis must output a mouse gesture
  (`HIDMouse_X`, `HIDMouse_Y` or `HIDMouse_Wheel`), never `HIDMultiAxis_*`.
  Raw motion is what freezes the Graphic Display.
- **Never send a keystroke that starts execution or moves the CMM.** That
  includes `Ctrl+Q` (execute the routine) and `Ctrl+E` (execute the selected
  feature).
- **Keep the Dominant axis filter on** for every model, and don't map any
  button to `Driver_ToggleDominantFilter`. Without it, pan, rotate and roll
  can hold the right mouse button, the middle mouse button and Alt at the
  same time.
- **Buttons with no PC-DMIS function go to `Driver_DevNull`,** so they can't
  send inherited shortcuts such as Cut or Paste into the Edit window.
- **Use only names your driver knows.** Check new action IDs against the
  driver's own catalog in
  `C:\Program Files\3Dconnexion\3DxWare\3DxWinCore\Cfg\Base.xml`.
  - Keep the file in the driver's 3DxWare 10 format
    (`CfgFormatVersion="1.3"`).
  - Key codes are USB HID usage IDs in hexadecimal (for example `E0` is Ctrl
    and `1D` is Z).
- **Keep the file well-formed XML.** `install.ps1` refuses to install a file
  that isn't.

### Rules for the installer

- It must run on Windows PowerShell 5.1, the version built into Windows 10
  and 11.
- It must never delete files. Existing profiles are moved to a dated backup
  folder.
- Test install, re-install, and uninstall before opening a pull request.

## License

By contributing, you agree that your contributions are licensed under the
[MIT License](LICENSE).
