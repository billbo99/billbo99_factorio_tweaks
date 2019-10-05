local Func = require("utils/func")
local Print = require("utils/print")
local AntiGrief = {}

function AntiGrief.setDefaultGlobals()
    global.antigrief = {
        whitelistTable = {},
        guardMode = "block",
        maxArea = 1000,
        godTable = {},
        deconstructGuard = true,
        spamTime = 60 * 60, -- Limit related message rate,
        cooldowns = {},
        autoTime = -1
    }
    if global["trusted_users"] then
        for k, v in pairs(global["trusted_users"]) do
            log(k)
            global.antigrief.whitelistTable[k] = true
        end
    end
end

-- cooldowns on alerts to limit spam.
function AntiGrief.checkCooldown(playerName, action)
    if (not global.antigrief.cooldowns[playerName]) then
        global.antigrief.cooldowns[playerName] = {}
    end
    if (not global.antigrief.cooldowns[playerName][action]) then
        global.antigrief.cooldowns[playerName][action] = game.tick + global.antigrief.spamTime
        return true
    elseif (global.antigrief.cooldowns[playerName][action] > game.tick) then
        return false
    else
        global.antigrief.cooldowns[playerName][action] = game.tick + global.antigrief.spamTime
        return true
    end
end

-- god mode
function AntiGrief.toggleGod(playerName)
    if (playerName == nil) then
        playerName = game.player.name
    end
    local player = Func.getPlayerByName(playerName)
    if (player == nil) then
        game.player.print("Player " .. playerName .. " does not exist.")
        return
    end
    if (global.antigrief.godTable[playerName]) then
        global.antigrief.godTable[playerName] = nil
        AntiGrief.disableGod(player)
    else
        global.antigrief.godTable[playerName] = true
        AntiGrief.enableGod(player)
    end
end
function AntiGrief.enableGod(player)
    player.cheat_mode = true
    if (player.character ~= nil) then
        player.character.destroy()
        player.character = nil
        player.print("You are now in god mode!")
    end
end
function AntiGrief.disableGod(player)
    player.cheat_mode = false
    player.create_character()
    player.print("You are no longer in god mode.")
end
Func.addCommand("god", "player> - Toggles god mode for a player.", AntiGrief.toggleGod)

-- remove all decontruct marking
function AntiGrief._removeAllDeconstruct(force, surface, area)
    if (area == nil) then
        for key, entity in pairs(surface.find_entities()) do
            if entity.to_be_deconstructed(force) then
                entity.cancel_deconstruction(force)
            end
        end
    else
        for key, entity in pairs(surface.find_entities(area)) do
            if entity.to_be_deconstructed(force) then
                entity.cancel_deconstruction(force)
            end
        end
    end
end

function AntiGrief.removeAllDeconstruct()
    Print.ToAll("Admin " .. game.player.name .. " is removing a deconstruct grief, please wait...")
    AntiGrief._removeAllDeconstruct(game.player.force, game.player.surface)
    Print.ToAll("Deconstruct grief removed by " .. game.player.name)
end
commands.add_command("ungrief", " - Removes all deconstruct markers.", AntiGrief.removeAllDeconstruct)

-- deconstruct guard
function AntiGrief.deconstructGuardToggle()
    if (global.antigrief.deconstructGuard) then
        global.antigrief.deconstructGuard = false
        game.player.print("deconstructGuard disabled.")
    else
        global.antigrief.deconstructGuard = true
        game.player.print("deconstructGuard enabled.")
    end
end
commands.add_command("gtoggle", "Toggle deconstructGuard.", AntiGrief.deconstructGuardToggle)

function AntiGrief.guardWarn(offendingPlayer, width, height)
    Print.ToAdmins(offendingPlayer.name .. " deconstructed a large area! (" .. width .. " x " .. height .. ")")
    Print.ToAdmins("An admin must type /gwhitelist " .. offendingPlayer.name .. " to mute these alerts.")
end

function AntiGrief.guardBlock(offendingPlayer, area, width, height)
    offendingPlayer.print("You cannot deconstruct that.")
    Print.ToAdmins(
        offendingPlayer.name .. " attempted to deconstruct a large area! (" .. width .. " x " .. height .. ")",
        offendingPlayer.name
    )
    Print.ToAdmins("An admin must type /gwhitelist " .. offendingPlayer.name .. " to allow this.")
    AntiGrief._removeAllDeconstruct(offendingPlayer.force, offendingPlayer.surface, area)
