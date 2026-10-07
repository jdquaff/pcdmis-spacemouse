# SpaceMouse profile for PC-DMIS

A 3DxWare 10 application profile that lets a 3Dconnexion SpaceMouse (including
the wireless models) pan, zoom, and rotate the CAD model in PC-DMIS's
Graphic Display window.

## Why it doesn't work out of the box

PC-DMIS's built-in 3D mouse support was written for the old **3DxWare 9**
driver. Hexagon's setup instructions still tell you to edit a `user??.scg` file
and add `EXECUTABLES = { "PCDLRN.exe" }`
([PC-DMIS Help: Editing the 3DxWare Configuration File](https://docs.hexagonmi.com/pcdmis/2023.1/en/helpcenter/mergedProjects/core/13_hardware_topics/Editing_the_3DxWare_Configuration_File.htm)).
Wireless SpaceMice run on **3DxWare 10**, which doesn't use `.scg` files. It
picks an XML profile by the program's `.exe` name
([3Dconnexion Admin Guide §5](https://download.3dconnexion.com/drivers/technical_support/3Dconnexion_Admin_Guide_v10-7-1_rev01.pdf)).
No profile exists for `PCDLRN.exe`, so the driver treats PC-DMIS like any
unknown program, and pushing the cap does little more than scroll the mouse
wheel.

## What this profile does

PC-DMIS already responds to mouse gestures in the Graphic Display window
([PC-DMIS Help: Pan, Zoom, Rotate tab](https://docs.hexagonmi.com/pcdmis/2022.2/en/helpcenter/mergedprojects/core/07_edit_cad_topics/Pan_Zoom_Rotate_Tab.htm),
[Shortcut Keys Reference](https://docs.hexagonmi.com/pcdmis/2023.1/en/helpcenter/mergedProjects/core/app_j_shortcuts_topics/Shortcut_Keys_Reference.htm)).
This profile makes the 3Dconnexion driver perform those gestures for you,
following each cap motion:

| Cap motion | PC-DMIS result | Gesture the driver performs |
|---|---|---|
| Slide left / right | Pan left / right | Right-button drag, horizontal |
| Pull up / push down | Pan up / down | Right-button drag, vertical |
| Pull toward you / push away | Zoom in / out | Mouse wheel |
| Tilt forward / back | Rotate (3D) up / down | Middle-button drag, vertical |
| Spin (twist) | Rotate (3D) left / right | Middle-button drag, horizontal |
| Roll left / right | Rotate in the screen plane (2D) | Alt + right-button drag |

Buttons:

| Button | Action |
|---|---|
| SpaceMouse Wireless **right** button (**Fit** on other models) | Scale to Fit (`Ctrl+Z`) |
| SpaceMouse Wireless **left** button (**Menu** on other models) | PC-DMIS radial menu (below) |
| SpaceMouse Pro **1** / **2** / **3** / **4** | Translate mode (`Ctrl+F1`) / Draw probe path (`Alt+P`) / Dominant axis on/off / 3Dconnexion settings |
| SpaceMouse Pro **Esc**, **Alt**, **Shift**, **Ctrl** | The same keyboard keys |

The radial menu has: Scale to Fit, Translate mode, Draw probe path, Esc, lock
rotation, lock pan/zoom, Dominant axis on/off, and 3Dconnexion settings.

The profile never sends Execute or any other command that runs a routine or
moves the machine.

## Requirements

- Windows with **3DxWare 10** (the current 3Dconnexion driver).
- PC-DMIS with the default mouse style. Go to **Edit > Graphic Display
  Window > Lighting, Materials**, open the **Pan, Zoom, Rotate** tab, and check
  that the **CAD Systems** list under **Mouse Controls** is set to
  **PC-DMIS** (not CATIA, Creo, NX, or SolidWorks). The menu path can differ
  slightly between PC-DMIS versions.
- PC-DMIS in **Translate mode** (`Ctrl+F1`), which is its normal mode. In
  Rotate 2D or Rotate 3D mode, a right-button drag rotates instead of panning.
  If panning ever starts rotating, press Translate mode on the radial menu.

## Install

1. Close PC-DMIS.
2. Download this repository (green **Code** button > **Download ZIP**) and unzip it.
3. Right-click `install.ps1` > **Run with PowerShell**, or from a PowerShell
   window in that folder run:

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\install.ps1
   ```

   The script copies `PC-DMIS.xml` into `%APPDATA%\3Dconnexion\3DxWare\Cfg`.
   Any other profile there that targets `PCDLRN.exe` is moved to a
   `Cfg-backup-<date>` folder, not deleted.

   **Manual alternative:** paste `%APPDATA%\3Dconnexion\3DxWare\Cfg` into the
   Explorer address bar and copy `PC-DMIS.xml` there.
4. Restart the 3Dconnexion driver. Signing out and back in, or rebooting, is
   the simplest way.

To uninstall, run `install.ps1 -Uninstall`, or delete `PC-DMIS.xml` from that
folder and restart the driver.

## First-run check (two minutes)

The motion directions were worked out from 3Dconnexion's axis conventions and
PC-DMIS's documented gestures, not tested on a live PC-DMIS seat. Check them
once:

1. Open PC-DMIS, load a routine with CAD, and click once on the CAD view.
   Leave the mouse pointer near the **middle of the CAD view**.
2. Open 3Dconnexion Settings (radial menu > settings, or the tray icon). The
   application name at the top should read **PC-DMIS**. If it doesn't, see
   Troubleshooting.
3. Try each motion from the table above. The model should move the way you
   move the cap, as if you were holding the part.
4. If a motion goes the wrong way, open `PC-DMIS.xml` in Notepad, find that
   motion's `<Axis>` block (each has a comment such as `<!-- Spin: ... -->`),
   and swap its `<Reversed>` value between `true` and `false`. Save, then
   restart the driver.

## Tuning

- **Speed:** use the speed slider in 3Dconnexion Settings, or edit
  `<OverallScale>` in the XML (`0.50` is half speed).
- **Accidental drift:** raise `<Deadband>` (out of 512) on the affected axis.
- **Diagonal rotation:** the profile uses a *Dominant* filter, which sends only
  the strongest cap motion at any moment. Pan and rotate use different mouse
  buttons, and pressing both at once confuses PC-DMIS. Turning the filter off
  (radial menu, or SpaceMouse Pro button 3) allows tilt and spin together,
  but pan may then leak into rotation.
- **Disable a motion:** set that axis's `<Enabled>` to `false`.

## Known limitations

These follow from driving PC-DMIS through mouse gestures. PC-DMIS offers no
other way in for a 3DxWare 10 device.

- **Keep the pointer over the CAD view.** The driver drags wherever the pointer
  is. Over the Edit window, a drag would act on the Edit window instead.
- **The pointer moves while you navigate.** If rotation or panning stops, the
  pointer has reached the edge of the screen. Let go of the cap, move the
  mouse back to the middle of the CAD view, and continue.
- **Roll uses the Alt key.** If PC-DMIS's menu bar gets keyboard focus after a
  roll, press `Esc`. If this keeps happening, disable the roll axis
  (`HIDMultiAxis_Ry`).
- Only one motion at a time while Dominant is on (see Tuning).

## Troubleshooting

**3Dconnexion Settings doesn't show "PC-DMIS" while PC-DMIS is in front.**
The driver didn't load the profile. Check that the file is at
`%APPDATA%\3Dconnexion\3DxWare\Cfg\PC-DMIS.xml`, and restart the driver. If
the settings window shows a different application name, PC-DMIS may be
connecting through its own legacy 3D-mouse interface. Note that name and
whether a small mode symbol appears in the bottom-right corner of the Graphic
Display window, then open an issue on this repository.

**Nothing moves, but the buttons work.** Make sure the CAD view has focus
(click it once) and the pointer is over it.

**Panning rotates the model.** PC-DMIS is in a rotate mode. Use Translate mode
(`Ctrl+F1`) from the radial menu.

**A right-click menu pops up.** Raise the `<Deadband>` on the pan axes
(`HIDMultiAxis_X`, `HIDMultiAxis_Z`).

## Reporting results

If something doesn't behave as described, please open an issue with:

- your PC-DMIS version, 3DxWare version, and SpaceMouse model
- which motion misbehaves and what it does instead
- the application name shown in 3Dconnexion Settings while PC-DMIS is in front
