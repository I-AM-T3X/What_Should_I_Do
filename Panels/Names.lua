-- Panels/Names.lua
-- Author: I_AM_T3X | v1.0.0

function BuildNamePanel(contentArea)
    local panel = MakePanel(contentArea)
    local hdr = MakeHeader(panel, "Name Generator")
    hdr:SetPoint("TOPLEFT", panel, "TOPLEFT", WSID_PAD, -WSID_PAD)

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
    for _, r in ipairs(WSID_ALL_RACES) do table.insert(allRaces, r.race) end
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
    local generateBtn = MakeBtn(panel, "Generate Names", nil, 30)
    generateBtn:SetPoint("TOP",   raceLabel, "BOTTOM",  0, -14)
    generateBtn:SetPoint("LEFT",  panel, "LEFT",   WSID_PAD, 0)
    generateBtn:SetPoint("RIGHT", panel, "RIGHT",  -WSID_PAD, 0)

    -- Name list scroll
    local nameHdr = MakeHeader(panel, "Generated Names  (click to copy to chat)")
    nameHdr:SetPoint("TOP",  generateBtn, "BOTTOM", 0, -10)
    nameHdr:SetPoint("LEFT", panel, "LEFT", WSID_PAD, 0)

    local nameBG, nameContent, nameReset = MakeScrollBox(panel, nil, 200)
    nameBG:SetPoint("TOPLEFT", nameHdr, "BOTTOMLEFT", 0, 0)

    local nameRows = {}

    local function RenderNames(names)
        for _, r in ipairs(nameRows) do r:Hide() end
        nameRows = {}
        for i, name in ipairs(names) do
            local even = (i%2==0)
            local row = CreateFrame("Button", nil, nameContent)
            row:SetHeight(26)
            row:SetPoint("TOP",   nameContent, "TOP",   0, -(i-1)*26)
            row:SetPoint("LEFT",  nameContent, "LEFT",  0, 0)
            row:SetPoint("RIGHT", nameContent, "RIGHT", 0, 0)
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

local WSID_PROFESSIONS = {
    "Alchemy","Blacksmithing","Enchanting","Engineering","Herbalism",
    "Inscription","Jewelcrafting","Leatherworking","Mining","Skinning","Tailoring",
    "Fishing","Cooking",
}


