import qs.modules.common

import QtQuick
import QtQuick.Controls

// 0–1 slider in the shell's palette. Emits changeRequested() for drags and
// wheel steps (5% each) instead of writing anything itself.
Slider {
  id: root

  signal changeRequested(real value)

  from: 0
  to: 1

  onMoved: root.changeRequested(root.value)

  background: Rectangle {
    x: root.leftPadding
    y: root.topPadding + (root.availableHeight - height) / 2

    width: root.availableWidth
    height: Appearance.sizes.sliderHeight
    radius: height / 2

    color: Appearance.colors.muted

    Rectangle {
      width: root.visualPosition * parent.width
      height: parent.height
      radius: parent.radius

      color: Appearance.colors.foreground
    }
  }

  handle: Rectangle {
    x: root.leftPadding + root.visualPosition * (root.availableWidth - width)
    y: root.topPadding + (root.availableHeight - height) / 2

    width: Appearance.sizes.sliderHandleSize
    height: width
    radius: width / 2

    // Grows under the pointer and darkens while dragged, like the other
    // clickable controls.
    scale: root.hovered || root.pressed ? 1.2 : 1
    color: root.pressed
      ? Qt.darker(Appearance.colors.foreground, 1.4)
      : Appearance.colors.foreground

    Behavior on scale {
      NumberAnimation {
        duration: Appearance.animation.hoverDuration
        easing.type: Easing.OutCubic
      }
    }

    Behavior on color {
      ColorAnimation {
        duration: Appearance.animation.hoverDuration
        easing.type: Easing.OutCubic
      }
    }
  }

  HoverHandler {
    cursorShape: Qt.PointingHandCursor
  }

  WheelHandler {
    onWheel: event => {
      if (event.angleDelta.y === 0)
        return

      const step = event.angleDelta.y > 0 ? 0.05 : -0.05
      const next = Math.min(root.value, 1) + step

      root.changeRequested(Math.max(0, Math.min(1, next)))
    }
  }
}
