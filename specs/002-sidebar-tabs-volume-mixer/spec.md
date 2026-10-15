# Feature Specification: Sidebar Tabs with a Volume Mixer

**Feature Branch**: `002-sidebar-tabs-volume-mixer`

**Created**: 2026-10-15

**Status**: Draft

**Input**: User description: "Add two tabs to the sidebar: one for system notifications, which will be implemented in the future, and one with the volume mixer, which will be implemented now."

## Clarifications

### Session 2026-10-15

- Q: Where do the tabs sit in the panel? → A: Below the calendar card, in a card that fills the
  remaining height of the panel.
- Q: How are the tabs labelled? → A: Icon plus text.
- Q: In what order? → A: Notifications first, then Volume.
- Q: Which tab is selected when the sidebar opens? → A: Always Notifications.
- Q: What does the Volume tab list? → A: The default output, the default input (microphone), each
  application currently playing sound, and a way to switch the default output and input device.
- Q: How is the device switched? → A: Clicking the current device's name expands a list of the
  other devices inside the tab; picking one makes it the default and collapses the list.
- Q: In what order are the Volume tab's sections? → A: Output, then microphone, then applications.
- Q: How do applications appear? → A: Icon (when one exists) plus name; "Unknown app" when the
  application has no name.
- Q: Can volume go above 100%? → A: No; sliders go from 0% to 100%. A level above 100% set
  elsewhere is shown as a full slider with its real percentage in the label.
- Q: Does the mouse wheel change volume? → A: Yes, 5% per wheel step over a slider.
- Q: Is the percentage shown? → A: Yes, always, to the right of each slider.
- Q: Which name do devices show? → A: The audio system's own description, elided with "…" when
  too long.
- Q: What happens when there are many applications? → A: The tab fills the remaining space and its
  content scrolls inside it.
- Q: What does the Notifications tab show until notifications exist? → A: The empty state it will
  have for real: an icon and "No notifications", centred.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Switch between the two tabs (Priority: P1)

Below the calendar, the sidebar gains a card with two tabs, Notifications and Volume, each with an
icon and a label. The user switches between them with a click.

**Why this priority**: the tabs are the frame both features live in.

**Independent Test**: open the sidebar, check Notifications is selected, click Volume, then
Notifications again; the highlight and content follow each click.

**Acceptance Scenarios**:

1. **Given** the sidebar is open, **When** the user looks below the calendar, **Then** a card shows
   two tabs, "Notifications" then "Volume", each with an icon, and the card extends to the bottom
   of the panel's content area.
2. **Given** the sidebar opens — for the first time, after a previous visit to Volume, or after a
   shell reload — **When** it appears, **Then** the Notifications tab is selected.
3. **Given** one tab is selected, **When** the user clicks the other, **Then** it becomes selected,
   is visibly highlighted, and its content replaces the previous one.

---

### User Story 2 - Control volume from the sidebar (Priority: P1)

In the Volume tab the user sees and changes, in this order, the default output, the default
microphone, and each application playing sound; they can mute each one and switch which output
and input device is the default.

**Why this priority**: it is the part of this feature that is implemented now and replaces opening
a separate mixer window for everyday volume changes.

**Independent Test**: with music playing in one app, open the Volume tab, move that app's slider,
scroll on it, mute it, and switch the output device; the sound follows and the system mixer shows
the same values.

**Acceptance Scenarios**:

