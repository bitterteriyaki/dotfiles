pragma ComponentBehavior: Bound

import qs.modules.common
import qs.modules.common.widgets

import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

Variants {
  id: root
  model: Quickshell.screens

  readonly property var monitors: Hyprland.monitors.values

  readonly property int minX: {
    let v = Infinity

    for (const m of monitors)
      v = Math.min(v, m.x)

    return v
  }

  readonly property int minY: {
    let v = Infinity

    for (const m of monitors)
      v = Math.min(v, m.y)

    return v
  }

  readonly property int totalW: {
    let v = -Infinity

    for (const m of monitors)
      v = Math.max(v, m.x + m.width)

    return v - minX
  }

  readonly property int totalH: {
    let v = -Infinity

    for (const m of monitors)
      v = Math.max(v, m.y + m.height)

    return v - minY
  }

  PanelWindow {
    id: background

    required property var modelData
    screen: modelData

    readonly property var hyprMonitor: {
      for (const m of root.monitors)
        if (m.name === modelData.name) return m

      return null
    }

    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.layer: WlrLayer.Bottom
    WlrLayershell.namespace: "quickshell:background"

    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true

    Item {
      anchors.fill: parent
      clip: true

      // Last resort, shown when neither the saved wallpaper nor
      // default.png can be loaded.
      Rectangle {
        anchors.fill: parent
        color: Appearance.colors.background
      }

      StyledImage {
        id: image

        // Set when the saved wallpaper fails to load, until another one is
        // applied.
        property bool failed: false

        source: image.failed ? Directories.defaultWallpaper : WallpaperState.current
        fillMode: Image.PreserveAspectCrop

        // StyledImage hides itself while loading; the wallpaper must keep
        // the previous image on screen until the new one is decoded, so the
        // switch happens in a single frame.
        opacity: 1

        onStatusChanged: {
          if (image.status === Image.Error)
            image.failed = true
        }

        Connections {
          target: WallpaperState

          function onCurrentChanged(): void {
            image.failed = false
          }
        }

        width: root.totalW
        height: root.totalH
        smooth: true

        x: -(background.hyprMonitor ? background.hyprMonitor.x - root.minX : 0)
        y: -(background.hyprMonitor ? background.hyprMonitor.y - root.minY : 0)
      }
    }
  }
}
