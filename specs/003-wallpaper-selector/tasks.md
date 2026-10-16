---

description: "Task list for Wallpaper Selector"
---

# Tasks: Wallpaper Selector

**Input**: Design documents from `/specs/003-wallpaper-selector/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/ipc.md, quickstart.md

**Tests**: No automated tests (no suite in the repo, none requested). Per constitution Principle V,
each story ends with a **validation** task that applies the change and exercises the shell
following `quickstart.md`; clicks and keys are left to the user and reported as unverified, never
claimed.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing
of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1–US4)

## Path Conventions

- Quickshell source: `dot_config/quickshell/` (the live shell hot-reloads from here)
- Module: `dot_config/quickshell/modules/wallpapers/` (replaces `modules/background/`)
- Shared: `dot_config/quickshell/modules/common/Appearance.qml`, `Directories.qml`
- IPC helper used below (zsh): `W() { qs --path ~/.local/share/chezmoi/dot_config/quickshell ipc call wallpapers "$@"; }`
- Verification directory (screenshots, notes): `~/.cache/wallpaper-selector-verify/`, removed in T027

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Starting state and test data

- [X] T001 Record the starting state in `~/.cache/wallpaper-selector-verify/`: the shell runs from source (`pgrep -x qs`), `chezmoi status ~/.config/quickshell` is clean, `qs log --pid $(pgrep -x qs) | tail -3` ends in `Configuration Loaded`, whether `~/.local/state/quickshell/wallpaper.json` exists (expected: no), and "before" screenshots of both monitors (`grim -o HDMI-A-1 before-hdmi.png`, `grim -o DVI-D-1 before-dvi.png`)
- [X] T002 Create temporary test data (removed in T027) and write the list of created paths to `~/.cache/wallpaper-selector-verify/created.txt`: `~/.local/share/wallpapers/test-a.png` and `~/.local/share/wallpapers/sub/test-b.jpg`, two visibly different 1920×1080 crops of `default.png` (e.g. `magick default.png -crop 1920x1080+0+0 +repage test-a.png` and `-crop 1920x1080+5760+1080`; `magick` is used only for this throwaway data, never by the shell), plus `~/.local/share/wallpapers/.hidden.png` (a copy of `test-a.png`) and `~/.local/share/wallpapers/notes.txt` to check filtering

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Rename the module, add paths and sizes, and make the background read a persisted
current wallpaper. Every story needs these.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T003 [P] In `dot_config/quickshell/modules/common/Directories.qml`, following the existing `property string … : \`${Directories.local}/…\`` style, add `state` (`${Directories.local}/state/quickshell`), `wallpaperState` (`${Directories.state}/wallpaper.json`), `thumbnails` (`${Quickshell.env("HOME")}/.cache/quickshell/wallpaper-thumbnails`) and `defaultWallpaper` (`${Directories.wallpapers}/default.png`)
- [X] T004 [P] In `dot_config/quickshell/modules/common/Appearance.qml`, add to `sizes` after the sidebar block: `wallpaperSelectorMaxWidth: 1200`, `wallpaperSelectorPadding: 14`, `wallpaperThumbnailWidth: 214`, `wallpaperThumbnailHeight: 120`, `wallpaperThumbnailSpacing: 10`; no new colours
- [X] T005 Move the module with `git mv dot_config/quickshell/modules/background/Background.qml dot_config/quickshell/modules/wallpapers/Wallpaper.qml` so the history follows, and make sure `modules/background/` no longer exists in the source. In `dot_config/quickshell/shell.qml`, replace `import qs.modules.background` with `import qs.modules.wallpapers` (keep the imports alphabetical) and `Background {}` with `Wallpaper {}`. Keep `WlrLayershell.namespace: "quickshell:background"` in `Wallpaper.qml`
- [X] T006 Create `dot_config/quickshell/modules/wallpapers/WallpaperState.qml` (`pragma Singleton`, `pragma ComponentBehavior: Bound`), modelled on `modules/common/Config.qml`: a `FileView` on `Directories.wallpaperState` with `watchChanges: true`, `onFileChanged: reload()` and a `JsonAdapter` holding `property string path: ""`. On `FileViewError.FileNotFound`, do **not** write the file ("the file is never auto-created"). Add `readonly property string current`, which is the saved `path`, or `Directories.defaultWallpaper` when it is empty. Add `function apply(path: string): void`, which sets the adapter's `path` and calls `writeAdapter()` after a `Process` has run `["mkdir", "-p", Directories.state]`
- [X] T007 In `dot_config/quickshell/modules/wallpapers/Wallpaper.qml`, remove the `// TODO` comment and the hard-coded `wallpaper` property, and implement the effective background from data-model.md: "saved path loads → saved path; saved path missing/error → `default.png`; `default.png` missing/error → plain `Appearance.colors.background`". Bind the `StyledImage` `source` to `WallpaperState.current`. On `status === Image.Error`, switch it to `Directories.defaultWallpaper`, and reset that override when `WallpaperState.current` changes. Add a `Rectangle` with `anchors.fill: parent` and `color: Appearance.colors.background` under the image, inside the clipping `Item`. Keep `StyledImage`'s `asynchronous`/`retainWhileLoading`, so a change swaps in one frame with no blank gap (research R5)
- [X] T008 Apply with `chezmoi apply -v ~/.config/quickshell`, then `rm -r ~/.config/quickshell/modules/background/` (chezmoi does not delete targets whose source was removed). Confirm that `chezmoi status ~/.config/quickshell` is clean and that `qs log` ends in `Configuration Loaded` with no `ERROR`. Both monitors' screenshots must match T001's (wallpaper unchanged, `wallpaper.json` still absent)