1. **Given** the Volume tab is selected, **When** the user looks at it, **Then** it shows an
   output section (current output device's name, slider, percentage, mute), a microphone section
   (current input device's name, slider, percentage, mute), and an applications section with one
   row per playing application (icon if any, name, slider, percentage, mute).
2. **Given** any slider, **When** the user drags it, **Then** the volume changes live between 0%
   and 100% and the percentage label follows.
3. **Given** the pointer is over a slider, **When** the user turns the mouse wheel one step,
   **Then** the volume changes by 5% in that direction, clamped to 0–100%.
4. **Given** any entry, **When** the user clicks its mute control, **Then** it is muted and shown
   as muted; clicking again unmutes it at the previous level.
5. **Given** the output or microphone section, **When** the user clicks the device name, **Then**
   a list of the other available devices of that kind expands inside the tab; **When** they pick
   one, **Then** it becomes the system's default device, the section shows it, and the list
   collapses.
6. **Given** the volume, mute state or default device is changed elsewhere (another mixer, keyboard
   keys, plugging a device), **When** the Volume tab is open, **Then** it reflects the change
   within one second.
7. **Given** an application starts or stops playing sound, **When** the tab is open, **Then** its
   row appears or disappears without reopening the sidebar.

---

### User Story 3 - Notifications tab empty state (Priority: P3)

The Notifications tab exists now so the layout is final; listing real notifications is a later
feature. Until then it shows the empty state it will eventually use.

**Why this priority**: it only reserves the place for future work.

**Independent Test**: open the sidebar (Notifications is selected) and check the tab's content.

**Acceptance Scenarios**:

1. **Given** the Notifications tab is selected, **When** the user looks at it, **Then** it shows an
   icon and the text "No notifications", centred, and nothing interactive.

---

### Edge Cases

- No application is playing sound: the applications section shows "No apps playing" instead of an
  empty area; output and microphone are still shown.
- An application has no name: its row shows "Unknown app"; with no icon, the row shows a generic
  audio icon.
- Several applications with the same name: each gets its own row.
- Many applications: the tab's content scrolls inside the card; the panel never grows past the
  screen and the tab bar stays visible.
- A level above 100% set elsewhere: the slider is full and the label shows the real value (e.g.
  "130%"); touching the slider or wheel brings it into 0–100%.
- Only one device of a kind is available: clicking its name expands a list that shows only it, or
  nothing happens; no error.
- The default device disappears (e.g. USB microphone unplugged): the section switches to the new
  default chosen by the system.
- The audio server is not running or restarts: the Volume tab shows "Audio unavailable" and
  recovers on its own when the server is back, without a shell restart.
- A very long device or application name: shown on one line, elided with "…".
- The other monitor (`DVI-D-1`) never shows the tabs; it only shows the dimming.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Below the calendar card, the sidebar MUST show a card with two tabs, "Notifications"
  then "Volume", each with an icon and a text label; the card MUST fill the remaining height of the
  panel's content area.
- **FR-002**: Clicking a tab MUST select it, highlight it, and show only its content.
- **FR-003**: The Notifications tab MUST be the selected tab every time the sidebar opens.
- **FR-004**: The Volume tab MUST show, in order: the default output, the default input, and one
  row per application currently playing sound.
- **FR-005**: Every entry MUST show its name, a slider for its current level, its percentage to the
  right of the slider, and a mute control; device names MUST be the audio system's description and
  application rows MUST show the application's icon when one exists.
- **FR-006**: Sliders MUST range from 0% to 100% and change the volume live while dragged; levels
  above 100% set elsewhere MUST be shown as a full slider with the real percentage.
- **FR-007**: One mouse-wheel step over a slider MUST change that volume by 5%, clamped to 0–100%.
- **FR-008**: Toggling mute MUST mute and unmute the entry, restoring the previous level.
- **FR-009**: Clicking the output or input device name MUST expand a list of the available devices
  of that kind; selecting one MUST make it the system default and collapse the list.
- **FR-010**: Changes to volume, mute or default device made outside the sidebar MUST appear in the
  open tab within one second, and application rows MUST appear and disappear as applications start
  and stop playing.
- **FR-011**: When no application is playing, the applications section MUST show "No apps
  playing"; when audio is unavailable, the tab MUST show "Audio unavailable" and recover
  automatically.
- **FR-012**: When the content does not fit, it MUST scroll inside the tab card, keeping the tab
  bar visible and the panel within the screen.
- **FR-013**: The Notifications tab MUST show a centred icon and "No notifications", with nothing
  interactive.
- **FR-014**: The tabs MUST follow the sidebar's existing look (card style, spacing, palette, hover
  states consistent with the bar's status icons) and elide long names with "…".
- **FR-015**: Clicks inside the tabs MUST NOT close the sidebar, and every existing sidebar
  behaviour (open/close, outside click on either monitor, Escape, external command, header,
  calendar) MUST keep working.

### Key Entities

- **Audio device**: an output or an input known to the audio system; has a description, a volume
  level, a muted flag, and whether it is the current default.
- **Application stream**: sound coming from one running application; has a name, an optional icon,
  a volume level and a muted flag.
- **Tab**: Notifications or Volume; exactly one is selected, and Notifications on every opening.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: From a closed sidebar, the user changes an application's volume in at most three
  actions (open, select Volume, drag or scroll).
- **SC-002**: A volume, mute or default-device change made outside the sidebar shows up in the open
  tab within one second in 10 out of 10 tries.
- **SC-003**: An application starting or stopping sound appears in or disappears from the list
  within one second.
- **SC-004**: The level set from the sidebar matches the level reported by the system mixer to
  within 1%.
- **SC-005**: Switching the output device from the sidebar moves the currently playing sound to the
  chosen device.
- **SC-006**: With 10 applications playing, the panel stays within the screen and every row is
  reachable by scrolling.
- **SC-007**: Every existing sidebar behaviour still works after the change.

## Assumptions

- The audio stack is the one already running on this machine (PipeWire with its PulseAudio layer
  and session manager); no new audio service is introduced.
- Receiving, listing and dismissing notifications is a later feature; this one only adds the tab
  and its empty state.
- Keyboard media keys for volume are out of scope (they belong to the Hyprland keybinds task).
- Per-application output routing (sending one app to a different device) is out of scope; only
  the default devices are switched.
- The header and the calendar from earlier features stay as they are.
