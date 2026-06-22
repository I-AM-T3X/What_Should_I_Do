local MAJOR, MINOR = "LibDBIcon-1.0", 47
local LibDBIcon = LibStub:NewLibrary(MAJOR, MINOR)
if not LibDBIcon then return end

local LDB = LibStub("LibDataBroker-1.1")
local Minimap = Minimap

LibDBIcon.objects     = LibDBIcon.objects or {}
LibDBIcon.callbackRegistered = LibDBIcon.callbackRegistered or false
LibDBIcon.disabled    = LibDBIcon.disabled or {}

local function getAngle(button)
	local mx, my = Minimap:GetCenter()
	local bx, by = button:GetCenter()
	return math.deg(math.atan2(by - my, bx - mx))
end

local function updatePosition(button, db)
	local angle = math.rad(db.minimapPos or 45)
	local x = math.cos(angle) * 80
	local y = math.sin(angle) * 80
	button:ClearAllPoints()
	button:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

local function onDragStart(self)
	self:LockHighlight()
	self.isDragging = true
	GameTooltip:Hide()
	self:SetScript("OnUpdate", function(s)
		local mx, my = Minimap:GetCenter()
		local cx, cy = GetCursorPosition()
		local scale = UIParent:GetScale()
		cx, cy = cx / scale, cy / scale
		s.db.minimapPos = math.deg(math.atan2(cy - my, cx - mx))
		updatePosition(s, s.db)
	end)
end

local function onDragStop(self)
	self:UnlockHighlight()
	self.isDragging = false
	self:SetScript("OnUpdate", nil)
end

local function onEnter(self)
	if self.isDragging then return end
	local obj = self.dataObject
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	if obj.OnTooltipShow then
		obj.OnTooltipShow(GameTooltip)
	elseif obj.tooltip then
		GameTooltip:SetText(obj.tooltip, 1, 1, 1)
		if obj.tooltiptext then
			GameTooltip:AddLine(obj.tooltiptext, 0.8, 0.8, 0.8, true)
		end
	elseif obj.label then
		GameTooltip:SetText(obj.label, 1, 1, 1)
	end
	GameTooltip:Show()
end

local function onLeave(self)
	GameTooltip:Hide()
end

local function onClick(self, btn)
	local obj = self.dataObject
	if obj.OnClick then
		obj.OnClick(self, btn)
	end
end

local function onDoubleClick(self, btn)
	local obj = self.dataObject
	if obj.OnDoubleClick then
		obj.OnDoubleClick(self, btn)
	end
end

local function createButton(name, dataObject, db)
	local button = CreateFrame("Button", "LibDBIcon10_"..name, Minimap)
	button:SetSize(31, 31)
	button:SetFrameStrata("MEDIUM")
	button:SetFrameLevel(8)
	button:SetClampedToScreen(true)

	button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	button:RegisterForDrag("LeftButton")
	button:SetMovable(true)

	local icon = button:CreateTexture(nil, "BACKGROUND")
	icon:SetTexture(dataObject.icon)
	icon:SetSize(17, 17)
	icon:SetPoint("CENTER")

	local border = button:CreateTexture(nil, "OVERLAY")
	border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
	border:SetSize(53, 53)
	border:SetPoint("CENTER")

	button:SetScript("OnEnter",      onEnter)
	button:SetScript("OnLeave",      onLeave)
	button:SetScript("OnClick",      onClick)
	button:SetScript("OnDoubleClick",onDoubleClick)
	button:SetScript("OnDragStart",  onDragStart)
	button:SetScript("OnDragStop",   onDragStop)

	button.dataObject = dataObject
	button.db = db

	updatePosition(button, db)

	if db.hide then
		button:Hide()
	else
		button:Show()
	end

	return button
end

function LibDBIcon:Register(name, dataObject, db)
	if LibDBIcon.objects[name] then return end

	if not db.minimapPos then db.minimapPos = 45 end

	local button = createButton(name, dataObject, db)
	LibDBIcon.objects[name] = button
end

function LibDBIcon:Show(name)
	local button = LibDBIcon.objects[name]
	if button then
		button.db.hide = false
		button:Show()
	end
end

function LibDBIcon:Hide(name)
	local button = LibDBIcon.objects[name]
	if button then
		button.db.hide = true
		button:Hide()
	end
end

function LibDBIcon:IsRegistered(name)
	return LibDBIcon.objects[name] ~= nil
end

function LibDBIcon:Refresh(name, db)
	local button = LibDBIcon.objects[name]
	if button then
		button.db = db
		updatePosition(button, db)
	end
end
