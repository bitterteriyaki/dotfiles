# Implementation Plan: Wallpaper Selector

**Branch**: `003-wallpaper-selector` | **Date**: 2026-10-15 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/003-wallpaper-selector/spec.md`

## Summary

Add a wallpaper selector to the Quickshell config: a panel centred below the bar on the bar's
monitor with a horizontal row of thumbnails of every image under `~/.local/share/wallpapers/`
(recursively, alphabetical). Picking one changes the background instantly and closes the panel;
the choice persists in a state file outside chezmoi. The panel opens only via IPC (`open`,
`close`, `toggle`, plus `random`). Thumbnails are decoded by Qt at reduced size and cached to
disk, so later opens are instant. The existing `modules/background/` is renamed to
`modules/wallpapers/`, which then owns everything about the wallpaper: drawing it
(`Background.qml` → `Wallpaper.qml`), the persisted current choice with fallbacks to
`default.png` and to a plain palette colour, and the selector.

## Technical Context

**Language/Version**: QML (Qt 6.11) on Quickshell 0.3.1

**Primary Dependencies**: Quickshell (`Quickshell.Io` `Process`/`StdioCollector`/`FileView`/
`JsonAdapter`/`IpcHandler`, `Quickshell.Hyprland` `HyprlandFocusGrab`, `Quickshell.Wayland`),
QtQuick (`ListView`, `Image`, `Item.grabToImage`), `find` (coreutils/findutils, already present)

**Storage**: `~/.local/state/quickshell/wallpaper.json` (current wallpaper path);
`~/.cache/quickshell/wallpaper-thumbnails/<md5>.png` (thumbnail cache). Neither is managed by
chezmoi.

**Testing**: no automated suite (constitution V) — apply, `qs log`, IPC calls, `grim` screenshots
on both monitors, restart of the shell for persistence; clicks and keys are user-verified

**Target Platform**: this desktop — bar and panel on `HDMI-A-1`, background spanning `HDMI-A-1`
(1920×1080 at 0,0) and `DVI-D-1` (1360×768 at 1920,150); one wallpaper today, `default.png`
(7680×2160, 32 MB)

**Project Type**: desktop shell configuration (QML modules in a chezmoi source tree)

**Performance Goals**: row visible within 1 s of opening (SC-002). Measured here: Qt decodes
`default.png` to a 320 px thumbnail in 822 ms and at full size in 1185 ms; a cached 640×180
thumbnail loads in 7 ms

**Constraints**: palette and widgets from `Appearance`/`InteractiveRectangle`; keyboard focus via
`HyprlandFocusGrab` with `WlrKeyboardFocus.None` (an exclusive surface breaks clicks on other
monitors, per the T-14.1 fix); nothing on `DVI-D-1` except the click-catching layer; no new
package

**Scale/Scope**: 1 module renamed and extended (1 moved + renamed file, 3 new QML files,
1 component), 2 changed common files, `shell.qml`

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Status |
| --------- | ----- | ------ |
| I. Single machine | Uses this desktop's folder, monitors and bar layout directly | ✅ |
| II. chezmoi source of truth | Code under `dot_config/quickshell/`; runtime state and thumbnail cache live in `~/.local/state` and `~/.cache`, outside chezmoi, so `chezmoi apply` never resets the choice | ✅ |
| III. Declarative provisioning | No new package: listing uses `find`, thumbnails use Qt itself (ImageMagick was measured at 3.2 s per image and is only an undeclared dependency here, so it is not used) | ✅ |
| IV. Tool idiom | One `modules/wallpapers/` module for the whole feature, its main component named after the module (`Wallpaper.qml`, like `bar/Bar.qml` and `sidebar/Sidebar.qml`); selector as `Scope` + `Variants` with a state singleton and `IpcHandler`, mirroring `modules/sidebar/`; sizes in `Appearance`, paths in `Directories` | ✅ |
| V. Verified by exercising | `quickstart.md` covers IPC, screenshots of both monitors, persistence across a shell restart, fallbacks; clicks/keys left to the user | ✅ |

**Post-design re-check**: ✅ — no package, no service, no template; one interface (IPC) documented
in `contracts/ipc.md`.

## Project Structure

### Documentation (this feature)

```text
specs/003-wallpaper-selector/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── ipc.md           # the `wallpapers` IPC target
├── checklists/
│   └── requirements.md
└── tasks.md             # /speckit-tasks
```

### Source Code (repository root)

```text
dot_config/quickshell/
├── shell.qml                                   # change: import qs.modules.wallpapers instead
│                                               #   of qs.modules.background; Background {} →
│                                               #   Wallpaper {}; add WallpaperSelector {}
└── modules/
    ├── common/
    │   ├── Appearance.qml                      # change: selector sizes (panel width/height,
    │   │                                       #   thumbnail height, spacing)
    │   └── Directories.qml                     # change: state dir, thumbnail cache dir,
    │                                           #   default wallpaper path
    ├── background/                             # removed (renamed to wallpapers/)
    ├── sidebar/
    │   └── SidebarState.qml                    # unchanged (selector closes the sidebar and
    │                                           #   watches it; dependency is one-way)
    └── wallpapers/
        ├── Wallpaper.qml                       # moved + renamed from background/Background.qml;
        │                                       #   reads WallpaperState; plain-colour layer
        │                                       #   under the image; layer namespace stays
        │                                       #   "quickshell:background"
        ├── WallpaperState.qml                  # new: singleton — current path persisted in
        │                                       #   wallpaper.json, apply(), effective source
        │                                       #   with fallbacks
        ├── WallpaperSelectorState.qml          # new: singleton — visible, open/close/toggle,
        │                                       #   wallpaper list via `find`, random()
        ├── WallpaperSelector.qml               # new: Scope + Variants over screens; click
        │                                       #   catcher everywhere, panel on bar screen;
        │                                       #   IpcHandler; focus grab; mutual exclusion
        └── components/
            └── WallpaperThumbnail.qml          # new: cached thumbnail with highlight,
                                                #   InteractiveRectangle click target
```

**Structure Decision**: one module owns the wallpaper end to end — drawing it, remembering it and
choosing it — so there is no cross-module state. `modules/background/` is renamed rather than
kept next to a new module, which would have split one feature across two folders with an import
between them. The file is moved with `git mv` so its history follows. `chezmoi apply` does not
delete targets whose source was removed, so the stale `~/.config/quickshell/modules/background/`
is removed explicitly during implementation (and checked with `chezmoi status`). The selector depends on the
sidebar (to close it), never the reverse. The colour-palette feature (matugen) is expected to land
in this module later.

## Complexity Tracking

No constitution violations; nothing to justify.
