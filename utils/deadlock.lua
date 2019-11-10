local Deadlock = {}

-- helper function to test an array for a value
function Deadlock.has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function Deadlock.DensityOverride()
    multiplier = settings.startup["deadlock-stack-size"].value

    local item_types = {"item"}
    for k, v in pairs(data.raw.item) do
        if string.match(k, "deadlock%-stack%-") then
            local parent_item = string.sub(k, 16)
            for _, item_type in ipairs(item_types) do
                if data.raw[item_type][parent_item] then
                    data.raw.item[k].stack_size = data.raw[item_type][parent_item].stack_size
                    log(item_type .. " .. " .. parent_item .. " .. " .. tostring(data.raw.item[k].stack_size))
                end
            end
        end
    end
end

function Deadlock.FixResearchTree(dataset)
    -- find what recipe is unlocked by each research
    item_unlocked_by_tech = {}
    for tech, tech_table in pairs(data.raw["technology"]) do
        if tech_table.effects then
            for _, effect in pairs(tech_table.effects) do
                if effect.type and effect.type == "unlock-recipe" then
                    recipe = effect.recipe
                    if data.raw.recipe[recipe] then
                        Recipe = data.raw.recipe[recipe]
                        if Recipe.results then
                            results = Recipe.results
                        elseif Recipe.result then
                            results = {{name=Recipe.result}}
                        elseif Recipe.normal.results then
                            results = Recipe.normal.results
                        elseif Recipe.normal.result then
                            results = {{name=Recipe.normal.result}}
                        else
                            log('how did I get no recipe result for .. '..recipe)
                        end
                        for _, result in pairs(results) do
                            if result.name then
                                if not item_unlocked_by_tech[result.name] then item_unlocked_by_tech[result.name] = {} end
                                if not Func.contains(item_unlocked_by_tech[result.name], tech) then
                                    if not Func.starts_with(tech, 'deadlock') then 
                                        table.insert(item_unlocked_by_tech[result.name], tech)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- for item, tech_list in pairs(item_unlocked_by_tech) do
    --     log(item..' unlocked by '..table.concat(tech_list, ','))
    -- end

    -- for each item we care about add the deadlock stack/unstack recipe to the research tree
    -- and remove from the default stacker
    for root_name, name_table in pairs(dataset) do
        for _, type in pairs(name_table.types) do
            name = root_name..'-'..type
            if item_unlocked_by_tech[name] then 
                for _, tech in pairs(item_unlocked_by_tech[name]) do
                    Technology = data.raw.technology[tech]
                    -- add stack
                    stack_recipe = string.format("deadlock-stacks-stack-%s", name)
                    table.insert(Technology.effects, {recipe = stack_recipe, type = "unlock-recipe"})
                    -- add unstack
                    unstack_recipe = string.format("deadlock-stacks-unstack-%s", name)
                    table.insert(Technology.effects, {recipe = unstack_recipe, type = "unlock-recipe"})

                    deadlock_tech = "deadlock-stacking-"..name_table.tier
                    DeadlockTechnology = data.raw.technology[deadlock_tech]
                    for idx, effect in pairs(DeadlockTechnology.effects) do
                        if effect.recipe == stack_recipe then DeadlockTechnology.effects[idx] = nil end
                        if effect.recipe == unstack_recipe then DeadlockTechnology.effects[idx] = nil end
                    end
                end
            end
        end
    end
end

function Deadlock.MakeDeadlockItems(dataset)
    for root_name, name_table in pairs(dataset) do
        for _, type in pairs(name_table.types) do
            name = root_name..'-'..type
            Item = data.raw["item"][name]
            if Item then
                if Item.icon then
                    if Item.icon_size then
                        -- all good
                    else
                        log(string.format("base icon_size missing for %s", name))
                    end
                else
                    for k2, v2 in pairs(Item.icons) do
                        if v2.icon_size then
                            -- all good
                        else
                            v2.icon_size = Item.icon_size
                        end
                    end
                end

                deadlock.add_stack(name, nil, "deadlock-stacking-".. name_table.tier, 32, "item")
                DeadlockItem = data.raw["item"][string.format("deadlock-stack-%s", name)]
                if DeadlockItem then
                    -- stack recipe
                    stack_recipe = string.format("deadlock-stacks-stack-%s", name)
                    DeadlockStackRecipe = data.raw.recipe[stack_recipe]
                    DeadlockStackRecipe.localised_name[2] = Item.localised_name
                    -- unstack recipe
                    unstack_recipe = string.format("deadlock-stacks-unstack-%s", name)
                    DeadlockUnStackRecipe = data.raw.recipe[unstack_recipe]
                    DeadlockUnStackRecipe.localised_name[2] = Item.localised_name
                    -- item
                    DeadlockItem.subgroup = 'Stacked-'..type
                    if Item.order then 
                        DeadlockItem.order = Item.subgroup .. '-' .. Item.order
                    end
                    if Item.localised_name then 
                        DeadlockItem.localised_name[2] = Item.localised_name
                    end
                else
                    log('DeadlockItem missing  '..string.format("deadlock-stack-%s", name))
                end
            else
                log('missing  '..name..'-'..type)
            end
        end
    end
end

return Deadlock