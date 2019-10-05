local Event = require('__stdlib__/stdlib/event/event').set_protected_mode(true)

local Default = require("modules/default/control")
local Permission = require("modules/permissions/control")
local AntiGrief = require("modules/anti-grief/anti-grief")


if Default then 
    Event.register(Event.core_events.init, Default.OnInit) 
    Event.register(Event.core_events.load, Default.OnLoad)
end

if Permission then 
    Event.register(Event.core_events.init, Permission.permissions_init)
    Event.register(Event.core_events.on_configuration_changed, Permission.permissions_init)
    Event.register(defines.events.on_player_joined_game, Permission.OnPlayerJoinedGame)
    Event.register(defines.events.on_player_created, Permission.OnPlayerCreated)
    Event.register(defines.events.on_player_promoted, Permission.OnPlayerPromoted)
    Event.register(defines.events.on_player_demoted, Permission.OnPlayerDemoted)
    Event.register(defines.events.on_console_command, Permission.OnConsoleCommand)

end

if AntiGrief then 
    Event.register(Event.core_events.init, AntiGrief.setDefaultGlobals)
    Event.register(defines.events.on_player_deconstructed_area, AntiGrief.onDeconstruct)
    Event.register(defines.events.on_player_mined_entity, AntiGrief.onMine)
    Event.register(defines.events.on_player_ammo_inventory_changed, AntiGrief.onAmmoChanged)
    Event.register(defines.events.on_entity_died, AntiGrief.onDie)
    Event.register(defines.events.on_player_used_capsule, AntiGrief.onUsedCapsule)
    Event.register(-3600, AntiGrief.onTick)
end
