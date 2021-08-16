pragma ComponentBehavior: Bound

import qs.modules.common
import qs.modules.sidebar
// import qs.modules.common.widgets

import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
  id: root

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

      property real showAnim: SidebarState.visible ? 1 : 0

      Behavior on showAnim {
        NumberAnimation {
          duration: 260
          easing.type: Easing.OutCubic
        }
      }

      WlrLayershell.namespace: "quickshell:sidebar"
      WlrLayershell.layer: WlrLayer.Overlay

      WlrLayershell.keyboardFocus: visible && window.isBarScreen
        ? WlrKeyboardFocus.Exclusive
        : WlrKeyboardFocus.None

      exclusionMode: ExclusionMode.Ignore
      color: "transparent"

      visible: showAnim

      anchors.top: true
      anchors.bottom: true
      anchors.left: true
      anchors.right: true

      HyprlandFocusGrab {
        active: SidebarState.visible && window.isBarScreen
        windows: [window]

        onCleared: SidebarState.close()
      }

      Item {
        id: keys

        focus: true
        visible: window.isBarScreen

        anchors.fill: parent

        Keys.onEscapePressed: SidebarState.close()
      }

      Rectangle {
        id: scrim

        color: "#40000000"
        opacity: window.showAnim

        anchors.fill: parent

        MouseArea {
          anchors.fill: parent
          onClicked: SidebarState.close()
        }
      }

      Item {
        id: panelContainer

        width: Appearance.sizes.sidebarWidth
        visible: window.isBarScreen
        opacity: window.showAnim

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right

        anchors.topMargin: {
          const sizes = Appearance.sizes

          return sizes.barHeight + sizes.sidebarMargin
        }

        anchors.bottomMargin: Appearance.sizes.sidebarMargin
        anchors.rightMargin: Appearance.sizes.sidebarMargin

        transform: Translate {
          x: {
            const hidden = panelContainer.width + Appearance.sizes.sidebarMargin
            const offset = 1 - window.showAnim

            return offset * hidden
          }
        }

        // StyledRectangularShadow {
        //   target: panel
        // }

        Rectangle {
          id: panel

          anchors.fill: parent

          radius: Appearance.sizes.sidebarRadius
          color: Appearance.colors.secondary

          Text {
            anchors.centerIn: parent

            text: "Sidebar"
            color: Appearance.colors.foreground

            font.family: Appearance.fonts.mono
            font.pixelSize: 14
          }
        }
      }
    }
  }
}
