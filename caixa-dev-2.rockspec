package = "caixa"
version = "dev-2"
source = {
   url = "git+ssh://git@github.com/diegovinie/caixa.git"
}
description = {
   summary = "A tool box for love2d",
   detailed = [[
      # Caixa
      A tool box for love2d
      ## Input
      Input is an abstraction for input controls that allows you to use keyboard or gamepad with the same code.
   ]],
   homepage = "https://github.com/diegovinie/caixa",
   license = "*** please specify a license ***"
}
dependencies = {
   "hump >= 0.4-2"
}
build = {
   type = "builtin",
   modules = {
      ["caixa.Input.Control"] = "Input/Control.lua",
      ["caixa.Input.presets"] = "Input/presets.lua",
      ["caixa.Input.test"] = "Input/test.lua",
      ["caixa.Utils"] = "Utils.lua"
   }
}
