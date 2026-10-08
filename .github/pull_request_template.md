## Summary

<!-- What does this change, and why? Link the issue it fixes, if any. -->

## Testing

<!-- Changes to PDCLRN.xml or the installer must be tested on real hardware,
     with PC-DMIS offline or the CMM idle and not executing.
     Docs-only changes can write "Not applicable". -->

- PC-DMIS version:
- 3DxWare version:
- SpaceMouse model and connection:
- What I tried:

## Checklist

<!-- Tick what applies. The rules are explained in CONTRIBUTING.md. -->

- [ ] Every axis still outputs a mouse gesture (`HIDMouse_*`), never `HIDMultiAxis_*`.
- [ ] No button or menu item sends a keystroke that starts execution or moves the CMM (such as `Ctrl+Q` or `Ctrl+E`).
- [ ] The Dominant axis filter is still on, and no button turns it off.
- [ ] Buttons with no PC-DMIS function go to `Driver_DevNull`.
- [ ] New action IDs exist in the driver's `Base.xml`.
- [ ] If the installer changed: it still runs on Windows PowerShell 5.1, never deletes files, and install, re-install and uninstall work.
- [ ] The README is updated if what users see or do changed.
- [ ] `CHANGELOG.md` has a line under **Unreleased**.
