local playerid = Inspect.Unit.Lookup("player")
local raidmembers = {"group01","group02","group03","group04","group05","group06","group07","group08","group09","group10","group11","group12","group13","group14","group15","group16","group17","group18","group19","group20"}
local frameset = {}
local lastframe
local durtable = {Lavafeld = 10, Kraftausbreitung = 30, ["Befehl zum Angriff"] = 30, ["Wüten"] = 10,["Orchester der Ebenen"] = 15, Wildwuchs = 12, Energiekern = 15, Hitzewelle = 0.1, DefendtheFallen = 15, Verse = 15, RC = 15}
local cdtable = {Lavafeld = 60, Kraftausbreitung = 300, ["Befehl zum Angriff"] = 300, ["Wüten"] = 60,["Orchester der Ebenen"] = 120, Wildwuchs = 60, Energiekern = 60, Hitzewelle = 120, DefendtheFallen = 120, Verse = 120, RC = 120}
local buffidtable = {Lavafeld = "B14A2E6D509F79153", Kraftausbreitung = "B2F55F12AF5DA3E23", ["Befehl zum Angriff"] = "BFA7A188CC92D648B", ["Wüten"] = "B0B046904062527A2",["Orchester der Ebenen"] = "BFD9F4FF8303ACEE6", Wildwuchs = "BFB7449C27E891383", Energiekern = "BFB35CEAD13FB09E5", Hitzewelle = "B634F42176219DD88", DefendtheFallen = "B39FB71DBD14135BE", Verse = "BFCEE87FF2B756BCD", RC = "B3BD1851BBB071BF3"}
local texturetable = {Lavafeld = "discombobulate3a.dds", Kraftausbreitung = "humbling_blow_01.dds", ["Befehl zum Angriff"] = "blazeofglory1a.dds", ["Wüten"] = "beastmaster_enraged_companion_01_a.dds",["Orchester der Ebenen"] = "bard_orchestra_of_the_planes.dds", Wildwuchs = "spiritoftree1a.dds", Energiekern = "tactician_power_core_z.dds", Hitzewelle = "redirect1a.dds", DefendtheFallen = "tempest_close_training_z.dds", Verse = "verse_of_joy.dds", RC = "champion_second_wind_a.dds"}
local buffgrouptable = {Lavafeld = 1, ["Orchester der Ebenen"] = 1, Kraftausbreitung = 2, ["Befehl zum Angriff"] = 2, ["Wüten"] = 3, Wildwuchs = 4, Energiekern = 4, DefendtheFallen = 1, Verse = 3, RC = 3}
local buffgroups = {}
for i=1,4 do
buffgroups[i] = {}
end
local now
local configMode = false
local mouseData
local lastcheck = 0
local freezed = false
local infight = {}
local scannedplayers = {}
local noframe

local overwriteLayout, slashHandler, onDeath, onCombat, onReady, mainscan, mainsort, remPlayer, frameHandler, constructFrames, setLayout, frameHitzewelle, onBuffadd, sorting, onCast, onGroupJoin, onGroupLeave, onUpdate, onVariablesLoaded

--localization
local language = Inspect.System.Language()
local rolecast
if language == "English" then
rolecast = "Changing Role"
elseif language == "German" then
rolecast = "Rolle wechseln"
elseif language == "French" then
rolecast = "Changement de rôle"
elseif language == "Russian" then
rolecast = "Смена роли"
end


local uicontext = UI.CreateContext("RCDui")
local rcdAnchor = UI.CreateFrame("Frame", "rcdAnchor", uicontext)
rcdAnchor:SetHeight(25)
rcdAnchor:SetWidth(200)
rcdAnchor:SetBackgroundColor(0,0,0,0.7)
rcdAnchor:SetVisible(false)
rcdAnchor.text = UI.CreateFrame("Text", "Anchorlabel", rcdAnchor)
rcdAnchor.text:SetText("RCD Anchor")
rcdAnchor.text:SetPoint("CENTER", rcdAnchor, "CENTER")
rcdAnchor.text:SetFontColor(1,0,0)
rcdAnchor.text:SetFontSize(15)

local framework = {}
for i=1,5 do
framework[i] = UI.CreateFrame("Frame", "horizontalframework", uicontext)
framework[i]:SetVisible(false)
end
framework[6] = UI.CreateFrame("Frame", "leftframework", uicontext)
framework[6]:SetVisible(false)
framework[6]:SetPoint("TOPRIGHT",framework[1],"TOPLEFT")
framework[6]:SetPoint("BOTTOMRIGHT",framework[5],"BOTTOMLEFT")
framework[7] = UI.CreateFrame("Frame", "rightframework", uicontext)
framework[7]:SetVisible(false)
framework[7]:SetPoint("TOPLEFT",framework[1],"TOPRIGHT")
framework[7]:SetPoint("BOTTOMLEFT",framework[5],"BOTTOMRIGHT")

