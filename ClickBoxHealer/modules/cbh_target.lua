--[[
file: main.lua -- Where all the magic really happens
by: Solsis00
for: ClickBoxHealer Unit Frames addition

This file contains all the core functions that do the real work, including all status changes post frame creation

**COMPLETE: Converted to local cbh table successfully.
]]--

local addon, cbh = ...


--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--					LOAD SETTINGS
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.TargetLoadSettings(x, addonid)
	if addonid == "ClickBoxHealer" then
		cbh.defaults.TargetValues = {
			enabled = true,
			macros = true,

			fx = 1520,
			fy = 900,
			fheight = 55,
			fwidth = 200,
			rbheight = 8,	-- resource bar
			
			texture = "health_1.png",
			texturedup = true,
			fontsize = 12,

			namefontsize = 16,
			namelengthauto = true,
			namelength = 8,
			namelocation = "CENTER",
			nameoffsetx = 0,
			nameoffsety = 0,
			levelsize = 16,
			levellocation = "CENTER",
			leveloffsetx = -50,
			leveloffsety = 0,
			roleshow = true,
			rolesize = 24,
			rolelocation = "TOPLEFT",
			roleoffsetx = 0,
			roleoffsety = 0,
			percentshow = true,
			percentfontsize = 12,
			percentlocation = "BOTTOMCENTER",
			percentoffsetx = 0,
			percentoffsety = 0,
			raidmarksize = 38,
			raidmarklocation = "TOPCENTER",
			raidmarkoffsetx = 0,
			raidmarkoffsety = 0,
			pvpalwaysshow = false,
			pvpmarksize = 16,
			pvpmarklocation = "BOTTOMLEFT",
			pvpmarkoffsetx = 0,
			pvpmarkoffsety = 0,
			tiersize = 24,
			tierlocation = "LEFTCENTER",
			tieroffsetx = -10,
			tieroffsety = 0,
			publiciconsize = 24,
			publiciconlocation = "TOPRIGHT",
			publiciconoffsetx = -20,
			publiciconoffsety = -5,
			
			buffsize = 38,
			buffcount = 6,
			buffreverse = true,
			buffontop = true,
			bufflocation = "BOTTOMLEFT",
			buffattach = "TOPLEFT",
			buffoffsetx = 0,
			buffoffsety = -10,
			
			debuffsize = 38,	--for now this is automated based on frame width
			debuffcount = 6,
			debuffreverse = false,
			debuffontop = false,
			debufflocation = "TOPLEFT",
			debuffattach = "BOTTOMLEFT",
			debuffoffsetx = 0,
			debuffoffsety = 10,
		}
		
		cbh.defaults.TargetColors = {
			[1] = {r = 0, g = 0, b = 0, a = 1, classcolor = false, gradient = false},			-- Health Color
			[2] = {r = 0.75, g = 0, b = 0, a = 1, classcolor = false},		-- Health Backdrop Color
			[3] = {r = 0, g = 0, b = 0.8, a = 1, classcolor = false},		-- Mana Color
			[4] = {r = 1, g = 1, b = 1, a = 1, shadow = true, classcolor = true},	-- Name Color
			[5] = {r = 1, g = 1, b = 1, a = 1, shadow = true, classcolor = false},			-- Percentage Color
		}

		if not cbhTargetValues then
			cbhTargetValues = {}
			cbhTargetValues["Colors"] = {}
		end
		if not cbhTargetValues["Colors"] then
			cbhTargetValues["Colors"] = {}
		end
		for k, v in pairs(cbh.defaults.TargetValues) do
			if cbhTargetValues[k] == nil then
				cbhTargetValues[k] = v
			end
		end
		for k, v in pairs(cbh.defaults.TargetColors) do
			if cbhTargetValues["Colors"][k] == nil then
				cbhTargetValues["Colors"][k] = v
			end
		end
	end
end



--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--				FRAME CREATION
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.TargetCreateFrame()
	cbh.TargetTable = {}
	cbh.TargetBuffTable={}
	cbh.TargetDebuffTable={}

	cbh.TargetWindow = UI.CreateFrame("Frame", "TargetMainWindow", cbh.Context)
	-- cbh.TargetWindow:SetSecureMode("restricted")
	cbh.TargetWindowDrag = UI.CreateFrame("Frame", "TargetDrag", cbh.TargetWindow)
	cbh.TargetClick = UI.CreateFrame("Frame", "TargetFrame", cbh.Context)
	cbh.TargetClick:SetSecureMode("restricted")
	cbh.TargetFrame = UI.CreateFrame("Texture", "TargetFrame", cbh.TargetWindow)
	cbh.TargetHP = UI.CreateFrame("Frame", "TargetHP", cbh.TargetWindow)
	
	cbh.TargetName = UI.CreateFrame("Text", "TargetFrame", cbh.TargetWindow)
	cbh.TargetLevel = UI.CreateFrame("Text", "TargetLevel", cbh.TargetWindow)
	cbh.TargetPercent = UI.CreateFrame("Text", "TargetPercent", cbh.TargetWindow)
	cbh.TargetRole = UI.CreateFrame("Texture", "TargetRole", cbh.TargetWindow)
	cbh.TargetRaidMark = UI.CreateFrame("Texture", "TargetRaidMark", cbh.TargetWindow)
	cbh.TargetTier = UI.CreateFrame("Texture", "TargetTier", cbh.TargetWindow)
	cbh.TargetPublicIcon = UI.CreateFrame("Text", "PublicFrame", cbh.TargetWindow)
	cbh.TargetPublicIconText = UI.CreateFrame("Text", "PublicText", cbh.TargetPublicIcon)
	cbh.TargetPvPMark = UI.CreateFrame("Text", "TargetPVP", cbh.TargetWindow)

	cbh.TargetBuffs={}
	cbh.TargetBuffsCounter={}
	cbh.TargetBuffsStackCounter={}
	for i = 1, cbhTargetValues.buffcount do
		cbh.TargetBuffs[i] = UI.CreateFrame("Texture", "TargetBuffs", cbh.TargetWindow)
		cbh.TargetBuffsCounter[i] = UI.CreateFrame("Text", "TargetBuffsCounter", cbh.TargetWindow)
		cbh.TargetBuffsStackCounter[i] = UI.CreateFrame("Text", "TargetBuffsStackCounter", cbh.TargetWindow)
	end

	cbh.TargetDebuffs={}
	cbh.TargetDebuffsCounter={}
	cbh.TargetDebuffsStackCounter={}
	for i = 1, cbhTargetValues.debuffcount do
		cbh.TargetDebuffs[i] = UI.CreateFrame("Texture", "TargetDebuffs", cbh.TargetWindow)
		cbh.TargetDebuffsCounter[i] = UI.CreateFrame("Text", "TargetDebuffCounter", cbh.TargetWindow)
		cbh.TargetDebuffsStackCounter[i] = UI.CreateFrame("Text", "TargetDebuffsStackCounter", cbh.TargetWindow)
	end
