if mods["Teleporters"] then
    log("Teleporters mod installed")

    local Teleporters = data.raw["technology"]["teleporter"]
    table.insert(Teleporters.prerequisites, "space-science-pack")
    table.insert(Teleporters.unit.ingredients, {"space-science-pack", 1})
end    
