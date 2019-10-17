if settings.startup["billbo99-IndustrialRevolution"].value and mods["IndustrialRevolution"] then
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

-- Deadlock.add_ore_to_deadlock("tin-ore", {{amount = 12, name = "deadlock-stack-tin-ore", type = "item"}}, "tin-ingot", 12, 38.4, "b-tin-ingot-a")
-- Deadlock.add_ore_to_deadlock("copper-ore", {{amount = 12, name = "deadlock-stack-copper-ore", type = "item"}}, "copper-ingot", 12, 38.4, "a-copper-ingot-a")
-- Deadlock.add_ore_to_deadlock("iron-ore", {{amount = 12, name = "deadlock-stack-iron-ore", type = "item"}}, "iron-ingot", 12, 38.4, "c-iron-ingot-a")
-- Deadlock.add_ore_to_deadlock("gold-ore", {{amount = 12, name = "deadlock-stack-gold-ore", type = "item"}}, "gold-ingot", 12, 38.4, "d-gold-ingot-a")

-- deadlock.add_stack("tin-gravel", nil, "deadlock-stacking-1", 32, "item")
-- deadlock.add_stack("copper-gravel", nil, "deadlock-stacking-1", 32, "item")
-- deadlock.add_stack("iron-gravel", nil, "deadlock-stacking-2", 32, "item")
-- deadlock.add_stack("gold-gravel", nil, "deadlock-stacking-2", 32, "item")

-- Deadlock.add_ore_to_deadlock("tin-gravel", {{amount = 10, name = "deadlock-stack-tin-gravel", type = "item"}}, "tin-ingot", 12, 38.4, "b-tin-ingot-b")
-- Deadlock.add_ore_to_deadlock("copper-gravel", {{amount = 10, name = "deadlock-stack-copper-gravel", type = "item"}}, "copper-ingot", 12, 38.4, "a-copper-ingot-b")
-- Deadlock.add_ore_to_deadlock("iron-gravel", {{amount = 10, name = "deadlock-stack-iron-gravel", type = "item"}}, "iron-ingot", 12, 38.4, "c-iron-ingot-b")
-- Deadlock.add_ore_to_deadlock("gold-gravel", {{amount = 10, name = "deadlock-stack-gold-gravel", type = "item"}}, "gold-ingot", 12, 38.4, "d-gold-ingot-b")

-- deadlock.add_stack("tin-pure", nil, "deadlock-stacking-1", 32, "item")
-- deadlock.add_stack("copper-pure", nil, "deadlock-stacking-1", 32, "item")
-- deadlock.add_stack("iron-pure", nil, "deadlock-stacking-2", 32, "item")
-- deadlock.add_stack("gold-pure", nil, "deadlock-stacking-2", 32, "item")

-- Deadlock.add_ore_to_deadlock("tin-pure", {{amount = 8, name = "deadlock-stack-tin-pure", type = "item"}}, "tin-ingot", 12, 38.4, "b-tin-ingot-c")
-- Deadlock.add_ore_to_deadlock("copper-pure", {{amount = 8, name = "deadlock-stack-copper-pure", type = "item"}}, "copper-ingot", 12, 38.4, "a-copper-ingot-c")
-- Deadlock.add_ore_to_deadlock("iron-pure", {{amount = 8, name = "deadlock-stack-iron-pure", type = "item"}}, "iron-ingot", 12, 38.4, "c-iron-ingot-c")
-- Deadlock.add_ore_to_deadlock("gold-pure", {{amount = 8, name = "deadlock-stack-gold-pure", type = "item"}}, "gold-ingot", 12, 38.4, "d-gold-ingot-c")

-- deadlock.add_stack("tin-powder", nil, "deadlock-stacking-1", 32, "item")
-- deadlock.add_stack("copper-powder", nil, "deadlock-stacking-1", 32, "item")
-- deadlock.add_stack("iron-powder", nil, "deadlock-stacking-2", 32, "item")
-- deadlock.add_stack("gold-powder", nil, "deadlock-stacking-2", 32, "item")

-- Deadlock.add_ore_to_deadlock("tin-powder", {{amount = 6, name = "deadlock-stack-tin-powder", type = "item"}}, "tin-ingot", 12, 38.4, "b-tin-ingot-d")
-- Deadlock.add_ore_to_deadlock("copper-powder", {{amount = 6, name = "deadlock-stack-copper-powder", type = "item"}}, "copper-ingot", 12, 38.4, "a-copper-ingot-d")
-- Deadlock.add_ore_to_deadlock("iron-powder", {{amount = 6, name = "deadlock-stack-iron-powder", type = "item"}}, "iron-ingot", 12, 38.4, "c-iron-ingot-d")
-- Deadlock.add_ore_to_deadlock("gold-powder", {{amount = 6, name = "deadlock-stack-gold-powder", type = "item"}}, "gold-ingot", 12, 38.4, "d-gold-ingot-d")

-- deadlock.add_stack("tin-scrap", nil, "deadlock-stacking-1", 32, "item")
-- deadlock.add_stack("copper-scrap", nil, "deadlock-stacking-1", 32, "item")
-- deadlock.add_stack("iron-scrap", nil, "deadlock-stacking-2", 32, "item")
-- deadlock.add_stack("gold-scrap", nil, "deadlock-stacking-2", 32, "item")

-- Deadlock.add_ore_to_deadlock("tin-scrap", {{amount = 4, name = "deadlock-stack-tin-scrap", type = "item"}}, "tin-ingot", 12, 38.4, "b-tin-ingot-e")
-- Deadlock.add_ore_to_deadlock("copper-scrap", {{amount = 4, name = "deadlock-stack-copper-scrap", type = "item"}}, "copper-ingot", 12, 38.4, "a-copper-ingot-e")
-- Deadlock.add_ore_to_deadlock("iron-scrap", {{amount = 4, name = "deadlock-stack-iron-scrap", type = "item"}}, "iron-ingot", 12, 38.4, "c-iron-ingot-e")
-- Deadlock.add_ore_to_deadlock("gold-scrap", {{amount = 4, name = "deadlock-stack-gold-scrap", type = "item"}}, "gold-ingot", 12, 38.4, "d-gold-ingot-e")

-- deadlock.add_stack("bronze-scrap", nil, "deadlock-stacking-1", 32, "item")
-- Deadlock.add_ore_to_deadlock("bronze-alloying", {{amount = 8, name = "deadlock-stack-copper-ingot", type = "item"}, {amount = 4, name = "deadlock-stack-tin-ingot", type = "item"}}, "bronze-ingot", 12, 19.2, "e-bronze-ingot-a")
-- Deadlock.add_ore_to_deadlock("bronze-scrap", {{amount = 4, name = "deadlock-stack-bronze-scrap", type = "item"}}, "bronze-ingot", 12, 19.2, "e-bronze-ingot-b")

Deadlock.DensityOverride()

-- for _, recipe in ipairs({"stacked-copper-ingot", "stacked-tin-ingot", "stacked-iron-ingot", "stacked-gold-ingot"}) do
--     for i = 1, 25 do
--         local module_name = string.format("productivity-module-%d", i)
--         if data.raw.recipe[recipe] and data.raw.module[module_name] and data.raw.module[module_name].limitation then
--             if not Deadlock.has_value(data.raw.module[module_name].limitation, recipe) then
--                 table.insert(data.raw.module[module_name].limitation, recipe)
--             end
--         end
--     end
-- end