end

function AntiGrief.onDeconstruct(event)
    if (not global.antigrief) then
        AntiGrief.setDefaultGlobals()
    end
    if (event.item ~= "deconstruction-planner") then
        return
    end

    local area = event.area
    local width = area.right_bottom.x - area.left_top.x
    local height = area.right_bottom.y - area.left_top.y
    local areaNum = width * height
    if (areaNum <= 0) then
        return
    end

    local offendingPlayer = game.players[event.player_index]

    if (global.antigrief.whitelistTable[offendingPlayer.name]) then
        return
    end

    if (areaNum > global.antigrief.maxArea) then
        if (global.antigrief.guardMode == "warning") then
            AntiGrief.guardWarn(offendingPlayer, width, height)
        end
        if (global.antigrief.guardMode == "block") then
            AntiGrief.guardBlock(offendingPlayer, area, width, height)
        end
    end

    -- check for pumps being marked
    local entities =
        offendingPlayer.surface.find_entities_filtered {
        area = area,
        force = offendingPlayer.force,
        name = "offshore-pump"
    }
    for key, entity in pairs(entities) do
        if entity.to_be_deconstructed(offendingPlayer.force) then
            Print.ToAdmins(offendingPlayer.name .. " marked an offshore pump for deconstruct!")
            return
        end
    end
end

-- set maximum allowed deconstruct area (0 for none)
function AntiGrief.setArea(area)
    if (area == nil) then
        game.player.print("Must provide an argument")
        return
    end
    numArea = tonumber(area)

    if (numArea == nil) then
        game.player.print("First argument must be a number.")
        return
    end
    if (numArea == 0) then
        numArea = 0.001
    end

    Print.ToAdmins(game.player.name .. " set the max deconstruct area to " .. area)
    global.antigrief.maxArea = numArea
end
commands.add_command("garea", "<area> - Set the maxmimum area to trigger deconstructGuard.", AntiGrief.setArea)

-- whitelist a player to deconstruct
function AntiGrief.addToWhitelist(name)
    local player = Func.getPlayerByName(name)
    if player == nil then
        return
    end

    if (name == nil) then
        name = game.player.name
    end
    who = game.player
    if who == nil then
        who = "SERVER"
    else
        who = who.name
    end
    Print.ToAdmins(who .. " deconstruct whitelisted " .. name)
    local player = Func.getPlayerByName(name)
    if (player ~= nil) then
        player.print("You may now deconstruct freely.")
    end
    global.antigrief.whitelistTable[name] = true
end
commands.add_command("gwhitelist", "<player> - Whitelist a player to deconstruct large areas.", AntiGrief.addToWhitelist)

-- blacklist a player to deconstruct
function AntiGrief.addToBlacklist(name)
    if (name == nil) then
        name = game.player.name
    end
    Print.ToAdmins(game.player.name .. " deconstruct blacklisted " .. name)
    local player = Func.getPlayerByName(name)
    if (player ~= nil) then
        player.print("You may no longer deconstruct freely.")
    end
    global.antigrief.whitelistTable[name] = nil
end
commands.add_command("gblacklist", "<player> - Blacklist a player from deconstructing large areas.", AntiGrief.addToBlacklist)

-- print the whitelist
function AntiGrief.printWhitelist()
    local any = false
    local list = {}
    for name, allowed in pairs(global.antigrief.whitelistTable) do
        if allowed then
            any = true
            table.insert(list, name)
        end
    end
    if not any then
        game.player.print("No players are deconstruct whitelisted.")
    else
        game.player.print("Players who are deconstruct whitelisted: " .. table.concat(list, ", "))
    end
end
commands.add_command("glist", "- Show players who are whitelisted to deconstruct.", AntiGrief.printWhitelist)

-- set guard mode
function AntiGrief.setGuardMode(mode)
    if (mode == nil) then
        game.player.print('Must provide a deconstruct guard mode. Use "/gmode block" or "/gmode warning"')
        return
    end
    if (mode ~= "warning" and mode ~= "block") then
        game.player.print('Invalid deconstruct guard mode. Use "/gmode block" or "/gmode warning"')
        return
    end
    global.antigrief.guardMode = mode
    Print.ToAdmins("Deconstruct guard mode set to " .. mode)
