import qs.modules.common
import qs.modules.bar.components
// import qs.modules.common.widgets

import QtQuick
import QtQuick.Layouts

Item {
  id: root

  Rectangle {
    id: background

    anchors.fill: parent
    color: Appearance.colors.background
  }

  // TODO: Verify why shadow is not working properly.
  // StyledRectangularShadow {
  //   target: background
  // }

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

      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter

      spacing: 8

      // Clock {}
      StatusIcons {}
    }
  }
}
