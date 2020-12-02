local AdminGui = require("modules/default/admin_gui")
if AdminGui then
    script.on_event(defines.events.on_player_joined_game, AdminGui.onPlayerJoinedGame)
    script.on_event(defines.events.on_player_promoted, AdminGui.onPlayerPromoted)
    script.on_event(defines.events.on_player_demoted, AdminGui.onPlayerDemoted)
    script.on_event(defines.events.on_gui_click, AdminGui.onGuiClick)
    script.on_event(defines.events.on_gui_selection_state_changed, AdminGui.onGuiSelectionStateChanged)
    script.on_event(defines.events.on_gui_value_changed, AdminGui.onGuiValueChanged)
    script.on_event(defines.events.on_gui_text_changed, AdminGui.onGuiTextChanged)
end

local function OnPrePlayerLeftGame(e)
    global.game_speed = game.speed
    if #game.connected_players == 1 then
        game.speed = 0.1
        game.print("Game speed set to : " .. tostring(game.speed))
        log("Game speed set to : " .. tostring(game.speed))
    end
end

script.on_event(defines.events.on_pre_player_left_game, OnPrePlayerLeftGame)
