---

description: "Task list for Sidebar Visual Polish"
---

# Tasks: Sidebar Visual Polish

**Input**: Design documents from `/specs/001-sidebar-visual-polish/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Tests**: No automated tests (the repo has no test suite and the spec does not request any).
Per constitution Principle V, each story ends with a **validation** task that applies the change
and exercises the shell following `quickstart.md`. Items that need clicks or a specific time of day
are left for the user and reported as unverified, never claimed.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing
of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1–US4)
- All paths are relative to the chezmoi source root; `QS` below means
  `dot_config/quickshell/modules`.

## Path Conventions

- Quickshell source: `dot_config/quickshell/modules/` (live shell runs from here and hot-reloads)
- Shared tokens: `dot_config/quickshell/modules/common/Appearance.qml`
- Sidebar module: `dot_config/quickshell/modules/sidebar/` and its `components/`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Confirm the starting state before editing

- [X] T001 Confirm the live shell runs from source (`pgrep -af 'qs --path'` shows `dot_config/quickshell`), `chezmoi status ~/.config/quickshell` is clean, and the last `qs log` entry is `Configuration Loaded` with no `ERROR`; record a "before" screenshot with the sidebar open (`grim -o HDMI-A-1`) in the session scratchpad

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Tokens and the panel's content column that every story builds on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T002 [P] Add the new design tokens to `dot_config/quickshell/modules/common/Appearance.qml`: in `sizes` add `sidebarSpacing` (uniform gap between panel elements, e.g. 12), `sidebarBorderWidth: 1`, `cardRadius` (e.g. 10), `cardPadding` (e.g. 12), `avatarSize` (e.g. 48) and `dateTimeReservedHeight` (height of the empty T-14.3 slot, e.g. 56); in `colors` add `border: ColorUtils.transparentize(muted, 0.4)` and `card: background` (palette-only, per research R2/R3)
- [X] T003 Replace the calendar `Loader` inside the `panel` rectangle of `dot_config/quickshell/modules/sidebar/Sidebar.qml` with one `Loader` (`active: window.isBarScreen`, anchored to the panel's left/right/top with `Appearance.sizes.sidebarPadding` margins) whose `sourceComponent` is a `ColumnLayout` with `spacing: Appearance.sizes.sidebarSpacing` containing, in order: an `Item` placeholder for the header (height 0 for now, `Layout.fillWidth`), an empty `Item` with `Layout.preferredHeight: Appearance.sizes.dateTimeReservedHeight` for T-14.3, and `Calendar { Layout.fillWidth: true }`; keep the panel-wide click-absorbing `MouseArea` as the first child of `panel`, and drop the old `sidebarPadding * 4` top margin
- [X] T004 Apply and check the foundation: `chezmoi apply -v ~/.config/quickshell`, `touch` `Sidebar.qml` if the reload was missed, confirm `Configuration Loaded` with no `ERROR`, then open via IPC and screenshot — the calendar shows below the reserved space and nothing else changed

**Checkpoint**: Foundation ready — user story implementation can now begin

---

## Phase 3: User Story 1 - The open panel looks finished (Priority: P1) 🎯 MVP

**Goal**: Shadow and subtle border on the solid panel, same palette and typeface as the bar

**Independent Test**: open the sidebar over a bright window and over a dark terminal; in both
screenshots the panel's shadow and border are visible, corners stay rounded, text is readable

### Implementation for User Story 1

- [X] T005 [US1] In `dot_config/quickshell/modules/sidebar/Sidebar.qml`, un-comment the `StyledRectangularShadow { target: panel }` inside `panelContainer` (before `panel`, so it slides and fades with it) and add `import qs.modules.common.widgets` (currently commented out at the top of the file)
- [X] T006 [US1] In the `panel` rectangle of `dot_config/quickshell/modules/sidebar/Sidebar.qml`, set `border.width: Appearance.sizes.sidebarBorderWidth` and `border.color: Appearance.colors.border`; keep `color: Appearance.colors.secondary` (solid background, FR-002) and `radius: Appearance.sizes.sidebarRadius`
- [ ] T007 [US1] Validate US1 per `quickstart.md` §1–2: apply, clean log, IPC-open screenshots over a bright window and a dark terminal; check the shadow is visible on both (if too faint, tune `elevationMargin`/`colors.shadow` in `Appearance.qml`, not values local to the sidebar) and that the border follows all four rounded corners; confirm by screenshot that `DVI-D-1` shows only the dimming — **partial**: verified over the dark terminal and wallpaper (shadow darkens the surroundings 5–17% after raising `elevationMargin` to 16 and the shadow alpha to 0.6; border and rounded corners confirmed); the bright-window screenshot is left to the user

**Checkpoint**: User Story 1 is fully functional and testable independently

---

## Phase 4: User Story 2 - A personal header greets the user (Priority: P2)

**Goal**: Header with avatar, name, greeting and uptime at the top of the panel

**Independent Test**: open the sidebar with and without `~/.face`; the header shows the image or
`K` in a circle, `kyomi`, the greeting for the current hour, and an uptime within a minute of
`/proc/uptime`

### Implementation for User Story 2

- [X] T008 [P] [US2] Create `dot_config/quickshell/modules/sidebar/components/SidebarHeader.qml` (`pragma ComponentBehavior: Bound`, imports `qs.modules.common`, `qs.modules.sidebar`, `QtQuick`, `QtQuick.Layouts`, `Quickshell`, `Quickshell.Io`, `Quickshell.Widgets`) as a `RowLayout`: a `ClippingRectangle` of `Appearance.sizes.avatarSize` (radius = half) holding an `Image` with `source: "file://" + Quickshell.env("HOME") + "/.face"`, `cache: false`, `fillMode: Image.PreserveAspectCrop`, and a `Text` with the initial shown instead when `status` is `Image.Error` or `Image.Null`; to its right a `ColumnLayout` with the greeting (larger, bold), the display name (`elide: Text.ElideRight`, `Layout.fillWidth`) and the uptime label (dimmer), all in `Appearance.fonts.mono` and `Appearance.colors.foreground`
- [X] T009 [US2] In `SidebarHeader.qml`, derive the identity from data-model.md: a `FileView` on `/etc/passwd`, find the line starting with `Quickshell.env("USER") + ":"`, take field 5 "up to the first `,`"; `displayName` = that value trimmed "if non-empty … else `login`"; `initial` = "first character of `displayName`, upper-cased"
- [X] T010 [US2] In `SidebarHeader.qml`, add the uptime and greeting: a `FileView` on `/proc/uptime`; `label` = "`< 86400` → `up {h}h {m}m`; `≥ 86400` → `up {d}d {h}h` (integer division, no leading zeros)"; greeting by local hour: "5 ≤ h < 12 `Good morning`, 12 ≤ h < 18 `Good afternoon`, 18 ≤ h < 22 `Good evening`, h ≥ 22 or h < 5 `Good night`"; drive both from a `SystemClock { precision: SystemClock.Minutes; enabled: SidebarState.visible }`, reloading `/proc/uptime` on each tick
- [X] T011 [US2] In `SidebarHeader.qml`, add a `Connections { target: SidebarState }` that on `visible` becoming true reloads `/etc/passwd`, reloads `/proc/uptime` and re-reads the avatar (reset `source` to `""` and back) so a changed or removed `~/.face` is picked up on the next opening (FR-006)
- [X] T012 [US2] In `dot_config/quickshell/modules/sidebar/Sidebar.qml`, replace the header placeholder `Item` from T003 with `SidebarHeader { Layout.fillWidth: true }`
- [X] T013 [US2] Validate US2 per `quickstart.md` §3: apply, clean log; IPC-open screenshot shows `K`, `kyomi`, the greeting for the current hour and `up …` matching `cat /proc/uptime` within a minute; copy any image to `~/.face`, close/open → image in a circle; `rm ~/.face`, close/open → `K` again; leave the other greeting ranges for the user (do not change the system clock)

**Checkpoint**: User Stories 1 and 2 both work independently

---

## Phase 5: User Story 3 - Content inside the panel is organised (Priority: P3)

**Goal**: Calendar on its own card, uniform spacing, hover readable on the card

**Independent Test**: in a screenshot, the order is header → reserved space → calendar card;
left/right/top padding and the gaps between elements are equal within 1 px

### Implementation for User Story 3

- [X] T014 [P] [US3] Create `dot_config/quickshell/modules/sidebar/components/SidebarCard.qml`: a `Rectangle` with `color: Appearance.colors.card`, `radius: Appearance.sizes.cardRadius`, a `default property alias content` into an inner `Item` inset by `Appearance.sizes.cardPadding`, and `implicitHeight` = content's implicit height + 2 × `cardPadding`, so it sizes to whatever widget it wraps
- [X] T015 [P] [US3] In `dot_config/quickshell/modules/sidebar/components/Calendar.qml`, change the `ArrowButton` hover colour from `Appearance.colors.muted` to `Appearance.colors.secondary`, the status icons' hover colour (research R3, FR-012)
- [X] T016 [US3] In `dot_config/quickshell/modules/sidebar/Sidebar.qml`, wrap the `Calendar` in `SidebarCard { Layout.fillWidth: true; Calendar { anchors.left/right … } }` so the calendar fills the card's width
- [X] T017 [US3] Validate US3 per `quickstart.md` §4: apply, clean log, IPC-open screenshot; measure with `magick` crops that the panel's left, right and top padding and the two inter-element gaps differ by ≤ 1 px (SC-003); confirm the card is visibly darker than the panel and the calendar grid is not clipped in a six-row month

**Checkpoint**: User Stories 1–3 work independently

---

## Phase 6: User Story 4 - Opening and closing stay smooth (Priority: P4)

**Goal**: Unchanged slide-and-fade with every new element moving with the panel; dimming as today

**Independent Test**: repeated toggles leave nothing behind; `DVI-D-1` only dims

### Implementation for User Story 4

- [X] T018 [US4] Review `dot_config/quickshell/modules/sidebar/Sidebar.qml` and confirm the shadow, border, header and card are all descendants of `panelContainer` (which carries the `Translate` and `opacity: window.showAnim`) and that the scrim colour `#40000000` and the 260 ms animation are untouched; move anything that is not
- [X] T019 [US4] Validate US4 per `quickstart.md` §5: `for i in {1..10}; do Q toggle; sleep 0.1; done; Q close`, then screenshots of both monitors show no leftover shadow, border, header or card (SC-006); with the sidebar open, a `DVI-D-1` screenshot shows only the 25% dimming

