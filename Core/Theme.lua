-- Core/Theme.lua
-- Theme system, color table, ApplyTheme, and all UI primitive helpers
-- Author: I_AM_T3X | v1.0.0

------------------------------------------------------------------------
-- THEME DEFINITIONS
------------------------------------------------------------------------

WSID_THEMES = {
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

-- C is the live color table, starts as Default
C = {}
for k, v in pairs(WSID_THEMES.Default) do C[k] = {v[1], v[2], v[3]} end

function ApplyTheme(themeName, customColors)
    local src = WSID_THEMES[themeName]
    if not src and themeName == "Custom" then
        src = customColors or WSID_THEMES.Default
    end
    if not src then src = WSID_THEMES.Default end
    for k, v in pairs(src) do
        C[k][1] = v[1] ; C[k][2] = v[2] ; C[k][3] = v[3]
    end
end

------------------------------------------------------------------------
-- RENDERING HELPERS
------------------------------------------------------------------------

local FLAT = {bgFile="Interface\\Buttons\\WHITE8x8", edgeFile="Interface\\Buttons\\WHITE8x8", edgeSize=1}

function Tx(f, r, g, b, a)
    local t = f:CreateTexture(nil, "BACKGROUND")
    t:SetAllPoints() ; t:SetColorTexture(r, g, b, a or 1) ; return t
end

function BgBorder(f, br, bg_, bb, er, eg, eb)
    f:SetBackdrop(FLAT)
    f:SetBackdropColor(br, bg_, bb, 1)
    f:SetBackdropBorderColor(er, eg, eb, 1)
end

------------------------------------------------------------------------
-- SCROLL BOX
------------------------------------------------------------------------

function MakeScrollBox(parent, w, h)
    local bg = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    bg:SetHeight(h)
    if w then bg:SetWidth(w) else
        bg:SetPoint("LEFT",  parent, "LEFT",  WSID_PAD, 0)
        bg:SetPoint("RIGHT", parent, "RIGHT", -WSID_PAD, 0)
    end
    BgBorder(bg, C.row_even[1],C.row_even[2],C.row_even[3],
                 C.divider[1], C.divider[2], C.divider[3])
    local clip = CreateFrame("Frame", nil, bg)
    clip:SetPoint("TOPLEFT",     bg, "TOPLEFT",     1, -1)
    clip:SetPoint("BOTTOMRIGHT", bg, "BOTTOMRIGHT", -1, 1)
    clip:SetClipsChildren(true)
    local content = CreateFrame("Frame", nil, clip)
    if w then
        content:SetWidth(w-2)
    else
        -- Stretch content to clip width dynamically
        content:SetPoint("LEFT",  clip, "LEFT",  0, 0)
        content:SetPoint("RIGHT", clip, "RIGHT", 0, 0)
    end
    content:SetHeight(h)
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

function MakeResult(parent, w, h, tagText)
    local f = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    f:SetHeight(h or 52)
    -- If w is a number use fixed size; if nil stretch to parent
    if w then f:SetWidth(w) else
        -- caller sets TOPLEFT; we add LEFT+RIGHT for stretch
        f:SetPoint("LEFT",  parent, "LEFT",  WSID_PAD, 0)
        f:SetPoint("RIGHT", parent, "RIGHT", -WSID_PAD, 0)
    end
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
    lbl:SetPoint("LEFT",  f, "LEFT",  10, 0)
    lbl:SetPoint("RIGHT", f, "RIGHT", -10, 0)
    lbl:SetJustifyH("CENTER") ; lbl:SetWordWrap(false)
    lbl:SetText("--") ; lbl:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
    return f, lbl
end

function MakeBtn(parent, text, w, h)
    local b = CreateFrame("Button", nil, parent, "BackdropTemplate")
    b:SetHeight(h or 30)
    if w then b:SetWidth(w) end
    -- RIGHT anchor set by caller when w is nil
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
    b:SetEnabled(true)
    return b
end

function MakeHeader(parent, text, w)
    local f = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    f:SetHeight(28)
    if w then f:SetWidth(w) else
        f:SetPoint("LEFT",  parent, "LEFT",  WSID_PAD, 0)
        f:SetPoint("RIGHT", parent, "RIGHT", -WSID_PAD, 0)
    end
    BgBorder(f, C.header_bg[1],C.header_bg[2],C.header_bg[3], C.divider[1],C.divider[2],C.divider[3])
    local stripe = f:CreateTexture(nil,"ARTWORK")
    stripe:SetColorTexture(C.nav_border[1],C.nav_border[2],C.nav_border[3],1)
    stripe:SetSize(3,28) ; stripe:SetPoint("LEFT",f,"LEFT",0,0)
    local lbl = f:CreateFontString(nil,"OVERLAY","GameFontNormal")
    lbl:SetPoint("LEFT",f,"LEFT",12,0)
    lbl:SetText(text) ; lbl:SetTextColor(C.header_txt[1],C.header_txt[2],C.header_txt[3])
    return f
end

function MakeDimLabel(parent, text, anchorFrame, anchorPoint, ox, oy)
    local fs = parent:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    fs:SetPoint("TOPLEFT", anchorFrame, anchorPoint or "BOTTOMLEFT", ox or 0, oy or -6)
    fs:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
    fs:SetText(text)
    return fs
end

function MakePanel(parent)
    local p = CreateFrame("Frame", nil, parent)
    p:SetAllPoints(parent) ; p:Hide() ; return p
end
