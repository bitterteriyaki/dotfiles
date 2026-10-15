import qs.modules.common

import QtQuick

// Rounded container for one sidebar widget; sizes itself to its content.
Rectangle {
  id: root

  default property alias content: inner.data

  implicitHeight: inner.childrenRect.height + 2 * Appearance.sizes.cardPadding

  radius: Appearance.sizes.cardRadius
  color: Appearance.colors.card

  Item {
    id: inner

    anchors.fill: parent
    anchors.margins: Appearance.sizes.cardPadding
  }
}