framework[1]:SetPoint("TOPLEFT",rcdAnchor,"BOTTOMLEFT")
local attachframe = framework[1]

local select_index

local configwin = UI.CreateFrame("SimpleWindow", "Configwindow", uicontext)
configwin:SetCloseButtonVisible(true)
configwin:SetTitle("Raidcooldowns Options")
configwin:SetPoint("CENTER", UIParent, "CENTER")
configwin:SetVisible(false)


configwin.tabs = UI.CreateFrame("SimpleTabView", "optiontabs", configwin)
configwin.tabs:SetPoint("TOPLEFT",configwin:GetContent(),"TOPLEFT",0,0)
configwin.colors = UI.CreateFrame("Frame", "colortab", configwin)
configwin.layout = UI.CreateFrame("Frame", "layouttab", configwin)
configwin.tabs:SetTabPosition("top")
configwin.tabs:AddTab("Colors",configwin.colors)
configwin.tabs:AddTab("Layout",configwin.layout)

configwin.select = UI.CreateFrame("SimpleSelect", "Colorselect", configwin.colors)
configwin.select:SetPoint("TOPLEFT",configwin.colors,"TOPLEFT",20,20)
configwin.select:SetItems({"Bar:Ready","Bar:Activated","Bar:Cooldown","Background","Border","Font","Outline"},{"color_ready","color_activated","color_cd","background_color","border_color","font_color","outline_color"})
configwin.select:SetWidth(210)
configwin.select.Event.ItemSelect = function(item, value, index)
select_index = index
for i=1,4 do
configwin.colorsliders[i]:SetPosition(100*RCD_saved[index][i])
end
end

configwin.colordemo = UI.CreateFrame("Frame", "Colordemo", configwin.colors)
configwin.colordemo:SetPoint("CENTERLEFT", configwin.select, "CENTERRIGHT", 20, 0)
configwin.colordemo:SetHeight(20)
configwin.colordemo:SetWidth(20)
configwin.colordemo:SetBackgroundColor(1,1,1)


configwin.colorsliders = {}
configwin.colorsliders.labels = {}
configwin.colorsliders.labels.text = {"Red:","Green:","Blue:","Alpha:"}
configwin.colorsliders[0] = configwin.select
for i=1,4 do
configwin.colorsliders.labels[i] = UI.CreateFrame("Text", "colorsliderlabel"..i, configwin.colors)
configwin.colorsliders.labels[i]:SetPoint("TOPLEFT", configwin.colorsliders[i-1], "BOTTOMLEFT", 0, 10)
configwin.colorsliders.labels[i]:SetText(configwin.colorsliders.labels.text[i])
configwin.colorsliders[i] = UI.CreateFrame("SimpleSlider", "Colorslider"..i, configwin.colors)
configwin.colorsliders[i]:SetPoint("TOPLEFT", configwin.colorsliders.labels[i], "BOTTOMLEFT", 0, 0)
configwin.colorsliders[i]:SetRange(0,100)
configwin.colorsliders[i].Event.SliderChange = function()
RCD_saved[select_index][i] = configwin.colorsliders[i]:GetPosition() / 100
 configwin.colordemo:SetBackgroundColor(RCD_saved[select_index][1],RCD_saved[select_index][2],RCD_saved[select_index][3],RCD_saved[select_index][4])

end
configwin.colorsliders[i].Event.SliderRelease = function()
overwriteLayout()
end
end


configwin.layoutsliders = {}
configwin.layoutsliders.labels = {}
configwin.layoutsliders.indices = {"frameheight","framewidth","border","font_size","outline_strength"}
configwin.layoutsliders.labels.text = {"Bar Height:","Bar Width:","Border Strength:","Font Size:","Outline Strength:"}
configwin.layoutsliders[0]=configwin.layout
RCD_saved = {}
for i=1,5 do
configwin.layoutsliders.labels[i] = UI.CreateFrame("Text", "layoutsliderlabel"..i, configwin.layout)
configwin.layoutsliders.labels[i]:SetPoint("TOPLEFT", configwin.layoutsliders[i-1], "BOTTOMLEFT", 0, 10)
configwin.layoutsliders.labels[i]:SetText(configwin.layoutsliders.labels.text[i])
configwin.layoutsliders[i] = UI.CreateFrame("SimpleSlider", "LayoutSlider"..i, configwin.layout)
configwin.layoutsliders[i]:SetPoint("TOPLEFT", configwin.layoutsliders.labels[i], "BOTTOMLEFT", 0, 0)
configwin.layoutsliders[i].Event.SliderRelease = function()
overwriteLayout()
end
configwin.layoutsliders[i].Event.SliderChange = function()
--local test = select_index
RCD_saved[configwin.layoutsliders.indices[i]] = configwin.layoutsliders[i]:GetPosition()
end
end
configwin.layoutsliders.labels[1]:SetPoint("TOPLEFT", configwin.layout, "TOPLEFT", 20, 20)
configwin.layoutsliders[1]:SetRange(10,40)
configwin.layoutsliders[2]:SetRange(50,300)
configwin.layoutsliders[3]:SetRange(0,20)
configwin.layoutsliders[4]:SetRange(5,30)
configwin.layoutsliders[5]:SetRange(0,10)
RCD_saved = nil



