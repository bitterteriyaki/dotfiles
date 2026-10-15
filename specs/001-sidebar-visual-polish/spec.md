# Feature Specification: Sidebar Visual Polish

**Feature Branch**: `001-sidebar-visual-polish`

**Created**: 2026-10-15

**Status**: Draft

**Input**: User description: "Make the sidebar look nice."

## Clarifications

### Session 2026-10-15

- Q: How should the panel stand apart from the windows behind it? → A: Both a drop shadow and a
  subtle 1 px border in a colour close to the panel background.
- Q: What should the panel's background be? → A: Solid, as today.
- Q: Keep the current palette or add an accent colour? → A: Keep the current palette.
- Q: How are widgets grouped inside the panel? → A: Each widget sits on its own card.
- Q: What sits at the top of the panel? → A: A header, placed above the space reserved for the
  date and time of T-14.3, which in turn sits above the calendar card.
- Q: What does the header show? → A: Avatar, name, a time-of-day greeting and the system uptime.
- Q: Where does the avatar come from? → A: The user's `~/.face` image, falling back to the name's
  initial in a circle when it does not exist.
- Q: Which name is shown? → A: The account's full name, falling back to the login name when the
  full name is empty.
- Q: What language and time ranges does the greeting use? → A: English, with four ranges — "Good
  morning" 05:00–11:59, "Good afternoon" 12:00–17:59, "Good evening" 18:00–21:59, "Good night"
  22:00–04:59.
- Q: How is uptime shown? → A: "up 3h 25m" (days and hours once above 24 hours, e.g. "up 2d 4h"),
  refreshed every minute while the panel is open.
- Q: Does the open/close motion change? → A: No, it keeps today's slide-in from the right with a
  fade.
- Q: What happens outside the panel while it is open? → A: Dimmed, as today, on both monitors.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - The open panel looks finished (Priority: P1)

When the user opens the sidebar from the bar's status icons, the panel reads as a deliberate,
finished surface rather than a flat box: a shadow lifts it off the windows behind it, a subtle
border traces its rounded edges, and it uses the same palette and typeface as the bar.

**Why this priority**: the panel frames every widget that lives in it, and the user sees it every
time the sidebar opens.

**Independent Test**: open the sidebar over a busy window and over the bare wallpaper, take a
screenshot of each, and compare them with the current look.

**Acceptance Scenarios**:

1. **Given** the sidebar is closed and a window fills the bar's monitor, **When** the user opens
   the sidebar, **Then** the panel casts a visible shadow onto the window behind it and has a
   subtle 1 px border along all four rounded corners, with no artefact at its edges.
2. **Given** the sidebar is open, **When** the user looks at it over a bright window and over a
   dark terminal, **Then** the panel's solid background keeps all of its text readable in both
   cases.
3. **Given** the sidebar is open, **When** the user looks at the bar and the panel together,
   **Then** both use the same colour palette, corner style and typeface, with no colour that does
   not already exist in the shell's palette.

---

### User Story 2 - A personal header greets the user (Priority: P2)

At the top of the panel, a header shows the user's avatar, their name, a greeting that matches the
time of day and how long the system has been up.

**Why this priority**: it is the most visible new element and gives the panel its identity, but
the panel is already usable without it.

**Independent Test**: open the sidebar at different times of day (or with the system clock in
different ranges) and with and without `~/.face`, and check the header's content.

**Acceptance Scenarios**:

1. **Given** `~/.face` exists, **When** the sidebar opens, **Then** the header shows that image
   cropped to a circle.
2. **Given** `~/.face` does not exist, **When** the sidebar opens, **Then** the header shows the
   first letter of the displayed name inside a circle of the same size, with no broken-image
   placeholder.
3. **Given** the account has a full name set, **When** the sidebar opens, **Then** the header shows
   that full name; **Given** it is empty, **Then** the header shows the login name.
4. **Given** the local time is 09:00, 14:00, 19:00 and 23:00, **When** the sidebar opens, **Then**
   the greeting reads "Good morning", "Good afternoon", "Good evening" and "Good night"
   respectively.
