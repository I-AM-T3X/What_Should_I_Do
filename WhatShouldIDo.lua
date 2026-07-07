-- WhatShouldIDo.lua
-- Author: I_AM_T3X | v1.0.0

------------------------------------------------------------------------
-- DATA
------------------------------------------------------------------------

local ADDON_NAME = "WhatShouldIDo"

-- Window / layout constants (single source of truth)
local WIN_W  = 660
local WIN_H  = 520
local NAV_W  = 120
local PAD    = 16
-- Content area width: window - nav - left pad - right pad
local CONT_W = WIN_W - NAV_W - PAD * 2   -- 660-120-32 = 508

local DEFAULT_ACTIVITIES = {
    "PvP",
    "Housing",
    "Open World",
    "Rare Hunting",
    "Delves",
    "Gathering",
    "Crafting",
    "Collections",
    "Gold Making",
    "Holiday Events / Trading Post",
    "Leveling",
    "Pet Battles",
    "Anything Goes",
}

local SMART_OPTIONS = {
    ["PvP"]                           = {"Random Battleground","Epic Battleground","Arena Skirmish","War Mode","World PvP","Brawl"},
    ["Housing"]                       = {"Work on House Layout","Gather Decor","Endeavor Tasks","Theme Room","Farm Housing Items","Decorate a Room"},
    ["Open World"]                    = {"World Quests","Weekly Quests","Reputation Grind","Renown Catch-up","Zone Completion","Public Events","Rituals","Void Assaults","Rare Hunting","Daily Objectives"},
    ["Rare Hunting"]                  = {"Current Expansion Rares","Old Expansion Rares","Mount Rare","Toy Rare","Pet Rare","Champion Rare"},
    ["Delves"]                        = {"Solo Delves","Group Delves","Bountiful Delves","Push Higher Tier","Farm Curios","Follower Leveling"},
    ["Gathering"]                     = {"Mining","Herbalism","Fishing","Skinning","Gather for 30 Min","Farm Reagents"},
    ["Crafting"]                      = {"Profession Orders","Crafting Knowledge","Cooldowns","Make Consumables","Craft for Gold","Clean Bags"},
    ["Collections"]                   = {"Mounts","Pets","Toys","Appearances","Achievements","Reputation","Random ATT Category","Transmog Farming","Old Raid for Transmog","Old Dungeon for Transmog","Achievement Hunting","Exploration Achieves","Legacy Achieves"},
    ["Gold Making"]                   = {"Auction House","Gathering Farm","Crafting Shuffle","Transmog Farm","Raw Gold Farm","Vendor Flip","Clean Bank"},
    ["Holiday Events / Trading Post"] = {"Holiday Boss","Holiday Achievements","Trading Post Tasks","Monthly Reward Progress","Event Toys/Pets"},
    ["Leveling"]                      = {"Alt Leveling","Dungeon Spam","Questing","Chromie Time","Follower Dungeons","Prof While Leveling"},
    ["Pet Battles"]                   = {"Pet Battle Dailies","Level Pets","Capture Pets","Family Battler","Pet Dungeon","Random Pet Team"},
    ["Anything Goes"]                 = {"Do the Weirdest Thing","Finish Something Half-Done","One Hour Chaos Mode","Pick Something from Your Backlog"},
}

local EXPANSIONS = {
    "The Burning Crusade","Wrath of the Lich King","Cataclysm","Mists of Pandaria",
    "Warlords of Draenor","Legion","Battle for Azeroth","Shadowlands",
    "Dragonflight","The War Within","Midnight",
}

local ALL_RACES = {
    {race="Human",               faction="Alliance", rtype="Core"},
    {race="Dwarf",               faction="Alliance", rtype="Core"},
    {race="Night Elf",           faction="Alliance", rtype="Core"},
    {race="Gnome",               faction="Alliance", rtype="Core"},
    {race="Draenei",             faction="Alliance", rtype="Core"},
    {race="Worgen",              faction="Alliance", rtype="Core"},
    {race="Orc",                 faction="Horde",    rtype="Core"},
    {race="Undead",              faction="Horde",    rtype="Core"},
    {race="Tauren",              faction="Horde",    rtype="Core"},
    {race="Troll",               faction="Horde",    rtype="Core"},
    {race="Blood Elf",           faction="Horde",    rtype="Core"},
    {race="Goblin",              faction="Horde",    rtype="Core"},
    {race="Pandaren",            faction="Neutral",  rtype="Core"},
    {race="Dracthyr",            faction="Neutral",  rtype="Core"},
    {race="Void Elf",            faction="Alliance", rtype="Allied"},
    {race="Lightforged Draenei", faction="Alliance", rtype="Allied"},
    {race="Dark Iron Dwarf",     faction="Alliance", rtype="Allied"},
    {race="Kul Tiran",           faction="Alliance", rtype="Allied"},
    {race="Mechagnome",          faction="Alliance", rtype="Allied"},
    {race="Nightborne",          faction="Horde",    rtype="Allied"},
    {race="Highmountain Tauren", faction="Horde",    rtype="Allied"},
    {race="Mag'har Orc",         faction="Horde",    rtype="Allied"},
    {race="Zandalari Troll",     faction="Horde",    rtype="Allied"},
    {race="Vulpera",             faction="Horde",    rtype="Allied"},
    {race="Earthen",             faction="Neutral",  rtype="Allied"},
    {race="Haranir",             faction="Neutral",  rtype="Allied"},
}

local CLASS_BY_RACE = {
    ["Human"]               = {"Warrior","Paladin","Hunter","Rogue","Priest","Mage","Warlock","Monk","Death Knight"},
    ["Dwarf"]               = {"Warrior","Paladin","Hunter","Rogue","Priest","Shaman","Mage","Warlock","Monk","Death Knight"},
    ["Night Elf"]           = {"Warrior","Hunter","Rogue","Priest","Mage","Monk","Druid","Demon Hunter","Death Knight"},
    ["Gnome"]               = {"Warrior","Hunter","Rogue","Priest","Mage","Warlock","Monk","Death Knight"},
    ["Draenei"]             = {"Warrior","Paladin","Hunter","Priest","Shaman","Mage","Monk","Death Knight"},
    ["Worgen"]              = {"Warrior","Hunter","Rogue","Priest","Mage","Warlock","Druid","Death Knight"},
    ["Pandaren"]            = {"Warrior","Hunter","Rogue","Priest","Shaman","Mage","Monk","Death Knight"},
    ["Dracthyr"]            = {"Warrior","Hunter","Rogue","Priest","Mage","Warlock","Evoker"},
    ["Orc"]                 = {"Warrior","Hunter","Rogue","Shaman","Mage","Warlock","Monk","Death Knight"},
    ["Undead"]              = {"Warrior","Hunter","Rogue","Priest","Mage","Warlock","Monk","Death Knight"},
    ["Tauren"]              = {"Warrior","Paladin","Hunter","Priest","Shaman","Mage","Monk","Druid","Death Knight"},
    ["Troll"]               = {"Warrior","Hunter","Rogue","Priest","Shaman","Mage","Warlock","Monk","Druid","Death Knight"},
    ["Blood Elf"]           = {"Warrior","Paladin","Hunter","Rogue","Priest","Mage","Warlock","Monk","Demon Hunter","Death Knight"},
    ["Goblin"]              = {"Warrior","Hunter","Rogue","Priest","Shaman","Mage","Warlock","Death Knight"},
    ["Void Elf"]            = {"Warrior","Hunter","Rogue","Priest","Mage","Warlock","Monk","Death Knight"},
    ["Lightforged Draenei"] = {"Warrior","Paladin","Hunter","Priest","Mage","Monk","Death Knight"},
    ["Dark Iron Dwarf"]     = {"Warrior","Paladin","Hunter","Rogue","Priest","Shaman","Mage","Warlock","Monk","Death Knight"},
    ["Kul Tiran"]           = {"Warrior","Hunter","Rogue","Priest","Shaman","Mage","Monk","Druid","Death Knight"},
    ["Mechagnome"]          = {"Warrior","Hunter","Rogue","Priest","Mage","Warlock","Monk","Death Knight"},
    ["Nightborne"]          = {"Warrior","Hunter","Rogue","Priest","Mage","Warlock","Monk","Death Knight"},
    ["Highmountain Tauren"] = {"Warrior","Hunter","Rogue","Priest","Shaman","Mage","Monk","Druid","Death Knight"},
    ["Mag'har Orc"]         = {"Warrior","Hunter","Rogue","Priest","Shaman","Mage","Monk","Death Knight"},
    ["Zandalari Troll"]     = {"Warrior","Paladin","Hunter","Rogue","Priest","Shaman","Mage","Monk","Druid","Death Knight"},
    ["Vulpera"]             = {"Warrior","Hunter","Rogue","Priest","Shaman","Mage","Warlock","Monk","Death Knight"},
    ["Earthen"]             = {"Warrior","Paladin","Hunter","Rogue","Priest","Shaman","Mage","Warlock","Monk","Death Knight"},
    ["Haranir"]             = {"Warrior","Hunter","Rogue","Priest","Shaman","Mage","Warlock","Monk","Druid"},
}

local CLASS_COLORS = {
    ["Warrior"]      = {r=0.78, g=0.61, b=0.43},
    ["Paladin"]      = {r=0.96, g=0.55, b=0.73},
    ["Hunter"]       = {r=0.67, g=0.83, b=0.45},
    ["Rogue"]        = {r=1.00, g=0.96, b=0.41},
    ["Priest"]       = {r=0.90, g=0.90, b=0.90},
    ["Shaman"]       = {r=0.00, g=0.44, b=0.87},
    ["Mage"]         = {r=0.25, g=0.78, b=0.92},
    ["Warlock"]      = {r=0.53, g=0.53, b=0.93},
    ["Monk"]         = {r=0.00, g=1.00, b=0.60},
    ["Druid"]        = {r=1.00, g=0.49, b=0.04},
    ["Demon Hunter"] = {r=0.64, g=0.19, b=0.79},
    ["Death Knight"] = {r=0.77, g=0.12, b=0.23},
    ["Evoker"]       = {r=0.20, g=0.58, b=0.50},
}

------------------------------------------------------------------------
-- SAVED VARIABLES
------------------------------------------------------------------------

local function InitDB()
    if not WhatShouldIDoDB then WhatShouldIDoDB = {} end
    if not WhatShouldIDoDB.activities then
        WhatShouldIDoDB.activities = {}
        for _, v in ipairs(DEFAULT_ACTIVITIES) do table.insert(WhatShouldIDoDB.activities, v) end
    end
    if not WhatShouldIDoDB.minimap      then WhatShouldIDoDB.minimap      = {hide=false, minimapPos=45} end
    if not WhatShouldIDoDB.subActivities then WhatShouldIDoDB.subActivities = {} end
    -- Clean up orphaned sub-activity keys that no longer match any activity
    if WhatShouldIDoDB.subActivities then
        local validKeys = {}
        for _, act in ipairs(WhatShouldIDoDB.activities) do validKeys[act] = true end
        for key in pairs(WhatShouldIDoDB.subActivities) do
            if not validKeys[key] then
                WhatShouldIDoDB.subActivities[key] = nil
            end
        end
    end
    if not WhatShouldIDoDB.seenChars     then WhatShouldIDoDB.seenChars     = {} end
    if not WhatShouldIDoDB.colorTheme    then WhatShouldIDoDB.colorTheme    = "Default" end
    if not WhatShouldIDoDB.customColors  then WhatShouldIDoDB.customColors  = {} end
end

------------------------------------------------------------------------
-- ROSTER
------------------------------------------------------------------------

-- Map uppercase tokens returned by UnitClass second value -> display name
local CLASS_TOKEN_MAP = {
    WARRIOR="Warrior", PALADIN="Paladin", HUNTER="Hunter", ROGUE="Rogue",
    PRIEST="Priest", SHAMAN="Shaman", MAGE="Mage", WARLOCK="Warlock",
    MONK="Monk", DRUID="Druid", DEMONHUNTER="Demon Hunter",
    DEATHKNIGHT="Death Knight", EVOKER="Evoker",
}

local function NormaliseClass(cls)
    if not cls then return cls end
    -- If it's already a known display name, pass through
    if CLASS_COLORS[cls] then return cls end
    -- Try uppercase token lookup
    local upper = cls:upper():gsub("%s","")
    return CLASS_TOKEN_MAP[upper] or cls
end

local roster = {}

local function BuildRoster()
    roster = {}
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
    -- Normalise any existing entries that may have token-style class names
    for _, s in ipairs(WhatShouldIDoDB.seenChars) do
        s.class = NormaliseClass(s.class)
    end

    table.insert(roster, {name=name,class=cls,level=level,race=race,faction=faction,current=true})
    for _, s in ipairs(WhatShouldIDoDB.seenChars) do
        if s.name ~= name then table.insert(roster, s) end
    end
end

local function RemoveCharFromRoster(charName)
    for i, s in ipairs(WhatShouldIDoDB.seenChars) do
        if s.name == charName then table.remove(WhatShouldIDoDB.seenChars, i) ; break end
    end
    BuildRoster()
end

------------------------------------------------------------------------
-- HELPERS
------------------------------------------------------------------------

