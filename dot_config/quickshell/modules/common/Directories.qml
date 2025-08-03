/*
 * Copyright (C) 2025-present end-4
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.common.functions

import Quickshell
import Qt.labs.platform

Singleton {
    readonly property string config: StandardPaths.standardLocations(StandardPaths.ConfigLocation)[0]

    property string shellConfig: FileUtils.trimFileProtocol(Directories.config)
    property string shellConfigName: "shell.json"
    property string shellConfigPath: `${Directories.shellConfig}/${Directories.shellConfigName}`
}
