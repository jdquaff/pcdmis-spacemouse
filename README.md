# SpaceMouse profile for PC-DMIS

A 3DxWare 10 profile that lets a 3Dconnexion SpaceMouse (including the
wireless models) pan, zoom, and rotate the CAD model in PC-DMIS's Graphic
Display window, instead of freezing it.

Built against 3DxWare 10.9.13 (driver 17.9.13) and PC-DMIS 2024.2, using
3DxWare's own configuration files as the reference for every name in it.

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

| Cap motion | PC-DMIS result | Gesture 3DxWare performs |
|---|---|---|
| Slide left / right | Pan | Right-button drag, horizontal |
| Lift up / push down | Pan | Right-button drag, vertical |
| Pull toward you / push away | Zoom | Mouse wheel |
| Tilt forward / back | 3D rotate | Middle-button drag, vertical |
| Spin (twist) | 3D rotate | Middle-button drag, horizontal |
| Roll left / right | 2D rotate (in the screen plane) | Alt + right-button drag |

Buttons:

| Button | Action |
|---|---|
| **Right** button on SpaceMouse Wireless (**Fit** on other models) | Scale to Fit (`Ctrl+Z`) |
| **Left** button on SpaceMouse Wireless (**Menu** on other models) | PC-DMIS radial menu: Translate mode, Draw probe path, 3Dconnexion Settings, Dominant on/off |
| SpaceMouse Pro **1** / **2** / **3** / **4** | Translate mode / Draw probe path / Dominant on/off / 3Dconnexion Settings |
| SpaceMouse Pro **Esc**, **Alt**, **Shift**, **Ctrl** | The same keyboard keys |
| SpaceMouse Pro view buttons (T, R, F, roll) | Nothing (kept away from PC-DMIS's legacy handler) |

Only one cap motion is sent at a time ("Dominant"). Pan and rotate use
different mouse buttons, so mixing them would press both at once.

Nothing in the profile starts execution or moves the CMM.

## Install

1. In PC-DMIS, **save your work**, then close PC-DMIS.
2. Download this repository (green **Code** button > **Download ZIP**) and unzip it.
3. In the unzipped folder, right-click `install.ps1` > **Run with PowerShell**,
   or run this in a PowerShell window in that folder:

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\install.ps1
   ```

   This copies `PDCLRN.xml` into `%APPDATA%\3Dconnexion\3DxWare\Cfg`. The
   `PDCLRN.xml` that 3DxWare created there, and any other PC-DMIS profile, is
   moved to a `Cfg-backup-<date>` folder. Nothing is deleted.

   **Manual alternative:** paste `%APPDATA%\3Dconnexion\3DxWare\Cfg` into the
   Explorer address bar, move any existing `PDCLRN.xml` somewhere safe, and
   copy this `PDCLRN.xml` in.
4. Restart 3DxWare: sign out of Windows and back in, or reboot.

## First test

1. Open PC-DMIS and a routine with CAD, and click once on the CAD view. Leave
   the mouse pointer near the **middle of the CAD view**.
2. **Check that the profile is active:** press the SpaceMouse **left** button
   (**Menu** on larger models). You should see a radial menu titled
   **PC-DMIS** with Translate mode, Draw probe path, 3Dconnexion Settings, and
   Dominant. If you get 3Dconnexion's "Common Tools" menu instead, the profile
   isn't loaded; see Troubleshooting.
3. **Nudge the cap gently, once.** If the view freezes again, stop: 3DxWare is
   still sending raw motion, and the profile needs another change. Report it
   (see below).
4. Try each motion from the table. The model should move the way you move
   the cap, as if you were holding the part.
5. If a motion goes the wrong way, open `PDCLRN.xml` from the Cfg folder in
   Notepad. Find that motion's `<Axis>` block (each has a comment such as
   `<!-- Spin: ... -->`) and swap its `<Reversed>` between `true` and `false`.
   Save, then restart 3DxWare.

## Tuning

- **Speed:** use the speed slider in 3Dconnexion Settings. To change one
  motion only, edit that axis's `<Scale>` (`0.50` is half speed).
- **Accidental drift:** raise that axis's `<Deadband>` (out of 512).
- **Turn a motion off:** set that axis's `<Enabled>` to `false`.
- **Diagonal rotation:** turn Dominant off from the radial menu. Tilt and spin
  can then combine, but pan may leak into rotation.

## Requirements and known limitations

- **PC-DMIS mouse style.** Go to Edit > Graphic Display Window > Lighting,
  Materials. On the Pan, Zoom, Rotate tab, set the CAD Systems list (under
  Mouse Controls) to **PC-DMIS**.
- **Translate mode** (`Ctrl+F1`, PC-DMIS's normal mode). In Rotate 2D or
  Rotate 3D mode, a right-button drag rotates instead of panning. Use
  Translate mode from the radial menu to get back.
- **Keep the pointer over the CAD view.** 3DxWare drags wherever the pointer
  is.
- **The pointer moves while you navigate.** If rotation or panning stops, the
  pointer has reached the edge of the screen. Let go, move the mouse back to
  the middle of the CAD view, and continue.
- **Roll uses the Alt key.** If PC-DMIS's menu bar gets keyboard focus after
  a roll, press `Esc`. If that keeps happening, set the Roll axis's
  `<Enabled>` to `false`.

## Troubleshooting

**The left button doesn't show the PC-DMIS menu.** Check that
`%APPDATA%\3Dconnexion\3DxWare\Cfg\PDCLRN.xml` is this file (it starts with a
comment mentioning github.com/jdquaff/pcdmis-spacemouse). Then restart
3DxWare. Opening 3Dconnexion Settings while PC-DMIS is in front should still
say **PDCLRN**.

**The view still freezes when the cap moves.** Restart PC-DMIS, then open an
issue with your 3DxWare version and a copy of the `PDCLRN.xml` currently in
your Cfg folder. 3DxWare rewrites that file whenever you change settings for
PC-DMIS.

**Panning rotates the model.** PC-DMIS is in a rotate mode. Use Translate
mode from the radial menu.

**A right-click menu pops up.** Raise `<Deadband>` on the two pan axes
(`HIDMultiAxis_X` and `HIDMultiAxis_Z`).

To uninstall, run `install.ps1 -Uninstall` (or delete `PDCLRN.xml` from the
Cfg folder) and restart 3DxWare. 3DxWare then goes back to its default, which
freezes PC-DMIS again.

## Reporting results

Please open an issue with:

- your PC-DMIS version, 3DxWare version, and SpaceMouse model
- whether the PC-DMIS radial menu appears
- which motions work, which go the wrong way, and anything that misbehaves
