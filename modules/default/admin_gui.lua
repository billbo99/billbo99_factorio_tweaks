local mod_gui = require("mod-gui")

local AdminGui = {}
local Actions = require("modules/default/actions")

function AdminGui.onPlayerJoinedGame(event)
    local player = game.players[event.player_index]

    if global.game_speed and game.speed ~= global.game_speed then
        game.speed = global.game_speed or 1
        game.print("Game speed set to : " .. tostring(game.speed))
        log("Game speed set to : " .. tostring(game.speed))
    else
        global.game_speed = game.speed
    end

    if player.gui.left["admin_panel"] then
        player.gui.left["admin_panel"].destroy()
    end
    AdminGui.createAdminButton(player)
end

function AdminGui.onPlayerPromoted(event)
    local player = game.players[event.player_index]
    if player.gui.left["admin_panel"] then
        player.gui.left["admin_panel"].destroy()
    end
    AdminGui.createAdminButton(player)
end

function AdminGui.onPlayerDemoted(event)
    local player = game.players[event.player_index]
    if player.gui.left["admin_panel"] then
        player.gui.left["admin_panel"].destroy()
    end
    AdminGui.createAdminButton(player)
end

function AdminGui.createAdminButton(player)
    local button_flow = mod_gui.get_button_flow(player)
    local button = button_flow.admin_button
    if not button then
        button_flow.add {
            type = "sprite-button",
            name = "admin_button",
            sprite = "AdminButton",
            style = mod_gui.button_style
        }
    end
end

function Actions.luaCmdConfirm(event)
    local player = game.players[event.player_index]
    local f, err
    if player.gui.left.admin_panel then
        local cmd = event.element.parent.input.text
        if cmd ~= nil then
            cmd = cmd:gsub("game%.player%.", "game.players[" .. player.index .. "].")
            f, err = loadstring(cmd)
            if not f then
                cmd = "game.players[" .. player.index .. "].print(" .. cmd .. ")"
                f, err = loadstring(cmd)
            end

            event.element.parent.output.text = ""
            event.element.parent.output.style.minimal_height = 60
            _, err = pcall(f)
            if err then
                local text = ""
                text = text .. cmd .. "\n"
                text = text .. "----------------------------------------------------------------------\n"
                text = text .. err:sub(1, err:find("\n"))
                event.element.parent.output.text = text
            end
        end
    end
end

function AdminGui.LuaTab(frame)
    local input = frame.add {type = "text-box", name = "input", style = "input_textbox"}
    input.word_wrap = true
    input.text = global.last_lua_cmd or ""
    input.style.minimal_height = 240
    input.style.minimal_width = 460

    frame.add {
        type = "button",
        name = "lua_cmd_confirm",
        style = "confirm_button",
        caption = "Confirm",
        tooltip = "Confirm"
    }

    local output = frame.add {type = "text-box", name = "output", style = "input_textbox"}
    output.word_wrap = true
    output.text = global.last_lua_cmd or ""
    output.style.minimal_height = 60
    output.style.minimal_width = 460
end

function AdminGui.SpeedTab(frame)
    local f = frame.add {type = "frame", name = "Speed", direction = "vertical", style = mod_gui.frame_style}
    local l = f.add({type = "label", caption = "Speed Control:"})
    f.style.minimal_width = 455
    f.style.maximal_width = 455
    local t = f.add({type = "table", column_count = 3})
    local b1 = t.add({type = "button", caption = "Slow Down", name = "changeSpeedButton", tooltip = "Change the current Game Speed"})
    local s1 = t.add({type = "slider", name = "changeSpeedSlider", value = game.speed, minimum_value = 0.1, maximum_value = 1, value_step = 0.05})
    s1.style.minimal_width = 240
    s1.style.maximal_width = 240
    local l1 = t.add({type = "label", name = "changeSpeedSlider_value", caption = string.format("%.2f", t.changeSpeedSlider.slider_value)})
    ---
    local b2 = t.add({type = "button", caption = "Speed Up", name = "changeSpeedButton2", tooltip = "Change the current Game Speed"})
    local s2 = t.add({type = "slider", name = "changeSpeedSlider2", value = game.speed, minimum_value = 1, maximum_value = 10, value_step = 0.5})
    s2.style.minimal_width = 240
    s2.style.maximal_width = 240
    local l2 = t.add({type = "label", name = "changeSpeedSlider2_value", caption = string.format("%.2f", t.changeSpeedSlider2.slider_value)})
