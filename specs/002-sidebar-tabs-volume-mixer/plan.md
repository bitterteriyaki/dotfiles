# Implementation Plan: Sidebar Tabs with a Volume Mixer

**Branch**: `002-sidebar-tabs-volume-mixer` | **Date**: 2026-10-15 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/002-sidebar-tabs-volume-mixer/spec.md`

## Summary

Add a tabbed card below the calendar in the Quickshell sidebar, filling the panel's remaining
height, with two tabs: Notifications (an empty state for now) and Volume. The Volume tab is a
mixer built on Quickshell's built-in PipeWire service: the default output and input with
expandable device pickers, then one row per application playing sound, each with icon, name,
0–100% slider (wheel = ±5%), percentage label and mute. Rows and defaults update live from
PipeWire. The audio packages the mixer relies on, already installed but missing from the
provisioning list, are added to it.

## Technical Context

**Language/Version**: QML (Qt 6.11) on Quickshell 0.3.1

**Primary Dependencies**: `Quickshell.Services.Pipewire` (`Pipewire`, `PwNode`,
`PwObjectTracker`), `Quickshell` (`DesktopEntries`, `Quickshell.iconPath`), QtQuick,
QtQuick.Layouts, QtQuick.Controls (Basic style, already forced in `shell.qml`) for `Slider` and
`ScrollView`

**Storage**: none — volumes, mute and defaults live in PipeWire; the selected tab is in-memory and
reset on every opening

**Testing**: no automated suite (constitution V) — apply, Quickshell log, IPC open, `grim`
screenshots, and `pactl`/`wpctl` to cross-check levels and defaults; drags, clicks and wheel
are user-verified

**Target Platform**: this desktop — PipeWire 1.6.9 with `pipewire-pulse` and WirePlumber 0.5.18;
outputs: Ryzen analog (default), TU106 HDMI, HyperX QuadCast S; inputs: HyperX QuadCast S
(default), Ryzen analog

**Project Type**: desktop shell configuration (QML modules in a chezmoi source tree)

**Performance Goals**: external changes reflected within 1 s (PipeWire pushes changes, no
polling); node tracking only while the sidebar is open

**Constraints**: palette/fonts from `Appearance`; panel never taller than the screen; nothing on
`DVI-D-1`; sliders clamp to 0–100% even though PipeWire allows more

**Scale/Scope**: 6 new QML components, 2 changed QML files, 1 changed provisioning script

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Status |
| --------- | ----- | ------ |
| I. Single machine | Built against this machine's PipeWire setup and devices; no options for other audio stacks | ✅ |
| II. chezmoi source of truth | All edits in the source tree (`dot_config/quickshell/`, `.chezmoiscripts/`); `specs/` ignored; no `.tmpl` | ✅ |
| III. Declarative provisioning | The mixer needs PipeWire + WirePlumber (+ the PulseAudio layer apps use). They are installed but **not** in the package list → this plan adds `pipewire`, `pipewire-pulse`, `pipewire-alsa`, `wireplumber` to `run_onchange_before_install-packages.sh` under "Drivers" | ✅ (with the addition) |
| IV. Tool idiom | Sidebar widgets in `modules/sidebar/components/`; tab state reset through `SidebarState`; sizes/colours in `Appearance`; Nerd Font glyphs via `Appearance.fonts.icons` as in `StatusIcons` | ✅ |
| V. Verified by exercising | `quickstart.md` cross-checks every level and default against `pactl`/`wpctl`; interaction left to the user | ✅ |

**Post-design re-check**: ✅ — one provisioning change (packages already installed, so `yay
--needed` is a no-op here); no services added (the PipeWire user units are already enabled by
their packages).

## Project Structure

### Documentation (this feature)

```text
specs/002-sidebar-tabs-volume-mixer/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── checklists/
│   └── requirements.md  # From /speckit-specify
└── tasks.md             # Phase 2 output (/speckit-tasks)
```

No `contracts/`: the sidebar's only external interface (IPC target `sidebar`) is unchanged.

### Source Code (repository root)

```text
.chezmoiscripts/
└── run_onchange_before_install-packages.sh  # change: add pipewire, pipewire-pulse,
                                             #   pipewire-alsa, wireplumber under "Drivers"
dot_config/quickshell/modules/
├── common/
│   └── Appearance.qml                       # change: tab bar height, row/slider sizes,
│                                            #   icon sizes
└── sidebar/
    ├── Sidebar.qml                          # change: content column fills the panel height;
    │                                        #   add SidebarTabs card (fillHeight) under calendar
    └── components/
        ├── SidebarTabs.qml                  # new: tab bar (icon+text) + content, Notifications
        │                                    #   selected on every opening
        ├── NotificationsTab.qml             # new: centred icon + "No notifications"
        ├── VolumeTab.qml                    # new: scrollable column — output, input, apps;
        │                                    #   "No apps playing" / "Audio unavailable"
        ├── VolumeRow.qml                    # new: icon, name, slider (0–100, wheel ±5%),
        │                                    #   percentage, mute — for devices and apps
        ├── VolumeSlider.qml                 # new: Basic Slider restyled with the palette
        └── DeviceSelector.qml               # new: current device name that expands into a
                                             #   list of devices of that kind
```

**Structure Decision**: everything stays in the sidebar module, consistent with feature 001.
`VolumeRow` serves devices and apps so both look identical; `VolumeSlider` is separate because
the row and any future brightness control can share it.

## Complexity Tracking

No constitution violations; nothing to justify.
