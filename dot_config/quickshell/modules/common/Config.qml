pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property string path: Directories.config
  property alias options: adapter

  property bool ready: false

  FileView {
    path: root.path
    watchChanges: true

    onFileChanged: reload()
    onLoaded: root.ready = true

    onLoadFailed: error => {
      if (error === FileViewError.FileNotFound)
        writeAdapter()
    }

    JsonAdapter {
      id: adapter

      property JsonObject bar: JsonObject {
        property list<string> screens: ["HDMI-A-1"]
      }
    }
  }
}