end

function AdminGui.MapTab(frame)
    local f = frame.add {type = "frame", name = "Pollution", direction = "vertical", style = mod_gui.frame_style}
    local l = f.add({type = "label", caption = "Pollution Control:"})
    f.style.minimal_width = 455
    f.style.maximal_width = 455
    local t = f.add({type = "table", column_count = 3})
    local b1 = t.add({type = "button", caption = "Change Evo", name = "changeEvoButton", tooltip = "Change the current value of Evo"})
    local s1 = t.add({type = "slider", name = "changeEvoSlider", value = game.forces["enemy"].evolution_factor, minimum_value = 0, maximum_value = 1, value_step = 0.000001})
    s1.style.minimal_width = 240
    s1.style.maximal_width = 240
    local l1 = t.add({type = "label", name = "changeEvoSlider_value", caption = string.format("%.6f", t.changeEvoSlider.slider_value)})
end

function AdminGui.GeneralTab(frame)
    -- Admin actions I want to be able to do easily
    local f = frame.add {type = "frame", name = "ranged_actions", direction = "horizontal", style = mod_gui.frame_style}
    local l = f.add({type = "label", caption = "Ranged Actions:"})
    f.style.minimal_width = 455
    f.style.maximal_width = 455
    local t = f.add({type = "table", column_count = 3})
    local b1 = t.add({type = "button", caption = "Kill Local Enemy", name = "killLocalSpawners", tooltip = "Kill all biters and spawners in the local area"})
    local s1 = t.add({type = "slider", name = "kill_radius", value = 100, minimum_value = 0, maximum_value = 5000})
    local l1 = t.add({type = "label", name = "kill_radius_value", caption = t.kill_radius.slider_value})
    local b2 = t.add({type = "button", caption = "Chart Local Map", name = "chartLocalMap", tooltip = "Chart the local area"})
    local s2 = t.add({type = "slider", name = "chart_radius", value = 100, minimum_value = 0, maximum_value = 5000})
    local l2 = t.add({type = "label", name = "chart_radius_value", caption = "100"})

    b1.style.font = "default-bold"
    b1.style.width = 160
    s1.style.width = 100

    b2.style.font = "default-bold"
    b2.style.width = 160
    s2.style.width = 100

    -- Admin actions I want to be able to do easily
    local GlobalActions = frame.add {type = "frame", name = "global_actions", direction = "vertical", style = mod_gui.frame_style}
    GlobalActions.style.minimal_width = 455
    GlobalActions.style.maximal_width = 455

    local l = GlobalActions.add({type = "label", caption = "Global Actions:"})
    local t = GlobalActions.add({type = "table", column_count = 3})
    local buttons = {
        t.add({type = "button", caption = "Kill Biters", name = "killBiters", tooltip = "Kill all biters"}),
        t.add({type = "button", caption = "Kill Spawners", name = "killSpawners", tooltip = "Kill all biters and spawners"}),
        t.add({type = "button", caption = "Chart All", name = "chartAll", tooltip = "Chart all the generated chunks"}),
        t.add({type = "button", caption = "Hide All", name = "hideAll", tooltip = "Un-chart all the map"}),
        t.add({type = "button", caption = "ReChart Map", name = "rechartMap", tooltip = "ReChart the map"})
    }
    for _, button in pairs(buttons) do
        button.style.font = "default-bold"
        button.style.width = 140
    end

    local GiveActions = frame.add {type = "frame", name = "Give_actions", direction = "vertical", style = mod_gui.frame_style}
    GiveActions.style.minimal_width = 455
    GiveActions.style.maximal_width = 455

    local l = GiveActions.add({type = "label", caption = "Give items:"})
    local t = GiveActions.add({type = "table", column_count = 3})
    local item_picker = t.add({type = "choose-elem-button", elem_type = "item", item = "small-electric-pole", name = "item_picker"})
    local item_amount = t.add({type = "textfield", text = 1, numeric = true, name = "item_amount", tooltip = "item count"})
    local give_item_button = t.add({type = "button", name = "give_item", caption = "Give", tooltip = "Give items to player"})