end



--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--					FRAME SETUP
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.TargetFrameSetup()
	if cbhTargetValues.enabled then
		cbh.TargetCreateFrame()

		cbh.TargetWindow:SetPoint("TOPLEFT", cbh.Context, "TOPLEFT", cbhTargetValues.fx, cbhTargetValues.fy)
		cbh.TargetWindow:SetVisible(false)

		-- CREATE "DRAG ORB" FOR MOVING FRAME
		cbh.TargetWindowDrag:SetPoint("TOPLEFT", cbh.TargetWindow, "TOPLEFT", -4, -4)
		-- cbh.TargetWindowDrag:SetTexture("Rift", "AreaQuest_VFX_CenterBursts.png.dds")
		cbh.TargetWindowDrag:SetLayer(9)
		cbh.TargetWindowDrag:SetWidth(cbhTargetValues.fwidth+8)
		cbh.TargetWindowDrag:SetHeight(cbhTargetValues.fheight+cbhTargetValues.rbheight+8)
		cbh.TargetWindowDrag:SetBackgroundColor(1,0,0,.5)
		cbh.TargetWindowDrag:SetVisible(false)

		
		-- ALLOWS DRAGGING OF FRAME AND REPOSITIONING WHEN FRAME ISN'T LOCKED
		cbh.TargetWindowDrag:EventAttach(Event.UI.Input.Mouse.Left.Down, function(self, h)
			self.windowdragActive = true
			local mouseStatus = Inspect.Mouse()
			self.oldx = mouseStatus.x - cbhTargetValues.fx
			self.oldy = mouseStatus.y - cbhTargetValues.fy
		end, "Event.UI.Input.Mouse.LeftDown")

		
		--CHANGE SAVED FRAMENUMBERIABLES WHEN MOUSE IS MOVED WHILE DRAGGING ACTIVE
		cbh.TargetWindowDrag:EventAttach(Event.UI.Input.Mouse.Cursor.Move, function(self, h)
			if self.windowdragActive == true then
				self.moved = true
				local mouseStatus = Inspect.Mouse()
				cbhTargetValues.fx = mouseStatus.x - self.oldx
				cbhTargetValues.fy = mouseStatus.y - self.oldy
				cbh.TargetWindow:SetPoint("TOPLEFT", cbh.Context, "TOPLEFT", cbhTargetValues.fx, cbhTargetValues.fy)
			end
		end, "Event.UI.Input.Mouse.Cursor.Move")

		
		-- ENDS DRAGGING WHEN LEFT CLICK RELEASED
		cbh.TargetWindowDrag:EventAttach(Event.UI.Input.Mouse.Left.Up, function(self, h)
			self.windowdragActive = false
		end, "Event.UI.Input.Mouse.LeftUp")

		cbh.TargetWindowDrag:EventAttach(Event.UI.Input.Mouse.Left.Upoutside, function(self, h)
			self.windowdragActive = false
		end, "Event.UI.Input.Mouse.Left.Upoutside")

		
		-- LOCKS FRAME IF RIGHT CLICKED
		cbh.TargetWindowDrag:EventAttach(Event.UI.Input.Mouse.Right.Click, function(self, h)
			cbh.FrameLocked()
		end, "Event.UI.Input.Mouse.Right.Click")

		
		-- TARGET CLICK FRAME
		cbh.TargetClick:SetPoint("TOPLEFT", cbh.TargetWindow, "TOPLEFT", 0, 0)
		cbh.TargetClick:SetWidth(cbhTargetValues.fwidth)
		cbh.TargetClick:SetHeight(cbhTargetValues.fheight)
		cbh.TargetClick:SetBackgroundColor(0,0,0,0.05)

		
		-- HEALTH FRAME
		cbh.TargetFrame:SetPoint("TOPLEFT", cbh.TargetWindow, "TOPLEFT", 0, 0)
		if cbhTargetValues.texturedup then
			cbh.TargetFrame:SetTexture("ClickBoxHealer", "Textures/"..cbhPlayerValues.texture)
		else
			cbh.TargetFrame:SetTexture("ClickBoxHealer", "Textures/"..cbhTargetValues.texture)
		end
		cbh.TargetFrame:SetWidth(cbhTargetValues.fwidth)
		cbh.TargetFrame:SetHeight(cbhTargetValues.fheight)
		cbh.TargetFrame:SetLayer(0)
		cbh.TargetFrame:SetBackgroundColor(cbhTargetValues["Colors"][1].r, cbhTargetValues["Colors"][1].g, cbhTargetValues["Colors"][1].b, cbhTargetValues["Colors"][1].a)

		cbh.TargetHP:SetPoint("TOPRIGHT", cbh.TargetFrame, "TOPRIGHT", 0, 0)
		cbh.TargetHP:SetWidth(0)
		cbh.TargetHP:SetHeight(cbhTargetValues.fheight)
		cbh.TargetHP:SetBackgroundColor(cbhTargetValues["Colors"][2].r, cbhTargetValues["Colors"][2].g, cbhTargetValues["Colors"][2].b, cbhTargetValues["Colors"][2].a)
		cbh.TargetHP:SetLayer(1)


		-- NAME
		cbh.TargetName:SetPoint(cbhTargetValues.namelocation, cbh.TargetFrame, cbhTargetValues.namelocation, cbhTargetValues.nameoffsetx, cbhTargetValues.nameoffsety)
		cbh.TargetName:SetLayer(2)
		cbh.TargetName:SetFontSize(cbhTargetValues.namefontsize)
		cbh.TargetName:SetEffectGlow(cbh.NameGlowTable)
		if cbhTargetValues["Colors"][4].shadow then cbh.TargetName:SetEffectGlow(cbh.NameGlowTable) end
		cbh.TargetName:SetFontColor(cbhTargetValues["Colors"][4].r, cbhTargetValues["Colors"][4].g, cbhTargetValues["Colors"][4].b, cbhTargetValues["Colors"][4].a)

		-- LEVEL
		cbh.TargetLevel:SetPoint(cbhTargetValues.levellocation, cbh.TargetFrame, cbhTargetValues.levellocation, cbhTargetValues.leveloffsetx, cbhTargetValues.leveloffsety)
		cbh.TargetLevel:SetLayer(3)
		cbh.TargetLevel:SetFontSize(cbhTargetValues.levelsize)
		if cbhTargetValues["Colors"][4].shadow then cbh.TargetLevel:SetEffectGlow(cbh.NameGlowTable) end
		cbh.TargetLevel:SetFontColor(cbhTargetValues["Colors"][4].r, cbhTargetValues["Colors"][4].g, cbhTargetValues["Colors"][4].b, cbhTargetValues["Colors"][4].a)

		
		-- TIER DIFFICULTY INDICATOR
		cbh.TargetTier:SetPoint(cbhTargetValues.tierlocation, cbh.TargetFrame, cbhTargetValues.tierlocation, cbhTargetValues.tieroffsetx, cbhTargetValues.tieroffsety)
		cbh.TargetTier:SetLayer(2)
		cbh.TargetTier:SetWidth(cbhTargetValues.tiersize)
		cbh.TargetTier:SetHeight(cbhTargetValues.tiersize)
		cbh.TargetTier:SetVisible(false)
		
		
		-- HEALTH PERCENT
		cbh.TargetPercent:SetPoint(cbhTargetValues.percentlocation, cbh.TargetFrame, cbhTargetValues.percentlocation, cbhTargetValues.percentoffsetx, cbhTargetValues.percentoffsety)
		cbh.TargetPercent:SetLayer(2)
		cbh.TargetPercent:SetFontSize(cbhTargetValues.percentfontsize)
		cbh.TargetPercent:SetEffectGlow(cbh.NameGlowTable)

		
		-- DUNGEON ROLE
		cbh.TargetRole:SetPoint(cbhTargetValues.rolelocation, cbh.TargetFrame, cbhTargetValues.rolelocation, cbhTargetValues.roleoffsetx, cbhTargetValues.roleoffsety)
		cbh.TargetRole:SetLayer(2)
		cbh.TargetRole:SetWidth(cbhTargetValues.rolesize)
		cbh.TargetRole:SetHeight(cbhTargetValues.rolesize)

		
		-- RAID MARK
		cbh.TargetRaidMark:SetPoint(cbhTargetValues.raidmarklocation, cbh.TargetFrame, cbhTargetValues.raidmarklocation, cbhTargetValues.raidmarkoffsetx, cbhTargetValues.raidmarkoffsety)
		cbh.TargetRaidMark:SetLayer(2)
		cbh.TargetRaidMark:SetVisible(false)
		cbh.TargetRaidMark:SetWidth(cbhTargetValues.raidmarksize)
		cbh.TargetRaidMark:SetHeight(cbhTargetValues.raidmarksize)
		
		
		-- PUBLIC GROUP INDICATOR
		-- cbh.TargetPublicIcon:SetPoint(cbhTargetValues.publiciconlocation, cbh.TargetFrame, cbhTargetValues.publiciconlocation, -(cbh.TargetFrame:GetWidth()*0.10), -5)
		cbh.TargetPublicIcon:SetPoint(cbhTargetValues.publiciconlocation, cbh.TargetFrame, cbhTargetValues.publiciconlocation, cbhTargetValues.publiciconoffsetx, cbhTargetValues.publiciconoffsety)
		cbh.TargetPublicIcon:SetLayer(2)
		cbh.TargetPublicIcon:SetWidth(cbhTargetValues.publiciconsize)
		cbh.TargetPublicIcon:SetHeight(cbhTargetValues.publiciconsize)
		cbh.TargetPublicIcon:SetBackgroundColor(0,0,0,.75)
		cbh.TargetPublicIcon:SetVisible(false)
		
		cbh.TargetPublicIconText:SetPoint("CENTER", cbh.TargetPublicIcon, "CENTER", 0, -2)
		cbh.TargetPublicIconText:SetFontSize(cbhTargetValues.publiciconsize)
		cbh.TargetPublicIconText:SetText("+")


		-- PVP
		cbh.TargetPvPMark:SetPoint(cbhTargetValues.pvpmarklocation, cbh.TargetFrame, cbhTargetValues.pvpmarklocation, cbhTargetValues.pvpmarkoffsetx, cbhTargetValues.pvpmarkoffsety)
		cbh.TargetPvPMark:SetLayer(3)
		cbh.TargetPvPMark:SetFontSize(cbhTargetValues.pvpmarksize)
		cbh.TargetPvPMark:SetEffectGlow(cbh.NameGlowTable)
		cbh.TargetPvPMark:SetFontColor(1,0,0,1)
		cbh.TargetPvPMark:SetText("> PvP <")
		cbh.TargetPvPMark:SetAlpha(0)


		-- BUFF BOXES
		-- calculates the size based on the number of buffs requested  to fit the width of the frame
		local tbuffsize = (cbhTargetValues.fwidth/cbhTargetValues.buffcount)-(4*cbhTargetValues.buffcount/cbhTargetValues.buffcount)
		local bufftempx = 0
		for i = 1, cbhTargetValues.buffcount do
			cbh.TargetBuffs[i]:SetPoint(cbhTargetValues.bufflocation, cbh.TargetFrame, cbhTargetValues.buffattach, bufftempx, cbhTargetValues.buffoffsety)
			cbh.TargetBuffs[i]:SetLayer(2)
			cbh.TargetBuffs[i]:SetWidth(tbuffsize)
			cbh.TargetBuffs[i]:SetHeight(tbuffsize)
			bufftempx = (tbuffsize+5)*i
			if cbhTargetValues.buffreverse then bufftempx = -(bufftempx) end
			cbh.TargetBuffsCounter[i]:SetPoint("BOTTOMCENTER", cbh.TargetBuffs[i], "BOTTOMCENTER", 0, 0)
			cbh.TargetBuffsCounter[i]:SetFontSize(16)
			cbh.TargetBuffsCounter[i]:SetFontColor(1,1,1,1)
			cbh.TargetBuffsCounter[i]:SetEffectGlow(cbh.NameGlowTable)
			cbh.TargetBuffsCounter[i]:SetLayer(6)
			cbh.TargetBuffsStackCounter[i]:SetPoint("TOPRIGHT", cbh.TargetBuffs[i], "TOPRIGHT", 0, -2)
			cbh.TargetBuffsStackCounter[i]:SetFontSize(16)
			cbh.TargetBuffsStackCounter[i]:SetFontColor(1,1,1,1)
			cbh.TargetBuffsStackCounter[i]:SetEffectGlow(cbh.NameGlowTable)
			cbh.TargetBuffsStackCounter[i]:SetLayer(6)
		end
		
		
		-- DEBUFF BOXES
		-- calculates the size based on the number of debuffs requested  to fit the width of the frame
		local tdebuffsize = (cbhTargetValues.fwidth/cbhTargetValues.debuffcount)-(4*cbhTargetValues.debuffcount/cbhTargetValues.debuffcount)
		local debufftempx = 0
		for i = 1, cbhTargetValues.debuffcount do
			cbh.TargetDebuffs[i]:SetPoint(cbhTargetValues.debufflocation, cbh.TargetFrame, cbhTargetValues.debuffattach, debufftempx, cbhTargetValues.debuffoffsety)
			cbh.TargetDebuffs[i]:SetLayer(2)
			cbh.TargetDebuffs[i]:SetWidth(tdebuffsize)
			cbh.TargetDebuffs[i]:SetHeight(tdebuffsize)
			debufftempx = (tdebuffsize+5)*i
			cbh.TargetDebuffsCounter[i]:SetPoint("BOTTOMCENTER", cbh.TargetDebuffs[i], "BOTTOMCENTER", 0, 0)
			cbh.TargetDebuffsCounter[i]:SetFontSize(16)
			cbh.TargetDebuffsCounter[i]:SetFontColor(1,1,1,1)
			cbh.TargetDebuffsCounter[i]:SetEffectGlow(cbh.NameGlowTable)
			cbh.TargetDebuffsCounter[i]:SetLayer(6)
			cbh.TargetDebuffsStackCounter[i]:SetPoint("TOPRIGHT", cbh.TargetDebuffs[i], "TOPRIGHT", 0, -2)
			cbh.TargetDebuffsStackCounter[i]:SetFontSize(16)
			cbh.TargetDebuffsStackCounter[i]:SetFontColor(1,1,1,1)
			cbh.TargetDebuffsStackCounter[i]:SetEffectGlow(cbh.NameGlowTable)
			cbh.TargetDebuffsStackCounter[i]:SetLayer(6)
		end
		
		-- cbh.TargetClick:EventAttach(Event.UI.Input.Mouse.Right.Down, function(self, h)
			-- if cbh.unitLookup("player.target") then cbh.ContextMenu("player.target") end
		-- end, "Event.UI.Input.Mouse.Right.Down")

		cbh.TargetFrame:EventAttach(Event.UI.Input.Mouse.Right.Down, function(self, h)
			cbh.ContextMenu("player.target")
		end, "Event.UI.Input.Mouse.Right.Down")
		
		cbh.TargetLoaded = true
	end
