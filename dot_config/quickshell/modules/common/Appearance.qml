pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.common.functions

import QtQuick
import Quickshell

Singleton {
  id: root

  property QtObject animationCurves: QtObject {
    property list<real> dynamicIsland: [0.34, 1.56, 0.64, 1]
  }

  property QtObject sizes: QtObject {
    property int barHeight: 40
    property real eleveationMargin: 10
  }

  property QtObject colors: QtObject {
    property color colLayer0: "#0D070C"
    property color colLayer1: "#1E151D"

    property color grayLayer0: "#393F4E"

    property color colShadow: ColorUtils.transparentize("#000000", 0.7)
  }
}
