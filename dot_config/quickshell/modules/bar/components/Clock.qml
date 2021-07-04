import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland

Rectangle {
  id: root

  property bool detailsVisible: false

  color: Appearance.colors.secondary
  radius: 8

  implicitWidth: label.implicitWidth + 16
  implicitHeight: label.implicitHeight + 8

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  Text {
    id: label

    anchors.centerIn: parent

    text: Qt.formatDateTime(clock.date, "hh:mm")
    color: Appearance.colors.foreground

    font.family: Appearance.font
    font.pixelSize: 13
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor

    onClicked: {
      root.detailsVisible = !root.detailsVisible
    }
  }

  PanelWindow {
    id: detailsWindow

    property real showAnim: root.detailsVisible ? 1 : 0

    Behavior on showAnim {
      NumberAnimation {
        duration: 300
        easing.type: root.detailsVisible ? Easing.InCubic : Easing.OutCubic
      }
    }

    visible: showAnim > 0.001

    WlrLayershell.namespace: "quickshell:calendar"
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

    MouseArea {
      anchors.fill: parent
      onClicked: root.detailsVisible = false
    }

    StyledRectangularShadow {
      target: card
    }

    Rectangle {
      id: card

      anchors.verticalCenter: parent.verticalCenter

      x: parent.width - detailsWindow.showAnim * (width + 24)

      width: 340
      height: content.implicitHeight + 40
      radius: 14
      color: Appearance.colors.secondary
      clip: true

      border.width: 1
      border.color: Appearance.colors.muted

      MouseArea {
        anchors.fill: parent
      }

      ColumnLayout {
        id: content

        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        ColumnLayout {
          Layout.alignment: Qt.AlignHCenter
          spacing: 0

          Text {
            Layout.alignment: Qt.AlignHCenter

            text: Qt.formatDateTime(clock.date, "hh:mm:ss")
            color: Appearance.colors.foreground

            font.family: Appearance.font
            font.pixelSize: 32
            font.bold: true
          }

          Text {
            Layout.alignment: Qt.AlignHCenter

            text: Qt.formatDate(clock.date, "d MMMM yyyy")
            color: ColorUtils.transparentize(Appearance.colors.foreground, 0.4)

            font.family: Appearance.font
            font.pixelSize: 16
          }
        }

        Rectangle {
          Layout.fillWidth: true
          Layout.preferredHeight: 1

          color: Appearance.colors.muted
        }

        DayOfWeekRow {
          Layout.alignment: Qt.AlignHCenter

          spacing: 4
          topPadding: 0
          bottomPadding: 0

          delegate: Text {
            required property string shortName

            width: 38
            height: 24

            text: shortName
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            color: Appearance.colors.foreground

            font.family: Appearance.font
            font.pixelSize: 13
          }
        }

        MonthGrid {
          id: grid

          Layout.alignment: Qt.AlignHCenter

          spacing: 4

          month: clock.date.getMonth()
          year: clock.date.getFullYear()

          delegate: Rectangle {
            required property var model

            width: 38
            height: 38

            radius: width / 2
            color: model.today ? Appearance.colors.foreground : "transparent"

            Text {
              anchors.centerIn: parent

              text: model.day
              opacity: model.month === grid.month ? 1 : 0.3

              color: model.today ? Appearance.colors.background : Appearance.colors.foreground

              font.family: Appearance.font
              font.pixelSize: 14
            }
          }
        }
      }
    }
  }
}
