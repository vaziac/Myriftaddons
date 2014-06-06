local toc, data = ...
local id = toc.identifier

local initialized = false
local function init()
	if initialized == true then return end
	wyk.func.ClassIcons()
	wyk.func.FindGearIcons()
	wyk.func.LoadIcons()
	if wyk.vars.IconCount > 8 then initialized = true end
	--print("found "..tostring(wyk.vars.usrCallingIconCount).." class icons")
	--print("found "..tostring(wyk.func.Count(wyk_saved_GearIcons)).." gear icons")
	--print("loaded "..tostring(wyk.vars.IconCount).." icons")
end
Command.Event.Attach(Event.Unit.Availability.Full, init, "libWykkyd Initialize")
--table.insert(Event.Unit.Availability.Full, {init, id, "libWykkyd Initialize"} )
--table.insert(Event.System.Update.Begin, { init, id, "libWykkyd Initialize" })

