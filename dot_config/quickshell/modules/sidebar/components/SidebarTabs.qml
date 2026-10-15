pragma ComponentBehavior: Bound

import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets
import qs.modules.sidebar
import qs.modules.sidebar.components

import QtQuick
import QtQuick.Layouts

// Card with the Notifications and Volume tabs; Notifications on every open.
Rectangle {
  id: root

  property string currentTab: "notifications"

  radius: Appearance.sizes.cardRadius
  color: Appearance.colors.card

  Connections {
    target: SidebarState

    function onVisibleChanged(): void {
      if (SidebarState.visible)
        root.currentTab = "notifications"
    }
  }

  component TabButton: InteractiveRectangle {
    id: tab

    required property string key
    required property string glyph
    required property string label

    readonly property bool selected: root.currentTab === tab.key

    Layout.fillWidth: true
    Layout.fillHeight: true

    radius: Appearance.sizes.cardRadius - 2

    baseColor: tab.selected
      ? Appearance.colors.secondary
      : ColorUtils.transparentize(Appearance.colors.secondary, 1)

    onClicked: root.currentTab = tab.key

    RowLayout {
      anchors.centerIn: parent
      spacing: 8

      Text {
        text: tab.glyph
        color: Appearance.colors.foreground
        opacity: tab.selected ? 1 : 0.6

        font.family: Appearance.fonts.icons
        font.pixelSize: Appearance.sizes.tabIconSize
      }

      Text {
        text: tab.label
        color: Appearance.colors.foreground
        opacity: tab.selected ? 1 : 0.6

        font.family: Appearance.fonts.mono
        font.pixelSize: 13
        font.bold: tab.selected
      }
    }
  }

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: Appearance.sizes.cardPadding

    spacing: Appearance.sizes.cardPadding

    RowLayout {
      Layout.fillWidth: true

      // Children fill the bar's height, which would otherwise make the bar
      // itself fill the card.
      Layout.fillHeight: false
      Layout.preferredHeight: Appearance.sizes.tabBarHeight

      spacing: 4

      TabButton {
        key: "notifications"
        glyph: String.fromCodePoint(0xF009A) // nf-md-bell
        label: "Notifications"
      }

      TabButton {
        key: "volume"
        glyph: String.fromCodePoint(0xF057E) // nf-md-volume_high
        label: "Volume"
      }
    }

    Item {
      Layout.fillWidth: true
      Layout.fillHeight: true

      Loader {
        anchors.fill: parent
        active: root.currentTab === "notifications"
        visible: active

        sourceComponent: NotificationsTab {}
      }

      Loader {
        anchors.fill: parent
        active: root.currentTab === "volume"
        visible: active

        sourceComponent: VolumeTab {}
      }
    }
  }
}
