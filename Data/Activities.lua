-- Data/Activities.lua
-- Default activity categories and sub-activities
-- Author: I_AM_T3X | v1.0.0

WSID_DEFAULT_ACTIVITIES = {
    "PvP",
    "Housing",
    "Open World",
    "Rare Hunting",
    "Delves",
    "Gathering",
    "Crafting",
    "Collections",
    "Gold Making",
    "Holiday Events / Trading Post",
    "Leveling",
    "Pet Battles",
    "Anything Goes",
}

WSID_SMART_OPTIONS = {
    ["PvP"]                           = {"Random Battleground","Epic Battleground","Arena Skirmish","War Mode","World PvP","Brawl"},
    ["Housing"]                       = {"Work on House Layout","Gather Decor","Endeavor Tasks","Theme Room","Farm Housing Items","Decorate a Room"},
    ["Open World"]                    = {"World Quests","Weekly Quests","Reputation Grind","Renown Catch-up","Zone Completion","Public Events","Rituals","Void Assaults","Rare Hunting","Daily Objectives"},
    ["Rare Hunting"]                  = {"Current Expansion Rares","Old Expansion Rares","Mount Rare","Toy Rare","Pet Rare","Champion Rare"},
    ["Delves"]                        = {"Solo Delves","Group Delves","Bountiful Delves","Push Higher Tier","Farm Curios","Follower Leveling"},
    ["Gathering"]                     = {"Mining","Herbalism","Fishing","Skinning","Gather for 30 Min","Farm Reagents"},
    ["Crafting"]                      = {"Profession Orders","Crafting Knowledge","Cooldowns","Make Consumables","Craft for Gold","Clean Bags"},
    ["Collections"]                   = {"Mounts","Pets","Toys","Appearances","Achievements","Reputation","Random ATT Category","Transmog Farming","Old Raid for Transmog","Old Dungeon for Transmog","Achievement Hunting","Exploration Achieves","Legacy Achieves"},
    ["Gold Making"]                   = {"Auction House","Gathering Farm","Crafting Shuffle","Transmog Farm","Raw Gold Farm","Vendor Flip","Clean Bank"},
    ["Holiday Events / Trading Post"] = {"Holiday Boss","Holiday Achievements","Trading Post Tasks","Monthly Reward Progress","Event Toys/Pets"},
    ["Leveling"]                      = {"Alt Leveling","Dungeon Spam","Questing","Chromie Time","Follower Dungeons","Prof While Leveling"},
    ["Pet Battles"]                   = {"Pet Battle Dailies","Level Pets","Capture Pets","Family Battler","Pet Dungeon","Random Pet Team"},
    ["Anything Goes"]                 = {"Do the Weirdest Thing","Finish Something Half-Done","One Hour Chaos Mode","Pick Something from Your Backlog"},
}

function GetSubPool(category)
    if WhatShouldIDoDB and WhatShouldIDoDB.subActivities
    and WhatShouldIDoDB.subActivities[category]
    and #WhatShouldIDoDB.subActivities[category] > 0 then
        return WhatShouldIDoDB.subActivities[category]
    end
    return WSID_SMART_OPTIONS[category]
end
