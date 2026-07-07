--[[
    LibResizable-1.0
    A library for adding resizable handles to WoW addon frames.

    Author: I_AM_T3X
    Version: 1.0.0

    Usage:
        local LibResizable = LibStub("LibResizable-1.0")

        LibResizable:MakeResizable(frame, {
            minWidth   = 200,
            minHeight  = 150,
            maxWidth   = 800,
            maxHeight  = 600,
            throttle   = 0.05,          -- seconds between OnResizing callbacks (default 0.05)
            savedVars  = MyAddonDB,      -- optional: table to save/load size (requires savedVarKey)
            savedVarKey = "myFrameSize", -- key inside savedVars to store { width, height }
            snapGrid   = 10,             -- optional: snap to nearest N pixels (0 = off)
            aspectLock = false,          -- optional: lock aspect ratio during resize

            onResizeStart = function(frame, w, h) end,
            onResizing    = function(frame, w, h) end,  -- throttled
            onResizeStop  = function(frame, w, h) end,
        })

    Returns a handle object:
        handle:Enable()
        handle:Disable()
        handle:SetMinSize(w, h)
        handle:SetMaxSize(w, h)
        handle:SetThrottle(seconds)
        handle:SetSnapGrid(pixels)
        handle:SetAspectLock(bool)
        handle:GetSize()        -> width, height
        handle:ResetSize()      -> restores savedVars size or minSize
        handle:Destroy()        -> removes the resize handle entirely
]]

assert(LibStub, "LibResizable-1.0 requires LibStub")

local MAJOR, MINOR = "LibResizable-1.0", 1
local lib, oldMinor = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end  -- already loaded, same or newer version

lib.handles = lib.handles or {}

-------------------------------------------------------------------------------
-- Constants
-------------------------------------------------------------------------------

local HANDLE_SIZE   = 16
local DEFAULT_THROTTLE = 0.05
local HANDLE_TEXTURE_NORMAL    = "Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down"
local HANDLE_TEXTURE_HIGHLIGHT = "Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight"
local HANDLE_TEXTURE_PUSHED    = "Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up"

-------------------------------------------------------------------------------
-- Private helpers
-------------------------------------------------------------------------------

local function Clamp(val, lo, hi)
    if lo and val < lo then return lo end
    if hi and val > hi then return hi end
    return val
end

local function SnapTo(val, grid)
    if not grid or grid <= 0 then return val end
    return math.floor(val / grid + 0.5) * grid
end

-------------------------------------------------------------------------------
-- Handle object methods
-------------------------------------------------------------------------------

local HandleMethods = {}
HandleMethods.__index = HandleMethods

function HandleMethods:Enable()
    self._enabled = true
    self._btn:Show()
end

function HandleMethods:Disable()
    self._enabled = false
    self._btn:Hide()
end

function HandleMethods:SetMinSize(w, h)
    self._minW = w or self._minW
    self._minH = h or self._minH
    self._frame:SetResizeBounds(self._minW, self._minH, self._maxW or nil, self._maxH or nil)
end

function HandleMethods:SetMaxSize(w, h)
    self._maxW = w or self._maxW
    self._maxH = h or self._maxH
    self._frame:SetResizeBounds(self._minW or 0, self._minH or 0, self._maxW, self._maxH)
end

function HandleMethods:SetThrottle(seconds)
    self._throttle = seconds or DEFAULT_THROTTLE
end

function HandleMethods:SetSnapGrid(pixels)
    self._snapGrid = pixels or 0
end

function HandleMethods:SetAspectLock(locked)
    self._aspectLock = locked
    if locked then
        local w, h = self._frame:GetSize()
        self._aspectRatio = (h > 0) and (w / h) or 1
    end
end

function HandleMethods:GetSize()
    return self._frame:GetSize()
end

function HandleMethods:ResetSize()
    local sv = self._savedVars
    local key = self._savedVarKey
    if sv and key and sv[key] then
        self._frame:SetSize(sv[key].width, sv[key].height)
    elseif self._minW and self._minH then
        self._frame:SetSize(self._minW, self._minH)
    end
end

function HandleMethods:Destroy()
    self._btn:Hide()
    self._btn:SetScript("OnMouseDown", nil)
    self._btn:SetScript("OnMouseUp", nil)
    self._frame:SetScript("OnSizeChanged", nil)
    self._btn = nil
    self._frame = nil
    -- remove from lib.handles
    for i, h in ipairs(lib.handles) do
        if h == self then
            table.remove(lib.handles, i)
            break
        end
    end
end

-------------------------------------------------------------------------------
-- Core: MakeResizable
-------------------------------------------------------------------------------

