
--[[
    Based on Recursive table printing function.
    https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
    Adapted for allowing to select how deep it goes
]]

---Print recursively
---
---Based on Recursive table printing function. https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
---Adapted by Diego Viniegra for allowing to select how deep it goes
---@param t table
---@param level? integer
local function printTable(t, level)
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

return {
    printTable = printTable,
}