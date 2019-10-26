local Print = require("utils/print")
local Func = {}

function Func.starts_with(str, start)
    return str:sub(1, #start) == start
 end

function Func.splitString(s, regex)
    chunks = {}
    count = 0
    if regex == nil then
        regex = "%S+"
    end

    for substring in s:gmatch(regex) do
        count = count + 1
        chunks[count] = substring
    end
    return chunks
end

function Func.getPlayerByName(playerName)
    for _, player in pairs(game.players) do
        if (player.name == playerName) then
            return player
        end
    end
end

function Func.getPlayerInventories(player)
    local invs = {}

    invs['main'] = player.get_inventory(defines.inventory.character_main)
    invs['guns'] = player.get_inventory(defines.inventory.character_guns)
    invs['ammo'] = player.get_inventory(defines.inventory.character_ammo)

    if player.get_inventory(defines.inventory.character_armor) then
        invs['armor'] = player.get_inventory(defines.inventory.character_armor)
    end

    if player.get_inventory(defines.inventory.character_vehicle) then
        invs['vehicle'] = player.get_inventory(defines.inventory.character_vehicle)
    end

    if player.get_inventory(defines.inventory.character_trash) then
        invs['trash'] = player.get_inventory(defines.inventory.character_trash)
    end

    return invs
end


function Func.getItemCount(inventory, itemName)
    local ok, result = pcall(inventory.get_item_count, itemName)
    if ok then
        return result
    else
        return 0
    end
end

function Func.insertItems(inventory, itemName, count)
    local ok, result = pcall(inventory.insert, {name = itemName, count = count})
    if ok then
        return true
    else
        return false
    end
end

function Func.isAdmin(player)
	if (player.admin) then
	   return true
	else
		return false
	end
end

function Func.trustedUsers()
    list = {}
    if settings.startup["billbo99-auto-trusted-permissions"].value ~= nil then
        _trusted_string = string.gsub(settings.startup["billbo99-auto-trusted-permissions"].value, ",", " ")
        local split_by_space = Func.splitString(_trusted_string)
        for k,v in ipairs(split_by_space) do
            list[v] = 'Trusted'
        end
    end
    return list
end

return Func