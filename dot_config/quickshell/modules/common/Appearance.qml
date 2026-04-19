pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

Singleton {
  id: root

  property QtObject sizes: QtObject {
    property int barHeight: 40
  }

  property QtObject colors: QtObject {
    property color colLayer0: "#0D070C"
  }
}
