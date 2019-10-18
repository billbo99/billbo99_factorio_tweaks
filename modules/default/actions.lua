local Actions = {}
local Logging = require("utils/logging")
local Func = require("utils/func")
local Print = require("utils/print")
local Event = require('__stdlib__/stdlib/event/event').set_protected_mode(true)


function Actions.UpdateCamera(event)
	for name, camera in pairs(global.cameras) do
		local target_player = Func.getPlayerByName(name)
		camera.position = target_player.position
	end

end

function Actions.DestroyMiniCameraGui(event)
	local player = game.players[event.player_index]
	if player.gui.left["mini_camera"] then
		target_player_name = player.gui.left["mini_camera"].caption
		global.cameras[target_player_name] = nil
		player.gui.left["mini_camera"].destroy()
	end

end

function Actions.CreateMiniCameraGui(event)
	global.cameras = global.cameras or {}
	local player = game.players[event.player_index]
	
	local drop_down = event.element.parent["admin_player_select"]
	local target_player_name = drop_down.items[drop_down.selected_index]
	local target_player = Func.getPlayerByName(target_player_name)

	if player.gui.left["mini_camera"] then Actions.DestroyMiniCameraGui(event) end
	caption = target_player_name
	position = target_player.position

	local frame = player.gui.left.add({type = "frame", name = "mini_camera", caption = caption})
	local camera = frame.add({type = "camera", name = "mini_cam_element", position = position, zoom = 1, surface_index = target_player.surface.index})
	camera.style.minimal_width = 450
	camera.style.minimal_height = 240

	global.cameras[target_player_name] = camera

	Event.register(-1, Actions.UpdateCamera)

end

function Actions.killBiters(event)
	if not Func.isAdmin(game.players[event.player_index]) then return end

	player = game.players[event.player_index]
	game.forces["enemy"].kill_all_units() 
	player.print('Bye bye biters')
end

function Actions.GiveItem(event)
	local player = game.players[event.player_index]
	local element = event.element

	player.insert{name=element.parent["item_picker"].elem_value, count=element.parent["item_amount"].text}
end

function Actions.killLocalSpawners(event)
	if not Func.isAdmin(game.players[event.player_index]) then return end
	
	local player = game.players[event.player_index]
	local element = event.element
	local radius=element.parent['kill_radius_value'].caption or 100
	local area = {{player.position.x - radius, player.position.y - radius}, {player.position.x + radius, player.position.y + radius}}
	local surface = player.surface

	for key, entity in pairs(surface.find_entities_filtered({area=area, force= "enemy"})) do
		entity.destroy()
	end
	player.print('Bye bye Local biters, worms and spawners')
end

function Actions.killSpawners(event)
	if not Func.isAdmin(game.players[event.player_index]) then return end
	
	local player = game.players[event.player_index]
	local surface = player.surface
	for c in surface.get_chunks() do
		for key, entity in pairs(surface.find_entities_filtered({area={{c.x * 32, c.y * 32}, {c.x * 32 + 32, c.y * 32 + 32}}, force= "enemy"})) do
			entity.destroy()
		end
	end
	player.print('Bye bye biters, worms and spawners')
end

function Actions.rechartMap(event)
	if not Func.isAdmin(game.players[event.player_index]) then return end
	
	player = game.players[event.player_index]
	game.forces.player.rechart()
	player.print('Clear the fog for a bit')
end

function Actions.hideAll(event)
	if not Func.isAdmin(game.players[event.player_index]) then return end
	
	local player = game.players[event.player_index]
	local surface = player.surface
	local force = player.force
	for chunk in surface.get_chunks() do
		force.unchart_chunk({x = chunk.x, y = chunk.y}, surface)
	end
	player.print('The world is hidden from eye site')
end

function Actions.chartAll(event)
	if not Func.isAdmin(game.players[event.player_index]) then return end

	player = game.players[event.player_index]
	game.forces.player.chart_all()
	player.print('Let the world be shown')
end

function Actions.chartLocalMap(event)
	if not Func.isAdmin(game.players[event.player_index]) then return end

	local player = game.players[event.player_index]
	local element = event.element
	local radius=element.parent['chart_radius_value'].caption or 100
	local area = {{player.position.x - radius, player.position.y - radius}, {player.position.x + radius, player.position.y + radius}}

	-- player.force.chart(player.surface, {{player.position.x-radius, player.position.y-radius}, {player.position.x+radius, player.position.y+radius}})
	player.force.chart(player.surface, area)
	player.print('Show me what is out there')
end

return Actions