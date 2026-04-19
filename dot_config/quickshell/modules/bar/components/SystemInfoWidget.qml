import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
  id: root

  implicitWidth: row.implicitWidth
  implicitHeight: 36

  property string cpuUsage: "0%"
  property string ramUsage: "0%"

  Process {
    id: cpuProc
    command: ["bash", "-c", "top -bn1 | grep 'Cpu(s)' | awk '{print int($2+$4)}'"]
    running: true
    stdout: SplitParser {
      onRead: data => root.cpuUsage = data.trim() + "%"
    }
  }

  Process {
    id: ramProc
    command: ["bash", "-c", "free | awk '/Mem:/{printf \"%d\", $3/$2*100}'"]
    running: true
    stdout: SplitParser {
      onRead: data => root.ramUsage = data.trim() + "%"
    }
  }

  Timer {
    interval: 5000
    running: true
    repeat: true
    onTriggered: {
      cpuProc.running = false
      cpuProc.running = true
      ramProc.running = false
      ramProc.running = true
    }
  }

  RowLayout {
    id: row
    anchors.centerIn: parent
    spacing: 10

    StatLabel {
      icon: ""
      value: root.cpuUsage
    }

    StatLabel {
      icon: ""
      value: root.ramUsage
    }
  }
}
