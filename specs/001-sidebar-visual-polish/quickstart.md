# Quickstart: validating Sidebar Visual Polish

## Prerequisites

- The shell is running from the source tree: `pgrep -af 'qs --path'` shows
  `qs --path /home/kyomi/.local/share/chezmoi/dot_config/quickshell`.
- Helpers (zsh):

  ```sh
  Q() { qs --path ~/.local/share/chezmoi/dot_config/quickshell ipc call sidebar "$@"; }
  P=$(pgrep -f 'qs --path' | head -1)
  ```

## 1. Apply and load

```sh
chezmoi diff --no-pager ~/.config/quickshell        # only the files listed in plan.md
chezmoi apply -v ~/.config/quickshell
qs log --pid $P | tail -3                            # last line: Configuration Loaded
qs log --pid $P | grep -iE 'warn|error'              # nothing after the last reload
```

If the reload was missed, `touch` the changed `Sidebar.qml` and check the log again.

## 2. Panel chrome (US1)

```sh
grim -o HDMI-A-1 /tmp/before.png   # sidebar closed, a bright window behind
Q open; sleep 0.7; grim -o HDMI-A-1 /tmp/open-bright.png; Q close
```

Repeat with a dark terminal behind. Expected: shadow visible around the panel, a subtle border on
all four rounded edges, solid background, readable text in both screenshots (SC-001).

## 3. Header (US2)

- With no `~/.face` (today's state) and an empty full name: header shows a circle with `K`,
  `kyomi`, the greeting for the current hour and `up …` matching `cat /proc/uptime` within a
  minute (SC-005).
- Avatar: `cp <some image> ~/.face; Q close; Q open` → the image appears in a circle; then
  `rm ~/.face` and reopen → back to `K`.
- Greeting ranges (SC-004): check the current hour against data-model.md; the other ranges are
  checked by the user at those times of day (do not change the system clock).

## 4. Layout (US3)

On the open-panel screenshot: header, empty reserved space, calendar card, top to bottom; equal
left/right/top padding and equal gaps within 1 px (SC-003, measure with `magick … -crop`).

## 5. Motion and behaviour (US4, SC-006, SC-007)

- `for i in {1..10}; do Q toggle; sleep 0.1; done; Q close` — then a screenshot shows no
  leftover shadow, border or card.
- `DVI-D-1` screenshot while open: dimmed only, no panel, header or cards.
- **(user)** clicking the header, a card, between cards → sidebar stays open; outside click on
  both monitors and Escape → closes; calendar arrows and day selection still work; hover on the
  arrows is visible on the card.
