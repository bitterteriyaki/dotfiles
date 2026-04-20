import QtQuick
import Quickshell
import Quickshell.Io

Text {
  id: root

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }

  text: Qt.formatDateTime(clock.date, "hh:mm")
  color: "#ffffff"

  font.family: "DM Sans"
  font.bold: true
}
