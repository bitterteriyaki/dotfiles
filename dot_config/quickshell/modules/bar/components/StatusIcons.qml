import qs.modules.common

import QtQuick
import QtQuick.Layouts
import Quickshell.Networking

Rectangle {
  id: root

  readonly property var wiredDevice: {
    for (const device of Networking.devices.values)
      if (device.type === DeviceType.Wired)
        return device

    return null
  }

  readonly property var wifiDevice: {
    for (const device of Networking.devices.values)
      if (device.type === DeviceType.Wifi)
        return device

    return null
  }

  readonly property var activeWifiNetwork: {
    if (wifiDevice === null)
      return null

    for (const network of wifiDevice.networks.values)
      if (network.connected)
        return network

    return null
  }

  readonly property bool wiredConnected: wiredDevice !== null && wiredDevice.connected
  readonly property bool wifiConnected: activeWifiNetwork !== null

  readonly property string networkIcon: {
    if (wiredConnected)
      return String.fromCodePoint(0xFFFB7) // settings_ethernet
  //
  //   if (wifiConnected) {
  //     const strength = activeWifiNetwork.signalStrength;
  //
  //     if (strength >= 75) return String.fromCodePoint(0xF0928); // md-wifi_strength_4
  //     if (strength >= 50) return String.fromCodePoint(0xF0925); // md-wifi_strength_3
  //     if (strength >= 25) return String.fromCodePoint(0xF0922); // md-wifi_strength_2
  //     return String.fromCodePoint(0xF091F); // md-wifi_strength_1
  //   }
  //
  //   if (wifiDevice !== null) return String.fromCodePoint(0xF05AA); // md-wifi_off ("sem wifi")
  //
    return String.fromCodePoint(0xE8BE) // settings_ethernet_cable_off
  }

  implicitWidth: row.implicitWidth + 24
  implicitHeight: row.implicitHeight

  radius: 8
  color: hoverHandler.hovered ? Appearance.colors.secondary : "transparent"

  RowLayout {
    id: row

    anchors.centerIn: parent

    spacing: 6

    Text {
      text: root.networkIcon
      color: Appearance.colors.foreground

      font.family: Appearance.fonts.icons
      font.pixelSize: 18
    }

  //   Text {
  //     text: ""
  //     color: Appearance.colors.foreground
  //
  //     font.family: Appearance.fonts.mono
  //     font.pixelSize: 13
  //   }
  // }

  HoverHandler {
    id: hoverHandler
  }

  // TapHandler {
  //   onTapped: {}
  }
}
