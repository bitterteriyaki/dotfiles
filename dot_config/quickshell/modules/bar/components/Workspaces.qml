import qs.modules.common

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Item {
  id: root

  implicitWidth: row.implicitWidth + 28
  implicitHeight: 28

  Behavior on implicitWidth {
    NumberAnimation {
      duration: 200
      easing.type: Easing.OutCubic
    }
  }

  RowLayout {
    id: row

    anchors.centerIn: parent
    spacing: 18

    Repeater {
      model: Hyprland.workspaces.values

      delegate: Item {
        required property HyprlandWorkspace modelData

        readonly property bool active: modelData.id === Hyprland.focusedMonitor?.activeWorkspace?.id

        Layout.alignment: Qt.AlignVCenter
        Layout.preferredWidth: 8
        Layout.preferredHeight: 8

        Rectangle {
          anchors.centerIn: parent

          width: parent.active ? 8 : 6
          height: parent.active ? 8 : 6

          radius: width / 2
          color: parent.active ? Appearance.colors.foreground : Appearance.colors.muted

          Behavior on width {
            NumberAnimation {
              duration: 200
              easing.type: Easing.OutCubic
            }
          }

          Behavior on height {
            NumberAnimation {
              duration: 200
              easing.type: Easing.OutCubic
            }
          }

          Behavior on color {
            ColorAnimation {
              duration: 200
              easing.type: Easing.OutCubic
            }
          }
        }
      }
    }
  }
}