end
commands.add_command("gmode", "<mode> - Set mode of deconstructGuard. warning or block.", AntiGrief.setGuardMode)

-- search inventories
function AntiGrief.searchInv(itemName)
    if (itemName == nil) then
        game.player.print("Must specify an item name.")
    end
    local found = false
    for _, player in pairs(game.players) do
        local sum = 0
        for _, inv in pairs(Func.getPlayerInventories(player)) do
            sum = sum + Func.getItemCount(inv, itemName)
        end
        if (sum > 0) then
            found = true
            game.player.print(player.name .. " has " .. sum .. " " .. itemName .. "!")
        end
    end
    if (not found) then
        game.player.print("No player has that item.")
    end
end
commands.add_command("search", "<itemName> - Search all player inventories for an item", AntiGrief.searchInv)

-- give item
function AntiGrief.giveItem(itemName, count, playerName)
    if (itemName == nil) then
        game.player.print("Must specify an item name.")
        return
    end
    local numCount = tonumber(count)
    if (numCount == nil) then
        numCount = 1
    end
    if (playerName == nil) then
        playerName = game.player.name
    end
    local player = Func.getPlayerByName(playerName)
    if (player == nil) then
        game.player.print("Player " .. playerName .. " does not exist.")
        return
    end

    local ok = Func.insertItems(player, itemName, numCount)
    if (ok) then
        Print.ToAdmins(game.player.name .. " gave " .. player.name .. " " .. numCount .. " " .. itemName)
    else
        game.player.print("Invalid item name.")
    end
end
commands.add_command("give", "<itemName> <count> <player> - Give a player items.", AntiGrief.giveItem)

-- warning on pump mining
function AntiGrief.isWellPump(entity)
    return entity.name == "offshore-pump"
end

function AntiGrief.isNuclearReactor(entity)
    return entity.name == "nuclear-reactor"
end

function AntiGrief.isRocketSilo(entity)
    return entity.name == "rocket-silo"
end

-- removing blueprint
function AntiGrief.isBlueprint(entity)
    return entity.type == "entity-ghost"
end

function AntiGrief.onMine(event)
    if (not global.antigrief) then
        AntiGrief.setDefaultGlobals()
    end
    if not event.entity and not event.entity.valid then
        return
    end

    local player = game.players[event.player_index]
    local entity = event.entity
    if (global.antigrief.whitelistTable[player.name]) then
        return
    end

    if (AntiGrief.isWellPump(entity)) then
        if (AntiGrief.checkCooldown(player.name, "pump")) then
            Print.ToAdmins(player.name .. " has mined a well pump.")
        end
    elseif (AntiGrief.isNuclearReactor(entity)) then
        if (AntiGrief.checkCooldown(player.name, "reactor")) then
            Print.ToAdmins(player.name .. " has mined a nuclear reactor.")
        end
    elseif (AntiGrief.isRocketSilo(entity)) then
        if (AntiGrief.checkCooldown(player.name, "silo")) then
            Print.ToAdmins(player.name .. " has mined a rocket silo")
        end
    elseif (AntiGrief.isBlueprint(entity)) then
        if (AntiGrief.checkCooldown(player.name, "blueprint")) then
            Print.ToAdmins(player.name .. " removed a blueprint ghost.")
        end
    end
end

-- equip an atomic bomb
function AntiGrief.onAtomic(event)
    local player = game.players[event.player_index]

    if (global.antigrief.whitelistTable[player.name]) then
        return
    end

    if player.get_item_count("atomic-bomb") > 0 then
        if AntiGrief.checkCooldown(player.name, "atomic") then
            Print.ToAdmins(player.name .. " has equipped an Atomic Bomb.")
        end
    end
end

-- equip artillery remote
function AntiGrief.onArtRemote(event)
    local player = game.players[event.player_index]

    if (global.antigrief.whitelistTable[player.name]) then
        return
    end

    if player.cursor_stack.valid_for_read and player.cursor_stack.name == "artillery-targeting-remote" then
        if AntiGrief.checkCooldown(player.name, "artillery-remote") then
            Print.ToAdmins(player.name .. " has equipped an Artillery Remote.")
        end
    end
