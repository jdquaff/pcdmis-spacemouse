# Security Policy

This project is a 3DxWare profile and a small installer, but both run on PCs
that control coordinate measuring machines. Problems that could make them do
something harmful are treated as security issues.

## Supported versions

| Version | Supported |
|---|---|
| 1.0.x | Yes |

Fixes go into the latest release. Please update to it before reporting.

## What to report privately

Report these privately, not in a public issue:

- **Machine safety.** Any way the profile could send a keystroke or gesture
  that starts execution, moves the CMM, or changes a measurement routine
  without the user meaning to.
- **The installer.** Any way `install.ps1`, `install.cmd`, or
  `uninstall.cmd` could delete or overwrite files it shouldn't, run other
  code, or be tricked into installing a different file.
- **Tampered copies.** Copies of this project distributed elsewhere with
  modified files.

Ordinary bugs, such as a motion going the wrong way or the profile not
loading, belong in a normal issue (see [CONTRIBUTING.md](CONTRIBUTING.md)).

Problems in PC-DMIS or 3DxWare themselves are out of scope. Report those to
Hexagon or 3Dconnexion.

## How to report

Email [jdquaff@gmail.com](mailto:jdquaff@gmail.com) with:

- what you found and how to reproduce it
- the versions of this project, PC-DMIS, and 3DxWare involved
- what could happen if it were exploited or triggered by accident

Please don't disclose the problem publicly until a fix is released. This is a
one-person project, so allow some time for a reply.

## Staying safe

- Download this project only from
  [github.com/jdquaff/pcdmis-spacemouse](https://github.com/jdquaff/pcdmis-spacemouse)
  or its [releases](https://github.com/jdquaff/pcdmis-spacemouse/releases).
- `PDCLRN.xml` is plain text. Before installing a copy from anywhere else,
  check that it never maps a button to `Ctrl+Q` or `Ctrl+E` (execute) and that
  no axis outputs `HIDMultiAxis_*`. In the file, keys are hex codes: Ctrl is
  `E0`, Q is `14`, and E is `08`. The full rules are in
  [CONTRIBUTING.md](CONTRIBUTING.md).
- Test changes with PC-DMIS offline, or with the CMM idle and not executing.
