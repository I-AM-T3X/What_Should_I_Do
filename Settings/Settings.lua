-- Settings/Settings.lua
-- Settings window and all tabs
-- Author: I_AM_T3X | v1.0.0

settingsFrame = nil
WSID_refreshActivities = nil
WSID_refreshRoster = nil


settingsFrame = nil
WSID_WSID_refreshActivities = nil
WSID_WSID_refreshRoster = nil

function BuildSettingsWindow()
    local f = CreateFrame("Frame","WhatShouldIDoSettings",UIParent,"BackdropTemplate")
    f:SetSize(WSID_SET_W, WSID_SET_H)
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
    closeBtn:SetFrameStrata(f:GetFrameStrata())
    closeBtn:SetFrameLevel(f:GetFrameLevel() + 1)

    -- Left nav
    local navBg=CreateFrame("Frame",nil,f)
    navBg:SetPoint("TOPLEFT",f,"TOPLEFT",0,-30) ; navBg:SetPoint("BOTTOMLEFT",f,"BOTTOMLEFT",0,0)
    navBg:SetWidth(WSID_SET_NAV)
    Tx(navBg,C.sidebar[1],C.sidebar[2],C.sidebar[3])
    local nd=navBg:CreateTexture(nil,"ARTWORK")
    nd:SetColorTexture(C.divider[1],C.divider[2],C.divider[3],1) ; nd:SetWidth(1)
    nd:SetPoint("TOPRIGHT",navBg,"TOPRIGHT",0,0) ; nd:SetPoint("BOTTOMRIGHT",navBg,"BOTTOMRIGHT",0,0)

    local content=CreateFrame("Frame",nil,f)
    content:SetPoint("TOPLEFT",f,"TOPLEFT",WSID_SET_NAV,-30)
    content:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",0,0)

    local actPanel=CreateFrame("Frame",nil,content) ; actPanel:SetAllPoints(content) ; actPanel:Hide()
    local rostPanel=CreateFrame("Frame",nil,content) ; rostPanel:SetAllPoints(content) ; rostPanel:Hide()
    local ioPanel=CreateFrame("Frame",nil,content)   ; ioPanel:SetAllPoints(content)   ; ioPanel:Hide()
    local colorsPanel=CreateFrame("Frame",nil,content) ; colorsPanel:SetAllPoints(content) ; colorsPanel:Hide()
    local PANELS={activities=actPanel,WSID_Roster=rostPanel,importexport=ioPanel,colors=colorsPanel}
    local navBtns={} ; local navActive=nil

    local function SetNavActive(name)
        navActive=name
        for k,b in pairs(navBtns) do
            if k==name then b.bg:SetColorTexture(C.nav_active[1],C.nav_active[2],C.nav_active[3],1) ; b.stripe:Show() ; b.lbl:SetTextColor(1,1,1)
            else b.bg:SetColorTexture(0,0,0,0) ; b.stripe:Hide() ; b.lbl:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3]) end
        end
        for k,p in pairs(PANELS) do if k==name then p:Show() else p:Hide() end end
        if name=="activities" and WSID_refreshActivities then WSID_refreshActivities() end
        if name=="WSID_Roster"     and WSID_refreshRoster     then WSID_refreshRoster() end
    end

    for i,def in ipairs({{name="activities",label="Activities"},{name="WSID_Roster",label="Roster"},{name="importexport",label="Import/Export"},{name="colors",label="Colors"}}) do
        local row=CreateFrame("Button",nil,navBg) ; row:SetSize(WSID_SET_NAV,36)
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
    -- Column layout: WSID_PAD(12) | COL(277) | gap(12) | COL(277) | WSID_PAD(12) = 590 = WSID_SET_CW ok
    -- Row heights: hdr(28) + scroll(280) + gap(10) + addRow(26) + gap(8) + resetBtn(26) = 378 < (500-30-12) = 458 ok

    local SCRL_H = 280  -- scroll list height
    local BTN_H  = 26
    local GAP    = 10

    -- Left column: Categories
    local catHdr = MakeHeader(actPanel, "Categories", WSID_SET_COL)
    catHdr:SetPoint("TOPLEFT", actPanel, "TOPLEFT", WSID_SET_PAD, -WSID_SET_PAD)

    local catCount=actPanel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    catCount:SetPoint("RIGHT",catHdr,"RIGHT",-6,0) ; catCount:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])

    local catBG,catContent,catReset=MakeScrollBox(actPanel,WSID_SET_COL,SCRL_H)
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

    local catResetBtn=MakeBtn(actPanel,"Reset All Defaults",WSID_SET_COL,BTN_H)
    catResetBtn:SetPoint("TOPLEFT",catBG,"BOTTOMLEFT",0,-(GAP+BTN_H+28))

    -- Right column: Sub-Activities
    local subHdr=MakeHeader(actPanel,"Sub-Activities",WSID_SET_COL)
    subHdr:SetPoint("TOPLEFT",catHdr,"TOPRIGHT",12,0)

    local subCount=actPanel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    subCount:SetPoint("RIGHT",subHdr,"RIGHT",-6,0) ; subCount:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])

    local subSelLbl=actPanel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    subSelLbl:SetPoint("TOPLEFT",subHdr,"BOTTOMLEFT",4,-4)
    subSelLbl:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
    subSelLbl:SetText("(click a category to edit its sub-activities)")
    subSelLbl:SetWidth(WSID_SET_COL)

    -- Sub scroll must align vertically with cat scroll despite the extra label line
    -- Anchor subBG to subHdr bottom + fixed 28px (label height) to keep tops aligned
    local subBG,subContent,subReset=MakeScrollBox(actPanel,WSID_SET_COL,SCRL_H)
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
            if WSID_SMART_OPTIONS[selectedCat] then
                for _,v in ipairs(WSID_SMART_OPTIONS[selectedCat]) do table.insert(subs,v) end
            end
            WhatShouldIDoDB.subActivities[selectedCat]=subs
        end
        subCount:SetText("["..#subs.."]") ; subAddBtn:SetEnabled(true)
        for i,sub in ipairs(subs) do
            local even=(i%2==0)
            local row=CreateFrame("Frame",nil,subContent)
            row:SetSize(WSID_SET_COL-2,22) ; row:SetPoint("TOPLEFT",subContent,"TOPLEFT",0,-(i-1)*22)
            local rb=row:CreateTexture(nil,"BACKGROUND") ; rb:SetAllPoints()
            rb:SetColorTexture(even and C.row_even[1] or C.row_odd[1],even and C.row_even[2] or C.row_odd[2],even and C.row_even[3] or C.row_odd[3],1)
            local fs=row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            fs:SetPoint("LEFT",row,"LEFT",6,0) ; fs:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
            fs:SetJustifyH("LEFT") ; fs:SetText(sub) ; fs:SetWidth(WSID_SET_COL-28)
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

    WSID_refreshActivities=function()
        for _,r in ipairs(catRows) do r:Hide() end ; catRows={} ; catRowBgs={}
        selectedCat=nil
        subSelLbl:SetText("(click a category to edit its sub-activities)")
        subSelLbl:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
        for _,r in ipairs(subRows) do r:Hide() end ; subRows={} ; subCount:SetText("") ; subAddBtn:SetEnabled(false)
        local acts=WhatShouldIDoDB.activities ; catCount:SetText("["..#acts.."]")
        for i,act in ipairs(acts) do
            local even=(i%2==0)
            local row=CreateFrame("Button",nil,catContent)
            row:SetSize(WSID_SET_COL-2,22) ; row:SetPoint("TOPLEFT",catContent,"TOPLEFT",0,-(i-1)*22)
            local rb=row:CreateTexture(nil,"BACKGROUND") ; rb:SetAllPoints()
            rb:SetColorTexture(even and C.row_even[1] or C.row_odd[1],even and C.row_even[2] or C.row_odd[2],even and C.row_even[3] or C.row_odd[3],1)
            table.insert(catRowBgs,rb)
            local nl=row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            nl:SetPoint("LEFT",row,"LEFT",6,0) ; nl:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
            nl:SetJustifyH("LEFT") ; nl:SetText(act) ; nl:SetWidth(WSID_SET_COL-28)
            local xBtn=CreateFrame("Button",nil,row) ; xBtn:SetSize(20,22) ; xBtn:SetPoint("RIGHT",row,"RIGHT",0,0)
            local xL=xBtn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall") ; xL:SetAllPoints() ; xL:SetJustifyH("CENTER") ; xL:SetText("|cffcc3333x|r")
            local idx=i
            xBtn:SetScript("OnClick",function()
                if selectedCat==WhatShouldIDoDB.activities[idx] then
                    selectedCat=nil ; subSelLbl:SetText("(click a category to edit its sub-activities)")
                    subSelLbl:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
                    for _,r in ipairs(subRows) do r:Hide() end ; subRows={} ; subCount:SetText("") ; subAddBtn:SetEnabled(false)
                end
                table.remove(WhatShouldIDoDB.activities,idx) ; WSID_refreshActivities()
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
        table.insert(WhatShouldIDoDB.activities,txt) ; catAddBox:SetText("") ; WSID_refreshActivities()
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
        WhatShouldIDoDB.activities={} ; for _,v in ipairs(WSID_DEFAULT_ACTIVITIES) do table.insert(WhatShouldIDoDB.activities,v) end
        WhatShouldIDoDB.subActivities={} ; WSID_refreshActivities()
    end)

    --------------------------------------------------------------------
    -- ROSTER PANEL
    --------------------------------------------------------------------

    local rostHdr=MakeHeader(rostPanel,"Seen Characters",WSID_SET_CW)
    rostHdr:SetPoint("TOPLEFT",rostPanel,"TOPLEFT",WSID_SET_PAD,-WSID_SET_PAD)
    local rostCount=rostPanel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    rostCount:SetPoint("RIGHT",rostHdr,"RIGHT",-6,0) ; rostCount:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
    local rostNote=rostPanel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    rostNote:SetPoint("TOPLEFT",rostHdr,"BOTTOMLEFT",4,-6)
    rostNote:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
    rostNote:SetText("Log into each alt to add it. Levels update on every login.")
    rostNote:SetWidth(WSID_SET_CW)

    local rostBG,rostContent,rostReset=MakeScrollBox(rostPanel,WSID_SET_CW,WSID_SET_H-30-WSID_SET_PAD*2-80)
    rostBG:SetPoint("TOPLEFT",rostNote,"BOTTOMLEFT",0,-8)

    local rostRows={}
    WSID_refreshRoster=function()
        for _,r in ipairs(rostRows) do r:Hide() end ; rostRows={}
        local chars=WhatShouldIDoDB.seenChars ; rostCount:SetText("["..#chars.."]")
        if not WhatShouldIDoDB.excludedChars then WhatShouldIDoDB.excludedChars = {} end
        for i,ch in ipairs(chars) do
            local even=(i%2==0)
            local row=CreateFrame("Frame",nil,rostContent)
            row:SetSize(WSID_SET_CW-2,24) ; row:SetPoint("TOPLEFT",rostContent,"TOPLEFT",0,-(i-1)*24)
            local rb=row:CreateTexture(nil,"BACKGROUND") ; rb:SetAllPoints()
            rb:SetColorTexture(even and C.row_even[1] or C.row_odd[1],even and C.row_even[2] or C.row_odd[2],even and C.row_even[3] or C.row_odd[3],1)
            local cc=WSID_CLASS_COLORS[ch.class] or {r=0.8,g=0.8,b=0.8}
            local isExcluded = WhatShouldIDoDB.excludedChars[ch.name] == true
            local fs=row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            fs:SetPoint("LEFT",row,"LEFT",10,0) ; fs:SetJustifyH("LEFT")
            fs:SetText(string.format("|cff%02x%02x%02x%s|r  |cffaaaaaa%s %s|r  |cffffcc00Lv %d|r%s",
                isExcluded and 80 or cc.r*255,
                isExcluded and 80 or cc.g*255,
                isExcluded and 80 or cc.b*255,
                ch.name, ch.race or "", ch.class or "", ch.level or 0,
                isExcluded and "  |cff888888[excluded]|r" or ""))
            local isCurrent=(ch.name==UnitName("player"))
            -- Exclude toggle button (all chars including current)
            local exBtn=CreateFrame("Button",nil,row,"BackdropTemplate")
            exBtn:SetSize(58,18) ; exBtn:SetPoint("RIGHT",row,"RIGHT", isCurrent and -4 or -26, 0)
            exBtn:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8x8",edgeFile="Interface\\Buttons\\WHITE8x8",edgeSize=1})
            local function UpdateExBtn()
                local ex = WhatShouldIDoDB.excludedChars[ch.name] == true
                exBtn:SetBackdropColor(ex and 0.25 or 0.08, ex and 0.08 or 0.18, ex and 0.08 or 0.08)
                exBtn:SetBackdropBorderColor(ex and 0.6 or 0.3, ex and 0.2 or 0.3, ex and 0.2 or 0.3, 1)
                local exL = exBtn._lbl
                if exL then exL:SetText(ex and "|cffff6666Excluded|r" or "|cff888888Exclude|r") end
            end
            local exL=exBtn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            exL:SetAllPoints() ; exL:SetJustifyH("CENTER")
            exBtn._lbl = exL
            UpdateExBtn()
            local cn=ch.name
            exBtn:SetScript("OnClick",function()
                if WhatShouldIDoDB.excludedChars[cn] then
                    WhatShouldIDoDB.excludedChars[cn] = nil
                else
                    WhatShouldIDoDB.excludedChars[cn] = true
                end
                WSID_refreshRoster()
            end)
            if isCurrent then
                local yl=row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
                yl:SetPoint("RIGHT",exBtn,"LEFT",-4,0) ; yl:SetTextColor(0.30,0.75,0.30) ; yl:SetText("(you)")
            else
                local xBtn=CreateFrame("Button",nil,row) ; xBtn:SetSize(20,24) ; xBtn:SetPoint("RIGHT",row,"RIGHT",0,0)
                local xL2=xBtn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall") ; xL2:SetAllPoints() ; xL2:SetJustifyH("CENTER") ; xL2:SetText("|cffcc3333x|r")
                xBtn:SetScript("OnClick",function() RemoveCharFromRoster(cn) ; WSID_refreshRoster() end)
                xBtn:SetScript("OnEnter",function() xL2:SetText("|cffff5555x|r") end)
                xBtn:SetScript("OnLeave",function() xL2:SetText("|cffcc3333x|r") end)
            end
            table.insert(rostRows,row)
        end
        rostContent:SetHeight(math.max(24,#chars*24+2)) ; rostReset()
    end

    local clearBtn=MakeBtn(rostPanel,"Clear All Others",WSID_SET_CW,BTN_H)
    clearBtn:SetPoint("TOPLEFT",rostBG,"BOTTOMLEFT",0,-10)
    clearBtn:SetScript("OnClick",function()
        local cur=UnitName("player") ; local kept={}
        for _,ch in ipairs(WhatShouldIDoDB.seenChars) do if ch.name==cur then table.insert(kept,ch) end end
        WhatShouldIDoDB.seenChars=kept ; BuildRoster() ; WSID_refreshRoster()
        print("|cffd5a742What Should I Do?:|r Roster cleared.")
    end)

    --------------------------------------------------------------------
    -- IMPORT / EXPORT PANEL
    --------------------------------------------------------------------

    -- Encode tables (no collisions between CLASS/RACE/FACT within same field)
    local CLASS_ENC = {
        ["Warrior"]="Wa",["Paladin"]="Pa",["Hunter"]="Hu",["Rogue"]="Ro",
        ["Priest"]="Pr",["Shaman"]="Sh",["Mage"]="Ma",["Warlock"]="Wk",
        ["Monk"]="Mo",["Druid"]="Dr",["Demon Hunter"]="DH",["Death Knight"]="DK",
        ["Evoker"]="Ev",
    }
    local CLASS_DEC = {}
    for k,v in pairs(CLASS_ENC) do CLASS_DEC[v]=k end

    local RACE_ENC = {
        ["Human"]="Hm",["Dwarf"]="Dw",["Night Elf"]="NE",["Gnome"]="Gn",
        ["Draenei"]="Dn",["Worgen"]="Wg",["Orc"]="Or",["Undead"]="Un",
        ["Tauren"]="Tn",["Troll"]="Tl",["Blood Elf"]="BE",["Goblin"]="Gb",
        ["Pandaren"]="Pd",["Dracthyr"]="Dc",["Void Elf"]="VE",
        ["Lightforged Draenei"]="LD",["Dark Iron Dwarf"]="DI",["Kul Tiran"]="KT",
        ["Mechagnome"]="Mc",["Nightborne"]="Nb",["Highmountain Tauren"]="HT",
        ["Mag'har Orc"]="MO",["Zandalari Troll"]="ZT",["Vulpera"]="Vp",
        ["Earthen"]="Ea",["Haranir"]="Hr",
    }
    local RACE_DEC = {}
    for k,v in pairs(RACE_ENC) do RACE_DEC[v]=k end

    local FACT_ENC = {["Alliance"]="Al",["Horde"]="Ho",["Neutral"]="Ne"}
    local FACT_DEC = {Al="Alliance",Ho="Horde",Ne="Neutral"}

    local function BuildExportStr()
        local chars = WhatShouldIDoDB and WhatShouldIDoDB.seenChars
        if not chars or #chars == 0 then return nil end
        local excl = WhatShouldIDoDB.excludedChars or {}
        local parts = {}
        for _, ch in ipairs(chars) do
            local cls  = CLASS_ENC[ch.class]  or (ch.class   or "?")
            local race = RACE_ENC[ch.race]    or (ch.race    or "?")
            local fact = FACT_ENC[ch.faction] or (ch.faction or "?")
            table.insert(parts, (ch.name or "?")..":"..cls..":"..tostring(ch.level or 0)..":"..race..":"..fact..":".. (excl[ch.name] and "1" or "0"))
        end
        return "W2:" .. table.concat(parts, "|")
    end

    -- EXPORT section
    local expHdr = MakeHeader(ioPanel, "Export Roster", WSID_SET_CW)
    expHdr:SetPoint("TOPLEFT", ioPanel, "TOPLEFT", WSID_SET_PAD, -WSID_SET_PAD)

    local expBoxBg = CreateFrame("Frame", nil, ioPanel, "BackdropTemplate")
    expBoxBg:SetSize(WSID_SET_CW, 54)
    expBoxBg:SetPoint("TOPLEFT", expHdr, "BOTTOMLEFT", 0, -6)
    expBoxBg:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8x8",edgeFile="Interface\\Buttons\\WHITE8x8",edgeSize=1})
    expBoxBg:SetBackdropColor(0.06,0.04,0.10,1)
    expBoxBg:SetBackdropBorderColor(0.25,0.20,0.35,1)

    -- XOR encode/decode for opaque export strings
    local XOR_KEY = 42
    local B64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local function EncodeStr(str)
        -- XOR each byte then base64-encode
        local xored = {}
        for i = 1, #str do
            xored[i] = string.char(bit.bxor(str:byte(i), XOR_KEY))
        end
        local raw = table.concat(xored)
        -- simple base64
        local out = {}
        for i = 1, #raw, 3 do
            local a, b, c = raw:byte(i), raw:byte(i+1) or 0, raw:byte(i+2) or 0
            local n = a*65536 + b*256 + c
            out[#out+1] = B64:sub(math.floor(n/262144)%64+1,math.floor(n/262144)%64+1)
            out[#out+1] = B64:sub(math.floor(n/4096)%64+1,math.floor(n/4096)%64+1)
            out[#out+1] = (raw:byte(i+1) and B64:sub(math.floor(n/64)%64+1,math.floor(n/64)%64+1) or "=")
            out[#out+1] = (raw:byte(i+2) and B64:sub(n%64+1,n%64+1) or "=")
        end
        return "WX!" .. table.concat(out)
    end
    local function DecodeStr(enc)
        if enc:sub(1,3) ~= "WX!" then return nil end
        local b64 = enc:sub(4)
        local map = {}
        for i = 1, #B64 do map[B64:sub(i,i)] = i-1 end
        local raw = {}
        for i = 1, #b64, 4 do
            local a = map[b64:sub(i,i)] or 0
            local b = map[b64:sub(i+1,i+1)] or 0
            local c = map[b64:sub(i+2,i+2)]
            local d = map[b64:sub(i+3,i+3)]
            local n = a*262144 + b*4096 + (c or 0)*64 + (d or 0)
            raw[#raw+1] = string.char(math.floor(n/65536) % 256)
            if c then raw[#raw+1] = string.char(math.floor(n/256) % 256) end
            if d then raw[#raw+1] = string.char(n % 256) end
        end
        -- XOR decode
        local out = {}
        for _, ch in ipairs(raw) do
            out[#out+1] = string.char(bit.bxor(ch:byte(1), XOR_KEY))
        end
        return table.concat(out)
    end

    -- ScrollFrame inside expBoxBg so the multiline EditBox scrolls
    local expScroll = CreateFrame("ScrollFrame", nil, expBoxBg, "UIPanelScrollFrameTemplate")
    expScroll:SetPoint("TOPLEFT",     expBoxBg, "TOPLEFT",     4,  -4)
    expScroll:SetPoint("BOTTOMRIGHT", expBoxBg, "BOTTOMRIGHT", -24,  4)

    local expBox = CreateFrame("EditBox", "WhatShouldIDoExportBox", expScroll, "InputBoxTemplate")
    expBox:SetWidth(expScroll:GetWidth() or (WSID_SET_CW - 28))
    expBox:SetHeight(54)
    expBox:SetFontObject(GameFontNormalSmall)
    expBox:SetTextColor(0.85, 0.85, 0.85)
    expBox:SetMultiLine(true)
    expBox:SetAutoFocus(false)
    expBox:SetMaxLetters(0)
    expBox:SetText("-- click Export to generate --")
    expBox._last = ""
    expScroll:SetScrollChild(expBox)
    -- Hide InputBoxTemplate border textures
    if expBox.Left   then expBox.Left:SetAlpha(0) end
    if expBox.Middle then expBox.Middle:SetAlpha(0) end
    if expBox.Right  then expBox.Right:SetAlpha(0) end
    -- Sync scroll when text changes
    expBox:SetScript("OnTextChanged", function(self)
        expScroll:UpdateScrollChildRect()
    end)
    -- Block typing but allow select/copy
    expBox:SetScript("OnChar",          function(s) s:SetText(s._last or "") end)
    expBox:SetScript("OnEscapePressed", function(s) s:ClearFocus() end)
    expBox:SetScript("OnEnterPressed",  function(s) s:ClearFocus() end)
    expBox:SetScript("OnEditFocusGained", function(s) s:HighlightText() end)

    local expGenBtn = MakeBtn(ioPanel, "Export", WSID_SET_CW, 24)
    expGenBtn:SetPoint("TOPLEFT", expBoxBg, "BOTTOMLEFT", 0, -4)

    expGenBtn:SetScript("OnClick", function()
        local str = BuildExportStr()
        if not str then
            expBox._last = ""
            expBox:SetText("No characters in roster.")
            return
        end
        local encoded = EncodeStr(str)
        expBox._last = encoded
        expBox:SetText(encoded)
        expBox:SetFocus()
    end)

    local ioRule = ioPanel:CreateTexture(nil,"ARTWORK")
    ioRule:SetColorTexture(C.divider[1],C.divider[2],C.divider[3],1) ; ioRule:SetHeight(1)
    ioRule:SetPoint("TOPLEFT",  expGenBtn, "BOTTOMLEFT",  0, -10)
    ioRule:SetPoint("TOPRIGHT", expGenBtn, "BOTTOMRIGHT", 0, -10)

    -- IMPORT
    local impHdr = MakeHeader(ioPanel, "Import Roster", WSID_SET_CW)
    impHdr:SetPoint("TOPLEFT", ioRule, "BOTTOMLEFT", 0, -8)

    local impBoxBg = CreateFrame("Frame", nil, ioPanel, "BackdropTemplate")
    impBoxBg:SetSize(WSID_SET_CW, 26)
    impBoxBg:SetPoint("TOPLEFT", impHdr, "BOTTOMLEFT", 0, -6)
    impBoxBg:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8x8",edgeFile="Interface\\Buttons\\WHITE8x8",edgeSize=1})
    impBoxBg:SetBackdropColor(0.03,0.02,0.06,1)
    impBoxBg:SetBackdropBorderColor(C.divider[1],C.divider[2],C.divider[3],1)

    local impBox = CreateFrame("EditBox", "WhatShouldIDoImportBox", impBoxBg)
    impBox:SetPoint("TOPLEFT",     impBoxBg, "TOPLEFT",     6, -4)
    impBox:SetPoint("BOTTOMRIGHT", impBoxBg, "BOTTOMRIGHT", -6,  4)
    impBox:SetFontObject(ChatFontNormal)
    impBox:SetTextColor(1, 1, 1)
    impBox:SetAutoFocus(false)
    impBox:SetScript("OnEscapePressed", function(s) s:ClearFocus() end)
    impBox:SetScript("OnEditFocusGained", function()
        impBoxBg:SetBackdropBorderColor(C.result_bdr[1],C.result_bdr[2],C.result_bdr[3],1)
    end)
    impBox:SetScript("OnEditFocusLost", function()
        impBoxBg:SetBackdropBorderColor(C.divider[1],C.divider[2],C.divider[3],1)
    end)

    local impBtn = MakeBtn(ioPanel, "Import Roster", WSID_SET_CW, 24)
    impBtn:SetPoint("TOPLEFT", impBoxBg, "BOTTOMLEFT", 0, -4)

    local impStatus = ioPanel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    impStatus:SetPoint("TOPLEFT", impBtn, "BOTTOMLEFT", 4, -6)
    impStatus:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
    impStatus:SetText(" ") ; impStatus:SetWidth(WSID_SET_CW)

    WSID_DoImport = function(importStr)
        importStr = strtrim(importStr or "")
        if importStr == "" then
            impStatus:SetText("Paste an export string first.")
            impStatus:SetTextColor(0.8,0.3,0.3) ; return
        end
        -- Decode WX! encoded strings first
        if importStr:sub(1,3) == "WX!" then
            local decoded = DecodeStr(importStr)
            if not decoded then
                impStatus:SetText("Failed to decode string.")
                impStatus:SetTextColor(0.8,0.3,0.3) ; return
            end
            importStr = decoded
        end
        local str, compressed
        if importStr:sub(1,3) == "W2:" then
            str = importStr:sub(4) ; compressed = true
        elseif importStr:sub(1,5) == "WSID:" then
            str = importStr:sub(6) ; compressed = false
        else
            impStatus:SetText("Invalid string format.")
            impStatus:SetTextColor(0.8,0.3,0.3) ; return
        end
        local imported, updated, excluded = 0, 0, 0
        if not WhatShouldIDoDB.excludedChars then WhatShouldIDoDB.excludedChars = {} end
        for entry in str:gmatch("[^|]+") do
            local name,cls,level,race,faction,excl = entry:match("^([^:]+):([^:]+):([^:]+):([^:]+):([^:]+):?([01]?)$")
            if name and name ~= "" then
                if compressed then
                    cls     = CLASS_DEC[cls]    or NormaliseClass(cls)
                    race    = RACE_DEC[race]    or race
                    faction = FACT_DEC[faction] or faction
                else
                    cls = NormaliseClass(cls)
                end
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
                        name=name, class=cls, level=tonumber(level) or 0, race=race, faction=faction,
                    })
                    imported = imported + 1
                end
                if excl == "1" then
                    WhatShouldIDoDB.excludedChars[name] = true ; excluded = excluded + 1
                end
            end
        end
        BuildRoster()
        if WSID_refreshRoster then WSID_refreshRoster() end
        impBox:SetText("")
        impStatus:SetTextColor(0.3,0.8,0.3)
        impStatus:SetText(string.format("Done! %d added, %d levels updated, %d excluded.", imported, updated, excluded))
    end

    impBtn:SetScript("OnClick", function()
        WSID_DoImport(impBox:GetText())
    end)
    impBox:SetScript("OnEnterPressed", function(s)
        WSID_DoImport(s:GetText())
        s:ClearFocus()
    end)

    --------------------------------------------------------------------
    -- COLORS PANEL
    --------------------------------------------------------------------

    local colScrollBG, colScrollContent, _ = MakeScrollBox(colorsPanel, WSID_SET_CW, WSID_SET_H - 30 - WSID_SET_PAD * 2)
    colScrollBG:SetPoint("TOPLEFT", colorsPanel, "TOPLEFT", WSID_SET_PAD, -WSID_SET_PAD)

    local colHdr = MakeHeader(colScrollContent, "Color Theme", WSID_SET_CW - 4)
    colHdr:SetPoint("TOPLEFT", colScrollContent, "TOPLEFT", 0, -4)

    local colDesc = colScrollContent:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    colDesc:SetPoint("TOPLEFT", colHdr, "BOTTOMLEFT", 4, -6)
    colDesc:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
    colDesc:SetText("Select a theme. A UI reload is required to fully apply the new colors.")
    colDesc:SetWidth(WSID_SET_CW - 8)

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
        row:SetSize(WSID_SET_CW - 4, 28)
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
        row:SetSize(WSID_SET_CW - 4, 26)
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


