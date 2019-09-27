local Actions = {}
local Logging = require("utils/logging")
local Commands = require("utils/commands")
local Func = require("utils/func")

function Actions.killBiters(event)
	if not Func.isAdmin(game.players[event.player_index]) then return end
	game.forces["enemy"].kill_all_units() 
	Func.printToAll('Bye bye biters')
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
	Func.printToAll('Bye bye biters, worms and spawners')
end

function Actions.rechartMap(event)
	if not Func.isAdmin(game.players[event.player_index]) then return end
	
	game.forces.player.rechart()
	Func.printToAll('Clear the fog for a bit')
end

function Actions.hideAll(event)
	if not Func.isAdmin(game.players[event.player_index]) then return end
	
	local player = game.players[event.player_index]

	local surface = player.surface
	local force = player.force
	for chunk in surface.get_chunks() do
		force.unchart_chunk({x = chunk.x, y = chunk.y}, surface)
	end
	Func.printToAll('The world is hidden from eye site')
end

function Actions.chartAll(event)
	if not Func.isAdmin(game.players[event.player_index]) then return end

	game.forces.player.chart_all()
	Func.printToAll('Let the world be shown')
end

function Actions.chartLocalMap(event)
	if not Func.isAdmin(game.players[event.player_index]) then return end

	local player = game.players[event.player_index]
	local radius=320
	if event.parameter then
		radius = event.parameter
	end
	player.force.chart(player.surface, {{player.position.x-radius, player.position.y-radius}, {player.position.x+radius, player.position.y+radius}})
	Func.printToAll('Show me what is out there')
end

function Actions.register_commands()
	Commands.Register("killBiters", {"api-description.default_action_killBiters"}, Actions.killBiters, true)
	Commands.Register("killSpawners", {"api-description.default_action_killSpawners"}, Actions.killSpawners, true)
	Commands.Register("rechartMap", {"api-description.default_action_rechartMap"}, Actions.rechartMap, true)
	Commands.Register("hideAll", {"api-description.default_action_hideAll"}, Actions.hideAll, true)
	Commands.Register("chartAll", {"api-description.default_action_chartAll"}, Actions.chartAll, true)
	Commands.Register("chartLocalMap", {"api-description.default_action_chartLocalMap"}, Actions.chartLocalMap, true)
end

return Actions