5. **Given** the system has been up for 3 hours 25 minutes, **When** the sidebar opens, **Then**
   the header shows "up 3h 25m"; **Given** 2 days 4 hours, **Then** it shows "up 2d 4h".
6. **Given** the sidebar stays open across a minute boundary or a greeting boundary, **When** the
   minute changes, **Then** the uptime and, where it applies, the greeting update without
   reopening the panel.

---

### User Story 3 - Content inside the panel is organised (Priority: P3)

The panel's contents follow one layout: the header at the top, then the space reserved for the
date and time of T-14.3, then each widget on its own card, all with even inner spacing.

**Why this priority**: setting the layout once lets the next widgets (T-14.3 to T-14.8) slot in
without restyling.

**Independent Test**: with the calendar inside, check in a screenshot the order of the elements,
the evenness of the spacing and that the calendar sits on its own card.

**Acceptance Scenarios**:

1. **Given** the sidebar is open, **When** the user looks at it from top to bottom, **Then** they
   see the header, the reserved space for the date and time, and the calendar card, in that order.
2. **Given** the sidebar is open, **When** the user inspects the panel, **Then** the inner margin
   between the panel's edge and its content is equal on every side that has content, and the gap
   between consecutive elements is the same throughout.
3. **Given** the calendar is shown, **When** the user looks at it, **Then** it sits on a card whose
   background is slightly different from the panel's, with rounded corners.
4. **Given** a hoverable control (calendar arrows, days), **When** the pointer is over it,
   **Then** it shows a hover state consistent with the bar's status icons and visible against the
   card.

---

### User Story 4 - Opening and closing stay smooth (Priority: P4)

The panel keeps its current slide-in from the right with a fade, and every new element (shadow,
border, header, cards) moves with it.

**Why this priority**: the motion already works; this story only guarantees the new look does not
break it.

**Independent Test**: open and close the sidebar repeatedly, by click and by the external command,
watching the panel and both monitors.

**Acceptance Scenarios**:

1. **Given** the sidebar is closed, **When** it opens, **Then** the panel slides in from the right
   while fading in, exactly as today, with its shadow, border, header and cards arriving together.
2. **Given** the sidebar opens, **When** the user looks outside the panel on either monitor,
   **Then** that area is dimmed as today.
3. **Given** the sidebar is open, **When** it closes, **Then** no part of the new styling remains
   on screen after the panel has left.

---

### Edge Cases

- The sidebar opens over a fullscreen window, over an empty workspace showing the wallpaper, and
  over a very bright window: the shadow and border keep the panel distinguishable, and its text
  stays readable in all three.
- `~/.face` exists but is not a readable image: the header falls back to the initial, as if the
  file were missing.
- `~/.face` is replaced while the shell runs: the new image appears the next time the sidebar
  opens.
- The full name is very long: it is shortened with an ellipsis on one line, without pushing other
  header content out or widening the panel.
- Uptime above 99 days: still shown as days and hours (e.g. "up 120d 3h"), without overflowing.
- The greeting boundary is crossed while the panel is open: the greeting changes within a minute.
- The sidebar is opened and closed rapidly: no shadow, border or card is left behind or drawn
  without the panel.
- The shell reloads while the sidebar is open: it comes back closed, with no leftover styling on
  either monitor.
- The other monitor (`DVI-D-1`) never shows the panel, its shadow or the header; it only shows the
  dimming.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The panel MUST cast a drop shadow onto what is behind it and MUST have a subtle 1 px
  border, in a colour close to the panel's background, following its rounded corners; both appear
  on the bar's monitor only.
- **FR-002**: The panel's background MUST remain solid, and all text in the panel MUST remain
  readable over light and dark content behind it.
- **FR-003**: The panel MUST keep four rounded corners and its current floating position and size
  (gap from the bar and from the right and bottom edges, current width).
