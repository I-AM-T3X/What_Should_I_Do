-- Panels/Leveling.lua
-- Author: I_AM_T3X | v1.0.0

function BuildLevelingPanel(contentArea)
    local panel = MakePanel(contentArea)
    local hdr = MakeHeader(panel, "Leveling Wheel")
    hdr:SetPoint("TOPLEFT", panel, "TOPLEFT", WSID_PAD, -WSID_PAD)

    local desc = MakeDimLabel(panel, "Spin a class -> pick a character -> spin an expansion.", hdr, "BOTTOMLEFT", 4, -8)

    -- Auto-pick character toggle
    local autoPickLbl = panel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    autoPickLbl:SetPoint("TOPLEFT", desc, "BOTTOMLEFT", 0, -8)
    autoPickLbl:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
    autoPickLbl:SetText("Auto-pick a character after class spin:")

    local autoPick = false
    local autoPickBtn = MakeBtn(panel, "Off", 60, 24)
    autoPickBtn:SetPoint("LEFT", autoPickLbl, "RIGHT", 8, 0)
    autoPickBtn:SetScript("OnClick", function()
        autoPick = not autoPick
        if autoPick then
            autoPickBtn._lbl:SetText("On")
            autoPickBtn:SetBackdropColor(C.nav_active[1],C.nav_active[2],C.nav_active[3])
            autoPickBtn:SetBackdropBorderColor(C.nav_border[1],C.nav_border[2],C.nav_border[3],1)
            autoPickBtn._lbl:SetTextColor(1,1,1)
        else
            autoPickBtn._lbl:SetText("Off")
            autoPickBtn:SetBackdropColor(C.btn_bg[1],C.btn_bg[2],C.btn_bg[3])
            autoPickBtn:SetBackdropBorderColor(C.btn_bdr[1],C.btn_bdr[2],C.btn_bdr[3],1)
            autoPickBtn._lbl:SetTextColor(C.btn_text[1],C.btn_text[2],C.btn_text[3])
        end
    end)

    local classBox, classLabel = MakeResult(panel, nil, 52, "CLASS")
    classBox:SetPoint("TOPLEFT", autoPickLbl, "BOTTOMLEFT", 0, -10)
    classLabel:SetText("Class")

    local spinClassBtn = MakeBtn(panel, "Spin Class", nil, 30)
    spinClassBtn:SetPoint("TOP", classBox, "BOTTOM", 0, -10)
    spinClassBtn:SetPoint("LEFT",    panel, "LEFT",  WSID_PAD, 0)
    spinClassBtn:SetPoint("RIGHT",   panel, "RIGHT", -WSID_PAD, 0)

    local charHdr = MakeHeader(panel, "Characters of that class  (click to select)")
    charHdr:SetPoint("TOPLEFT", spinClassBtn, "BOTTOMLEFT", 0, -10)

    local listBG, listContent, listReset = MakeScrollBox(panel, nil, 110)
    listBG:SetPoint("TOPLEFT", charHdr, "BOTTOMLEFT", 0, 0)

    local expBox, expLabel = MakeResult(panel, nil, 52, "EXPANSION")
    expBox:SetPoint("TOPLEFT", listBG, "BOTTOMLEFT", 0, -10)
    expLabel:SetText("Expansion")

    local spinExpBtn = MakeBtn(panel, "Spin Expansion", nil, 30)
    spinExpBtn:SetPoint("TOP", expBox, "BOTTOM", 0, -10)
    spinExpBtn:SetPoint("LEFT",    panel, "LEFT",  WSID_PAD, 0)
    spinExpBtn:SetPoint("RIGHT",   panel, "CENTER", -3, 0)
    spinExpBtn:SetEnabled(false)

    local spinAllBtn = MakeBtn(panel, "Spin All Steps", nil, 30)
    spinAllBtn:SetPoint("TOP", expBox, "BOTTOM", 0, -10)
    spinAllBtn:SetPoint("LEFT",    panel, "CENTER", 3, 0)
    spinAllBtn:SetPoint("RIGHT",   panel, "RIGHT", -WSID_PAD, 0)

    local noteLbl = panel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    noteLbl:SetPoint("TOPLEFT", spinExpBtn, "BOTTOMLEFT", 0, -10)
    noteLbl:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
    noteLbl:SetText("Roster fills automatically as you log into each character.")

    local pickedClass=nil ; local selectedChar=nil ; local charRows={}

    local function ClearList()
        for _,r in ipairs(charRows) do r:Hide() end
        charRows={} ; selectedChar=nil ; listContent:SetHeight(110) ; listReset()
    end

    local function PopulateList(class)
        ClearList()
        local matches={}
        for _,ch in ipairs(WSID_Roster) do
            local excluded = WhatShouldIDoDB.excludedChars and WhatShouldIDoDB.excludedChars[ch.name]
            if ch.class==class and (ch.level or 0) < 90 and not excluded then
                table.insert(matches,ch)
            end
        end
        if #matches==0 then
            local none=listContent:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            none:SetPoint("TOPLEFT",listContent,"TOPLEFT",8,-8)
            none:SetTextColor(0.65,0.30,0.30)
            none:SetText("No "..class.."s available for leveling.  (Max level characters are excluded.)")
            table.insert(charRows, none) ; listContent:SetHeight(30) ; return
        end
        for i,ch in ipairs(matches) do
            local even=(i%2==0)
            local row=CreateFrame("Button",nil,listContent)
            row:SetHeight(24)
            row:SetPoint("TOP",   listContent, "TOP",   0, -(i-1)*24)
            row:SetPoint("LEFT",  listContent, "LEFT",  0, 0)
            row:SetPoint("RIGHT", listContent, "RIGHT", 0, 0)
            local rowBg=row:CreateTexture(nil,"BACKGROUND") ; rowBg:SetAllPoints()
            rowBg:SetColorTexture(even and C.row_even[1] or C.row_odd[1],
                                  even and C.row_even[2] or C.row_odd[2],
                                  even and C.row_even[3] or C.row_odd[3],1)
            local cc=WSID_CLASS_COLORS[ch.class] or {r=0.8,g=0.8,b=0.8}
            local fs=row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            fs:SetPoint("LEFT",row,"LEFT",10,0) ; fs:SetJustifyH("LEFT")
            fs:SetText(string.format("|cff%02x%02x%02x%s|r  |cffaaaaaa%s|r  |cffffcc00Lv %d|r%s",
                cc.r*255,cc.g*255,cc.b*255,ch.name,ch.race or "",ch.level or 0,
                ch.current and "  |cff55cc55(you)|r" or ""))
            local charData=ch
            row:SetScript("OnClick", function()
                selectedChar=charData
                for _,r in ipairs(charRows) do
                    if r._bg then
                        local re=r._even
                        r._bg:SetColorTexture(re and C.row_even[1] or C.row_odd[1],
                                              re and C.row_even[2] or C.row_odd[2],
                                              re and C.row_even[3] or C.row_odd[3],1)
                    end
                end
                rowBg:SetColorTexture(C.row_select[1],C.row_select[2],C.row_select[3],1)
            end)
            row:SetScript("OnEnter", function()
                if selectedChar~=charData then rowBg:SetColorTexture(C.row_hover[1],C.row_hover[2],C.row_hover[3],1) end end)
            row:SetScript("OnLeave", function()
                if selectedChar~=charData then
                    rowBg:SetColorTexture(even and C.row_even[1] or C.row_odd[1],
                                         even and C.row_even[2] or C.row_odd[2],
                                         even and C.row_even[3] or C.row_odd[3],1)
                end end)
            row._bg=rowBg ; row._even=even ; row._charData=ch
            table.insert(charRows, row)
        end
        listContent:SetHeight(math.max(24,#matches*24+2))
    end

    local function DoSpinClass(onDone)
        local pool={} ; for cls in pairs(WSID_CLASS_COLORS) do table.insert(pool,cls) end
        StopSlot() ; pickedClass=nil ; selectedChar=nil
        classLabel:SetText("Class") ; classLabel:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
        expLabel:SetText("Expansion") ; expLabel:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
        spinExpBtn:SetEnabled(false) ; ClearList()
        classLabel:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
        StartSlot(classLabel, pool, function(winner)
            pickedClass=winner
            local cc=WSID_CLASS_COLORS[winner]
            if cc then classLabel:SetTextColor(cc.r,cc.g,cc.b) end
            PopulateList(winner) ; spinExpBtn:SetEnabled(true)

            -- Auto-pick: spin a random eligible character from the list
            if autoPick and #charRows > 0 then
                -- Build eligible pool (already filtered in PopulateList via charRows)
                local eligible = {}
                for _, row in ipairs(charRows) do
                    if row._charData then table.insert(eligible, row) end
                end
                if #eligible > 0 then
                    -- Small delay so the class slot finishes visually first
                    C_Timer.After(0.3, function()
                        local pick = eligible[math.random(#eligible)]
                        -- Simulate a click on that row
                        pick:GetScript("OnClick")(pick)
                        -- Flash the selected row so user sees it
                        if pick._bg then
                            pick._bg:SetColorTexture(C.spin_text[1]*0.6,C.spin_text[2]*0.6,C.spin_text[3]*0.6,1)
                            C_Timer.After(0.15, function()
                                pick._bg:SetColorTexture(C.row_select[1],C.row_select[2],C.row_select[3],1)
                            end)
                        end
                    end)
                end
            end

            if onDone then onDone(winner) end
        end)
    end

    spinClassBtn:SetScript("OnClick", function()
        spinClassBtn:SetEnabled(false) ; spinAllBtn:SetEnabled(false)
        DoSpinClass(function(_) spinClassBtn:SetEnabled(true) ; spinAllBtn:SetEnabled(true) end)
    end)

    spinExpBtn:SetScript("OnClick", function()
        if not selectedChar then
            UIErrorsFrame:AddMessage("|cffd5a742What Should I Do?:|r Select a character first.",1,0.8,0.2) ; return
        end
        local pool = GetExpansionPool(selectedChar.level or 1)
        if #pool == 1 then
            expLabel:SetText(pool[1])
            expLabel:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3])
            return
        end
        StopSlot() ; spinExpBtn:SetEnabled(false)
        expLabel:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
        StartSlot(expLabel, pool, function(_)
            expLabel:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3]) ; spinExpBtn:SetEnabled(true)
        end)
    end)

    spinAllBtn:SetScript("OnClick", function()
        spinClassBtn:SetEnabled(false) ; spinAllBtn:SetEnabled(false) ; spinExpBtn:SetEnabled(false)
        DoSpinClass(function(winner)
            local autoChar=nil
            for _,ch in ipairs(WSID_Roster) do
                local excluded = WhatShouldIDoDB.excludedChars and WhatShouldIDoDB.excludedChars[ch.name]
                if ch.class==winner and (ch.level or 0) < 90 and not excluded then
                    autoChar=ch ; break
                end
            end
            if autoChar then
                selectedChar=autoChar
                if charRows[1] and charRows[1]._bg then
                    charRows[1]._bg:SetColorTexture(C.row_select[1],C.row_select[2],C.row_select[3],1)
                end
                local pool=GetExpansionPool(autoChar.level or 1)
                if #pool==1 then
                    expLabel:SetText(pool[1])
                    expLabel:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3])
                    spinClassBtn:SetEnabled(true) ; spinExpBtn:SetEnabled(true) ; spinAllBtn:SetEnabled(true)
                else
                    expLabel:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
                    StartSlot(expLabel, pool, function(_)
                        expLabel:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3])
                        spinClassBtn:SetEnabled(true) ; spinExpBtn:SetEnabled(true) ; spinAllBtn:SetEnabled(true)
                    end)
                end
            else
                spinClassBtn:SetEnabled(true) ; spinExpBtn:SetEnabled(true) ; spinAllBtn:SetEnabled(true)
            end
        end)
    end)

    return panel
