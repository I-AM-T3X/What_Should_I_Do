-- Data/Names.lua
-- Race-based name generation data and functions
-- Author: I_AM_T3X | v1.0.0

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
                  {"'a","'amon","'ar","'ari","'jin","'kah","'kan","'kar","'kas","'rak","'raki","'rik","'ro","'rok","'thas","'tiki","'zar","'zin","'zum"}},
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
        female = {{"Ash","Bane","Cor","Crypt","Dark","Dead","Dread","Grim","Mal","Mor","Rot","Shade","Skel","Soul","Spite","Tomb","Vile","Wrath","Wraith","Wyn"},
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

local NAME_ALIASES = {
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

function GenerateName(race, gender)
    local key = NAME_ALIASES[race] or race
    local data = NAME_DATA[key]
    if not data then
        local pre = {"Ael","Bel","Cal","Dal","El","Fal","Gal","Hal","Ial","Kal"}
        local suf = {"an","ar","ath","en","ion","ith","or","un","us","yn"}
        return pre[math.random(#pre)] .. suf[math.random(#suf)]
    end
    local g = (gender == "Female") and "female" or "male"
    local prefixes = data[g][1]
    local suffixes = data[g][2]
    return prefixes[math.random(#prefixes)] .. suffixes[math.random(#suffixes)]
end

function GenerateNameList(race, gender, count)
    local names, seen, attempts = {}, {}, 0
    while #names < count and attempts < count * 10 do
        local n = GenerateName(race, gender)
        if not seen[n] then seen[n] = true ; table.insert(names, n) end
        attempts = attempts + 1
    end
    return names
end
