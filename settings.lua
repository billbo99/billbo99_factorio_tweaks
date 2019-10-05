data:extend(
    {
        {
            name = "default-actions",
            type = "bool-setting",
            default_value = "true",
            setting_type = "startup",
            order = "0100"
        },
        {
            name = "enable-anti-grief",
            type = "bool-setting",
            default_value = "false",
            setting_type = "startup",
            order = "0200"
        },
        {
            name = "enable-permissions",
            type = "bool-setting",
            default_value = "false",
            setting_type = "startup",
            order = "0200"
        },
        {
            name = "auto-trusted-permissions",
            type = "string-setting",
            allow_blank = true,
            default_value = "",
            setting_type = "startup",
            order = "0210"
        },
        {
            name = "deadlock-experiments",
            type = "bool-setting",
            default_value = "false",
            setting_type = "startup",
            order = "1000"
        },
        {
            name = "darkstar",
            type = "bool-setting",
            default_value = "false",
            setting_type = "startup",
            order = "1000"
        }
    }
)