local function Pick(t)
    if not t or #t == 0 then return nil end
    return t[math.random(#t)]
end

local function GetExpansionPool(level)
    if level >= 80 then
        -- 80-89: Midnight content
        return {"Midnight"}
    elseif level >= 70 then
        -- 70-79: The War Within
        return {"The War Within"}
    elseif level >= 10 then
        -- 10-69: Chromie Time (all classic/legacy expansions)
        local pool = {}
        for _, e in ipairs(EXPANSIONS) do
            if e ~= "The War Within" and e ~= "Midnight" then
                table.insert(pool, e)
            end
        end
        return pool
    else
        -- 1-9: Still in starting zone
        return {"Finish your starting zone and reroll!"}
    end
end

local function GetSubPool(category)
    if WhatShouldIDoDB and WhatShouldIDoDB.subActivities
    and WhatShouldIDoDB.subActivities[category]
    and #WhatShouldIDoDB.subActivities[category] > 0 then
        return WhatShouldIDoDB.subActivities[category]
    end
    return SMART_OPTIONS[category]
end

------------------------------------------------------------------------
-- SLOT MACHINE
------------------------------------------------------------------------

local slotTimer=nil ; local slotTick=0 ; local slotTotal=0
local slotWinner=nil ; local slotLabel=nil ; local slotCallback=nil

local function StopSlot()
    if slotTimer then slotTimer:Cancel() slotTimer = nil end
end

local function StartSlot(label, pool, onDone)
    StopSlot()
    if not pool or #pool == 0 then
        label:SetText("No options!") ; if onDone then onDone(nil) end ; return
    end
    slotTick=0 ; slotTotal=26+math.random(0,10)
    slotWinner=Pick(pool) ; slotLabel=label ; slotCallback=onDone
    local function Tick()
        slotTick = slotTick + 1
        if slotTick >= slotTotal then
            slotLabel:SetText(slotWinner) ; StopSlot()
            if slotCallback then slotCallback(slotWinner) end ; return
        end
        slotLabel:SetText(pool[math.random(#pool)])
        slotTimer = C_Timer.NewTimer(0.06 + 0.18*((slotTick/slotTotal)^2), Tick)
    end
    Tick()
end

------------------------------------------------------------------------
-- THEME
------------------------------------------------------------------------

------------------------------------------------------------------------
-- THEME SYSTEM
------------------------------------------------------------------------

local THEMES = {
    Default = {
        bg          = {0.058, 0.048, 0.075},
        sidebar     = {0.040, 0.032, 0.058},
        nav_hover   = {0.14,  0.10,  0.22},
        nav_active  = {0.18,  0.10,  0.32},
        nav_border  = {0.55,  0.28,  0.90},
        header_bg   = {0.14,  0.08,  0.24},
        header_txt  = {0.82,  0.65,  1.00},
        row_even    = {0.08,  0.06,  0.11},
        row_odd     = {0.06,  0.04,  0.09},
        row_hover   = {0.18,  0.12,  0.28},
        row_select  = {0.22,  0.12,  0.38},
        result_bg   = {0.05,  0.03,  0.10},
        result_bdr  = {0.44,  0.22,  0.72},
        btn_bg      = {0.16,  0.08,  0.28},
        btn_bdr     = {0.50,  0.28,  0.80},
        btn_hover   = {0.24,  0.12,  0.40},
        btn_text    = {0.88,  0.72,  1.00},
        btn_dis     = {0.09,  0.06,  0.14},
        dim_text    = {0.50,  0.44,  0.62},
        bright_text = {0.92,  0.86,  1.00},
        spin_text   = {0.78,  0.55,  1.00},
        win_border  = {0.28,  0.16,  0.44},
        divider     = {0.18,  0.12,  0.28},
    },
    -- Deuteranopia: red-green blind -- replace purples with blues/cyans
    Deuteranopia = {
        bg          = {0.04,  0.06,  0.12},
        sidebar     = {0.03,  0.04,  0.09},
        nav_hover   = {0.08,  0.14,  0.26},
        nav_active  = {0.06,  0.18,  0.36},
        nav_border  = {0.20,  0.60,  1.00},
        header_bg   = {0.06,  0.12,  0.24},
        header_txt  = {0.55,  0.88,  1.00},
        row_even    = {0.06,  0.08,  0.14},
        row_odd     = {0.04,  0.06,  0.11},
        row_hover   = {0.10,  0.18,  0.32},
        row_select  = {0.08,  0.22,  0.44},
        result_bg   = {0.03,  0.05,  0.12},
        result_bdr  = {0.20,  0.55,  0.90},
        btn_bg      = {0.06,  0.14,  0.30},
        btn_bdr     = {0.22,  0.55,  0.90},
        btn_hover   = {0.10,  0.22,  0.44},
        btn_text    = {0.65,  0.90,  1.00},
        btn_dis     = {0.05,  0.07,  0.14},
        dim_text    = {0.44,  0.55,  0.70},
        bright_text = {0.86,  0.94,  1.00},
        spin_text   = {0.40,  0.82,  1.00},
        win_border  = {0.14,  0.30,  0.55},
        divider     = {0.10,  0.18,  0.34},
    },
    -- Protanopia: red blind -- similar to deuteranopia, heavier blue shift
    Protanopia = {
        bg          = {0.04,  0.05,  0.10},
        sidebar     = {0.03,  0.04,  0.08},
        nav_hover   = {0.07,  0.12,  0.24},
        nav_active  = {0.05,  0.16,  0.34},
        nav_border  = {0.15,  0.65,  0.95},
        header_bg   = {0.05,  0.10,  0.22},
        header_txt  = {0.50,  0.85,  1.00},
        row_even    = {0.05,  0.07,  0.13},
        row_odd     = {0.04,  0.05,  0.10},
        row_hover   = {0.09,  0.16,  0.30},
        row_select  = {0.07,  0.20,  0.42},
        result_bg   = {0.03,  0.04,  0.10},
        result_bdr  = {0.15,  0.60,  0.92},
        btn_bg      = {0.05,  0.12,  0.28},
        btn_bdr     = {0.18,  0.58,  0.92},
        btn_hover   = {0.09,  0.20,  0.42},
        btn_text    = {0.60,  0.88,  1.00},
        btn_dis     = {0.04,  0.06,  0.13},
        dim_text    = {0.42,  0.54,  0.68},
        bright_text = {0.84,  0.92,  1.00},
        spin_text   = {0.35,  0.80,  1.00},
        win_border  = {0.12,  0.28,  0.52},
        divider     = {0.09,  0.16,  0.32},
    },
    -- Tritanopia: blue-yellow blind -- use orange/red accents instead of blue/purple
    Tritanopia = {
        bg          = {0.10,  0.06,  0.04},
        sidebar     = {0.08,  0.04,  0.03},
        nav_hover   = {0.22,  0.12,  0.06},
        nav_active  = {0.32,  0.14,  0.05},
        nav_border  = {0.95,  0.55,  0.10},
        header_bg   = {0.22,  0.10,  0.04},
        header_txt  = {1.00,  0.80,  0.40},
        row_even    = {0.12,  0.08,  0.06},
        row_odd     = {0.09,  0.06,  0.04},
        row_hover   = {0.28,  0.14,  0.06},
        row_select  = {0.36,  0.16,  0.06},
        result_bg   = {0.08,  0.04,  0.03},
        result_bdr  = {0.80,  0.42,  0.08},
        btn_bg      = {0.26,  0.10,  0.04},
        btn_bdr     = {0.88,  0.48,  0.10},
        btn_hover   = {0.38,  0.16,  0.06},
        btn_text    = {1.00,  0.82,  0.50},
        btn_dis     = {0.12,  0.07,  0.05},
        dim_text    = {0.62,  0.48,  0.36},
        bright_text = {1.00,  0.92,  0.80},
        spin_text   = {1.00,  0.72,  0.20},
        win_border  = {0.48,  0.24,  0.08},
        divider     = {0.28,  0.14,  0.06},
    },
    -- High Contrast: white/black/yellow for maximum readability
    HighContrast = {
        bg          = {0.02,  0.02,  0.02},
        sidebar     = {0.05,  0.05,  0.05},
        nav_hover   = {0.20,  0.20,  0.20},
        nav_active  = {0.25,  0.25,  0.00},
        nav_border  = {1.00,  1.00,  0.00},
        header_bg   = {0.15,  0.15,  0.15},
        header_txt  = {1.00,  1.00,  0.00},
        row_even    = {0.10,  0.10,  0.10},
        row_odd     = {0.06,  0.06,  0.06},
        row_hover   = {0.25,  0.25,  0.25},
        row_select  = {0.30,  0.30,  0.00},
        result_bg   = {0.00,  0.00,  0.00},
        result_bdr  = {1.00,  1.00,  0.00},
        btn_bg      = {0.15,  0.15,  0.15},
        btn_bdr     = {1.00,  1.00,  0.00},
        btn_hover   = {0.30,  0.30,  0.00},
        btn_text    = {1.00,  1.00,  0.00},
        btn_dis     = {0.08,  0.08,  0.08},
        dim_text    = {0.70,  0.70,  0.70},
        bright_text = {1.00,  1.00,  1.00},
        spin_text   = {1.00,  1.00,  0.00},
        win_border  = {1.00,  1.00,  0.00},
        divider     = {0.40,  0.40,  0.40},
    },
}

-- C is the live color table -- starts as Default, swapped by ApplyTheme
local C = {}
for k,v in pairs(THEMES.Default) do C[k] = {v[1],v[2],v[3]} end

local function ApplyTheme(themeName, customColors)
    local src = THEMES[themeName]
    if not src and themeName == "Custom" then
        src = customColors or THEMES.Default
    end
    if not src then src = THEMES.Default end
    for k,v in pairs(src) do
        C[k][1] = v[1] ; C[k][2] = v[2] ; C[k][3] = v[3]
    end
end

local FLAT = {bgFile="Interface\\Buttons\\WHITE8x8", edgeFile="Interface\\Buttons\\WHITE8x8", edgeSize=1}

local function Tx(f, r,g,b,a)  -- plain texture background helper
    local t = f:CreateTexture(nil,"BACKGROUND")
    t:SetAllPoints() ; t:SetColorTexture(r,g,b,a or 1) ; return t
end

local function BgBorder(f, br,bg_,bb, er,eg,eb)
    f:SetBackdrop(FLAT)
    f:SetBackdropColor(br,bg_,bb,1)
    f:SetBackdropBorderColor(er,eg,eb,1)
end

------------------------------------------------------------------------
-- SCROLL BOX
------------------------------------------------------------------------

local function MakeScrollBox(parent, w, h)
    local bg = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    bg:SetSize(w, h)
    BgBorder(bg, C.row_even[1],C.row_even[2],C.row_even[3],
                 C.divider[1], C.divider[2], C.divider[3])
    local clip = CreateFrame("Frame", nil, bg)
    clip:SetPoint("TOPLEFT",     bg, "TOPLEFT",     1, -1)
    clip:SetPoint("BOTTOMRIGHT", bg, "BOTTOMRIGHT", -1, 1)
    clip:SetClipsChildren(true)
    local content = CreateFrame("Frame", nil, clip)
    content:SetWidth(w-2) ; content:SetHeight(h)
    content:SetPoint("TOPLEFT", clip, "TOPLEFT", 0, 0)
    local scrollOff = 0
    local function Clamp(v,lo,hi) return math.max(lo,math.min(hi,v)) end
    local function Scroll(d)
        scrollOff = Clamp(scrollOff - d*22*2, 0, math.max(0, content:GetHeight()-clip:GetHeight()))
        content:SetPoint("TOPLEFT", clip, "TOPLEFT", 0, scrollOff)
    end
    bg:EnableMouseWheel(true)
    bg:SetScript("OnMouseWheel", function(_,d) Scroll(d) end)
    local function ResetScroll()
        scrollOff=0 ; content:SetPoint("TOPLEFT", clip, "TOPLEFT", 0, 0)
    end
    return bg, content, ResetScroll
end

------------------------------------------------------------------------
-- UI PRIMITIVES
------------------------------------------------------------------------

-- Result display (label returns fontstring for slot machine)
local function MakeResult(parent, w, h, tagText)
    local f = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    f:SetSize(w, h or 52)
    BgBorder(f, C.result_bg[1],C.result_bg[2],C.result_bg[3],
                C.result_bdr[1],C.result_bdr[2],C.result_bdr[3])
    if tagText then
        local tag = f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        tag:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -6)
        tag:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
        tag:SetText(tagText)
    end
    local lbl = f:CreateFontString(nil,"OVERLAY")
    lbl:SetFont("Fonts\\FRIZQT__.TTF", 17, "")
    lbl:SetPoint("CENTER", f, "CENTER", 0, tagText and -4 or 0)
    lbl:SetWidth(w-20) ; lbl:SetJustifyH("CENTER") ; lbl:SetWordWrap(false)
    lbl:SetText("--") ; lbl:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
    return f, lbl
end

-- Button
local function MakeBtn(parent, text, w, h)
    local b = CreateFrame("Button", nil, parent, "BackdropTemplate")
    b:SetSize(w, h or 30)
    BgBorder(b, C.btn_bg[1],C.btn_bg[2],C.btn_bg[3], C.btn_bdr[1],C.btn_bdr[2],C.btn_bdr[3])
    local lbl = b:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    lbl:SetAllPoints() ; lbl:SetJustifyH("CENTER")
    lbl:SetText(text) ; lbl:SetTextColor(C.btn_text[1],C.btn_text[2],C.btn_text[3])
    b:SetScript("OnEnter", function(s)
        if s:IsEnabled() then
            s:SetBackdropColor(C.btn_hover[1],C.btn_hover[2],C.btn_hover[3])
            s:SetBackdropBorderColor(0.70,0.42,1.00,1)
        end
    end)
    b:SetScript("OnLeave", function(s)
        if s:IsEnabled() then
            s:SetBackdropColor(C.btn_bg[1],C.btn_bg[2],C.btn_bg[3])
            s:SetBackdropBorderColor(C.btn_bdr[1],C.btn_bdr[2],C.btn_bdr[3],1)
        end
    end)
    b._lbl = lbl
    local origSetEnabled = b.SetEnabled
    b.SetEnabled = function(self, v)
        origSetEnabled(self, v)
        if v then
            self:SetBackdropColor(C.btn_bg[1],C.btn_bg[2],C.btn_bg[3])
            self:SetBackdropBorderColor(C.btn_bdr[1],C.btn_bdr[2],C.btn_bdr[3],1)
            lbl:SetTextColor(C.btn_text[1],C.btn_text[2],C.btn_text[3])
        else
            self:SetBackdropColor(C.btn_dis[1],C.btn_dis[2],C.btn_dis[3])
            self:SetBackdropBorderColor(C.btn_dis[1]+0.10,C.btn_dis[2]+0.10,C.btn_dis[3]+0.10,1)
            lbl:SetTextColor(C.dim_text[1]*0.6, C.dim_text[2]*0.6, C.dim_text[3]*0.6)
        end
    end
    -- Apply enabled visual through our override so initial state is correct
    b:SetEnabled(true)
    return b
end

-- Section header bar
local function MakeHeader(parent, text, w)
    local f = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    f:SetSize(w, 28)
    BgBorder(f, C.header_bg[1],C.header_bg[2],C.header_bg[3], C.divider[1],C.divider[2],C.divider[3])
    local stripe = f:CreateTexture(nil,"ARTWORK")
    stripe:SetColorTexture(C.nav_border[1],C.nav_border[2],C.nav_border[3],1)
    stripe:SetSize(3,28) ; stripe:SetPoint("LEFT",f,"LEFT",0,0)
    local lbl = f:CreateFontString(nil,"OVERLAY","GameFontNormal")
    lbl:SetPoint("LEFT",f,"LEFT",12,0)
    lbl:SetText(text) ; lbl:SetTextColor(C.header_txt[1],C.header_txt[2],C.header_txt[3])
    return f
end

-- Dim label
local function MakeDimLabel(parent, text, anchorFrame, anchorPoint, ox, oy)
    local fs = parent:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    fs:SetPoint("TOPLEFT", anchorFrame, anchorPoint or "BOTTOMLEFT", ox or 0, oy or -6)
    fs:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
    fs:SetText(text)
    return fs
end

-- Horizontal rule
local function MakeRule(parent, anchorFrame, yOff)
    local t = parent:CreateTexture(nil,"ARTWORK")
    t:SetColorTexture(C.divider[1],C.divider[2],C.divider[3],1)
    t:SetHeight(1)
    t:SetPoint("TOPLEFT",  anchorFrame, "BOTTOMLEFT",  0, yOff or -8)
    t:SetPoint("TOPRIGHT", anchorFrame, "BOTTOMRIGHT", 0, yOff or -8)
    return t
end

local function MakePanel(parent)
    local p = CreateFrame("Frame", nil, parent)
    p:SetAllPoints(parent) ; p:Hide() ; return p
end

------------------------------------------------------------------------
-- LEFT NAV
------------------------------------------------------------------------

local function BuildLeftNav(parent, topDefs, bottomDefs, onSelect)
    local ROW_H = 38
    local navBg = CreateFrame("Frame", nil, parent)
    navBg:SetPoint("TOPLEFT",    parent,"TOPLEFT",    0,-30)
    navBg:SetPoint("BOTTOMLEFT", parent,"BOTTOMLEFT", 0,  0)
    navBg:SetWidth(NAV_W)
    Tx(navBg, C.sidebar[1],C.sidebar[2],C.sidebar[3])
    local divR = navBg:CreateTexture(nil,"ARTWORK")
    divR:SetColorTexture(C.divider[1],C.divider[2],C.divider[3],1)
    divR:SetWidth(1)
    divR:SetPoint("TOPRIGHT",navBg,"TOPRIGHT",0,0)
    divR:SetPoint("BOTTOMRIGHT",navBg,"BOTTOMRIGHT",0,0)

    local btns   = {}
    local active = nil

    local function SetActive(name)
        active = name
        for k,b in pairs(btns) do
            if k == name then
                b.bg:SetColorTexture(C.nav_active[1],C.nav_active[2],C.nav_active[3],1)
                b.stripe:Show() ; b.lbl:SetTextColor(1,1,1)
            else
                b.bg:SetColorTexture(0,0,0,0)
                b.stripe:Hide() ; b.lbl:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
            end
        end
        if onSelect then onSelect(name) end
    end

    local function AddRow(def, anchorFrm, anchorPt, anchorOff)
        local row = CreateFrame("Button", nil, navBg)
        row:SetSize(NAV_W, ROW_H)
        row:SetPoint("TOPLEFT", anchorFrm, anchorPt, 0, anchorOff or 0)
        local bg     = row:CreateTexture(nil,"BACKGROUND") ; bg:SetAllPoints() ; bg:SetColorTexture(0,0,0,0)
        local stripe = row:CreateTexture(nil,"ARTWORK")
        stripe:SetColorTexture(C.nav_border[1],C.nav_border[2],C.nav_border[3],1)
        stripe:SetSize(3,ROW_H) ; stripe:SetPoint("LEFT",row,"LEFT",0,0) ; stripe:Hide()
        local lbl = row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        lbl:SetPoint("LEFT",row,"LEFT",16,0) ; lbl:SetText(def.label)
        lbl:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
        local name = def.name
        row:SetScript("OnClick",  function() SetActive(name) end)
        row:SetScript("OnEnter",  function()
            if active~=name then bg:SetColorTexture(C.nav_hover[1],C.nav_hover[2],C.nav_hover[3],1)
                                 lbl:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3]) end end)
        row:SetScript("OnLeave",  function()
            if active~=name then bg:SetColorTexture(0,0,0,0)
                                 lbl:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3]) end end)
        btns[name] = {bg=bg,stripe=stripe,lbl=lbl}
        return row
    end

    local prev = navBg ; local pp = "TOPLEFT"
    for _, def in ipairs(topDefs) do
        local row = AddRow(def, prev, pp, 0)
        prev = row ; pp = "BOTTOMLEFT"
    end

    -- divider above bottom items
    local bdiv = navBg:CreateTexture(nil,"ARTWORK")
    bdiv:SetColorTexture(C.divider[1],C.divider[2],C.divider[3],1) ; bdiv:SetHeight(1)
    bdiv:SetPoint("BOTTOMLEFT",  navBg,"BOTTOMLEFT",  0, #bottomDefs*ROW_H)
    bdiv:SetPoint("BOTTOMRIGHT", navBg,"BOTTOMRIGHT", 0, #bottomDefs*ROW_H)

    for i, def in ipairs(bottomDefs) do
        local row = CreateFrame("Button", nil, navBg)
        row:SetSize(NAV_W, ROW_H)
        row:SetPoint("BOTTOMLEFT", navBg,"BOTTOMLEFT", 0, (#bottomDefs-i)*ROW_H)
        local bg     = row:CreateTexture(nil,"BACKGROUND") ; bg:SetAllPoints() ; bg:SetColorTexture(0,0,0,0)
        local stripe = row:CreateTexture(nil,"ARTWORK")
        stripe:SetColorTexture(C.nav_border[1],C.nav_border[2],C.nav_border[3],1)
        stripe:SetSize(3,ROW_H) ; stripe:SetPoint("LEFT",row,"LEFT",0,0) ; stripe:Hide()
        local lbl = row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        lbl:SetPoint("LEFT",row,"LEFT",16,0) ; lbl:SetText(def.label)
        lbl:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
        local name = def.name
        row:SetScript("OnClick",  function() SetActive(name) end)
        row:SetScript("OnEnter",  function()
            if active~=name then bg:SetColorTexture(C.nav_hover[1],C.nav_hover[2],C.nav_hover[3],1)
                                 lbl:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3]) end end)
        row:SetScript("OnLeave",  function()
            if active~=name then bg:SetColorTexture(0,0,0,0)
                                 lbl:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3]) end end)
        btns[name] = {bg=bg,stripe=stripe,lbl=lbl}
    end

    SetActive(topDefs[1].name)
    return SetActive
end

------------------------------------------------------------------------
-- TAB 1: ACTIVITY
------------------------------------------------------------------------
-- Layout (total content height needed = 490px available):
--   PAD(16) + hdr(28) + gap(10) + desc(14) + gap(12)
--   + catBox(52) + gap(10) + subBox(52) + gap(14)
--   + btnRow(30) + gap(6) + bothBtn(30) + PAD(16) = 290px  (lots of breathing room)

