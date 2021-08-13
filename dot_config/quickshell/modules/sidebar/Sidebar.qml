pragma ComponentBehavior: Bound

import qs.modules.common
import qs.modules.common.widgets
import qs.modules.sidebar

import QtQuick
import Quickshell
import Quickshell.Wayland

Scope {
  id: root

  Variants {
    model: {
      const screens = Config.options.bar.screens

      if (!screens || screens.length === 0)
        return screens

      return Quickshell.screens.filter(screen => screens.includes(screen.name))
    }

    PanelWindow {
      id: window

      required property var modelData
      screen: modelData

      property real showAnim: SidebarState.visible ? 1 : 0

      Behavior on showAnim {
        NumberAnimation {
          duration: 260
          easing.type: Easing.OutCubic
        }
      }

      visible: showAnim > 0.001

      WlrLayershell.namespace: "quickshell:sidebar"
      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

      exclusionMode: ExclusionMode.Ignore
      color: "transparent"

      anchors {
        top: true
        bottom: true
        left: true
        right: true
      }

      Connections {
        target: SidebarState

        function onVisibleChanged() {
          if (SidebarState.visible)
            keys.forceActiveFocus()
        }
      }

      Item {
        id: keys

        anchors.fill: parent
        focus: true

        Keys.onEscapePressed: SidebarState.close()
      }

      Rectangle {
        id: scrim

        anchors.fill: parent
        color: "#99000000"
        opacity: window.showAnim

        MouseArea {
          anchors.fill: parent
          onClicked: SidebarState.close()
        }
      }

      Item {
        id: panelContainer

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right

        anchors.topMargin: Appearance.sizes.barHeight + Appearance.sizes.sidebarMargin
        anchors.bottomMargin: Appearance.sizes.sidebarMargin
        anchors.rightMargin: Appearance.sizes.sidebarMargin

        width: Appearance.sizes.sidebarWidth
        opacity: window.showAnim

        transform: Translate {
          x: (1 - window.showAnim) * (panelContainer.width + Appearance.sizes.sidebarMargin)
        }

        StyledRectangularShadow {
          target: panel
        }

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
