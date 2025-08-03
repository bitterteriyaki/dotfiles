/* Copyright (C) 2025-present end-4
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

import qs.modules.common
import qs.modules.common.widgets

import QtQuick
import Quickshell
import Quickshell.Wayland

Scope {
    id: root

    property bool showBarBackground: Config.options.bar.showBackground

    Variants {
        model: {
            const screens = Quickshell.screens
            const list = Config.options.bar.screenList

            if (!list || list.length === 0)
                return screens

            return screens.filter(screen => list.includes(screen.name))
        }

        LazyLoader {
            id: barLoader
            active: true

            required property ShellScreen modelData

            component: PanelWindow {
                id: barRoot
                screen: barLoader.modelData

                exclusionMode: ExclusionMode.Ignore
                exclusiveZone: Appearance.sizes.baseBarHeight + (Config.options.bar.cornerStyle === 1 ? Appearance.sizes.hyprlandGapsOut : 0)

                WlrLayershell.namespace: "quickshell:bar"
                implicitHeight: Appearance.sizes.barHeight + Appearance.rounding.screenRounding

                mask: Region { item: barContent }
                color: "transparent"

                anchors.top: !Config.options.bar.bottom
                anchors.bottom: Config.options.bar.bottom
                anchors.left: true
                anchors.right: true

                BarContent {
                    id: barContent
                    implicitHeight: Appearance.sizes.barHeight

                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: undefined

                    states: State {
                        name: "bottom"
                        when: Config.options.bar.bottom

                        AnchorChanges {
                            target: barContent

                            anchors.right: parent.right
                            anchors.left: parent.left
                            anchors.top: undefined
                            anchors.bottom: parent.bottom
                        }
                    }
                }

                Loader {
                    id: roundDecorators

                    anchors.left: parent.left
                    anchors.right: parent.right

                    y: Appearance.sizes.barHeight
                    width: parent.width
                    height: Appearance.rounding.screenRounding

                    active: showBarBackground && Config.options.bar.cornerStyle === 0 // Hug

                    sourceComponent: Item {
                        implicitHeight: Appearance.rounding.screenRounding

                        RoundCorner {
                            id: leftCorner

                            implicitSize: Appearance.rounding.screenRounding
                            color: showBarBackground ? Appearance.colors.colLayer0 : "transparent"
                            corner: RoundCorner.CornerPosition.TopLeft

                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left

                            states: State {
                                name: "bottom"
                                when: Config.options.bar.bottom

                                PropertyChanges { leftCorner.corner: RoundCorner.CornerPosition.BottomLeft }
                            }
                        }

                        RoundCorner {
                            id: rightCorner

                            implicitSize: Appearance.rounding.screenRounding
                            color: showBarBackground ? Appearance.colors.colLayer0 : "transparent"
                            corner: RoundCorner.CornerPosition.TopRight

                            anchors.right: parent.right
                            anchors.top: !Config.options.bar.bottom ? parent.top : undefined
                            anchors.bottom: Config.options.bar.bottom ? parent.bottom : undefined

                            states: State {
                                name: "bottom"
                                when: Config.options.bar.bottom

                                PropertyChanges { rightCorner.corner: RoundCorner.CornerPosition.BottomRight }
                            }
                        }
                    }
                }
            }
        }
    }
}
