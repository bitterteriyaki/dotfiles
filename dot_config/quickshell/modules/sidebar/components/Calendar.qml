pragma ComponentBehavior: Bound

import qs.modules.common
import qs.modules.sidebar

import QtQuick
import QtQuick.Layouts
import Quickshell

ColumnLayout {
  id: root

  // Both count from 0 = Sunday, like Date.getDay() and Locale.dayName().
  property int weekStart: Qt.locale().firstDayOfWeek
  property bool showAdjacentDays: true

  property int viewYear
  property int viewMonth
  property var selectedDate: null

  readonly property int cellSize: Appearance.sizes.calendarCellSize

  // Leading cells borrowed from the previous month.
  readonly property int offset: {
    const first = new Date(root.viewYear, root.viewMonth, 1)

    return (first.getDay() - root.weekStart + 7) % 7
  }

  spacing: 8

  function reset(): void {
    const now = new Date()

    root.viewYear = now.getFullYear()
    root.viewMonth = now.getMonth()
    root.selectedDate = null
  }

  function shiftMonth(delta: int): void {
    const date = new Date(root.viewYear, root.viewMonth + delta, 1)

    root.viewYear = date.getFullYear()
    root.viewMonth = date.getMonth()
  }

  function sameDay(a, b): bool {
    return !!a && !!b
      && a.getFullYear() === b.getFullYear()
      && a.getMonth() === b.getMonth()
      && a.getDate() === b.getDate()
  }

  Component.onCompleted: reset()

  Connections {
    target: SidebarState

    function onVisibleChanged(): void {
      if (SidebarState.visible)
        root.reset()
    }
  }

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }

  component ArrowButton: Rectangle {
    id: arrow

    required property string glyph
    signal clicked()

    implicitWidth: root.cellSize
    implicitHeight: root.cellSize

    radius: width / 2
    color: hover.hovered ? Appearance.colors.muted : "transparent"

    Text {
      anchors.centerIn: parent

      text: arrow.glyph
      color: Appearance.colors.foreground

      font.family: Appearance.fonts.icons
      font.pixelSize: 20
    }

    HoverHandler {
      id: hover
      cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
      onTapped: arrow.clicked()
    }
  }

  RowLayout {
    Layout.fillWidth: true

    ArrowButton {
      glyph: String.fromCodePoint(0xF0141) // nf-md-chevron_left
      onClicked: root.shiftMonth(-1)
    }

    Text {
      Layout.fillWidth: true
      horizontalAlignment: Text.AlignHCenter

      text: {
        const month = Qt.locale().standaloneMonthName(root.viewMonth, Locale.LongFormat)

        return `${month} ${root.viewYear}`
      }

      color: Appearance.colors.foreground

      font.family: Appearance.fonts.mono
      font.pixelSize: 15
      font.bold: true
    }

    ArrowButton {
      glyph: String.fromCodePoint(0xF0142) // nf-md-chevron_right
      onClicked: root.shiftMonth(1)
    }
  }

  Row {
    Layout.alignment: Qt.AlignHCenter

    Repeater {
      model: 7

      Text {
        required property int index

        width: root.cellSize
        horizontalAlignment: Text.AlignHCenter

        text: Qt.locale().dayName((root.weekStart + index) % 7, Locale.NarrowFormat)
        color: Appearance.colors.foreground
        opacity: 0.6

        font.family: Appearance.fonts.mono
        font.pixelSize: 12
      }
    }
  }

  // Always six weeks, so the grid never changes height between months.
  Grid {
    Layout.alignment: Qt.AlignHCenter

    columns: 7

    Repeater {
      model: 42

      Item {
        id: cell

        required property int index

        readonly property date date: {
          return new Date(root.viewYear, root.viewMonth, 1 - root.offset + index)
        }

        readonly property bool inMonth: date.getMonth() === root.viewMonth
        readonly property bool shown: inMonth || root.showAdjacentDays

        readonly property bool isToday: inMonth && root.sameDay(date, clock.date)
        readonly property bool isSelected: root.sameDay(date, root.selectedDate)

        width: root.cellSize
        height: root.cellSize

        // Selection ring, drawn outside today's fill so both can show.
        Rectangle {
          anchors.centerIn: parent

          width: parent.width - 6
          height: width
          radius: width / 2

          visible: cell.shown && cell.isSelected
          color: "transparent"

          border.width: 2
          border.color: Appearance.colors.foreground
        }

        Rectangle {
          anchors.centerIn: parent

          width: parent.width - 16
          height: width
          radius: width / 2

          visible: cell.shown && cell.isToday
          color: Appearance.colors.foreground
        }

        Text {
          anchors.centerIn: parent

          visible: cell.shown
          text: cell.date.getDate()

          color: cell.isToday
            ? Appearance.colors.background
            : Appearance.colors.foreground

          // Plain `muted` is nearly invisible on the panel's background.
          opacity: cell.inMonth ? 1 : 0.35

          font.family: Appearance.fonts.mono
          font.pixelSize: 13
        }

        MouseArea {
          anchors.fill: parent

          enabled: cell.shown
          cursorShape: Qt.PointingHandCursor

          onClicked: root.selectedDate = cell.date
        }
      }
    }
  }
}
