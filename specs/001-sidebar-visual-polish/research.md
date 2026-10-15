# Research: Sidebar Visual Polish

All findings below were checked on this machine (Quickshell 0.3.1, Qt 6.11.2) with a throwaway
shell unless stated otherwise.

## R1 — Drop shadow

- **Decision**: re-enable the repo's `StyledRectangularShadow` (Qt Quick Effects'
  `RectangularShadow`) targeting the panel, as the first child of `panelContainer` so it slides
  and fades with the panel.
- **Rationale**: FR-001/FR-013. `RectangularShadow` is an analytic shadow (no offscreen
  rendering), already wrapped with the repo's elevation and shadow colour. It instantiated fine in
  the test shell. The sidebar window covers the whole monitor, so there is room around the panel
  for the blur to draw — unlike the bar, whose window is only slightly taller than the bar (the
  likely reason behind the `TODO: Verify why shadow is not working properly` in `BarContent.qml`).
- **Alternatives considered**: `MultiEffect` with `shadowEnabled` (renders the panel offscreen;
  heavier and blurs content edges); a hand-drawn semi-transparent rectangle (no soft falloff).
- **Risk**: the shadow's visual strength must be confirmed on screen; tune `elevationMargin` /
  `colors.shadow` in `Appearance` if it is too faint over dark windows.

## R2 — Border

- **Decision**: `border.width: Appearance.sizes.sidebarBorderWidth` (1) on the panel rectangle,
  with a new `Appearance.colors.border` = `muted` made partly transparent through the existing
  `ColorUtils.transparentize`.
- **Rationale**: FR-001 ("subtle, close to the panel background") and FR-004 (only palette
  colours): derived from `muted`, no new hue.
- **Alternatives considered**: `foreground` at low opacity (the "visible" option the user did not
  pick).

## R3 — Card background

- **Decision**: cards use `Appearance.colors.background` (`#0D070C`) on the panel's `secondary`
  (`#1E151D`), radius `Appearance.sizes.cardRadius`.
- **Rationale**: FR-011 needs "slightly different" from the panel using only the palette; the
  darker base colour is the only palette colour close to `secondary`.
- **Alternatives considered**: `muted` (`#393F4E`) is much lighter and bluish, which would make
  cards stand out more than the panel itself.
- **Knock-on**: the calendar's hover colour today is `muted`; on a dark card the status icons'
  hover colour (`secondary`) is the one consistent with the bar (FR-012), so the calendar arrows
  switch to `secondary` on hover.

## R4 — Full name and login

- **Decision**: read `/etc/passwd` with `FileView`, find the line starting with
  `${Quickshell.env("USER")}:`, take field 5 (GECOS) up to the first comma; if empty, use the login.
- **Rationale**: FR-007. Reading the file avoids spawning a process. In the test shell
  `/etc/passwd` was readable and the GECOS field for `kyomi` is `""`, so today the header will show
  `kyomi` — the fallback path is the one exercised on this machine.
- **Alternatives considered**: `Process` running `getent passwd` (spawns a process for a static
  value); hardcoding the name (rejected by the user).

## R5 — Avatar

- **Decision**: `ClippingRectangle` (from `Quickshell.Widgets`, radius = half its size) holding an
  `Image` of `file://$HOME/.face` with `cache: false`; when `status` is `Image.Error` or
  `Image.Null`, show a `Text` with the first letter of the displayed name instead. The source is
  re-read every time the sidebar opens.
- **Rationale**: FR-006 including the unreadable-file and "picked up on next opening" cases.
  `ClippingRectangle` instantiated fine in the test shell. `~/.face` does not exist on this machine
  today, so the initial fallback is what will show by default.
- **Alternatives considered**: `MultiEffect` mask (heavier); `OpacityMask` (Qt 5 compatibility
  module, not installed).

## R6 — Uptime

- **Decision**: `FileView` on `/proc/uptime`, reloaded when the sidebar opens and on every minute
  tick while it is open; seconds → `up Xh Ym` below 24 h, `up Xd Yh` from 24 h on.
- **Rationale**: FR-009, SC-005 (≤ 1 minute off). The test shell read `/proc/uptime` correctly.
- **Alternatives considered**: `Process` running `uptime -p` (process per refresh, and its text
  format differs from the spec's).

## R7 — Greeting and the minute tick

- **Decision**: one `SystemClock { precision: SystemClock.Minutes }` in the header drives both the
  greeting (from the hour) and the uptime reload; it is enabled only while the sidebar is open.
- **Rationale**: FR-008/FR-009 and the "only while open" performance goal; `SystemClock` is
  already used by the bar clock and the calendar.

## R8 — Layout and loading

- **Decision**: replace the calendar `Loader` in `Sidebar.qml` with a single `Loader`
  (`active: window.isBarScreen`) whose component is a `ColumnLayout` with uniform `spacing` and
  `sidebarPadding` margins: `SidebarHeader`, an `Item` of fixed height reserved for T-14.3, and a
  `SidebarCard` containing the `Calendar`. The existing panel-wide `MouseArea` keeps absorbing
  clicks on the header and cards (FR-015).
- **Rationale**: FR-010/FR-011 and SC-003; one column with one spacing value makes the gaps
  uniform by construction; loading only on the bar screen keeps `DVI-D-1` free of header and cards.
- **Alternatives considered**: anchors per element (harder to keep gaps equal).