end



--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--					FRAME VALUES
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.TargetUnitChange(units)
	if cbhTargetValues.enabled and cbh.TargetLoaded then
		cbh.TargetWindow:SetVisible(false)
		cbh.UnitStatus["target"] = nil
		cbh.targetinfo = nil
		-- cbh.TargetBuffTable[units] = nil
		-- cbh.TargetDebuffTable[units] = nil
		if cbh.TargetBuffTable[units] then cbh.TargetBuffTable[units] = nil end
		if cbh.TargetDebuffTable[units] then cbh.TargetDebuffTable[units] = nil end
		if units and cbhTargetValues.enabled then --and not cbh.UnitStatus[units].istarget then
			cbh.TargetWindow:SetVisible(true)
			cbh.GetTargetInfo(units)
		end
	end
	if units then
		if cbhPlayerValues.enabled and cbhPlayerValues.fadeooc then cbh.PlayerWindow:SetAlpha(1) end
	else
		if cbhPlayerValues.enabled and cbhPlayerValues.fadeooc and not cbhValues.isincombat then cbh.PlayerWindow:SetAlpha(0.1) end
	end
end

function cbh.GetTargetInfo(uid)
	local tid = cbh.unitDetail(uid)
	cbh.targetinfo = cbh.unitDetail(uid)

	cbh.targetinfo.buffcount = 0
	cbh.targetinfo.haswhitedebuff = nil
	cbh.targetinfo.whitedebuffqty = 0
	cbh.targetinfo.poisonqty = 0
	cbh.targetinfo.curseqty = 0
	cbh.targetinfo.diseaseqty = 0
	cbh.targetinfo.debuffcount = 0
	cbh.targetinfo.hasdebuffs = false
	cbh.targetinfo.hasburnout = false

	if tid then
		cbh.UnitStatus["target"] = {
			id = tid.id,
			name = tid.name,

			level = tid.level,
			tier = tid.tier,
			role = tid.role,
			calling = tid.calling,
			raidmark = tid.mark,

			aggro = tid.aggro,
			offline = tid.offline,
			dead = nil,
			los = nil,	-- tid.blocked
			outofrange = nil,
			warfront = nil,
			public = tid.publicSize,

			xcoord = tid.coordX,
			ycoord = tid.coordY,
			health = tid.health,
			healthmax = tid.healthMax,
			healthcap = tid.healthCap,
			mana = tid.mana,
			manamax = tid.manaMax,

			buffcount = 0,
			haswhitedebuff = nil,
			whitedebuffqty = 0,
			poisonqty = 0,
			curseqty = 0,
			diseaseqty = 0,
			debuffcount = 0,
			hasdebuffs = false,
			hasburnout = false,
		}

		-- cbh.nameCalc(tid.name, nil, "target")

		-- if tid.role then
			-- cbh.TargetRole:SetVisible(true)
			-- cbh.TargetRole:SetTexture("Rift", cbh.RoleImgs[tid.role])
		-- else cbh.TargetRole:SetVisible(false) end

		-- if tid.mark then
			-- cbh.TargetRaidMark:SetVisible(true)
			-- cbh.TargetRaidMark:SetTexture("Rift", cbh.RaidMarkerImages[tid.mark])
		-- else cbh.TargetRaidMark:SetVisible(false) end

		cbh.TargetName:SetText(cbh.targetinfo.name)
		cbh.TargetLevel:SetText(tostring(cbh.targetinfo.level))
		cbh.nameCalc(cbh.targetinfo.name, nil, "target")
		
		if cbh.targetinfo.role then
			cbh.TargetRole:SetVisible(cbhTargetValues.roleshow)
			if cbhTargetValues.roleshow then cbh.TargetRole:SetTexture("Rift", cbh.RoleImgs[cbh.targetinfo.role]) end
		else cbh.TargetRole:SetVisible(false) end

		if cbh.targetinfo.mark then
			cbh.TargetRaidMark:SetVisible(true)
			cbh.TargetRaidMark:SetTexture("Rift", cbh.RaidMarkerImages[cbh.targetinfo.mark])
		else cbh.TargetRaidMark:SetVisible(false) end

		if tid.relation == "friendly" and tid.calling then
			if cbhTargetValues["Colors"][4].classcolor then
				-- for i = 1, 4 do
					-- if tid.calling == cbh.Calling[i] then
						-- cbh.TargetName:SetFontColor(cbhCallingColors[i].r, cbhCallingColors[i].g, cbhCallingColors[i].b, 1)
						cbh.TargetName:SetFontColor(cbh.ClassColors[cbh.targetinfo.calling].r, cbh.ClassColors[cbh.targetinfo.calling].g, cbh.ClassColors[cbh.targetinfo.calling].b, cbhTargetValues["Colors"][4].a)
					-- end
				-- end
				else
					cbh.TargetName:SetFontColor(cbh.ClassColors[cbh.targetinfo.calling].r, cbh.ClassColors[cbh.targetinfo.calling].g, cbh.ClassColors[cbh.targetinfo.calling].b, cbhTargetValues["Colors"][4].a)
				end
			-- else
				-- cbh.TargetName:SetFontColor(.1, .5, 1)
			-- end
		elseif tid.relation == "hostile" then
			cbh.TargetName:SetFontColor(.8, .2, 0)
		else
			cbh.TargetName:SetFontColor(.8, .8, 0)
		end

		if tid.tier then
			-- only picks up group elites, raid mobs, bosses. This does not catch rares.
			cbh.TargetTier:SetVisible(true)
			cbh.TargetTier:SetTexture("ClickBoxHealer", "textures/tier_"..tid.tier..".png")
		else
			cbh.TargetTier:SetVisible(false)
		end

		for i = 1, cbhTargetValues.debuffcount do
			cbh.TargetDebuffs[i]:SetVisible(false)
			cbh.TargetDebuffsCounter[i]:SetVisible(false)
		end
		
		if tid.publicSize then
			cbh.TargetPublicIcon:SetVisible(true)
		else
			cbh.TargetPublicIcon:SetVisible(false)
		end
		
		-- cbh.TargetClick:SetMouseoverUnit(cbh.targetinfo.id)

		-- if cbh.targetinfo.pvp and cbhTargetValues.pvpalwaysshow then cbh.TargetPvPMark:SetAlpha(1) end
		
		local tbufflist = cbh.buffList(tid.id)
		cbh.TargetBuffAdding(x, tid.id, tbufflist)

		local tdebufflist = cbh.buffList(tid.id)
		cbh.TargetDebuffAdding(x, tid.id, tdebufflist)

		local temptid = { [tid.id] = tid.health }
		cbh.UpdateTargetHP(x, temptid)
	end
