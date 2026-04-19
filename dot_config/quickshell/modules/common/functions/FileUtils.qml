pragma Singleton

import Quickshell

Singleton {
  function trimFileProtocol(file: string): string {
    return file.startsWith("file://") ? file.slice(7) : file
  }
}
