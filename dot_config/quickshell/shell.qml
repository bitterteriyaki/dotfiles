//@ pragma UseQApplication
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

import qs.modules.bar
import qs.modules.background

import Quickshell

ShellRoot {
  Bar {}
  Background {}
}
