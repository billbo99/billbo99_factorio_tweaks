if not settings.startup["default-actions"].value then
    return
end

local Actions = require("tweaks/default/actions")
local Commands = require("utils/commands")

-- Flush the players inventory
local function ClearPlayerInventories(player)
    player.get_main_inventory().clear()
    player.get_inventory(defines.inventory.character_ammo).clear()
    player.get_inventory(defines.inventory.character_guns).clear()
end

-- On new player created setup some default gear
local function OnPlayerCreated(event)
    local player = game.get_player(event.player_index)

    ClearPlayerInventories(player)
    player.insert {name = global.SpawnItems["gun"], count = 1}
    player.insert {name = global.SpawnItems["ammo"], count = 10}
    player.insert {name = "iron-plate", count = 8}
    player.insert {name = "wood", count = 1}
    player.insert {name = "burner-mining-drill", count = 1}
    player.insert {name = "stone-furnace", count = 1}

    player.print({"messages.default_start_message"})
end

-- On respawn
local function OnPlayerRespawned(event)
    local player = game.get_player(event.player_index)
    ClearPlayerInventories(player)
    player.insert {name = global.SpawnItems["gun"], count = 1}
    player.insert {name = global.SpawnItems["ammo"], count = 10}

    player.print({"messages.respawn"})
end

-- On research completed see if we should change the default starting gear
local function OnResearchFinished(event)
    local technology = event.research
    if technology.name == "military" then
        global.SpawnItems["gun"] = "submachine-gun"
    elseif technology.name == "military-2" then
        global.SpawnItems["ammo"] = "piercing-rounds-magazine"
    elseif technology.name == "uranium-ammo" then
        global.SpawnItems["ammo"] = "uranium-rounds-magazine"
    end
end

-- Init the mod
local function OnInit()
    global.SpawnItems = global.SpawnItems or {}
    global.SpawnItems["gun"] = global.SpawnItems["gun"] or "pistol"
    global.SpawnItems["ammo"] = global.SpawnItems["ammo"] or "firearm-magazine"
    OnLoad()
end

-- Register default commands
local function OnLoad()
    Actions.register_commands()
end

-- Register functions for known events
script.on_init(OnInit)
script.on_load(OnLoad)
script.on_event(defines.events.on_player_created, OnPlayerCreated)
script.on_event(defines.events.on_player_respawned, OnPlayerRespawned)
script.on_event(defines.events.on_research_finished, OnResearchFinished)
script.on_event(defines.events.on_player_joined_game, OnPlayerJoinedGame)
