local Func = require("utils/func")
local Permission = {}

local console = {name = "Console", admin = true, print = function(...)
        rcon.print(...)
    end, color = {1, 1, 1, 1}}

-- Setup permissions for a group
function Permission.set_group_permissions(group, actions, treat_actions_as_blacklist)
    actions = actions or {}
    if treat_actions_as_blacklist then
        for _, a in pairs(defines.input_action) do
            group.set_allows_action(a, true)
        end
        for _, a in pairs(actions) do
            group.set_allows_action(a, false)
        end
    else
        for _, a in pairs(defines.input_action) do
            group.set_allows_action(a, false)
        end
        for _, a in pairs(actions) do
            group.set_allows_action(a, true)
        end
    end
end

function Permission.permissions_init()
    global.permissions = global.permissions or {}

    global.permissions["admin"] = "Admin"
    global.permissions["trusted"] = "Trusted"
    global.permissions["auto_permission_users"] = Func.trustedUsers()

    -- get and create permission groups
    local default = game.permissions.get_group("Default")
    local trusted = game.permissions.get_group(global.permissions["trusted"]) or game.permissions.create_group(global.permissions["trusted"])
    local admin = game.permissions.get_group(global.permissions["admin"]) or game.permissions.create_group(global.permissions["admin"])

    Permission.set_group_permissions(admin, nil, true)

    --For each player logged in make sure they are in the correct permission group
    for k, v in pairs(game.players) do
        if v and v.name then
            if global.permissions and global.permissions["auto_permission_users"] then
                local group = global.permissions["auto_permission_users"][v.name]
                if v.admin and not group then
                    game.permissions.get_group(global.permissions["admin"]).add_player(v)
                else
                    game.permissions.get_group(group).add_player(v)
                end
            end
        end
    end

    -- restrict trusted users from only these actions
    local trusted_actions_blacklist = {
        defines.input_action.admin_action,
        defines.input_action.change_multiplayer_config,
        defines.input_action.add_permission_group,
        defines.input_action.edit_permission_group,
        defines.input_action.delete_permission_group
    }
    Permission.set_group_permissions(trusted, trusted_actions_blacklist, true)

    -- New joins can only use these actions
    local actions = {
        defines.input_action.start_walking,
        defines.input_action.write_to_console
    }

    Permission.set_group_permissions(default, actions)
end

function Permission.OnPlayerJoinedGame(e)
    global.permissions[e.player_index] = global.permissions[e.player_index] or {}

    local player = game.players[e.player_index]
    local group = global.permissions["auto_permission_users"][player.name]
    if player.admin then
        group = global.permissions["admin"]
    elseif group then
        group = group
    else
        group = "Default"
    end

    game.permissions.get_group(group).add_player(player)
    player.print("You are a member of the <" .. group .. "> group", global.print_colour)
end

function Permission.OnPlayerCreated(e)
    if game.players[e.player_index].admin then
        game.permissions.get_group(global.permissions["admin"]).add_player(e.player_index)
    end
end

function Permission.OnPlayerPromoted(e)
    local player = game.players[e.player_index]
    if not global.permissions then
        permissions_init()
    end

    if player.name ~= nil then
        local group = global.permissions["auto_permission_users"][player.name]
        if not group then
            game.permissions.get_group(global.permissions["admin"]).add_player(player)
        elseif group then
            game.permissions.get_group(group).add_player(player)
        end
    end
end

function Permission.OnPlayerDemoted(e)
    game.permissions.get_group("Default").add_player(e.player_index)
end

function Permission.OnConsoleCommand(e)
    local caller = (e.player_index and game.players[e.player_index]) or console
    if caller.admin then
        if (e.command == "kick") or (e.command == "ban") then
            local player = game.players[e.parameters]

            if player and not player.admin then
                game.permissions.get_group("Default").add_player(player)
            end
        end
    end
end

function Permission.ReloadPermissions(e)
    local caller = (e.player_index and game.players[e.player_index]) or console
    if caller.admin then
        Permission.permissions_init()
        caller.print("Permissions reloaded.", global.print_colour)
    else
        caller.print("You must be an admin to run this command.", global.print_colour)
    end
end
commands.add_command("reloadperms", "Reload permissions", Permission.ReloadPermissions)

function Permission.trust_player(caller, player)
    if player then
        if player.admin then
            caller.print("Player is admin.", global.print_colour)
        else
            game.permissions.get_group(global.permissions["trusted"]).add_player(player)
            global.permissions["auto_permission_users"][player.name] = global.permissions["trusted"]
            caller.print("Player now trusted.", global.print_colour)
            player.print("You are now trusted.", global.print_colour)
        end
    else
        caller.print("Player not found.", global.print_colour)
    end
end

function Permission.ListTrusted(e)
    local caller = (e.player_index and game.players[e.player_index]) or console

    list = {}
    for k, v in pairs(game.permissions.get_group(global.permissions["trusted"]).players) do
        list[v.name] = true
    end
    for k, v in pairs(global.permissions["auto_permission_users"]) do
        list[k] = true
    end
    list2 = {}
    for k, v in pairs(list) do
        table.insert(list2, k)
    end

    caller.print("The server trusts these players : " .. table.concat(list2, ", "), global.print_colour)
end
commands.add_command("list_trusted", "List trusted players", Permission.ListTrusted)

function Permission.Trust(e)
    local caller = (e.player_index and game.players[e.player_index]) or console
    if caller.admin then
        local player = e.parameter and game.players[e.parameter]

        Permission.trust_player(caller, player)
    else
        caller.print("You must be an admin to run this command.", global.print_colour)
    end
end
commands.add_command("trust", "Trust a player", Permission.Trust)

return Permission
