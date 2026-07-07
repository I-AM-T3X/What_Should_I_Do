-- Panels/Activity.lua
-- Author: I_AM_T3X | v1.0.0

function BuildActivityPanel(contentArea)
    local panel = MakePanel(contentArea)
    local hdr = MakeHeader(panel, "Activity Wheel")
    hdr:SetPoint("TOPLEFT", panel, "TOPLEFT", WSID_PAD, -WSID_PAD)

    local desc = MakeDimLabel(panel, "Spin a category, then spin a sub-activity.", hdr, "BOTTOMLEFT", 4, -8)

    local catBox, catLabel = MakeResult(panel, nil, 52, "CATEGORY")
    catBox:SetPoint("TOPLEFT", desc, "BOTTOMLEFT", -4, -12)
    catLabel:SetText("Category")

    local subBox, subLabel = MakeResult(panel, nil, 52, "SUB-ACTIVITY")
    subBox:SetPoint("TOPLEFT", catBox, "BOTTOMLEFT", 0, -10)
    subLabel:SetText("Sub-Activity")

    local spinCatBtn = MakeBtn(panel, "Spin Category", nil, 30)
    spinCatBtn:SetPoint("TOP",  subBox, "BOTTOMLEFT",  0, -14)
    spinCatBtn:SetPoint("LEFT",     panel, "LEFT",  WSID_PAD, 0)
    spinCatBtn:SetPoint("RIGHT",    panel, "CENTER",       -3, 0)

    local spinSubBtn = MakeBtn(panel, "Spin Sub-Activity", nil, 30)
    spinSubBtn:SetPoint("TOP",  subBox, "BOTTOMLEFT",  0, -14)
    spinSubBtn:SetPoint("LEFT",     panel, "CENTER",        3, 0)
    spinSubBtn:SetPoint("RIGHT",    panel, "RIGHT",       -WSID_PAD, 0)
    spinSubBtn:SetEnabled(false)

    local spinBothBtn = MakeBtn(panel, "Spin Both", nil, 30)
    spinBothBtn:SetPoint("TOP",  spinCatBtn, "BOTTOM", 0, -6)
    spinBothBtn:SetPoint("LEFT",     panel, "LEFT",  WSID_PAD, 0)
    spinBothBtn:SetPoint("RIGHT",    panel, "RIGHT", -WSID_PAD, 0)

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

