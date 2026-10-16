pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.common
import qs.modules.sidebar

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property bool visible: false

  // { path, mtime, thumbnail } for every image under the wallpapers folder,
  // sorted by path. Rebuilt every time the selector opens.
  property var entries: []

  // Set by random() so that only the refresh it started picks a wallpaper.
  property bool pickRandom: false

  signal refreshed()

  function open(): void {
    if (root.visible)
      return

    // Only one of the selector and the sidebar is open at a time.
    SidebarState.close()

    root.visible = true
    root.refresh()
  }

  function close(): void {
    root.visible = false
  }

  function toggle(): void {
    if (root.visible)
      root.close()
    else
      root.open()
  }

  function refresh(): void {
    finder.running = true
  }

  // Applies an image other than the current one, without opening the
  // selector. Does nothing with fewer than two images.
  function random(): void {
    root.pickRandom = true
    root.refresh()
  }

  onRefreshed: {
    if (!root.pickRandom)
      return

    root.pickRandom = false

    if (root.entries.length < 2)
      return

    const others = root.entries.filter(e => e.path !== WallpaperState.current)
    const pick = others[Math.floor(Math.random() * others.length)]

    if (pick)
      WallpaperState.apply(pick.path)
  }

  // The sidebar does not know about the selector; the selector watches it.
  Connections {
    target: SidebarState

    function onVisibleChanged(): void {
      if (SidebarState.visible)
        root.close()
    }
  }

  Process {
    id: finder

    // Recursive, so subfolders are listed too. Hidden files and folders are
    // pruned by name below the root (matching on the whole path would also
    // hit the root's own "/.local"). The mtime only keys the thumbnail cache.
    command: [
      "find", Directories.wallpapers,
      "-mindepth", "1",
      "-name", ".*", "-prune", "-o",
      "-type", "f",
      "(",
        "-iname", "*.png", "-o",
        "-iname", "*.jpg", "-o",
        "-iname", "*.jpeg", "-o",
        "-iname", "*.webp",
      ")",
      "-printf", "%T@\\t%p\\n",
    ]

    stdout: StdioCollector {
      id: output

      onStreamFinished: {
        const entries = []

        for (const line of output.text.split("\n")) {
          const tab = line.indexOf("\t")
          if (tab < 0)
            continue

          const mtime = line.slice(0, tab)
          const path = line.slice(tab + 1)
          const thumbnail = `${Directories.thumbnails}/${Qt.md5(`${path}:${mtime}`)}.png`

          entries.push({ path, mtime, thumbnail })
        }

        entries.sort((a, b) => a.path.localeCompare(b.path))

        root.entries = entries
        root.refreshed()
      }
    }
  }
}