local function BuildActivityPanel(contentArea)
    local panel = MakePanel(contentArea)
    local W = CONT_W

    local hdr = MakeHeader(panel, "Activity Wheel", W)
    hdr:SetPoint("TOPLEFT", panel, "TOPLEFT", PAD, -PAD)

    local desc = MakeDimLabel(panel, "Spin a category, then spin a sub-activity.", hdr, "BOTTOMLEFT", 4, -8)

    local catBox, catLabel = MakeResult(panel, W, 52, "CATEGORY")
    catBox:SetPoint("TOPLEFT", desc, "BOTTOMLEFT", -4, -12)
    catLabel:SetText("Category")

    local subBox, subLabel = MakeResult(panel, W, 52, "SUB-ACTIVITY")
    subBox:SetPoint("TOPLEFT", catBox, "BOTTOMLEFT", 0, -10)
    subLabel:SetText("Sub-Activity")

    local halfW = math.floor((W-6)/2)
    local spinCatBtn = MakeBtn(panel, "Spin Category", halfW, 30)
    spinCatBtn:SetPoint("TOPLEFT", subBox, "BOTTOMLEFT", 0, -14)

    local spinSubBtn = MakeBtn(panel, "Spin Sub-Activity", halfW, 30)
    spinSubBtn:SetPoint("TOPLEFT", subBox, "BOTTOMLEFT", halfW+6, -14)
    spinSubBtn:SetEnabled(false)

    local spinBothBtn = MakeBtn(panel, "Spin Both", W, 30)
    spinBothBtn:SetPoint("TOPLEFT", spinCatBtn, "BOTTOMLEFT", 0, -6)

    local lastCat = nil

    local function ResetSub()
        subLabel:SetText("Sub-Activity") ; subLabel:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
        spinSubBtn:SetEnabled(false) ; lastCat = nil
    end

    spinCatBtn:SetScript("OnClick", function()
        local pool = WhatShouldIDoDB.activities ; if #pool==0 then return end
        StopSlot() ; spinCatBtn:SetEnabled(false) ; spinBothBtn:SetEnabled(false) ; ResetSub()
        catLabel:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
        StartSlot(catLabel, pool, function(w)
            lastCat=w ; catLabel:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3])
            spinCatBtn:SetEnabled(true) ; spinBothBtn:SetEnabled(true) ; spinSubBtn:SetEnabled(true)
        end)
    end)

    spinSubBtn:SetScript("OnClick", function()
        if not lastCat then return end
        local pool = GetSubPool(lastCat) ; if not pool or #pool==0 then subLabel:SetText("(none)") return end
        StopSlot() ; spinSubBtn:SetEnabled(false)
        subLabel:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
        StartSlot(subLabel, pool, function(_)
            subLabel:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3]) ; spinSubBtn:SetEnabled(true)
        end)
    end)

    spinBothBtn:SetScript("OnClick", function()
        local pool = WhatShouldIDoDB.activities ; if #pool==0 then return end
        StopSlot() ; spinCatBtn:SetEnabled(false) ; spinBothBtn:SetEnabled(false) ; ResetSub()
        catLabel:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
        StartSlot(catLabel, pool, function(w)
            lastCat=w ; catLabel:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3])
            local sub = GetSubPool(w)
            if sub and #sub>0 then
                subLabel:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
                StartSlot(subLabel, sub, function(_)
                    subLabel:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3])
                    spinCatBtn:SetEnabled(true) ; spinBothBtn:SetEnabled(true) ; spinSubBtn:SetEnabled(true)
                end)
            else
                subLabel:SetText("(none)") ; spinCatBtn:SetEnabled(true) ; spinBothBtn:SetEnabled(true)
            end
        end)
    end)

    return panel
end

------------------------------------------------------------------------
-- TAB 2: CREATOR
------------------------------------------------------------------------

local function BuildCreatorPanel(contentArea)
    local panel = MakePanel(contentArea)
    local W = CONT_W

    local hdr = MakeHeader(panel, "Character Creator", W)
    hdr:SetPoint("TOPLEFT", panel, "TOPLEFT", PAD, -PAD)

    local desc = MakeDimLabel(panel, "Spin a random valid Race + Class combo for a new character.", hdr, "BOTTOMLEFT", 4, -8)

    local raceBox, raceLabel = MakeResult(panel, W, 52, "RACE")
    raceBox:SetPoint("TOPLEFT", desc, "BOTTOMLEFT", -4, -12)
    raceLabel:SetText("Race")

    local classBox, classLabel = MakeResult(panel, W, 52, "CLASS")
    classBox:SetPoint("TOPLEFT", raceBox, "BOTTOMLEFT", 0, -10)
    classLabel:SetText("Class")

    local infoLbl = panel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    infoLbl:SetPoint("TOPLEFT", classBox, "BOTTOMLEFT", 4, -8)
    infoLbl:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3]) ; infoLbl:SetText(" ")

    -- Faction filter
    local filterLbl = panel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    filterLbl:SetPoint("TOPLEFT", infoLbl, "BOTTOMLEFT", 0, -8)
    filterLbl:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3]) ; filterLbl:SetText("Faction:")

    local factionFilter = "Any"
    local filterBtns = {}
    for i, opt in ipairs({"Any","Alliance","Horde"}) do
        local fb = MakeBtn(panel, opt, 84, 26)
        fb:SetPoint("LEFT", filterLbl, "RIGHT", 6+(i-1)*88, 0)
        local fo = opt
        local function Activate(b)
            b:SetBackdropColor(C.nav_active[1],C.nav_active[2],C.nav_active[3])
            b:SetBackdropBorderColor(C.nav_border[1],C.nav_border[2],C.nav_border[3],1)
            b._lbl:SetTextColor(1,1,1)
        end
        local function Deactivate(b)
            b:SetBackdropColor(C.btn_bg[1],C.btn_bg[2],C.btn_bg[3])
            b:SetBackdropBorderColor(C.btn_bdr[1],C.btn_bdr[2],C.btn_bdr[3],1)
            b._lbl:SetTextColor(C.btn_text[1],C.btn_text[2],C.btn_text[3])
        end
        fb:SetScript("OnClick", function()
            factionFilter=fo
            for _,b in ipairs(filterBtns) do Deactivate(b) end
            Activate(fb)
        end)
        table.insert(filterBtns, fb)
    end
    Activate = function(b)
        b:SetBackdropColor(C.nav_active[1],C.nav_active[2],C.nav_active[3])
        b:SetBackdropBorderColor(C.nav_border[1],C.nav_border[2],C.nav_border[3],1)
        b._lbl:SetTextColor(1,1,1)
    end
    filterBtns[1]:SetBackdropColor(C.nav_active[1],C.nav_active[2],C.nav_active[3])
    filterBtns[1]:SetBackdropBorderColor(C.nav_border[1],C.nav_border[2],C.nav_border[3],1)
    filterBtns[1]._lbl:SetTextColor(1,1,1)

    local halfW = math.floor((W-6)/2)
    local spinRaceBtn = MakeBtn(panel, "Spin Race", halfW, 30)
    spinRaceBtn:SetPoint("TOPLEFT", filterLbl, "BOTTOMLEFT", 0, -10)

    local spinClassBtn = MakeBtn(panel, "Spin Class", halfW, 30)
    spinClassBtn:SetPoint("TOPLEFT", filterLbl, "BOTTOMLEFT", halfW+6, -10)
    spinClassBtn:SetEnabled(false)

    local spinBothBtn = MakeBtn(panel, "Spin Both", W, 30)
    spinBothBtn:SetPoint("TOPLEFT", spinRaceBtn, "BOTTOMLEFT", 0, -6)

    local pickedRace = nil

    local function GetRaceNames()
        local names={}
        for _,r in ipairs(ALL_RACES) do
            if factionFilter=="Any" or r.faction==factionFilter or r.faction=="Neutral" then
                table.insert(names, r.race)
            end
        end
        return names
    end

    local function FindRace(name)
        for _,r in ipairs(ALL_RACES) do if r.race==name then return r end end
    end

    local function AfterRace(winner)
        pickedRace = FindRace(winner)
        raceLabel:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3])
        if pickedRace then
            local fc = pickedRace.faction=="Alliance" and "|cff4499ff"
                    or pickedRace.faction=="Horde"    and "|cffff4444" or "|cffaaaaaa"
            infoLbl:SetText(pickedRace.rtype.."  --  "..fc..pickedRace.faction.."|r")
        end
        spinRaceBtn:SetEnabled(true) ; spinBothBtn:SetEnabled(true) ; spinClassBtn:SetEnabled(true)
    end

    spinRaceBtn:SetScript("OnClick", function()
        local names=GetRaceNames() ; if #names==0 then return end
        StopSlot() ; spinRaceBtn:SetEnabled(false) ; spinBothBtn:SetEnabled(false)
        spinClassBtn:SetEnabled(false) ; pickedRace=nil
        classLabel:SetText("Class") ; classLabel:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
        infoLbl:SetText(" ") ; raceLabel:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
        StartSlot(raceLabel, names, AfterRace)
    end)

    spinClassBtn:SetScript("OnClick", function()
        if not pickedRace then return end
        local classes=CLASS_BY_RACE[pickedRace.race] ; if not classes then return end
        StopSlot() ; spinClassBtn:SetEnabled(false)
        classLabel:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
        StartSlot(classLabel, classes, function(w)
            local cc=CLASS_COLORS[w]
            if cc then classLabel:SetTextColor(cc.r,cc.g,cc.b)
            else classLabel:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3]) end
            spinClassBtn:SetEnabled(true)
        end)
    end)

    spinBothBtn:SetScript("OnClick", function()
        local names=GetRaceNames() ; if #names==0 then return end
        StopSlot() ; spinRaceBtn:SetEnabled(false) ; spinClassBtn:SetEnabled(false)
        spinBothBtn:SetEnabled(false) ; pickedRace=nil
        classLabel:SetText("Class") ; classLabel:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
        infoLbl:SetText(" ") ; raceLabel:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
        StartSlot(raceLabel, names, function(winner)
            AfterRace(winner)
            spinRaceBtn:SetEnabled(false) ; spinBothBtn:SetEnabled(false) ; spinClassBtn:SetEnabled(false)
            local classes = pickedRace and CLASS_BY_RACE[pickedRace.race] or {}
            if #classes==0 then spinRaceBtn:SetEnabled(true) ; spinBothBtn:SetEnabled(true) ; return end
            classLabel:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
            StartSlot(classLabel, classes, function(cls)
                local cc=CLASS_COLORS[cls]
                if cc then classLabel:SetTextColor(cc.r,cc.g,cc.b)
                else classLabel:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3]) end
                spinRaceBtn:SetEnabled(true) ; spinClassBtn:SetEnabled(true) ; spinBothBtn:SetEnabled(true)
            end)
        end)
    end)

    return panel
end

------------------------------------------------------------------------
-- TAB 3: LEVELING
------------------------------------------------------------------------
-- Layout budget (490px content height):
--   PAD(16)+hdr(28)+gap(10)+desc(14)+gap(12)+classBox(52)+gap(10)+spinBtn(30)
--   +gap(10)+charHdr(28)+charList(110)+gap(10)+expBox(52)+gap(10)
--   +btnRow(30)+gap(8)+note(14)+PAD(16) = 460px  fits cleanly

local function BuildLevelingPanel(contentArea)
    local panel = MakePanel(contentArea)
    local W = CONT_W

    local hdr = MakeHeader(panel, "Leveling Wheel", W)
    hdr:SetPoint("TOPLEFT", panel, "TOPLEFT", PAD, -PAD)

    local desc = MakeDimLabel(panel, "Spin a class -> pick a character -> spin an expansion.", hdr, "BOTTOMLEFT", 4, -8)

    local classBox, classLabel = MakeResult(panel, W, 52, "CLASS")
    classBox:SetPoint("TOPLEFT", desc, "BOTTOMLEFT", -4, -12)
    classLabel:SetText("Class")

    local spinClassBtn = MakeBtn(panel, "Spin Class", W, 30)
    spinClassBtn:SetPoint("TOPLEFT", classBox, "BOTTOMLEFT", 0, -10)

    local charHdr = MakeHeader(panel, "Characters of that class  (click to select)", W)
    charHdr:SetPoint("TOPLEFT", spinClassBtn, "BOTTOMLEFT", 0, -10)

    local listBG, listContent, listReset = MakeScrollBox(panel, W, 110)
    listBG:SetPoint("TOPLEFT", charHdr, "BOTTOMLEFT", 0, 0)

    local expBox, expLabel = MakeResult(panel, W, 52, "EXPANSION")
    expBox:SetPoint("TOPLEFT", listBG, "BOTTOMLEFT", 0, -10)
    expLabel:SetText("Expansion")

    local halfW = math.floor((W-6)/2)
    local spinExpBtn = MakeBtn(panel, "Spin Expansion", halfW, 30)
    spinExpBtn:SetPoint("TOPLEFT", expBox, "BOTTOMLEFT", 0, -10)
    spinExpBtn:SetEnabled(false)

    local spinAllBtn = MakeBtn(panel, "Spin All Steps", halfW, 30)
    spinAllBtn:SetPoint("TOPLEFT", expBox, "BOTTOMLEFT", halfW+6, -10)

    local noteLbl = panel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    noteLbl:SetPoint("TOPLEFT", spinExpBtn, "BOTTOMLEFT", 0, -10)
    noteLbl:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
    noteLbl:SetText("Roster fills automatically as you log into each character.")

    local pickedClass=nil ; local selectedChar=nil ; local charRows={}

    local function ClearList()
        for _,r in ipairs(charRows) do r:Hide() end
        charRows={} ; selectedChar=nil ; listContent:SetHeight(110) ; listReset()
    end

    local function PopulateList(class)
        ClearList()
        local matches={}
        for _,ch in ipairs(roster) do
            if ch.class==class and (ch.level or 0) < 90 then
                table.insert(matches,ch)
            end
        end
        if #matches==0 then
            local none=listContent:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            none:SetPoint("TOPLEFT",listContent,"TOPLEFT",8,-8)
            none:SetTextColor(0.65,0.30,0.30)
            none:SetText("No "..class.."s available for leveling.  (Max level characters are excluded.)")
            table.insert(charRows, none) ; listContent:SetHeight(30) ; return
        end
        for i,ch in ipairs(matches) do
            local even=(i%2==0)
            local row=CreateFrame("Button",nil,listContent)
            row:SetSize(W-2, 24)
            row:SetPoint("TOPLEFT",listContent,"TOPLEFT",0,-(i-1)*24)
            local rowBg=row:CreateTexture(nil,"BACKGROUND") ; rowBg:SetAllPoints()
            rowBg:SetColorTexture(even and C.row_even[1] or C.row_odd[1],
                                  even and C.row_even[2] or C.row_odd[2],
                                  even and C.row_even[3] or C.row_odd[3],1)
            local cc=CLASS_COLORS[ch.class] or {r=0.8,g=0.8,b=0.8}
            local fs=row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            fs:SetPoint("LEFT",row,"LEFT",10,0) ; fs:SetJustifyH("LEFT")
            fs:SetText(string.format("|cff%02x%02x%02x%s|r  |cffaaaaaa%s|r  |cffffcc00Lv %d|r%s",
                cc.r*255,cc.g*255,cc.b*255,ch.name,ch.race or "",ch.level or 0,
                ch.current and "  |cff55cc55(you)|r" or ""))
            local charData=ch
            row:SetScript("OnClick", function()
                selectedChar=charData
                for _,r in ipairs(charRows) do
                    if r._bg then
                        local re=r._even
                        r._bg:SetColorTexture(re and C.row_even[1] or C.row_odd[1],
                                              re and C.row_even[2] or C.row_odd[2],
                                              re and C.row_even[3] or C.row_odd[3],1)
                    end
                end
                rowBg:SetColorTexture(C.row_select[1],C.row_select[2],C.row_select[3],1)
            end)
            row:SetScript("OnEnter", function()
                if selectedChar~=charData then rowBg:SetColorTexture(C.row_hover[1],C.row_hover[2],C.row_hover[3],1) end end)
            row:SetScript("OnLeave", function()
                if selectedChar~=charData then
                    rowBg:SetColorTexture(even and C.row_even[1] or C.row_odd[1],
                                         even and C.row_even[2] or C.row_odd[2],
                                         even and C.row_even[3] or C.row_odd[3],1)
                end end)
            row._bg=rowBg ; row._even=even
            table.insert(charRows, row)
        end
        listContent:SetHeight(math.max(24,#matches*24+2))
    end

    local function DoSpinClass(onDone)
        local pool={} ; for cls in pairs(CLASS_COLORS) do table.insert(pool,cls) end
        StopSlot() ; pickedClass=nil ; selectedChar=nil
        classLabel:SetText("Class") ; classLabel:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
        expLabel:SetText("Expansion") ; expLabel:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
        spinExpBtn:SetEnabled(false) ; ClearList()
        classLabel:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
        StartSlot(classLabel, pool, function(winner)
            pickedClass=winner
            local cc=CLASS_COLORS[winner]
            if cc then classLabel:SetTextColor(cc.r,cc.g,cc.b) end
            PopulateList(winner) ; spinExpBtn:SetEnabled(true)
            if onDone then onDone(winner) end
        end)
    end

    spinClassBtn:SetScript("OnClick", function()
        spinClassBtn:SetEnabled(false) ; spinAllBtn:SetEnabled(false)
        DoSpinClass(function(_) spinClassBtn:SetEnabled(true) ; spinAllBtn:SetEnabled(true) end)
    end)

    spinExpBtn:SetScript("OnClick", function()
        if not selectedChar then
            UIErrorsFrame:AddMessage("|cffd5a742What Should I Do?:|r Select a character first.",1,0.8,0.2) ; return
        end
        local pool = GetExpansionPool(selectedChar.level or 1)
        if #pool == 1 then
            expLabel:SetText(pool[1])
            expLabel:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3])
            return
        end
        StopSlot() ; spinExpBtn:SetEnabled(false)
        expLabel:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
        StartSlot(expLabel, pool, function(_)
            expLabel:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3]) ; spinExpBtn:SetEnabled(true)
        end)
    end)

    spinAllBtn:SetScript("OnClick", function()
        spinClassBtn:SetEnabled(false) ; spinAllBtn:SetEnabled(false) ; spinExpBtn:SetEnabled(false)
        DoSpinClass(function(winner)
            local autoChar=nil
            for _,ch in ipairs(roster) do if ch.class==winner then autoChar=ch ; break end end
            if autoChar then
                selectedChar=autoChar
                if charRows[1] and charRows[1]._bg then
                    charRows[1]._bg:SetColorTexture(C.row_select[1],C.row_select[2],C.row_select[3],1)
                end
                local pool=GetExpansionPool(autoChar.level or 1)
                if #pool==1 then
                    expLabel:SetText(pool[1])
                    expLabel:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3])
                    spinClassBtn:SetEnabled(true) ; spinExpBtn:SetEnabled(true) ; spinAllBtn:SetEnabled(true)
                else
                    expLabel:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
                    StartSlot(expLabel, pool, function(_)
                        expLabel:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3])
                        spinClassBtn:SetEnabled(true) ; spinExpBtn:SetEnabled(true) ; spinAllBtn:SetEnabled(true)
                    end)
                end
            else
                spinClassBtn:SetEnabled(true) ; spinExpBtn:SetEnabled(true) ; spinAllBtn:SetEnabled(true)
            end
        end)
    end)

    return panel
