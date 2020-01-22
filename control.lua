local AdminGui = require("modules/default/admin_gui")
if AdminGui then
    -- script.on_init(Spawn.OnInit)
    -- script.on_load(Spawn.OnLoad)

    -- script.on_nth_tick(1800, Spawn.OnTickDoCheckForSpawnGear)

    -- script.on_event(defines.events.on_player_created, Spawn.OnPlayerCreated)

    script.on_event(defines.events.on_player_joined_game, AdminGui.onPlayerJoinedGame)
    script.on_event(defines.events.on_player_promoted, AdminGui.onPlayerPromoted)
    script.on_event(defines.events.on_player_demoted, AdminGui.onPlayerDemoted)
    script.on_event(defines.events.on_gui_click, AdminGui.onGuiClick)
    script.on_event(defines.events.on_gui_selection_state_changed, AdminGui.onGuiSelectionStateChanged)
    script.on_event(defines.events.on_gui_value_changed, AdminGui.onGuiValueChanged)
    script.on_event(defines.events.on_gui_text_changed, AdminGui.onGuiTextChanged)
end
