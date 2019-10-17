data:extend(
    {
        -- runtime-per-user
        { name = "billbo99-respawn-with-ammo", type = "bool-setting", default_value = "true", setting_type = "runtime-per-user", order = "0100" },
        { name = "billbo99-respawn-with-gun", type = "bool-setting", default_value = "true", setting_type = "runtime-per-user", order = "0100" },
        { name = "billbo99-respawn-with-armor", type = "bool-setting", default_value = "true", setting_type = "runtime-per-user", order = "0100" },
        -- startup
        { name = "billbo99-default-actions", type = "bool-setting", default_value = "true", setting_type = "startup", order = "0100" },
        { name = "billbo99-enable-anti-grief", type = "bool-setting", default_value = "false", setting_type = "startup", order = "0200" },
        { name = "billbo99-enable-permissions", type = "bool-setting", default_value = "false", setting_type = "startup", order = "0200" },
        { name = "billbo99-auto-trusted-permissions", type = "string-setting", allow_blank = true, default_value = "", setting_type = "startup", order = "0210" },
        -- tweaks of mods
        { name = "billbo99-deadlock-experiments", type = "bool-setting", default_value = "false", setting_type = "startup", order = "1000" },
        { name = "billbo99-darkstar", type = "bool-setting", default_value = "false", setting_type = "startup", order = "1000" },
        { name = "billbo99-IndustrialRevolution", type = "bool-setting", default_value = "false", setting_type = "startup", order = "1000" },
    }
)