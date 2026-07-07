-- Data/Changelog.lua
-- Addon changelog entries
-- Author: I_AM_T3X
-- To add a new version: add a new block at the TOP of WSID_CHANGELOG
-- Types: "new", "fix", "change"

WSID_CHANGELOG = {
    {version="1.2.0", entries={
        {type="new",  text="Expansion Exclusions -- New Expansions settings tab lets you exclude specific expansions from the Raids & Dungeons spinner via checkboxes."},
        {type="new",  text="Exclude Farming Professions -- Checkbox on the Profession Picker to exclude Herbalism, Mining, and Skinning from the spin pool."},
        {type="new",  text="In-Addon Changelog -- New Changelog tab in Settings showing full version history."},
        {type="fix",  text="Fixed Troll and Zandalari Troll name generator producing names with apostrophes, which are not valid when trying to name your new character."},
    }},
    {version="1.1.1", entries={
        {type="new",  text="UI Scale -- New Settings tab to scale the entire addon from 50% to 200% in 10% steps. Changes apply instantly."},
        {type="new",  text="Reset Size button added to the Settings nav to quickly return UI scale to 100%."},
    }},
    {version="1.1.0", entries={
        {type="new",  text="Import / Export -- Share your warband roster between characters and accounts via an encoded string."},
        {type="new",  text="Raids & Dungeons -- Full panel with complete dungeon and raid lists for every expansion from Classic through Midnight."},
        {type="new",  text="Name Generator -- Generate 10 race-appropriate names per race and gender. Click to copy to chat."},
        {type="new",  text="Professions -- Spin two unique primary professions."},
        {type="new",  text="Exclude Characters -- Mark roster characters as excluded from the Leveling wheel without removing them."},
        {type="new",  text="Color Themes -- 5 preset themes plus fully custom color picker."},
        {type="new",  text="ESC now closes both the main window and settings window."},
        {type="fix",  text="Raids & Dungeons data corrected -- all expansion lists verified directly from the Adventure Guide."},
        {type="fix",  text="Export string encoding collision fixed between Hunter (class) and Horde (faction) short codes."},
    }},
}
