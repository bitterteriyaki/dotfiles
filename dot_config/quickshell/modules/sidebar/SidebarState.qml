pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell

Singleton {
  id: root

  property bool visible: false

  function open(): void {
    root.visible = true
  }

  function close(): void {
    root.visible = false
  }

  function toggle(): void {
    root.visible = !root.visible
  }
}