end

function AntiGrief.onAmmoChanged(event)
    if (not global.antigrief) then
        AntiGrief.setDefaultGlobals()
    end
    AntiGrief.onArtRemote(event)
    AntiGrief.onAtomic(event)
end

-- general destruction
function AntiGrief.onDie(event)
    if (not global.antigrief) then
        AntiGrief.setDefaultGlobals()
    end
    if not (event.entity and event.entity.valid) then
        return
    end
    if not (event.cause and event.cause.type == "player") then
        return
    end
    local player = event.cause.player

    if (player == nill or (not player.valid)) then -- player kills themselves
        return
    end

    local entity = event.entity

    if (global.antigrief.whitelistTable[player.name]) then
        return
    end

    if (player.force == entity.force) then
        if (AntiGrief.isWellPump(event.entity)) then
            if (AntiGrief.checkCooldown(player.name, "pump")) then
                Print.ToAdmins(player.name .. " has destroyed a well pump.")
            end
        elseif (AntiGrief.isNuclearReactor(event.entity)) then
            if (AntiGrief.checkCooldown(player.name, "reactor")) then
                Print.ToAdmins(player.name .. " has destroyed a nuclear reactor.")
            end
        elseif (AntiGrief.isRocketSilo(event.entity)) then
            if (AntiGrief.checkCooldown(player.name, "silo")) then
                Print.ToAdmins(player.name .. " has destroyed a rocket silo.")
            end
        elseif AntiGrief.checkCooldown(player.name, "destroy") then
            Print.ToAdmins(player.name .. " is destroying friendly entities.")
        end
    end
end

-- set spam timer
function AntiGrief.setSpamTimer(time)
    if (time == nil) then
        game.player.print("Must provide an argument.")
        return
    end
    numTime = tonumber(time)
    if (numTime == nil) then
        game.player.print("First argument must be a number.")
        return
    end
    global.antigrief.spamTime = numTime * 60
    Print.ToAdmins("Set the spam limit to 1 related message per " .. time .. " seconds.")
end
commands.add_command("setspamtime", "<time> - Time (in seconds) to limit related messages (default 60s).", AntiGrief.setSpamTimer)

function AntiGrief.setAutoTime(time)
    if (time == nil) then
        game.player.print("Must provide an argument.")
        return
    end
    numTime = tonumber(time)
    if (numTime == nil) then
        game.player.print("First argument must be a number.")
        return
    end
    if (numTime < 0) then
        global.antigrief.autoTime = -1
        Print.ToAdmins("Disabled automatic whitelisting.")
    else
        global.antigrief.autoTime = numTime * 60 * 60
        Print.ToAdmins("Set the auto-whitelist time to " .. time .. " minutes.")
    end
end
commands.add_command("gauto", "<time> - Time (in minutes) until automatic whitelist (-1 is OFF).", AntiGrief.setAutoTime)

function AntiGrief.onTick()
    if (not global.antigrief) then
        AntiGrief.setDefaultGlobals()
    end
    if (global.antigrief.autoTime < 0) then -- -1 means disabled
        return
    end
    for _, player in pairs(game.players) do
        if ((not global.antigrief.whitelistTable[player.name]) and player.online_time > global.antigrief.autoTime) then
            if (player ~= nil and player.valid) then
                player.print("You may now deconstruct freely.")
                Print.ToAdmins(
                    player.name ..
                        " has been automatically whitelisted. (Online for " ..
                            global.antigrief.autoTime / (60 * 60) .. " minutes)"
                )
                global.antigrief.whitelistTable[player.name] = true
            end
        end
    end
end

function AntiGrief.onUsedCapsule(event)
    local player = game.players[event.player_index]
    if (not (player and player.valid)) then
        return
    end

    if (event.item.name == "artillery-targeting-remote") then
        if (AntiGrief.checkCooldown(player.name, "artillery")) then
            Print.ToAdmins(player.name .. " is using an artillery remote.")
        end
    elseif (event.item.name == "grenade" or event.item.name == "cluster-grenade") then
        if (AntiGrief.checkCooldown(player.name, "grenade")) then
            Print.ToAdmins(player.name .. " is using grenades.")
        end
    end
end

return AntiGrief
