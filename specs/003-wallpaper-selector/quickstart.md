# Quickstart: validating the Wallpaper Selector

## Prerequisites

- The shell runs from the source tree (`pgrep -x qs`).
- Helpers (zsh):

  ```sh
  W() { qs --path ~/.local/share/chezmoi/dot_config/quickshell ipc call wallpapers "$@"; }
  P=$(pgrep -x qs)
  ```

- Test images (removed at the end): two extra images, one in a subfolder, e.g. 1920×1080 crops of
  `default.png` made with any tool already on the system, saved as
  `~/.local/share/wallpapers/test-a.png` and `~/.local/share/wallpapers/sub/test-b.jpg`.

## 1. Apply and load

```sh
chezmoi diff --no-pager ~/.config/quickshell
chezmoi apply -v ~/.config/quickshell
qs log --pid $P | tail -3               # Configuration Loaded, no ERROR
qs --path … ipc show | grep -A5 wallpapers   # matches contracts/ipc.md
```

## 2. Open and list (US1)

- `W open`, wait 1 s, screenshot `HDMI-A-1`: panel centred below the bar, a horizontal row with
  `default.png`, `sub/test-b.jpg`, `test-a.png` in path order, no names, the current one
  highlighted (SC-002).
- Screenshot `DVI-D-1`: nothing drawn.
- `W open` again: no change. `W close`: panel gone, wallpaper unchanged.
- The sidebar: `qs … ipc call sidebar open` while the selector is open → selector closes; `W open`
  while the sidebar is open → sidebar closes (FR-011).

## 3. Thumbnail cache (FR-010)

- After the first open, `ls ~/.cache/quickshell/wallpaper-thumbnails/` lists one PNG per image.
- Close and reopen: thumbnails appear immediately.

## 4. Apply (US1, US2)

- **(user)** click `test-a.png` → background changes instantly on both monitors, panel closes.
  Without clicking: `W random` applies an image other than the current one.
- Screenshots of both monitors: the image continues across the seam (SC-003).
- `cat ~/.local/state/quickshell/wallpaper.json` → the new path.
- Restart the shell (user, or with approval): the background is the same image (SC-004).

## 5. Fallbacks (US2)

- Point `wallpaper.json` at a missing file (or delete the applied test image) and restart/reload →
  `default.png` is shown.
- Run `W random` ten times and record the path after each: no immediate repeat (SC-005).

## 6. Keyboard and closing (user)

- Left/Right move the highlight and scroll; Enter applies; Escape and a click on either monitor
  close without changing the wallpaper; the mouse wheel scrolls the row sideways.

## 7. Cleanup

Remove the test images and their thumbnails, restore `wallpaper.json` to `default.png` (or the
user's choice), and confirm the background.
