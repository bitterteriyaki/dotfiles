import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Item {
  id: root

  implicitWidth: row.implicitWidth
  implicitHeight: 36

  RowLayout {
    id: row
    anchors.centerIn: parent
    spacing: 6

    Repeater {
      model: Hyprland.workspaces.values

      delegate: Item {
        required property HyprlandWorkspace modelData

        readonly property bool active: modelData.id === Hyprland.focusedMonitor?.activeWorkspace?.id

        width: active ? 8 : 6
        height: active ? 8 : 6

        Rectangle {
          anchors.centerIn: parent
          width: parent.width
          height: parent.height
          radius: width / 2
          color: parent.active ? "#cba6f7" : "#45475a"
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
