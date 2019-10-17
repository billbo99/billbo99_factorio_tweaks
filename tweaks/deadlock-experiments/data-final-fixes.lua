if settings.startup["billbo99-deadlock-experiments"].value and mods["deadlock-experiments"] then
    log("option enabled and mod installed")
else
    return
end

if settings.startup["billbo99-darkstar"].value and mods["darkstar"] then
    require("tweaks.deadlock-experiments.darkstar")
end
