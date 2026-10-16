# Data Model: Wallpaper Selector

## WallpaperEntry (from the folder listing, rebuilt on every open)

| Field | Source | Rule |
| ----- | ------ | ---- |
| `path` | `find` output | absolute path under `~/.local/share/wallpapers/`, any depth; no path component starts with `.`; extension `png`/`jpg`/`jpeg`/`webp` (case-insensitive) |
| `mtime` | `find -printf %T@` | used only for the thumbnail cache key |
| `thumbnail` | — | `~/.cache/quickshell/wallpaper-thumbnails/<md5(path + ":" + mtime)>.png` |

Entries are ordered by `path`, alphabetically.

## CurrentWallpaper (persisted)

Stored in `~/.local/state/quickshell/wallpaper.json`:

```json
{ "path": "/home/kyomi/.local/share/wallpapers/default.png" }
```

| Field | Rule |
| ----- | ---- |
| `path` | absolute path of the last applied image; written by `apply()`; the file is never auto-created |

**Effective background** (what `Wallpaper.qml` shows):

```text
saved path loads          → saved path
saved path missing/error  → ~/.local/share/wallpapers/default.png
default.png missing/error → plain Appearance.colors.background
```

## SelectorState

| Field | Values | Rule |
| ----- | ------ | ---- |
| `visible` | bool | false at shell start; `open()` sets true and closes the sidebar; `close()` false |
| `entries` | list of WallpaperEntry | refreshed when `visible` becomes true and before `random()` |
| `currentIndex` | int | on open: index of the current wallpaper (0 if absent); Left/Right ±1, clamped |

## Transitions

```text
closed ──open/toggle (IPC)──────────────▶ open   (list refreshed, sidebar closed)
open   ──click thumb / Enter──▶ apply ──▶ closed
open   ──Escape / click outside / close/toggle (IPC) / sidebar opens──▶ closed
any    ──random (IPC), ≥2 entries──▶ apply(random entry ≠ current), panel state unchanged
```
