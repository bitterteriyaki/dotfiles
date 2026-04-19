import qs.modules.common
import qs.modules.common.widgets

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

Scope {
  id: root

  Variants {
    model: {
      const screens = Config.options.bar.screens

      if (!screens || screens.length === 0)
        return screens

      return Quickshell.screens.filter(screen => screens.includes(screen.name))
    }

    PanelWindow {
      id: bar

      required property var modelData
      screen: modelData

      exclusionMode: ExclusionMode.Ignore
      exclusiveZone: Appearance.sizes.barHeight

      WlrLayershell.namespace: "quickshell:bar"
      implicitHeight: Appearance.sizes.barHeight + 50 + 25

      anchors {
        top: true
        left: true
        right: true
      }

      mask: Region { item: content }
      color: "transparent"

      BarContent {
        id: content

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        height: Appearance.sizes.barHeight
      }

      Item {
        id: decorators

        anchors.left: parent.left
        anchors.right: parent.right

        y: Appearance.sizes.barHeight
        implicitHeight: 25

        RoundCorner {
          corner: RoundCorner.CornerPosition.TopLeft

          anchors.top: parent.top
          anchors.bottom: parent.bottom
          anchors.left: parent.left
        }

        RoundCorner {
          corner: RoundCorner.CornerPosition.TopRight

          anchors.top: parent.top
          anchors.bottom: parent.bottom
          anchors.right: parent.right
        }
      }
    }
  }
}
