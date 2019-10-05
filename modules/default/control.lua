if not settings.startup["default-actions"].value then
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

    Default.ClearPlayerInventories(player)
    player.insert {name = global.SpawnItems["gun"], count = 1}
    player.insert {name = global.SpawnItems["ammo"], count = 10}
    player.insert {name = "iron-plate", count = 8}
    player.insert {name = "wood", count = 1}
    player.insert {name = "burner-mining-drill", count = 1}
    player.insert {name = "stone-furnace", count = 1}

    player.print({"messages.default_start_message"}, global.print_colour)
end

-- On respawn
function Default.OnPlayerRespawned(event)
    local player = game.get_player(event.player_index)
    Default.ClearPlayerInventories(player)
    player.insert {name = global.SpawnItems["gun"], count = 1}
    player.insert {name = global.SpawnItems["ammo"], count = 10}

    player.print({"messages.respawn"}, global.print_colour)
end

-- On research completed see if we should change the default starting gear
function Default.OnResearchFinished(event)
    local technology = event.research
    if technology.name == "military" then
        global.SpawnItems["gun"] = "submachine-gun"
    elseif technology.name == "military-2" then
        global.SpawnItems["ammo"] = "piercing-rounds-magazine"
    elseif technology.name == "uranium-ammo" then
        global.SpawnItems["ammo"] = "uranium-rounds-magazine"
    end
    game.print("Clones will now receive: " .. global.SpawnItems["gun"] .. " and " .. global.SpawnItems["ammo"] .. " on respawn", global.print_colour)
end

-- Init the mod
function Default.OnInit()
    log("Default.OnInit")
    global.print_colour = {r=255, g=255, b=0}
    global.SpawnItems = global.SpawnItems or {}
    global.SpawnItems["gun"] = global.SpawnItems["gun"] or "pistol"
    global.SpawnItems["ammo"] = global.SpawnItems["ammo"] or "firearm-magazine"
    Default.OnLoad()
end

-- Register default commands
function Default.OnLoad()
    log("Default.OnLoad")
    Actions.register_commands()
end
        
Event.register(defines.events.on_player_created, Default.OnPlayerCreated)
Event.register(defines.events.on_player_respawned, Default.OnPlayerRespawned)
Event.register(defines.events.on_research_finished, Default.OnResearchFinished)

return Default