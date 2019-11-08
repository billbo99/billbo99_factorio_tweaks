local Event = require('__stdlib__/stdlib/event/event').set_protected_mode(true)

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
