# SpaceMouse profile for PC-DMIS

[![Latest release](https://img.shields.io/github/v/release/jdquaff/pcdmis-spacemouse)](https://github.com/jdquaff/pcdmis-spacemouse/releases/latest)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-3.0-4baaaa.svg)](CODE_OF_CONDUCT.md)
[![Security policy](https://img.shields.io/badge/security-policy-orange.svg)](SECURITY.md)
[![Contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)](CONTRIBUTING.md)

A 3DxWare 10 profile that lets a 3Dconnexion SpaceMouse (including the
wireless models) pan, zoom, and rotate the CAD model in PC-DMIS's Graphic
Display window, instead of freezing it.

Built for 3DxWare 10.9.13 (driver 17.9.13) and PC-DMIS 2024.2. Its structure
and names follow the 3DxWare 10.9.13 configuration files. The mouse-button
modifiers that make the gestures work (`<Modifiers>`) come from 3Dconnexion
forum guidance by the driver's developers and appear in none of the driver's
own files.

## The problem

PC-DMIS has old built-in 3D-mouse code that connects to the 3Dconnexion driver
under the name **PDCLRN**, not the program file name PCDLRN.exe. That's why
3Dconnexion Settings shows "PDCLRN" when PC-DMIS is in front. 3DxWare treats
PDCLRN as a legacy program and streams raw 6-axis motion to it. Its default
profile for legacy programs also multiplies every axis by 4 and adds a steep
acceleration curve. When that motion reaches PC-DMIS, the Graphic Display
window locks up and ignores even the normal mouse until PC-DMIS is restarted.

Hexagon's setup instructions (editing a `user??.scg` file) are written for the
old 3DxWare 9 driver and don't apply to 3DxWare 10.

## What this profile does

`PDCLRN.xml` replaces the profile 3DxWare uses for PDCLRN. It sends PC-DMIS
**no raw motion at all**. Instead, 3DxWare performs the mouse gestures PC-DMIS
already understands in the Graphic Display window:

| Cap motion | PC-DMIS result | Gesture 3DxWare performs | Axis in `PDCLRN.xml` |
|---|---|---|---|
| Slide left / right | Pan | Right-button drag, horizontal | `HIDMultiAxis_X` |
| Lift up / push down | Pan | Right-button drag, vertical | `HIDMultiAxis_Z` |
| Pull toward you / push away | Zoom | Mouse wheel | `HIDMultiAxis_Y` |
| Tilt forward / back | 3D rotate | Middle-button drag, vertical | `HIDMultiAxis_Rx` |
| Spin (twist) | 3D rotate | Middle-button drag, horizontal | `HIDMultiAxis_Rz` |
| Roll left / right | 2D rotate (in the screen plane) | Alt + right-button drag | `HIDMultiAxis_Ry` |

Only one cap motion is sent at a time (3DxWare's "Dominant" filter). Pan,
rotate, and roll use different mouse buttons and keys, so mixing them would
press several at once. No button on the SpaceMouse turns this off.

Buttons:

| Button | Action |
|---|---|
| **Right** button on SpaceMouse Wireless (**Fit** on other models) | Scale to Fit (`Ctrl+Z`) |
| **Left** button on SpaceMouse Wireless (**Menu** on other models) | PC-DMIS radial menu: Translate mode, Draw probe path, 3Dconnexion Settings, Esc |
| SpaceMouse Pro **1** / **2** / **4** | Translate mode / Draw probe path / 3Dconnexion Settings |
| SpaceMouse Pro **Esc**, **Alt**, **Shift**, **Ctrl** | The same keyboard keys |
| Every other button | Nothing |

The buttons send PC-DMIS **keyboard shortcuts**, which go to whichever window
has keyboard focus. Click an empty area of the Graphic Display first, and
don't use them while a dialog box is open. None of the keystrokes starts
execution or moves the CMM.

## Install

1. In PC-DMIS, **save your work**, then close PC-DMIS.
2. Download this repository (green **Code** button > **Download ZIP**) and
   unzip it.
3. In the unzipped folder, double-click **`install.cmd`**. The window stays
   open so you can read the result.

   This copies `PDCLRN.xml` into `%APPDATA%\3Dconnexion\3DxWare\Cfg`. The
   `PDCLRN.xml` that 3DxWare created there, and any other PC-DMIS profile, is
   moved to a `Cfg-backup-<date-time>` folder next to it. Nothing is deleted.

   **Manual alternative:** paste `%APPDATA%\3Dconnexion\3DxWare\Cfg` into the
   Explorer address bar, move any existing `PDCLRN.xml` somewhere safe, and
   copy this `PDCLRN.xml` in.
4. Restart 3DxWare: sign out of Windows and back in, or reboot.

## Set up PC-DMIS (once)

- **Mouse style:** go to Edit > Graphic Display Window > Lighting, Materials.
  On the Pan, Zoom, Rotate tab, set the CAD Systems list (under Mouse
  Controls) to **PC-DMIS**.
- **Translate mode** (`Ctrl+F1`, PC-DMIS's normal mode). In Rotate 2D or
  Rotate 3D mode, a right-button drag rotates instead of panning. Translate
  mode on the radial menu gets you back.

## First test

Do this with PC-DMIS offline, or with the CMM idle and not executing, on a
copy of a routine.

1. Open the routine with CAD. Click an **empty area** of the Graphic Display
   (not the model), and leave the mouse pointer near the middle of the CAD
   view.
2. **Check that the profile is active:** press the SpaceMouse **left** button
   (**Menu** on larger models). You should see a radial menu titled
   **PC-DMIS** with Translate mode, Draw probe path, 3Dconnexion Settings, and
   Esc. If you get 3Dconnexion's "Common Tools" menu (SpaceMouse Wireless or
   Compact) or the 3Dconnexion Settings window (SpaceMouse Pro or
   Enterprise), the profile isn't loaded; see Troubleshooting.
3. **Push the cap left or right, far enough that the view should move,** then
   let go. If the view freezes again, stop: 3DxWare is still sending raw
   motion. Restart PC-DMIS and report it (see below).
4. Try each motion from the table. The model should move the way you move
   the cap, as if you were holding the part.
5. If a motion goes the wrong way, open `PDCLRN.xml` from the Cfg folder in
   Notepad. Find the `<Axis>` block whose `<Input>` has that motion's axis
   (see the table above) and swap its `<Reversed>` between `true` and
   `false`. Save, then restart 3DxWare.

Keep your hand off the SpaceMouse while a routine is executing.

## Tuning

Make changes by editing `PDCLRN.xml` in the Cfg folder with Notepad, then
restart 3DxWare.

- **Speed:** `<OverallScale>` near the top changes all motions (`0.50` is
  half speed). An axis's `<Scale>` changes that motion only.
- **Accidental drift, or the view moving under a resting hand:** raise that
  axis's `<Deadband>` (out of 512).
- **Turn a motion off:** set that axis's `<Enabled>` to `false`.

Avoid changing settings in 3Dconnexion Settings while PC-DMIS is in front.
3DxWare then rewrites `PDCLRN.xml` from its own copy, and the `<Modifier>`
lines this profile depends on may not survive. If pan or rotate stops working
after such a change, run `install.cmd` again and restart 3DxWare.

## Known limitations

- **Keep the pointer over the CAD view.** 3DxWare drags wherever the pointer
  is.
- **The pointer moves while you navigate.** If rotation or panning stops, the
  pointer has reached the edge of the screen. Let go, move the mouse back to
  the middle of the CAD view, and continue.
- **Roll uses the Alt key.** If PC-DMIS's menu bar gets keyboard focus after
  a roll, press `Esc`. If that keeps happening, set the `HIDMultiAxis_Ry`
  axis's `<Enabled>` to `false`.
- **A very short push can act as a click.** If a right-click menu opens,
  close it with `Esc` (keyboard, or the radial menu) before touching the cap
  again.

## Troubleshooting

**The left button doesn't show the PC-DMIS menu.** Open
`%APPDATA%\3Dconnexion\3DxWare\Cfg\PDCLRN.xml` in Notepad and check that it
contains `RadialMenu_PCDMIS` and `<Modifier>RightMouse</Modifier>`. If not,
run `install.cmd` again. Then restart 3DxWare.

**The pointer moves, but the model doesn't pan or rotate.** Your 3DxWare
version ignores the `<Modifiers>` lines. First check that they're still in
the file (see above). If they are, please report it with your 3DxWare
version.

**The view still freezes when the cap moves.** Restart PC-DMIS, then report
it with your 3DxWare version and a copy of the `PDCLRN.xml` currently in your
Cfg folder.

**Pan and rotate happen together, or Alt or menus appear while panning.** The
Dominant filter has been switched off, for example in 3Dconnexion Settings.
Run `install.cmd` again and restart 3DxWare.

**Panning rotates the model.** PC-DMIS is in a rotate mode. Use Translate
mode from the radial menu.

**A right-click menu pops up when you didn't expect one.** Close it with
`Esc`, then raise `<Deadband>` on the axes that use the right button:
`HIDMultiAxis_X`, `HIDMultiAxis_Z`, and the roll axis `HIDMultiAxis_Ry`.

**Every click acts like a right-click, or Alt seems stuck.** 3DxWare didn't
release a button or key it was holding. Click and release the right and
middle buttons on your real mouse and tap `Alt` on the keyboard. If it
continues, restart 3DxWare.

## Uninstall

Double-click **`uninstall.cmd`**, or delete `PDCLRN.xml` from the Cfg folder.
Then restart 3DxWare. 3DxWare goes back to its default, which freezes PC-DMIS
when the cap moves.

## Reporting results

Please open an issue with:

- your PC-DMIS version, 3DxWare version, and SpaceMouse model
- whether the PC-DMIS radial menu appears
- which motions work, which go the wrong way, and anything that misbehaves

## License

Released under the [MIT License](LICENSE). Copyright (c) 2026 jdquaff.

This project is not affiliated with or endorsed by Hexagon or 3Dconnexion.
PC-DMIS is a trademark of Hexagon. 3Dconnexion, SpaceMouse, and 3DxWare are
trademarks of 3Dconnexion.
