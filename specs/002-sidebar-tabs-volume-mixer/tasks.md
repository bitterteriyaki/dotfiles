---

description: "Task list for Sidebar Tabs with a Volume Mixer"
---

# Tasks: Sidebar Tabs with a Volume Mixer

**Input**: Design documents from `/specs/002-sidebar-tabs-volume-mixer/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Tests**: No automated tests (no suite in the repo, none requested). Per constitution Principle V,
each story ends with a **validation** task that applies the change and exercises the shell
following `quickstart.md`; drags, clicks and wheel are left to the user and reported as
unverified, never claimed.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing
of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1–US3)

## Path Conventions

- Quickshell source: `dot_config/quickshell/modules/` (the live shell hot-reloads from here)
- Sidebar components: `dot_config/quickshell/modules/sidebar/components/`
- Shared tokens: `dot_config/quickshell/modules/common/Appearance.qml`
- Provisioning: `.chezmoiscripts/run_onchange_before_install-packages.sh`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Provisioning and starting state

- [X] T001 Add `pipewire`, `pipewire-pulse`, `pipewire-alsa` and `wireplumber` (approved by the user) to the `packages` array in `.chezmoiscripts/run_onchange_before_install-packages.sh`, under the existing `# Drivers:` comment after `nvidia-utils`; do not run the script (the next full `chezmoi apply` does, and `yay --needed` is a no-op here) — check with `grep -n -A5 '# Drivers' .chezmoiscripts/run_onchange_before_install-packages.sh`
- [X] T002 Confirm the live shell runs from source (`pgrep -af 'qs --path'`), `chezmoi status ~/.config/quickshell` is clean, the last `qs log` entry is `Configuration Loaded`, and at least one application is playing sound (`pactl list short sink-inputs`); take a "before" screenshot of the open sidebar into the session scratchpad

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Tokens and a content column that can give the tabs the panel's remaining height

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T003 [P] Add to `sizes` in `dot_config/quickshell/modules/common/Appearance.qml`: `tabBarHeight` (e.g. 36), `tabIconSize` (e.g. 16), `volumeRowHeight` (e.g. 40), `volumeIconSize` (e.g. 24), `sliderHeight` (e.g. 6), `sliderHandleSize` (e.g. 14), `volumeLabelWidth` (width for "100%", e.g. 44); no new colours (reuse `foreground`, `muted`, `secondary`, `card`)
- [X] T004 In `dot_config/quickshell/modules/sidebar/Sidebar.qml`, anchor the content `Loader` inside `panel` to the panel's bottom as well (`anchors.bottom: parent.bottom`, keeping `sidebarPadding` margins) and make its `ColumnLayout` fill it (`anchors.fill` via the Loader's size), so a child with `Layout.fillHeight: true` can take the remaining height; add a temporary `Item { Layout.fillWidth: true; Layout.fillHeight: true }` after the calendar card
- [X] T005 Apply (`chezmoi apply -v ~/.config/quickshell`, `touch Sidebar.qml` if the reload was missed), confirm `Configuration Loaded` with no `ERROR`, and screenshot via IPC: header, reserved space and calendar unchanged

**Checkpoint**: Foundation ready — user story implementation can now begin

---

## Phase 3: User Story 1 - Switch between the two tabs (Priority: P1) 🎯 MVP

**Goal**: A card below the calendar, filling the remaining height, with "Notifications" and "Volume"
tabs (icon + text); Notifications selected on every opening

**Independent Test**: open the sidebar → Notifications selected; click Volume → selected; close and
reopen → Notifications again

### Implementation for User Story 1

- [X] T006 [US1] Create `dot_config/quickshell/modules/sidebar/components/SidebarTabs.qml` (`pragma ComponentBehavior: Bound`; imports `qs.modules.common`, `qs.modules.sidebar`, `qs.modules.sidebar.components`, `QtQuick`, `QtQuick.Layouts`) as a `Rectangle` styled like `SidebarCard` (`color: Appearance.colors.card`, `radius: Appearance.sizes.cardRadius`) holding a `ColumnLayout`: a tab bar `RowLayout` of height `Appearance.sizes.tabBarHeight` with two equal-width tab buttons in the order "Notifications" (glyph `String.fromCodePoint(0xF009A)`) then "Volume" (glyph `String.fromCodePoint(0xF057E)`), each icon in `Appearance.fonts.icons` + label in `Appearance.fonts.mono`; the selected tab has `Appearance.colors.secondary` background, the other is transparent with a `secondary` hover (same as `StatusIcons`), pointer cursor; below it a content `Item` with `Layout.fillWidth/fillHeight` showing one `Loader` per tab, `visible`/`active` only for the selected one
- [X] T007 [US1] In `SidebarTabs.qml`, hold `property string currentTab: "notifications"` (values "`notifications` | `volume`"), set it from the tab buttons' clicks, and reset it to `"notifications"` in a `Connections { target: SidebarState }` whenever `SidebarState.visible` becomes true ("set to `notifications` every time the sidebar opens")
- [X] T008 [US1] In `dot_config/quickshell/modules/sidebar/Sidebar.qml`, replace the temporary filler `Item` from T004 with `SidebarTabs { Layout.fillWidth: true; Layout.fillHeight: true }`; the two tab contents are plain placeholders until US2/US3 land
- [X] T009 [US1] Validate US1 per `quickstart.md` §1–2: apply, clean log, IPC-open screenshot shows the card below the calendar reaching the panel's bottom padding, both tabs with icon + text, Notifications highlighted; confirm by `DVI-D-1` screenshot that nothing is drawn there; leave tab clicks and the reopen reset to the user

