
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
cd caixa
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

<br/>

## Instructions for caixa.Input
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
}

function love.load()
    -- instantiate a control as a global variable, you can pass it to the player later on
    gControl = Control(options)
end

--
--

function love.keypressed(key)
    -- Other code

    Control.OnKeyboardPressed(key)
end

--
--

function love.gamepadpressed(joystick, button)
    -- Other code

    Control.OnGamepadPressed(button, joystick:getID())
end

--
--

function love.update(dt)
    -- At the top of the function body
    Control.UpdateAll(dt)

    -- Other code

    -- At the bottom of the function body
    Control.CleanInputs()
end
```

### To use inside the update function
Useful for movement commands, e.g. move forward/backward.

When a button is being pressed its key in the buttons table is set to true, otherwise is false, e.g.:

Imagine you are pressing the left button, if you use the command `Utils.PrintTable(control.buttons)` you will get:
```lua
table: 0x557b88a291b0 {
  [buttonB] => false
  [down] => false
  [up] => false
  [left] => true
  [right] => false
  [buttonA] => false
}
```

So you can check if the button is true:
```lua
-- check if control.buttons[button] is down
 if gControl.buttons.left then
    -- move backwards
 end
```

### Check if af button was pressed
Avoid the bouncing, useful for action command like jumping, and toggle commands like pause, e.g.:



```lua
-- check into the pressed buttons table
if gControl:pressed('buttonA') then
    -- perform a jumping action
end
```

Input has its own state that's independent from the instances, all buttons pressed are recorded with `Control.OnKeyboadPressed()` and `Control.OnGamepadPressed()` static methods, and flushed out with `Control.CleanInputs()` method.


