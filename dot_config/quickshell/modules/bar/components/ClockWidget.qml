import QtQuick
import Quickshell
import Quickshell.Io

Item {
  id: root

  implicitWidth: label.implicitWidth
  implicitHeight: label.implicitHeight

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }

  Text {
    id: label
    anchors.centerIn: parent
    text: clock.now ? Qt.formatDateTime(clock.now, "ddd dd MMM  hh:mm") : ""
    color: "#cdd6f4"
    font.pixelSize: 13
    font.family: "JetBrainsMono Nerd Font"
  }
}
