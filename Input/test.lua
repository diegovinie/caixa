Control = require 'Input.Control'
local presets = require 'Input.presets'

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

function print_r(t, level)
    level = level or (1 / 0)
    local print_r_cache = {}
    local function sub_print_r(t, indent, l)
        if (print_r_cache[tostring(t)]) then
            print(indent .. "*" .. tostring(t))
        else
            print_r_cache[tostring(t)] = true
            if (type(t) == "table") then
                for pos, val in pairs(t) do
                    if (type(val) == "table" and l < level) then
                        print(indent .. "[" .. pos .. "] => " .. tostring(t) .. " {")
                        sub_print_r(val, indent .. string.rep(" ", string.len(pos) + 8), l + 1)
                        print(indent .. string.rep(" ", string.len(pos) + 6) .. "}")
                    elseif (type(val) == "string") then
                        print(indent .. "[" .. pos .. '] => "' .. val .. '"')
                    else
                        print(indent .. "[" .. pos .. "] => " .. tostring(val))
                    end
                end
            else
                print(indent .. tostring(t))
            end
        end
    end
    if (type(t) == "table") then
        print(tostring(t) .. " {")
        sub_print_r(t, "  ", 0)
        print("}")
    else
        sub_print_r(t, "  ", 0)
    end
    print()
end

local control = Control{ position = 1, kbSet = presets.kb1, gpSet = presets.gp1, engine = love, player = 1 }

control:changeInput('kb', 'buttonA', 's')

print_r(control.inputMap)