end


--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--				FRAME UPDATE HP
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.UpdateTargetHP(x, units)
	if cbhTargetValues.enabled and cbh.UnitStatus["target"] and units[cbh.UnitStatus["target"].id] then
		cbh.UnitStatus["target"].health = units[cbh.UnitStatus["target"].id]
			local healthcalc = (cbh.UnitStatus["target"].health / cbh.UnitStatus["target"].healthmax)
			local healthtick = (-healthcalc * cbhTargetValues.fwidth)
			if healthtick < cbhTargetValues.fwidth then healthtick = healthtick + cbhTargetValues.fwidth end
			cbh.TargetHP:SetWidth(healthtick)
			-- if cbhTargetValues.healthgradient then
				if cbhValues.debuffcolorwhole == false or cbh.UnitStatus["target"].hasdebuffs == false then
					if healthcalc < .3 then
						cbh.TargetFrame:SetBackgroundColor(1, 0, 0, cbhCallingColors[7].a)
					elseif healthcalc < .65 then
						cbh.TargetFrame:SetBackgroundColor(1, 1, 0, cbhCallingColors[7].a)
					else cbh.TargetFrame:SetBackgroundColor(cbhCallingColors[7].r, cbhCallingColors[7].g, cbhCallingColors[7].b, cbhCallingColors[7].a) end
				end
			-- end
			if cbhTargetValues.hidehealth == false then
				local health = 0
				local healthpercent = math.ceil(healthcalc * 100)
				if cbh.UnitStatus["target"].health >= 1000000 then
					health = cbh.round((cbh.UnitStatus["target"].health/1000000), 1)
					health = tostring(health).."m"
					cbh.TargetPercent:SetText(health.."  "..healthpercent.."%")
				elseif cbh.UnitStatus["target"].health >= 1000 then
					health = cbh.round((cbh.UnitStatus["target"].health/1000), 1)
					health = tostring(health).."k"
					cbh.TargetPercent:SetText(health.."  "..healthpercent.."%")
				elseif cbh.UnitStatus["target"].health < 1000 and cbh.UnitStatus["target"].health > 0 then
					health = cbh.round(cbh.UnitStatus["target"].health, 0)
					health = tostring(health)
					cbh.TargetPercent:SetText(health.."  "..healthpercent.."%")
				elseif cbh.UnitStatus["target"].health <= 0 or math.ceil(healthcalc) == 0 then
					cbh.TargetPercent:SetText("DEAD")
					cbh.UnitStatus["target"].dead = true
				end
			end
		-- end
	-- end
	end
