# Research: Wallpaper Selector

Measurements were taken on this machine (Quickshell 0.3.1, Qt 6.11) with throwaway shells.
end-4's implementation (`dots/.config/quickshell/ii/modules/ii/wallpaperSelector/`,
`services/Wallpapers.qml`, `scripts/colors/switchwall.sh`) was read for reference.

## R1 — Listing images recursively

- **Decision**: a `Process` running `find <dir> -mindepth 1 -name '.*' -prune -o -type f …` filtered to
  `-iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp'`, printing
  `%T@\t%p\n` (mtime + path), collected with `StdioCollector`, split into entries and sorted by
  path. It runs every time the selector opens (and before `random`).
  `-not -path '*/.*'` was tried first and listed nothing: it also matches the `/.local` in the
  folder's own path, so hidden names are pruned below the root instead.
- **Rationale**: FR-001 needs subfolders; `FolderListModel` (what end-4 uses) is one directory
  only. `find` is always present and returns the mtime used for the thumbnail cache key (R3).
  Re-listing on open satisfies "added/removed images appear the next time it opens".
- **Alternatives considered**: `FolderListModel` per subfolder (complex tree walking in QML);
  `inotify` watching (unneeded, open-time listing is enough).

## R2 — Thumbnails

- **Decision**: each thumbnail first tries the cached file; if it is missing, it loads the original
  with `asynchronous: true` and `sourceSize` set to the thumbnail size, then saves the rendered
  item with `grabToImage(…, size)` + `saveToFile()` into the cache.
- **Rationale**: FR-010/SC-002. Measured: Qt decodes `default.png` (7680×2160, 32 MB) to a 320 px
  thumbnail in **822 ms** (full decode, then scale), and loads a cached 640×180 PNG in **7 ms**.
  So the first open of a new image costs under a second in a background thread, and every later
  open is instant. ImageMagick (`magick -thumbnail 640x`) took **3177 ms** for the same image and
  is only installed as an undeclared dependency. A throwaway shell confirmed the save path:
  `grabToImage(…, Qt.size(320, 90))` on a loaded `Image` inside a `PanelWindow`, then
  `saveToFile()`, returned `true` and wrote a valid 320×90 PNG. The item must be in a visible
  window, so thumbnails are cached while the selector is open.
- **Alternatives considered**: no cache (every open re-decodes each 32 MB image); end-4's
  thumbnail scripts (Python venv or ImageMagick, plus the freedesktop cache layout) — heavier and
  would add a package; generating all thumbnails at shell start (wasted work when the selector is
  never opened).

## R3 — Thumbnail cache key and location

- **Decision**: `~/.cache/quickshell/wallpaper-thumbnails/<Qt.md5(path + ":" + mtime)>.png`. The
  directory is created with `mkdir -p` (a `Process`) before saving.
- **Rationale**: including the mtime means an edited image gets a fresh thumbnail; the cache is
  disposable and outside chezmoi (constitution II).

## R4 — Persisting the current wallpaper

- **Decision**: `WallpaperState` singleton in `modules/wallpapers/` with a `FileView` +
  `JsonAdapter` on `~/.local/state/quickshell/wallpaper.json` (`{ "path": "…" }`), the same pattern
  as `Config.qml`. `apply(path)` writes the adapter. When the file is missing it is **not**
  auto-created; the default applies.
- **Rationale**: FR-008/SC-004. A state file (not `shell.json`, which is configuration) keeps
  runtime choice separate from settings and outside chezmoi.

## R5 — Fallbacks and instant switching

- **Decision**: `Wallpaper.qml` (today's `Background.qml`, moved into `modules/wallpapers/`) keeps `StyledImage` (`asynchronous`, `retainWhileLoading`) with
  `source` = the saved path; on `Image.Error` it switches to `default.png`; a `Rectangle` in
  `Appearance.colors.background` sits underneath, visible if both fail.
- **Rationale**: FR-004 "instant" with no animation: `retainWhileLoading` keeps the old wallpaper
  on screen while the new one decodes (~1.2 s for the 32 MB file) and swaps it in one frame — no
  blank gap. The fallback chain covers "saved file deleted" and "`default.png` missing".
- **Note**: each monitor has its own background window but they share one source and the same
  decode time, so both switch together (SC-003); confirm with screenshots of both monitors.

## R6 — Window layout, closing, keyboard

- **Decision**: mirror `Sidebar.qml`: `Variants` over `Quickshell.screens`, each a full-screen
  overlay `PanelWindow` (`exclusionMode: Ignore`, `WlrKeyboardFocus.None`) with a **transparent**
  click-catching `MouseArea` that closes; on the bar screen, the panel is anchored top-centre at
  `barHeight + sidebarMargin`. A `HyprlandFocusGrab` (active while open, bar screen) gives keyboard
  input and closes on `onCleared`. Keys: Escape closes, Left/Right move `ListView.currentIndex`,
  Enter applies.
- **Rationale**: FR-002/FR-005/FR-006. The sidebar already proves this combination closes on clicks
  on either monitor and receives Escape; `WlrKeyboardFocus.Exclusive` is avoided because it broke
  cross-monitor clicks (T-14.1 fix). end-4 also anchors its panel just below the bar.

## R7 — Horizontal row

- **Decision**: a horizontal `ListView` with `clip: true`, `highlightFollowsCurrentItem`,
  `positionViewAtIndex(current, ListView.Center)` on open, and a `WheelHandler` mapping vertical
  wheel deltas to horizontal scrolling. Delegates are `WallpaperThumbnail` items whose click target
  is `InteractiveRectangle` (hover/press feedback, FR-012); the current wallpaper gets a
  `foreground` border.
- **Rationale**: spec decisions (horizontal row, highlight current, no names). A plain mouse wheel
  only scrolls vertically, so it has to be mapped.

## R8 — IPC and random

- **Decision**: `IpcHandler { target: "wallpapers" }` with `open`, `close`, `toggle`,
  `random`; `random` re-lists (R1), picks uniformly among entries whose path differs from the
  current one, and applies it; with fewer than two images it does nothing. No `GlobalShortcut`.
- **Rationale**: FR-007 and the user's decision to keep only IPC in this feature. Contract in
  `contracts/ipc.md`.

## R9 — Mutual exclusion with the sidebar

- **Decision**: `WallpaperSelectorState.open()` calls `SidebarState.close()`; a `Connections` on
  `SidebarState` closes the selector when the sidebar opens.
- **Rationale**: FR-011, keeping the dependency one-way (selector → sidebar), so the sidebar module
  stays unaware of the selector.