end

------------------------------------------------------------------------
-- NAME GENERATOR DATA
------------------------------------------------------------------------

local NAME_DATA = {
    ["Human"] = {
        male   = {{"Al","Ard","Bren","Cal","Dar","Ed","Gar","Hal","Jan","Kel","Lor","Mar","Ned","Or","Per","Ran","Sar","Tal","Ulf","Val"},
                  {"an","ath","bert","dan","ek","en","ford","hard","ik","lan","len","mar","on","or","ric","rick","ton","us","win"}},
        female = {{"Ade","Bri","Cath","Dor","El","Gwen","Helen","Is","Joss","Kath","Lil","Mar","Mir","Nat","Or","Per","Ros","Sara","Tan","Val"},
                  {"a","aine","ath","en","ess","ia","ine","ith","la","len","lyn","na","nis","ora","ra","tha","ya"}},
    },
    ["Night Elf"] = {
        male   = {{"Ael","Alth","Aren","Cel","Dath","Elar","Fal","Halad","Iel","Kael","Lor","Mal","Nath","Oel","Reth","Sal","Tal","Vel","Xal","Zel"},
                  {"adan","amir","aran","avel","dath","elar","enar","ethas","idan","ilar","inar","istor","ithas","odath","oran","orin","othas","udath","unar"}},
        female = {{"Ash","Bel","Cel","Dath","Elun","Fael","Ilth","Kal","Lun","Mael","Nael","Quel","Rael","Sal","Tal","Thal","Uel","Val","Xal","Zel"},
                  {"ania","ara","aris","ath","dath","dris","elle","eris","iath","iel","inda","ira","ith","lia","liel","nara","nis","riel","sha","thas"}},
    },
    ["Orc"] = {
        male   = {{"Bak","Drak","Grak","Grom","Gor","Gruk","Karg","Krak","Lok","Mak","Mor","Nak","Orgr","Rak","Rok","Thrak","Trok","Urak","Vrak","Zug"},
                  {"al","am","ar","ash","az","dan","en","gal","gar","gath","grak","grim","gun","ish","kar","mak","mar","nosh","rok","tar","ush"}},
        female = {{"Azg","Drak","Gasha","Gruk","Kasha","Loka","Masha","Naka","Orka","Raka","Roka","Shaka","Thaka","Traka","Urka","Vaka","Waka","Yaka","Zaka","Zuga"},
                  {"a","asha","da","ga","isha","ka","la","ma","na","ra","sha","ta","thra","tuka","ya","za"}},
    },
    ["Dwarf"] = {
        male   = {{"Ald","Bald","Bor","Dar","Dun","Eld","Fal","Gald","Gimb","Gor","Grim","Gund","Hal","Keld","Morg","Orn","Thor","Thur","Ulf","Vol"},
                  {"ak","al","an","bar","bek","dar","din","ek","en","fur","gal","grim","in","ir","kin","lin","mir","nar","ok","rin","ur"}},
        female = {{"Ald","Beld","Bryn","Deld","Edl","Fald","Geld","Gild","Gyld","Held","Hyld","Ild","Keld","Meld","Nyld","Old","Ryld","Syld","Thyld","Wyld"},
                  {"a","ais","da","dis","dra","dris","dyn","ia","ina","ira","ith","na","nda","nis","ra","rin","rith","ryn","tha","yn"}},
    },
    ["Gnome"] = {
        male   = {{"Bil","Bim","Daz","Fiz","Giz","Kaz","Mek","Nib","Pix","Poz","Qix","Rix","Siz","Taz","Tik","Viz","Whiz","Wiz","Zap","Zip"},
                  {"blix","ble","borg","brix","daz","fiz","gix","gle","grik","lix","mek","nix","pix","plex","rix","snik","taz","tik","trix","zap","zig"}},
        female = {{"Bel","Bix","Daz","Fiz","Gix","Kaz","Mex","Nix","Pix","Qix","Rix","Siz","Taz","Tix","Vix","Wix","Xix","Yix","Zix","Zap"},
                  {"a","ble","da","dra","fiz","gix","ia","ina","ira","ith","la","lix","na","nia","nix","ra","rix","sha","tix","za"}},
    },
    ["Troll"] = {
        male   = {{"Akil","Bwon","Dal","Gan","Hak","Jin","Kaz","Khal","Mal","Rak","Ras","Sen","Tal","Vol","Wal","Zal","Zan","Zar","Zep","Zul"},
                  {"'a","'amon","'ar","'ari","'jin","'jin","'kah","'kan","'kar","'kas","'rak","'raki","'rik","'ro","'rok","'thas","'tiki","'zar","'zin","'zum"}},
        female = {{"Akil","Bwon","Dal","Gan","Hak","Jin","Kaz","Khal","Mal","Rak","Ras","Sen","Tal","Vol","Wal","Zal","Zan","Zar","Zep","Zul"},
                  {"'a","'aja","'ali","'ama","'ani","'ara","'ari","'asha","'ini","'ira","'isa","'ita","'iya","'ola","'ona","'ora","'sha","'tika","'ya","'za"}},
    },
    ["Blood Elf"] = {
        male   = {{"Ael","Anar","Bel","Dath","Elar","Fal","Ial","Kael","Lor","Mal","Nath","Quel","Rael","Sal","Selth","Tal","Thal","Vel","Xal","Zel"},
                  {"amir","anas","aran","aris","athas","dath","elar","enar","ethas","idan","ilar","iras","istor","ithas","odath","oran","orin","othas","umar","unar"}},
        female = {{"Aela","Bel","Cael","Dath","Elara","Fael","Iala","Kael","Lael","Mael","Nael","Quel","Rael","Sal","Sel","Tal","Thal","Vel","Xal","Zel"},
                  {"ania","ara","aris","ath","dath","dris","elle","eris","iath","iel","inda","ira","ith","lia","liel","nara","nis","riel","sha","thas"}},
    },
    ["Undead"] = {
        male   = {{"Ath","Bane","Cor","Crypt","Dark","Dead","Dread","Grim","Mal","Mor","Nec","Rot","Shade","Skel","Soul","Spite","Tomb","Vile","Wrath","Wraith"},
                  {"bone","blight","crypt","curse","death","decay","dread","fang","grim","grave","hate","maw","plague","rot","shade","skull","spite","tomb","vex","woe"}},
        female = {{"Ash","Bane","Cor","Crypt","Dark","Dead","Dread","Grim","Mal","Mor","Mor","Rot","Shade","Skel","Soul","Spite","Tomb","Vile","Wrath","Wraith"},
                  {"a","ash","bane","bone","da","dra","ia","ina","ira","ith","la","na","nia","ra","rith","sha","thas","vex","ya","za"}},
    },
    ["Draenei"] = {
        male   = {{"Akh","Azz","Dar","Dur","Esh","Ikh","Khar","Lor","Mar","Mor","Naz","Ner","Oth","Resh","Sha","Thar","Ther","Ukh","Vash","Zar"},
                  {"adar","adis","akhar","amosh","anak","anar","anosh","aras","aris","athas","athor","avash","edas","edis","enas","enis","ethas","ithar","ithos","udas"}},
        female = {{"Akh","Azz","Dar","Dur","Esh","Ikh","Khar","Lor","Mar","Mor","Naz","Ner","Oth","Resh","Sha","Thar","Ther","Ukh","Vash","Zar"},
                  {"a","adis","aeis","aia","aira","akia","alia","anis","aras","aria","asha","asis","atha","eis","ena","enia","ika","ilia","ira","isha"}},
    },
    ["Tauren"] = {
        male   = {{"Brug","Drak","Grak","Gor","Gruk","Hamuul","Karg","Krag","Lok","Mag","Mak","Mor","Mur","Nak","Rok","Rug","Tor","Torg","Unk","Zan"},
                  {"amani","anar","athar","atuk","duruk","gadar","ganar","gar","grak","inar","itar","kadar","kanar","nadar","nanar","rakar","ranar","tadar","tanar","turak"}},
        female = {{"Ayame","Azak","Brana","Drana","Grana","Hana","Jana","Kana","Lana","Mana","Nana","Rana","Rona","Sana","Tana","Tona","Uana","Vana","Wana","Yana"},
                  {"a","ada","ana","anda","ani","anka","ara","ari","asha","ata","aya","ina","ira","isha","ita","iya","ona","ora","sha","ya"}},
    },
    ["Worgen"] = {
        male   = {{"Ald","Arn","Balt","Bram","Cald","Drak","Eld","Falk","Grim","Hark","Keld","Mork","Nark","Ork","Ralk","Sark","Tark","Ulk","Vork","Wark"},
                  {"en","ar","ath","borne","cliffe","croft","dale","fell","ford","grimm","hurst","moor","more","ness","shaw","shire","thorpe","ton","vale","wood"}},
        female = {{"Ald","Ash","Bram","Cath","Drak","Eld","Falk","Grim","Hark","Keld","Mork","Nark","Ork","Ralk","Sark","Tark","Ulk","Vork","Wark","Wren"},
                  {"a","ah","ath","borne","dale","en","fell","ford","grimm","hurst","ia","ina","ira","ith","la","moor","na","ness","ra","sha"}},
    },
    ["Goblin"] = {
        male   = {{"Bix","Blaz","Daz","Fiz","Giz","Kaz","Krix","Mek","Nix","Pix","Rix","Slix","Snix","Stix","Taz","Trik","Vix","Wix","Zap","Zip"},
                  {"blix","ble","borg","brix","daz","fiz","gix","gle","grik","lix","mek","nix","pix","plex","rix","snik","taz","trik","trix","zap"}},
        female = {{"Bix","Blaz","Daz","Fiz","Giz","Kaz","Krix","Mek","Nix","Pix","Rix","Slix","Snix","Stix","Taz","Trik","Vix","Wix","Zap","Zip"},
                  {"a","ble","da","dra","fiz","gix","ia","ina","ira","ith","la","lix","na","nia","nix","ra","rix","sha","tix","za"}},
    },
    ["Pandaren"] = {
        male   = {{"Chen","Fei","Han","Ji","Kun","Lei","Li","Liang","Lin","Liu","Long","Mei","Ming","Peng","Quan","Shen","Wei","Xiao","Yan","Yu"},
                  {"bao","chen","da","feng","han","hua","ji","jian","jun","kun","lei","li","lian","long","ming","peng","qing","shan","wei","xuan"}},
        female = {{"Bao","Chen","Fei","Han","Ji","Kun","Lei","Li","Liang","Lin","Liu","Mei","Ming","Peng","Quan","Shen","Wei","Xiao","Yan","Yu"},
                  {"a","bao","chen","da","fen","hua","ia","ina","ira","ith","juan","la","lan","li","lian","mei","ming","na","ra","sha"}},
    },
    ["Void Elf"] = {
        male   = {{"Aethar","Crael","Dar","Dusk","Ethar","Fael","Gael","Hal","Iael","Jael","Kael","Lael","Mael","Nael","Oael","Pael","Rael","Sael","Tael","Vel"},
                  {"amir","anas","aran","aris","athas","dath","elar","enar","ethas","idan","ilar","iras","istor","ithas","odath","oran","orin","othas","umar","unar"}},
        female = {{"Aela","Bel","Cael","Dusk","Elara","Fael","Iala","Kael","Lael","Mael","Nael","Quel","Rael","Sal","Sel","Tal","Thal","Vel","Xal","Zel"},
                  {"ania","ara","aris","ath","dath","dris","elle","eris","iath","iel","inda","ira","ith","lia","liel","nara","nis","riel","sha","thas"}},
    },
    ["Dracthyr"] = {
        male   = {{"Arath","Drak","Embr","Flam","Frost","Gale","Imm","Keth","Lith","Malath","Nath","Rath","Scal","Sear","Smok","Storm","Thorn","Venth","Volc","Wyth"},
                  {"adon","adrak","akar","akath","aketh","alath","anath","arath","arkath","arnak","arrath","arshak","arthas","arwing","athos","aveth","axath","azrak","iketh","unwing"}},
        female = {{"Arath","Drak","Embr","Flam","Frost","Gale","Imm","Keth","Lith","Malath","Nath","Rath","Scal","Sear","Smok","Storm","Thorn","Venth","Volc","Wyth"},
                  {"a","adra","aela","aera","aia","aira","alia","anis","ara","aria","asha","ath","eia","ela","ena","enia","iera","ilia","ira","isha"}},
    },
    ["Earthen"] = {
        male   = {{"Ald","Bald","Bor","Dar","Dun","Eld","Fal","Gald","Grav","Gor","Grim","Gund","Hal","Iron","Keld","Morg","Ore","Stone","Thor","Vol"},
                  {"ak","al","an","bar","bek","dar","din","ek","en","fur","gal","grim","in","ir","kin","lin","mir","nar","ok","rin"}},
        female = {{"Ald","Beld","Bryn","Deld","Edl","Fald","Geld","Gild","Gyld","Held","Hyld","Ild","Keld","Meld","Nyld","Old","Ryld","Syld","Thyld","Wyld"},
                  {"a","ais","da","dis","dra","dris","dyn","ia","ina","ira","ith","na","nda","nis","ra","rin","rith","ryn","tha","yn"}},
    },
    ["Haranir"] = {
        male   = {{"Ahar","Bhar","Char","Dhar","Ehar","Fhar","Ghar","Hhar","Ihar","Jhar","Khar","Lhar","Mhar","Nhar","Ohar","Phar","Rhar","Shar","Thar","Vhar"},
                  {"anis","aras","aris","asha","asis","atha","edas","edis","enas","enis","ethas","ithar","ithos","udas","udar","unas","unar","uras","uris","usha"}},
        female = {{"Ahar","Bhar","Char","Dhar","Ehar","Fhar","Ghar","Hhar","Ihar","Jhar","Khar","Lhar","Mhar","Nhar","Ohar","Phar","Rhar","Shar","Thar","Vhar"},
                  {"a","adis","aeis","aia","aira","akia","alia","anis","aras","aria","asha","asis","atha","eis","ena","enia","ika","ilia","ira","isha"}},
    },
}

