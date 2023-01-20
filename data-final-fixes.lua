local function format(ingredient, result_count)
    local object
    if type(ingredient) == "table" then
        if ingredient.valid and ingredient:is_valid() then
            return ingredient
        elseif ingredient.name then
            if data.raw[ingredient.type] and data.raw[ingredient.type][ingredient.name] then
                object = table.deepcopy(ingredient)
                if not object.amount and not (object.amount_min and object.amount_max and object.probability) then
                    error("Result table requires amount or probabilities")
                end
            end
        elseif #ingredient > 0 then
            -- Can only be item types not fluid
            local item = data.raw.item[ingredient[1]]
            if item then
                object = {
                    type = "item",
                    name = ingredient[1],
                    amount = ingredient[2] or 1
                }
            end
        end
    elseif type(ingredient) == "string" then
        -- Our shortcut so we need to check it
        local item = data.raw.item[ingredient]
        if item then
            object = {
                type = item.type == "fluid" and "fluid" or "item",
                name = ingredient,
                amount = result_count or 1
            }
        end
    end
    return object
end

local function _replace_ingredient(ingredients, orig_item, new_item)
    for _, ingredient in pairs(ingredients) do
        if ingredient.name == orig_item then
            ingredient.name = new_item
        end
        if ingredient[1] == orig_item then
            ingredient[1] = new_item
        end
    end
end

local function replace_ingredient(recipe, orig_item, new_item)
    if recipe.normal and recipe.normal.ingredients then
        _replace_ingredient(recipe.normal.ingredients, orig_item, new_item)
    end
    if recipe.expensive and recipe.expensive.ingredients then
        _replace_ingredient(recipe.expensive.ingredients, orig_item, new_item)
    end
    if recipe.ingredients then
        _replace_ingredient(recipe.ingredients, orig_item, new_item)
    end
end

if mods["FasterStart"] then
    if data.raw["equipment-grid"]["mini-equipment-grid"] then
        data.raw["equipment-grid"]["mini-equipment-grid"].width = 6
        data.raw["equipment-grid"]["mini-equipment-grid"].height = 4
    end

    if data.raw["construction-robot"]["fusion-construction-robot"] then
        data.raw["construction-robot"]["fusion-construction-robot"].speed = data.raw["construction-robot"]["fusion-construction-robot"].speed * 3
    end
end

if mods["bobpower"] and mods["omnimatter_fluid"] then
    if data.raw.recipe["boiler-2"] then
        replace_ingredient(data.raw.recipe["boiler-2"], "boiler", "boiler-converter")
    end
    if data.raw.recipe["boiler-3"] then
        replace_ingredient(data.raw.recipe["boiler-3"], "boiler-2", "boiler-2-converter")
    end
    if data.raw.recipe["boiler-4"] then
        replace_ingredient(data.raw.recipe["boiler-4"], "boiler-3", "boiler-3-converter")
    end
    if data.raw.recipe["boiler-5"] then
        replace_ingredient(data.raw.recipe["boiler-5"], "boiler-4", "boiler-4-converter")
    end
end

if mods["omnimatter_compression"] then
    if data.raw.furnace["auto-compressor"] then
        data.raw.furnace["auto-compressor"].crafting_speed = 12
    end
end

if mods["Advanced-Drills"] and mods["Krastorio2"] then
    data.raw["mining-drill"]["advanced-mining-drill"].fast_replaceable_group = "electric-mining-drill"
    data.raw["mining-drill"]["elite-mining-drill"].fast_replaceable_group = "electric-mining-drill"
    data.raw["mining-drill"]["ultimate-mining-drill"].fast_replaceable_group = "electric-mining-drill"
end