configwin.tabs:SetPoint("BOTTOMRIGHT",configwin.layoutsliders[5],"BOTTOMRIGHT",20,20)
configwin:SetWidth(configwin.layout:GetWidth()+40)
configwin:SetHeight(configwin.layout:GetHeight()+150)


configwin.reset_button = UI.CreateFrame("RiftButton","reset_button",configwin)
configwin.reset_button:SetPoint("TOPLEFT",configwin.layout,"BOTTOMLEFT", 10, 5)
configwin.reset_button:SetText("DEFAULTS")
configwin.reset_button:EventAttach(Event.UI.Button.Left.Press, function()
RCD_saved = nil
overwriteLayout()
	for i, index in ipairs(configwin.layoutsliders.indices) do
		configwin.layoutsliders[i]:SetPosition(RCD_saved[index])
	end
	for i=1,4 do
	configwin.colorsliders[i]:SetPosition(100*RCD_saved[select_index][i])
	end
end,"ButtonPress")

function overwriteLayout()
onVariablesLoaded(true, "RaidCoolDowns")
for unit, unittable in pairs(frameset) do
	for ability, abtable in pairs(unittable) do
		local heathere
		if ability == "Hitzewelle" then
			local height = RCD_saved.frameheight * 2 / 5
			local restheight = RCD_saved.frameheight - height
			abtable.frames.maintexture:SetHeight(height)
			abtable.frames.maintexture:SetWidth(height)
			abtable.frames.bar:SetHeight(height)
			abtable.frames.bar:SetWidth(RCD_saved.framewidth)
			abtable.frames.bar:SetBackgroundColor(RCD_saved.color_ready[1],RCD_saved.color_ready[2],RCD_saved.color_ready[3],RCD_saved.color_ready[4])
			abtable.frames.maintexture:SetPoint("TOPLEFT",frameset[unit].Lavafeld.frames.maintexture,"TOPLEFT", restheight, restheight)
		unittable.Lavafeld.frames.bar:SetHeight(restheight)
		heathere = true
		else
		setLayout(abtable.frames)
		if heathere then
			unittable.Lavafeld.frames.bar:SetHeight(restheight)
		end
		end
		if abtable.onCD then
			abtable.frames.bar:SetBackgroundColor(RCD_saved.color_cd[1],RCD_saved.color_cd[2],RCD_saved.color_cd[3],RCD_saved.color_cd[4])
		elseif abtable.going then
			abtable.frames.bar:SetBackgroundColor(RCD_saved.color_activated[1],RCD_saved.color_activated[2],RCD_saved.color_activated[3],RCD_saved.color_activated[4])
		end
	end
end
end

local restrictedcontext = UI.CreateContext("restrictedcontext")
restrictedcontext:SetSecureMode("restricted")
local reloadui = UI.CreateFrame("Frame", "reloadui_frame", restrictedcontext)
reloadui:SetBackgroundColor(0,0,0,0.5)
reloadui:SetVisible(false)
reloadui:SetSecureMode("restricted")
reloadui.button = UI.CreateFrame("RiftButton", "reloadui_button", reloadui)
reloadui.button:SetSecureMode("restricted")
reloadui:SetPoint("CENTER", UIParent, "CENTER", 0, -100)
reloadui.button:SetPoint("CENTERLEFT", reloadui, "CENTERLEFT", 5, 0)
reloadui.close = UI.CreateFrame("RiftButton", "reloadui_close", reloadui)
reloadui.close:SetPoint("CENTERRIGHT", reloadui, "CENTERRIGHT", -5, 0)
reloadui:SetHeight(reloadui.button:GetHeight()+10)
reloadui:SetWidth(reloadui.button:GetWidth()+reloadui.close:GetWidth()+10)
reloadui.button.Event.LeftPress = "reloadui"
reloadui.button:SetText("Reload UI (Save)")
reloadui.close:SetText("Close")
reloadui.close:EventAttach(Event.UI.Button.Left.Press, function()
	if not infight[playerid] then
	reloadui:SetVisible(false)
	end
end,"ButtonPress")

configwin.Event.Close = function()
configMode = false
rcdAnchor:SetVisible(false)
if not infight[playerid] then
reloadui:SetVisible(true)
end
end

