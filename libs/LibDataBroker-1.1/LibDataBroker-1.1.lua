assert(LibStub, "LibDataBroker-1.1 requires LibStub")
assert(LibStub:GetLibrary("CallbackHandler-1.0", true), "LibDataBroker-1.1 requires CallbackHandler-1.0")

local MAJOR, MINOR = "LibDataBroker-1.1", 4
local lib, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end

local callbacks = CallbackHandler:New(lib, "RegisterCallback", "UnregisterCallback", "UnregisterAllCallbacks")

local data = lib.data or {}
lib.data = data
local proxies = lib.proxies or {}
lib.proxies = proxies

local domt = {
	__newindex = function(self, key, value)
		rawset(self, key, value)
		local name = rawget(self, "name")
		callbacks:Fire("LibDataBroker_AttributeChanged", name, key, value, self)
		callbacks:Fire("LibDataBroker_AttributeChanged_"..name, name, key, value, self)
		callbacks:Fire("LibDataBroker_AttributeChanged_"..name.."_"..key, name, key, value, self)
		callbacks:Fire("LibDataBroker_AttributeChanged__"..key, name, key, value, self)
	end,
}

function lib:NewDataObject(name, dataobj)
	if data[name] then return nil end
	dataobj = dataobj or {}
	rawset(dataobj, "name", name)
	data[name] = setmetatable(dataobj, domt)
	callbacks:Fire("LibDataBroker_DataObjectCreated", name, data[name])
	return data[name]
end

function lib:GetDataObjectByName(name)
	return data[name]
end

function lib:GetDataObjectFromProxy(proxy)
	return proxies[proxy]
end

function lib:pairs()
	return pairs(data)
end