end

------------------------------------------------------------------------
-- NAME GENERATOR DATA
------------------------------------------------------------------------

local NAME_DATA = {
    ["Human"] = {
        male   = {{"Al","Ard","Bren","Cal","Dar","Ed","Gar","Hal","Jan","Kel","Lor","Mar","Ned","Or","Per","Ran","Sar","Tal","Ulf","Val"},
                  {"an","ath","bert","dan","ek","en","ford","hard","ik","lan","len","mar","on","or","ric","rick","ton","us","win"}},
        female = {{"Ade","Bri","Cath","Dor","El","Gwen","Helen","Is","Joss","Kath","Lil","Mar","Mir","Nat","Or","Per","Ros","Sara","Tan","Val"},
                  {"a","aine","ath","en","ess","ia","ine","ith","la","len","lyn","na","nis","ora","ra","tha","ya"}},
    },
    ["Night Elf"] = {
        male   = {{"Ael","Alth","Aren","Cel","Dath","Elar","Fal","Halad","Iel","Kael","Lor","Mal","Nath","Oel","Reth","Sal","Tal","Vel","Xal","Zel"},
                  {"adan","amir","aran","avel","dath","elar","enar","ethas","idan","ilar","inar","istor","ithas","odath","oran","orin","othas","udath","unar"}},
        female = {{"Ash","Bel","Cel","Dath","Elun","Fael","Ilth","Kal","Lun","Mael","Nael","Quel","Rael","Sal","Tal","Thal","Uel","Val","Xal","Zel"},
                  {"ania","ara","aris","ath","dath","dris","elle","eris","iath","iel","inda","ira","ith","lia","liel","nara","nis","riel","sha","thas"}},
    },
    ["Orc"] = {
        male   = {{"Bak","Drak","Grak","Grom","Gor","Gruk","Karg","Krak","Lok","Mak","Mor","Nak","Orgr","Rak","Rok","Thrak","Trok","Urak","Vrak","Zug"},
                  {"al","am","ar","ash","az","dan","en","gal","gar","gath","grak","grim","gun","ish","kar","mak","mar","nosh","rok","tar","ush"}},
        female = {{"Azg","Drak","Gasha","Gruk","Kasha","Loka","Masha","Naka","Orka","Raka","Roka","Shaka","Thaka","Traka","Urka","Vaka","Waka","Yaka","Zaka","Zuga"},
                  {"a","asha","da","ga","isha","ka","la","ma","na","ra","sha","ta","thra","tuka","ya","za"}},
    },
    ["Dwarf"] = {
        male   = {{"Ald","Bald","Bor","Dar","Dun","Eld","Fal","Gald","Gimb","Gor","Grim","Gund","Hal","Keld","Morg","Orn","Thor","Thur","Ulf","Vol"},
                  {"ak","al","an","bar","bek","dar","din","ek","en","fur","gal","grim","in","ir","kin","lin","mir","nar","ok","rin","ur"}},
        female = {{"Ald","Beld","Bryn","Deld","Edl","Fald","Geld","Gild","Gyld","Held","Hyld","Ild","Keld","Meld","Nyld","Old","Ryld","Syld","Thyld","Wyld"},
                  {"a","ais","da","dis","dra","dris","dyn","ia","ina","ira","ith","na","nda","nis","ra","rin","rith","ryn","tha","yn"}},
    },
    ["Gnome"] = {
        male   = {{"Bil","Bim","Daz","Fiz","Giz","Kaz","Mek","Nib","Pix","Poz","Qix","Rix","Siz","Taz","Tik","Viz","Whiz","Wiz","Zap","Zip"},
                  {"blix","ble","borg","brix","daz","fiz","gix","gle","grik","lix","mek","nix","pix","plex","rix","snik","taz","tik","trix","zap","zig"}},
        female = {{"Bel","Bix","Daz","Fiz","Gix","Kaz","Mex","Nix","Pix","Qix","Rix","Siz","Taz","Tix","Vix","Wix","Xix","Yix","Zix","Zap"},
                  {"a","ble","da","dra","fiz","gix","ia","ina","ira","ith","la","lix","na","nia","nix","ra","rix","sha","tix","za"}},
    },
    ["Troll"] = {
        male   = {{"Akil","Bwon","Dal","Gan","Hak","Jin","Kaz","Khal","Mal","Rak","Ras","Sen","Tal","Vol","Wal","Zal","Zan","Zar","Zep","Zul"},
                  {"'a","'amon","'ar","'ari","'jin","'jin","'kah","'kan","'kar","'kas","'rak","'raki","'rik","'ro","'rok","'thas","'tiki","'zar","'zin","'zum"}},
        female = {{"Akil","Bwon","Dal","Gan","Hak","Jin","Kaz","Khal","Mal","Rak","Ras","Sen","Tal","Vol","Wal","Zal","Zan","Zar","Zep","Zul"},
                  {"'a","'aja","'ali","'ama","'ani","'ara","'ari","'asha","'ini","'ira","'isa","'ita","'iya","'ola","'ona","'ora","'sha","'tika","'ya","'za"}},
    },
    ["Blood Elf"] = {
        male   = {{"Ael","Anar","Bel","Dath","Elar","Fal","Ial","Kael","Lor","Mal","Nath","Quel","Rael","Sal","Selth","Tal","Thal","Vel","Xal","Zel"},
                  {"amir","anas","aran","aris","athas","dath","elar","enar","ethas","idan","ilar","iras","istor","ithas","odath","oran","orin","othas","umar","unar"}},
        female = {{"Aela","Bel","Cael","Dath","Elara","Fael","Iala","Kael","Lael","Mael","Nael","Quel","Rael","Sal","Sel","Tal","Thal","Vel","Xal","Zel"},
                  {"ania","ara","aris","ath","dath","dris","elle","eris","iath","iel","inda","ira","ith","lia","liel","nara","nis","riel","sha","thas"}},
    },
    ["Undead"] = {
        male   = {{"Ath","Bane","Cor","Crypt","Dark","Dead","Dread","Grim","Mal","Mor","Nec","Rot","Shade","Skel","Soul","Spite","Tomb","Vile","Wrath","Wraith"},
                  {"bone","blight","crypt","curse","death","decay","dread","fang","grim","grave","hate","maw","plague","rot","shade","skull","spite","tomb","vex","woe"}},
        female = {{"Ash","Bane","Cor","Crypt","Dark","Dead","Dread","Grim","Mal","Mor","Mor","Rot","Shade","Skel","Soul","Spite","Tomb","Vile","Wrath","Wraith"},
                  {"a","ash","bane","bone","da","dra","ia","ina","ira","ith","la","na","nia","ra","rith","sha","thas","vex","ya","za"}},
    },
    ["Draenei"] = {
        male   = {{"Akh","Azz","Dar","Dur","Esh","Ikh","Khar","Lor","Mar","Mor","Naz","Ner","Oth","Resh","Sha","Thar","Ther","Ukh","Vash","Zar"},
                  {"adar","adis","akhar","amosh","anak","anar","anosh","aras","aris","athas","athor","avash","edas","edis","enas","enis","ethas","ithar","ithos","udas"}},
        female = {{"Akh","Azz","Dar","Dur","Esh","Ikh","Khar","Lor","Mar","Mor","Naz","Ner","Oth","Resh","Sha","Thar","Ther","Ukh","Vash","Zar"},
                  {"a","adis","aeis","aia","aira","akia","alia","anis","aras","aria","asha","asis","atha","eis","ena","enia","ika","ilia","ira","isha"}},
    },
    ["Tauren"] = {
        male   = {{"Brug","Drak","Grak","Gor","Gruk","Hamuul","Karg","Krag","Lok","Mag","Mak","Mor","Mur","Nak","Rok","Rug","Tor","Torg","Unk","Zan"},
                  {"amani","anar","athar","atuk","duruk","gadar","ganar","gar","grak","inar","itar","kadar","kanar","nadar","nanar","rakar","ranar","tadar","tanar","turak"}},
        female = {{"Ayame","Azak","Brana","Drana","Grana","Hana","Jana","Kana","Lana","Mana","Nana","Rana","Rona","Sana","Tana","Tona","Uana","Vana","Wana","Yana"},
                  {"a","ada","ana","anda","ani","anka","ara","ari","asha","ata","aya","ina","ira","isha","ita","iya","ona","ora","sha","ya"}},
    },
    ["Worgen"] = {
        male   = {{"Ald","Arn","Balt","Bram","Cald","Drak","Eld","Falk","Grim","Hark","Keld","Mork","Nark","Ork","Ralk","Sark","Tark","Ulk","Vork","Wark"},
                  {"en","ar","ath","borne","cliffe","croft","dale","fell","ford","grimm","hurst","moor","more","ness","shaw","shire","thorpe","ton","vale","wood"}},
        female = {{"Ald","Ash","Bram","Cath","Drak","Eld","Falk","Grim","Hark","Keld","Mork","Nark","Ork","Ralk","Sark","Tark","Ulk","Vork","Wark","Wren"},
                  {"a","ah","ath","borne","dale","en","fell","ford","grimm","hurst","ia","ina","ira","ith","la","moor","na","ness","ra","sha"}},
    },
    ["Goblin"] = {
        male   = {{"Bix","Blaz","Daz","Fiz","Giz","Kaz","Krix","Mek","Nix","Pix","Rix","Slix","Snix","Stix","Taz","Trik","Vix","Wix","Zap","Zip"},
                  {"blix","ble","borg","brix","daz","fiz","gix","gle","grik","lix","mek","nix","pix","plex","rix","snik","taz","trik","trix","zap"}},
        female = {{"Bix","Blaz","Daz","Fiz","Giz","Kaz","Krix","Mek","Nix","Pix","Rix","Slix","Snix","Stix","Taz","Trik","Vix","Wix","Zap","Zip"},
                  {"a","ble","da","dra","fiz","gix","ia","ina","ira","ith","la","lix","na","nia","nix","ra","rix","sha","tix","za"}},
    },
    ["Pandaren"] = {
        male   = {{"Chen","Fei","Han","Ji","Kun","Lei","Li","Liang","Lin","Liu","Long","Mei","Ming","Peng","Quan","Shen","Wei","Xiao","Yan","Yu"},
                  {"bao","chen","da","feng","han","hua","ji","jian","jun","kun","lei","li","lian","long","ming","peng","qing","shan","wei","xuan"}},
        female = {{"Bao","Chen","Fei","Han","Ji","Kun","Lei","Li","Liang","Lin","Liu","Mei","Ming","Peng","Quan","Shen","Wei","Xiao","Yan","Yu"},
                  {"a","bao","chen","da","fen","hua","ia","ina","ira","ith","juan","la","lan","li","lian","mei","ming","na","ra","sha"}},
    },
    ["Void Elf"] = {
        male   = {{"Aethar","Crael","Dar","Dusk","Ethar","Fael","Gael","Hal","Iael","Jael","Kael","Lael","Mael","Nael","Oael","Pael","Rael","Sael","Tael","Vel"},
                  {"amir","anas","aran","aris","athas","dath","elar","enar","ethas","idan","ilar","iras","istor","ithas","odath","oran","orin","othas","umar","unar"}},
        female = {{"Aela","Bel","Cael","Dusk","Elara","Fael","Iala","Kael","Lael","Mael","Nael","Quel","Rael","Sal","Sel","Tal","Thal","Vel","Xal","Zel"},
                  {"ania","ara","aris","ath","dath","dris","elle","eris","iath","iel","inda","ira","ith","lia","liel","nara","nis","riel","sha","thas"}},
    },
    ["Dracthyr"] = {
        male   = {{"Arath","Drak","Embr","Flam","Frost","Gale","Imm","Keth","Lith","Malath","Nath","Rath","Scal","Sear","Smok","Storm","Thorn","Venth","Volc","Wyth"},
                  {"adon","adrak","akar","akath","aketh","alath","anath","arath","arkath","arnak","arrath","arshak","arthas","arwing","athos","aveth","axath","azrak","iketh","unwing"}},
        female = {{"Arath","Drak","Embr","Flam","Frost","Gale","Imm","Keth","Lith","Malath","Nath","Rath","Scal","Sear","Smok","Storm","Thorn","Venth","Volc","Wyth"},
                  {"a","adra","aela","aera","aia","aira","alia","anis","ara","aria","asha","ath","eia","ela","ena","enia","iera","ilia","ira","isha"}},
    },
    ["Earthen"] = {
        male   = {{"Ald","Bald","Bor","Dar","Dun","Eld","Fal","Gald","Grav","Gor","Grim","Gund","Hal","Iron","Keld","Morg","Ore","Stone","Thor","Vol"},
                  {"ak","al","an","bar","bek","dar","din","ek","en","fur","gal","grim","in","ir","kin","lin","mir","nar","ok","rin"}},
        female = {{"Ald","Beld","Bryn","Deld","Edl","Fald","Geld","Gild","Gyld","Held","Hyld","Ild","Keld","Meld","Nyld","Old","Ryld","Syld","Thyld","Wyld"},
                  {"a","ais","da","dis","dra","dris","dyn","ia","ina","ira","ith","na","nda","nis","ra","rin","rith","ryn","tha","yn"}},
    },
    ["Haranir"] = {
        male   = {{"Ahar","Bhar","Char","Dhar","Ehar","Fhar","Ghar","Hhar","Ihar","Jhar","Khar","Lhar","Mhar","Nhar","Ohar","Phar","Rhar","Shar","Thar","Vhar"},
                  {"anis","aras","aris","asha","asis","atha","edas","edis","enas","enis","ethas","ithar","ithos","udas","udar","unas","unar","uras","uris","usha"}},
        female = {{"Ahar","Bhar","Char","Dhar","Ehar","Fhar","Ghar","Hhar","Ihar","Jhar","Khar","Lhar","Mhar","Nhar","Ohar","Phar","Rhar","Shar","Thar","Vhar"},
                  {"a","adis","aeis","aia","aira","akia","alia","anis","aras","aria","asha","asis","atha","eis","ena","enia","ika","ilia","ira","isha"}},
    },
}

-- Races that share name tables with another
local NAME_ALIASES = {
    ["Gnome"]               = "Gnome",
    ["Dark Iron Dwarf"]     = "Dwarf",
    ["Lightforged Draenei"] = "Draenei",
    ["Kul Tiran"]           = "Human",
    ["Mechagnome"]          = "Gnome",
    ["Nightborne"]          = "Blood Elf",
    ["Highmountain Tauren"] = "Tauren",
    ["Mag'har Orc"]         = "Orc",
    ["Zandalari Troll"]     = "Troll",
    ["Vulpera"]             = "Goblin",
}

