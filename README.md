
# Caixa
A tool box for love2d
## Input
Input is an abstraction for input controls that allows you to use a keyboard or gamepad with the same code.


## Installing Caixa
### Luarocks instructions

```sh
# Pull the rock from the server (to install it locally use the flag --local)
luarocks install --server=https://luarocks.org/dev caixa

# Alternatively you can clone the repository
git@github.com:diegovinie/caixa.git

# and install this rock locally
ca caixa
luarocks make --local

# TODO: install dependencies

# Make the paths (including local) visible to lua
eval "$(luarocks path --bin)"
```

### Adding as a git submodule

```sh
# inside the directory
git submodule init
git submodule add git@github.com:diegovinie/caixa.git

# TODO install dependencies
```

## Instructions
### Setup

Usually in the `main.lua` file:

```lua
local presets = require 'caixa.Input.presets'
Control = require 'caixa.Input.Control'         -- Global variable recommended

local options = {
    player = 'player A',    -- A string to identify the user, Used as key internally
    position = 1,           -- number (default: 1): Used mostly to identify the joystick position
    kbSet = presents.kb1,   -- table (default: presets.kb1): The gamepad mapping
    gpSet = presets.gp1,    -- table (default: presets.gp1): The keyboard mapping
    engine = love,          -- The engine used. In case of trying a different game engine
}

function love.load()
    -- instantiate a control as a global variable, you can pass it to the player later on
    gControl = Control(options)
end

--
--

function love.keypressed(key)
    -- Other code

    Control.RegisterKeyboard(key)
end

--
--

function love.gamepadpressed(joystick, button)
    -- Other code

    Control.RegisterGamepad(button, joystick:getID())
end

--
--

function love.update(dt)
    -- At the top of the function body
    Control.updateAll(dt)

    -- Other code

    -- At the bottom of the function body
    Control.cleanInputs()
end
```

### To use inside the update function
Useful for movement commands, e.g. move forward/backward.

```lua
-- check if control[button] is down
 if gControl.left then
    -- ...
 end
```

### Check if af button was pressed
Avoid the bouncing, useful for action command like jumping, and toggle commands like pause

```lua
if gControl:pressed('buttonA') then
    -- ...
end
```
