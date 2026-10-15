pragma ComponentBehavior: Bound

import qs.modules.common
import qs.modules.sidebar
import qs.modules.sidebar.components

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire

// Mixer: default output, default input, then one row per app playing sound.
Item {
  id: root

  readonly property var streams: Pipewire.nodes.values.filter(node => {
    return node.audio && node.isStream && node.isSink
  })

  // DesktopEntries loads lazily; depending on it here makes the icon
  // lookups below resolve once the entries arrive.
  readonly property int desktopEntryCount: DesktopEntries.applications.values.length

  function appName(node: var): string {
    const properties = node.properties ?? {}

    return properties["application.name"] || node.name || "Unknown app"
  }

  function appIcon(node: var): string {
    if (root.desktopEntryCount === 0)
      return ""

    const properties = node.properties ?? {}
    const icon = properties["application.icon-name"]
      || (DesktopEntries.heuristicLookup(root.appName(node))?.icon ?? "")

    return icon ? Quickshell.iconPath(icon, true) : ""
  }

  // Nodes only report live volume and mute while tracked.
  PwObjectTracker {
    objects: SidebarState.visible ? Pipewire.nodes.values : []
  }

  component SectionLabel: Text {
    color: Appearance.colors.foreground
    opacity: 0.6

    font.family: Appearance.fonts.mono
    font.pixelSize: 11
  }

  Text {
    anchors.centerIn: parent

    visible: !Pipewire.ready
    text: "Audio unavailable"
    color: Appearance.colors.foreground
    opacity: 0.6

    font.family: Appearance.fonts.mono
    font.pixelSize: 13
  }

  ScrollView {
    id: scroll

    anchors.fill: parent

    visible: Pipewire.ready
    clip: true

    contentWidth: availableWidth
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

    ColumnLayout {
      width: scroll.availableWidth
      spacing: 6

      DeviceSelector {
        Layout.fillWidth: true

        sinks: true
        glyph: String.fromCodePoint(0xF057E) // nf-md-volume_high
      }

      VolumeRow {
        Layout.fillWidth: true

        node: Pipewire.defaultAudioSink
        showIcon: false
      }

      DeviceSelector {
        Layout.fillWidth: true
        Layout.topMargin: 6

        sinks: false
        glyph: String.fromCodePoint(0xF036C) // nf-md-microphone
      }

      VolumeRow {
        Layout.fillWidth: true

        node: Pipewire.defaultAudioSource
        showIcon: false

        glyph: String.fromCodePoint(0xF036C) // nf-md-microphone
        mutedGlyph: String.fromCodePoint(0xF036D) // nf-md-microphone_off
      }

      SectionLabel {
        Layout.topMargin: 6
        text: "Apps"
      }

      Repeater {
        model: root.streams

        VolumeRow {
          required property var modelData

          Layout.fillWidth: true

          node: modelData
          label: root.appName(modelData)
          iconSource: root.appIcon(modelData)
        }
      }

      SectionLabel {
        visible: root.streams.length === 0
        text: "No apps playing"
      }
    }
  }
}
