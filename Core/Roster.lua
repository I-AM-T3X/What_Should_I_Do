-- Core/Roster.lua
-- Character roster management
-- Author: I_AM_T3X | v1.0.0

local CLASS_TOKEN_MAP = {
    WARRIOR="Warrior", PALADIN="Paladin", HUNTER="Hunter", ROGUE="Rogue",
    PRIEST="Priest", SHAMAN="Shaman", MAGE="Mage", WARLOCK="Warlock",
    MONK="Monk", DRUID="Druid", DEMONHUNTER="Demon Hunter",
    DEATHKNIGHT="Death Knight", EVOKER="Evoker",
}

function NormaliseClass(cls)
    if not cls then return cls end
    if WSID_CLASS_COLORS[cls] then return cls end
    local upper = cls:upper():gsub("%s","")
    return CLASS_TOKEN_MAP[upper] or cls
end

WSID_Roster = {}

function BuildRoster()
    WSID_Roster = {}
    local name    = UnitName("player")
    local cls, _  = UnitClass("player")
    cls = NormaliseClass(cls)
    local level   = UnitLevel("player")
    local race    = UnitRace("player")
    local faction = UnitFactionGroup("player")
    local found   = false
    for _, s in ipairs(WhatShouldIDoDB.seenChars) do
        if s.name == name then
            s.level=level ; s.class=cls ; s.race=race ; s.faction=faction
            found = true ; break
        end
    end
    if not found then
        table.insert(WhatShouldIDoDB.seenChars, {name=name,class=cls,level=level,race=race,faction=faction})
    end
    for _, s in ipairs(WhatShouldIDoDB.seenChars) do
        s.class = NormaliseClass(s.class)
    end
    table.insert(WSID_Roster, {name=name,class=cls,level=level,race=race,faction=faction,current=true})
    for _, s in ipairs(WhatShouldIDoDB.seenChars) do
        if s.name ~= name then table.insert(WSID_Roster, s) end
    end
end

function RemoveCharFromRoster(charName)
    for i, s in ipairs(WhatShouldIDoDB.seenChars) do
        if s.name == charName then table.remove(WhatShouldIDoDB.seenChars, i) ; break end
    end
    BuildRoster()
end