**Checkpoint**: All user stories are independently functional

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Final checks across stories

- [X] T020 Run the full `quickstart.md` once more end to end, compare the final screenshot with the "before" one from T001, and confirm `chezmoi status ~/.config/quickshell` is clean after `chezmoi apply`
- [X] T021 Report to the user the items only they can verify: clicks on header/cards/gaps keep the sidebar open; outside click on both monitors and Escape close it; calendar arrows, day selection and arrow hover still work on the card; greetings at 09:00/14:00/19:00/23:00 (SC-004); overall look preferred over "before" (SC-002)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: no dependencies
- **Foundational (Phase 2)**: after Setup — blocks all user stories
- **User Stories (Phases 3–6)**: all depend on Foundational; then, in priority order
  P1 → P2 → P3 → P4, because US1, US2, US3 and US4 all edit `Sidebar.qml`
- **Polish (Phase 7)**: after all user stories

### User Story Dependencies

- **US1 (P1)**: after Foundational; no dependency on other stories
- **US2 (P2)**: after Foundational; independent of US1 (only shares `Sidebar.qml`, a different
  region of it)
- **US3 (P3)**: after Foundational; independent of US1/US2
- **US4 (P4)**: verification of US1–US3 together; run it last

### Within Each User Story

- New component files before the `Sidebar.qml` edit that uses them
- Validation task last in each story