end


function cbh.UpdateTargetHPMax(hEvent, units)
	if cbhTargetValues.enabled and cbh.UnitStatus["target"] and units[cbh.UnitStatus["target"].id] then
		local tvalue = units[cbh.UnitStatus["target"].id]
		cbh.UnitStatus["target"].healthmax = tvalue
		local tempid = {[cbh.UnitStatus["target"].id] = cbh.UnitStatus["target"].health}
		cbh.UpdateTargetHP(x, tempid)
	end
end


function cbh.UpdateTargetHPCap(bEvent, units)

end


function cbh.TargetMentoredUpdate(hEvent, units)
-- just send this back through the change target function
end


--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--		TARGET FRAME UPDATE MANA
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.UpdateTargetMB(hEvent, units)

end



function cbh.UpdateTargetMBMax(hEvent, units)

end



--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--			FRAME UPDATE PVP
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.TargetUpdatePVP(hEvent, units)
	if cbhTargetValues.enabled and units[cbh.targetinfo.id] ~= nil then
		local tvalue = units[cbh.targetinfo.id]
		cbh.targetinfo.pvp = tvalue
		if cbh.targetinfo.pvp and cbhTargetValues.pvpalwaysshow then
			cbh.TargetPvPMark:SetAlpha(1)
		else
			cbh.TargetPvPMark:SetAlpha(0)
		end
	end
end


function cbh.TargetaggroUpdate(hEvent, units)

end



function cbh.TargetOnlineStatusUpdate(hEvent, units)

end


-- Triggered when absorption value on a unit changes
function cbh.TargetAbsorbUpdate(hEvents, units)

end


--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--		FRAME UPDATE RAID MARK
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.TargetRaidMarkUpdate(hEvent, units)
	if cbhTargetValues.enabled and cbh.UnitStatus["target"] and units[cbh.UnitStatus["target"].id] ~= nil then
		if units[cbh.UnitStatus["target"].id] ~= false then
			local tvalue = units[cbh.UnitStatus["target"].id]
			cbh.TargetRaidMark:SetVisible(true)
			cbh.TargetRaidMark:SetTexture("Rift", cbh.RaidMarkerImages[tvalue])
		else
			cbh.TargetRaidMark:SetVisible(false)
		end
	end
end


-- Updates group role changes based on current spec unless in a dungeon
function cbh.TargetRoleCheck(hEvent, units)
	if cbhTargetValues.enabled and cbh.UnitStatus["target"] and units[cbh.UnitStatus["target"].id] ~= nil then
		if units[cbh.UnitStatus["target"].id] ~= false then
			local tvalue = units[cbh.UnitStatus["target"].id]
			cbh.targetinfo.role = tvalue
			cbh.TargetRole:SetVisible(cbhTargetValues.roleshow)
			if cbhTargetValues.roleshow then cbh.TargetRole:SetTexture("Rift", cbh.RoleImgs[cbh.targetinfo.role]) end
		end
	end
end


