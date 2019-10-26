local Event = require('__stdlib__/stdlib/event/event').set_protected_mode(true)

local Default = {}
local Actions = require("modules/default/actions")
local Func = require("utils/func")

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
        if settings.get_player_settings(player)["billbo99-respawn-with-primary_gun"] and global.SpawnItems["primary_gun"] then player.insert {name = global.SpawnItems["primary_gun"], count = 1} end
        if settings.get_player_settings(player)["billbo99-respawn-with-primary_ammo"] and global.SpawnItems["primary_ammo"] then player.insert {name = global.SpawnItems["primary_ammo"], count = settings.global["billbo99-primary_ammo_starting_amount"].value} end
        if settings.get_player_settings(player)["billbo99-respawn-with-secondary_gun"] and global.SpawnItems["secondary_gun"] then player.insert {name = global.SpawnItems["secondary_gun"], count = 1} end
        if settings.get_player_settings(player)["billbo99-respawn-with-secondary_ammo"] and global.SpawnItems["secondary_ammo"] then player.insert {name = global.SpawnItems["secondary_ammo"], count = settings.global["billbo99-secondary_ammo_starting_amount"].value} end
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
    if global.SpawnItems["primary_gun"] then player.insert {name = global.SpawnItems["primary_gun"], count = 1} end
    if global.SpawnItems["primary_ammo"] then player.insert {name = global.SpawnItems["primary_ammo"], count = settings.global["billbo99-primary_ammo_starting_amount"].value} end
    if global.SpawnItems["secondary_gun"] then player.insert {name = global.SpawnItems["secondary_gun"], count = 1} end
    if global.SpawnItems["secondary_ammo"] then player.insert {name = global.SpawnItems["secondary_ammo"], count = settings.global["billbo99-secondary_ammo_starting_amount"].value} end
    if global.SpawnItems["armor"] then player.insert {name = global.SpawnItems["armor"], count = 1} end

    player.print({"messages.billbo99-respawn"}, global.print_colour)
end

-- Once a minute check to see what has been made and change the default spawn gear 
function Default.OnTickDoCheckForSpawnGear()
    Checks = {
        -- primary_gun
        primary_gun_001={priority=001, what_type='primary_gun', what='pistol', what_name='Pistol'},
        primary_gun_002={priority=100, what_type='primary_gun', what='submachine-gun', what_name='Submachine Gun'},
        -- primary_ammo
        primary_ammo_001={priority=001, what_type='primary_ammo', what='firearm-magazine', what_name='Firearms rounds magazine'},
        primary_ammo_002={priority=100, what_type='primary_ammo', what='piercing-rounds-magazine', what_name='Piercing rounds magazine'},
        primary_ammo_003={priority=200, what_type='primary_ammo', what='uranium-ammo', what_name='Uranium rounds magazine'},
        -- secondary_gun
        secondary_gun_001={priority=001, what_type='secondary_gun', what='flamethrower', what_name='Flame Thrower'},
        secondary_gun_002={priority=100, what_type='secondary_gun', what='rocket-launcher', what_name='Rocket Launcher'},
        -- secondary_ammo
        secondary_ammo_001={priority=001, what_type='secondary_ammo', what='flamethrower-ammo', what_name='Flame Thrower ammo'},
        secondary_ammo_002={priority=100, what_type='secondary_ammo', what='rocket', what_name='Rocket'},
        secondary_ammo_003={priority=200, what_type='secondary_ammo', what='explosive-rocket', what_name='Explosive Rocket'},
        secondary_ammo_003={priority=300, what_type='secondary_ammo', what='atomic-rocket', what_name='Atomic Rocket'},
        -- armor
        armor_001={priority=001, what_type='armor', what='light-armor', what_name='Light Armor'},
        armor_002={priority=100, what_type='armor', what='heavy-armor', what_name='Heavy Armor'},
        armor_003={priority=200, what_type='armor', what='modular-armor', what_name='Modular Armor'},
        armor_004={priority=300, what_type='armor', what='power-armor', what_name='Power Armor'},
        armor_005={priority=400, what_type='armor', what='power-armor-mk2', what_name='Power Armor MK2'},
    }

    if game.active_mods["IndustrialRevolution"] then
        -- ammo
        Checks.primary_ammo_001={priority=001, what_type='ammo', what='copper-magazine', what_name='Copper Magazine'}
        Checks.primary_ammo_002={priority=100, what_type='ammo', what='iron-magazine', what_name='Iron Magazine'}
        Checks.primary_ammo_003={priority=200, what_type='ammo', what='steel-magazine', what_name='Steel Magazine'}
        Checks.primary_ammo_004={priority=300, what_type='ammo', what='titanium-magazine', what_name='Titanium Magazine'}
        Checks.primary_ammo_005={priority=400, what_type='ammo', what='uranium-magazine', what_name='Uranium Magazine'}
    end

    global.SpawnItems.primary_gun_threshold = settings.global["billbo99-primary_gun_threshold"].value
    global.SpawnItems.secondary_gun_threshold = settings.global["billbo99-secondary_gun_threshold"].value
    global.SpawnItems.primary_ammo_threshold = settings.global["billbo99-primary_ammo_threshold"].value
    global.SpawnItems.secondary_ammo_threshold = settings.global["billbo99-secondary_ammo_threshold"].value
    global.SpawnItems.armor_threshold = settings.global["billbo99-armor_threshold"].value

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
            if global.SpawnItems.primary_gun_name then table.insert(list, global.SpawnItems.primary_gun_name) end
            if global.SpawnItems.primary_ammo_name then table.insert(list, global.SpawnItems.primary_ammo_name) end
            if global.SpawnItems.secondary_gun_name then table.insert(list, global.SpawnItems.secondary_gun_name) end
            if global.SpawnItems.secondary_ammo_name then table.insert(list, global.SpawnItems.secondary_ammo_name) end
            force.print("Clones will now receive the following on respawn; " .. table.concat(list, ", ") , global.print_colour) 
        end
    end