--Hijacked from TCB
rcdAnchor:EventAttach(Event.UI.Input.Mouse.Left.Down, function(self, h)
		if not configMode then
			return
		end
		self.MouseDown = true
		mouseData = Inspect.Mouse()
		self.sx = mouseData.x - rcdAnchor:GetLeft()
		self.sy = mouseData.y - rcdAnchor:GetTop()
	end, "Event.UI.Input.Mouse.Left.Down")

	rcdAnchor:EventAttach(Event.UI.Input.Mouse.Cursor.Move, function(self, h)
		if not configMode then
			return
		end
		if self.MouseDown then
			local nx, ny
			mouseData = Inspect.Mouse()
			nx = mouseData.x - self.sx
			ny = mouseData.y - self.sy
			rcdAnchor:SetPoint("TOPLEFT", UIParent, "TOPLEFT", nx, ny)
		end
	end, "Event.UI.Input.Mouse.Cursor.Move")

	rcdAnchor:EventAttach(Event.UI.Input.Mouse.Left.Up, function(self, h)
		if not configMode then
			return
		end
		if self.MouseDown then
			self.MouseDown = false
		end
		RCD_saved.position_x = rcdAnchor:GetLeft()
		RCD_saved.position_y = rcdAnchor:GetTop()
	end, "Event.UI.Input.Mouse.Left.Up")

--[[
local menu = UI.CreateFrame("Frame","rightclickmenu",uicontext)
menu.textfollow = UI.CreateFrame("Text","textfollow",menu)
menu.textfollow:SetText("Follow")
--menu.textfollow:SetFontSize(30)
menu:SetPoint("TOPLEFT",UIParent,"TOPLEFT",500,500)
menu:SetBackgroundColor(0,0,0,1)
menu.textfollow:SetPoint("TOPLEFT",menu,"TOPLEFT")
menu:SetPoint("BOTTOMRIGHT",menu.textfollow,"BOTTOMRIGHT")
--menu.textfollow:SetBackgroundColor(1,1,1,1)


local function OnClickOutside()
print("Hey")
end

local catchAllClicks = UI.CreateFrame("Frame", "CatchAllClicks", uicontext)
catchAllClicks:SetLayer(10000)
catchAllClicks:SetVisible(false)
catchAllClicks:SetAllPoints(UIParent)
catchAllClicks.Event.LeftClick = OnClickOutside
catchAllClicks.Event.RightClick = OnClickOutside
--]]

function slashHandler(h, args)
--Hijacked from TCB
	local r = {}
	local numargs = 0
	for token in string.gmatch(args, "[^%s]+") do
		r[numargs] = token
		numargs=numargs+1
	end
if r[0] == "config" then
	for i, index in ipairs(configwin.layoutsliders.indices) do
		configwin.layoutsliders[i]:SetPosition(RCD_saved[index])
	end
	configwin.select:SetSelectedItem("Bar:Ready")
	configwin:SetVisible(true)
		configMode = true
		rcdAnchor:SetVisible(true)
	return
end
if r[0] == "freeze" then
	if freezed then
		freezed = false
		print("Frames unfrozen.")
	else
		freezed = true
		print("Frames frozen.")
	end
	return
end
if r[0] == "scan" then
	mainscan()
	print("Scan completed.")
	return
end
if r[0] == "cleartarget" then
	if scannedplayers[Inspect.Unit.Lookup("player.target")] then
		remPlayer(Inspect.Unit.Lookup("player.target"))
		mainsort()
	end
	return
end
print("/rcd config - brings up options and anchor to move around")
print("/rcd freeze - deactivates automatic scan and clear processes")
print("/rcd scan - manually scans for cooldowns")
print("/rcd cleartarget - removes the target from the scanned cooldowns")
end




local deathcount = 0
local playercount = 0
local archonreset = false

	
function onDeath(h, info)
if scannedplayers[info.target] ~= nil then
deathcount = deathcount + 1
if (not archonreset) and playercount * 0.7 <= deathcount then
	for pos, skill in pairs(buffgroups[2]) do
		skill.cdend = skill.cdend - 180
	end
archonreset = true
end
end	
end

function onCombat(h, units)
for unit, status in pairs(units) do
	if status then
		infight[unit] = true
		if unit == playerid then
		playercount = LibSRM.GroupCount()
		deathcount = 0
		archonreset = false
		end
	else
		infight[unit] = false
	end
end
if freezed or (not LibSRM.Player.Grouped) then return end
if units[playerid] then
mainscan()
end
end

function onReady()
if freezed or (not LibSRM.Player.Grouped) then return end
if (now - lastcheck) > 3 then
mainscan()
end
lastcheck = now
end

