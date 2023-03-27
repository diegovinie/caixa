Class = require 'hump.class'
local presets = require 'love2dControl.presets'

---This the global state, used with static methods
local state = {
    inputPressed = { gp = {}, kb = {} },
    controls = {}
}

local Control = Class{}

---Instantiate Control
---@param def table
---
function Control:init(def)
    self.position = def.position or 1
    self.up = false
    self.right = false
    self.down = false
    self.left = false
    self.buttonA = false
    self.buttonB = false
    local kbSet = def.kbSet or presets.kb1
    local gpSet = def.gpSet or presets.gp1
    self.engine = def.engine
    self.player = def.player

    local joysticks = self.engine.joystick.getJoysticks()

    self.joystick = joysticks[self.position]
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
        self[key] = true
    else
        self[key] = false
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

    return key and self.engine.keyboard.isDown(key)
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

function Control.UpdateAll(dt)
    for _, control in pairs(state.controls) do
        control:update(dt)
    end
end

---Create a InputMap
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

function Control.GetControl(player)
    for key, control in pairs(state.controls) do
        if not player then
            return control
        end

        if key == player then
            return control
        end
    end
end

---Use this with gamepadpressed
---@generic Button : string
---@param button Button
---@param position number this is the joystick number
---
function Control.RegisterGamepad(button, position)
    -- print(position)
    local gp = state.inputPressed.gp
    gp[position] = gp[position] or {}
    -- print_r(gp)
    gp[position][button] = true

end

---Use this with keypressed
---@param key string
---
function Control.RegisterKeyboard(key)
    state.inputPressed.kb[key] = true
end

function Control.Pressed(button, player)
    local control = Control.GetControl(player)

    return control:pressed(button)
end

function Control.CleanInputs()
    state.inputPressed = { gp = {}, kb = {} }
end

return Control
