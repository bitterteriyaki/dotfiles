# Data Model: Sidebar Tabs with a Volume Mixer

Nothing is stored by the shell. All audio state is read from and written to PipeWire; the tab
selection is in memory.

## Tab

| Field | Values | Rule |
| ----- | ------ | ---- |
| `currentTab` | `notifications` \| `volume` | set to `notifications` every time the sidebar opens; changed only by clicking a tab |

## AudioDevice (PipeWire node, `audio && !isStream`)

| Field | Source | Rule |
| ----- | ------ | ---- |
| `kind` | `isSink` | `output` if true, `input` otherwise |
| `name` | `description` | elided with "…" on one line |
| `volume` | `audio.volume` (0…∞) | slider shows `min(volume, 1)`; label `round(volume × 100)%` |
| `muted` | `audio.muted` | toggled by the mute control |
| `isDefault` | equals `Pipewire.defaultAudioSink` / `defaultAudioSource` | exactly one per kind is shown as the section's device |

## AppStream (PipeWire node, `audio && isStream && isSink`)

| Field | Source | Rule |
| ----- | ------ | ---- |
| `name` | `properties["application.name"]` → `name` → `"Unknown app"` | first non-empty |
| `icon` | `properties["application.icon-name"]` → `DesktopEntries.heuristicLookup(name).icon` → music-note glyph | first that resolves |
| `volume`, `muted` | as AudioDevice | same slider/label rules |

## Writes

| Action | Effect |
| ------ | ------ |
| drag slider to `v` | `audio.volume = clamp(v, 0, 1)` |
| wheel step up/down | `audio.volume = clamp(min(volume, 1) ± 0.05, 0, 1)` |
| click mute | `audio.muted = !audio.muted` (PipeWire keeps the level) |
| pick device in selector | `Pipewire.preferredDefaultAudioSink` / `preferredDefaultAudioSource = node`; list collapses |

## States of the Volume tab

```text
Pipewire.ready == false          → "Audio unavailable" (whole tab); recovers when ready
ready, no AppStream              → output + input sections, then "No apps playing"
ready, ≥ 1 AppStream             → output + input sections, then one row per stream
device selector                  → collapsed ⇄ expanded (click name / pick device)
```