### Parallel Opportunities

- T002 can be written while T001's checks run (different file)
- T008 (`SidebarHeader.qml`) and T014 (`SidebarCard.qml`) and T015 (`Calendar.qml`) touch
  different files and can be written in parallel once Phase 2 is done
- All `Sidebar.qml` edits (T003, T005, T006, T012, T016, T018) are sequential — same file

---

## Parallel Example: after Phase 2

```text
Task: "T008 [US2] Create SidebarHeader.qml in dot_config/quickshell/modules/sidebar/components/"
Task: "T014 [US3] Create SidebarCard.qml in dot_config/quickshell/modules/sidebar/components/"
Task: "T015 [US3] Change ArrowButton hover colour in dot_config/quickshell/modules/sidebar/components/Calendar.qml"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Phase 1 (Setup) and Phase 2 (Foundational)
2. Phase 3 (US1) — shadow and border
3. **Stop and validate**: screenshots over bright and dark windows
4. Show the user before moving on

### Incremental Delivery

1. Foundation → panel content in a column, no visual change
2. + US1 → finished panel chrome (MVP)
3. + US2 → personal header
4. + US3 → calendar on a card, uniform spacing
5. + US4 → motion check across everything
6. Each step leaves the shell loading cleanly; commits only when the user asks

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps each task to its user story for traceability
- The live shell hot-reloads from the source tree; if a reload is missed after editing several
  files, `touch` `Sidebar.qml` and re-check `qs log`
- Apply only the Quickshell target (`chezmoi apply ~/.config/quickshell`) so Bitwarden-backed
  templates are not rendered
