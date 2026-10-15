import qs.modules.common

import QtQuick
import QtQuick.Layouts

// Empty state; listing notifications is a later feature.
Item {
  ColumnLayout {
    anchors.centerIn: parent
    spacing: 8

    Text {
      Layout.alignment: Qt.AlignHCenter

      text: String.fromCodePoint(0xF009A) // nf-md-bell
      color: Appearance.colors.foreground
      opacity: 0.4

      font.family: Appearance.fonts.icons
      font.pixelSize: 36
    }

    Text {
      Layout.alignment: Qt.AlignHCenter

      text: "No notifications"
      color: Appearance.colors.foreground
      opacity: 0.6

      font.family: Appearance.fonts.mono
      font.pixelSize: 13
    }
  }
}
