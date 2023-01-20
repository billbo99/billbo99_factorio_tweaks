local Print = {}

function Print.ToAll(message)
    for _, player in pairs(game.players) do
        player.print(message, global.print_colour)
    end
end

function Print.ToAdmins(message)
    for _, player in pairs(game.players) do
        if (player.admin) then
            player.print(message, global.print_colour)
        end
    end
end

function Print.ToAllBut(message, excludeName)
    for _, player in pairs(game.players) do
        if (player.name ~= excludeName) then
            player.print(message, global.print_colour)
        end
    end
end

return Print