if not settings.startup["enable-permissions"].value then
    return
end

local Permission = require("modules/permissions/permissions")

return Permission
