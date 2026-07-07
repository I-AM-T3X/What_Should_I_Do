-- Panels/Professions.lua
-- Author: I_AM_T3X | v1.0.0

function BuildProfessionPanel(contentArea)
    local panel = MakePanel(contentArea)
    local hdr = MakeHeader(panel, "Profession Picker")
    hdr:SetPoint("TOPLEFT", panel, "TOPLEFT", WSID_PAD, -WSID_PAD)

    local desc = MakeDimLabel(panel, "Spin two professions for your character.", hdr, "BOTTOMLEFT", 4, -8)

    local prof1Box, prof1Label = MakeResult(panel, nil, 52, "PROFESSION 1")
    prof1Box:SetPoint("TOP", desc, "BOTTOM", 0, -12)
    prof1Box:SetPoint("LEFT",    panel, "LEFT",  WSID_PAD, 0)
    prof1Box:SetPoint("RIGHT",   panel, "CENTER", -3, 0)
    prof1Label:SetText("--")

    local prof2Box, prof2Label = MakeResult(panel, nil, 52, "PROFESSION 2")
    prof2Box:SetPoint("TOP",  desc, "BOTTOM", 0, -12)
    prof2Box:SetPoint("LEFT",     panel, "CENTER", 3, 0)
    prof2Box:SetPoint("RIGHT",    panel, "RIGHT", -WSID_PAD, 0)
    prof2Label:SetText("--")

    local spinBtn = MakeBtn(panel, "Spin Professions", nil, 30)
    spinBtn:SetPoint("TOP", prof1Box, "BOTTOM", 0, -10)
    spinBtn:SetPoint("LEFT",    panel, "LEFT",  WSID_PAD, 0)
    spinBtn:SetPoint("RIGHT",   panel, "RIGHT", -WSID_PAD, 0)

    -- Exclude farming professions checkbox
    local FARMING = {Herbalism=true, Mining=true, Skinning=true}

    local farmBox = CreateFrame("Frame", nil, panel, "BackdropTemplate")
    farmBox:SetSize(14, 14)
    farmBox:SetPoint("TOPLEFT", spinBtn, "BOTTOMLEFT", 0, -14)
    farmBox:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8x8",edgeFile="Interface\\Buttons\\WHITE8x8",edgeSize=1})

    local farmCheck = farmBox:CreateTexture(nil,"OVERLAY")
    farmCheck:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
    farmCheck:SetSize(16,16) ; farmCheck:SetPoint("CENTER", farmBox, "CENTER", 0, 0)

    local farmLbl = panel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    farmLbl:SetPoint("LEFT", farmBox, "RIGHT", 6, 0)
    farmLbl:SetText("Exclude farming professions (Herbalism, Mining, Skinning)")

    local function SetFarmState(on)
        if not WhatShouldIDoDB then return end
        WhatShouldIDoDB.excludeFarming = on
        local ac1,ac2,ac3   = C.accent      and C.accent[1]      or 0.84, C.accent      and C.accent[2]      or 0.67, C.accent      and C.accent[3]      or 0.20
        local rb1,rb2,rb3   = C.result_bg   and C.result_bg[1]   or 0.06, C.result_bg   and C.result_bg[2]   or 0.04, C.result_bg   and C.result_bg[3]   or 0.10
        local di1,di2,di3   = C.divider     and C.divider[1]     or 0.25, C.divider     and C.divider[2]     or 0.20, C.divider     and C.divider[3]     or 0.35
        local br1,br2,br3   = C.bright_text and C.bright_text[1] or 1.00, C.bright_text and C.bright_text[2] or 0.90, C.bright_text and C.bright_text[3] or 0.40
        local dm1,dm2,dm3   = C.dim_text    and C.dim_text[1]    or 0.50, C.dim_text    and C.dim_text[2]    or 0.45, C.dim_text    and C.dim_text[3]    or 0.55
        if on then
            farmBox:SetBackdropColor(rb1,rb2,rb3,1)
            farmBox:SetBackdropBorderColor(ac1,ac2,ac3,1)
            farmCheck:SetVertexColor(ac1,ac2,ac3,1)
            farmCheck:Show()
            farmLbl:SetTextColor(br1,br2,br3)
        else
            farmBox:SetBackdropColor(0.05,0.03,0.08,1)
            farmBox:SetBackdropBorderColor(di1,di2,di3,1)
            farmCheck:Hide()
            farmLbl:SetTextColor(dm1,dm2,dm3)
        end
    end

    local farmBtn = CreateFrame("Button", nil, panel)
    farmBtn:SetHeight(20)
    farmBtn:SetPoint("TOPLEFT", spinBtn, "BOTTOMLEFT", 0, -10)
    farmBtn:SetPoint("RIGHT",   panel,   "RIGHT", -WSID_PAD, 0)
    farmBtn:SetScript("OnClick", function()
        SetFarmState(not (WhatShouldIDoDB and WhatShouldIDoDB.excludeFarming))
    end)

    -- Init state after frame shown (C table populated by then)
    panel:SetScript("OnShow", function()
        SetFarmState(WhatShouldIDoDB and WhatShouldIDoDB.excludeFarming or false)
        panel:SetScript("OnShow", nil)
    end)

    local spinning = false

    spinBtn:SetScript("OnClick", function()
        if spinning then return end
        local excludeFarming = WhatShouldIDoDB and WhatShouldIDoDB.excludeFarming
        local pool = {}
        for _, p in ipairs(WSID_PROFESSIONS) do
            if p ~= "Fishing" and p ~= "Cooking" then
                if not (excludeFarming and FARMING[p]) then
                    table.insert(pool, p)
                end
            end
        end
        if #pool < 2 then return end
        spinning = true ; spinBtn:SetEnabled(false)

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
            end)
        end)
    end)

    return panel
end

------------------------------------------------------------------------
-- RAIDS & DUNGEONS PANEL
------------------------------------------------------------------------

local WSID_RAIDS_BY_EXPANSION = {
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

local WSID_DUNGEONS_BY_EXPANSION = {
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

