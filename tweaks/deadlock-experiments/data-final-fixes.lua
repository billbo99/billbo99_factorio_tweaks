if not settings.startup["deadlock-experiments"].value then
    return
end

-- deadlock-experiments needs to have its dependencies changed to that it comes after all the other deadlock stacking mods that are out there.

if settings.startup["darkstar"].value then

    local setting_value = settings.startup["experiments-densityoverride"].value
    local deadlock_stack_size = settings.startup["deadlock-stack-size"].value
    
    if setting_value == "match-stack-size" then
        multiplier = settings.startup["deadlock-stack-size"].value
    else
        multiplier = tonumber(setting_value)
    end

    local item_types = {"item"}
    for k, v in pairs(data.raw.item) do
        -- if matches scheme and there's an underlying item then update
        if string.match(k, "deadlock%-stack%-") then
            -- looks like a stacked item, chop off the prefix
            local parent_item = string.sub(k, 16)
            for _, item_type in ipairs(item_types) do
                if data.raw[item_type][parent_item] then
                    -- found parent item - let's resync the stacked item's stack size to the appropriate multiplier of the base item's stack size
                    log(parent_item .. tostring(math.floor((data.raw[item_type][parent_item].stack_size / deadlock_stack_size) * multiplier)))
                    data.raw.item[k].stack_size = math.floor((data.raw[item_type][parent_item].stack_size / deadlock_stack_size) * multiplier)
                end
            end
        end
    end

    -- Darkstar has 25 levels of modules,  need to update the limiation on them all to allow the direct smelting of stacks to get the bonus too.
    for _, recipe in ipairs({"stacked-copper-plate", "stacked-iron-plate", "stacked-stone-brick", "stacked-steel-plate", "deadlock-stacks-stack-gold-plate", "deadlock-stacks-stack-lead-plate"}) do
        for i = 1, 25 do
            local module_name = string.format("productivity-module-%d", i)
            if data.raw.module[module_name] and data.raw.module[module_name].limitation then
                table.insert(data.raw.module[module_name].limitation, recipe)
            end
        end
    end
end