end

function AdminGui.createAdminPanel(player)
    if player.gui.left["admin_panel"] then
        player.gui.left["admin_panel"].destroy()
    end

    local admin_panel_frame = player.gui.left.add({type = "frame", name = "admin_panel", direction = "vertical"})
    admin_panel_frame.style.margin = 6

    local tabbed_pane = admin_panel_frame.add({type = "tabbed-pane", name = "tabbed_pane"})

    local tab = tabbed_pane.add({type = "tab", caption = "Speed"})
    local frame = tabbed_pane.add({type = "frame", name = "Speed", direction = "vertical"})
    frame.style.minimal_height = 40
    frame.style.minimal_width = 460
    tabbed_pane.add_tab(tab, frame)
    AdminGui.SpeedTab(frame)

    if player.admin then
        local tab = tabbed_pane.add({type = "tab", caption = "General"})
        local frame = tabbed_pane.add({type = "frame", name = "General", direction = "vertical"})
        frame.style.minimal_height = 240
        frame.style.minimal_width = 460
        tabbed_pane.add_tab(tab, frame)
        AdminGui.GeneralTab(frame)
    end

    if player.admin then
        local tab = tabbed_pane.add({type = "tab", caption = "Map"})
        local frame = tabbed_pane.add({type = "frame", name = "Map", direction = "vertical"})
        frame.style.minimal_height = 240
        frame.style.minimal_width = 460
        tabbed_pane.add_tab(tab, frame)
        AdminGui.MapTab(frame)
    end

    if player.admin then
        local tab = tabbed_pane.add({type = "tab", caption = "Lua"})
        local frame = tabbed_pane.add({type = "frame", name = "Lua", direction = "vertical"})
        frame.style.minimal_height = 240
        frame.style.minimal_width = 460
        tabbed_pane.add_tab(tab, frame)
        AdminGui.LuaTab(frame)
    end
end

function AdminGui.onGuiClick(event)
    local player = game.players[event.player_index]

    local name = event.element.name

    if name == "admin_button" then
        if player.gui.left["admin_panel"] then
            player.gui.left["admin_panel"].destroy()
        else
            AdminGui.createAdminPanel(player)
        end
    elseif AdminGui.admin_functions[name] then
        AdminGui.admin_functions[name](event)
    end
end

function AdminGui.onGuiValueChanged(event)
    local player = game.players[event.player_index]
    local element = event.element

    l = element.name .. "_value"
    if element.parent and element.parent[l] then
        element.parent[l].caption = element.slider_value
    end
end

function AdminGui.onGuiSelectionStateChanged(event)
    local player = game.players[event.player_index]
    local name = event.element.name
end

AdminGui.admin_functions = {
    ["lua_cmd_confirm"] = Actions.luaCmdConfirm,
    ["killBiters"] = Actions.killBiters,
    ["killLocalSpawners"] = Actions.killLocalSpawners,
    ["killSpawners"] = Actions.killSpawners,
    ["rechartMap"] = Actions.rechartMap,
    ["hideAll"] = Actions.hideAll,
    ["chartAll"] = Actions.chartAll,
    ["chartLocalMap"] = Actions.chartLocalMap,
    ["give_item"] = Actions.GiveItem,
    ["changeEvoButton"] = Actions.changeEvo,
    ["changeSpeedButton"] = Actions.changeSpeed,
    ["changeSpeedButton2"] = Actions.changeSpeed
}

return AdminGui