**Checkpoint**: Foundation ready — the background now comes from `WallpaperState`

---

## Phase 3: User Story 1 - Pick a wallpaper (Priority: P1) 🎯 MVP

**Goal**: A panel below the bar with a horizontal row of thumbnails (recursive, alphabetical, the
current one highlighted). A click, or the arrows plus Enter, applies the wallpaper and closes the
panel.

**Independent Test**: `W open` lists `default.png`, `sub/test-b.jpg` and `test-a.png`, without the
hidden or `.txt` files, with the current one highlighted. Applying another image changes both
monitors and closes the panel.

### Implementation for User Story 1

- [X] T009 [US1] Create `dot_config/quickshell/modules/wallpapers/WallpaperSelectorState.qml` (`pragma Singleton`):
  - Properties: `property bool visible: false` and `property var entries: []`.
  - `refresh()`: runs a `Process` with `["find", Directories.wallpapers, "-mindepth", "1", "-name", ".*", "-prune", "-o", "-type", "f", "(", "-iname", "*.png", "-o", "-iname", "*.jpg", "-o", "-iname", "*.jpeg", "-o", "-iname", "*.webp", ")", "-printf", "%T@\t%p\n"]`. A `StdioCollector` collects the output. Each non-empty line becomes `{ path, mtime, thumbnail }`, where `thumbnail` = `${Directories.thumbnails}/${Qt.md5(path + ":" + mtime)}.png`. Entries are sorted by `path` with `localeCompare`, and a missing folder gives `[]`. A `signal refreshed()` is emitted when it finishes.
  - `open()`: sets `visible = true` and calls `refresh()`; it does nothing if already open.
  - `close()`: sets `visible = false`.
  - `toggle()`: calls `open()` or `close()`.
- [X] T010 [P] [US1] Create `dot_config/quickshell/modules/wallpapers/components/WallpaperThumbnail.qml`:
  - Interface: `required property var entry`, `property bool current`, `property bool highlighted`, `signal activated()`. Size: `Appearance.sizes.wallpaperThumbnailWidth` × `wallpaperThumbnailHeight`.
  - Image: an `Image` (`asynchronous: true`, `fillMode: Image.PreserveAspectCrop`) first loads `entry.thumbnail`. On `Image.Error`, it switches to `entry.path` with `sourceSize` set to the item size. Once that image is `Ready`, it runs `["mkdir", "-p", Directories.thumbnails]`, then `grabToImage(r => r.saveToFile(entry.thumbnail), Qt.size(width, height))` (research R2/R3).
  - Look: rounded corners with the sidebar card radius; a `foreground` border when `current`; a thicker, brighter outline when `highlighted`; hover and press feedback from an `InteractiveRectangle` layer whose `clicked` emits `activated()`. No file name text.
