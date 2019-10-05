if settings.startup["deadlock-experiments"].value and mods["deadlock-experiments"] then
    log("option enabled and mod installed")
else
    return
end

if settings.startup["darkstar"].value and mods["darkstar"] then
    require("tweaks.deadlock-experiments.darkstar")
end