function lib:MakeResizable(frame, opts)
    assert(frame, "LibResizable-1.0: frame is required")
    opts = opts or {}

    -- Build handle object
    local handle = setmetatable({}, HandleMethods)
    handle._frame      = frame
    handle._enabled    = true
    handle._minW       = opts.minWidth   or 0
    handle._minH       = opts.minHeight  or 0
    handle._maxW       = opts.maxWidth   or nil
    handle._maxH       = opts.maxHeight  or nil
    handle._throttle   = opts.throttle   or DEFAULT_THROTTLE
    handle._snapGrid   = opts.snapGrid   or 0
    handle._aspectLock = opts.aspectLock or false
    handle._savedVars  = opts.savedVars  or nil
    handle._savedVarKey = opts.savedVarKey or nil
    handle._lastUpdate = 0

    handle._onResizeStart = opts.onResizeStart or nil
    handle._onResizing    = opts.onResizing    or nil
    handle._onResizeStop  = opts.onResizeStop  or nil

    -- Aspect ratio baseline
    if handle._aspectLock then
        local w, h = frame:GetSize()
        handle._aspectRatio = (h > 0) and (w / h) or 1
    end

    -- Apply saved size if available
    local sv  = handle._savedVars
    local svk = handle._savedVarKey
    if sv and svk and sv[svk] then
        frame:SetSize(sv[svk].width, sv[svk].height)
    end

    -- Make the frame resizable at the WoW API level
    frame:SetResizable(true)
    frame:SetResizeBounds(handle._minW, handle._minH, handle._maxW or 0, handle._maxH or 0)

    -- Create the resize button (bottom-right corner)
    local btn = CreateFrame("Button", nil, frame)
    btn:SetSize(HANDLE_SIZE, HANDLE_SIZE)
    btn:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
    btn:SetNormalTexture(HANDLE_TEXTURE_NORMAL)
    btn:SetHighlightTexture(HANDLE_TEXTURE_HIGHLIGHT)
    btn:SetPushedTexture(HANDLE_TEXTURE_PUSHED)
    btn:EnableMouse(true)
    btn:SetFrameLevel(frame:GetFrameLevel() + 10)
    handle._btn = btn

    -- OnMouseDown: start sizing
    btn:SetScript("OnMouseDown", function(self, button)
        if button ~= "LeftButton" then return end
        if not handle._enabled then return end

        -- Capture aspect ratio fresh at drag start
        if handle._aspectLock then
            local w, h = frame:GetSize()
            handle._aspectRatio = (h > 0) and (w / h) or 1
        end

        frame:StartSizing("BOTTOMRIGHT")

        if handle._onResizeStart then
            handle._onResizeStart(frame, frame:GetSize())
        end
    end)

    -- OnMouseUp: stop sizing, apply snap, save
    btn:SetScript("OnMouseUp", function(self, button)
        if button ~= "LeftButton" then return end

        frame:StopMovingOrSizing()

        local w, h = frame:GetWidth(), frame:GetHeight()

        -- Snap
        w = SnapTo(w, handle._snapGrid)
        h = SnapTo(h, handle._snapGrid)

        -- Clamp
        w = Clamp(w, handle._minW, handle._maxW)
        h = Clamp(h, handle._minH, handle._maxH)

        -- Aspect lock
        if handle._aspectLock and handle._aspectRatio then
            h = w / handle._aspectRatio
            h = Clamp(h, handle._minH, handle._maxH)
            w = h * handle._aspectRatio
            w = Clamp(w, handle._minW, handle._maxW)
        end

        frame:SetSize(w, h)

        -- Save to SavedVariables
        if sv and svk then
            sv[svk] = { width = w, height = h }
        end

        if handle._onResizeStop then
            handle._onResizeStop(frame, w, h)
        end
    end)

    -- OnSizeChanged: throttled live callback
    frame:SetScript("OnSizeChanged", function(self, w, h)
        if not handle._enabled then return end
        if not handle._onResizing then return end

        local now = GetTime()
        if (now - handle._lastUpdate) < handle._throttle then return end
        handle._lastUpdate = now

        handle._onResizing(frame, w, h)
    end)

    table.insert(lib.handles, handle)
    return handle
end

-------------------------------------------------------------------------------
-- Utility: apply to multiple frames at once
-------------------------------------------------------------------------------

--[[
    LibResizable:MakeResizableGroup(frames, sharedOpts)
    Applies the same options to a list of frames.
    Returns a list of handle objects.
]]
function lib:MakeResizableGroup(frames, opts)
    assert(type(frames) == "table", "LibResizable-1.0: frames must be a table")
    local handles = {}
    for _, frame in ipairs(frames) do
        handles[#handles + 1] = self:MakeResizable(frame, opts)
    end
    return handles
end

-------------------------------------------------------------------------------
-- Utility: destroy all handles (useful on addon disable/unload)
-------------------------------------------------------------------------------

function lib:DestroyAll()
    for _, handle in ipairs(lib.handles) do
        pcall(function() handle:Destroy() end)
    end
    lib.handles = {}
end

-------------------------------------------------------------------------------

return lib
