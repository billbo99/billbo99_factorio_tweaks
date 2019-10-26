if mods["IndustrialRevolution"] then
    log("option enabled and mod installed")
else
    return
end

local Deadlock = require("utils/deadlock")
deadlock.add_stack("coal", nil, "deadlock-stacking-1", 32, "item")
deadlock.add_stack("stone", nil, "deadlock-stacking-1", 32, "item")
deadlock.add_stack("tin-ore", nil, "deadlock-stacking-1", 32, "item")
deadlock.add_stack("copper-ore", nil, "deadlock-stacking-1", 32, "item")
deadlock.add_stack("iron-ore", nil, "deadlock-stacking-2", 32, "item")
deadlock.add_stack("gold-ore", nil, "deadlock-stacking-2", 32, "item")

Deadlock.DensityOverride()
