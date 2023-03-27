package = "love2d-control"
version = "dev-4"
source = {
   url = "git+ssh://git@github.com/diegovinie/love2d-control.git"
}
description = {
   homepage = "*** please enter a project homepage ***",
   license = "*** please specify a license ***"
}
dependencies = {
   "hump >= 0.4-2"
}
build = {
   type = "builtin",
   modules = {
      ["love2dControl.Control"] = "Control.lua",
      ["love2dControl.presets"] = "presets.lua"
   }
}
