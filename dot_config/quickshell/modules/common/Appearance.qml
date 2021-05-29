pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.common.functions

import QtQuick
import Quickshell

Singleton {
  id: root

  property QtObject sizes: QtObject {
    property int barHeight: 40
    property real eleveationMargin: 10
    property int barPaddingHorizontal: 16
  }

  property string font: "JetBrainsMono Nerd Font"

  property QtObject colors: QtObject {
    property color foreground: "#DFE1DE"
    property color background: "#0D070C"

    property color secondary: "#1E151D"
    property color muted: "#393F4E"

    property color shadow: ColorUtils.transparentize("#000000", 0.7)
  }
}
