-- Panels/Creator.lua
-- Author: I_AM_T3X | v1.0.0

function BuildCreatorPanel(contentArea)
    local panel = MakePanel(contentArea)
    local W = WSID_CONT_W

    local hdr = MakeHeader(panel, "Character Creator", W)
    hdr:SetPoint("TOPLEFT", panel, "TOPLEFT", WSID_PAD, -WSID_PAD)

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
        for _,r in ipairs(WSID_ALL_RACES) do
            if factionFilter=="Any" or r.faction==factionFilter or r.faction=="Neutral" then
                table.insert(names, r.race)
            end
        end
        return names
    end

    local function FindRace(name)
        for _,r in ipairs(WSID_ALL_RACES) do if r.race==name then return r end end
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
        local classes=WSID_CLASS_BY_RACE[pickedRace.race] ; if not classes then return end
        StopSlot() ; spinClassBtn:SetEnabled(false)
        classLabel:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
        StartSlot(classLabel, classes, function(w)
            local cc=WSID_CLASS_COLORS[w]
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
            local classes = pickedRace and WSID_CLASS_BY_RACE[pickedRace.race] or {}
            if #classes==0 then spinRaceBtn:SetEnabled(true) ; spinBothBtn:SetEnabled(true) ; return end
            classLabel:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
            StartSlot(classLabel, classes, function(cls)
                local cc=WSID_CLASS_COLORS[cls]
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
--   WSID_PAD(16)+hdr(28)+gap(10)+desc(14)+gap(12)+classBox(52)+gap(10)+spinBtn(30)
--   +gap(10)+charHdr(28)+charList(110)+gap(10)+expBox(52)+gap(10)
--   +btnRow(30)+gap(8)+note(14)+WSID_PAD(16) = 460px  fits cleanly


