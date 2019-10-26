data:extend(
    {
        -- runtime-per-user
        { name = "billbo99-respawn-with-primary_gun", type = "bool-setting", default_value = "true", setting_type = "runtime-per-user", order = "0100" },
        { name = "billbo99-respawn-with-primary_ammo", type = "bool-setting", default_value = "true", setting_type = "runtime-per-user", order = "0110" },
        { name = "billbo99-respawn-with-secondary_gun", type = "bool-setting", default_value = "true", setting_type = "runtime-per-user", order = "0200" },
        { name = "billbo99-respawn-with-secondary_ammo", type = "bool-setting", default_value = "true", setting_type = "runtime-per-user", order = "0210" },
        { name = "billbo99-respawn-with-armor", type = "bool-setting", default_value = "true", setting_type = "runtime-per-user", order = "0300" },
        -- runtime-global
        { name = "billbo99-primary_gun_threshold", type = "int-setting", default_value = 15, setting_type = "runtime-global", order = "0100" },
        { name = "billbo99-primary_ammo_threshold", type = "int-setting", default_value = 50, setting_type = "runtime-global", order = "0150" },
        { name = "billbo99-primary_ammo_starting_amount", type = "int-setting", default_value = 20, setting_type = "runtime-global", order = "0160" },
        { name = "billbo99-secondary_gun_threshold", type = "int-setting", default_value = 15, setting_type = "runtime-global", order = "0200" },
        { name = "billbo99-secondary_ammo_threshold", type = "int-setting", default_value = 50, setting_type = "runtime-global", order = "0250" },
        { name = "billbo99-secondary_ammo_starting_amount", type = "int-setting", default_value = 20, setting_type = "runtime-global", order = "0260" },
        { name = "billbo99-armor_threshold", type = "int-setting", default_value = 15, setting_type = "runtime-global", order = "0300" },
    }
)