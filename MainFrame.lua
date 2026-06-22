-- MainFrame.lua
-- Main window, left nav, minimap button, init, slash commands
-- Author: I_AM_T3X | v1.0.0

mainFrame = nil
mainPanels = {}

mainFrame = nil
mainPanels = {}

function BuildMainFrame()
    local f=CreateFrame("Frame","WhatShouldIDoFrame",UIParent,"BackdropTemplate")
    f:SetSize(WSID_WIN_W,WSID_WIN_H) ; f:SetPoint("CENTER")
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
    closeBtn:SetFrameStrata(f:GetFrameStrata())
    closeBtn:SetFrameLevel(f:GetFrameLevel() + 1)
    closeBtn:SetScript("OnClick",function()
        f:Hide() ; if settingsFrame then settingsFrame:Hide() end
    end)

    -- Content area
    local contentArea=CreateFrame("Frame",nil,f)
    contentArea:SetPoint("TOPLEFT",f,"TOPLEFT",WSID_NAV_W,-30)
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
            -- Always refresh WSID_Roster when switching to leveling so imports show immediately
            if name=="leveling" then BuildRoster() end
            for k,p in pairs(mainPanels) do if k==name then p:Show() else p:Hide() end end
        end
    )

    f:Hide() ; return f
end

------------------------------------------------------------------------
-- MINIMAP BUTTON
------------------------------------------------------------------------

function RegisterMinimapButton()
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
    if event=="ADDON_LOADED" and arg1==WSID_ADDON_NAME then
        InitDB()
        -- Apply saved theme (must run after InitDB sets defaults and after ApplyTheme is defined)
        if WhatShouldIDoDB.colorTheme == "Custom" and next(WhatShouldIDoDB.customColors) then
            ApplyTheme("Custom", WhatShouldIDoDB.customColors)
        else
            ApplyTheme(WhatShouldIDoDB.colorTheme or "Default")
        end

        -- Define StaticPopup dialogs at init time so they're registered before use
        StaticPopupDialogs["WSID_CONFIRM_THEME"] = StaticPopupDialogs["WSID_CONFIRM_THEME"] or {}
        StaticPopupDialogs["WSID_CONFIRM_CUSTOM"] = StaticPopupDialogs["WSID_CONFIRM_CUSTOM"] or {}
        mainFrame     = BuildMainFrame()
        settingsFrame = BuildSettingsWindow()
        RegisterMinimapButton()
        -- ESC closes the windows
        tinsert(UISpecialFrames, "WhatShouldIDoFrame")
        tinsert(UISpecialFrames, "WhatShouldIDoSettings")
    elseif event=="PLAYER_LOGIN" then
        if WhatShouldIDoDB then BuildRoster() end
    end
end)

SLASH_SPINWHEELS1="/sw" ; SLASH_SPINWHEELS2="/spinwheels" ; SLASH_SPINWHEELS3="/wsid"
SlashCmdList["SPINWHEELS"]=function(msg)
    msg=strtrim(msg)
    local msgL=msg:lower()
    if msgL=="WSID_Roster" then
        BuildRoster()
        print("|cffd5a742What Should I Do?:|r Roster refreshed -- "..#WSID_Roster.." character(s).")
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