function mainscan()
for unit, scanned in pairs(scannedplayers) do
local detail = Inspect.Unit.Detail(unit)
if detail then
if not scanned then
	if detail.calling == "warrior" and detail.role == "support" then
		frameHandler(unit, "Befehl zum Angriff")
		frameHandler(unit, "Wüten")
	elseif detail.calling == "mage" then
	local unitbuffs = Inspect.Buff.List(unit)
	if unitbuffs then
		local details = Inspect.Buff.Detail(unit,unitbuffs)
		local pyrocount = 0
		for buffid, detaillist in pairs(details) do
			if detaillist.type == "BFD6201FA830F9130" then
				frameHandler(unit, "Wildwuchs")
			end
			if detaillist.type == "BFD2977C0CD2F0CAF" then
				frameHandler(unit, "Lavafeld")
				frameHandler(unit, "Kraftausbreitung")
				pyrocount = pyrocount + 1
			end
			if detaillist.type == "BFC4206DF076065D1" then
				pyrocount = pyrocount - 1
			end
			if detaillist.type == "B0D0F09B9F6DD43D1" then
				pyrocount = pyrocount + 1
			end
		end
		if pyrocount == 2 then
			frameHitzewelle(unit)
		end
	end
	elseif detail.calling == "rogue" and detail.role == "support" then
	local tac = false
	local unitbuffs = Inspect.Buff.List(unit)
	if unitbuffs then
		local details = Inspect.Buff.Detail(unit,unitbuffs)
		for buffid, detaillist in pairs(details) do
			if detaillist.type == "B38A21184E782FF9F" then --(Rending Munitions) engines: "BFC7FDE53A8A2A7DA" "BFBA5656FBA91602E"
				frameHandler(unit, "Energiekern")
				tac = true
			end
		end
	end
	if not tac then
		frameHandler(unit, "Orchester der Ebenen")
		frameHandler(unit, "Verse")
	end
	--new cleric
	elseif detail.calling == "cleric" and detail.role == "support" then
		frameHandler(unit, "DefendtheFallen")
		frameHandler(unit, "RC")
	end
elseif detail.calling == "rogue" and detail.role == "support" then
	local unitbuffs = Inspect.Buff.List(unit)
	if unitbuffs then
		local details = Inspect.Buff.Detail(unit,unitbuffs)
		for buffid, detaillist in pairs(details) do
			if detaillist.type == "BFC7FDE53A8A2A7DA" or detaillist.type == "BFBA5656FBA91602E" then
				remPlayer(unit)
				frameHandler(unit, "Energiekern")
			end
		end
	end
end
end
end
mainsort()
end

function mainsort()
framework[1]:SetVisible(false)
for i=2,5 do
	framework[i]:SetVisible(false)
	framework[i]:SetPoint("TOPLEFT",framework[i-1],"TOPLEFT")
end
framework[6]:SetVisible(false)
framework[7]:SetVisible(false)
	lastframe = framework[1]
	for j=1,4 do
	if j == 4 then
		attachframe = lastframe
	end
	for i, frametab in ipairs(buffgroups[j]) do
		frametab.frames.maintexture:SetPoint("TOPLEFT",lastframe,"BOTTOMLEFT")
		lastframe = frametab.frames.maintexture
	end
	if next(buffgroups[j]) then
		framework[j+1]:SetPoint("TOPLEFT",lastframe,"BOTTOMLEFT")
		framework[j+1]:SetVisible(true)
		lastframe = framework[j+1]
	end
	end
noframe = false
if not (lastframe == framework[1]) then --old: rcdAnchor
noframe = true
framework[1]:SetVisible(true)
framework[6]:SetVisible(true)
framework[7]:SetVisible(true)
end
end

function remPlayer(unit)
if frameset[unit] then
	for skill, second in pairs(frameset[unit]) do
		if second.frames.activated then 
		second.frames.maintexture:SetVisible(false)
		second.frames.activated = false
		second.frames.maintexture:SetPoint("TOPLEFT",rcdAnchor,"TOPLEFT")
		local j = false
		if buffgroups[buffgrouptable[skill]] then
		for i, frametab in ipairs(buffgroups[buffgrouptable[skill]]) do
			if second == frametab then
				j = i
			end
		end
		if j then
		table.remove(buffgroups[buffgrouptable[skill]], j)
		else
		print("Error:remPlayer")
		end
		end
		end
	end
	scannedplayers[unit] = false
end
end

function frameHandler(unit, skill)
if not frameset[unit] then
	frameset[unit] = {}
