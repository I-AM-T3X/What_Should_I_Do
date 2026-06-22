-- Data/Expansions.lua
-- Expansion list and level-gated pool logic
-- Author: I_AM_T3X | v1.0.0

WSID_EXPANSIONS = {
    "The Burning Crusade","Wrath of the Lich King","Cataclysm","Mists of Pandaria",
    "Warlords of Draenor","Legion","Battle for Azeroth","Shadowlands",
    "Dragonflight","The War Within","Midnight",
}

function GetExpansionPool(level)
    if level >= 80 then
        return {"Midnight"}
    elseif level >= 70 then
        return {"The War Within"}
    elseif level >= 10 then
        local pool = {}
        for _, e in ipairs(WSID_EXPANSIONS) do
            if e ~= "The War Within" and e ~= "Midnight" then
                table.insert(pool, e)
            end
        end
        return pool
    else
        return {"Finish your starting zone and reroll!"}
    end
end