local function GenerateName(race, gender)
    local key = NAME_ALIASES[race] or race
    local data = NAME_DATA[key]
    if not data then
        -- fallback generic fantasy
        local pre = {"Ael","Bel","Cal","Dal","El","Fal","Gal","Hal","Ial","Kal"}
        local suf = {"an","ar","ath","en","ion","ith","or","un","us","yn"}
        return pre[math.random(#pre)] .. suf[math.random(#suf)]
    end
    local g = (gender == "Female") and "female" or "male"
    local prefixes = data[g][1]
    local suffixes = data[g][2]
    return prefixes[math.random(#prefixes)] .. suffixes[math.random(#suffixes)]
end

local function GenerateNameList(race, gender, count)
    local names = {}
    local seen  = {}
    local attempts = 0
    while #names < count and attempts < count * 10 do
        local n = GenerateName(race, gender)
        if not seen[n] then
            seen[n] = true
            table.insert(names, n)
        end
        attempts = attempts + 1
    end
    return names
end

------------------------------------------------------------------------
-- NAME GENERATOR PANEL
------------------------------------------------------------------------

local function BuildNamePanel(contentArea)
    local panel = MakePanel(contentArea)
    local W = CONT_W

    local hdr = MakeHeader(panel, "Name Generator", W)
    hdr:SetPoint("TOPLEFT", panel, "TOPLEFT", PAD, -PAD)

    local desc = MakeDimLabel(panel, "Pick a race and gender to generate a list of names.", hdr, "BOTTOMLEFT", 4, -8)

    -- Race dropdown (we'll use a simple scrollable button list)
    local raceLabel = panel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    raceLabel:SetPoint("TOPLEFT", desc, "BOTTOMLEFT", 0, -10)
    raceLabel:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
    raceLabel:SetText("Race:")

    -- Race selector display box
    local raceBox = CreateFrame("Button", nil, panel, "BackdropTemplate")
    raceBox:SetSize(200, 26)
    raceBox:SetPoint("LEFT", raceLabel, "RIGHT", 8, 0)
    BgBorder(raceBox, C.result_bg[1],C.result_bg[2],C.result_bg[3], C.result_bdr[1],C.result_bdr[2],C.result_bdr[3])
    local raceBoxLbl = raceBox:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    raceBoxLbl:SetPoint("LEFT", raceBox, "LEFT", 8, 0)
    raceBoxLbl:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
    raceBoxLbl:SetText("Select Race...")

    -- Gender toggle
    local genderLbl = panel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    genderLbl:SetPoint("LEFT", raceBox, "RIGHT", 16, 0)
    genderLbl:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
    genderLbl:SetText("Gender:")

    local selectedGender = "Male"
    local genderBtns = {}
    for i, g in ipairs({"Male","Female"}) do
        local gb = MakeBtn(panel, g, 72, 26)
        gb:SetPoint("LEFT", genderLbl, "RIGHT", 6+(i-1)*76, 0)
        local gv = g
        gb:SetScript("OnClick", function()
            selectedGender = gv
            for _, b in ipairs(genderBtns) do
                b:SetBackdropColor(C.btn_bg[1],C.btn_bg[2],C.btn_bg[3])
                b:SetBackdropBorderColor(C.btn_bdr[1],C.btn_bdr[2],C.btn_bdr[3],1)
                b._lbl:SetTextColor(C.btn_text[1],C.btn_text[2],C.btn_text[3])
            end
            gb:SetBackdropColor(C.nav_active[1],C.nav_active[2],C.nav_active[3])
            gb:SetBackdropBorderColor(C.nav_border[1],C.nav_border[2],C.nav_border[3],1)
            gb._lbl:SetTextColor(1,1,1)
        end)
        table.insert(genderBtns, gb)
    end
    -- Default Male active
    genderBtns[1]:SetBackdropColor(C.nav_active[1],C.nav_active[2],C.nav_active[3])
    genderBtns[1]:SetBackdropBorderColor(C.nav_border[1],C.nav_border[2],C.nav_border[3],1)
    genderBtns[1]._lbl:SetTextColor(1,1,1)

    -- Race dropdown popup
    local raceList = CreateFrame("Frame", nil, panel, "BackdropTemplate")
    raceList:SetSize(200, 300)
    raceList:SetPoint("TOPLEFT", raceBox, "BOTTOMLEFT", 0, -2)
    raceList:SetFrameStrata("TOOLTIP")
    BgBorder(raceList, C.bg[1],C.bg[2],C.bg[3], C.win_border[1],C.win_border[2],C.win_border[3])
    raceList:Hide()

    local allRaces = {}
    for _, r in ipairs(ALL_RACES) do table.insert(allRaces, r.race) end
    table.sort(allRaces)

    local selectedRace = nil
    local raceRowFrames = {}

    local raceScroll, raceScrollContent, _ = MakeScrollBox(raceList, 198, 298)
    raceScroll:SetPoint("TOPLEFT", raceList, "TOPLEFT", 1, -1)

    for i, race in ipairs(allRaces) do
        local row = CreateFrame("Button", nil, raceScrollContent)
        row:SetSize(196, 22)
        row:SetPoint("TOPLEFT", raceScrollContent, "TOPLEFT", 0, -(i-1)*22)
        local rbg = row:CreateTexture(nil,"BACKGROUND") ; rbg:SetAllPoints()
        rbg:SetColorTexture(i%2==0 and C.row_even[1] or C.row_odd[1],
                            i%2==0 and C.row_even[2] or C.row_odd[2],
                            i%2==0 and C.row_even[3] or C.row_odd[3], 1)
        local rlbl = row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        rlbl:SetPoint("LEFT", row, "LEFT", 8, 0) ; rlbl:SetJustifyH("LEFT")
        rlbl:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
        rlbl:SetText(race)
        local rv = race
        row:SetScript("OnClick", function()
            selectedRace = rv
            raceBoxLbl:SetText(rv)
            raceBoxLbl:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3])
            raceList:Hide()
            for _, r in ipairs(raceRowFrames) do r._bg:SetColorTexture(r._ec and C.row_even[1] or C.row_odd[1],r._ec and C.row_even[2] or C.row_odd[2],r._ec and C.row_even[3] or C.row_odd[3],1) end
            rbg:SetColorTexture(C.row_select[1],C.row_select[2],C.row_select[3],1)
        end)
        row:SetScript("OnEnter", function() if selectedRace~=rv then rbg:SetColorTexture(C.row_hover[1],C.row_hover[2],C.row_hover[3],1) end end)
        row:SetScript("OnLeave", function() if selectedRace~=rv then rbg:SetColorTexture(i%2==0 and C.row_even[1] or C.row_odd[1],i%2==0 and C.row_even[2] or C.row_odd[2],i%2==0 and C.row_even[3] or C.row_odd[3],1) end end)
        row._bg = rbg ; row._ec = (i%2==0)
        table.insert(raceRowFrames, row)
    end
    raceScrollContent:SetHeight(#allRaces * 22 + 2)

    raceBox:SetScript("OnClick", function()
        if raceList:IsShown() then raceList:Hide() else raceList:Show() end
    end)

    -- Generate button
    local generateBtn = MakeBtn(panel, "Generate Names", W, 30)
    generateBtn:SetPoint("TOPLEFT", raceLabel, "BOTTOMLEFT", 0, -14)

    -- Name list scroll
    local nameHdr = MakeHeader(panel, "Generated Names  (click to copy to chat)", W)
    nameHdr:SetPoint("TOPLEFT", generateBtn, "BOTTOMLEFT", 0, -10)

    local nameBG, nameContent, nameReset = MakeScrollBox(panel, W, 200)
    nameBG:SetPoint("TOPLEFT", nameHdr, "BOTTOMLEFT", 0, 0)

    local nameRows = {}

    local function RenderNames(names)
        for _, r in ipairs(nameRows) do r:Hide() end
        nameRows = {}
        for i, name in ipairs(names) do
            local even = (i%2==0)
            local row = CreateFrame("Button", nil, nameContent)
            row:SetSize(W-2, 26)
            row:SetPoint("TOPLEFT", nameContent, "TOPLEFT", 0, -(i-1)*26)
            local rb = row:CreateTexture(nil,"BACKGROUND") ; rb:SetAllPoints()
            rb:SetColorTexture(even and C.row_even[1] or C.row_odd[1],
                               even and C.row_even[2] or C.row_odd[2],
                               even and C.row_even[3] or C.row_odd[3], 1)
            local nl = row:CreateFontString(nil,"OVERLAY")
            nl:SetFont("Fonts\\FRIZQT__.TTF", 13, "")
            nl:SetPoint("LEFT", row, "LEFT", 12, 0) ; nl:SetJustifyH("LEFT")
            nl:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3])
            nl:SetText(name)

            local copyHint = row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            copyHint:SetPoint("RIGHT", row, "RIGHT", -10, 0)
            copyHint:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
            copyHint:SetText("click to copy")
            copyHint:Hide()

            local n = name
            row:SetScript("OnClick", function()
                -- Copy to default chat editbox
                ChatFrame_OpenChat(n)
            end)
            row:SetScript("OnEnter", function()
                rb:SetColorTexture(C.row_hover[1],C.row_hover[2],C.row_hover[3],1)
                copyHint:Show()
            end)
            row:SetScript("OnLeave", function()
                rb:SetColorTexture(even and C.row_even[1] or C.row_odd[1],
                                   even and C.row_even[2] or C.row_odd[2],
                                   even and C.row_even[3] or C.row_odd[3], 1)
                copyHint:Hide()
            end)
            table.insert(nameRows, row)
        end
        nameContent:SetHeight(math.max(26, #names*26+2))
        nameReset()
    end

    generateBtn:SetScript("OnClick", function()
        if not selectedRace then
            UIErrorsFrame:AddMessage("|cffd5a742What Should I Do?:|r Select a race first.", 1,0.8,0.2)
            return
        end
        raceList:Hide()
        local names = GenerateNameList(selectedRace, selectedGender, 10)
        RenderNames(names)
    end)

    -- Also generate when race is selected from dropdown
    -- (handled inline above; user can click Generate)

    return panel
end

------------------------------------------------------------------------
-- PROFESSION PICKER PANEL
------------------------------------------------------------------------

local PROFESSIONS = {
    "Alchemy","Blacksmithing","Enchanting","Engineering","Herbalism",
    "Inscription","Jewelcrafting","Leatherworking","Mining","Skinning","Tailoring",
    "Fishing","Cooking",
}

local function BuildProfessionPanel(contentArea)
    local panel = MakePanel(contentArea)
    local W = CONT_W

    local hdr = MakeHeader(panel, "Profession Picker", W)
    hdr:SetPoint("TOPLEFT", panel, "TOPLEFT", PAD, -PAD)

    local desc = MakeDimLabel(panel, "Spin two professions for your character.", hdr, "BOTTOMLEFT", 4, -8)

    local halfW = math.floor((W - 10) / 2)

    local prof1Box, prof1Label = MakeResult(panel, halfW, 52, "PROFESSION 1")
    prof1Box:SetPoint("TOPLEFT", desc, "BOTTOMLEFT", -4, -12)
    prof1Label:SetText("--")

    local prof2Box, prof2Label = MakeResult(panel, halfW, 52, "PROFESSION 2")
    prof2Box:SetPoint("TOPLEFT", prof1Box, "TOPRIGHT", 10, 0)
    prof2Label:SetText("--")

    local spinBtn = MakeBtn(panel, "Spin Professions", W, 30)
    spinBtn:SetPoint("TOPLEFT", prof1Box, "BOTTOMLEFT", 0, -10)

    local pairNote = panel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    pairNote:SetPoint("TOPLEFT", spinBtn, "BOTTOMLEFT", 0, -12)
    pairNote:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
    pairNote:SetText(" ") ; pairNote:SetWidth(W)

    local spinning = false

    spinBtn:SetScript("OnClick", function()
        if spinning then return end
        local pool = {}
        for _, p in ipairs(PROFESSIONS) do
            if p ~= "Fishing" and p ~= "Cooking" then
                table.insert(pool, p)
            end
        end
        if #pool < 2 then return end
        spinning = true ; spinBtn:SetEnabled(false) ; pairNote:SetText(" ")

        -- Pre-pick two different winners
        local idx1   = math.random(#pool)
        local winner1 = pool[idx1]
        local pool2  = {}
        for _, p in ipairs(pool) do if p ~= winner1 then table.insert(pool2, p) end end
        local winner2 = pool2[math.random(#pool2)]

        prof1Label:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
        prof2Label:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])

        -- Chain: spin 1 then spin 2
        StartSlot(prof1Label, pool, function(_)
            prof1Label:SetText(winner1)
            prof1Label:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3])
            StartSlot(prof2Label, pool2, function(_)
                prof2Label:SetText(winner2)
                prof2Label:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3])
                spinning = false ; spinBtn:SetEnabled(true)
                pairNote:SetText(winner1 .. " + " .. winner2)
                pairNote:SetTextColor(C.header_txt[1],C.header_txt[2],C.header_txt[3])
            end)
        end)
    end)

    return panel
end

------------------------------------------------------------------------
-- RAIDS & DUNGEONS PANEL
------------------------------------------------------------------------

local RAIDS_BY_EXPANSION = {
    ["The Burning Crusade"]     = {"Karazhan","Gruul's Lair","Magtheridon's Lair","Serpentshrine Cavern","Tempest Keep","Mount Hyjal","Black Temple","Sunwell Plateau"},
    ["Wrath of the Lich King"]  = {"Naxxramas","The Obsidian Sanctum","The Eye of Eternity","Ulduar","Trial of the Crusader","Onyxia's Lair","Icecrown Citadel","The Ruby Sanctum"},
    ["Cataclysm"]               = {"Blackwing Descent","The Bastion of Twilight","Throne of the Four Winds","Firelands","Dragon Soul"},
    ["Mists of Pandaria"]       = {"Mogu'shan Vaults","Heart of Fear","Terrace of Endless Spring","Throne of Thunder","Siege of Orgrimmar"},
    ["Warlords of Draenor"]     = {"Highmaul","Blackrock Foundry","Hellfire Citadel"},
    ["Legion"]                  = {"The Emerald Nightmare","Trial of Valor","The Nighthold","Tomb of Sargeras","Antorus the Burning Throne"},
    ["Battle for Azeroth"]      = {"Uldir","Battle of Dazar'alor","Crucible of Storms","The Eternal Palace","Ny'alotha the Waking City"},
    ["Shadowlands"]             = {"Castle Nathria","Sanctum of Domination","Sepulcher of the First Ones"},
    ["Dragonflight"]            = {"Vault of the Incarnates","Aberrus the Shadowed Crucible","Amirdrassil the Dream's Hope"},
    ["The War Within"]          = {"Nerub-ar Palace","Liberation of Undermine"},
    ["Midnight"]                = {"The Bleeding Edge","Cinderbrew Meadery","Darkflame Cleft","The Dawnbreaker","Operation: Floodgate","Priory of the Sacred Flame","The Rookery","The Stonevault"},
}

local DUNGEONS_BY_EXPANSION = {
    ["Classic"]                 = {"Ragefire Chasm","Wailing Caverns","The Deadmines","Shadowfang Keep","Blackfathom Deeps","The Stockade","Gnomeregan","Razorfen Kraul","Scarlet Monastery","Razorfen Downs","Uldaman","Zul'Farrak","Maraudon","Temple of Atal'Hakkar","Blackrock Depths","Lower Blackrock Spire","Upper Blackrock Spire","Dire Maul","Stratholme","Scholomance"},
    ["The Burning Crusade"]     = {"Hellfire Ramparts","The Blood Furnace","The Slave Pens","The Underbog","Mana-Tombs","Auchenai Crypts","Sethekk Halls","Shadow Labyrinth","The Shattered Halls","The Steamvault","The Botanica","The Mechanar","Old Hillsbrad Foothills","The Black Morass","Magister's Terrace"},
    ["Wrath of the Lich King"]  = {"Utgarde Keep","The Nexus","Azjol-Nerub","Ahn'kahet","Drak'Tharon Keep","Violet Hold","Gundrak","Halls of Stone","Halls of Lightning","The Oculus","Utgarde Pinnacle","The Culling of Stratholme","Trial of the Champion","The Forge of Souls","Pit of Saron","Halls of Reflection"},
    ["Cataclysm"]               = {"Blackrock Caverns","Throne of the Tides","The Stonecore","The Vortex Pinnacle","Lost City of Tol'vir","The Halls of Origination","Grim Batol","Deadmines","Shadowfang Keep","End Time","Well of Eternity","Hour of Twilight","Zul'Gurub","Zul'Aman"},
    ["Mists of Pandaria"]       = {"Temple of the Jade Serpent","Stormstout Brewery","Shado-pan Monastery","Gate of the Setting Sun","Mogu'shan Palace","Siege of Niuzao Temple","Scarlet Halls","Scarlet Monastery","Scholomance","Siege of Niuzao Temple"},
    ["Warlords of Draenor"]     = {"Bloodmaul Slag Mines","Iron Docks","Auchindoun","Skyreach","The Everbloom","Grimrail Depot","Upper Blackrock Spire","Shadowmoon Burial Grounds"},
    ["Legion"]                  = {"Eye of Azshara","Darkheart Thicket","Black Rook Hold","Halls of Valor","Neltharion's Lair","Vault of the Wardens","Court of Stars","The Arcway","Cathedral of Eternal Night","Return to Karazhan","Seat of the Triumvirate"},
    ["Battle for Azeroth"]      = {"Atal'Dazar","Freehold","Tol Dagor","The MOTHERLODE!!","Waycrest Manor","Kings' Rest","Temple of Sethraliss","Underrot","Shrine of the Storm","Siege of Boralus","Operation: Mechagon"},
    ["Shadowlands"]             = {"Mists of Tirna Scithe","The Necrotic Wake","De Other Side","Halls of Atonement","Plaguefall","Spires of Ascension","Theater of Pain","Sanguine Depths","Tazavesh the Veiled Market"},
    ["Dragonflight"]            = {"Ruby Life Pools","The Nokhud Offensive","The Azure Vault","Algeth'ar Academy","Uldaman: Legacy of Tyr","Neltharus","Brackenhide Hollow","Halls of Infusion","Dawn of the Infinite","Murozond's Rise"},
    ["The War Within"]          = {"The Rookery","The Stonevault","City of Threads","The Dawnbreaker","Ara-Kara City of Echoes","Darkflame Cleft","Priory of the Sacred Flame","The Necrotic Wake"},
    ["Midnight"]                = {"Cinderbrew Meadery","Darkflame Cleft","The Dawnbreaker","Operation: Floodgate","Priory of the Sacred Flame","The Rookery","The Stonevault","Liberation of Undermine"},
}

local function BuildRaidDungeonPanel(contentArea)
    local panel = MakePanel(contentArea)
    local W = CONT_W

    local hdr = MakeHeader(panel, "Raids & Dungeons", W)
    hdr:SetPoint("TOPLEFT", panel, "TOPLEFT", PAD, -PAD)

    local desc = MakeDimLabel(panel, "Choose Raids or Dungeons, spin an expansion, then spin a random instance.", hdr, "BOTTOMLEFT", 4, -8)

    -- Mode toggle: Raids or Dungeons
    local modeLbl = panel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    modeLbl:SetPoint("TOPLEFT", desc, "BOTTOMLEFT", 0, -10)
    modeLbl:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
    modeLbl:SetText("Mode:")

    local mode = "Raids"
    local modeBtns = {}
    for i, m in ipairs({"Raids","Dungeons"}) do
        local mb = MakeBtn(panel, m, 100, 26)
        mb:SetPoint("LEFT", modeLbl, "RIGHT", 6+(i-1)*104, 0)
        local mv = m
        mb:SetScript("OnClick", function()
            mode = mv
            for _, b in ipairs(modeBtns) do
                b:SetBackdropColor(C.btn_bg[1],C.btn_bg[2],C.btn_bg[3])
                b:SetBackdropBorderColor(C.btn_bdr[1],C.btn_bdr[2],C.btn_bdr[3],1)
                b._lbl:SetTextColor(C.btn_text[1],C.btn_text[2],C.btn_text[3])
            end
            mb:SetBackdropColor(C.nav_active[1],C.nav_active[2],C.nav_active[3])
            mb:SetBackdropBorderColor(C.nav_border[1],C.nav_border[2],C.nav_border[3],1)
            mb._lbl:SetTextColor(1,1,1)
        end)
        table.insert(modeBtns, mb)
    end
    -- Default: Raids active
    modeBtns[1]:SetBackdropColor(C.nav_active[1],C.nav_active[2],C.nav_active[3])
    modeBtns[1]:SetBackdropBorderColor(C.nav_border[1],C.nav_border[2],C.nav_border[3],1)
    modeBtns[1]._lbl:SetTextColor(1,1,1)

    -- Expansion result
    local expBox, expLabel = MakeResult(panel, W, 52, "EXPANSION")
    expBox:SetPoint("TOPLEFT", modeLbl, "BOTTOMLEFT", 0, -12)
    expLabel:SetText("Expansion")

    -- Instance result
    local instBox, instLabel = MakeResult(panel, W, 52, "RAID / DUNGEON")
    instBox:SetPoint("TOPLEFT", expBox, "BOTTOMLEFT", 0, -8)
    instLabel:SetText("--")

    -- Spin buttons
    local halfW = math.floor((W-6)/2)
    local spinExpBtn = MakeBtn(panel, "Spin Expansion", halfW, 30)
    spinExpBtn:SetPoint("TOPLEFT", instBox, "BOTTOMLEFT", 0, -10)

    local spinInstBtn = MakeBtn(panel, "Spin Instance", halfW, 30)
    spinInstBtn:SetPoint("TOPLEFT", instBox, "BOTTOMLEFT", halfW+6, -10)
    spinInstBtn:SetEnabled(false)

    local spinBothBtn = MakeBtn(panel, "Spin Both", W, 30)
    spinBothBtn:SetPoint("TOPLEFT", spinExpBtn, "BOTTOMLEFT", 0, -6)

    local pickedExp = nil

    local function GetExpansionList()
        local pool = {}
        local src = mode == "Raids" and RAIDS_BY_EXPANSION or DUNGEONS_BY_EXPANSION
        for exp, instances in pairs(src) do
            if #instances > 0 then table.insert(pool, exp) end
        end
        -- Sort chronologically
        local ORDER = {"Classic","The Burning Crusade","Wrath of the Lich King","Cataclysm","Mists of Pandaria","Warlords of Draenor","Legion","Battle for Azeroth","Shadowlands","Dragonflight","The War Within","Midnight"}
        table.sort(pool, function(a,b)
            local ai, bi = 99, 99
            for i,v in ipairs(ORDER) do if v==a then ai=i end if v==b then bi=i end end
            return ai < bi
        end)
        return pool
    end

    local function GetInstanceList(exp)
        local src = mode == "Raids" and RAIDS_BY_EXPANSION or DUNGEONS_BY_EXPANSION
        return src[exp] or {}
    end

    spinExpBtn:SetScript("OnClick", function()
        local pool = GetExpansionList()
        if #pool == 0 then return end
        StopSlot()
        spinExpBtn:SetEnabled(false) ; spinBothBtn:SetEnabled(false)
        spinInstBtn:SetEnabled(false) ; pickedExp = nil
        instLabel:SetText("--") ; instLabel:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
        expLabel:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
        StartSlot(expLabel, pool, function(winner)
            pickedExp = winner
            expLabel:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3])
            spinExpBtn:SetEnabled(true) ; spinBothBtn:SetEnabled(true) ; spinInstBtn:SetEnabled(true)
        end)
    end)

    spinInstBtn:SetScript("OnClick", function()
        if not pickedExp then return end
        local pool = GetInstanceList(pickedExp)
        if #pool == 0 then instLabel:SetText("None found") return end
        StopSlot() ; spinInstBtn:SetEnabled(false)
        instLabel:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
        StartSlot(instLabel, pool, function(_)
            instLabel:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3])
            spinInstBtn:SetEnabled(true)
        end)
    end)

    spinBothBtn:SetScript("OnClick", function()
        local pool = GetExpansionList()
        if #pool == 0 then return end
        StopSlot()
        spinExpBtn:SetEnabled(false) ; spinBothBtn:SetEnabled(false) ; spinInstBtn:SetEnabled(false)
        pickedExp = nil
        instLabel:SetText("--") ; instLabel:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
        expLabel:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
        StartSlot(expLabel, pool, function(winner)
            pickedExp = winner
            expLabel:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3])
            local instPool = GetInstanceList(winner)
            if #instPool == 0 then
                spinExpBtn:SetEnabled(true) ; spinBothBtn:SetEnabled(true) ; return
            end
            instLabel:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
            StartSlot(instLabel, instPool, function(_)
                instLabel:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3])
                spinExpBtn:SetEnabled(true) ; spinBothBtn:SetEnabled(true) ; spinInstBtn:SetEnabled(true)
            end)
        end)
    end)

    return panel
