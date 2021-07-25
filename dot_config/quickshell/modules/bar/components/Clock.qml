import qs.modules.common

import QtQuick
import QtQuick.Layouts
import Quickshell

RowLayout {
  id: root

  spacing: 8

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  Rectangle {
    implicitWidth: dateLabel.implicitWidth + 24
    implicitHeight: dateLabel.implicitHeight + 8

    radius: 8
    color: Appearance.colors.secondary

    Text {
      id: dateLabel

      anchors.centerIn: parent

      text: Qt.formatDateTime(clock.date, "dddd, dd/MM")
      color: Appearance.colors.foreground

      font.family: Appearance.font
      font.pixelSize: 12
    }
  }

  Rectangle {
    implicitWidth: timeLabel.implicitWidth + 24
    implicitHeight: timeLabel.implicitHeight + 8

    radius: 8
    color: Appearance.colors.secondary

    Text {
      id: timeLabel

      anchors.centerIn: parent

      text: Qt.formatDateTime(clock.date, "hh:mm AP")
      color: Appearance.colors.foreground

      font.family: Appearance.font
      font.pixelSize: 12
    }
  }
}
