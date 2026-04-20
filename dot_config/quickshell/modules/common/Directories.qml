pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.common.functions

import Quickshell
import Qt.labs.platform

Singleton {
  readonly property string configPath: StandardPaths.standardLocations(StandardPaths.ConfigLocation)[0]
  readonly property string localPath: `${Quickshell.env("HOME")}/.local`

  property string path: FileUtils.trimFileProtocol(Directories.configPath)
  property string local: FileUtils.trimFileProtocol(Directories.localPath)

  property string name: "shell.json"
  property string config: `${Directories.path}/${Directories.name}`

  property string wallpapers: `${Directories.local}/share/wallpapers`
}