-- Races that share name tables with another
local NAME_ALIASES = {
    ["Gnome"]               = "Gnome",
    ["Dark Iron Dwarf"]     = "Dwarf",
    ["Lightforged Draenei"] = "Draenei",
    ["Kul Tiran"]           = "Human",
    ["Mechagnome"]          = "Gnome",
    ["Nightborne"]          = "Blood Elf",
    ["Highmountain Tauren"] = "Tauren",
    ["Mag'har Orc"]         = "Orc",
    ["Zandalari Troll"]     = "Troll",
    ["Vulpera"]             = "Goblin",
}

local function GenerateName(race, gender)
    local key = NAME_ALIASES[race] or race
    local data = NAME_DATA[key]
    if not data then
        -- fallback generic fantasy
        local pre = {"Ael","Bel","Cal","Dal","El","Fal","Gal","Hal","Ial","Kal"}
        local suf = {"an","ar","ath","en","ion","ith","or","un","us","yn"}
        return pre[math.random(#pre)] .. suf[math.random(#suf)]
    end
    local g = (gender == "Female") and "female" or "male"
    local prefixes = data[g][1]
    local suffixes = data[g][2]
    return prefixes[math.random(#prefixes)] .. suffixes[math.random(#suffixes)]
end

local function GenerateNameList(race, gender, count)
    local names = {}
    local seen  = {}
    local attempts = 0
    while #names < count and attempts < count * 10 do
        local n = GenerateName(race, gender)
        if not seen[n] then
            seen[n] = true
            table.insert(names, n)
        end
        attempts = attempts + 1
    end
    return names
end

------------------------------------------------------------------------
-- NAME GENERATOR PANEL
------------------------------------------------------------------------