end
	if not frameset[unit][skill] then
		frameset[unit][skill] = {buffbegin = -100, cdbegin = -200, cdend = -200, frames = {}}
		local name = Inspect.Unit.Detail(unit)
		if name then
		constructFrames(frameset[unit][skill].frames,name.name,texturetable[skill])
		else
		constructFrames(frameset[unit][skill].frames,"error",texturetable[skill])
		end
	else
		frameset[unit][skill].frames.maintexture:SetVisible(true)
		frameset[unit][skill].frames.bar:SetHeight(RCD_saved.frameheight)
	end
	

	table.insert(buffgroups[buffgrouptable[skill]], frameset[unit][skill])
	scannedplayers[unit] = true
	frameset[unit][skill].frames.activated = true
	frameset[unit][skill].frames.maintexture:SetPoint("TOPLEFT",rcdAnchor,"BOTTOMLEFT")
end

function constructFrames(frametable, unitname, texture)
frametable.maintexture = UI.CreateFrame("Texture", "skillpic", uicontext)
	frametable.maintexture:SetTexture("Rift",texture)
frametable.background = UI.CreateFrame("Frame", "barbackground", frametable.maintexture)
	frametable.background:SetPoint("TOPLEFT",frametable.maintexture,"TOPRIGHT")
frametable.bar = UI.CreateFrame("Frame", "durationbar", frametable.background)
	frametable.bar:SetPoint("TOPLEFT",frametable.maintexture,"TOPRIGHT")
	frametable.bar:SetLayer(2)
frametable.name = UI.CreateFrame("Text", "nametag", frametable.bar)
	frametable.name:SetText(string.match(unitname, "[^@]+"))
	frametable.name:SetPoint("CENTERLEFT",frametable.maintexture,"CENTERRIGHT")
frametable.counter = UI.CreateFrame("Text", "readyandcounter", frametable.bar)
	frametable.counter:SetText("Ready!")
	frametable.counter:SetPoint("CENTERRIGHT",frametable.background,"CENTERRIGHT", -5,0)
setLayout(frametable)
end

function setLayout(frametable)
	frametable.maintexture:SetHeight(RCD_saved.frameheight)
	frametable.maintexture:SetWidth(RCD_saved.frameheight)
	frametable.background:SetHeight(RCD_saved.frameheight)
	frametable.background:SetWidth(RCD_saved.framewidth)
	frametable.background:SetBackgroundColor(RCD_saved.background_color[1],RCD_saved.background_color[2],RCD_saved.background_color[3],RCD_saved.background_color[4])
	frametable.bar:SetHeight(RCD_saved.frameheight)
	frametable.bar:SetWidth(RCD_saved.framewidth)
	frametable.bar:SetBackgroundColor(RCD_saved.color_ready[1],RCD_saved.color_ready[2],RCD_saved.color_ready[3],RCD_saved.color_ready[4])
	frametable.name:SetEffectGlow({strength = RCD_saved.outline_strength, colorR = RCD_saved.outline_color[1], colorG = RCD_saved.outline_color[2], colorB = RCD_saved.outline_color[3], colorA = RCD_saved.outline_color[4]})
	frametable.name:SetFontSize(RCD_saved.font_size)
	frametable.name:SetFontColor(RCD_saved.font_color[1],RCD_saved.font_color[2],RCD_saved.font_color[3],RCD_saved.font_color[4])
	frametable.counter:SetEffectGlow({strength = RCD_saved.outline_strength, colorR = RCD_saved.outline_color[1], colorG = RCD_saved.outline_color[2], colorB = RCD_saved.outline_color[3], colorA = RCD_saved.outline_color[4]})
	frametable.counter:SetFontSize(RCD_saved.font_size)
	frametable.counter:SetFontColor(RCD_saved.font_color[1],RCD_saved.font_color[2],RCD_saved.font_color[3],RCD_saved.font_color[4])
end



function frameHitzewelle(unit)
local height = RCD_saved.frameheight * 2 / 5
local restheight = RCD_saved.frameheight - height
if not frameset[unit] then
	frameset[unit] = {}
end
if not frameset[unit].Hitzewelle then
	frameset[unit].Hitzewelle = {buffbegin = -100, cdbegin = -200, cdend = -200, frames = {}}
	frameset[unit].Hitzewelle.frames.maintexture = UI.CreateFrame("Texture", "skillpic", frameset[unit].Lavafeld.frames.background)
		frameset[unit].Hitzewelle.frames.maintexture:SetTexture("Rift",texturetable.Hitzewelle)
		frameset[unit].Hitzewelle.frames.maintexture:SetHeight(height)
		frameset[unit].Hitzewelle.frames.maintexture:SetWidth(height)
		frameset[unit].Hitzewelle.frames.maintexture:SetLayer(1)
		
	frameset[unit].Hitzewelle.frames.bar = UI.CreateFrame("Frame", "durationbar", frameset[unit].Hitzewelle.frames.maintexture)
		frameset[unit].Hitzewelle.frames.bar:SetPoint("TOPLEFT",frameset[unit].Hitzewelle.frames.maintexture,"TOPRIGHT") 
		frameset[unit].Hitzewelle.frames.bar:SetHeight(height)
		frameset[unit].Hitzewelle.frames.bar:SetWidth(RCD_saved.framewidth)
		frameset[unit].Hitzewelle.frames.bar:SetBackgroundColor(RCD_saved.color_ready[1],RCD_saved.color_ready[2],RCD_saved.color_ready[3],RCD_saved.color_ready[4])
		
	frameset[unit].Hitzewelle.frames.counter = UI.CreateFrame("Text", "readyandcounter", frameset[unit].Hitzewelle.frames.bar)   --used for onUpdate() not to need an exception
		frameset[unit].Hitzewelle.frames.counter:SetVisible(false)
		--	print("Hitzewelle aufgebaut.")	
