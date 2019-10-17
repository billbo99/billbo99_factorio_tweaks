if not settings.startup["billbo99-enable-anti-grief"].value then
    return nil
end

return require("modules/anti-grief/anti-grief")
