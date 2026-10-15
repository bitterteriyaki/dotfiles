# Quickstart: validating Sidebar Tabs with a Volume Mixer

## Prerequisites

- The shell runs from the source tree (`pgrep -af 'qs --path'`).
- Something playing sound (e.g. Spotify) so at least one application row exists.
- Helpers (zsh):

  ```sh
  Q() { qs --path ~/.local/share/chezmoi/dot_config/quickshell ipc call sidebar "$@"; }
  P=$(pgrep -f 'qs --path' | head -1)
  ```

## 1. Apply and load

```sh
chezmoi diff --no-pager ~/.config/quickshell
chezmoi apply -v ~/.config/quickshell
qs log --pid $P | tail -3          # Configuration Loaded, no ERROR
```

The package-list change is applied with the next full `chezmoi apply` (it re-runs the script;
`yay --needed` installs nothing here). Check `grep -n pipewire .chezmoiscripts/*install-packages*`.

## 2. Tabs (US1)

- `Q open` + screenshot: below the calendar, a card with "Notifications" and "Volume" (icon + text)
  reaching the bottom of the panel; Notifications selected, showing a centred bell and
  "No notifications" (US3).
- **(user)** click Volume → selected and shown; close and reopen → Notifications again.

## 3. Mixer reads (US2)

Compare the Volume tab screenshot with:

```sh
pactl info | grep -E 'Default (Sink|Source)'
pactl list sink-inputs | grep -E 'application.name|Volume:|Mute:'
pactl get-sink-volume @DEFAULT_SINK@; pactl get-source-volume @DEFAULT_SOURCE@
```

Expected: section devices match the defaults; each app row matches a sink-input; percentages
match within 1% (SC-004); Firefox at 120% shows a full slider labelled "120%".

## 4. External changes (SC-002, SC-003)

With the Volume tab open (user selects it, or check right after a click):

```sh
pactl set-sink-volume @DEFAULT_SINK@ 50%      # slider and label move within 1 s
pactl set-sink-mute @DEFAULT_SINK@ toggle     # mute state flips; toggle back
```

Start/stop playback in an app → its row appears/disappears within 1 s.

## 5. Writes (user)

- Drag a slider, scroll on it (±5%), click mute → `pactl` shows the same values.
- Click the output name → device list → pick HDMI → `pactl info` shows the new default and sound
  moves; switch back to the Ryzen analog output.

## 6. Robustness

- `systemctl --user restart pipewire pipewire-pulse wireplumber` with the tab open → "Audio
  unavailable" briefly, then the mixer recovers without restarting the shell.
- `DVI-D-1` screenshot while open → only dimming.
- **(user)** clicks anywhere in the tabs never close the sidebar; outside click and Escape still do.
