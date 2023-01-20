data.raw["gui-style"].default["input_textbox"] = {
    type = "textbox_style",
    name = "input_textbox",
    parent = "textbox"
}

data:extend(
    {
        {
            type = "sprite",
            name = "AdminButton",
            filename = "__billbo99_factorio_tweaks__/graphics/admin.png",
            width = 512,
            height = 512
        }
    }
)

data:extend(
    {
        {
            type = "item",
            name = "blocker",
            order = "zzzzz",
            stack_size = 1,
            icon = "__core__/graphics/cancel.png",
            icon_size = 64,
            icon_mipmaps = 1,
            subgroup = "raw-resource"
        }
    }
)
