package = "caixa"
version = "dev-1"
source = {
   url = "git+ssh://git@github.com/diegovinie/caixa.git"
}
description = {
   summary = "```luarocks make --local",
   detailed = [[

```
luarocks make --local]],
   homepage = "*** please enter a project homepage ***",
   license = "*** please specify a license ***"
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