else
	frameset[unit].Hitzewelle.frames.maintexture:SetVisible(true)
	--	print("Hitzewelle aktiviert.")
end
	frameset[unit].Hitzewelle.frames.activated = true
	frameset[unit].Lavafeld.frames.bar:SetHeight(restheight)
	frameset[unit].Hitzewelle.frames.maintexture:SetPoint("TOPLEFT",frameset[unit].Lavafeld.frames.maintexture,"TOPLEFT", restheight, restheight)
end

function onBuffadd(h, unit, buffs) --immer nur ein buff
	for buffid, typeid in pairs(buffs) do
		for name, mytypeid in pairs(buffidtable) do
			if typeid == mytypeid then
				local value = Inspect.Buff.Detail(unit, buffid)
				if scannedplayers[value.caster] ~= nil then
				local block = true
				if not(frameset[value.caster] and frameset[value.caster][name] and frameset[value.caster][name].frames.activated) then
				if name == "Hitzewelle" then --Hitzewelle nur nach Lavafeld überschreibbar
				if frameset[value.caster] and frameset[value.caster].Lavafeld and frameset[value.caster].Lavafeld.frames.activated then
				frameHitzewelle(value.caster)
				else
					block = false
				end
				else
				remPlayer(value.caster)
				if name == "Lavafeld" or name == "Kraftausbreitung" then
				frameHandler(value.caster, "Lavafeld")
				frameHandler(value.caster, "Kraftausbreitung")
				elseif name == "Orchester der Ebenen" or name == "Verse" then
					frameHandler(value.caster, "Verse")
					frameHandler(value.caster, "Orchester der Ebenen")
				elseif name == "RC" or name == "DefendTheFallen" then
					frameHandler(value.caster, "DefendTheFallen")
					frameHandler(value.caster, "RC")
				elseif name == "Befehl zum Angriff" or name == "Wüten" then
				frameHandler(value.caster, "Wüten")
				frameHandler(value.caster, "Befehl zum Angriff")
				else
				frameHandler(value.caster, name)
				end
				mainsort()
				end
				end
					if block and now - frameset[value.caster][name].buffbegin > durtable[name] then --exception für Hitzewelle
						frameset[value.caster][name].buffbegin = value.begin or now
						frameset[value.caster][name].buffend = frameset[value.caster][name].buffbegin + durtable[name]
						frameset[value.caster][name].cdbegin = value.begin or now
						if name == "Wildwuchs" then
							frameset[value.caster][name].cdbegin = frameset[value.caster][name].cdbegin - 1.5
						end
						if name == "Lavafeld" then
							frameset[value.caster][name].cdbegin = frameset[value.caster][name].cdbegin - 2
						end
						frameset[value.caster][name].cdend = frameset[value.caster][name].cdbegin + cdtable[name]
						frameset[value.caster][name].going = true
						frameset[value.caster][name].frames.bar:SetBackgroundColor(RCD_saved.color_activated[1],RCD_saved.color_activated[2],RCD_saved.color_activated[3],RCD_saved.color_activated[4])
						if name == "Wildwuchs" or name == "Energiekern" then
						sorting(frameset[value.caster][name],1)
						end
						if name == "Hitzewelle" then
							frameset[value.caster].Lavafeld.cdend = -200
						end
					end
				
				end
			end
		end
	end
end



function sorting(abtable,pos)
local j
	for i, frametab in ipairs(buffgroups[4]) do
		if abtable == frametab then
			j = i
		end
	end
	table.remove(buffgroups[4], j)
	if pos then
	table.insert(buffgroups[4], pos, abtable)
	else
	table.insert(buffgroups[4], abtable)
	end
local lastattach = attachframe
	for i, frametab in ipairs(buffgroups[4]) do
		if frametab.frames.maintexture then
			frametab.frames.maintexture:SetPoint("TOPLEFT",lastattach,"BOTTOMLEFT")
			lastattach = frametab.frames.maintexture
		end
	end
	framework[5]:SetPoint("TOPLEFT",lastattach,"BOTTOMLEFT")
