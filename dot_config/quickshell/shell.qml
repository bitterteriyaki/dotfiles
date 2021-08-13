//@ pragma UseQApplication
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

import qs.modules.bar
import qs.modules.background
import qs.modules.launcher
import qs.modules.sidebar

import Quickshell

ShellRoot {
  Bar {}
  Background {}
  Launcher {}
  Sidebar {}
}