end

local function BuildAboutPanel(contentArea)
    local panel = MakePanel(contentArea)
    local W = CONT_W

    local scrollBG, scrollContent, scrollReset = MakeScrollBox(panel, W, WIN_H-30-PAD*2)
    scrollBG:SetPoint("TOPLEFT", panel, "TOPLEFT", PAD, -PAD)

    local lines = {
        {text="What Should I Do?", size=16, color={C.bright_text[1],C.bright_text[2],C.bright_text[3]}},
        {text="Version 1.0.0",     size=11, color={C.dim_text[1],C.dim_text[2],C.dim_text[3]}},
        {text=" ", size=5},
        {text="Author:  I_AM_T3X", size=12, color={C.bright_text[1],C.bright_text[2],C.bright_text[3]}},
        {text=" ", size=5},
        {text="A spin-wheel decision helper for World of Warcraft.", size=12, color={C.bright_text[1],C.bright_text[2],C.bright_text[3]}},
        {text="Can't decide what to do? Let the wheels choose for you.", size=11, color={C.dim_text[1],C.dim_text[2],C.dim_text[3]}},
        {text=" ", size=5},
        {text="Wheels:", size=12, color={C.header_txt[1],C.header_txt[2],C.header_txt[3]}},
        {text="Activity         --  Spin a category and sub-activity.", size=11, color={C.dim_text[1],C.dim_text[2],C.dim_text[3]}},
        {text="Creator          --  Spin a random Race + Class combo.", size=11, color={C.dim_text[1],C.dim_text[2],C.dim_text[3]}},
        {text="Leveling         --  Spin a class, pick a char, spin an expansion.", size=11, color={C.dim_text[1],C.dim_text[2],C.dim_text[3]}},
        {text="Name Generator   --  Generate race-appropriate character names.", size=11, color={C.dim_text[1],C.dim_text[2],C.dim_text[3]}},
        {text="Professions      --  Spin two random primary professions.", size=11, color={C.dim_text[1],C.dim_text[2],C.dim_text[3]}},
        {text="Raids & Dungeons --  Spin an expansion then a random instance.", size=11, color={C.dim_text[1],C.dim_text[2],C.dim_text[3]}},
        {text=" ", size=5},
        {text="Slash Commands:", size=12, color={C.header_txt[1],C.header_txt[2],C.header_txt[3]}},
        {text="/wsid              --  Toggle main window", size=11, color={C.dim_text[1],C.dim_text[2],C.dim_text[3]}},
        {text="/sw                --  Toggle main window (alias)", size=11, color={C.dim_text[1],C.dim_text[2],C.dim_text[3]}},
        {text="/wsid settings     --  Open settings", size=11, color={C.dim_text[1],C.dim_text[2],C.dim_text[3]}},
        {text="/wsid roster       --  Refresh character roster", size=11, color={C.dim_text[1],C.dim_text[2],C.dim_text[3]}},
        {text=" ", size=5},
        {text="Roster:", size=12, color={C.header_txt[1],C.header_txt[2],C.header_txt[3]}},
        {text="Characters are added automatically each time you log in.", size=11, color={C.dim_text[1],C.dim_text[2],C.dim_text[3]}},
        {text="Leveling wheel excludes max level (90) characters.", size=11, color={C.dim_text[1],C.dim_text[2],C.dim_text[3]}},
        {text="Use Settings -- Import/Export to share rosters between accounts.", size=11, color={C.dim_text[1],C.dim_text[2],C.dim_text[3]}},
        {text=" ", size=5},
        {text="Settings:", size=12, color={C.header_txt[1],C.header_txt[2],C.header_txt[3]}},
        {text="Activities    --  Add/remove categories and their sub-activities.", size=11, color={C.dim_text[1],C.dim_text[2],C.dim_text[3]}},
        {text="Roster        --  View and remove characters from the roster.", size=11, color={C.dim_text[1],C.dim_text[2],C.dim_text[3]}},
        {text="Import/Export --  Share roster strings between two accounts.", size=11, color={C.dim_text[1],C.dim_text[2],C.dim_text[3]}},
        {text="Colors        --  Pick a preset theme or build custom colors.", size=11, color={C.dim_text[1],C.dim_text[2],C.dim_text[3]}},
        {text=" ", size=5},
        {text="Minimap Button:", size=12, color={C.header_txt[1],C.header_txt[2],C.header_txt[3]}},
        {text="Left-click   --  Open or close the main window.", size=11, color={C.dim_text[1],C.dim_text[2],C.dim_text[3]}},
        {text="Right-click  --  Open Settings.", size=11, color={C.dim_text[1],C.dim_text[2],C.dim_text[3]}},
        {text="Drag         --  Reposition around the minimap.", size=11, color={C.dim_text[1],C.dim_text[2],C.dim_text[3]}},
        {text=" ", size=5},
        {text="Special Thanks:", size=12, color={C.header_txt[1],C.header_txt[2],C.header_txt[3]}},
        {text="MajGhostPants  --  For the inspiration and feedback.", size=11, color={C.dim_text[1],C.dim_text[2],C.dim_text[3]}},
        {text="twitch.tv/majghostpants", size=11, color={C.spin_text[1],C.spin_text[2],C.spin_text[3]}},
    }

    local yOff = -8
    for _, line in ipairs(lines) do
        local fs = scrollContent:CreateFontString(nil, "OVERLAY")
        fs:SetFont("Fonts\\FRIZQT__.TTF", line.size or 12, "")
        fs:SetPoint("TOPLEFT", scrollContent, "TOPLEFT", 10, yOff)
        fs:SetWidth(W - 24) ; fs:SetJustifyH("LEFT") ; fs:SetWordWrap(true)
        fs:SetText(line.text)
        if line.color then fs:SetTextColor(line.color[1], line.color[2], line.color[3])
        else fs:SetTextColor(C.dim_text[1], C.dim_text[2], C.dim_text[3]) end
        yOff = yOff - (line.size or 12) - 4
    end
    scrollContent:SetHeight(math.abs(yOff) + 20)
    return panel
end

------------------------------------------------------------------------
-- SETTINGS WINDOW
------------------------------------------------------------------------
-- Settings: 700w x 500h, NAV=110, content=590, two cols each=285

local SET_W   = 700
local SET_H   = 500
local SET_NAV = 110
local SET_PAD = 12
local SET_CW  = SET_W - SET_NAV - SET_PAD * 2   -- 700-110-24 = 566
local SET_COL = math.floor((SET_CW - 12) / 2)   -- (566-12)/2 = 277

local settingsFrame
local refreshActivities = nil
local refreshRoster     = nil

