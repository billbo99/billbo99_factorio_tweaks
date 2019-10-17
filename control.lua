local Event = require('__stdlib__/stdlib/event/event').set_protected_mode(true)

if settings.startup["billbo99-default-actions"].value then
    local Default = require("modules/default/control")
    if Default then 
        Event.register(Event.core_events.init, Default.OnInit) 
        Event.register(Event.core_events.load, Default.OnLoad)
        Event.register(-3600, Default.OnTickDoCheckForSpawnGear)
        Event.register(defines.events.on_player_created, Default.OnPlayerCreated)
        Event.register(defines.events.on_player_respawned, Default.OnPlayerRespawned)
    end

    local AdminGui = require("modules/default/admin_gui")
    if AdminGui then
        Event.register(defines.events.on_player_joined_game, AdminGui.onPlayerJoinedGame)
        Event.register(defines.events.on_player_promoted, AdminGui.onPlayerPromoted)
        Event.register(defines.events.on_player_demoted, AdminGui.onPlayerDemoted)
        Event.register(defines.events.on_gui_click, AdminGui.onGuiClick)
        Event.register(defines.events.on_gui_selection_state_changed, AdminGui.onGuiSelectionStateChanged)
        Event.register(defines.events.on_gui_value_changed, AdminGui.onGuiValueChanged)
        Event.register(defines.events.on_gui_text_changed, AdminGui.onGuiTextChanged)
    end

end

if settings.startup["billbo99-enable-permissions"].value then
    local Permission = require("modules/permissions/control")
    if Permission then 
        Event.register(Event.core_events.init, Permission.permissions_init)
        Event.register(Event.core_events.on_configuration_changed, Permission.permissions_init)
        Event.register(defines.events.on_player_joined_game, Permission.OnPlayerJoinedGame)
        Event.register(defines.events.on_player_created, Permission.OnPlayerCreated)
        Event.register(defines.events.on_player_promoted, Permission.OnPlayerPromoted)
        Event.register(defines.events.on_player_demoted, Permission.OnPlayerDemoted)
        Event.register(defines.events.on_console_command, Permission.OnConsoleCommand)
    end
end
    
if settings.startup["billbo99-enable-anti-grief"].value then
    local AntiGrief = require("modules/anti-grief/anti-grief")
    if AntiGrief then 
        Event.register(Event.core_events.init, AntiGrief.setDefaultGlobals)
        Event.register(defines.events.on_player_deconstructed_area, AntiGrief.onDeconstruct)
        Event.register(defines.events.on_player_mined_entity, AntiGrief.onMine)
        Event.register(defines.events.on_player_ammo_inventory_changed, AntiGrief.onAmmoChanged)
        Event.register(defines.events.on_entity_died, AntiGrief.onDie)
        Event.register(defines.events.on_player_used_capsule, AntiGrief.onUsedCapsule)
        Event.register(-3600, AntiGrief.onTick)
    end
end
