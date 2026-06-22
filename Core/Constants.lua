-- Core/Constants.lua
-- Shared layout constants
-- Author: I_AM_T3X | v1.0.0

WSID_ADDON_NAME = "WhatShouldIDo"

WSID_WIN_W  = 660
WSID_WIN_H  = 520
WSID_NAV_W  = 120
WSID_PAD    = 16
WSID_CONT_W = WSID_WIN_W - WSID_NAV_W - WSID_PAD * 2  -- 508

WSID_SET_W   = 700
WSID_SET_H   = 500
WSID_SET_NAV = 110
WSID_SET_PAD = 12
WSID_SET_CW  = WSID_SET_W - WSID_SET_NAV - WSID_SET_PAD * 2  -- 566
WSID_SET_COL = math.floor((WSID_SET_CW - 12) / 2)            -- 277
