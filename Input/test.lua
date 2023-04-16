Control = require 'caixa.Input.Control'
local presets = require 'caixa.Input.presets'
Utils = require 'caixa.Utils'

local love = {
    joystick = {
        getJoysticks = function ()
            return { 1, 2 }
        end
    },
    keyboard = {
        isDown = function ()
            return true
        end
    }
}

local control = Control{ position = 1, kbSet = presets.kb1, gpSet = presets.gp1, engine = love, player = 1 }

control:changeInput('kb', 'buttonA', 's')

Utils.printTable(control.inputMap)
