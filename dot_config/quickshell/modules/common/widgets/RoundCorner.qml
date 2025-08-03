/*
 * Copyright (C) 2025-present end-4
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick
import QtQuick.Shapes

Item {
    id: root

    enum CornerPosition { TopLeft, TopRight, BottomLeft, BottomRight }

    property var corner: RoundCorner.CornerPosition.TopLeft

    property int implicitSize: 25
    property color color: "#FF0000"

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
