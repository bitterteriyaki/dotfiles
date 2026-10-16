pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.common

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  // The applied wallpaper, or default.png when nothing was saved yet.
  // Wallpaper.qml falls back further when this file cannot be loaded.
  readonly property string current: adapter.path || Directories.defaultWallpaper

  // Path waiting for the state directory to exist before it is written.
  property string pending: ""

  function apply(path: string): void {
    root.pending = path
    mkdir.running = true
  }

  // The state directory may not exist on a fresh machine, and FileView does
  // not create parent directories when it writes.
  Process {
    id: mkdir

    command: ["mkdir", "-p", Directories.state]

    onExited: {
      adapter.path = root.pending
      file.writeAdapter()
    }
  }

  FileView {
    id: file

    path: Directories.wallpaperState
    watchChanges: true

    onFileChanged: reload()

    // A missing file is left missing: the default applies until the user
    // picks a wallpaper.

    JsonAdapter {
      id: adapter

      property string path: ""
    }
  }
}
