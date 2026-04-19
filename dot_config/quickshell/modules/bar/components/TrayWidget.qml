import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

Item {
  id: root

  implicitWidth: row.implicitWidth
  implicitHeight: 36

  RowLayout {
    id: row
    anchors.centerIn: parent
    spacing: 4

    Repeater {
      model: SystemTray.items

      delegate: Item {
        required property SystemTrayItem modelData

        width: 20
        height: 20

        Image {
          anchors.fill: parent
          source: parent.modelData.icon
          fillMode: Image.PreserveAspectFit
          smooth: true
        }

        MouseArea {
          anchors.fill: parent
          acceptedButtons: Qt.LeftButton | Qt.RightButton
          onClicked: mouse => {
            if (mouse.button === Qt.LeftButton)
              parent.modelData.activate()
            else
              parent.modelData.showContextMenu(-1, -1)
          }
          cursorShape: Qt.PointingHandCursor
        }
      }
    }
  }
}