- **FR-004**: The panel MUST use only the shell's existing colour palette and the bar's typeface
  and corner style; colours, radii and spacing MUST be shared with the rest of the shell rather
  than defined only for the sidebar.
- **FR-005**: The top of the panel MUST show a header with, in this order of prominence, the
  avatar, the name, the greeting and the uptime.
- **FR-006**: The avatar MUST be the user's `~/.face` image cropped to a circle, falling back to
  the displayed name's first letter in a circle of the same size when the file is missing or
  unreadable; a changed `~/.face` MUST be picked up on the next opening.
- **FR-007**: The name MUST be the account's full name, falling back to the login name when the
  full name is empty, and MUST be truncated with an ellipsis instead of wrapping or widening the
  panel.
- **FR-008**: The greeting MUST be in English and follow four ranges of local time: "Good morning"
  05:00–11:59, "Good afternoon" 12:00–17:59, "Good evening" 18:00–21:59, "Good night"
  22:00–04:59.
- **FR-009**: The uptime MUST read "up Xh Ym" below 24 hours and "up Xd Yh" from 24 hours on, and
  MUST refresh at least once a minute while the panel is open, together with the greeting.
- **FR-010**: Below the header, the panel MUST keep the space reserved for the date and time of
  T-14.3, followed by the widgets.
- **FR-011**: Each widget MUST sit on its own card with rounded corners and a background slightly
  different from the panel's; content MUST have equal inner padding on every side that has
  content, and the gap between consecutive elements MUST be uniform.
- **FR-012**: Hoverable controls inside the panel MUST show a hover state consistent with the bar's
  status icons and visible against the card they sit on.
- **FR-013**: The panel MUST keep today's slide-in from the right with a fade; the shadow, border,
  header and cards MUST move with the panel and MUST NOT be visible while it is closed.
- **FR-014**: While the sidebar is open, the area outside the panel on both monitors MUST be
  dimmed as today, and return to normal when it closes.
- **FR-015**: Closing on an outside click on either monitor, Escape, the external open/close/toggle
  command and the calendar's behaviour MUST work exactly as they do today, and clicks on the header
  or on a card MUST NOT close the sidebar.

### Key Entities

- **User identity**: the account's full name, login name and avatar image (`~/.face`) shown in the
  header; read from the system, never stored by the shell.
- **System uptime**: how long the machine has been running since boot, shown in the header.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In screenshots of the open sidebar over a bright window and over a dark terminal, the
  panel's outline is identifiable at a glance in both (judged by the user).
- **SC-002**: Comparing before and after screenshots, the user prefers the new look and points out
  nothing that looks unfinished (misaligned edges, uneven spacing, mismatched colours).
- **SC-003**: Inner padding measured in a screenshot differs by no more than 1 px between the
  panel's left, right and top edges, and gaps between consecutive elements differ by no more than
  1 px.
- **SC-004**: At four sample times (09:00, 14:00, 19:00, 23:00) the greeting matches FR-008 in
  every case.
- **SC-005**: The uptime shown differs from the system's actual uptime by no more than 1 minute.
- **SC-006**: Across 10 rapid open/close cycles, no styling element is ever visible without the
  panel.
- **SC-007**: Every existing sidebar behaviour (open, close on outside click on either monitor,
  Escape, external command, calendar navigation and selection) still works after the change.

## Assumptions

- "The sidebar" is the existing sidebar opened from the bar's status icons; the bar, the launcher
  and the wallpaper are not restyled by this feature, and the bar does not gain a shadow or border.
- A wallpaper-driven colour scheme is a separate task (T-25) and out of scope.
- The panel's position and width stay as they are; this feature changes the panel's appearance and
  adds the header, not the layout of the rest of the screen.
- Creating or managing `~/.face` (e.g. versioning it in the dotfiles) is out of scope; the header
  only reads it if present.
- No widget other than the header is added; the calendar keeps its behaviour and only moves onto a
  card.
- The date and time widget itself is T-14.3; this feature only keeps its reserved space between the
  header and the cards.
