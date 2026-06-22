-- Panels/About.lua
-- Author: I_AM_T3X | v1.0.0

function BuildAboutPanel(contentArea)
    local panel = MakePanel(contentArea)
    local W = WSID_CONT_W

    local scrollBG, scrollContent, scrollReset = MakeScrollBox(panel, W, WSID_WIN_H-30-WSID_PAD*2)
    scrollBG:SetPoint("TOPLEFT", panel, "TOPLEFT", WSID_PAD, -WSID_PAD)

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
        {text="/wsid WSID_Roster       --  Refresh character WSID_Roster", size=11, color={C.dim_text[1],C.dim_text[2],C.dim_text[3]}},
        {text=" ", size=5},
        {text="Roster:", size=12, color={C.header_txt[1],C.header_txt[2],C.header_txt[3]}},
        {text="Characters are added automatically each time you log in.", size=11, color={C.dim_text[1],C.dim_text[2],C.dim_text[3]}},
        {text="Leveling wheel excludes max level (90) characters.", size=11, color={C.dim_text[1],C.dim_text[2],C.dim_text[3]}},
        {text="Use Settings -- Import/Export to share rosters between accounts.", size=11, color={C.dim_text[1],C.dim_text[2],C.dim_text[3]}},
        {text=" ", size=5},
        {text="Settings:", size=12, color={C.header_txt[1],C.header_txt[2],C.header_txt[3]}},
        {text="Activities    --  Add/remove categories and their sub-activities.", size=11, color={C.dim_text[1],C.dim_text[2],C.dim_text[3]}},
        {text="Roster        --  View and remove characters from the WSID_Roster.", size=11, color={C.dim_text[1],C.dim_text[2],C.dim_text[3]}},
        {text="Import/Export --  Share WSID_Roster strings between two accounts.", size=11, color={C.dim_text[1],C.dim_text[2],C.dim_text[3]}},
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


