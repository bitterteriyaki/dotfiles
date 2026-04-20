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
  readonly property string wallpaper: `${Directories.wallpapers}/default.png`

  readonly property int minX: {
    let v = 0

    for (const m of monitors)
      v = Math.min(v, m.x)

    return v
  }

  readonly property int minY: {
    let v = 0

    for (const m of monitors)
      v = Math.min(v, m.y)

    return v
  }

  readonly property int totalW: {
    let v = 0

    for (const m of monitors)
      v = Math.max(v, m.x + m.width)

    return v - minX
  }

  readonly property int totalH: {
    let v = 0

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

      StyledImage {
        source: root.wallpaper
        fillMode: Image.Stretch

        width: root.totalW
        height: root.totalH

        x: -(background.hyprMonitor ? background.hyprMonitor.x - root.minX : 0)
        y: -(background.hyprMonitor ? background.hyprMonitor.y - root.minY : 0)
      }
    }
  }
}
