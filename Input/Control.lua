Class = require 'hump.class'
local presets = require 'caixa.Input.presets'
local engine;

if love then
    engine = love
end

---This the global state, used with static methods
local state = {
    inputPressed = { gp = {}, kb = {} },
    controls = {},
    joysticks = {},
}

local Control = Class{}

---Instantiate Control
---@param def table
---
function Control:init(def)
    if engine == nil then
        error('No engine detected')
    end

    self.position = def.position or 1
    local kbSet = def.kbSet or presets.kb1
    local gpSet = def.gpSet or presets.gp1
    self.player = def.player

    self.buttons = {
        up = false,
        right = false,
        down = false,
        left = false,
        buttonA = false,
        buttonB = false,
    }

    state.joysticks = engine.joystick.getJoysticks()

    self.joystick = state.joysticks[self.position]
    self.inputMap = Control.GenInputMap(kbSet, gpSet)

    Control.RegisterControl(self.player, self)
end

---Use this to update an input like key,button etc
---@generic Button : string
---@param type 'kb'|'gp' Keyboard or Gamepad
---@param button Button
---@param input string
---
function Control:changeInput(type, button, input)
    self.inputMap[button][type] = input
end

---Use this inside the update function
---@param dt number delta time
---
function Control:update(dt)
    for key, _ in pairs(self.inputMap) do
        self:updateInput(key)
    end
end

function Control:updateInput(key)
    if self:keyboardDown(key) or self:gamepadDown(key) then
        self.buttons[key] = true
    else
        self.buttons[key] = false
    end
end

---Check whether the button was pressed
---@generic Button : string
---@param button Button
---@return boolean
---
function Control:pressed(button)
    local mappedKey = self.inputMap[button].kb
    local mappedButton = self.inputMap[button].gp

    for key, value in pairs(state.inputPressed.kb) do
        if key == mappedKey then
            return true
        end
    end

    if state.inputPressed.gp[self.position] then
        for key, value in pairs(state.inputPressed.gp[self.position]) do
            if key == mappedButton then
                return true
            end
        end
    end

    return false
end

---Check if any keyboard key pressed matches any input
---@generic Button : string
---@param button Button
---@return boolean | nil
---
function Control:keyboardDown(button)
    local key = self.inputMap[button].kb

    return key and engine.keyboard.isDown(key)
end

---Check if any gamepad button pressed math any input
---@generic Button : string
---@param button Button
---@return boolean | nil
---
function Control:gamepadDown(button)
    if not self.joystick then return end

    local key = self.inputMap[button].gp

    return key and self.joystick:isGamepadDown(key)
end

---------------------------- Static methods --------------------------------

---(static) Perform all controls' update function at once.
---Use it at the top of the main update function.
---
---@param dt number delta time in second fractions
---
function Control.UpdateAll(dt)
    for _, control in pairs(state.controls) do
        control:update(dt)
    end
end

---(static) Try to get all joysticks from the engine and assign them to the
---respective registered players
---
---Used when browsers starts the game before registering the joysticks.
---
function Control.RegisterJoysticks()
    print 'Registering joysticks'
    state.joysticks = engine.joystick.getJoysticks()

    for _, control in pairs(state.controls) do
        control.joystick = state.joysticks[control.position]
    end
end

---(static) Create a InputMap
---@generic InputMap : table
---@generic Preset : table
---@param kbSet Preset keyboard preset
---@param gpSet Preset gamepad preset
---@return InputMap
---
function Control.GenInputMap(kbSet, gpSet)
    local inputMap = {}

    for label, key in pairs(kbSet) do
        inputMap[label] = inputMap[label] or {}
        inputMap[label].kb = key
    end

    for label, key in pairs(gpSet) do
        inputMap[label] = inputMap[label] or {}
        inputMap[label].gp = key
    end

    return inputMap
end

function Control.RegisterControl(player, control)
    state.controls[player] = control
end

function Control.RemoveControl(player)
    state.controls[player] = nil
end

---(static) Returns a control instance associated to a string
---@generic Control
---@param player string the player who instantiated the control
---@return Control|nil
---
function Control.GetControl(player)
    for key, control in pairs(state.controls) do
        if not player then
            return control
        end

        if key == player then
            return control
        end
    end

    return nil
end

---(static) Use this with gamepadpressed
---@generic Button : string
---@param button Button
---@param position number this is the joystick number
---
function Control.OnGamepadPressed(button, position)
    local gp = state.inputPressed.gp
    gp[position] = gp[position] or {}

    gp[position][button] = true

    if #state.joysticks == 0 then
        Control.RegisterJoysticks()
    end
end

---(static) Use this with keypressed
---@param key string
---
function Control.OnKeyboardPressed(key)
    state.inputPressed.kb[key] = true
end

function Control.Pressed(button, player)
    local control = Control.GetControl(player)

    if control == nil then
        return error('No control found for ' .. player)
    end

    return control:pressed(button)
end

---(static) Clean the tables for recording pressed buttons.
---Use it at the end of the main update function
---
function Control.CleanInputs()
    state.inputPressed = { gp = {}, kb = {} }
end

function Control.SetEngine(newEngine)
    engine = newEngine
end

return Control
