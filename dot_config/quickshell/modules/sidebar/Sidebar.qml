pragma ComponentBehavior: Bound

import qs.modules.common
import qs.modules.sidebar
import qs.modules.sidebar.components
// import qs.modules.common.widgets

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
  id: root

  IpcHandler {
    target: "sidebar"

    function toggle(): void { SidebarState.toggle() }
    function open(): void { SidebarState.open() }
    function close(): void { SidebarState.close() }
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

      property real showAnim: SidebarState.visible ? 1 : 0

      Behavior on showAnim {
        NumberAnimation {
          duration: 260

          // Decelerate on the way in, accelerate on the way out. The
          // branches read inverted on purpose: the binding is evaluated
          // against the state the panel is leaving, not the one it is
          // entering.
          easing.type: SidebarState.visible
            ? Easing.InCubic
            : Easing.OutCubic
        }
      }

      WlrLayershell.namespace: "quickshell:sidebar"
      WlrLayershell.layer: WlrLayer.Overlay

      // Never Exclusive: an exclusive layer surface makes Hyprland route
      // every pointer event to it, so a click on another monitor never
      // reaches that monitor's scrim and the sidebar stays open. The
      // HyprlandFocusGrab below already provides the keyboard focus Escape
      // needs.
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

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

          // Swallows clicks that miss the content, so they never reach the
          // scrim underneath and close the sidebar.
          MouseArea {
            anchors.fill: parent
          }

          Loader {
            active: window.isBarScreen

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top

            anchors.margins: Appearance.sizes.sidebarPadding

            // Room left above the calendar for the date and time (T-14.3).
            anchors.topMargin: Appearance.sizes.sidebarPadding * 4

            sourceComponent: Calendar {}
          }
        }
      }
    }
  }
}
