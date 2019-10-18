require "mod-gui"

local AdminGui = {}
local Actions = require("modules/default/actions")

local admin_functions = {
    ["killBiters"] = Actions.killBiters,
    ["killLocalSpawners"] = Actions.killLocalSpawners,
    ["killSpawners"] = Actions.killSpawners,
    ["rechartMap"] = Actions.rechartMap,
    ["hideAll"] = Actions.hideAll,
    ["chartAll"] = Actions.chartAll,
    ["chartLocalMap"] = Actions.chartLocalMap,
    ["spy"] = Actions.CreateMiniCameraGui,
    ["give_item"] = Actions.GiveItem,
}

function AdminGui.onPlayerJoinedGame(event)
    local player = game.players[event.player_index]
	if player.admin == true then
		AdminGui.createAdminButton(player)
	end
end

function AdminGui.onPlayerPromoted(event)
	local player = game.players[event.player_index]
	AdminGui.createAdminButton(player)
end

function AdminGui.onPlayerDemoted(event)
	local player = game.players[event.player_index]
	if player.gui.top["admin_button"] then player.gui.top["admin_button"].destroy() end
	if player.gui.left["admin_panel"] then player.gui.left["admin_panel"].destroy() end
	if player.gui.left["mini_camera"] then Actions.DestroyMiniCameraGui(event) end
end

function AdminGui.createAdminButton(player)
	if player.gui.top["admin_button"] then return end
	local b = player.gui.top.add({type = "button", caption = "Admin", name = "admin_button", tooltip = "Use your powers wisely"})
	b.style.font_color = {r = 0.1, g = 0.1, b = 0.1}
	b.style.font = "default-bold"
	b.style.minimal_height = 38
	b.style.minimal_width = 54
	b.style.top_padding = 2
	b.style.left_padding = 4
	b.style.right_padding = 4
	b.style.bottom_padding = 2
end

