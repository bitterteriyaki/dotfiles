pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.common.functions

import Quickshell
import Qt.labs.platform

Singleton {
  readonly property string configPath: StandardPaths.standardLocations(StandardPaths.ConfigLocation)[0]

  property string path: FileUtils.trimFileProtocol(Directories.configPath)
  property string name: "shell.json"
  property string config: `${Directories.path}/${Directories.name}`
}
