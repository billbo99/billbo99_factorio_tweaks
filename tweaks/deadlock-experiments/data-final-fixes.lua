if not settings.startup["deadlock-experiments"].value then
    return
end

-- need to do things with sand for Darkstar
local function add_sand_to_deadlock()
    deadlock.add_stack("sand", nil, "deadlock-stacking-1", 32, "item")
    local sand_density = deadlock.get_item_stack_density("sand", "item")
    local sand = {
        type = "recipe",
        name = "stacked-glass",
        category = "smelting",
        energy_required = 18.5 * sand_density,
        ingredients = {{ "deadlock-stack-sand", 5}},
    }
    data:extend({sand})
    if settings.startup["experiments-directsmelting-outputstacks"].value then
        sand.result = "deadlock-stack-glass"
    else
        sand.result = "glass"
        sand.result_count = sand_density
    end

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
                end
            end
        end
    end
end

-- deadlock-experiments needs to have its dependencies changed to that it comes after all the other deadlock stacking mods that are out there.
if settings.startup["darkstar"].value then
    add_sand_to_deadlock()
    rerun_densityoverride()

    -- Darkstar has 25 levels of modules,  need to update the limitation on them all to allow the direct smelting of stacks to get the bonus too.
    for _, recipe in ipairs({"stacked-copper-plate", "stacked-iron-plate", "stacked-stone-brick", "stacked-steel-plate", "deadlock-stacks-stack-gold-plate", "deadlock-stacks-stack-lead-plate", "stacked-glass"}) do
        for i = 1, 25 do
            local module_name = string.format("productivity-module-%d", i)
            if data.raw.module[module_name] and data.raw.module[module_name].limitation then
                if not has_value(data.raw.module[module_name].limitation, recipe) then
                    table.insert(data.raw.module[module_name].limitation, recipe)
                end
            end
        end
    end
end
