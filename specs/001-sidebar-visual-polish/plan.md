# Implementation Plan: Sidebar Visual Polish

**Branch**: `001-sidebar-visual-polish` | **Date**: 2026-10-15 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/001-sidebar-visual-polish/spec.md`

## Summary

Give the Quickshell sidebar panel a finished look and a personal header. The panel gains a drop
shadow (the existing `StyledRectangularShadow`, re-enabled) and a subtle 1 px border, keeping its
solid background, palette, position and slide-in animation. Its content becomes a vertical column:
a new `SidebarHeader` (avatar from `~/.face` or an initial, name from `/etc/passwd` falling back to
the login, a time-of-day greeting, and uptime from `/proc/uptime`), the space reserved for T-14.3's
date and time, and the existing calendar moved onto a new reusable `SidebarCard`. All new sizes and
colours go into the `Appearance` singleton.

## Technical Context

**Language/Version**: QML (Qt 6.11.2) on Quickshell 0.3.1

**Primary Dependencies**: Quickshell (`Quickshell`, `Quickshell.Io` `FileView`,
`Quickshell.Widgets` `ClippingRectangle`), QtQuick, QtQuick.Layouts, QtQuick.Effects
(`RectangularShadow`, via the repo's `StyledRectangularShadow`)

**Storage**: none — reads `/etc/passwd`, `/proc/uptime` and `~/.face`; writes nothing

**Testing**: no automated suite (constitution V) — `chezmoi diff`/`apply`, the Quickshell log, IPC
open/close, `grim` screenshots and pixel checks, plus manual checks by the user for clicks

**Target Platform**: this Arch Linux + Hyprland desktop; panel on `HDMI-A-1`, dimming only on
`DVI-D-1`

**Project Type**: desktop shell configuration (QML modules in a chezmoi source tree)

**Performance Goals**: open/close animation unchanged (260 ms); header refresh at most once a
minute, only while the panel is open

**Constraints**: palette limited to the existing `Appearance.colors`; panel width 460 px and
position unchanged; nothing drawn while closed; no new package

**Scale/Scope**: 2 new QML components, 3 changed files, 1 desktop

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Status |
| --------- | ----- | ------ |
| I. Single machine | Uses this machine's facts directly (`/etc/passwd`, `~/.face`, monitor names); no options added for other machines | ✅ |
| II. chezmoi source of truth | All edits under `dot_config/quickshell/` in the source; `specs/`, `.specify/`, `.claude/` are in `.chezmoiignore`; no `.tmpl` needed (nothing reads chezmoi data) | ✅ |
| III. Declarative provisioning | No new package, font or service: Quickshell and Qt modules used are already installed and listed | ✅ |
| IV. Tool idiom | New panel content follows the module layout: sidebar widgets in `modules/sidebar/components/`, shared primitive `SidebarCard` there too (sidebar-only), all sizes/colours in `Appearance`, `qs.*` imports | ✅ |
| V. Verified by exercising | `quickstart.md` lists `chezmoi diff`/`apply`, log check, IPC + screenshots, and marks click/time-dependent checks as user-verified | ✅ |

**Post-design re-check**: still ✅ — the design adds no package, no template, no shell.json option
and no file outside the Quickshell source tree.

## Project Structure

### Documentation (this feature)

```text
specs/001-sidebar-visual-polish/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── checklists/
│   └── requirements.md  # From /speckit-specify
└── tasks.md             # Phase 2 output (/speckit-tasks — not created here)
```

No `contracts/` directory: the feature exposes no new interface. The sidebar's only external
interface (the `sidebar` IPC target with `open`/`close`/`toggle`) is unchanged.

### Source Code (repository root)

```text
dot_config/quickshell/modules/
├── common/
│   └── Appearance.qml                 # change: new sizes (avatar, spacing, card radius,
│                                      #   border width, reserved date/time height) and
│                                      #   colours (border, card)
└── sidebar/
    ├── Sidebar.qml                    # change: re-enable shadow, add border, replace the
    │                                  #   calendar Loader with a column (header, reserved
    │                                  #   space, calendar card) loaded on the bar screen only
    └── components/
        ├── Calendar.qml               # change: hover colour readable on the card
        ├── SidebarCard.qml            # new: rounded card container for one widget
        └── SidebarHeader.qml          # new: avatar, name, greeting, uptime
```

**Structure Decision**: everything stays inside the existing `modules/sidebar/` module and the
`Appearance` singleton. `SidebarCard` lives in `modules/sidebar/components/` rather than
`modules/common/widgets/` because only the sidebar uses cards today; it can move to `common/` when
another panel needs it.

## Complexity Tracking

No constitution violations; nothing to justify.