--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--				FRAME DEBUFF ADD
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.TargetDebuffAdding(hEvent, unit, buffs)
	if cbhTargetValues.enabled and cbh.UnitStatus["target"] and unit == cbh.UnitStatus["target"].id then
		if not cbh.TargetDebuffTable[unit] then 
			cbh.TargetDebuffTable[unit] = {}
		end
		if buffs ~= nil then
			for k in pairs(buffs) do
				local buffinfo = cbh.buffDetail(unit, k)
				if  buffinfo.caster == cbh.playerinfo.id and buffinfo.debuff then
					-- cbh.UnitStatus["target"].debuffcount = cbh.UnitStatus["target"].debuffcount + 1
					-- table.insert(cbh.TargetDebuffTable[unit], buffinfo)
					cbh.TargetDebuffTable[unit][buffinfo.id] = buffinfo
				end
			end
			local tbcount = 0
			for i, v in pairs(cbh.TargetDebuffTable[unit]) do
				tbcount = tbcount + 1
				v.slot = tbcount
				-- if v.slot ~= v.oldslot or v.oldslot == nil then
				if tbcount <= cbhTargetValues.debuffcount and (v.slot ~= v.oldslot or v.oldslot == nil) then
					cbh.TargetDebuffs[tbcount]:SetTexture("Rift", v.icon)
					cbh.TargetDebuffs[tbcount]:SetVisible(true)
					cbh.TargetDebuffsCounter[tbcount]:SetVisible(true)
					cbh.TargetDebuffs[tbcount]:SetAlpha(1)
					cbh.TargetDebuffsCounter[tbcount]:SetAlpha(1)
					v.oldslot = v.slot
					if v.stack then
						cbh.TargetDebuffsStackCounter[tbcount]:SetVisible(true)
						cbh.TargetDebuffsStackCounter[tbcount]:SetAlpha(1)
						cbh.TargetDebuffsStackCounter[tbcount]:SetText(tostring(v.stack))
					else
						cbh.TargetDebuffsStackCounter[tbcount]:SetVisible(false)
					end
				end
			end
			cbh.UnitStatus["target"].debuffcount = tbcount
			if cbh.UnitStatus["target"].debuffcount < cbhTargetValues.debuffcount then
				-- print("DEBUFF CLEANUP")
				for i = cbhTargetValues.debuffcount, cbh.UnitStatus["target"].debuffcount + 1, -1 do
					cbh.TargetDebuffs[i]:SetVisible(false)
					cbh.TargetDebuffsCounter[i]:SetVisible(false)
					cbh.TargetDebuffsStackCounter[i]:SetVisible(false)
				end
			end
		end
	end
end


--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--			FRAME DEBUFF REMOVE
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.TargetDebuffRemoving(hEvent, unit, buffs)
	if cbhTargetValues.enabled and cbh.UnitStatus["target"] and unit == cbh.UnitStatus["target"].id then
		for k, v in pairs(cbh.TargetDebuffTable[unit]) do
			if buffs[v.id] then
				-- table.remove(cbh.TargetDebuffTable[unit], v.slot)
				-- cbh.UnitStatus["target"].debuffcount = cbh.UnitStatus["target"].debuffcount - 1
				cbh.TargetDebuffTable[unit][v.id] = nil
			end
		end
		if cbh.UnitStatus["target"].debuffcount == 0 then
			for i = 1, cbhTargetValues.debuffcount do
				cbh.TargetDebuffs[i]:SetVisible(false)
				cbh.TargetDebuffsCounter[i]:SetVisible(false)
			end
		else
			local tbcount = 0
			for i, v in pairs(cbh.TargetDebuffTable[unit]) do
				tbcount = tbcount + 1
				v.slot = tbcount
				-- if v.slot ~= v.oldslot or v.oldslot == nil then
				if tbcount <= cbhTargetValues.debuffcount and (v.slot ~= v.oldslot or v.oldslot == nil) then
					cbh.TargetDebuffs[tbcount]:SetTexture("Rift", v.icon)
					cbh.TargetDebuffs[tbcount]:SetVisible(true)
					cbh.TargetDebuffsCounter[tbcount]:SetVisible(true)
					cbh.TargetDebuffs[tbcount]:SetAlpha(1)
					cbh.TargetDebuffsCounter[tbcount]:SetAlpha(1)
					v.oldslot = v.slot
					if v.stack then
						cbh.TargetDebuffsStackCounter[tbcount]:SetVisible(true)
						cbh.TargetDebuffsStackCounter[tbcount]:SetAlpha(1)
						cbh.TargetDebuffsStackCounter[tbcount]:SetText(tostring(v.stack))
					else
						cbh.TargetDebuffsStackCounter[tbcount]:SetVisible(false)
					end
				end
			end
			cbh.UnitStatus["target"].debuffcount = tbcount
			if cbh.UnitStatus["target"].debuffcount < cbhTargetValues.debuffcount then
				for i = cbhTargetValues.debuffcount, cbh.UnitStatus["target"].debuffcount + 1, -1 do
					cbh.TargetDebuffs[i]:SetVisible(false)
					cbh.TargetDebuffsCounter[i]:SetVisible(false)
					cbh.TargetDebuffsStackCounter[i]:SetVisible(false)
				end
			end
		end
	end
end


local timeFrame = _G.Inspect.Time.Frame
local lastUnitUpdate = 0

function cbh.TargetDebuffThrottle(throttle)
	local now = timeFrame()
	local elapsed = now - lastUnitUpdate
	if (elapsed >= throttle) then
		lastUnitUpdate = now
		return true
	end
end

--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--				DEBUFF MONITOR
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.TargetDebuffWatch(hEvent)
	if cbhTargetValues.enabled and cbh.UnitStatus["target"] and cbh.UnitStatus["target"].debuffcount > 0 then
		local timer = cbh.TargetDebuffThrottle(0.5)
		if not timer then return end
		
		local tid = cbh.UnitStatus["target"].id
		-- local tempdebuffcount = 0
		for k, v in pairs(cbh.TargetDebuffTable[tid]) do
			if k and v and v.duration and v.begin then
				-- tempdebuffcount = tempdebuffcount + 1
				if v.slot and v.slot <= cbhTargetValues.debuffcount then
					-- if v.slot ~= v.oldslot then
						-- cbh.TargetDebuffs[v.slot]:SetTexture("Rift", v.icon)
						-- cbh.TargetDebuffs[v.slot]:SetVisible(true)
						-- cbh.TargetDebuffsCounter[v.slot]:SetVisible(true)
						-- v.visible = true
						-- v.oldslot = v.slot
						-- cbh.TargetDebuffs[v.slot]:SetAlpha(1)
						-- cbh.TargetDebuffsCounter[v.slot]:SetAlpha(1)
					-- end
					v.remaining = v.duration - (timeFrame() - v.begin)
					if v.remaining > 60 then
						v.remaining = cbh.mceil(v.remaining/60)
						cbh.TargetDebuffsCounter[v.slot]:SetText(cbh.makestring(v.remaining).."m")
					else
						v.remaining = cbh.mceil(v.remaining, 0.5)
						cbh.TargetDebuffsCounter[v.slot]:SetText(cbh.makestring(v.remaining))
						if v.remaining and v.remaining <= 0 then
							-- dump(v.name)
							cbh.TargetDebuffs[v.slot]:SetAlpha(0)
							cbh.TargetDebuffsCounter[v.slot]:SetAlpha(0)
						-- elseif v.remaining and v.remaining > 0 and v.remaining < 3 then
						elseif v.remaining < 3 then
							cbh.TargetDebuffs[v.slot]:SetAlpha(-(cbh.TargetDebuffs[v.slot]:GetAlpha()))
							cbh.TargetDebuffsCounter[v.slot]:SetAlpha(-(cbh.TargetDebuffsCounter[v.slot]:GetAlpha()))
						-- else
							-- cbh.TargetDebuffs[v.slot]:SetAlpha(1)
							-- cbh.TargetDebuffsCounter[v.slot]:SetAlpha(1)
						end
					end
				end
			end
		end
	end
