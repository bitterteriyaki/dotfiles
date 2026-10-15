# Research: Sidebar Tabs with a Volume Mixer

All findings were checked on this machine (Quickshell 0.3.1, Qt 6.11, PipeWire 1.6.9) with
throwaway shells.

## R1 — Audio backend

- **Decision**: Quickshell's built-in `Quickshell.Services.Pipewire`.
- **Rationale**: it talks to PipeWire directly and pushes changes (FR-010, SC-002 ≤ 1 s) with no
  polling or child processes. In the test shell `Pipewire.ready` was `true`,
  `defaultAudioSink`/`defaultAudioSource` matched `pactl info` (Ryzen analog / HyperX QuadCast S),
  and every device and stream exposed `audio.volume` and `audio.muted`.
- **Alternatives considered**: running `pactl`/`wpctl` via `Process` (polling or parsing
  `pactl subscribe`, slower and fragile); the PulseAudio layer is still needed by applications,
  not by the shell.

## R2 — Which nodes go where

- **Decision**: devices = `node.audio && !node.isStream`, split by `isSink` (outputs) / not
  (inputs); application rows = `node.audio && node.isStream && node.isSink`
  (type `AudioOutStream`). Defaults are `Pipewire.defaultAudioSink` / `defaultAudioSource`.
- **Rationale**: FR-004. Observed types: sinks 54/55/57 `AudioSink`, sources 56/58 `AudioSource`,
  Spotify 79 and Firefox 84 `AudioOutStream`. Recording streams (`AudioInStream`) are not
  "applications playing sound" and are excluded.

## R3 — Binding nodes

- **Decision**: one `PwObjectTracker` whose `objects` are the default sink, default source,
  all devices and all output streams, active only while `SidebarState.visible`.
- **Rationale**: PipeWire nodes only expose live `audio` values while tracked; tracking only
  while the panel is open satisfies the "only while open" performance goal.

## R4 — Volume range and levels above 100%

- **Decision**: slider `value = Math.min(node.audio.volume, 1)`, range 0–1; the label shows
  `Math.round(node.audio.volume * 100) + "%"`; dragging or wheel writes `node.audio.volume` clamped
  to `[0, 1]`; wheel step 0.05.
- **Rationale**: FR-006/FR-007. The test caught a real case: Firefox's stream is at **1.199
  (120%)** right now, so the "above 100%" edge case is live on this machine.

## R5 — Switching the default device

- **Decision**: assign `Pipewire.preferredDefaultAudioSink` / `preferredDefaultAudioSource` to
  the chosen node.
- **Rationale**: FR-009; these properties are writable in the installed API and set the
  configured default that WirePlumber honours, which moves playing streams that follow the
  default (SC-005). Verified later with `pactl info` in quickstart.
- **Alternatives considered**: `pactl set-default-sink` via `Process` (works, but adds a process
  for something the service already does).

## R6 — Names

- **Decision**: devices show `node.description` (e.g. "Ryzen HD Audio Controller Analog
  Stereo"); apps show `properties["application.name"]`, falling back to `node.name`, then
  "Unknown app". Long names elide with "…".
- **Rationale**: spec decisions on names. Observed: devices have descriptions; streams have an
  empty `description` but `application.name` ("Spotify", "Firefox").

## R7 — Application icons

- **Decision**: `properties["application.icon-name"]` if present, else
  `DesktopEntries.heuristicLookup(appName)?.icon`, resolved with `Quickshell.iconPath(name,
  true)`; when nothing resolves, a Nerd Font audio glyph.
- **Rationale**: neither stream sets `application.icon-name` here. `heuristicLookup` mapped
  "Spotify" → `spotify-launcher` and "Firefox" → `firefox`, both present in `hicolor` (qt6ct sets
  no icon theme, so `hicolor` is what resolves). `DesktopEntries` loads lazily: lookups return
  `null` until something binds to `DesktopEntries.applications`, so the tab binds to it on load.

## R8 — Interface glyphs

- **Decision**: Nerd Font Material glyphs through `Appearance.fonts.icons`, as `StatusIcons`
  does: bell `0xF009A` (Notifications tab and empty state), volume-high `0xF057E` (Volume tab,
  output), volume-off `0xF0581` (muted), microphone `0xF036C`, microphone-off `0xF036D`,
  chevron down/up `0xF0140`/`0xF0143` (device picker), music-note `0xF075A` (app fallback).
- **Rationale**: same font and idiom as the bar; no icon theme dependency for UI chrome.

## R9 — Tab state and layout

- **Decision**: `SidebarTabs` holds `currentTab` and resets it to Notifications in a
  `Connections` on `SidebarState` when the sidebar opens (FR-003). The content column in
  `Sidebar.qml` is anchored top **and bottom** so `SidebarTabs` (`Layout.fillHeight`) takes the
  remaining height; `VolumeTab` puts its sections in a `ScrollView`/`Flickable` so overflow
  scrolls while the tab bar stays fixed (FR-012).
- **Rationale**: matches the spec decisions and keeps the panel within the screen.

## R10 — Provisioning

- **Decision**: add `pipewire`, `pipewire-pulse`, `pipewire-alsa` and `wireplumber` to
  `.chezmoiscripts/run_onchange_before_install-packages.sh` under "Drivers".
- **Rationale**: constitution III. All four are "Explicitly installed" here but absent from the
  list (only `pavucontrol` is), so a fresh machine provisioned by chezmoi alone would lack the
  stack the mixer depends on. Their user units (`pipewire.socket`, `pipewire-pulse.socket`,
  `wireplumber.service`) are enabled by the packages themselves; no service script is needed.
- **Note**: changing the script makes the next full `chezmoi apply` re-run it; `yay --needed`
  makes that a no-op here.
