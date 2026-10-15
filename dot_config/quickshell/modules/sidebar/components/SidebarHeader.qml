pragma ComponentBehavior: Bound

import qs.modules.common
import qs.modules.sidebar

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

RowLayout {
  id: root

  readonly property string login: Quickshell.env("USER")
  readonly property string avatarPath: `${Quickshell.env("HOME")}/.face`

  // Only hand ~/.face to the Image once it is known to exist, so a missing
  // file does not log a warning every time the sidebar opens.
  property bool hasAvatar: false

  // Field 5 (GECOS) of the login's /etc/passwd line, up to the first comma.
  readonly property string fullName: {
    const prefix = `${root.login}:`
    const line = passwd.text().split("\n").find(l => l.startsWith(prefix))

    return line ? (line.split(":")[4] ?? "").split(",")[0].trim() : ""
  }

  readonly property string displayName: root.fullName || root.login
  readonly property string initial: root.displayName.charAt(0).toUpperCase()

  readonly property string greeting: {
    const hour = clock.date.getHours()

    if (hour >= 5 && hour < 12)
      return "Good morning"

    if (hour >= 12 && hour < 18)
      return "Good afternoon"

    if (hour >= 18 && hour < 22)
      return "Good evening"

    return "Good night"
  }

  readonly property string uptime: {
    const seconds = Math.floor(parseFloat(uptimeFile.text().split(" ")[0]) || 0)

    const days = Math.floor(seconds / 86400)
    const hours = Math.floor(seconds % 86400 / 3600)
    const minutes = Math.floor(seconds % 3600 / 60)

    return days > 0 ? `up ${days}d ${hours}h` : `up ${hours}h ${minutes}m`
  }

  spacing: Appearance.sizes.sidebarSpacing

  FileView {
    id: passwd
    path: "/etc/passwd"
  }

  FileView {
    id: face

    path: root.avatarPath
    printErrors: false

    onLoaded: root.hasAvatar = true
    onLoadFailed: root.hasAvatar = false
  }

  FileView {
    id: uptimeFile
    path: "/proc/uptime"
  }

  SystemClock {
    id: clock

    precision: SystemClock.Minutes
    enabled: SidebarState.visible

    onDateChanged: uptimeFile.reload()
  }

  // Re-read everything on open, so a new or removed ~/.face shows up.
  Connections {
    target: SidebarState

    function onVisibleChanged(): void {
      if (!SidebarState.visible)
        return

      passwd.reload()
      uptimeFile.reload()

      // Drop the old image first so a replaced ~/.face is decoded again.
      root.hasAvatar = false
      face.reload()
    }
  }

  ClippingRectangle {
    Layout.preferredWidth: Appearance.sizes.avatarSize
    Layout.preferredHeight: Appearance.sizes.avatarSize

    radius: width / 2
    color: Appearance.colors.muted

    Image {
      id: avatar

      anchors.fill: parent

      source: root.hasAvatar ? `file://${root.avatarPath}` : ""
      cache: false
      asynchronous: true

      fillMode: Image.PreserveAspectCrop
      sourceSize.width: width
      sourceSize.height: height

      visible: status === Image.Ready
    }

    Text {
      anchors.centerIn: parent

      visible: avatar.status !== Image.Ready
      text: root.initial
      color: Appearance.colors.foreground

      font.family: Appearance.fonts.mono
      font.pixelSize: 20
      font.bold: true
    }
  }

  ColumnLayout {
    Layout.fillWidth: true
    spacing: 2

    Text {
      Layout.fillWidth: true

      text: root.greeting
      color: Appearance.colors.foreground
      elide: Text.ElideRight

      font.family: Appearance.fonts.mono
      font.pixelSize: 15
      font.bold: true
    }

    Text {
      Layout.fillWidth: true

      text: root.displayName
      color: Appearance.colors.foreground
      elide: Text.ElideRight

      font.family: Appearance.fonts.mono
      font.pixelSize: 13
    }

    Text {
      Layout.fillWidth: true

      text: root.uptime
      color: Appearance.colors.foreground
      opacity: 0.6
      elide: Text.ElideRight

      font.family: Appearance.fonts.mono
      font.pixelSize: 12
    }
  }
}