end




--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--				FRAME BUFF ADD
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.TargetBuffAdding(hEvent, unit, buffs)
	if cbhTargetValues.enabled and cbh.UnitStatus["target"] and unit == cbh.UnitStatus["target"].id then
		if not cbh.TargetBuffTable[unit] then 
			cbh.TargetBuffTable[unit] = {}
		end
		if buffs ~= nil then
			for k in pairs(buffs) do
				local buffinfo = cbh.buffDetail(unit, k)
				if buffinfo.caster == cbh.UnitStatus["target"].id and not buffinfo.debuff and (buffinfo.remaining or cbh.targetinfo.relation ~= "friendly") then
					cbh.TargetBuffTable[unit][buffinfo.id] = buffinfo
					-- cbh.UnitStatus["target"].buffcount = cbh.UnitStatus["target"].buffcount + 1
				end
			end
			local tbcount = 0
			for i, v in pairs(cbh.TargetBuffTable[unit]) do
				tbcount = tbcount + 1
				v.slot = tbcount
				-- if v.slot ~= v.oldslot or v.oldslot == nil then
				if tbcount <= cbhTargetValues.buffcount and (v.slot ~= v.oldslot or v.oldslot == nil) then
					cbh.TargetBuffs[tbcount]:SetTexture("Rift", v.icon)
					cbh.TargetBuffs[tbcount]:SetVisible(true)
					cbh.TargetBuffs[tbcount]:SetAlpha(1)
					if v.remaining then
						cbh.TargetBuffsCounter[tbcount]:SetVisible(true)
						cbh.TargetBuffsCounter[tbcount]:SetAlpha(1)
					end
					v.oldslot = v.slot
					if v.stack then
						cbh.TargetBuffsStackCounter[tbcount]:SetVisible(true)
						cbh.TargetBuffsStackCounter[tbcount]:SetAlpha(1)
						cbh.TargetBuffsStackCounter[tbcount]:SetText(tostring(v.stack))
					else
						cbh.TargetBuffsStackCounter[tbcount]:SetVisible(false)
					end
				end
			end
			cbh.UnitStatus["target"].buffcount = tbcount
			if cbh.UnitStatus["target"].buffcount < cbhTargetValues.buffcount then
				for i = cbh.UnitStatus["target"].buffcount + 1, cbhTargetValues.buffcount do
					cbh.TargetBuffs[i]:SetVisible(false)
					cbh.TargetBuffsCounter[i]:SetVisible(false)
					cbh.TargetBuffsStackCounter[i]:SetVisible(false)
				end
			end
		end
	end
end


--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--			FRAME BUFF REMOVE
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.TargetBuffRemoving(hEvent, unit, buffs)
	if cbhTargetValues.enabled and cbh.UnitStatus["target"] and unit == cbh.UnitStatus["target"].id then
		if cbh.TargetBuffTable[unit] then
			for k, v in pairs(cbh.TargetBuffTable[unit]) do
				if buffs[v.id] then
					-- table.remove(cbh.TargetBuffTable[unit], v.slot)
					cbh.TargetBuffTable[unit][v.id] = nil
					-- cbh.UnitStatus["target"].buffcount = cbh.UnitStatus["target"].buffcount - 1
				end
			end
		end
		if cbh.UnitStatus["target"].buffcount == 0 then
			for i = 1, cbhTargetValues.buffcount do
				cbh.TargetBuffs[i]:SetVisible(false)
				cbh.TargetBuffsCounter[i]:SetVisible(false)
			end
		else
			local tbcount = 0
			for i, v in pairs(cbh.TargetBuffTable[unit]) do
				tbcount = tbcount + 1
				v.slot = tbcount
				if tbcount < cbhTargetValues.buffcount and (v.slot ~= v.oldslot or v.oldslot == nil) then
					cbh.TargetBuffs[tbcount]:SetTexture("Rift", v.icon)
					cbh.TargetBuffs[tbcount]:SetVisible(true)
					cbh.TargetBuffs[tbcount]:SetAlpha(1)
					if v.remaining then
						cbh.TargetBuffsCounter[tbcount]:SetVisible(true)
						cbh.TargetBuffsCounter[tbcount]:SetAlpha(1)
					end
					v.oldslot = v.slot
					if v.stack then
						cbh.TargetBuffsStackCounter[tbcount]:SetVisible(true)
						cbh.TargetBuffsStackCounter[tbcount]:SetAlpha(1)
						cbh.TargetBuffsStackCounter[tbcount]:SetText(tostring(v.stack))
					else
						cbh.TargetBuffsStackCounter[tbcount]:SetVisible(false)
					end
				end
			end
			cbh.UnitStatus["target"].buffcount = tbcount
			if cbh.UnitStatus["target"].buffcount < cbhTargetValues.buffcount then
				for i = cbh.UnitStatus["target"].buffcount + 1, cbhTargetValues.buffcount do
					cbh.TargetBuffs[i]:SetVisible(false)
					cbh.TargetBuffsCounter[i]:SetVisible(false)
					cbh.TargetBuffsStackCounter[i]:SetVisible(false)
				end
			end

		end
	end
end


local lastBuffUpdate = 0

function cbh.TargetBuffThrottle(throttle)
	local now = timeFrame()
	local elapsed = now - lastBuffUpdate
	if (elapsed >= throttle) then
		lastBuffUpdate = now
		return true
	end
end

