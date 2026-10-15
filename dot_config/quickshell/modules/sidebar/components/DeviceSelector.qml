pragma ComponentBehavior: Bound

import qs.modules.common

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire

// Current default output (or input); clicking it lists the others to pick from.
ColumnLayout {
  id: root

  required property bool sinks
  property string glyph: ""
  property bool expanded: false

  readonly property var current: root.sinks
    ? Pipewire.defaultAudioSink
    : Pipewire.defaultAudioSource

  readonly property var devices: Pipewire.nodes.values.filter(node => {
    return node.audio && !node.isStream && node.isSink === root.sinks
  })

  function choose(node: var): void {
    if (root.sinks)
      Pipewire.preferredDefaultAudioSink = node
    else
      Pipewire.preferredDefaultAudioSource = node

    root.expanded = false
  }

  spacing: 2

  Rectangle {
    Layout.fillWidth: true
    Layout.preferredHeight: 28

    radius: 6
    color: currentHover.hovered ? Appearance.colors.secondary : "transparent"

    RowLayout {
      anchors.fill: parent
      anchors.leftMargin: 6
      anchors.rightMargin: 6

      spacing: 8

      Text {
        text: root.glyph
        color: Appearance.colors.foreground

        font.family: Appearance.fonts.icons
        font.pixelSize: 16
      }

      Text {
        Layout.fillWidth: true

        text: root.current?.description ?? "No device"
        color: Appearance.colors.foreground
        elide: Text.ElideRight

        font.family: Appearance.fonts.mono
        font.pixelSize: 12
        font.bold: true
      }

      Text {
        text: String.fromCodePoint(root.expanded ? 0xF0143 : 0xF0140) // nf-md-chevron_up / down
        color: Appearance.colors.foreground
        opacity: 0.6

        font.family: Appearance.fonts.icons
        font.pixelSize: 16
      }
    }

    HoverHandler {
      id: currentHover
      cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
      onTapped: root.expanded = !root.expanded
    }
  }

  Repeater {
    model: root.expanded ? root.devices : []

    Rectangle {
      id: option

      required property var modelData
      readonly property bool isCurrent: option.modelData === root.current

      Layout.fillWidth: true
      Layout.preferredHeight: 26

      radius: 6
      color: optionHover.hovered ? Appearance.colors.secondary : "transparent"

      RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 30
        anchors.rightMargin: 6

        spacing: 8

        Text {
          Layout.fillWidth: true

          text: option.modelData.description
          color: Appearance.colors.foreground
          opacity: option.isCurrent ? 1 : 0.7
          elide: Text.ElideRight

          font.family: Appearance.fonts.mono
          font.pixelSize: 12
        }

        Text {
          visible: option.isCurrent
          text: String.fromCodePoint(0xF012C) // nf-md-check
          color: Appearance.colors.foreground

          font.family: Appearance.fonts.icons
          font.pixelSize: 14
        }
      }

      HoverHandler {
        id: optionHover
        cursorShape: Qt.PointingHandCursor
      }

      TapHandler {
        onTapped: root.choose(option.modelData)
      }
    }
  }
}
