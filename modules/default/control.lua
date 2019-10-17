if not settings.startup["billbo99-default-actions"].value then
    return nil
end

local Event = require('__stdlib__/stdlib/event/event').set_protected_mode(true)

local Default = {}
local Actions = require("modules/default/actions")


-- Flush the players inventory
function Default.ClearPlayerInventories(player)
    player.get_main_inventory().clear()
    player.get_inventory(defines.inventory.character_ammo).clear()
    player.get_inventory(defines.inventory.character_guns).clear()
end

-- On new player created setup some default gear
function Default.OnPlayerCreated(event)
    local player = game.get_player(event.player_index)

    if game.active_mods["IndustrialRevolution"] then
        -- do nothing IR gives its own starting inventory
    else
        Default.ClearPlayerInventories(player)
        if settings.get_player_settings(player)["billbo99-respawn-with-ammo"] and global.SpawnItems["ammo"] then player.insert {name = global.SpawnItems["ammo"], count = 10} end
        if settings.get_player_settings(player)["billbo99-respawn-with-gun"] and global.SpawnItems["gun"] then player.insert {name = global.SpawnItems["gun"], count = 1} end
        if settings.get_player_settings(player)["billbo99-respawn-with-armor"] and global.SpawnItems["armor"] then player.insert {name = global.SpawnItems["armor"], count = 1} end
    
        player.insert {name = "iron-plate", count = 8}
        player.insert {name = "wood", count = 1}
        player.insert {name = "burner-mining-drill", count = 1}
        player.insert {name = "stone-furnace", count = 1}
    end

    player.print({"messages.billbo99-default_start_message"}, global.print_colour)
end

-- On respawn
function Default.OnPlayerRespawned(event)
    local player = game.get_player(event.player_index)
    Default.ClearPlayerInventories(player)
    if global.SpawnItems["gun"] then player.insert {name = global.SpawnItems["gun"], count = 1} end
    if global.SpawnItems["ammo"] then player.insert {name = global.SpawnItems["ammo"], count = 10} end
    if global.SpawnItems["armor"] then player.insert {name = global.SpawnItems["armor"], count = 1} end

    player.print({"messages.billbo99-respawn"}, global.print_colour)
end

-- Once a minute check to see what has been made and change the default spawn gear 
function Default.OnTickDoCheckForSpawnGear()
    Checks = {
        -- gun
        gun_001={priority=001, what_type='gun', what='pistol', what_name='Pistol'},
        gun_002={priority=100, what_type='gun', what='submachine-gun', what_name='Submachine Gun'},
        -- ammo
        ammo_001={priority=001, what_type='ammo', what='firearm-magazine', what_name='Firearms rounds magazine'},
        ammo_002={priority=100, what_type='ammo', what='piercing-rounds-magazine', what_name='Piercing rounds magazine'},
        ammo_003={priority=200, what_type='ammo', what='uranium-ammo', what_name='Uranium rounds magazine'},
        -- armor
        armor_001={priority=001, what_type='armor', what='light-armor', what_name='Light Armor'},
        armor_002={priority=100, what_type='armor', what='heavy-armor', what_name='Heavy Armor'},
        armor_003={priority=200, what_type='armor', what='modular-armor', what_name='Modular Armor'},
        armor_004={priority=300, what_type='armor', what='power-armor', what_name='Power Armor'},
        armor_005={priority=400, what_type='armor', what='power-armor-mk2', what_name='Power Armor MK2'},
    }

    if game.active_mods["IndustrialRevolution"] then
        -- ammo
        Checks.ammo_001={priority=001, what_type='ammo', what='copper-magazine', what_name='Copper Magazine'}
        Checks.ammo_002={priority=100, what_type='ammo', what='iron-magazine', what_name='Iron Magazine'}
        Checks.ammo_003={priority=200, what_type='ammo', what='steel-magazine', what_name='Steel Magazine'}
        Checks.ammo_004={priority=300, what_type='ammo', what='titanium-magazine', what_name='Titanium Magazine'}
        Checks.ammo_005={priority=400, what_type='ammo', what='uranium-magazine', what_name='Uranium Magazine'}
        -- guns
        Checks.gun_003={priority=100, what_type='gun', what='minigun', what_name='Minigun'}
    end

    flag = false
    for k, force in pairs(game.forces) do
        produced = force["item_production_statistics"].input_counts
        for k, v in pairs(Checks) do
            if produced[v.what] and produced[v.what] > global.SpawnItems[v.what_type .. '_threshold'] then
                if v.priority > global.SpawnItems[v.what_type .. '_priority'] then
                    global.SpawnItems[v.what_type] = v.what
                    global.SpawnItems[v.what_type .. '_name'] = v.what_name
                    global.SpawnItems[v.what_type .. '_priority'] = v.priority
                    flag = true
                end
            end
        end
        if flag then 
            list = {}
            if global.SpawnItems.armor_name then table.insert(list, global.SpawnItems.armor_name) end
            if global.SpawnItems.gun_name then table.insert(list, global.SpawnItems.gun_name) end
            if global.SpawnItems.ammo_name then table.insert(list, global.SpawnItems.ammo_name) end
            force.print("Clones will now receive the following on respawn; " .. table.concat(list, ", ") , global.print_colour) 
        end
    end
end

-- Init the mod
function Default.OnInit()
    log("Default.OnInit")
    global.print_colour = {r=255, g=255, b=0}
    global.SpawnItems = global.SpawnItems or {}
    
    global.SpawnItems.gun_threshold = 15
    global.SpawnItems.ammo_threshold = 50
    global.SpawnItems.armor_threshold = 15

    global.SpawnItems.gun = global.SpawnItems.gun or nil
    global.SpawnItems.gun_name = global.SpawnItems.gun_name or nil
    global.SpawnItems.gun_priority = global.SpawnItems.gun_priority or 0
    
    global.SpawnItems.ammo = global.SpawnItems.ammo or nil
    global.SpawnItems.ammo_name = global.SpawnItems.ammo_name or nil
    global.SpawnItems.ammo_priority = global.SpawnItems.ammo_priority or 0
    
    global.SpawnItems.armor = global.SpawnItems.armor or nil
    global.SpawnItems.armor_name = global.SpawnItems.armor_name or nil
    global.SpawnItems.armor_priority = global.SpawnItems.armor_priority or 0

    if game.active_mods["IndustrialRevolution"] then
        if global.SpawnItems.ammo == "firearm-magazine" then 
            global.SpawnItems.ammo = "copper-magazine" 
            global.SpawnItems.ammo_name = "Copper Magazine" 
            global.SpawnItems.ammo_priority = 0
        end
    end

    Default.OnLoad()
end

-- Register default commands
function Default.OnLoad()
    log("Default.OnLoad")
end
        
return Default