end

-- Init the mod
function Default.OnInit()
    log("Default.OnInit")
    global.print_colour = {r=255, g=255, b=0}
    global.SpawnItems = global.SpawnItems or {}
    
    global.SpawnItems.primary_gun = global.SpawnItems.primary_gun or nil
    global.SpawnItems.primary_gun_name = global.SpawnItems.primary_gun_name or nil
    global.SpawnItems.primary_gun_priority = global.SpawnItems.primary_gun_priority or 0
    
    global.SpawnItems.primary_ammo = global.SpawnItems.primary_ammo or nil
    global.SpawnItems.primary_ammo_name = global.SpawnItems.primary_ammo_name or nil
    global.SpawnItems.primary_ammo_priority = global.SpawnItems.primary_ammo_priority or 0
    
    global.SpawnItems.secondary_gun = global.SpawnItems.secondary_gun or nil
    global.SpawnItems.secondary_gun_name = global.SpawnItems.secondary_gun_name or nil
    global.SpawnItems.secondary_gun_priority = global.SpawnItems.secondary_gun_priority or 0
    
    global.SpawnItems.secondary_ammo = global.SpawnItems.secondary_ammo or nil
    global.SpawnItems.secondary_ammo_name = global.SpawnItems.secondary_ammo_name or nil
    global.SpawnItems.secondary_ammo_priority = global.SpawnItems.secondary_ammo_priority or 0
    
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

function Default.OnConfigurationChanged(event)
    local changed = event.mod_changes and event.mod_changes["billbo99_factorio_tweaks"]
    if changed then -- something to do with your mod
        if not changed.old_version then
            -- your mod was added
        elseif not changed.new_version then
            -- your mod was removed
        else
            -- your mod was updated
        end
    end
end

function Default.OnRuntimeModSettingChanged(event)
    local player = game.get_player(event.player_index)
    local setting = event.setting
    local setting_type = event.setting_type
    if not Func.starts_with(setting, 'billbo99') then return end  -- not a setting we care about presently

    -- lazy time
    global.SpawnItems.primary_gun_threshold = settings.global["billbo99-primary_gun_threshold"].value
    global.SpawnItems.secondary_gun_threshold = settings.global["billbo99-secondary_gun_threshold"].value
    global.SpawnItems.primary_ammo_threshold = settings.global["billbo99-primary_ammo_threshold"].value
    global.SpawnItems.secondary_ammo_threshold = settings.global["billbo99-secondary_ammo_threshold"].value
    global.SpawnItems.armor_threshold = settings.global["billbo99-armor_threshold"].value

end

return Default