**Checkpoint**: User Story 1 is functional and testable independently

---

## Phase 4: User Story 2 - Control volume from the sidebar (Priority: P1)

**Goal**: The Volume tab — output and input with device pickers, then one row per playing app;
sliders 0–100%, wheel ±5%, percentage, mute; live updates

**Independent Test**: Volume tab values match `pactl` (within 1%); external `pactl` changes show
within 1 s; dragging, scrolling, muting and switching devices change `pactl`'s values

### Implementation for User Story 2

- [X] T010 [P] [US2] Create `dot_config/quickshell/modules/sidebar/components/VolumeSlider.qml`: a QtQuick.Controls `Slider` (Basic style) with `from: 0; to: 1`, custom `background` (track `Appearance.sizes.sliderHeight` tall, `Appearance.colors.muted`, filled part `Appearance.colors.foreground`) and `handle` (`Appearance.sizes.sliderHandleSize` circle, `foreground`); a `WheelHandler` that emits `moved(value)` with `clamp(min(value, 1) ± 0.05, 0, 1)` per wheel step (sign from `angleDelta.y`); signal `moved(real value)` also emitted while dragging (`onMoved`)
- [X] T011 [P] [US2] Create `dot_config/quickshell/modules/sidebar/components/VolumeRow.qml`: `required property var node` (a `PwNode`), `property string label`, `property string iconSource` (image path, may be empty), `property string glyph` (Nerd Font fallback); a `RowLayout` of height `Appearance.sizes.volumeRowHeight` with: icon (`Image` of `volumeIconSize` when `iconSource` resolves, else the glyph `Text` in `Appearance.fonts.icons`), a `ColumnLayout` with the label (elided with "…") above a `VolumeSlider` bound to "slider shows `min(volume, 1)`", the percentage label "`round(volume × 100)%`" in a `volumeLabelWidth`-wide `Text`, and a mute button showing `0xF0581` when muted (or the row's muted glyph) that does "`audio.muted = !audio.muted` (PipeWire keeps the level)"; slider/wheel write "`audio.volume = clamp(v, 0, 1)`"
- [X] T012 [P] [US2] Create `dot_config/quickshell/modules/sidebar/components/DeviceSelector.qml`: `required property bool sinks` (true = outputs); shows the current default's `description` (elided) with a chevron (`0xF0140` collapsed / `0xF0143` expanded); clicking toggles `expanded`; when expanded, lists every `Pipewire.nodes.values` node with `audio && !isStream && isSink === sinks`, the current default marked; clicking one sets `Pipewire.preferredDefaultAudioSink` (or `preferredDefaultAudioSource`) to it and collapses; a single device still expands without error
- [X] T013 [US2] Create `dot_config/quickshell/modules/sidebar/components/VolumeTab.qml` (imports `Quickshell`, `Quickshell.Services.Pipewire`, `QtQuick.Controls`): a `PwObjectTracker` with `objects` = default sink + default source + all audio nodes, only while `SidebarState.visible`; a `ScrollView` (vertical only, content width = view width) holding a `ColumnLayout` with, in order: output section (`DeviceSelector { sinks: true }` + `VolumeRow` for `Pipewire.defaultAudioSink`, glyph `0xF057E`), input section (`DeviceSelector { sinks: false }` + `VolumeRow` for `Pipewire.defaultAudioSource`, glyph `0xF036C`, muted glyph `0xF036D`), then an applications section: a `Repeater` over nodes with `audio && isStream && isSink`, each a `VolumeRow` whose label is "`properties["application.name"]` → `name` → `"Unknown app"`" and whose icon is "`properties["application.icon-name"]` → `DesktopEntries.heuristicLookup(name).icon` → music-note glyph" (`0xF075A`) resolved with `Quickshell.iconPath(name, true)`; bind something to `DesktopEntries.applications` on load so lookups resolve (research R7); show "No apps playing" when the repeater is empty and replace the whole tab with "Audio unavailable" while `!Pipewire.ready`
- [X] T014 [US2] In `dot_config/quickshell/modules/sidebar/components/SidebarTabs.qml`, replace the Volume placeholder with `VolumeTab {}` filling the content area
- [X] T015 [US2] Validate US2 per `quickstart.md` §3–4 (reads and external changes): with the Volume tab shown (temporarily set `currentTab` default or ask the user to click; restore afterwards), screenshot and compare with `pactl info`, `pactl list sink-inputs`, `pactl get-sink-volume @DEFAULT_SINK@`, `pactl get-source-volume @DEFAULT_SOURCE@` — devices match the defaults, each app row matches a sink-input, percentages within 1%, Firefox at 120% shows a full slider labelled "120%"; run `pactl set-sink-volume @DEFAULT_SINK@ <current-5%>` and `pactl set-sink-mute @DEFAULT_SINK@ toggle` (toggle back, restore the level) and confirm the tab follows within 1 s; leave drag, wheel, mute clicks and device switching (§5) to the user; ask the user before the PipeWire restart test (§6) since it interrupts audio

**Checkpoint**: User Stories 1 and 2 both work independently

---

## Phase 5: User Story 3 - Notifications tab empty state (Priority: P3)

**Goal**: The Notifications tab shows its eventual empty state

**Independent Test**: open the sidebar (Notifications selected) → centred bell and "No
notifications", nothing interactive

### Implementation for User Story 3

- [X] T016 [P] [US3] Create `dot_config/quickshell/modules/sidebar/components/NotificationsTab.qml`: an `Item` with a centred `ColumnLayout` holding the bell glyph `0xF009A` (`Appearance.fonts.icons`, large, `foreground` at reduced opacity) above the text "No notifications" (`Appearance.fonts.mono`); no `MouseArea`/handlers
- [X] T017 [US3] In `dot_config/quickshell/modules/sidebar/components/SidebarTabs.qml`, replace the Notifications placeholder with `NotificationsTab {}` filling the content area
- [X] T018 [US3] Validate US3: apply, clean log, IPC-open screenshot shows the bell and "No notifications" centred in the tab content

**Checkpoint**: All user stories are independently functional

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final checks across stories

- [X] T019 Check the overflow case (FR-012/SC-006) without spawning ten apps: temporarily lower the panel's available height or raise `volumeRowHeight` in `Appearance.qml`, confirm by screenshot that the Volume tab content scrolls while the tab bar stays visible and the panel stays within the screen, then restore the value
- [X] T020 Run `quickstart.md` end to end once more, compare with the T002 "before" screenshot, confirm `chezmoi status ~/.config/quickshell` is clean after apply and `git diff` touches only the files in plan.md
- [X] T021 Report to the user what only they can verify: tab clicks and the reopen reset; slider drag, wheel ±5%, mute clicks; switching output/input from the picker (and that sound moves); clicks in the tabs never close the sidebar while outside click and Escape still do; the PipeWire-restart recovery if they approve running it

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: no dependencies; T001 is independent of the QML work
- **Foundational (Phase 2)**: after Setup — blocks all user stories
- **US1 (Phase 3)**: after Foundational — provides `SidebarTabs`, which US2 and US3 plug into
- **US2 (Phase 4)** and **US3 (Phase 5)**: after US1; independent of each other
- **Polish (Phase 6)**: after all stories

### User Story Dependencies

- **US1 (P1)**: depends only on Foundational
- **US2 (P1)**: needs `SidebarTabs` from US1 to be visible (its components can be written before)
- **US3 (P3)**: needs `SidebarTabs` from US1; independent of US2

### Within Each User Story

- New component files before the `SidebarTabs.qml`/`Sidebar.qml` edit that uses them
- Validation last

### Parallel Opportunities

- T001 (provisioning script) and T003 (`Appearance.qml`) touch different files
- T010, T011, T012 (US2 components) and T016 (US3) are separate new files and can be written in
  parallel once Phase 2 is done
- Edits to `SidebarTabs.qml` (T006, T007, T014, T017) and `Sidebar.qml` (T004, T008) are
  sequential within each file

---

## Parallel Example: after Phase 2

```text
Task: "T010 [US2] Create VolumeSlider.qml in dot_config/quickshell/modules/sidebar/components/"
Task: "T011 [US2] Create VolumeRow.qml in dot_config/quickshell/modules/sidebar/components/"
Task: "T012 [US2] Create DeviceSelector.qml in dot_config/quickshell/modules/sidebar/components/"
Task: "T016 [US3] Create NotificationsTab.qml in dot_config/quickshell/modules/sidebar/components/"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Phase 1 and Phase 2
2. Phase 3 (US1) — the tab card with switching
3. **Stop and validate**: tabs render and reset to Notifications on open

### Incremental Delivery

1. Setup + Foundation → packages declared, column ready
2. + US1 → tabs (MVP)
3. + US2 → working mixer
4. + US3 → Notifications empty state
5. Polish → overflow and end-to-end check; commits only when the user asks

---

## Notes

- [P] tasks = different files, no dependencies
- After editing several files, `touch` `Sidebar.qml` if the hot reload was missed and re-check
  `qs log`
- Apply only `~/.config/quickshell` so Bitwarden-backed templates are not rendered
- Any `pactl` change made during validation must be restored to the user's previous value
