import QtQuick
import Quickshell
import Quickshell.Io

Text {
  id: root

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }

  text: Qt.formatDateTime(clock.date, "ddd dd MMM  hh:mm")
  color: "#ffffff"
  font.pixelSize: 13
  font.family: "JetBrainsMono Nerd Font"
}