local function BuildSettingsWindow()
    local f = CreateFrame("Frame","WhatShouldIDoSettings",UIParent,"BackdropTemplate")
    f:SetSize(SET_W, SET_H)
    f:SetPoint("CENTER",UIParent,"CENTER",280,0)
    f:SetMovable(true) ; f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart",f.StartMoving) ; f:SetScript("OnDragStop",f.StopMovingOrSizing)
    f:SetFrameStrata("DIALOG") ; f:SetFrameLevel(20)
    f:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8x8",edgeFile="Interface\\Buttons\\WHITE8x8",edgeSize=1})
    f:SetBackdropColor(C.bg[1],C.bg[2],C.bg[3],1)
    f:SetBackdropBorderColor(C.win_border[1],C.win_border[2],C.win_border[3],1)
    f:Hide()

    -- Title bar
    local tb=CreateFrame("Frame",nil,f) ; tb:SetHeight(30)
    tb:SetPoint("TOPLEFT",f,"TOPLEFT",0,0) ; tb:SetPoint("TOPRIGHT",f,"TOPRIGHT",0,0)
    Tx(tb,C.sidebar[1],C.sidebar[2],C.sidebar[3])
    local tbBord=tb:CreateTexture(nil,"ARTWORK")
    tbBord:SetColorTexture(C.divider[1],C.divider[2],C.divider[3],1) ; tbBord:SetHeight(1)
    tbBord:SetPoint("BOTTOMLEFT",tb,"BOTTOMLEFT",0,0) ; tbBord:SetPoint("BOTTOMRIGHT",tb,"BOTTOMRIGHT",0,0)
    local tbLbl=tb:CreateFontString(nil,"OVERLAY","GameFontNormal")
    tbLbl:SetPoint("LEFT",tb,"LEFT",10,0)
    tbLbl:SetText("What Should I Do?  --  Settings") ; tbLbl:SetTextColor(C.header_txt[1],C.header_txt[2],C.header_txt[3])
    local closeBtn=CreateFrame("Button",nil,f,"UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT",f,"TOPRIGHT",-2,-2)

    -- Left nav
    local navBg=CreateFrame("Frame",nil,f)
    navBg:SetPoint("TOPLEFT",f,"TOPLEFT",0,-30) ; navBg:SetPoint("BOTTOMLEFT",f,"BOTTOMLEFT",0,0)
    navBg:SetWidth(SET_NAV)
    Tx(navBg,C.sidebar[1],C.sidebar[2],C.sidebar[3])
    local nd=navBg:CreateTexture(nil,"ARTWORK")
    nd:SetColorTexture(C.divider[1],C.divider[2],C.divider[3],1) ; nd:SetWidth(1)
    nd:SetPoint("TOPRIGHT",navBg,"TOPRIGHT",0,0) ; nd:SetPoint("BOTTOMRIGHT",navBg,"BOTTOMRIGHT",0,0)

    local content=CreateFrame("Frame",nil,f)
    content:SetPoint("TOPLEFT",f,"TOPLEFT",SET_NAV,-30)
    content:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",0,0)

    local actPanel=CreateFrame("Frame",nil,content) ; actPanel:SetAllPoints(content) ; actPanel:Hide()
    local rostPanel=CreateFrame("Frame",nil,content) ; rostPanel:SetAllPoints(content) ; rostPanel:Hide()
    local ioPanel=CreateFrame("Frame",nil,content)   ; ioPanel:SetAllPoints(content)   ; ioPanel:Hide()
    local colorsPanel=CreateFrame("Frame",nil,content) ; colorsPanel:SetAllPoints(content) ; colorsPanel:Hide()
    local PANELS={activities=actPanel,roster=rostPanel,importexport=ioPanel,colors=colorsPanel}
    local navBtns={} ; local navActive=nil

    local function SetNavActive(name)
        navActive=name
        for k,b in pairs(navBtns) do
            if k==name then b.bg:SetColorTexture(C.nav_active[1],C.nav_active[2],C.nav_active[3],1) ; b.stripe:Show() ; b.lbl:SetTextColor(1,1,1)
            else b.bg:SetColorTexture(0,0,0,0) ; b.stripe:Hide() ; b.lbl:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3]) end
        end
        for k,p in pairs(PANELS) do if k==name then p:Show() else p:Hide() end end
        if name=="activities" and refreshActivities then refreshActivities() end
        if name=="roster"     and refreshRoster     then refreshRoster() end
    end

    for i,def in ipairs({{name="activities",label="Activities"},{name="roster",label="Roster"},{name="importexport",label="Import/Export"},{name="colors",label="Colors"}}) do
        local row=CreateFrame("Button",nil,navBg) ; row:SetSize(SET_NAV,36)
        row:SetPoint("TOPLEFT",navBg,"TOPLEFT",0,-(i-1)*36)
        local bg=row:CreateTexture(nil,"BACKGROUND") ; bg:SetAllPoints() ; bg:SetColorTexture(0,0,0,0)
        local stripe=row:CreateTexture(nil,"ARTWORK")
        stripe:SetColorTexture(C.nav_border[1],C.nav_border[2],C.nav_border[3],1)
        stripe:SetSize(3,36) ; stripe:SetPoint("LEFT",row,"LEFT",0,0) ; stripe:Hide()
        local lbl=row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        lbl:SetPoint("LEFT",row,"LEFT",12,0) ; lbl:SetText(def.label)
        lbl:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
        local name=def.name
        row:SetScript("OnClick",function() SetNavActive(name) end)
        row:SetScript("OnEnter",function() if navActive~=name then bg:SetColorTexture(C.nav_hover[1],C.nav_hover[2],C.nav_hover[3],1) ; lbl:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3]) end end)
        row:SetScript("OnLeave",function() if navActive~=name then bg:SetColorTexture(0,0,0,0) ; lbl:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3]) end end)
        navBtns[def.name]={bg=bg,stripe=stripe,lbl=lbl}
    end

    --------------------------------------------------------------------
    -- ACTIVITIES PANEL: two columns
    --------------------------------------------------------------------
    -- Column layout: PAD(12) | COL(277) | gap(12) | COL(277) | PAD(12) = 590 = SET_CW ok
    -- Row heights: hdr(28) + scroll(280) + gap(10) + addRow(26) + gap(8) + resetBtn(26) = 378 < (500-30-12) = 458 ok

    local SCRL_H = 280  -- scroll list height
    local BTN_H  = 26
    local GAP    = 10

    -- Left column: Categories
    local catHdr = MakeHeader(actPanel, "Categories", SET_COL)
    catHdr:SetPoint("TOPLEFT", actPanel, "TOPLEFT", SET_PAD, -SET_PAD)

    local catCount=actPanel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    catCount:SetPoint("RIGHT",catHdr,"RIGHT",-6,0) ; catCount:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])

    local catBG,catContent,catReset=MakeScrollBox(actPanel,SET_COL,SCRL_H)
    catBG:SetPoint("TOPLEFT",catHdr,"BOTTOMLEFT",0,-4)

    local catAddBtn=MakeBtn(actPanel,"Add",54,BTN_H)
    catAddBtn:SetPoint("TOPRIGHT",catBG,"BOTTOMRIGHT",0,-GAP)

    local catAddBox=CreateFrame("EditBox",nil,actPanel,"BackdropTemplate")
    catAddBox:SetHeight(BTN_H)
    catAddBox:SetPoint("TOPLEFT",catBG,"BOTTOMLEFT",0,-GAP)
    catAddBox:SetPoint("TOPRIGHT",catAddBtn,"TOPLEFT",-6,0)
    catAddBox:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8x8",edgeFile="Interface\\Buttons\\WHITE8x8",edgeSize=1})
    catAddBox:SetBackdropColor(0.04,0.03,0.08,1)
    catAddBox:SetBackdropBorderColor(C.divider[1],C.divider[2],C.divider[3],1)
    catAddBox:SetFont("Fonts\\FRIZQT__.TTF",11,"")
    catAddBox:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
    catAddBox:SetTextInsets(6,6,2,2)
    catAddBox:SetAutoFocus(false) ; catAddBox:SetMaxLetters(64)
    catAddBox:SetScript("OnEditFocusGained",function(s) s:SetBackdropBorderColor(C.result_bdr[1],C.result_bdr[2],C.result_bdr[3],1) end)
    catAddBox:SetScript("OnEditFocusLost",  function(s) s:SetBackdropBorderColor(C.divider[1],C.divider[2],C.divider[3],1) end)

    local catResetBtn=MakeBtn(actPanel,"Reset All Defaults",SET_COL,BTN_H)
    catResetBtn:SetPoint("TOPLEFT",catBG,"BOTTOMLEFT",0,-(GAP+BTN_H+28))

    -- Right column: Sub-Activities
    local subHdr=MakeHeader(actPanel,"Sub-Activities",SET_COL)
    subHdr:SetPoint("TOPLEFT",catHdr,"TOPRIGHT",12,0)

    local subCount=actPanel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    subCount:SetPoint("RIGHT",subHdr,"RIGHT",-6,0) ; subCount:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])

    local subSelLbl=actPanel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    subSelLbl:SetPoint("TOPLEFT",subHdr,"BOTTOMLEFT",4,-4)
    subSelLbl:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
    subSelLbl:SetText("(click a category to edit its sub-activities)")
    subSelLbl:SetWidth(SET_COL)

    -- Sub scroll must align vertically with cat scroll despite the extra label line
    -- Anchor subBG to subHdr bottom + fixed 28px (label height) to keep tops aligned
    local subBG,subContent,subReset=MakeScrollBox(actPanel,SET_COL,SCRL_H)
    subBG:SetPoint("TOPLEFT",subHdr,"BOTTOMLEFT",0,-28)

    local subAddBtn=MakeBtn(actPanel,"Add",54,BTN_H)
    subAddBtn:SetPoint("TOPRIGHT",subBG,"BOTTOMRIGHT",0,-GAP)
    subAddBtn:SetEnabled(false)

    local subAddBox=CreateFrame("EditBox",nil,actPanel,"BackdropTemplate")
    subAddBox:SetHeight(BTN_H)
    subAddBox:SetPoint("TOPLEFT",subBG,"BOTTOMLEFT",0,-GAP)
    subAddBox:SetPoint("TOPRIGHT",subAddBtn,"TOPLEFT",-6,0)
    subAddBox:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8x8",edgeFile="Interface\\Buttons\\WHITE8x8",edgeSize=1})
    subAddBox:SetBackdropColor(0.04,0.03,0.08,1)
    subAddBox:SetBackdropBorderColor(C.divider[1],C.divider[2],C.divider[3],1)
    subAddBox:SetFont("Fonts\\FRIZQT__.TTF",11,"")
    subAddBox:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
    subAddBox:SetTextInsets(6,6,2,2)
    subAddBox:SetAutoFocus(false) ; subAddBox:SetMaxLetters(64)
    subAddBox:SetScript("OnEditFocusGained",function(s) s:SetBackdropBorderColor(C.result_bdr[1],C.result_bdr[2],C.result_bdr[3],1) end)
    subAddBox:SetScript("OnEditFocusLost",  function(s) s:SetBackdropBorderColor(C.divider[1],C.divider[2],C.divider[3],1) end)

    -- State
    local selectedCat=nil ; local catRows={} ; local subRows={} ; local catRowBgs={}

    local function RefreshSubList()
        for _,r in ipairs(subRows) do r:Hide() end ; subRows={}
        if not selectedCat then subCount:SetText("") ; subAddBtn:SetEnabled(false) ; return end
        if not WhatShouldIDoDB.subActivities then WhatShouldIDoDB.subActivities={} end
        local subs=WhatShouldIDoDB.subActivities[selectedCat]
        if not subs then
            subs={}
            if SMART_OPTIONS[selectedCat] then
                for _,v in ipairs(SMART_OPTIONS[selectedCat]) do table.insert(subs,v) end
            end
            WhatShouldIDoDB.subActivities[selectedCat]=subs
        end
        subCount:SetText("["..#subs.."]") ; subAddBtn:SetEnabled(true)
        for i,sub in ipairs(subs) do
            local even=(i%2==0)
            local row=CreateFrame("Frame",nil,subContent)
            row:SetSize(SET_COL-2,22) ; row:SetPoint("TOPLEFT",subContent,"TOPLEFT",0,-(i-1)*22)
            local rb=row:CreateTexture(nil,"BACKGROUND") ; rb:SetAllPoints()
            rb:SetColorTexture(even and C.row_even[1] or C.row_odd[1],even and C.row_even[2] or C.row_odd[2],even and C.row_even[3] or C.row_odd[3],1)
            local fs=row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            fs:SetPoint("LEFT",row,"LEFT",6,0) ; fs:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
            fs:SetJustifyH("LEFT") ; fs:SetText(sub) ; fs:SetWidth(SET_COL-28)
            local xBtn=CreateFrame("Button",nil,row) ; xBtn:SetSize(20,22) ; xBtn:SetPoint("RIGHT",row,"RIGHT",0,0)
            local xL=xBtn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall") ; xL:SetAllPoints() ; xL:SetJustifyH("CENTER") ; xL:SetText("|cffcc3333x|r")
            local idx=i
            xBtn:SetScript("OnClick",function() table.remove(WhatShouldIDoDB.subActivities[selectedCat],idx) ; RefreshSubList() end)
            xBtn:SetScript("OnEnter",function() xL:SetText("|cffff5555x|r") end)
            xBtn:SetScript("OnLeave",function() xL:SetText("|cffcc3333x|r") end)
            table.insert(subRows,row)
        end
        subContent:SetHeight(math.max(22,#subs*22+2)) ; subReset()
    end

    local function SelectCat(name,rowBg)
        selectedCat=name
        for _,rb in ipairs(catRowBgs) do rb:SetColorTexture(C.row_even[1],C.row_even[2],C.row_even[3],1) end
        rowBg:SetColorTexture(C.row_select[1],C.row_select[2],C.row_select[3],1)
        subSelLbl:SetText(name) ; subSelLbl:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3])
        RefreshSubList()
    end

    refreshActivities=function()
        for _,r in ipairs(catRows) do r:Hide() end ; catRows={} ; catRowBgs={}
        selectedCat=nil
        subSelLbl:SetText("(click a category to edit its sub-activities)")
        subSelLbl:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
        for _,r in ipairs(subRows) do r:Hide() end ; subRows={} ; subCount:SetText("") ; subAddBtn:SetEnabled(false)
        local acts=WhatShouldIDoDB.activities ; catCount:SetText("["..#acts.."]")
        for i,act in ipairs(acts) do
            local even=(i%2==0)
            local row=CreateFrame("Button",nil,catContent)
            row:SetSize(SET_COL-2,22) ; row:SetPoint("TOPLEFT",catContent,"TOPLEFT",0,-(i-1)*22)
            local rb=row:CreateTexture(nil,"BACKGROUND") ; rb:SetAllPoints()
            rb:SetColorTexture(even and C.row_even[1] or C.row_odd[1],even and C.row_even[2] or C.row_odd[2],even and C.row_even[3] or C.row_odd[3],1)
            table.insert(catRowBgs,rb)
            local nl=row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            nl:SetPoint("LEFT",row,"LEFT",6,0) ; nl:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
            nl:SetJustifyH("LEFT") ; nl:SetText(act) ; nl:SetWidth(SET_COL-28)
            local xBtn=CreateFrame("Button",nil,row) ; xBtn:SetSize(20,22) ; xBtn:SetPoint("RIGHT",row,"RIGHT",0,0)
            local xL=xBtn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall") ; xL:SetAllPoints() ; xL:SetJustifyH("CENTER") ; xL:SetText("|cffcc3333x|r")
            local idx=i
            xBtn:SetScript("OnClick",function()
                if selectedCat==WhatShouldIDoDB.activities[idx] then
                    selectedCat=nil ; subSelLbl:SetText("(click a category to edit its sub-activities)")
                    subSelLbl:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
                    for _,r in ipairs(subRows) do r:Hide() end ; subRows={} ; subCount:SetText("") ; subAddBtn:SetEnabled(false)
                end
                table.remove(WhatShouldIDoDB.activities,idx) ; refreshActivities()
            end)
            xBtn:SetScript("OnEnter",function() xL:SetText("|cffff5555x|r") end)
            xBtn:SetScript("OnLeave",function() xL:SetText("|cffcc3333x|r") end)
            local actName=act
            row:SetScript("OnClick",function() SelectCat(actName,rb) end)
            row:SetScript("OnEnter",function() if selectedCat~=actName then rb:SetColorTexture(C.row_hover[1],C.row_hover[2],C.row_hover[3],1) end end)
            row:SetScript("OnLeave",function()
                if selectedCat~=actName then rb:SetColorTexture(even and C.row_even[1] or C.row_odd[1],even and C.row_even[2] or C.row_odd[2],even and C.row_even[3] or C.row_odd[3],1) end end)
            table.insert(catRows,row)
        end
        catContent:SetHeight(math.max(22,#acts*22+2)) ; catReset()
    end

    local function DoCatAdd()
        local txt=strtrim(catAddBox:GetText()) ; if txt=="" then return end
        table.insert(WhatShouldIDoDB.activities,txt) ; catAddBox:SetText("") ; refreshActivities()
    end
    catAddBtn:SetScript("OnClick",DoCatAdd) ; catAddBox:SetScript("OnEnterPressed",DoCatAdd)

    local function DoSubAdd()
        if not selectedCat then return end
        local txt=strtrim(subAddBox:GetText()) ; if txt=="" then return end
        if not WhatShouldIDoDB.subActivities then WhatShouldIDoDB.subActivities={} end
        if not WhatShouldIDoDB.subActivities[selectedCat] then WhatShouldIDoDB.subActivities[selectedCat]={} end
        table.insert(WhatShouldIDoDB.subActivities[selectedCat],txt) ; subAddBox:SetText("") ; RefreshSubList()
    end
    subAddBtn:SetScript("OnClick",DoSubAdd) ; subAddBox:SetScript("OnEnterPressed",DoSubAdd)

    catResetBtn:SetScript("OnClick",function()
        WhatShouldIDoDB.activities={} ; for _,v in ipairs(DEFAULT_ACTIVITIES) do table.insert(WhatShouldIDoDB.activities,v) end
        WhatShouldIDoDB.subActivities={} ; refreshActivities()
    end)

    --------------------------------------------------------------------
    -- ROSTER PANEL
    --------------------------------------------------------------------

    local rostHdr=MakeHeader(rostPanel,"Seen Characters",SET_CW)
    rostHdr:SetPoint("TOPLEFT",rostPanel,"TOPLEFT",SET_PAD,-SET_PAD)
    local rostCount=rostPanel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    rostCount:SetPoint("RIGHT",rostHdr,"RIGHT",-6,0) ; rostCount:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
    local rostNote=rostPanel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    rostNote:SetPoint("TOPLEFT",rostHdr,"BOTTOMLEFT",4,-6)
    rostNote:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
    rostNote:SetText("Log into each alt to add it. Levels update on every login.")
    rostNote:SetWidth(SET_CW)

    local rostBG,rostContent,rostReset=MakeScrollBox(rostPanel,SET_CW,SET_H-30-SET_PAD*2-80)
    rostBG:SetPoint("TOPLEFT",rostNote,"BOTTOMLEFT",0,-8)

    local rostRows={}
    refreshRoster=function()
        for _,r in ipairs(rostRows) do r:Hide() end ; rostRows={}
        local chars=WhatShouldIDoDB.seenChars ; rostCount:SetText("["..#chars.."]")
        for i,ch in ipairs(chars) do
            local even=(i%2==0)
            local row=CreateFrame("Frame",nil,rostContent)
            row:SetSize(SET_CW-2,24) ; row:SetPoint("TOPLEFT",rostContent,"TOPLEFT",0,-(i-1)*24)
            local rb=row:CreateTexture(nil,"BACKGROUND") ; rb:SetAllPoints()
            rb:SetColorTexture(even and C.row_even[1] or C.row_odd[1],even and C.row_even[2] or C.row_odd[2],even and C.row_even[3] or C.row_odd[3],1)
            local cc=CLASS_COLORS[ch.class] or {r=0.8,g=0.8,b=0.8}
            local fs=row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            fs:SetPoint("LEFT",row,"LEFT",10,0) ; fs:SetJustifyH("LEFT")
            fs:SetText(string.format("|cff%02x%02x%02x%s|r  |cffaaaaaa%s %s|r  |cffffcc00Lv %d|r",
                cc.r*255,cc.g*255,cc.b*255,ch.name,ch.race or "",ch.class or "",ch.level or 0))
            local isCurrent=(ch.name==UnitName("player"))
            if isCurrent then
                local yl=row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
                yl:SetPoint("RIGHT",row,"RIGHT",-8,0) ; yl:SetTextColor(0.30,0.75,0.30) ; yl:SetText("(you)")
            else
                local xBtn=CreateFrame("Button",nil,row) ; xBtn:SetSize(20,24) ; xBtn:SetPoint("RIGHT",row,"RIGHT",0,0)
                local xL=xBtn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall") ; xL:SetAllPoints() ; xL:SetJustifyH("CENTER") ; xL:SetText("|cffcc3333x|r")
                local cn=ch.name
                xBtn:SetScript("OnClick",function() RemoveCharFromRoster(cn) ; refreshRoster() end)
                xBtn:SetScript("OnEnter",function() xL:SetText("|cffff5555x|r") end)
                xBtn:SetScript("OnLeave",function() xL:SetText("|cffcc3333x|r") end)
            end
            table.insert(rostRows,row)
        end
        rostContent:SetHeight(math.max(24,#chars*24+2)) ; rostReset()
    end

    local clearBtn=MakeBtn(rostPanel,"Clear All Others",SET_CW,BTN_H)
    clearBtn:SetPoint("TOPLEFT",rostBG,"BOTTOMLEFT",0,-10)
    clearBtn:SetScript("OnClick",function()
        local cur=UnitName("player") ; local kept={}
        for _,ch in ipairs(WhatShouldIDoDB.seenChars) do if ch.name==cur then table.insert(kept,ch) end end
        WhatShouldIDoDB.seenChars=kept ; BuildRoster() ; refreshRoster()
        print("|cffd5a742What Should I Do?:|r Roster cleared.")
    end)

    --------------------------------------------------------------------
    -- IMPORT / EXPORT PANEL
    --------------------------------------------------------------------

    local function MakeEditArea(parent, anchorFrame, anchorOff, h)
        local bg = CreateFrame("Frame", nil, parent, "BackdropTemplate")
        bg:SetSize(SET_CW, h)
        bg:SetPoint("TOPLEFT", anchorFrame, "BOTTOMLEFT", 0, anchorOff or -8)
        bg:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8x8",edgeFile="Interface\\Buttons\\WHITE8x8",edgeSize=1})
        bg:SetBackdropColor(0.03,0.02,0.06,1)
        bg:SetBackdropBorderColor(C.divider[1],C.divider[2],C.divider[3],1)
        local eb = CreateFrame("EditBox", nil, bg)
        eb:SetPoint("TOPLEFT",     bg, "TOPLEFT",     6, -6)
        eb:SetPoint("BOTTOMRIGHT", bg, "BOTTOMRIGHT", -6,  6)
        eb:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
        eb:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
        eb:SetMultiLine(true)
        eb:SetAutoFocus(false)
        eb:SetMaxLetters(0)  -- unlimited
        eb:SetScript("OnEditFocusGained", function() bg:SetBackdropBorderColor(C.result_bdr[1],C.result_bdr[2],C.result_bdr[3],1) end)
        eb:SetScript("OnEditFocusLost",   function() bg:SetBackdropBorderColor(C.divider[1],C.divider[2],C.divider[3],1) end)
        return bg, eb
    end

    -- Export section
    local expHdr = MakeHeader(ioPanel, "Export Roster", SET_CW)
    expHdr:SetPoint("TOPLEFT", ioPanel, "TOPLEFT", SET_PAD, -SET_PAD)

    local expDesc = ioPanel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    expDesc:SetPoint("TOPLEFT", expHdr, "BOTTOMLEFT", 4, -6)
    expDesc:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
    expDesc:SetText("Click Export to generate a string. Copy it and use Import on your other account.")
    expDesc:SetWidth(SET_CW)

    local expBtn = MakeBtn(ioPanel, "Export Roster", SET_CW, 28)
    expBtn:SetPoint("TOPLEFT", expDesc, "BOTTOMLEFT", 0, -8)

    local _, expBox = MakeEditArea(ioPanel, expBtn, -8, 80)
    expBox:SetScript("OnChar", function(s) s:SetText(s:GetText()) end)  -- read-only feel

    expBtn:SetScript("OnClick", function()
        local chars = WhatShouldIDoDB.seenChars
        if not chars or #chars == 0 then
            expBox:SetText("No characters in roster to export.")
            return
        end
        local parts = {}
        for _, ch in ipairs(chars) do
            table.insert(parts, table.concat({
                ch.name    or "",
                ch.class   or "",
                tostring(ch.level or 0),
                ch.race    or "",
                ch.faction or "",
            }, ":"))
        end
        expBox:SetText("WSID:" .. table.concat(parts, "|"))
        expBox:SetFocus()
        expBox:HighlightText()
    end)

    -- Divider
    local ioRule = ioPanel:CreateTexture(nil,"ARTWORK")
    ioRule:SetColorTexture(C.divider[1],C.divider[2],C.divider[3],1) ; ioRule:SetHeight(1)
    -- anchor to bottom of expBox parent (MakeEditArea returns bg as first value; we need to anchor to it)
    -- Re-find it by anchoring relative to expBtn with a known offset
    ioRule:SetPoint("TOPLEFT",  expBtn, "BOTTOMLEFT",  0, -104)
    ioRule:SetPoint("TOPRIGHT", expBtn, "BOTTOMRIGHT", 0, -104)

    -- Import section
    local impHdr = MakeHeader(ioPanel, "Import Roster", SET_CW)
    impHdr:SetPoint("TOPLEFT", ioRule, "BOTTOMLEFT", 0, -10)

    local impDesc = ioPanel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    impDesc:SetPoint("TOPLEFT", impHdr, "BOTTOMLEFT", 4, -6)
    impDesc:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
    impDesc:SetText("Paste an export string from another account, then click Import. Existing characters will not be duplicated.")
    impDesc:SetWidth(SET_CW)

    local _, impBox = MakeEditArea(ioPanel, impDesc, -8, 80)

    local impBtn = MakeBtn(ioPanel, "Import Roster", SET_CW, 28)
    impBtn:SetPoint("TOPLEFT", impDesc, "BOTTOMLEFT", 0, -98)

    local impStatus = ioPanel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    impStatus:SetPoint("TOPLEFT", impBtn, "BOTTOMLEFT", 4, -8)
    impStatus:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
    impStatus:SetText(" ")
    impStatus:SetWidth(SET_CW)

    impBtn:SetScript("OnClick", function()
        local importStr = strtrim(impBox:GetText())
        if importStr == "" then
            impStatus:SetText("Paste an export string first.")
            impStatus:SetTextColor(0.8,0.3,0.3)
            return
        end
        if importStr:sub(1,5) ~= "WSID:" then
            impStatus:SetText("Invalid string. Must start with WSID:")
            impStatus:SetTextColor(0.8,0.3,0.3)
            return
        end
        local data = importStr:sub(6)
        local imported = 0
        local updated  = 0
        for entry in data:gmatch("[^|]+") do
            local name,class,level,race,faction = entry:match("^([^:]+):([^:]+):([^:]+):([^:]+):([^:]+)$")
            if name and name ~= "" then
                local exists = false
                for _, ch in ipairs(WhatShouldIDoDB.seenChars) do
                    if ch.name == name then
                        if tonumber(level) and tonumber(level) > (ch.level or 0) then
                            ch.level = tonumber(level) ; updated = updated + 1
                        end
                        exists = true ; break
                    end
                end
                if not exists then
                    table.insert(WhatShouldIDoDB.seenChars, {
                        name=name, class=class, level=tonumber(level) or 0, race=race, faction=faction,
                    })
                    imported = imported + 1
                end
            end
        end
        BuildRoster()
        if refreshRoster then refreshRoster() end
        impBox:SetText("")
        impStatus:SetTextColor(0.3,0.8,0.3)
        impStatus:SetText(string.format("Done! %d character(s) added, %d level(s) updated.", imported, updated))
    end)

    f:SetScript("OnShow",function() SetNavActive("activities") end)
    SetNavActive("activities")
    return f
end

    --------------------------------------------------------------------
    -- COLORS PANEL
    --------------------------------------------------------------------

    local colScrollBG, colScrollContent, _ = MakeScrollBox(colorsPanel, SET_CW, SET_H - 30 - SET_PAD * 2)
    colScrollBG:SetPoint("TOPLEFT", colorsPanel, "TOPLEFT", SET_PAD, -SET_PAD)

    local colHdr = MakeHeader(colScrollContent, "Color Theme", SET_CW - 4)
    colHdr:SetPoint("TOPLEFT", colScrollContent, "TOPLEFT", 0, -4)

    local colDesc = colScrollContent:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    colDesc:SetPoint("TOPLEFT", colHdr, "BOTTOMLEFT", 4, -6)
    colDesc:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
    colDesc:SetText("Select a theme. A UI reload is required to fully apply the new colors.")
    colDesc:SetWidth(SET_CW - 8)

    local themeSep = colScrollContent:CreateTexture(nil,"ARTWORK")
    themeSep:SetColorTexture(C.divider[1],C.divider[2],C.divider[3],1) ; themeSep:SetHeight(1)
    themeSep:SetPoint("TOPLEFT",  colDesc, "BOTTOMLEFT",  0, -10)
    themeSep:SetPoint("TOPRIGHT", colDesc, "BOTTOMRIGHT", 0, -10)

    local themeHdr = colScrollContent:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    themeHdr:SetPoint("TOPLEFT", themeSep, "BOTTOMLEFT", 0, -8)
    themeHdr:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
    themeHdr:SetText("Preset Themes:")

    -- Confirm popup helper
    local function ConfirmAndReload(themeName, displayName, onConfirm)
        StaticPopupDialogs["WSID_CONFIRM_THEME"] = {
            text = "Apply the "..displayName.." theme?\n\nThe UI will reload to apply the new colors.",
            button1 = "Yes, Apply",
            button2 = "Cancel",
            OnAccept = function()
                if onConfirm then onConfirm() end
                WhatShouldIDoDB.colorTheme = themeName
                ReloadUI()
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
        }
        StaticPopup_Show("WSID_CONFIRM_THEME")
    end

    local THEME_DEFS = {
        {name="Default",      label="Default",      desc="The original purple theme."},
        {name="Deuteranopia", label="Deuteranopia", desc="Red-green colorblind. Blue/cyan accents."},
        {name="Protanopia",   label="Protanopia",   desc="Red blind. Deep blue accents."},
        {name="Tritanopia",   label="Tritanopia",   desc="Blue-yellow blind. Orange/amber accents."},
        {name="HighContrast", label="High Contrast",desc="Black background with yellow accents."},
    }

    local themeBtns = {}
    local function UpdateThemeBtns()
        local cur = WhatShouldIDoDB.colorTheme or "Default"
        for _, tb in ipairs(themeBtns) do
            if tb._theme == cur then
                tb:SetBackdropColor(C.nav_active[1],C.nav_active[2],C.nav_active[3])
                tb:SetBackdropBorderColor(C.nav_border[1],C.nav_border[2],C.nav_border[3],1)
                tb._lbl:SetTextColor(1,1,1)
            else
                tb:SetBackdropColor(C.btn_bg[1],C.btn_bg[2],C.btn_bg[3])
                tb:SetBackdropBorderColor(C.btn_bdr[1],C.btn_bdr[2],C.btn_bdr[3],1)
                tb._lbl:SetTextColor(C.btn_text[1],C.btn_text[2],C.btn_text[3])
            end
        end
    end

    local prevRow = themeHdr
    for _, td in ipairs(THEME_DEFS) do
        local row = CreateFrame("Frame", nil, colScrollContent)
        row:SetSize(SET_CW - 4, 28)
        row:SetPoint("TOPLEFT", prevRow, "BOTTOMLEFT", 0, -6)

        local btn = MakeBtn(row, td.label, 140, 26)
        btn:SetPoint("TOPLEFT", row, "TOPLEFT", 0, 0)
        local tname = td.name
        local tlabel = td.label
        btn._theme = tname
        btn:SetScript("OnClick", function()
            ConfirmAndReload(tname, tlabel)
        end)
        table.insert(themeBtns, btn)

        local dlbl = row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        dlbl:SetPoint("LEFT", btn, "RIGHT", 10, 0)
        dlbl:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
        dlbl:SetText(td.desc)
        prevRow = row
    end

    UpdateThemeBtns()

    -- Custom section
    local customSep = colScrollContent:CreateTexture(nil,"ARTWORK")
    customSep:SetColorTexture(C.divider[1],C.divider[2],C.divider[3],1) ; customSep:SetHeight(1)
    customSep:SetPoint("TOPLEFT",  prevRow, "BOTTOMLEFT",  0, -12)
    customSep:SetPoint("TOPRIGHT", prevRow, "BOTTOMRIGHT", 0, -12)

    local customHdr = colScrollContent:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    customHdr:SetPoint("TOPLEFT", customSep, "BOTTOMLEFT", 0, -8)
    customHdr:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
    customHdr:SetText("Custom Colors -- click Edit to pick a color. Hit Apply when done.")

    local CUSTOM_KEYS = {
        {key="nav_border",  label="Accent / Border"},
        {key="btn_bdr",     label="Button Border"},
        {key="header_txt",  label="Header Text"},
        {key="spin_text",   label="Spin Result Text"},
        {key="bright_text", label="Bright Text"},
        {key="bg",          label="Background"},
    }

    local swatchRefs = {}  -- track swatches so we can update them after color pick

    local function OpenColorPicker(key, swatch)
        -- Auto-select Custom theme when editing colors
        WhatShouldIDoDB.colorTheme = "Custom"
        UpdateThemeBtns()
        if not WhatShouldIDoDB.customColors then WhatShouldIDoDB.customColors = {} end
        -- Seed all keys from current C table if not yet set
        for k,v in pairs(C) do
            if not WhatShouldIDoDB.customColors[k] then
                WhatShouldIDoDB.customColors[k] = {v[1],v[2],v[3]}
            end
        end
        local cur = WhatShouldIDoDB.customColors[key] or C[key]
        local info = {}
        info.r, info.g, info.b = cur[1], cur[2], cur[3]
        info.hasOpacity = false
        info.swatchFunc = function()
            local r,g,b = ColorPickerFrame:GetColorRGB()
            WhatShouldIDoDB.customColors[key] = {r,g,b}
            -- Update the swatch preview
            if swatch then swatch:SetBackdropColor(r,g,b,1) end
        end
        info.cancelFunc = function(prev)
            WhatShouldIDoDB.customColors[key] = {prev.r,prev.g,prev.b}
            if swatch then swatch:SetBackdropColor(prev.r,prev.g,prev.b,1) end
        end
        ColorPickerFrame:SetupColorPickerAndShow(info)
    end

    local prevCustom = customHdr
    for _, ck in ipairs(CUSTOM_KEYS) do
        local row = CreateFrame("Frame", nil, colScrollContent)
        row:SetSize(SET_CW - 4, 26)
        row:SetPoint("TOPLEFT", prevCustom, "BOTTOMLEFT", 0, -6)

        local swatch = CreateFrame("Button", nil, row, "BackdropTemplate")
        swatch:SetSize(22, 22)
        swatch:SetPoint("TOPLEFT", row, "TOPLEFT", 0, -2)
        swatch:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8x8",edgeFile="Interface\\Buttons\\WHITE8x8",edgeSize=1})
        local cv = C[ck.key]
        swatch:SetBackdropColor(cv[1],cv[2],cv[3],1)
        swatch:SetBackdropBorderColor(0.4,0.4,0.4,1)
        table.insert(swatchRefs, {swatch=swatch, key=ck.key})

        local rlbl = row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        rlbl:SetPoint("LEFT", swatch, "RIGHT", 8, 0)
        rlbl:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
        rlbl:SetText(ck.label)

        local editBtn = MakeBtn(row, "Edit", 50, 22)
        editBtn:SetPoint("LEFT", rlbl, "RIGHT", 10, 0)
        local k = ck.key
        editBtn:SetScript("OnClick", function() OpenColorPicker(k, swatch) end)

        prevCustom = row
    end

    -- Apply Custom button with confirmation
    local applyCustomBtn = MakeBtn(colScrollContent, "Apply Custom Theme", 220, 30)
    applyCustomBtn:SetPoint("TOPLEFT", prevCustom, "BOTTOMLEFT", 0, -12)
    applyCustomBtn:SetScript("OnClick", function()
        StaticPopupDialogs["WSID_CONFIRM_CUSTOM"] = {
            text = "Apply your custom color theme?\n\nThe UI will reload to apply the new colors.",
            button1 = "Yes, Apply",
            button2 = "Cancel",
            OnAccept = function()
                WhatShouldIDoDB.colorTheme = "Custom"
                -- Write custom colors into C so they survive the reload via DB
                if WhatShouldIDoDB.customColors then
                    ApplyTheme("Custom", WhatShouldIDoDB.customColors)
                end
                ReloadUI()
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
        }
        StaticPopup_Show("WSID_CONFIRM_CUSTOM")
    end)

    -- Set scroll content height
    colScrollContent:SetHeight(680)

    f:SetScript("OnShow",function() SetNavActive("activities") end)
    SetNavActive("activities")
    return f
end

------------------------------------------------------------------------
-- MAIN WINDOW
------------------------------------------------------------------------

local mainFrame
local mainPanels={}

local function BuildMainFrame()
    local f=CreateFrame("Frame","WhatShouldIDoFrame",UIParent,"BackdropTemplate")
    f:SetSize(WIN_W,WIN_H) ; f:SetPoint("CENTER")
    f:SetMovable(true) ; f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart",f.StartMoving) ; f:SetScript("OnDragStop",f.StopMovingOrSizing)
    f:SetFrameStrata("DIALOG")
    f:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8x8",edgeFile="Interface\\Buttons\\WHITE8x8",edgeSize=1})
    f:SetBackdropColor(C.bg[1],C.bg[2],C.bg[3],1)
    f:SetBackdropBorderColor(C.win_border[1],C.win_border[2],C.win_border[3],1)

    -- Title bar
    local tb=CreateFrame("Frame",nil,f) ; tb:SetHeight(30)
    tb:SetPoint("TOPLEFT",f,"TOPLEFT",0,0) ; tb:SetPoint("TOPRIGHT",f,"TOPRIGHT",0,0)
    Tx(tb,C.sidebar[1],C.sidebar[2],C.sidebar[3])
    local tbb=tb:CreateTexture(nil,"ARTWORK")
    tbb:SetColorTexture(C.divider[1],C.divider[2],C.divider[3],1) ; tbb:SetHeight(1)
    tbb:SetPoint("BOTTOMLEFT",tb,"BOTTOMLEFT",0,0) ; tbb:SetPoint("BOTTOMRIGHT",tb,"BOTTOMRIGHT",0,0)
    local titleLbl=tb:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
    titleLbl:SetPoint("CENTER",tb,"CENTER",0,0)
    titleLbl:SetText("What Should I Do?") ; titleLbl:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
    local closeBtn=CreateFrame("Button",nil,f,"UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT",f,"TOPRIGHT",-2,-2)
    closeBtn:SetScript("OnClick",function()
        f:Hide() ; if settingsFrame then settingsFrame:Hide() end
    end)

    -- Content area
    local contentArea=CreateFrame("Frame",nil,f)
    contentArea:SetPoint("TOPLEFT",f,"TOPLEFT",NAV_W,-30)
    contentArea:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",0,0)
    Tx(contentArea,C.bg[1]+0.005,C.bg[2]+0.005,C.bg[3]+0.01)

    local actPanel  = BuildActivityPanel(contentArea)
    local crePanel  = BuildCreatorPanel(contentArea)
    local levPanel  = BuildLevelingPanel(contentArea)
    local namPanel  = BuildNamePanel(contentArea)
    local profPanel = BuildProfessionPanel(contentArea)
    local rdPanel   = BuildRaidDungeonPanel(contentArea)
    local abtPanel  = BuildAboutPanel(contentArea)
    mainPanels={activity=actPanel,creator=crePanel,leveling=levPanel,names=namPanel,professions=profPanel,raidsdungeons=rdPanel,about=abtPanel}

    BuildLeftNav(f,
        {{name="activity",label="Activity"},{name="creator",label="Creator"},{name="leveling",label="Leveling"},{name="names",label="Name Generator"},{name="professions",label="Professions"},{name="raidsdungeons",label="Raids & Dungeons"}},
        {{name="settings_nav",label="Settings"},{name="about",label="About"}},
        function(name)
            if name=="settings_nav" then
                if settingsFrame then
                    if settingsFrame:IsShown() then settingsFrame:Hide() else settingsFrame:Show() end
                end
                return
            end
            -- Always refresh roster when switching to leveling so imports show immediately
            if name=="leveling" then BuildRoster() end
            for k,p in pairs(mainPanels) do if k==name then p:Show() else p:Hide() end end
        end
    )

    f:Hide() ; return f
end

------------------------------------------------------------------------
-- MINIMAP BUTTON
------------------------------------------------------------------------

local function RegisterMinimapButton()
    local LDB=LibStub("LibDataBroker-1.1") ; local LibDBIcon=LibStub("LibDBIcon-1.0")
    local broker=LDB:NewDataObject("WhatShouldIDo",{
        type="launcher", icon="Interface\\Icons\\INV_Misc_QuestionMark", label="What Should I Do?",
        OnClick=function(_,btn)
            if btn=="LeftButton" then
                if mainFrame:IsShown() then mainFrame:Hide() ; if settingsFrame then settingsFrame:Hide() end
                else BuildRoster() ; mainFrame:Show() end
            elseif btn=="RightButton" then
                if settingsFrame:IsShown() then settingsFrame:Hide() else settingsFrame:Show() end
            end
        end,
        OnTooltipShow=function(tt)
            tt:SetText("What Should I Do?",1,0.85,0.20)
            tt:AddLine("Left-click: open / close",0.8,0.8,0.8)
            tt:AddLine("Right-click: settings",   0.8,0.8,0.8)
        end,
    })
    LibDBIcon:Register("WhatShouldIDo",broker,WhatShouldIDoDB.minimap)
end

------------------------------------------------------------------------
-- INIT
------------------------------------------------------------------------

local initFrame=CreateFrame("Frame")
initFrame:RegisterEvent("ADDON_LOADED") ; initFrame:RegisterEvent("PLAYER_LOGIN")
initFrame:SetScript("OnEvent",function(self,event,arg1)
    if event=="ADDON_LOADED" and arg1==ADDON_NAME then
        InitDB()
        -- Apply saved theme (must run after InitDB sets defaults and after ApplyTheme is defined)
        if WhatShouldIDoDB.colorTheme == "Custom" and next(WhatShouldIDoDB.customColors) then
            ApplyTheme("Custom", WhatShouldIDoDB.customColors)
        else
            ApplyTheme(WhatShouldIDoDB.colorTheme or "Default")
        end
        mainFrame     = BuildMainFrame()
        settingsFrame = BuildSettingsWindow()
        RegisterMinimapButton()
    elseif event=="PLAYER_LOGIN" then
        if WhatShouldIDoDB then BuildRoster() end
    end
end)

SLASH_SPINWHEELS1="/sw" ; SLASH_SPINWHEELS2="/spinwheels" ; SLASH_SPINWHEELS3="/wsid"
SlashCmdList["SPINWHEELS"]=function(msg)
    msg=strtrim(msg)
    local msgL=msg:lower()
    if msgL=="roster" then
        BuildRoster()
        print("|cffd5a742What Should I Do?:|r Roster refreshed -- "..#roster.." character(s).")
        return
    end
    if msgL=="settings" then
        if settingsFrame then
            if settingsFrame:IsShown() then settingsFrame:Hide() else settingsFrame:Show() end
        end
        return
    end
    if mainFrame then
        if mainFrame:IsShown() then mainFrame:Hide() ; if settingsFrame then settingsFrame:Hide() end
        else BuildRoster() ; mainFrame:Show() end
    end
end
