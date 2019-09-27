local Func = {}

function Func.splitString(s)
    chunks = {}
    count = 0
    for substring in s:gmatch("%S+") do
        count = count + 1
        chunks[count] = substring
    end
    return chunks
end

function Func.printToAll(message)
    for _, player in pairs(game.players) do
        player.print(message)
    end
end

function Func.printToAdmins(message)
    for _, player in pairs(game.players) do
        if (player.admin) then
            player.print(message)
        end
    end
end

function Func.printToAllBut(message, excludeName)
    for _, player in pairs(game.players) do
        if (player.name ~= excludeName) then
            player.print(message)
        end
    end
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

function Func.unqique_list(list_to_fix)
	local hash = {}
	for _,v in ipairs(list_to_fix) do
		hash[v] = true
	end

	-- transform keys back into values
	local res = {}
	for k,_ in pairs(hash) do
		res[#res+1] = k
	end
	return res
end

return Func