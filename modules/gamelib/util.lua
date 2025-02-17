function postostring(pos)
    return pos.x .. ' ' .. pos.y .. ' ' .. pos.z
end

function dirtostring(dir)
    for k, v in pairs(Directions) do
        if v == dir then
            return k
        end
    end
end

function comma_value(n)
    local left, num, right = string.match(n, '^([^%d]*%d)(%d*)(.-)$')
    return left .. (num:reverse():gsub('(%d%d%d)', '%1,'):reverse()) .. right
end

function tableToJson(tbl, indent)
    if not indent then indent = 0 end
    local result, spaces = {}, string.rep(" ", indent)
    table.insert(result, "{\n")
    for k, v in pairs(tbl) do
        local formattedKey = type(k) == "string" and '"' .. k .. '"' or k
        local formattedValue = v
        if type(v) == "table" then
            formattedValue = tableToJson(v, indent + 2)
        elseif type(v) == "string" then
            formattedValue = '"' .. v .. '"'
        elseif type(v) == "boolean" then
            formattedValue = v and "true" or "false"
        elseif type(v) == "function" then
            formattedValue = '"<function>"'  -- Replace function with placeholder
        elseif type(v) == "userdata" then
            formattedValue = '"<userdata>"'  -- Handle userdata safely
        elseif type(v) == "thread" then
            formattedValue = '"<thread>"'
        elseif type(v) == "nil" then
            formattedValue = "null"
        end
        table.insert(result, spaces .. "  " .. formattedKey .. ": " .. tostring(formattedValue) .. ",\n")
    end
    table.insert(result, spaces .. "}\n")
    return table.concat(result)
end


function printTable(t, indent)
	if type(t) == "table" then
		print(tableToJson(t, indent))
	else
		print("object is not a table")
	end
end