- [X] T011 [US1] Create `dot_config/quickshell/modules/wallpapers/WallpaperSelector.qml`, mirroring `modules/sidebar/Sidebar.qml` without its slide animation:
  - Structure: a `Scope` root, then `Variants { model: Quickshell.screens }`, each a `PanelWindow { id: window }`.
  - Window: `readonly property bool isBarScreen` copied from `Sidebar.qml`, `WlrLayershell.layer: WlrLayer.Overlay`, `WlrLayershell.namespace: "quickshell:wallpapers"`, `WlrLayershell.keyboardFocus: WlrKeyboardFocus.None` (with the same "never Exclusive" comment), `exclusionMode: ExclusionMode.Ignore`, `color: "transparent"`, all four anchors set, and `visible: WallpaperSelectorState.visible`.
  - Click catcher: a transparent full-window `MouseArea` whose click calls `WallpaperSelectorState.close()`.
  - Panel (only when `window.isBarScreen`): a `Rectangle` styled like the sidebar (`Appearance.colors.secondary`, `sidebarRadius`, `sidebarBorderWidth` border, `StyledRectangularShadow`), anchored top-centre at `barHeight + sidebarMargin`, width fitted to the thumbnails (or the empty message) plus padding, capped at `wallpaperSelectorMaxWidth`, height `wallpaperThumbnailHeight + 2 * wallpaperSelectorPadding`, with its own `MouseArea` that absorbs clicks.
- [X] T012 [US1] Inside the panel in `WallpaperSelector.qml`, add a horizontal `ListView { id: list }`:
  - Settings: `orientation: ListView.Horizontal`, `clip: true`, `spacing: wallpaperThumbnailSpacing`, `highlightFollowsCurrentItem: true`, `model: WallpaperSelectorState.entries`.
  - Delegate: `WallpaperThumbnail` with `required property var modelData` and `required property int index`. It sets `entry: modelData`, `current: modelData.path === WallpaperState.current` and `highlighted: index === list.currentIndex`.
  - Wheel: a `WheelHandler` maps vertical wheel deltas to horizontal `contentX`, clamped to the content bounds.
  - On `WallpaperSelectorState.refreshed`: set `currentIndex` to the current wallpaper's index (0 if absent) and call `positionViewAtIndex(currentIndex, ListView.Center)`.
  - On `activated`: call `WallpaperState.apply(modelData.path)`, then `WallpaperSelectorState.close()`.
- [X] T013 [US1] Add keyboard handling to `WallpaperSelector.qml`:
  - Focus grab: a `HyprlandFocusGrab` with `active: WallpaperSelectorState.visible && window.isBarScreen`, `windows: [window]` and `onCleared: WallpaperSelectorState.close()`.
  - Keys: a `focus: true` `Item` in the panel, with `Keys.onLeftPressed`/`Keys.onRightPressed` moving `list.currentIndex` by −1/+1, clamped to `[0, count − 1]`, and `Keys.onReturnPressed`/`Keys.onEnterPressed` applying the highlighted entry and closing the panel.
- [X] T014 [US1] Add IPC and wire the selector into the shell:
  - In the `Scope` root of `WallpaperSelector.qml` (not inside `Variants`), add `IpcHandler { target: "wallpapers" }` with `function open(): void`, `function close(): void` and `function toggle(): void`, as in `contracts/ipc.md`, delegating to `WallpaperSelectorState`.
  - In `dot_config/quickshell/shell.qml`, add `WallpaperSelector {}` after `Sidebar {}`.
- [X] T015 [US1] Validate US1 per `quickstart.md` §1–3, with screenshots in the verification directory:
  - Load: apply, check that the log is clean, and check that `qs … ipc show` lists `open`/`close`/`toggle` under `target wallpapers`.
  - First open: run `W open`, wait 1 s and screenshot `HDMI-A-1`. Expect the panel centred below the bar with three thumbnails in path order (`default.png`, `sub/test-b.jpg`, `test-a.png`), no `.hidden.png` or `notes.txt`, `default.png` highlighted, and everything visible within 1 s (SC-002). A screenshot of `DVI-D-1` must show nothing drawn.
  - Cache: `ls ~/.cache/quickshell/wallpaper-thumbnails/` lists three PNGs.
  - Reopen: `W open` again changes nothing. After `W close`, add `~/.local/share/wallpapers/test-c.png` (a copy of `test-a.png`, also listed in `created.txt`). `W open` then shows four thumbnails, with the cached ones instant. Delete `test-c.png`, then `W close` and `W open` show three again.
  - Left to the user: clicks, arrows, Enter and wheel scrolling.

