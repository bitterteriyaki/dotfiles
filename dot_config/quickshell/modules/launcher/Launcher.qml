import qs.modules.common

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets

Scope {
  id: root

  property bool launcherVisible: false
  property string searchText: ""
  property var filtered: []
  property int selectedIndex: 0

  function refresh(): void {
    const query = root.searchText.toLowerCase()
    const apps = DesktopEntries.applications.values.filter(entry => !entry.noDisplay)

    root.filtered = query.length === 0
      ? apps
      : apps.filter(entry => entry.name.toLowerCase().includes(query))

    root.selectedIndex = 0
  }

  function launch(entry): void {
    if (!entry)
      return

    entry.execute()
    root.close()
  }

  function open(): void {
    root.searchText = ""
    refresh()
    root.launcherVisible = true
  }

  function close() {
    root.launcherVisible = false
  }

  IpcHandler {
    target: "launcher"

    function toggle(): void {
      if (root.launcherVisible)
        root.close()
      else
        root.open()
    }

    function open(): void { root.open() }
    function close(): void { root.close() }
  }

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

      property real showAnim: root.launcherVisible ? 1 : 0

      Behavior on showAnim {
        NumberAnimation {
          duration: 150
          easing.type: Easing.OutCubic
        }
      }

      visible: showAnim > 0.001

      WlrLayershell.namespace: "quickshell:launcher"
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
        target: root

        function onLauncherVisibleChanged() {
          if (root.launcherVisible) {
            searchInput.text = ""
            searchInput.forceActiveFocus()
          }
        }
      }

      Rectangle {
        id: scrim

        anchors.fill: parent
        color: "#99000000"
        opacity: window.showAnim

        MouseArea {
          anchors.fill: parent
          onClicked: root.close()
        }
      }

      Rectangle {
        id: box

        anchors.centerIn: parent

        width: 520
        height: Math.min(560, header.implicitHeight + Math.max(resultsList.contentHeight, 1) + 40)

        radius: 14
        color: Appearance.colors.secondary

        opacity: window.showAnim
        scale: 0.9 + 0.1 * window.showAnim

        Behavior on height {
          NumberAnimation {
            duration: 150
            easing.type: Easing.OutCubic
          }
        }

        ColumnLayout {
          id: header

          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.margins: 16
          spacing: 12

          RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Text {
              text: ""
              color: Appearance.colors.foreground
              font.pixelSize: 16
              font.family: Appearance.font
            }

            TextInput {
              id: searchInput

              Layout.fillWidth: true
              font.pixelSize: 16
              font.family: Appearance.font
              color: Appearance.colors.foreground
              clip: true

              text: root.searchText

              onTextEdited: {
                root.searchText = text
                root.refresh()
              }

              Keys.onEscapePressed: root.close()

              Keys.onReturnPressed: root.launch(root.filtered[root.selectedIndex])

              Keys.onDownPressed: {
                if (root.filtered.length > 0)
                  root.selectedIndex = Math.min(root.selectedIndex + 1, root.filtered.length - 1)
              }

              Keys.onUpPressed: {
                if (root.filtered.length > 0)
                  root.selectedIndex = Math.max(root.selectedIndex - 1, 0)
              }

              Keys.onPressed: event => {
                if (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_W) {
                  const pos = searchInput.cursorPosition
                  const after = searchInput.text.substring(pos)

                  let before = searchInput.text.substring(0, pos)

                  before = before.replace(/\s+$/, "")
                  before = before.replace(/\S+$/, "")

                  searchInput.text = before + after
                  searchInput.cursorPosition = before.length

                  root.searchText = searchInput.text
                  root.refresh()

                  event.accepted = true
                }
              }

              Text {
                text: "Search apps..."
                color: Appearance.colors.foreground
                font: parent.font
                visible: !parent.text.length
              }
            }
          }

          Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Appearance.colors.muted
            opacity: 0.4
          }
        }

        ListView {
          id: resultsList

          anchors.top: header.bottom
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.bottom: parent.bottom
          anchors.margins: 16
          anchors.topMargin: 8

          clip: true
          spacing: 2

          boundsBehavior: Flickable.StopAtBounds

          flickDeceleration: 600
          maximumFlickVelocity: 2500

          model: root.filtered
          currentIndex: root.selectedIndex

          delegate: Rectangle {
            id: entryDelegate

            required property DesktopEntry modelData
            required property int index

            width: resultsList.width
            height: 48
            radius: 8
            color: index === root.selectedIndex ? Appearance.colors.background : "transparent"

            Behavior on color {
              ColorAnimation {
                duration: 150
                easing.type: Easing.OutCubic
              }
            }

            RowLayout {
              anchors.left: parent.left
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              anchors.leftMargin: 10
              anchors.rightMargin: 10
              spacing: 10

              IconImage {
                Layout.alignment: Qt.AlignVCenter
                implicitSize: 28
                source: Quickshell.iconPath(entryDelegate.modelData.icon, true)
              }

              ColumnLayout {
                Layout.fillWidth: true
                spacing: 1

                Text {
                  Layout.fillWidth: true

                  text: entryDelegate.modelData.name
                  color: Appearance.colors.foreground
                  font.pixelSize: 14
                  font.family: Appearance.font
                  elide: Text.ElideRight
                }

                Text {
                  Layout.fillWidth: true

                  text: entryDelegate.modelData.comment
                  color: Appearance.colors.muted
                  visible: text.length > 0

                  font.pixelSize: 11
                  font.family: Appearance.font

                  elide: Text.ElideRight
                  maximumLineCount: 1
                }
              }
            }

            MouseArea {
              anchors.fill: parent
              hoverEnabled: true
              cursorShape: Qt.PointingHandCursor

              onEntered: root.selectedIndex = entryDelegate.index
              onClicked: root.launch(entryDelegate.modelData)
            }
          }
        }
      }
    }
  }
}
