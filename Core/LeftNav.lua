-- Core/LeftNav.lua
-- Left navigation bar builder
-- Author: I_AM_T3X | v1.0.0

function BuildLeftNav(parent, topDefs, bottomDefs, onSelect)
    local ROW_H = 38
    local navBg = CreateFrame("Frame", nil, parent)
    navBg:SetPoint("TOPLEFT",    parent,"TOPLEFT",    0,-30)
    navBg:SetPoint("BOTTOMLEFT", parent,"BOTTOMLEFT", 0,  0)
    navBg:SetWidth(WSID_NAV_W)
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
        row:SetSize(WSID_NAV_W, ROW_H)
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
        row:SetSize(WSID_NAV_W, ROW_H)
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
--   WSID_PAD(16) + hdr(28) + gap(10) + desc(14) + gap(12)
--   + catBox(52) + gap(10) + subBox(52) + gap(14)
--   + btnRow(30) + gap(6) + bothBtn(30) + WSID_PAD(16) = 290px  (lots of breathing room)


