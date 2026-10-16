# Contract: `wallpapers` IPC target

Called as:

```sh
qs --path ~/.local/share/chezmoi/dot_config/quickshell ipc call wallpapers <function>
```

| Function | Arguments | Effect | Idempotence / errors |
| -------- | --------- | ------ | -------------------- |
| `open` | — | Opens the selector on the bar's monitor (closing the sidebar if open), with the list refreshed and the current wallpaper highlighted | Opening an open selector does nothing; never errors |
| `close` | — | Closes the selector without changing the wallpaper | Closing a closed selector does nothing |
| `toggle` | — | `open` if closed, `close` if open | — |
| `random` | — | Applies a random image different from the current one and persists it; does not open or close the panel | With fewer than two images, does nothing; never errors |

`qs ... ipc show` lists the target as:

```text
target wallpapers
  function open(): void
  function close(): void
  function toggle(): void
  function random(): void
```

No global shortcut is registered by this feature; a Hyprland binding can call the commands above
later (keybinds task).
