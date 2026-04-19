import qs.modules.common

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import "components"

Rectangle {
  id: root

  color: Appearance.colors.colLayer0

  RowLayout {
    anchors {
      fill: parent
      leftMargin: 12
      rightMargin: 12
    }
    spacing: 0

    // Left section: clock
    ClockWidget {
      Layout.alignment: Qt.AlignVCenter
    }

    Item { Layout.fillWidth: true }

    // Center section: workspaces
    WorkspaceWidget {
      Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
    }

    Item { Layout.fillWidth: true }

    // Right section: tray + system info
    RowLayout {
      Layout.alignment: Qt.AlignVCenter
      spacing: 8

      SystemInfoWidget {}
      TrayWidget {}
    }
  }
}
