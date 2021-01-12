local Actions = {}
local Func = require("utils/func")

function Actions.changeSpeed(event)
    local player = game.players[event.player_index]
    local element = event.element
    local speed = 1
    if element.name == "changeSpeedButton" then
        speed = element.parent["changeSpeedSlider_value"].caption or 1
    elseif element.name == "changeSpeedButton2" then
        speed = element.parent["changeSpeedSlider2_value"].caption or 1
    end
    game.speed = speed
    global.game_speed = speed

    game.print("Game Speed set to .. " .. game.speed .. " .. by " .. player.name)
end

function Actions.changeEvo(event)
    if not Func.isAdmin(game.players[event.player_index]) then
        return
    end

    local player = game.players[event.player_index]
    local element = event.element
    local factor = element.parent["changeEvoSlider_value"].caption or 0.0001
    game.forces["enemy"].evolution_factor = factor
    player.print("Evo set to .. " .. game.forces["enemy"].evolution_factor)
end

function Actions.killBiters(event)
    if not Func.isAdmin(game.players[event.player_index]) then
        return
    end

    local player = game.players[event.player_index]
    game.forces["enemy"].kill_all_units()
    player.print("Bye bye biters")
end

function Actions.GiveItem(event)
    local player = game.players[event.player_index]
    local element = event.element

    player.insert {name = element.parent["item_picker"].elem_value, count = element.parent["item_amount"].text}
end

function Actions.killLocalSpawners(event)
    if not Func.isAdmin(game.players[event.player_index]) then
        return
    end

    local player = game.players[event.player_index]
    local element = event.element
    local radius = element.parent["kill_radius_value"].caption or 100
    local area = {{player.position.x - radius, player.position.y - radius}, {player.position.x + radius, player.position.y + radius}}
    local surface = player.surface

    for key, entity in pairs(surface.find_entities_filtered({area = area, force = "enemy"})) do
        entity.destroy()
    end
    player.print("Bye bye Local biters, worms and spawners")
end

function Actions.killSpawners(event)
    if not Func.isAdmin(game.players[event.player_index]) then
        return
    end

    local player = game.players[event.player_index]
    local surface = player.surface
    for c in surface.get_chunks() do
        for key, entity in pairs(surface.find_entities_filtered({area = {{c.x * 32, c.y * 32}, {c.x * 32 + 32, c.y * 32 + 32}}, force = "enemy"})) do
            entity.destroy()
        end
    end
    player.print("Bye bye biters, worms and spawners")
end

function Actions.rechartMap(event)
    if not Func.isAdmin(game.players[event.player_index]) then
        return
    end

    local player = game.players[event.player_index]
    game.forces.player.rechart()
    player.print("Clear the fog for a bit")
end

function Actions.hideAll(event)
    if not Func.isAdmin(game.players[event.player_index]) then
        return
    end

    local player = game.players[event.player_index]
    local surface = player.surface
    local force = player.force
    for chunk in surface.get_chunks() do
        force.unchart_chunk({x = chunk.x, y = chunk.y}, surface)
    end
    player.print("The world is hidden from eye site")
end

function Actions.chartAll(event)
    if not Func.isAdmin(game.players[event.player_index]) then
        return
    end

    local player = game.players[event.player_index]
    game.forces.player.chart_all()
    player.print("Let the world be shown")
end

function Actions.chartLocalMap(event)
    if not Func.isAdmin(game.players[event.player_index]) then
        return
    end

    local player = game.players[event.player_index]
    local element = event.element
    local radius = element.parent["chart_radius_value"].caption or 100
    local area = {{player.position.x - radius, player.position.y - radius}, {player.position.x + radius, player.position.y + radius}}

    -- player.force.chart(player.surface, {{player.position.x-radius, player.position.y-radius}, {player.position.x+radius, player.position.y+radius}})
    player.force.chart(player.surface, area)
    player.print("Show me what is out there")
end

return Actions
