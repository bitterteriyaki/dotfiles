pragma ComponentBehavior: Bound

import qs.modules.common
import qs.modules.common.widgets
import qs.modules.wallpapers.components

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
  id: root

  IpcHandler {
    target: "wallpapers"

    function open(): void { WallpaperSelectorState.open() }
    function close(): void { WallpaperSelectorState.close() }
    function toggle(): void { WallpaperSelectorState.toggle() }
    function random(): void { WallpaperSelectorState.random() }
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: window

      required property var modelData
      screen: modelData

      readonly property bool isBarScreen: {
        const screens = Config.options.bar.screens
        return !!screens && screens.includes(modelData.name)
      }

      WlrLayershell.namespace: "quickshell:wallpapers"
      WlrLayershell.layer: WlrLayer.Overlay

      // Never Exclusive, for the same reason as the sidebar: an exclusive
      // layer surface takes every pointer event, so a click on the other
      // monitor would never reach its click catcher. The focus grab below
      // provides the keyboard focus.
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

      exclusionMode: ExclusionMode.Ignore
      color: "transparent"

      visible: WallpaperSelectorState.visible

      anchors.top: true
      anchors.bottom: true
      anchors.left: true
      anchors.right: true

      HyprlandFocusGrab {
        active: WallpaperSelectorState.visible && window.isBarScreen
        windows: [window]

        onCleared: WallpaperSelectorState.close()
      }

      // Transparent: a click anywhere outside the panel, on any monitor,
      // closes the selector without dimming the screen.
      MouseArea {
        anchors.fill: parent
        onClicked: WallpaperSelectorState.close()
      }

      Item {
        id: panelContainer

        visible: window.isBarScreen

        // As wide as the row of thumbnails (or the empty message), up to
        // the maximum; past it the row scrolls.
        width: {
          const sizes = Appearance.sizes
          const count = WallpaperSelectorState.entries.length

          const content = count > 0
            ? count * sizes.wallpaperThumbnailWidth + (count - 1) * sizes.wallpaperThumbnailSpacing
            : emptyMessage.implicitWidth

          return Math.min(sizes.wallpaperSelectorMaxWidth, content + 2 * sizes.wallpaperSelectorPadding)
        }
        height: {
          const sizes = Appearance.sizes

          return sizes.wallpaperThumbnailHeight + 2 * sizes.wallpaperSelectorPadding
        }

        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        anchors.topMargin: {
          const sizes = Appearance.sizes

          return sizes.barHeight + sizes.sidebarMargin
        }

        StyledRectangularShadow {
          target: panel
        }

        Rectangle {
          id: panel

          anchors.fill: parent

          radius: Appearance.sizes.sidebarRadius
          color: Appearance.colors.secondary

          border.width: Appearance.sizes.sidebarBorderWidth
          border.color: Appearance.colors.border

          // Swallows clicks that miss a thumbnail, so they never reach the
          // click catcher underneath and close the selector.
          MouseArea {
            anchors.fill: parent
          }

          // Only the bar's monitor builds the row, so thumbnails are decoded
          // (and cached) once.
          Text {
            id: emptyMessage

            anchors.centerIn: parent

            visible: WallpaperSelectorState.entries.length === 0
            text: "No wallpapers found in ~/.local/share/wallpapers"
            color: Appearance.colors.foreground
            opacity: 0.6

            font.family: Appearance.fonts.mono
            font.pixelSize: 13
          }

          Loader {
            active: window.isBarScreen && WallpaperSelectorState.visible
            focus: true

            anchors.fill: parent
            anchors.margins: Appearance.sizes.wallpaperSelectorPadding

            sourceComponent: Item {
              id: content

              focus: true

              function apply(path: string): void {
                WallpaperState.apply(path)
                WallpaperSelectorState.close()
              }

              function applyHighlighted(): void {
                const entry = WallpaperSelectorState.entries[list.currentIndex]

                if (entry)
                  content.apply(entry.path)
              }

              Keys.onEscapePressed: WallpaperSelectorState.close()

              Keys.onLeftPressed: list.currentIndex = Math.max(0, list.currentIndex - 1)
              Keys.onRightPressed: list.currentIndex = Math.min(list.count - 1, list.currentIndex + 1)

              Keys.onReturnPressed: content.applyHighlighted()
              Keys.onEnterPressed: content.applyHighlighted()

              ListView {
                id: list

                anchors.fill: parent

                orientation: ListView.Horizontal
                clip: true
                spacing: Appearance.sizes.wallpaperThumbnailSpacing

                highlightFollowsCurrentItem: true
                highlightMoveDuration: Appearance.animation.hoverDuration

                model: WallpaperSelectorState.entries

                delegate: WallpaperThumbnail {
                  required property var modelData
                  required property int index

                  entry: modelData
                  current: modelData.path === WallpaperState.current
                  highlighted: index === list.currentIndex

                  onActivated: content.apply(modelData.path)
                }

                // A mouse wheel only scrolls vertically; move the row
                // sideways instead. Touchpads already scroll horizontally.
                WheelHandler {
                  acceptedDevices: PointerDevice.Mouse

                  onWheel: event => {
                    const delta = event.angleDelta.y || event.angleDelta.x
                    const max = list.originX + list.contentWidth - list.width

                    list.contentX = Math.max(list.originX, Math.min(max, list.contentX - delta))
                  }
                }

                // Start on the applied wallpaper every time the list is
                // rebuilt (on each open).
                Connections {
                  target: WallpaperSelectorState

                  function onRefreshed(): void {
                    const entries = WallpaperSelectorState.entries
                    const index = entries.findIndex(e => e.path === WallpaperState.current)

                    list.currentIndex = Math.max(0, index)
                    list.positionViewAtIndex(list.currentIndex, ListView.Center)
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
