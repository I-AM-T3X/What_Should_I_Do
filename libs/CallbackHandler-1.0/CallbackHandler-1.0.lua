local MAJOR, MINOR = "CallbackHandler-1.0", 7
local CallbackHandler = LibStub:NewLibrary(MAJOR, MINOR)
if not CallbackHandler then return end

local meta = {__index = function(tbl, key) rawset(tbl, key, {}) return tbl[key] end}

local function errorhandler(err)
	return geterrorhandler()(err)
end

local function CreateDispatcher(argCount)
	local code = [[
		local next, xpcall, eh = next, xpcall, ...
		local method, ARGS
		local function call() method(ARGS) end
		return function(handlers, ]]
	local args = {}
	for i = 1, argCount do args[#args+1] = "a"..i end
	code = code .. table.concat(args, ", ") .. [[)
			ARGS = ]] .. table.concat(args, ", ") .. [[
			local index = next(handlers)
			while index do
				method = index
				local success, err = xpcall(call, eh)
				if not success then eh(err) end
				index = next(handlers, index)
			end
		end
	]]
	return loadstring(code)(errorhandler)
end

local Dispatchers = setmetatable({}, {__index=function(t,argCount)
	local dispatcher = CreateDispatcher(argCount)
	rawset(t, argCount, dispatcher)
	return dispatcher
end})
Dispatchers[0] = function(handlers)
	local index = next(handlers)
	while index do
		local success, err = xpcall(index, errorhandler)
		if not success then errorhandler(err) end
		index = next(handlers, index)
	end
end

function CallbackHandler:New(target, RegisterName, UnregisterName, UnregisterAllName)
	RegisterName = RegisterName or "RegisterCallback"
	UnregisterName = UnregisterName or "UnregisterCallback"
	UnregisterAllName = UnregisterAllName or "UnregisterAllCallbacks"

	local events = setmetatable({}, meta)
	local registry = { recurse=0, events=events }

	function registry:Fire(eventname, ...)
		if not rawget(events, eventname) or not next(events[eventname]) then return end
		local oldrecurse = registry.recurse
		registry.recurse = oldrecurse + 1

		Dispatchers[select('#', ...)](events[eventname], ...)

		registry.recurse = oldrecurse

		if registry.insertQueue and oldrecurse == 0 then
			for event,callbacks in pairs(registry.insertQueue) do
				for object,func in pairs(callbacks) do
					events[event][object] = func
				end
			end
			registry.insertQueue = nil
		end
	end

	target[RegisterName] = function(self, eventname, method, ...)
		if type(eventname) ~= "string" then
			error("Usage: "..RegisterName.."(eventname, method[, ...]): 'eventname' - string expected.", 2)
		end
		method = method or eventname
		local func
		if type(method) == "string" then
			func = function(...) self[method](self, ...) end
		elseif type(method) == "function" then
			func = method
		else
			error("Usage: "..RegisterName.."(\"eventname\", \"methodname\"): 'methodname' - string or function expected.", 2)
		end
		if registry.recurse > 0 then
			if not registry.insertQueue then registry.insertQueue = setmetatable({},meta) end
			registry.insertQueue[eventname][self] = func
		else
			events[eventname][self] = func
		end
		return func
	end

	target[UnregisterName] = function(self, eventname)
		if not events[eventname] then return end
		events[eventname][self] = nil
	end

	target[UnregisterAllName] = function(...)
		if select("#",...) < 1 then
			error("Usage: "..UnregisterAllName.."([whatFor])", 2)
		end
		if select("#",...) == 1 and ... == target then
			for eventname, callbacks in pairs(events) do
				for object in pairs(callbacks) do
					events[eventname][object] = nil
				end
			end
		else
			for i = 1, select("#",...) do
				local self = select(i,...)
				if registry.recurse > 0 then
					if not registry.insertQueue then registry.insertQueue = setmetatable({},meta) end
					for eventname in pairs(events) do
						registry.insertQueue[eventname][self] = false
					end
				else
					for eventname, callbacks in pairs(events) do
						callbacks[self] = nil
					end
				end
			end
		end
	end

	return registry
end
