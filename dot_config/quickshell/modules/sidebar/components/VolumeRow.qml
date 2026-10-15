pragma ComponentBehavior: Bound

import qs.modules.common
import qs.modules.sidebar.components

import QtQuick
import QtQuick.Layouts

// One volume control: optional icon and name, slider, percentage and mute.
RowLayout {
  id: root

  required property var node

  property string label: ""
  property string iconSource: ""
  property bool showIcon: true

  // Shown in place of the icon when iconSource does not resolve.
  property string iconGlyph: String.fromCodePoint(0xF075A) // nf-md-music_note

  // The mute button, unmuted and muted.
  property string glyph: String.fromCodePoint(0xF057E) // nf-md-volume_high
  property string mutedGlyph: String.fromCodePoint(0xF0581) // nf-md-volume_off

  readonly property real volume: root.node?.audio?.volume ?? 0
  readonly property bool muted: root.node?.audio?.muted ?? false

  function setVolume(value: real): void {
    if (root.node?.audio)
      root.node.audio.volume = Math.max(0, Math.min(1, value))
  }

  Layout.preferredHeight: Appearance.sizes.volumeRowHeight
  spacing: 10

  Item {
    visible: root.showIcon

    Layout.preferredWidth: Appearance.sizes.volumeIconSize
    Layout.preferredHeight: Appearance.sizes.volumeIconSize

    Image {
      id: icon

      anchors.fill: parent

      source: root.iconSource
      sourceSize.width: width
      sourceSize.height: height

      visible: status === Image.Ready
    }

    Text {
      anchors.centerIn: parent

      visible: icon.status !== Image.Ready
      text: root.iconGlyph
      color: Appearance.colors.foreground

      font.family: Appearance.fonts.icons
      font.pixelSize: 18
    }
  }

  ColumnLayout {
    Layout.fillWidth: true
    spacing: 0

    Text {
      Layout.fillWidth: true

      visible: root.label !== ""
      text: root.label
      color: Appearance.colors.foreground
      elide: Text.ElideRight

      font.family: Appearance.fonts.mono
      font.pixelSize: 12
    }

    VolumeSlider {
      Layout.fillWidth: true

      value: Math.min(root.volume, 1)
      opacity: root.muted ? 0.5 : 1

      onChangeRequested: value => root.setVolume(value)
    }
  }

  // The real level, which can exceed the slider's 100% when set elsewhere.
  Text {
    Layout.preferredWidth: Appearance.sizes.volumeLabelWidth
    horizontalAlignment: Text.AlignRight

    text: `${Math.round(root.volume * 100)}%`
    color: Appearance.colors.foreground
    opacity: root.muted ? 0.5 : 1

    font.family: Appearance.fonts.mono
    font.pixelSize: 12
  }

  Rectangle {
    Layout.preferredWidth: 28
    Layout.preferredHeight: 28

    radius: width / 2
    color: hover.hovered ? Appearance.colors.secondary : "transparent"

    Text {
      anchors.centerIn: parent

      text: root.muted ? root.mutedGlyph : root.glyph
      color: Appearance.colors.foreground
      opacity: root.muted ? 0.5 : 1

      font.family: Appearance.fonts.icons
      font.pixelSize: 16
    }

    HoverHandler {
      id: hover
      cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
      onTapped: {
        if (root.node?.audio)
          root.node.audio.muted = !root.muted
      }
    }
  }
}