**Checkpoint**: User Story 1 is functional and testable independently

---

## Phase 4: User Story 2 - The choice survives restarts (Priority: P1)

**Goal**: The applied wallpaper persists, with fallbacks to `default.png` and then to a plain
colour

**Independent Test**: save a test image, reload the shell, and the background stays the same.
Break the saved path and `default.png` is shown.

### Implementation for User Story 2

- [X] T016 [US2] Validate persistence and fallbacks per `quickstart.md` §4–5. The code is in T006/T007; this check needs no clicks and does not depend on US4.
  - Save: write `{ "path": "$HOME/.local/share/wallpapers/test-a.png" }` to `~/.local/state/quickshell/wallpaper.json`, as `apply()` would. `FileView` picks it up, and screenshots of both monitors show `test-a.png` continuing across the seam (SC-003).
  - Reload: `touch dot_config/quickshell/shell.qml` to force a reload; the background stays `test-a.png`. Ask the user before a full shell restart (SC-004).
  - Fallback: point `wallpaper.json` at `$HOME/.local/share/wallpapers/missing.png`; `default.png` is shown.
  - If the user clicked a thumbnail during T015, also confirm that `wallpaper.json` held that path.
- [X] T017 [US2] Check the last fallback without touching the user's real `default.png`. Temporarily point `Directories.defaultWallpaper` at a non-existent file and `wallpaper.json` at a missing path. Screenshots must show plain `Appearance.colors.background` on both monitors. Then restore `Directories.qml` (`git diff` shows only the T003 change) and `wallpaper.json`

**Checkpoint**: User Stories 1 and 2 work

---

## Phase 5: User Story 3 - Close without picking (Priority: P2)

**Goal**: The selector closes with Escape, a click outside on either monitor, or IPC close/toggle,
and is never open together with the sidebar

**Independent Test**: open and close the selector each way; the wallpaper stays the same, and the
sidebar and the selector are never both open

### Implementation for User Story 3

- [X] T018 [US3] In `dot_config/quickshell/modules/wallpapers/WallpaperSelector.qml`, add `Keys.onEscapePressed: WallpaperSelectorState.close()` to the focused item from T013. Outside clicks are already handled by T011's `MouseArea` and T013's focus grab
- [X] T019 [US3] In `dot_config/quickshell/modules/wallpapers/WallpaperSelectorState.qml`, make `open()` call `SidebarState.close()` first, and add a `Connections { target: SidebarState; function onVisibleChanged() { if (SidebarState.visible) root.close() } }` (FR-011). The sidebar module stays unchanged
- [X] T020 [US3] Validate US3, checking `hyprctl layers` for `quickshell:wallpapers`/`quickshell:sidebar` after each step:
  - IPC: after `W open`, `W close` and `W toggle` twice give the expected open/closed states, and `wallpaper.json` is unchanged.
  - Sidebar exclusion: `W open`, then `qs … ipc call sidebar open`, closes the selector. `qs … ipc call sidebar open`, then `W open`, closes the sidebar.
  - Reload: `W open`, then `touch` `shell.qml`; the selector comes back closed.
  - Left to the user: Escape and outside clicks on both monitors.

**Checkpoint**: User Stories 1–3 work

---

## Phase 6: User Story 4 - Random wallpaper by command (Priority: P3)

**Goal**: `random` applies a different image without opening the panel

**Independent Test**: ten `W random` calls never repeat the current wallpaper; with one image,
nothing happens

### Implementation for User Story 4

- [X] T021 [US4] In `dot_config/quickshell/modules/wallpapers/WallpaperSelectorState.qml`, add `random()`. It calls `refresh()` and, once `refreshed` fires, picks uniformly among the entries whose `path` differs from `WallpaperState.current` and calls `WallpaperState.apply()` with it. With fewer than two entries, it does nothing. It never opens or closes the panel. A one-shot flag makes sure the pick happens only for refreshes started by `random()`
- [X] T022 [US4] Add `function random(): void` to the `IpcHandler` in `dot_config/quickshell/modules/wallpapers/WallpaperSelector.qml`, delegating to `WallpaperSelectorState.random()`
- [X] T023 [US4] Validate US4 per `quickstart.md` §5. `qs … ipc show` matches `contracts/ipc.md` exactly (four functions). Run `W random` ten times and read `wallpaper.json` after each: no consecutive repeat (SC-005), and the panel stays closed. Temporarily move `test-a.png` and `sub/test-b.jpg` out of the folder: `W random` leaves `wallpaper.json` unchanged with no error in `qs log`. Then put them back

