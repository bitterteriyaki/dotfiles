pragma ComponentBehavior: Bound

import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions

import QtQuick
import Quickshell.Io
import Quickshell.Widgets

// One wallpaper in the selector row. Shows the cached thumbnail when there is
// one; otherwise decodes the original at thumbnail size and caches it.
Item {
  id: root

  required property var entry

  // The applied wallpaper.
  property bool current: false

  // The keyboard selection.
  property bool highlighted: false

  signal activated()

  // Set when the cached thumbnail is missing, so the original is decoded.
  property bool fromOriginal: false

  implicitWidth: Appearance.sizes.wallpaperThumbnailWidth
  implicitHeight: Appearance.sizes.wallpaperThumbnailHeight

  ClippingRectangle {
    anchors.fill: parent

    radius: Appearance.sizes.cardRadius
    color: Appearance.colors.muted

    Image {
      id: image

      anchors.fill: parent

      source: `file://${root.fromOriginal ? root.entry.path : root.entry.thumbnail}`
      asynchronous: true
      fillMode: Image.PreserveAspectCrop

      // Decoding a large original at full size would take seconds; the
      // cached thumbnail is already small.
      sourceSize.width: root.fromOriginal ? width : 0
      sourceSize.height: root.fromOriginal ? height : 0

      onStatusChanged: {
        if (image.status === Image.Error && !root.fromOriginal)
          root.fromOriginal = true
        else if (image.status === Image.Ready && root.fromOriginal)
          mkdir.running = true
      }
    }

    InteractiveRectangle {
      anchors.fill: parent

      radius: Appearance.sizes.cardRadius
      hoverColor: ColorUtils.transparentize(Appearance.colors.foreground, 0.85)

      onClicked: root.activated()
    }
  }

  // Outline for the applied wallpaper and, thicker, for the selection.
  Rectangle {
    anchors.fill: parent

    radius: Appearance.sizes.cardRadius
    color: "transparent"

    border.width: root.highlighted ? 3 : (root.current ? 2 : 0)
    border.color: root.highlighted
      ? Appearance.colors.foreground
      : ColorUtils.transparentize(Appearance.colors.foreground, 0.4)
  }

  // grabToImage needs the item on screen, so the cache is written while the
  // selector is open.
  Process {
    id: mkdir

    command: ["mkdir", "-p", Directories.thumbnails]

    onExited: {
      const path = root.entry.thumbnail
      const size = Qt.size(image.width, image.height)

      image.grabToImage(result => result.saveToFile(path), size)
    }
  }
}
