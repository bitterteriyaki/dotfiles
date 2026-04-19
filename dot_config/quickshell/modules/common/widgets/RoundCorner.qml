import qs.modules.common

import QtQuick
import QtQuick.Shapes

Item {
  id: root

  enum CornerPosition { TopLeft, TopRight, BottomLeft, BottomRight }

  property var corner: RoundCorner.CornerPosition.TopLeft

  property int implicitSize: 25
  property color color: Appearance.colors.colLayer0

  implicitWidth: implicitSize
  implicitHeight: implicitSize

  Shape {
    anchors.fill: parent

    layer.enabled: true
    layer.smooth: true
    preferredRendererType: Shape.CurveRenderer

    ShapePath {
      id: shapePath

      strokeWidth: 0
      fillColor: root.color

      startX: switch (root.corner) {
        case RoundCorner.CornerPosition.TopLeft: return 0
        case RoundCorner.CornerPosition.TopRight: return root.implicitSize
        case RoundCorner.CornerPosition.BottomLeft: return 0
        case RoundCorner.CornerPosition.BottomRight: return root.implicitSize
      }

      startY: switch (root.corner) {
        case RoundCorner.CornerPosition.TopLeft: return 0
        case RoundCorner.CornerPosition.TopRight: return 0
        case RoundCorner.CornerPosition.BottomLeft: return root.implicitSize
        case RoundCorner.CornerPosition.BottomRight: return root.implicitSize
      }

      PathAngleArc {
        moveToStart: false

        centerX: root.implicitSize - shapePath.startX
        centerY: root.implicitSize - shapePath.startY
        radiusX: root.implicitSize
        radiusY: root.implicitSize

        startAngle: switch (root.corner) {
          case RoundCorner.CornerPosition.TopLeft: return 180
          case RoundCorner.CornerPosition.TopRight: return -90
          case RoundCorner.CornerPosition.BottomLeft: return 90
          case RoundCorner.CornerPosition.BottomRight: return 0
        }

        sweepAngle: 90
      }

      PathLine {
        x: shapePath.startX
        y: shapePath.startY
      }
    }
  }
}
