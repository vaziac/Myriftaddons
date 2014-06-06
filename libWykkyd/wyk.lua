local toc, data = ...
local id = toc.identifier

wyk = {
	vars = {},
	func = {},
	addons = {},
	EVENT = {},
	frame = {},
}

function wyk.ready() 
	if Inspect.System.Secure() == true then 
		return false 
	else 
		return true 
	end 
end
function wyk.Ready() return wyk.ready() end
function wyk.IsReady() return wyk.ready() end
function wyk.isReady() return wyk.ready() end
function wyk.combat() return Inspect.System.Secure() end
function wyk.Combat() return wyk.combat() end
function wyk.InCombat() return wyk.combat() end
function wyk.inCombat() return wyk.combat() end

local nameCount = 0
function wyk.UniqueName(name)
	nameCount = nameCount + 1
	return "Frame"..tostring(nameCount).."_"..name
end

--print("Loaded Wykkyd Library")