local Deadlock = {}

function Deadlock.add_item_to_deadlock(name, ingredients, results, recipe_energy_required, order)
    local ingredient_density = deadlock.get_item_stack_density(name, "item")
    local recipe = {
        type = "recipe",
        name = "stacked-" .. name,
        energy_required = recipe_energy_required * ingredient_density,
        ingredients = ingredients,
        results = results,
        order = order,
        icons = {
            {
                icon = "__deadlock-beltboxes-loaders__/graphics/icons/square/stacked-" .. name .. ".png",
                icon_size = 32
            },
          },
    }
    data:extend({recipe})
end

-- need to do things deadlock
function Deadlock.add_ore_to_deadlock(name, ingredients, result, result_count, recipe_energy_required, order)
    local ingredient_density = deadlock.get_item_stack_density(name, "item")
    local recipe = {
        type = "recipe",
        name = "stacked-" .. name,
        category = "smelting",
        energy_required = recipe_energy_required * ingredient_density,
        -- ingredients = {{ "deadlock-stack-" .. ingredient, ingredient_quantity}},
        ingredients = ingredients,
        result = "deadlock-stack-" .. result,
        result_count = result_count,
        order = order,
        icons = {
            {
              icon = "__IndustrialRevolution__/graphics/icons/64/" .. "stacked-" .. result .. ".png",
              icon_size = 64
            },
            {
              icon = "__IndustrialRevolution__/graphics/icons/64/" .. name .. ".png",
              icon_size = 64,
              scale = 0.25,
              shift = {
                -8,
                -8
              }
            }
          },
    }
    data:extend({recipe})
end

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

return Deadlock