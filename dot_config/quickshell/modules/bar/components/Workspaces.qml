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
      duration: 150
      easing.type: Easing.OutCubic
    }
  }

  Rectangle {
    anchors.fill: parent
    color: Appearance.colors.colLayer1
    radius: height / 2
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
        Layout.preferredWidth: active ? 8 : 6
        Layout.preferredHeight: active ? 8 : 6

        Rectangle {
          anchors.centerIn: parent
          width: parent.width
          height: parent.height
          radius: width / 2
          color: parent.active ? "#e9243d" : Appearance.colors.grayLayer0
        }

        MouseArea {
          anchors.fill: parent
          onClicked: Hyprland.dispatch("workspace " + parent.modelData.id)
          cursorShape: Qt.PointingHandCursor
        }
      }
    }
  }
}
