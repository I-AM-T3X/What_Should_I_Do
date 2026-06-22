-- LibStub is a simple versioning stub meant for use in Libraries.
-- LibStub is hereby placed in the Public Domain
-- Credits: Kaelten, Cladhaire, ckknight, Mikk, Ammo, Nevcairiel, joshborke
local LIBSTUB_MAJOR, LIBSTUB_MINOR = "LibStub", 2
local LibStub = _G[LIBSTUB_MAJOR]

if not LibStub or LibStub.minor < LIBSTUB_MINOR then
	LibStub = LibStub or {libs = {}, minors = {}}
	_G[LIBSTUB_MAJOR] = LibStub
	LibStub.minor = LIBSTUB_MINOR

	function LibStub:NewLibrary(major, minor)
		assert(type(major) == "string", "Bad argument #2 to `NewLibrary' (string expected)")
		minor = assert(tonumber(minor), "Minor version must be a number")

		local xlib = self.libs[major]
		if xlib and self.minors[major] >= minor then return end
		xlib = xlib or {}
		self.libs[major] = xlib
		self.minors[major] = minor
		return xlib, self.libs[major]
	end

	function LibStub:GetLibrary(major, silent)
		if not self.libs[major] and not silent then
			error(("Cannot find a library instance of %q."):format(tostring(major)), 2)
		end
		return self.libs[major], self.minors[major]
	end

	function LibStub:IterateLibraries()
		return pairs(self.libs)
	end

	setmetatable(LibStub, { __call = function(lib, ...) return lib:GetLibrary(...) end })
end
