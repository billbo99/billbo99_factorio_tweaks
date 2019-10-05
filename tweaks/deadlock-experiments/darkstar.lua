-- deadlock-experiments needs to have its dependencies changed to that it comes after all the other deadlock stacking mods that are out there.
if settings.startup["darkstar"].value and mods["darkstar"] then
    log("option enabled and mod installed")
else
    return
end

    -- need to do things with Darkstar ores to get them to work with deadlock
local function add_ore_to_deadlock(ingredient, ingredient_quantity , result, recipe_energy_required)
    local ingredient_density = deadlock.get_item_stack_density(ingredient, "item")
    local recipe = {
        type = "recipe",
        name = "stacked-" .. result,
        category = "smelting",
        energy_required = recipe_energy_required * ingredient_density,
        ingredients = {{ "deadlock-stack-" .. ingredient, ingredient_quantity}},
    }
    if settings.startup["experiments-directsmelting-outputstacks"].value then
        recipe.result = "deadlock-stack-" .. result
    else
        recipe.result = result
        recipe.result_count = ingredient_density
    end
    log(serpent.block(recipe))
    data:extend({recipe})
end

-- helper function to test an array for a value
local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

-- rerun densityoverride logic at the end of all things
local function rerun_densityoverride()
    local setting_value = settings.startup["experiments-densityoverride"].value
    local deadlock_stack_size = settings.startup["deadlock-stack-size"].value
    
    if setting_value == "match-stack-size" then
        multiplier = settings.startup["deadlock-stack-size"].value
    else
        multiplier = tonumber(setting_value)
    end

    local item_types = {"item"}
    for k, v in pairs(data.raw.item) do
        if string.match(k, "deadlock%-stack%-") then
            local parent_item = string.sub(k, 16)
            for _, item_type in ipairs(item_types) do
                if data.raw[item_type][parent_item] then
                    data.raw.item[k].stack_size = math.floor((data.raw[item_type][parent_item].stack_size / deadlock_stack_size) * multiplier)
                    log(item_type .. " .. " .. parent_item .. " .. " .. tostring(data.raw.item[k].stack_size))
                end
            end
        end
    end
end

if settings.startup["darkstar"].value then
    deadlock.add_stack("sand", nil, "deadlock-stacking-1", 32, "item")

    add_ore_to_deadlock("sand", 5, "glass", 18.5)
    add_ore_to_deadlock("gold-ore", 2, "gold-plate", 7.5)
    add_ore_to_deadlock("lead-ore", 2, "lead-plate", 9.5)

    rerun_densityoverride()

    -- Darkstar has 25 levels of modules,  need to update the limitation on them all to allow the direct smelting of stacks to get the bonus too.
    for _, recipe in ipairs({"stacked-copper-plate", "stacked-iron-plate", "stacked-stone-brick", "stacked-steel-plate", "stacked-gold-plate", "stacked-lead-plate", "stacked-glass"}) do
        for i = 1, 25 do
            local module_name = string.format("productivity-module-%d", i)
            if data.raw.recipe[recipe] and data.raw.module[module_name] and data.raw.module[module_name].limitation then
                if not has_value(data.raw.module[module_name].limitation, recipe) then
                    table.insert(data.raw.module[module_name].limitation, recipe)
                end
            end
        end
    end
end
