pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.common.functions

import QtQuick
import Quickshell

Singleton {
  id: root

  property QtObject sizes: QtObject {
    property int barHeight: 40
    property real elevationMargin: 16
    property int barPaddingHorizontal: 16

    property int sidebarWidth: 460
    property int sidebarMargin: 12
    property int sidebarRadius: 14
    property int sidebarPadding: 20
    property int sidebarSpacing: 12
    property int sidebarBorderWidth: 1

    property int wallpaperSelectorMaxWidth: 1200
    property int wallpaperSelectorPadding: 14
    property int wallpaperThumbnailWidth: 214
    property int wallpaperThumbnailHeight: 120
    property int wallpaperThumbnailSpacing: 10

    property int cardRadius: 10
    property int cardPadding: 12

    property int avatarSize: 48
    property int dateTimeReservedHeight: 56

    property int calendarCellSize: 40

    property int tabBarHeight: 36
    property int tabIconSize: 16

    property int volumeRowHeight: 40
    property int volumeIconSize: 24
    property int volumeLabelWidth: 44

    property int sliderHeight: 6
    property int sliderHandleSize: 14
  }

  property QtObject fonts: QtObject {
    property string mono: "JetBrainsMono Nerd Font"
    property string icons: "JetBrainsMono Nerd Font"
  }

  property QtObject colors: QtObject {
    property color foreground: "#DFE1DE"
    property color background: "#0D070C"

    property color secondary: "#1E151D"
    property color muted: "#393F4E"

    property color border: ColorUtils.transparentize(muted, 0.4)
    property color card: background

    property color shadow: ColorUtils.transparentize("#000000", 0.4)
  }

  property QtObject animation: QtObject {
    property int hoverDuration: 150
  }
}