function AdminGui.createAdminPanel(player)	
    if player.gui.left["admin_panel"] then player.gui.left["admin_panel"].destroy() end

    local player_names = {}	
	for _, p in pairs(game.connected_players) do		
		table.insert(player_names, tostring(p.name))		
	end	
	-- table.insert(player_names, "Select Player")

    local frame = player.gui.left.add({type = "frame", name = "admin_panel", direction = "vertical"})

    -- Create a combo box for all connected players in the game
	local selected_index = #player_names
	if global.admin_panel_selected_player_index then
		if global.admin_panel_selected_player_index[player.name] then
			if player_names[global.admin_panel_selected_player_index[player.name]] then
				selected_index = global.admin_panel_selected_player_index[player.name]
			end
		end
	end

	local PlayerActions = frame.add{type="frame", name="player_actions", direction = "vertical", style=mod_gui.frame_style} 
	PlayerActions.style.minimal_width = 455
	PlayerActions.style.maximal_width = 455

    local l = PlayerActions.add({type = "label", caption = "Player Actions:"})
	local t = PlayerActions.add({type = "table", name="player_actions_table", column_count = 3})

	local drop_down = t.add({type = "drop-down", name = "admin_player_select", items = player_names, selected_index = selected_index})
	drop_down.style.right_padding = 12
	drop_down.style.left_padding = 12
	drop_down.style.width = 140

	local buttons = {
		t.add({type = "button", enabled=true, caption = "Spy", name = "spy", tooltip = "Create a mini-cam to watch a player."}),
		-- t.add({type = "button", enabled=false, caption = "Trust", name = "trust", tooltip = "Trust a player"}),
		-- t.add({type = "button", enabled=false, caption = "Un-Trust", name = "untrust", tooltip = "Stop trusting a player"}),
		-- t.add({type = "button", enabled=false, caption = "Bring Player", name = "bring_player", tooltip = "Teleports the selected player to your position."}),
		-- t.add({type = "button", enabled=false, caption = "Go to Player", name = "go_to_player", tooltip = "Teleport yourself to the selected player."}),
		-- t.add({type = "button", enabled=false, caption = "gwhitelist", name = "gwhitelist", tooltip = "gwhitelist"}),
		-- t.add({type = "button", enabled=false, caption = "gblacklist", name = "gblacklist", tooltip = "gblacklist"}),
	}
	for _, button in pairs(buttons) do
		button.style.font = "default-bold"
		button.style.width = 140
	end

	-- Admin actions I want to be able to do easily
	local f = frame.add{type="frame", name="ranged_actions", direction = "horizontal", style=mod_gui.frame_style} 
    local l = f.add({type = "label", caption = "Ranged Actions:"})
	f.style.minimal_width = 455
	f.style.maximal_width = 455
	local t = f.add({type = "table", column_count = 3})
	b1 = t.add({type = "button", caption = "Kill Local Enemy", name = "killLocalSpawners", tooltip = "Kill all biters and spawners in the local area"})
	s1 = t.add{type = "slider", name='kill_radius', value = 100, minimum_value=0, maximum_value=500}
	l1 = t.add({type = "label", name='kill_radius_value', caption = t.kill_radius.slider_value})
	b2 = t.add({type = "button", caption = "Chart Local Map", name = "chartLocalMap", tooltip = "Chart the local area"})
	s2 = t.add{type = "slider", name='chart_radius', value = 100, minimum_value=0, maximum_value=500}
	l2 = t.add({type = "label", name='chart_radius_value', caption = "100"})

	b1.style.font = "default-bold"
	b1.style.width = 160
	s1.style.width = 100

	b2.style.font = "default-bold"
	b2.style.width = 160
	s2.style.width = 100


    -- Admin actions I want to be able to do easily
	local GlobalActions = frame.add{type="frame", name="global_actions", direction = "vertical", style=mod_gui.frame_style} 
	GlobalActions.style.minimal_width = 455
	GlobalActions.style.maximal_width = 455

	local l = GlobalActions.add({type = "label", caption = "Global Actions:"})
	local t = GlobalActions.add({type = "table", column_count = 3})
	local buttons = {
		t.add({type = "button", caption = "Kill Biters", name = "killBiters", tooltip = "Kill all biters"}),
		t.add({type = "button", caption = "Kill Spawners", name = "killSpawners", tooltip = "Kill all biters and spawners"}),
		t.add({type = "button", caption = "Chart All", name = "chartAll", tooltip = "Chart all the generated chunks"}),
		t.add({type = "button", caption = "Hide All", name = "hideAll", tooltip = "Un-chart all the map"}),
		t.add({type = "button", caption = "ReChart Map", name = "rechartMap", tooltip = "ReChart the map"}),
	}
	for _, button in pairs(buttons) do
		button.style.font = "default-bold"
		button.style.width = 140
	end

	local GiveActions = frame.add{type="frame", name="Give_actions", direction = "vertical", style=mod_gui.frame_style} 
	GiveActions.style.minimal_width = 455
	GiveActions.style.maximal_width = 455

	local l = GiveActions.add({type = "label", caption = "Give items:"})
	local t = GiveActions.add({type = "table", column_count = 3})
	item_picker = t.add({type = "choose-elem-button", elem_type = "item", item='small-electric-pole', name = "item_picker"})
	item_amount = t.add({type = "textfield", text = 1, numeric = true, name = "item_amount", tooltip = 'item count'})
	give_item_button = t.add({type = "button", name = "give_item", caption = "Give", tooltip = 'Give items to player'})

end

function AdminGui.onGuiClick(event)
    local player = game.players[event.player_index]
	
	local name = event.element.name
	
	if name == "admin_button" then		
		if player.gui.left["admin_panel"] then 
			if not global.admin_panel_selected_player_index then global.admin_panel_selected_player_index = {} end
			global.admin_panel_selected_player_index[player.name] = player.gui.left["admin_panel"]["player_actions"]["player_actions_table"]["admin_player_select"].selected_index

            player.gui.left["admin_panel"].destroy()
            if player.gui.left["mini_camera"] then Actions.DestroyMiniCameraGui(event) end
        else
            AdminGui.createAdminPanel(player)
        end
	end
	if admin_functions[name] then
		admin_functions[name](event)
    end

end

function AdminGui.onGuiTextChanged(event)
    local player = game.players[event.player_index]
	local name = event.element.name
	player.print("AdminGui.onGuiTextChanged")
	player.print(name)
end

function AdminGui.onGuiValueChanged(event)
    local player = game.players[event.player_index]
	local name = event.element.name
	-- player.print("AdminGui.onGuiValueChanged")
	-- player.print(name)
end

function AdminGui.onGuiValueChanged(event)
    local player = game.players[event.player_index]
	local element = event.element

	l = element.name .. '_value'
	if element.parent and element.parent[l] then
		element.parent[l].caption = element.slider_value
	end

end

function AdminGui.onGuiSelectionStateChanged(event)
    local player = game.players[event.player_index]
	local name = event.element.name

	if name == "admin_player_select" and event.element.selected_index then
		event.element.parent['spy'].enabled = true
	end

end

return AdminGui