--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--				BUFF MONITOR
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.TargetBuffWatch(hEvent)
	if cbhTargetValues.enabled and cbh.UnitStatus["target"] and cbh.UnitStatus["target"].buffcount > 0 then
		local timer = cbh.TargetBuffThrottle(0.5)
		if not timer then return end
		
		local tid = cbh.UnitStatus["target"].id
		-- local tempbuffcount = 0
		for k, v in pairs(cbh.TargetBuffTable[tid]) do
			if k and v and v.duration and v.begin then
				-- tempbuffcount = tempbuffcount + 1
				-- v.slot = tempbuffcount
				if v.slot and v.slot <= cbhTargetValues.buffcount then
					-- if v.slot ~= v.oldslot then
						-- cbh.TargetBuffs[v.slot]:SetTexture("Rift", v.icon)
						-- cbh.TargetBuffs[v.slot]:SetVisible(true)
						-- cbh.TargetBuffsCounter[v.slot]:SetVisible(true)
						-- v.visible = true
						-- v.oldslot = v.slot
						-- cbh.TargetBuffs[v.slot]:SetAlpha(1)
						-- cbh.TargetBuffsCounter[v.slot]:SetAlpha(1)
					-- end
					v.remaining = v.duration - (timeFrame() - v.begin)
					if v.remaining > 60 then
						v.remaining = cbh.mceil(v.remaining/60)
						cbh.TargetBuffsCounter[v.slot]:SetText(cbh.makestring(v.remaining).."m")
					else
						v.remaining = cbh.mceil(v.remaining, 0.5)
						cbh.TargetBuffsCounter[v.slot]:SetText(cbh.makestring(v.remaining))
						if v.remaining and v.remaining <= 0 then
							cbh.TargetBuffs[v.slot]:SetAlpha(0)
							cbh.TargetBuffsCounter[v.slot]:SetAlpha(0)
						-- elseif v.remaining and v.remaining > 0 and v.remaining < 3 then
						elseif v.remaining < 3 then
							cbh.TargetBuffs[v.slot]:SetAlpha(-(cbh.TargetBuffs[v.slot]:GetAlpha()))
							cbh.TargetBuffsCounter[v.slot]:SetAlpha(-(cbh.TargetBuffsCounter[v.slot]:GetAlpha()))
						-- else
							-- cbh.TargetBuffs[v.slot]:SetAlpha(1)
							-- cbh.TargetBuffsCounter[v.slot]:SetAlpha(1)
						end
					end
				end
			end
		end
	end
end



function cbh.TargetBuffChanging(x, unit, buffs)
	if cbhTargetValues.enabled and cbh.targetinfo ~= nil and unit == cbh.targetinfo.id then
		if buffs ~= nil and cbh.TargetBuffTable[unit] then
			for k, v in pairs(cbh.TargetBuffTable[unit]) do
				if buffs[v.id] then
					local buffinfo = cbh.buffDetail(unit, k)
					if v.slot <= cbhTargetValues.buffcount and buffinfo.caster == cbh.targetinfo.id and not buffinfo.debuff and buffinfo.stack then
						v.stack = buffinfo.stack
						cbh.TargetBuffsStackCounter[v.slot]:SetText(tostring(buffinfo.stack))
					end
				end
			end
			for k, v in pairs(cbh.TargetDebuffTable[unit]) do
				if buffs[v.id] then
					local buffinfo = cbh.buffDetail(unit, k)
					if v.slot <= cbhTargetValues.buffcount and buffinfo.caster == cbh.targetinfo.id and buffinfo.debuff and buffinfo.stack then
						v.stack = buffinfo.stack
						cbh.TargetDebuffsStackCounter[v.slot]:SetText(tostring(buffinfo.stack))
					end
				end
			end
		end
	end
end




function cbh.TargetUnitMouseOver(unit)
	-- dump(units)
	if cbhTargetValues.enabled and cbh.targetinfo and unit == cbh.targetinfo.id then
		cbhtargetover = cbh.targetinfo.id
		if cbh.targetinfo.pvp then cbh.TargetPvPMark:SetAlpha(1) end	-- show pvp flag in mouse over
	elseif cbhTargetValues.enabled then
		if not cbhTargetValues.pvpalwaysshow then cbh.TargetPvPMark:SetAlpha(0) end
	end
end




--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--		FRAME COMMAND SETTINGS
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.TargetToggle(t)
	if not t then
		cbhTargetValues.enabled = true
		if not cbh.TargetLoaded then cbh.TargetFrameSetup() end
		if cbh.unitLookup("player.target") then
			cbh.TargetWindow:SetVisible(true)
			cbh.UnitStatus["target"] = nil
			cbh.GetTargetInfo(cbh.unitLookup("player.target"))
		end
	else
		cbhTargetValues.enabled = false
		cbh.TargetWindow:SetVisible(false)
	end
end








--[[
find:			(UnitStatus.*\])\[1\]
replace:	\1\.aggro
]]--




--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--					EVENT TABLES
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
Command.Event.Attach(Event.Addon.SavedVariables.Load.End, cbh.TargetLoadSettings, "TargetLoadSettings")
Command.Event.Attach(Event.Addon.Startup.End, cbh.TargetFrameSetup, "TargetFrameSetup")
-- Command.Event.Attach(Event.Unit.Availability.Full, cbh.TargetFill, "TargetFill")


-- table.insert(Library.LibUnitChange.Register("mouseover"), {cbh.PTUnitMouseOver, "ClickBoxHealer", "cbhOnUnitMouseOver"}) -- create a mouseover event
table.insert(Library.LibUnitChange.Register("player.target"), {cbh.TargetUnitChange, "ClickBoxHealer", "TargetUnitChange"})
-- table.insert(Library.LibUnitChange.Register("mouseover"), {cbh.TargetUnitMouseOver, "ClickBoxHealer", "TargetMouseOver"}) -- create a mouseover event
Command.Event.Attach(Event.Unit.Detail.Health, cbh.UpdateTargetHP, "UpdateTargetHP")
Command.Event.Attach(Event.Unit.Detail.HealthMax, cbh.UpdateTargetHPMax, "UpdateHP")
Command.Event.Attach(Event.Unit.Detail.Mark, cbh.TargetRaidMarkUpdate, "UpdateRaidMark")
Command.Event.Attach(Event.Unit.Detail.Role, cbh.TargetRoleCheck, "UpdateRole")

-- DEBUFF MONITORING
Command.Event.Attach(Event.Buff.Add, cbh.TargetDebuffAdding, "TargetDebuffAdding")
Command.Event.Attach(Event.Buff.Remove, cbh.TargetDebuffRemoving, "TargetDebuffRemoving")
Command.Event.Attach(Event.System.Update.Begin, cbh.TargetDebuffWatch, "TargetDebuffWatch")

-- BUFF MONITORING
Command.Event.Attach(Event.Buff.Add, cbh.TargetBuffAdding, "TargetBuffAdding")
Command.Event.Attach(Event.Buff.Remove, cbh.TargetBuffRemoving, "TargetBuffRemoving")
Command.Event.Attach(Event.System.Update.Begin, cbh.TargetBuffWatch, "TargetBuffWatch")

Command.Event.Attach(Event.Buff.Change, cbh.TargetBuffChanging, "TargetBuffRemoving")
