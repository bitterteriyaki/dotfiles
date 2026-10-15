# Data Model: Sidebar Visual Polish

The feature stores nothing. These are the values the header derives from the system each time the
sidebar opens (and every minute while it stays open).

## UserIdentity

| Field | Source | Rule |
| ----- | ------ | ---- |
| `login` | `$USER` | always present (`kyomi`) |
| `fullName` | field 5 of the `login`'s line in `/etc/passwd`, up to the first `,` | may be empty |
| `displayName` | — | `fullName` if non-empty after trimming, else `login`; shown on one line, elided with `…` |
| `initial` | — | first character of `displayName`, upper-cased |
| `avatarPath` | `$HOME/.face` | re-read on every opening |
| `avatarState` | image loader status | `ready` → show image cropped to a circle; `missing`/`error` → show `initial` in a circle of the same size |

## Uptime

| Field | Source | Rule |
| ----- | ------ | ---- |
| `seconds` | first number in `/proc/uptime` | refreshed on open and every minute while open |
| `label` | — | `< 86400` → `up {h}h {m}m`; `≥ 86400` → `up {d}d {h}h` (integer division, no leading zeros) |

## Greeting

| Local hour (h) | Text |
| -------------- | ---- |
| 5 ≤ h < 12 | `Good morning` |
| 12 ≤ h < 18 | `Good afternoon` |
| 18 ≤ h < 22 | `Good evening` |
| h ≥ 22 or h < 5 | `Good night` |

Re-evaluated on every minute tick while the panel is open.

## State transitions

```text
sidebar closed ──open──▶ reload avatar, /etc/passwd, /proc/uptime; enable minute tick
sidebar open   ──tick──▶ reload /proc/uptime; recompute greeting
sidebar open   ─close──▶ disable minute tick (values kept until next open)
```
