-- Panels/RaidsDungeons.lua
-- Author: I_AM_T3X | v1.0.0

function BuildRaidDungeonPanel(contentArea)
    local panel = MakePanel(contentArea)
    local hdr = MakeHeader(panel, "Raids & Dungeons")
    hdr:SetPoint("TOPLEFT", panel, "TOPLEFT", WSID_PAD, -WSID_PAD)

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
    local expBox, expLabel = MakeResult(panel, nil, 52, "EXPANSION")
    expBox:SetPoint("TOPLEFT", modeLbl, "BOTTOMLEFT", 0, -12)
    expLabel:SetText("Expansion")

    -- Instance result
    local instBox, instLabel = MakeResult(panel, nil, 52, "RAID / DUNGEON")
    instBox:SetPoint("TOPLEFT", expBox, "BOTTOMLEFT", 0, -8)
    instLabel:SetText("--")

    -- Spin buttons
    local spinExpBtn = MakeBtn(panel, "Spin Expansion", nil, 30)
    spinExpBtn:SetPoint("TOP", instBox, "BOTTOM", 0, -10)
    spinExpBtn:SetPoint("LEFT",    panel, "LEFT",  WSID_PAD, 0)
    spinExpBtn:SetPoint("RIGHT",   panel, "CENTER", -3, 0)

    local spinInstBtn = MakeBtn(panel, "Spin Instance", nil, 30)
    spinInstBtn:SetPoint("TOP", instBox, "BOTTOM", 0, -10)
    spinInstBtn:SetPoint("LEFT",    panel, "CENTER", 3, 0)
    spinInstBtn:SetPoint("RIGHT",   panel, "RIGHT", -WSID_PAD, 0)
    spinInstBtn:SetEnabled(false)

    local spinBothBtn = MakeBtn(panel, "Spin Both", nil, 30)
    spinBothBtn:SetPoint("TOP", spinExpBtn, "BOTTOM", 0, -6)
    spinBothBtn:SetPoint("LEFT",    panel, "LEFT",  WSID_PAD, 0)
    spinBothBtn:SetPoint("RIGHT",   panel, "RIGHT", -WSID_PAD, 0)

    local pickedExp = nil

    local function GetExpansionList()
        local pool = {}
        local src = mode == "Raids" and WSID_RAIDS_BY_EXPANSION or WSID_DUNGEONS_BY_EXPANSION
        local excluded = WhatShouldIDoDB and WhatShouldIDoDB.excludedExpansions or {}
        for exp, instances in pairs(src) do
            if #instances > 0 and not excluded[exp] then table.insert(pool, exp) end
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
        local src = mode == "Raids" and WSID_RAIDS_BY_EXPANSION or WSID_DUNGEONS_BY_EXPANSION
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

