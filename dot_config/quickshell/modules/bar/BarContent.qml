import qs.modules.common
import qs.modules.common.widgets
import qs.modules.bar.components

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

Item {
  id: root

  Rectangle {
    id: background

    anchors.fill: parent
    color: Appearance.colors.background
  }

  StyledRectangularShadow {
    target: background
  }

  Item {
    id: content

    anchors.fill: parent
    anchors.leftMargin: Appearance.sizes.barPaddingHorizontal
    anchors.rightMargin: Appearance.sizes.barPaddingHorizontal

    Workspaces {
      id: workspaces

      anchors.centerIn: parent
    }

    RowLayout {
      id: right

      anchors.left: workspaces.right
      anchors.right: parent.right
      anchors.top: parent.top
      anchors.bottom: parent.bottom

      layoutDirection: Qt.RightToLeft

      ClockWidget {}
    }
  }
}
