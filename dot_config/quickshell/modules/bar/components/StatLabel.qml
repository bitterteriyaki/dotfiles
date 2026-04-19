import QtQuick
import QtQuick.Layouts

Item {
  id: root

  property string icon: ""
  property string value: "0%"

  implicitWidth: row.implicitWidth
  implicitHeight: row.implicitHeight

  RowLayout {
    id: row
    anchors.centerIn: parent
    spacing: 4

    Text {
      text: root.icon
      color: "#cba6f7"
      font.pixelSize: 13
      font.family: "JetBrainsMono Nerd Font"
    }

    Text {
      text: root.value
      color: "#cdd6f4"
      font.pixelSize: 12
      font.family: "JetBrainsMono Nerd Font"
    }
  }
}
