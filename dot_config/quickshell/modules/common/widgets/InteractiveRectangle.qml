import qs.modules.common
import qs.modules.common.functions

import QtQuick

// Clickable surface: fades to hoverColor under the pointer and darkens while
// pressed. Use it as the background of anything the user can click.
Rectangle {
  id: root

  signal clicked()

  property color hoverColor: Appearance.colors.secondary
  property color pressedColor: Qt.darker(root.hoverColor, 1.4)

  // Resting colour. Defaults to a fully transparent hoverColor rather than
  // plain "transparent", so the fade does not pass through black.
  property color baseColor: ColorUtils.transparentize(root.hoverColor, 1)

  readonly property bool hovered: hover.hovered
  readonly property bool pressed: tap.pressed

  color: {
    if (!root.enabled)
      return root.baseColor

    if (tap.pressed)
      return root.pressedColor

    return hover.hovered ? root.hoverColor : root.baseColor
  }

  Behavior on color {
    ColorAnimation {
      duration: Appearance.animation.hoverDuration
      easing.type: Easing.OutCubic
    }
  }

  HoverHandler {
    id: hover

    enabled: root.enabled
    cursorShape: Qt.PointingHandCursor
  }

  TapHandler {
    id: tap

    enabled: root.enabled
    onTapped: root.clicked()
  }
}