end

function onCast(h, units)
	for unit, cbstatus in pairs(units) do
		if (not infight[unit]) and (scannedplayers[unit] ~= nil) and cbstatus then
			local details = Inspect.Unit.Castbar(unit)
			if details and details.abilityName ==  rolecast then  --Localization
				remPlayer(unit)
				mainsort()
			end
		end
	end
end

function onGroupJoin(h, unit)
scannedplayers[unit] = false
if unit == playerid then
mainscan()
end
end

function onGroupLeave(h, unit)
remPlayer(unit)
scannedplayers[unit] = nil
if noframe then --check if there is still anything to sort
mainsort()
end
end

function onUpdate()
now = Inspect.Time.Frame()
for unit, unittable in pairs(frameset) do
	for ability, abtable in pairs(unittable) do
		if abtable.frames.activated then			--erster check nötig? abtable.buffbegin wegen role?
			if abtable.going then
				local remaining = abtable.buffend - now
				abtable.frames.bar:SetWidth(remaining / durtable[ability] * RCD_saved.framewidth)
				abtable.frames.counter:SetText(string.format("%d",remaining))
				if remaining <= 0 then
					abtable.going = false
					abtable.onCD = true
					abtable.restCD = abtable.cdend - now --restCD
					if ability == "Wildwuchs" or ability == "Energiekern" then
						sorting(abtable)
					end
					abtable.frames.bar:SetBackgroundColor(RCD_saved.color_cd[1],RCD_saved.color_cd[2],RCD_saved.color_cd[3],RCD_saved.color_cd[4])
				end
			elseif abtable.onCD then
				local remaining = abtable.cdend - now
				abtable.frames.bar:SetWidth((1 - remaining / abtable.restCD) * RCD_saved.framewidth) --restCD
				abtable.frames.counter:SetText(string.format("%d",remaining))
				if remaining <= 0 then
					abtable.onCD = false
					abtable.frames.bar:SetBackgroundColor(RCD_saved.color_ready[1],RCD_saved.color_ready[2],RCD_saved.color_ready[3],RCD_saved.color_ready[4])
					abtable.frames.bar:SetWidth(RCD_saved.framewidth)
					abtable.frames.counter:SetText("Ready!")
				end
			end
		end
	end
end
end

function onVariablesLoaded(event, addonname) if addonname ~= "RaidCoolDowns" then return end
RCD_saved = RCD_saved or {position_x = 20, position_y = 500, border = 5, framewidth = 175, frameheight = 25, color_ready = {1,1,0,0.5}, color_cd = {0,0.6,0.7,0.5}, color_activated = {0,0.9,0.1,0.5}, outline_strength = 2, outline_color = {0,0,0,1}, font_color = {1,1,1,1}, font_size = 15, border_color = {0,0,0,0.7}, background_color = {0,0,0,0.3}}
rcdAnchor:SetPoint("TOPLEFT", UIParent, "TOPLEFT",RCD_saved.position_x,RCD_saved.position_y)
for i=1,5 do
framework[i]:SetHeight(RCD_saved.border)
framework[i]:SetWidth(RCD_saved.framewidth + RCD_saved.frameheight)
end
framework[6]:SetWidth(RCD_saved.border)
framework[7]:SetWidth(RCD_saved.border)
for i=1,7 do
framework[i]:SetBackgroundColor(RCD_saved.border_color[1],RCD_saved.border_color[2],RCD_saved.border_color[3],RCD_saved.border_color[4])
end
 end
 
Command.Event.Attach(Event.SafesRaidManager.Group.Join, onGroupJoin, "Event.SafesRaidManager.Group.Join")
Command.Event.Attach(Event.SafesRaidManager.Group.Leave, onGroupLeave, "Event.SafesRaidManager.Group.Leave")
Command.Event.Attach(Event.Buff.Add, onBuffadd, "buffaddevent")
Command.Event.Attach(Event.System.Update.Begin, onUpdate, "refresh")
Command.Event.Attach(Event.Unit.Detail.Combat, onCombat, "combatstart")
Command.Event.Attach(Event.Combat.Death, onDeath, "deathevent")
Command.Event.Attach(Event.Unit.Detail.Ready, onReady, "readycheck")
Command.Event.Attach(Event.Unit.Castbar, onCast, "Event.Unit.Castbar")
Command.Event.Attach(Event.Addon.SavedVariables.Load.End, onVariablesLoaded, "Event.Addon.SavedVariables.Load.End")
Command.Event.Attach(Command.Slash.Register("rcd"), slashHandler, "Command.Slash.Register")
print("loaded. /rcd for commands.")
--[[for n,v in pairs(_G) do 
if not string.find(n, "KBM") then
print(n)
end
 end--]]