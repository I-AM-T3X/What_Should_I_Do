-- Core/DB.lua
-- SavedVariables initialisation
-- Author: I_AM_T3X | v1.0.0

function InitDB()
    if not WhatShouldIDoDB then WhatShouldIDoDB = {} end
    if not WhatShouldIDoDB.activities then
        WhatShouldIDoDB.activities = {}
        for _, v in ipairs(WSID_DEFAULT_ACTIVITIES) do table.insert(WhatShouldIDoDB.activities, v) end
    end
    if not WhatShouldIDoDB.minimap       then WhatShouldIDoDB.minimap       = {hide=false, minimapPos=45} end
    if not WhatShouldIDoDB.subActivities then WhatShouldIDoDB.subActivities = {} end
    -- Clean up orphaned sub-activity keys
    if WhatShouldIDoDB.subActivities then
        local validKeys = {}
        for _, act in ipairs(WhatShouldIDoDB.activities) do validKeys[act] = true end
        for key in pairs(WhatShouldIDoDB.subActivities) do
            if not validKeys[key] then WhatShouldIDoDB.subActivities[key] = nil end
        end
    end
    if not WhatShouldIDoDB.seenChars    then WhatShouldIDoDB.seenChars    = {} end
    if not WhatShouldIDoDB.colorTheme   then WhatShouldIDoDB.colorTheme   = "Default" end
    if not WhatShouldIDoDB.customColors then WhatShouldIDoDB.customColors = {} end
    if not WhatShouldIDoDB.excludedChars then WhatShouldIDoDB.excludedChars = {} end
end
