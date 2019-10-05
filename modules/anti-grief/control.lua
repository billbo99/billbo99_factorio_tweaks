if not settings.startup["enable-anti-grief"].value then
    return nil
end

return require("modules/anti-grief/anti-grief")
