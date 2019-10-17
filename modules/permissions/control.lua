if not settings.startup["billbo99-enable-permissions"].value then
    return
end

local Permission = require("modules/permissions/permissions")

return Permission
