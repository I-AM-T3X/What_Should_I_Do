# What Should I Do?

A World of Warcraft addon that helps you decide what to do by spinning wheels across a variety of categories.

**Author:** I_AM_T3X  
**Version:** 1.1.0  
**Special Thanks:** twitch.tv/majghostpants

---

## Features

### 🎯 Activity
Spin a random activity category (PvP, Gathering, Gold Making, Pet Battles, etc.), then spin a sub-activity within that category. Fully customizable — add, remove, and reset activities from the Settings panel.

### ⚔️ Creator
Spin a random valid Race + Class combo for your next character. Filter by faction (Any / Alliance / Horde).

### 📈 Leveling
Spin a class → pick a character from your warband roster → spin an expansion to level through. Expansion pool is level-gated (Chromie Time for sub-70, full list for 70+, Midnight only for 80+). Supports auto-pick and excluded characters.

### 🔤 Name Generator
Generate 10 race-appropriate names for any race and gender combination. Click a name to copy it to your chat input.

### 🧰 Professions
Spin two unique primary professions (Fishing and Cooking excluded).

### 🏰 Raids & Dungeons
Choose Raids or Dungeons mode, spin a random expansion, then spin a random instance from that expansion. Covers all expansions from Classic through Midnight.

---

## Settings

Open Settings from the main window header button, the minimap icon right-click, or `/wsid settings`.

### Activities Tab
Add, remove, or reset your activity and sub-activity lists.

### Roster Tab
View all warband characters the addon has seen. Exclude characters from the Leveling wheel without removing them. Remove individual characters or clear all others.

### Import / Export Tab
Export your roster as an encoded string to share between accounts or characters. Import a string to merge rosters.

### Colors Tab
Choose from 5 preset color themes or build a fully custom theme. Requires a UI reload to apply.

---

## Slash Commands

| Command | Action |
|---------|--------|
| `/wsid` | Toggle main window |
| `/sw` | Toggle main window |
| `/spinwheels` | Toggle main window |
| `/wsid settings` | Toggle settings window |
| `/wsid roster` | Force roster refresh |

---

## Minimap Button

- **Left-click** — Toggle main window
- **Right-click** — Toggle settings window

---

## Roster

The addon automatically adds your current character to the roster every login. Log into each alt once and they'll appear in the Leveling wheel. The roster persists in SavedVariables (`WhatShouldIDoDB`).

---

## Installation

1. Download the latest release zip
2. Extract the `WhatShouldIDo` folder into `World of Warcraft/_retail_/Interface/AddOns/`
3. Reload your UI or log in

---

## Compatibility

- **Game Version:** The War Within / Midnight (Interface 120007)
- **SavedVariables:** `WhatShouldIDoDB`

---

## License

All rights reserved. © I_AM_T3X