**Checkpoint**: All user stories are independently functional

---

## Phase 7: Polish & Cross-Cutting Concerns

- [X] T024 Empty or missing folder (FR-009): in `WallpaperSelector.qml`, show the text "No wallpapers found in ~/.local/share/wallpapers", centred in the panel, in the shell's text colour and font, when `WallpaperSelectorState.entries.length === 0`
- [X] T025 Validate T024: temporarily point `Directories.wallpapers` at a non-existent directory, run `W open` and take a screenshot (the message appears, with no empty row), then restore `Directories.qml`
- [X] T026 Run `quickstart.md` end to end once more. Confirm that `chezmoi status ~/.config/quickshell` is clean and that `qs log` has no `ERROR`. `git status` must show only the files in plan.md, with `background/Background.qml → wallpapers/Wallpaper.qml` as a rename
- [X] T027 Clean up: remove exactly the paths in `created.txt` (and `sub/` if it is empty) and their cached thumbnails. Restore `wallpaper.json` to its T001 state (delete it if it did not exist), confirm that the background matches the T001 screenshots, and delete `~/.cache/wallpaper-selector-verify/`
- [X] T028 Report to the user what only they can verify: clicking a thumbnail applies it and closes the panel; Left/Right/Enter; Escape; outside clicks on both monitors; horizontal scrolling with the mouse wheel; hover and press feedback on thumbnails; and a full shell restart keeping the chosen wallpaper (if not approved in T016). Commit only when the user asks

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: no dependencies
- **Foundational (Phase 2)**: after Setup; it blocks all stories (rename, paths, `WallpaperState`,
  background reading it)
- **US1 (Phase 3)**: after Foundational
- **US2 (Phase 4)**: after Foundational only, because its validation writes `wallpaper.json`
  directly. In the MVP order it runs after US1
- **US3 (Phase 5)**: after US1 (it extends the selector window and state)
- **US4 (Phase 6)**: after US1's `WallpaperSelectorState` (T009) and `IpcHandler` (T014)
- **Polish (Phase 7)**: after all stories

### Within Each User Story

- State before UI, components before the window that uses them, `IpcHandler` last, validation last

### Parallel Opportunities

- T003 (`Directories.qml`) and T004 (`Appearance.qml`) are independent files
- T010 (`WallpaperThumbnail.qml`) can be written in parallel with T009 (`WallpaperSelectorState.qml`)
- US2 (T016–T017) can be validated in parallel with US1 implementation, once Phase 2 is done
- Everything touching `WallpaperSelector.qml` (T011–T014, T018, T022, T024) or
  `WallpaperSelectorState.qml` (T009, T019, T021) is sequential within that file

---

## Parallel Example: Phase 2 and early US1

```text
Task: "T003 Add state/thumbnail/default paths to dot_config/quickshell/modules/common/Directories.qml"
Task: "T004 Add selector sizes to dot_config/quickshell/modules/common/Appearance.qml"

Task: "T009 [US1] Create WallpaperSelectorState.qml in dot_config/quickshell/modules/wallpapers/"
Task: "T010 [US1] Create WallpaperThumbnail.qml in dot_config/quickshell/modules/wallpapers/components/"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Phase 1 and Phase 2: rename the module and persist the background, with no visible change
2. Phase 3 (US1): open by IPC, pick, apply
3. **Stop and validate**: thumbnails, order, highlight, apply on both monitors

### Incremental Delivery

1. Foundation: module renamed, background reads `WallpaperState`
2. + US1: working selector (MVP)
3. + US2: persistence and fallbacks validated
4. + US3: closing paths and sidebar exclusion
5. + US4: `random`
6. Polish: empty-folder message, end-to-end check, cleanup; commits only when the user asks

---

## Notes

- [P] tasks = different files, no dependencies
- After editing several files, `touch` `shell.qml` if the hot reload was missed, and check
  `qs log` again
- Apply only `~/.config/quickshell` so Bitwarden-backed templates are not rendered
- Every temporary change made for validation (test images, `wallpaper.json`, `Directories`
  overrides) is restored before the task is marked done
