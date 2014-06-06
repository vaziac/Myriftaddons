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
function cbh.PlayerLoadSettings(x, addonid)
	if addonid == "ClickBoxHealer" then
		cbh.defaults.PlayerValues = {
			enabled = true,
			macros = true,

			fx = 250,
			fy = 250,
			fheight = 55,
			fwidth = 200,
			mfheight = 5,
			mfwidth = 200,
			cfheight = 5,
			cfwidth = 200,

			cpx = 300,
			cpy = 300,
			cpsize = 64,

			fadeooc = false,

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
			pvpmarklocation = "TOPRIGHT",
			pvpmarkoffsetx = 0,
			pvpmarkoffsety = 0,
			combatsize = 24,
			combatlocation = "TOPLEFT",
			combatoffsetx = 30,
			combatoffsety = -10,
			planarchargealwaysshow = false,
			planarchargesize = 38,
			planarchargelocation = "BOTTOMRIGHT",
			planarchargeoffsetx = 0,
			planarchargeoffsety = 0,
			vitalityalwaysshow = false,
			vitalitysize = 38,
			vitalitylocation = "BOTTOMLEFT",
			vitalityoffsetx = 0,
			vitalityoffsety = 0,
			
			buffsize = 38,
			buffcount = 6,
			buffreverse = false,
			buffontop = true,
			bufflocation = "BOTTOMLEFT",
			buffattach = "TOPLEFT",
			buffoffsetx = 0,
			buffoffsety = -10,
		}
		
		cbh.defaults.PlayerColors = {
			[1] = {r = 0, g = 0, b = 0, a = 1, classcolor = false, gradient = false},			-- Health Color
			[2] = {r = 0.75, g = 0, b = 0, a = 1, classcolor = false},		-- Health Backdrop Color
			[3] = {r = 0, g = 0, b = 0.8, a = 1, classcolor = false},		-- Mana Color
			[4] = {r = 1, g = 1, b = 1, a = 1, shadow = true, classcolor = true},	-- Name Color
			[5] = {r = 1, g = 1, b = 1, a = 1, shadow = true, classcolor = false},			-- Percentage Color
		}

		if not cbhPlayerValues then
			cbhPlayerValues = {}
			cbhPlayerValues["Colors"] = {}
		end
		if not cbhPlayerValues["Colors"] then
			cbhPlayerValues["Colors"] = {}
		end
		for k, v in pairs(cbh.defaults.PlayerValues) do
			if cbhPlayerValues[k] == nil then
				cbhPlayerValues[k] = v
			end
		end
		for k, v in pairs(cbh.defaults.PlayerColors) do
			if cbhPlayerValues["Colors"][k] == nil then
				cbhPlayerValues["Colors"][k] = v
			end
		end
	end
end


--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--				FRAME CREATION
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.PlayerCreateFrame()
	cbh.PlayerTable = {}
	cbh.PlayerBuffTable = {}
	cbh.PlayerWindow = UI.CreateFrame("Frame", "PlayerWindow", cbh.Context)
	cbh.PlayerWindow:SetSecureMode("restricted")
	cbh.PlayerWindowDrag = UI.CreateFrame("Frame", "PlayerDragFrame", cbh.PlayerWindow)
	cbh.PlayerBorder = UI.CreateFrame("Texture", "PlayerFrame", cbh.PlayerWindow)
	cbh.PlayerFrame = UI.CreateFrame("Texture", "PlayerFrame", cbh.PlayerWindow)
	cbh.PlayerFrame:SetSecureMode("restricted")
	cbh.PlayerHP = UI.CreateFrame("Frame", "PlayerHP", cbh.PlayerWindow)
	cbh.PlayerChargeFrame = UI.CreateFrame("Texture", "PlayerChargeFrame", cbh.PlayerWindow)
	cbh.PlayerCharge = UI.CreateFrame("Frame", "PlayerCharge", cbh.PlayerWindow)
	cbh.PlayerManaFrame = UI.CreateFrame("Texture", "PlayerManaFrame", cbh.PlayerWindow)
	cbh.PlayerMana = UI.CreateFrame("Frame", "PlayerMana", cbh.PlayerWindow)
	cbh.PlayerEnergyFrame = UI.CreateFrame("Texture", "PlayerCombatIcon", cbh.PlayerWindow)
	cbh.PlayerEnergy = UI.CreateFrame("Frame", "PlayerCombatIcon", cbh.PlayerWindow)
	cbh.PlayerPowerFrame = UI.CreateFrame("Texture", "PlayerCombatIcon", cbh.PlayerWindow)
	cbh.PlayerPower = UI.CreateFrame("Frame", "PlayerCombatIcon", cbh.PlayerWindow)
	cbh.PlayerComboFrame = UI.CreateFrame("Frame", "ComboPointFrame", cbh.PlayerWindow)
	cbh.PlayerComboDrag = UI.CreateFrame("Frame", "PlayerComboDrag", cbh.PlayerWindow)
	cbh.PlayerCombo={}
	for i = 1, 5 do
		cbh.PlayerCombo[i] = UI.CreateFrame("Texture", "PlayerComboPoints", cbh.PlayerComboFrame)
	end

	cbh.PlayerName = UI.CreateFrame("Text", "PlayerFrame", cbh.PlayerWindow)
	cbh.PlayerLevel = UI.CreateFrame("Text", "PlayerFrame", cbh.PlayerWindow)
	cbh.PlayerPercent = UI.CreateFrame("Text", "PlayerPercent", cbh.PlayerWindow)
	cbh.PlayerPvPMark = UI.CreateFrame("Text", "PlayerPVP", cbh.PlayerWindow)
	cbh.PlayerRole = UI.CreateFrame("Texture", "PlayerRole", cbh.PlayerWindow)
	cbh.PlayerRaidMark = UI.CreateFrame("Texture", "PlayerRaidMark", cbh.PlayerWindow)
	cbh.PlayerCombat = UI.CreateFrame("Texture", "PlayerCombatIcon", cbh.PlayerWindow)
	cbh.PlayerPlanarCharge = UI.CreateFrame("Texture", "PlayerPlanarCharge", cbh.PlayerWindow)
	cbh.PlayerPlanarChargeText = UI.CreateFrame("Text", "PlayerPlanarChargeText", cbh.PlayerWindow)
	cbh.PlayerVitality = UI.CreateFrame("Texture", "PlayerVitality", cbh.PlayerWindow)
	cbh.PlayerVitalityText = UI.CreateFrame("Text", "PlayerVitalityText", cbh.PlayerWindow)
	
	cbh.PlayerTooltip = UI.CreateFrame("Frame", "PlayerTooltip", cbh.Context)

	cbh.PlayerBuffs={}
	cbh.PlayerBuffsCounter={}
	cbh.PlayerBuffsStackCounter={}
	for i = 1, cbhPlayerValues.buffcount do
		cbh.PlayerBuffs[i] = UI.CreateFrame("Texture", "PlayerBuffs", cbh.PlayerWindow)
		cbh.PlayerBuffsCounter[i] = UI.CreateFrame("Text", "PlayerBuffsCounter", cbh.PlayerWindow)
		cbh.PlayerBuffsStackCounter[i] = UI.CreateFrame("Text", "PlayerBuffsCounter", cbh.PlayerWindow)
	end

	
	-- test canvas
	-- cbh.canvasa = UI.CreateFrame("Canvas", "test", cbh.PlayerWindow)	
end


--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--					FRAME SETUP
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.PlayerFrameSetup()
	if cbhPlayerValues.enabled then
		cbh.PlayerCreateFrame()
		cbh.PlayerWindow:SetPoint("TOPLEFT", cbh.Context, "TOPLEFT", cbhPlayerValues.fx, cbhPlayerValues.fy)
		-- cbh.PlayerWindow:SetSecureMode("restricted")
		if not cbhValues.isincombat and cbhPlayerValues.fadeooc then
			cbh.PlayerWindow:SetAlpha(0.1)
		end

		-- CREATE "DRAG ORB" FOR MOVING FRAME
		cbh.PlayerWindowDrag:SetPoint("TOPLEFT", cbh.PlayerWindow, "TOPLEFT", -4, -4)
		-- cbh.PlayerWindowDrag:SetTexture("Rift", "AreaQuest_VFX_CenterBursts.png.dds")
		cbh.PlayerWindowDrag:SetLayer(9)
		cbh.PlayerWindowDrag:SetWidth(cbhPlayerValues.fwidth+8)
		cbh.PlayerWindowDrag:SetHeight(cbhPlayerValues.fheight+cbhPlayerValues.mfheight+8)
		cbh.PlayerWindowDrag:SetBackgroundColor(1,0,0,0.5)
		cbh.PlayerWindowDrag:SetVisible(false)
		
		-- cbh.canvasa:SetPoint("TOPLEFT", cbh.PlayerWindow, "TOPLEFT", -1, -1)
		-- cbh.canvasa:SetPoint("TOPLEFT", cbh.PlayerWindow, "TOPLEFT", -1, -1)
		-- cbh.canvasa:SetPoint("TOPLEFT", cbh.PlayerWindow, "TOPLEFT", -1, -1)
		-- cbh.canvasa:SetPoint("TOPLEFT", cbh.PlayerWindow, "TOPLEFT", -1, -1)
		-- cbh.canvasa:SetPoint("TOPLEFT", cbh.PlayerWindow, "TOPLEFT", -1, -1)

		-- ALLOWS DRAGGING OF FRAME AND REPOSITIONING WHEN FRAME ISN'T LOCKED
		cbh.PlayerWindowDrag:EventAttach(Event.UI.Input.Mouse.Left.Down, function(self, h)
			self.windowdragActive = true
			local mouseStatus = Inspect.Mouse()
			self.oldx = mouseStatus.x - cbhPlayerValues.fx
			self.oldy = mouseStatus.y - cbhPlayerValues.fy
		end, "Event.UI.Input.Mouse.LeftDown")

		--CHANGE SAVED FRAMENUMBERIABLES WHEN MOUSE IS MOVED WHILE DRAGGING ACTIVE
		cbh.PlayerWindowDrag:EventAttach(Event.UI.Input.Mouse.Cursor.Move, function(self, h)
			if self.windowdragActive == true then
				self.moved = true
				local newx, newy
				local mouseStatus = Inspect.Mouse()
				cbhPlayerValues.fx = mouseStatus.x - self.oldx
				cbhPlayerValues.fy = mouseStatus.y - self.oldy
				cbh.PlayerWindow:SetPoint("TOPLEFT", cbh.Context, "TOPLEFT", cbhPlayerValues.fx, cbhPlayerValues.fy)
			end
		end, "Event.UI.Input.Mouse.Cursor.Move")

		-- ENDS DRAGGING WHEN LEFT CLICK RELEASED
		cbh.PlayerWindowDrag:EventAttach(Event.UI.Input.Mouse.Left.Up, function(self, h)
			self.windowdragActive = false
		end, "Event.UI.Input.Mouse.LeftUp")

		cbh.PlayerWindowDrag:EventAttach(Event.UI.Input.Mouse.Left.Upoutside, function(self, h)
			self.windowdragActive = false
		end, "Event.UI.Input.Mouse.Left.Upoutside")

		-- LOCKS FRAME IF RIGHT CLICKED
		cbh.PlayerWindowDrag:EventAttach(Event.UI.Input.Mouse.Right.Click, function(self, h)
			cbh.FrameLocked()
		end, "Event.UI.Input.Mouse.Right.Click")

		
		
		-- HEALTH FRAME
		cbh.PlayerFrame:SetPoint("TOPLEFT", cbh.PlayerWindow, "TOPLEFT", 0, 0)
		cbh.PlayerFrame:SetTexture("ClickBoxHealer", "Textures/"..cbhPlayerValues.texture)
		cbh.PlayerFrame:SetLayer(1)
		cbh.PlayerFrame:SetWidth(cbhPlayerValues.fwidth)
		cbh.PlayerFrame:SetHeight(cbhPlayerValues.fheight)
		cbh.PlayerFrame:SetBackgroundColor(cbhPlayerValues["Colors"][1].r, cbhPlayerValues["Colors"][1].g, cbhPlayerValues["Colors"][1].b, cbhPlayerValues["Colors"][1].a)
		
		cbh.PlayerHP:SetPoint("TOPRIGHT", cbh.PlayerFrame, "TOPRIGHT", 0, 0)
		cbh.PlayerHP:SetLayer(2)
		cbh.PlayerHP:SetWidth(0)
		cbh.PlayerHP:SetHeight(cbhPlayerValues.fheight)
		cbh.PlayerHP:SetBackgroundColor(cbhPlayerValues["Colors"][2].r, cbhPlayerValues["Colors"][2].g, cbhPlayerValues["Colors"][2].b, cbhPlayerValues["Colors"][2].a)


		-- HEALTH FRAME
		cbh.PlayerBorder:SetPoint("TOPLEFT", cbh.PlayerFrame, "TOPLEFT", -1, -1)
		cbh.PlayerBorder:SetPoint("BOTTOMRIGHT", cbh.PlayerManaFrame, "BOTTOMRIGHT", 1, 1)
		cbh.PlayerBorder:SetTexture("ClickBoxHealer", "Textures/nbackframe.png")
		cbh.PlayerBorder:SetLayer(0)
		-- cbh.PlayerBorder:SetWidth(cbhPlayerValues.fwidth+2)
		-- cbh.PlayerBorder:SetHeight(cbhPlayerValues.fheight+cbhPlayerValues.mfheight+2)

		
		--MANA BAR IF PRESENT
		cbh.PlayerManaFrame:SetPoint("TOPLEFT", cbh.PlayerFrame, "BOTTOMLEFT", 0, 0)
		cbh.PlayerManaFrame:SetTexture("ClickBoxHealer", "Textures/"..cbhPlayerValues.texture)
		cbh.PlayerManaFrame:SetLayer(1)
		cbh.PlayerManaFrame:SetWidth(cbhPlayerValues.fwidth)
		cbh.PlayerManaFrame:SetHeight(cbhPlayerValues.mfheight)
		cbh.PlayerManaFrame:SetVisible(false)
		cbh.PlayerManaFrame:SetBackgroundColor(cbhPlayerValues["Colors"][3].r, cbhPlayerValues["Colors"][3].g, cbhPlayerValues["Colors"][3].b, cbhPlayerValues["Colors"][3].a)

		cbh.PlayerMana:SetPoint("TOPRIGHT", cbh.PlayerManaFrame, "TOPRIGHT", 0, 0)
		cbh.PlayerMana:SetLayer(2)
		cbh.PlayerMana:SetWidth(0)
		cbh.PlayerMana:SetHeight(cbhPlayerValues.mfheight)
		cbh.PlayerMana:SetBackgroundColor(0,0,0,1)

		
		-- ENERGY BAR IF PRESENT
		cbh.PlayerEnergyFrame:SetPoint("TOPLEFT", cbh.PlayerFrame, "BOTTOMLEFT", 0, 0)
		cbh.PlayerEnergyFrame:SetTexture("ClickBoxHealer", "Textures/"..cbhPlayerValues.texture)
		cbh.PlayerEnergyFrame:SetLayer(1)
		cbh.PlayerEnergyFrame:SetWidth(cbhPlayerValues.fwidth)
		cbh.PlayerEnergyFrame:SetHeight(cbhPlayerValues.mfheight)
		cbh.PlayerEnergyFrame:SetBackgroundColor(1,1,0,1)
		cbh.PlayerEnergyFrame:SetVisible(false)

		cbh.PlayerEnergy:SetPoint("TOPRIGHT", cbh.PlayerManaFrame, "TOPRIGHT", 0, 0)
		cbh.PlayerEnergy:SetLayer(2)
		cbh.PlayerEnergy:SetWidth(0)
		cbh.PlayerEnergy:SetHeight(cbhPlayerValues.mfheight)
		cbh.PlayerEnergy:SetBackgroundColor(0,0,0,1)

		
		-- POWER BAR IF PRESENT
		cbh.PlayerPowerFrame:SetPoint("TOPLEFT", cbh.PlayerFrame, "BOTTOMLEFT", 0, 0)
		cbh.PlayerPowerFrame:SetTexture("ClickBoxHealer", "Textures/"..cbhPlayerValues.texture)
		cbh.PlayerPowerFrame:SetLayer(1)
		cbh.PlayerPowerFrame:SetWidth(cbhPlayerValues.fwidth)
		cbh.PlayerPowerFrame:SetHeight(cbhPlayerValues.mfheight)
		cbh.PlayerPowerFrame:SetBackgroundColor(1,0,0,1)
		cbh.PlayerPowerFrame:SetVisible(false)

		cbh.PlayerPower:SetPoint("TOPRIGHT", cbh.PlayerManaFrame, "TOPRIGHT", 0, 0)
		cbh.PlayerPower:SetLayer(2)
		cbh.PlayerPower:SetWidth(0)
		cbh.PlayerPower:SetHeight(cbhPlayerValues.mfheight)
		cbh.PlayerPower:SetBackgroundColor(0,0,0,1)

		
		-- CHARGE BAR IF PRESENT
		cbh.PlayerChargeFrame:SetPoint("TOPLEFT", cbh.PlayerManaFrame, "BOTTOMLEFT", 0, 0)
		cbh.PlayerChargeFrame:SetTexture("ClickBoxHealer", "Textures/"..cbhPlayerValues.texture)
		cbh.PlayerChargeFrame:SetLayer(1)
		cbh.PlayerChargeFrame:SetWidth(cbhPlayerValues.fwidth)
		cbh.PlayerChargeFrame:SetHeight(cbhPlayerValues.cfheight)
		cbh.PlayerChargeFrame:SetBackgroundColor(0.25,.5,.75,1)
		cbh.PlayerChargeFrame:SetVisible(false)

		cbh.PlayerCharge:SetPoint("TOPRIGHT", cbh.PlayerChargeFrame, "TOPRIGHT", 0, 0)
		cbh.PlayerCharge:SetLayer(2)
		cbh.PlayerCharge:SetWidth(0)
		cbh.PlayerCharge:SetHeight(cbhPlayerValues.cfheight)
		cbh.PlayerCharge:SetBackgroundColor(0,0,0,1)

		
		-- NAME
		cbh.PlayerName:SetPoint(cbhPlayerValues.namelocation, cbh.PlayerFrame, cbhPlayerValues.namelocation, cbhPlayerValues.nameoffsetx, cbhPlayerValues.nameoffsety)
		cbh.PlayerName:SetLayer(3)
		cbh.PlayerName:SetFontSize(cbhPlayerValues.namefontsize)
		if cbhPlayerValues["Colors"][4].shadow then cbh.PlayerName:SetEffectGlow(cbh.NameGlowTable) end
		cbh.PlayerName:SetFontColor(cbhPlayerValues["Colors"][4].r, cbhPlayerValues["Colors"][4].g, cbhPlayerValues["Colors"][4].b, cbhPlayerValues["Colors"][4].a)

		-- LEVEL
		cbh.PlayerLevel:SetPoint(cbhPlayerValues.levellocation, cbh.PlayerFrame, cbhPlayerValues.levellocation, cbhPlayerValues.leveloffsetx, cbhPlayerValues.leveloffsety)
		cbh.PlayerLevel:SetLayer(3)
		cbh.PlayerLevel:SetFontSize(cbhPlayerValues.levelsize)
		if cbhPlayerValues["Colors"][4].shadow then cbh.PlayerLevel:SetEffectGlow(cbh.NameGlowTable) end
		cbh.PlayerLevel:SetFontColor(cbhPlayerValues["Colors"][4].r, cbhPlayerValues["Colors"][4].g, cbhPlayerValues["Colors"][4].b, cbhPlayerValues["Colors"][4].a)

		
		-- PVP
		cbh.PlayerPvPMark:SetPoint(cbhPlayerValues.pvpmarklocation, cbh.PlayerFrame, cbhPlayerValues.pvpmarklocation, cbhPlayerValues.pvpmarkoffsetx, cbhPlayerValues.pvpmarkoffsety)
		cbh.PlayerPvPMark:SetLayer(3)
		cbh.PlayerPvPMark:SetFontSize(cbhPlayerValues.pvpmarksize)
		cbh.PlayerPvPMark:SetEffectGlow(cbh.NameGlowTable)
		cbh.PlayerPvPMark:SetFontColor(1,0,0,1)
		cbh.PlayerPvPMark:SetText("> PvP <")
		cbh.PlayerPvPMark:SetAlpha(0)

		
		-- HEALTH PERCENT TEXT
		cbh.PlayerPercent:SetPoint(cbhPlayerValues.percentlocation, cbh.PlayerFrame, cbhPlayerValues.percentlocation, cbhPlayerValues.percentoffsetx, cbhPlayerValues.percentoffsety)
		cbh.PlayerPercent:SetLayer(3)
		cbh.PlayerPercent:SetFontSize(cbhPlayerValues.percentfontsize)
		if cbhPlayerValues["Colors"][5].shadow then cbh.PlayerPercent:SetEffectGlow(cbh.NameGlowTable) end
		cbh.PlayerPercent:SetFontColor(cbhPlayerValues["Colors"][5].r, cbhPlayerValues["Colors"][5].g, cbhPlayerValues["Colors"][5].b, cbhPlayerValues["Colors"][5].a)
		if not cbhPlayerValues.percentshow then cbh.PlayerPercent:SetVisible(false) end
		
		-- DUNGEON ROLE
		cbh.PlayerRole:SetPoint(cbhPlayerValues.rolelocation, cbh.PlayerFrame, cbhPlayerValues.rolelocation, cbhPlayerValues.roleoffsetx, cbhPlayerValues.roleoffsety)
		cbh.PlayerRole:SetLayer(3)
		cbh.PlayerRole:SetWidth(cbhPlayerValues.rolesize)
		cbh.PlayerRole:SetHeight(cbhPlayerValues.rolesize)

		
		-- RAID MARKER
		cbh.PlayerRaidMark:SetPoint(cbhPlayerValues.raidmarklocation, cbh.PlayerFrame, cbhPlayerValues.raidmarklocation, cbhPlayerValues.raidmarkoffsetx, cbhPlayerValues.raidmarkoffsety)
		cbh.PlayerRaidMark:SetLayer(3)
		cbh.PlayerRaidMark:SetVisible(false)
		cbh.PlayerRaidMark:SetWidth(cbhPlayerValues.raidmarksize)
		cbh.PlayerRaidMark:SetHeight(cbhPlayerValues.raidmarksize)


		-- COMBAT INDICATOR
		-- cbh.PlayerCombat:SetPoint("BOTTOMRIGHT", cbh.PlayerFrame, "TOPLEFT", 50, 10)
		cbh.PlayerCombat:SetPoint(cbhPlayerValues.combatlocation, cbh.PlayerFrame, cbhPlayerValues.combatlocation, cbhPlayerValues.combatoffsetx, cbhPlayerValues.combatoffsety)
		-- cbh.PlayerCombat:SetTexture("ClickBoxHealer", "textures/combat.png")
		cbh.PlayerCombat:SetTexture("Rift", "indicator_invasion_fire.png.dds")
		cbh.PlayerCombat:SetLayer(3)
		cbh.PlayerCombat:SetWidth(cbhPlayerValues.combatsize)
		cbh.PlayerCombat:SetHeight(cbhPlayerValues.combatsize)
		cbh.PlayerCombat:SetVisible(false)
		
		
		-- PLANAR CHARGES CRYSTAL
		cbh.PlayerPlanarCharge:SetPoint(cbhPlayerValues.planarchargelocation, cbh.PlayerFrame, cbhPlayerValues.planarchargelocation, cbhPlayerValues.planarchargeoffsetx, cbhPlayerValues.planarchargeoffsety)
		cbh.PlayerPlanarCharge:SetTexture("Rift", "chargedstone_on.png.dds")
		cbh.PlayerPlanarCharge:SetLayer(4)
		cbh.PlayerPlanarCharge:SetWidth(cbhPlayerValues.planarchargesize)
		cbh.PlayerPlanarCharge:SetHeight(cbhPlayerValues.planarchargesize)
		
		-- PLANAR CHARGES
		cbh.PlayerPlanarChargeText:SetPoint("CENTER", cbh.PlayerPlanarCharge, "CENTER", 0, 5)
		cbh.PlayerPlanarChargeText:SetLayer(5)
		cbh.PlayerPlanarChargeText:SetFontSize(18)
		cbh.PlayerPlanarChargeText:SetEffectGlow(cbh.NameGlowTable)

		if cbhPlayerValues.planarchargealwaysshow then
			cbh.PlayerPlanarCharge:SetAlpha(1)
			cbh.PlayerPlanarChargeText:SetAlpha(1)
		else
			cbh.PlayerPlanarCharge:SetAlpha(0)
			cbh.PlayerPlanarChargeText:SetAlpha(0)
		end

		
		-- VITALITY ICON
		cbh.PlayerVitality:SetPoint(cbhPlayerValues.vitalitylocation, cbh.PlayerFrame, cbhPlayerValues.vitalitylocation, cbhPlayerValues.vitalityoffsetx, cbhPlayerValues.vitalityoffsety)
		-- cbh.PlayerVitality:SetTexture("Rift", "death_icon_(grey).png.dds")
		cbh.PlayerVitality:SetTexture("Rift", "GuildLog_icon_kills.png.dds")
		cbh.PlayerVitality:SetLayer(4)
		cbh.PlayerVitality:SetWidth(cbhPlayerValues.vitalitysize)
		cbh.PlayerVitality:SetHeight(cbhPlayerValues.vitalitysize)
		
		-- VITALITY TEXT
		cbh.PlayerVitalityText:SetPoint("BOTTOMCENTER", cbh.PlayerVitality, "BOTTOMCENTER", 0, 10)
		cbh.PlayerVitalityText:SetLayer(5)
		cbh.PlayerVitalityText:SetFontSize(14)
		cbh.PlayerVitalityText:SetEffectGlow(cbh.NameGlowTable)


		if cbhPlayerValues.vitalityalwaysshow then
			cbh.PlayerVitality:SetAlpha(1)
			cbh.PlayerVitalityText:SetAlpha(1)
		else
			cbh.PlayerVitality:SetAlpha(0)
			cbh.PlayerVitalityText:SetAlpha(0)
		end

		
		-- BUFF BOXES
		-- calculates the size based on the number of buffs requested  to fit the width of the frame
		local tbuffsize = (cbhPlayerValues.fwidth/cbhPlayerValues.buffcount)-(4*cbhPlayerValues.buffcount/cbhPlayerValues.buffcount)
		local bufftempx = 0
		for i = 1, cbhPlayerValues.buffcount do
			cbh.PlayerBuffs[i]:SetPoint(cbhPlayerValues.bufflocation, cbh.PlayerFrame, cbhPlayerValues.buffattach, bufftempx, cbhPlayerValues.buffoffsety)
			cbh.PlayerBuffs[i]:SetLayer(3)
			cbh.PlayerBuffs[i]:SetWidth(tbuffsize)
			cbh.PlayerBuffs[i]:SetHeight(tbuffsize)
			bufftempx = (tbuffsize+5)*i
			if cbhPlayerValues.buffreverse then	bufftempx = -(bufftempx) end
			cbh.PlayerBuffsCounter[i]:SetPoint("BOTTOMCENTER", cbh.PlayerBuffs[i], "BOTTOMCENTER", 0, 0)
			cbh.PlayerBuffsCounter[i]:SetFontSize(16)
			cbh.PlayerBuffsCounter[i]:SetFontColor(1,1,1,1)
			cbh.PlayerBuffsCounter[i]:SetEffectGlow(cbh.NameGlowTable)
			cbh.PlayerBuffsCounter[i]:SetLayer(6)
			cbh.PlayerBuffsStackCounter[i]:SetPoint("TOPRIGHT", cbh.PlayerBuffs[i], "TOPRIGHT", 0, -2)
			cbh.PlayerBuffsStackCounter[i]:SetFontSize(16)
			cbh.PlayerBuffsStackCounter[i]:SetFontColor(1,1,1,1)
			cbh.PlayerBuffsStackCounter[i]:SetEffectGlow(cbh.NameGlowTable)
			cbh.PlayerBuffsStackCounter[i]:SetLayer(6)
		end


		-- COMBO POINT FRAME
		cbh.PlayerComboFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", cbhPlayerValues.cpx, cbhPlayerValues.cpy)
		cbh.PlayerComboFrame:SetWidth((cbhPlayerValues.cpsize+2)*5)

		
		-- CREATE "DRAG ORB" FOR MOVING FRAME
		cbh.PlayerComboDrag:SetPoint("TOPLEFT", cbh.PlayerComboFrame, "TOPLEFT", 0, 0)
		-- cbh.PlayerComboDrag:SetTexture("Rift", "AreaQuest_VFX_CenterBursts.png.dds")
		cbh.PlayerComboDrag:SetLayer(9)
		cbh.PlayerComboDrag:SetWidth((cbhPlayerValues.cpsize+2)*5)
		cbh.PlayerComboDrag:SetHeight(cbhPlayerValues.cpsize)
		cbh.PlayerComboDrag:SetBackgroundColor(1,0,0,.5)
		cbh.PlayerComboDrag:SetVisible(false)

		-- ALLOWS DRAGGING OF FRAME AND REPOSITIONING WHEN FRAME ISN'T LOCKED
		cbh.PlayerComboDrag:EventAttach(Event.UI.Input.Mouse.Left.Down, function(self, h)
			self.windowdragActive = true
			local mouseStatus = Inspect.Mouse()
			self.oldx = mouseStatus.x - cbhPlayerValues.cpx
			self.oldy = mouseStatus.y - cbhPlayerValues.cpy
		end, "Event.UI.Input.Mouse.LeftDown")

		--CHANGE SAVED FRAMENUMBERIABLES WHEN MOUSE IS MOVED WHILE DRAGGING ACTIVE
		cbh.PlayerComboDrag:EventAttach(Event.UI.Input.Mouse.Cursor.Move, function(self, h)
			if self.windowdragActive == true then
				self.moved = true
				local newx, newy
				local mouseStatus = Inspect.Mouse()
				cbhPlayerValues.cpx = mouseStatus.x - self.oldx
				cbhPlayerValues.cpy = mouseStatus.y - self.oldy
				cbh.PlayerComboFrame:SetPoint("TOPLEFT", cbh.Context, "TOPLEFT", cbhPlayerValues.cpx, cbhPlayerValues.cpy)
			end
		end, "Event.UI.Input.Mouse.Cursor.Move")

		-- ENDS DRAGGING WHEN LEFT CLICK RELEASED
		cbh.PlayerComboDrag:EventAttach(Event.UI.Input.Mouse.Left.Up, function(self, h)
			self.windowdragActive = false
		end, "Event.UI.Input.Mouse.LeftUp")

		cbh.PlayerComboDrag:EventAttach(Event.UI.Input.Mouse.Left.Upoutside, function(self, h)
			self.windowdragActive = false
		end, "Event.UI.Input.Mouse.Left.Upoutside")

		-- LOCKS FRAME IF RIGHT CLICKED
		cbh.PlayerComboDrag:EventAttach(Event.UI.Input.Mouse.Right.Click, function(self, h)
			cbh.FrameLocked()
		end, "Event.UI.Input.Mouse.Right.Click")
		
		for i = 1, 5 do
			cbh.PlayerCombo[i]:SetPoint("TOPLEFT", cbh.PlayerComboFrame, "TOPLEFT", cbhPlayerValues.cpsize*(i-1), 0)
			cbh.PlayerCombo[i]:SetLayer(2)
			cbh.PlayerCombo[i]:SetWidth(cbhPlayerValues.cpsize)
			cbh.PlayerCombo[i]:SetHeight(cbhPlayerValues.cpsize)
			-- cbh.PlayerCombo[i]:SetWidth(64)
			-- cbh.PlayerCombo[i]:SetHeight(64)
			cbh.PlayerCombo[i]:SetVisible(false)
		end

		-- cbh.PlayerClick:SetPoint("TOPLEFT", cbh.Context, "TOPLEFT", cbhPlayerValues.fx, cbhPlayerValues.fy)
		-- cbh.PlayerClick:SetWidth(cbhPlayerValues.fwidth)
		-- cbh.PlayerClick:SetHeight(cbhPlayerValues.fheight)
		-- cbh.PlayerClick:SetAlpha(0)

		local taction = "/tar @player"
		local tempraction = "/script Command.Unit.Menu(cbhplayerover)"
		cbh.PlayerFrame.Event.LeftClick = taction
		cbh.PlayerFrame.Event.RightClick = tempraction
		
		-- cbh.PlayerFrame.Event.RightClick = function(self)
			-- Command.Unit.Menu(cbh.playerinfo.id) end
	end
end


--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--					FRAME VALUES
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.PlayerFrameUpdate()
	if cbhPlayerValues.enabled then
		cbh.PlayerName:SetText(cbh.playerinfo.name)
		cbh.PlayerLevel:SetText(tostring(cbh.playerinfo.level))
		cbh.nameCalc(cbh.playerinfo.name, nil, "player")
		
		cbh.PlayerPlanarChargeText:SetText(tostring(cbh.playerinfo.planar))
		if cbhPlayerValues.planarchargealwaysshow then cbh.PlayerPlanarCharge:SetAlpha(1) cbh.PlayerPlanarChargeText:SetAlpha(1) end
		
		cbh.PlayerVitalityText:SetText(cbh.playerinfo.vitality.."%")
		if cbhPlayerValues.vitalityalwaysshow then cbh.PlayerPlanarCharge:SetAlpha(1) cbh.PlayerPlanarChargeText:SetAlpha(1) end

		if cbh.playerinfo.role then
			cbh.PlayerRole:SetTexture("Rift", cbh.RoleImgs[cbh.playerinfo.role])
			cbh.PlayerRole:SetVisible(cbhPlayerValues.roleshow)
		else cbh.PlayerRole:SetVisible(false) end

		if cbh.playerinfo.mark then
			cbh.PlayerRaidMark:SetVisible(true)
			cbh.PlayerRaidMark:SetTexture("Rift", cbh.RaidMarkerImages[cbh.playerinfo.mark])
		else cbh.PlayerRaidMark:SetVisible(false) end

		if cbhPlayerValues["Colors"][4].classcolor then
			cbh.PlayerName:SetFontColor(cbh.ClassColors[cbh.playerinfo.calling].r, cbh.ClassColors[cbh.playerinfo.calling].g, cbh.ClassColors[cbh.playerinfo.calling].b, cbhPlayerValues["Colors"][4].a)
		end
		
		if cbhPlayerValues["Colors"][3].classcolor then
			cbh.PlayerManaFrame:SetBackgroundColor(cbh.ClassColors[cbh.playerinfo.calling].r, cbh.ClassColors[cbh.playerinfo.calling].g, cbh.ClassColors[cbh.playerinfo.calling].b, cbhPlayerValues["Colors"][3].a)
		end
		-- for i = 1, 4 do
			-- if cbh.playerinfo.calling == cbh.Calling[i] then
				-- cbh.PlayerName:SetFontColor(cbhCallingColors[i].r, cbhCallingColors[i].g, cbhCallingColors[i].b, 1)
				-- if cbhPlayerValues.manaCC then
					-- cbh.PlayerManaFrame:SetBackgroundColor(cbhCallingColors[i].r, cbhCallingColors[i].g, cbhCallingColors[i].b, 1)
				-- else
					-- cbh.PlayerManaFrame:SetBackgroundColor(.25,.25,.75,1)
				-- end
				--cbh.PlayerHP:SetBackgroundColor(cbhCallingColors[i].r, cbhCallingColors[i].g, cbhCallingColors[i].b, 1)
			-- end
		-- end

		for i = 1, 5 do
			if cbh.playerinfo.calling == "warrior" then
				cbh.PlayerCombo[i]:SetTexture("Rift", "target_portrait_warrior_hp.png.dds")
			else
				cbh.PlayerCombo[i]:SetTexture("Rift", "target_portrait_roguepoint.png.dds")
			end
		end
		
		if cbh.playerinfo.mana then cbh.PlayerManaFrame:SetVisible(true) end
		if cbh.playerinfo.charge then cbh.PlayerChargeFrame:SetVisible(true) end
		if cbh.playerinfo.energy then cbh.PlayerEnergyFrame:SetVisible(true) end
		if cbh.playerinfo.power then cbh.PlayerPowerFrame:SetVisible(true) end

		cbh.PlayerFrame:SetMouseoverUnit(cbh.playerinfo.id)
		
		if cbh.playerinfo.pvp and cbhPlayerValues.pvpalwaysshow then cbh.PlayerPvPMark:SetAlpha(1) end
		
		local tempid
		
		tempid = { [cbh.playerinfo.id] = cbh.playerinfo.health }
		cbh.PlayerUpdateHP(x, tempid)
		
		tempid={[cbh.playerinfo.id]=cbh.playerinfo.combo}
		if cbh.playerinfo.combo then cbh.PlayerUpdateCombo(x, tempid) end
		
		cbh.playerinfo.buffcount = 0
		local tbufflist = cbh.buffList(cbh.playerinfo.id)
		cbh.PlayerBuffAdding(x, cbh.playerinfo.id, tbufflist)

		cbh.PlayerLoaded = true
	end
end



--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--				FRAME UPDATE HP
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.PlayerUpdateHP(x, units)
	if cbhPlayerValues.enabled and units[cbh.playerinfo.id] then
		cbh.playerinfo.health = units[cbh.playerinfo.id]
		local healthcalc = (cbh.playerinfo.health / cbh.playerinfo.healthMax)
		local healthtick = (-healthcalc * cbhPlayerValues.fwidth + cbhPlayerValues.fwidth)
		cbh.PlayerHP:SetWidth(healthtick)
		if cbhPlayerValues["Colors"][1].gradient then
			if healthcalc < .3 then
				cbh.PlayerFrame:SetBackgroundColor(1, 0, 0, cbhPlayerValues["Colors"][1].a)
			elseif healthcalc < .65 then
				cbh.PlayerFrame:SetBackgroundColor(1, 1, 0, cbhPlayerValues["Colors"][1].a)
			else cbh.PlayerFrame:SetBackgroundColor(cbhPlayerValues["Colors"][1].r, cbhPlayerValues["Colors"][1].g, cbhPlayerValues["Colors"][1].b, cbhPlayerValues["Colors"][1].a) end
		end

		-- if cbhValues.hidehealth == false then
			local health = 0
			local healthpercent = math.ceil(healthcalc * 100)
			if cbh.playerinfo.health >= 1000000 then
				health = cbh.round((cbh.playerinfo.health/1000000), 1)
				health = tostring(health).."m"
				cbh.PlayerPercent:SetText(health.."  "..healthpercent.."%")
			elseif cbh.playerinfo.health >= 1000 then
				health = cbh.round((cbh.playerinfo.health/1000), 1)
				health = tostring(health).."k"
				cbh.PlayerPercent:SetText(health.."  "..healthpercent.."%")
			elseif cbh.playerinfo.health < 1000 and cbh.playerinfo.health > 0 then
				health = cbh.round(cbh.playerinfo.health, 0)
				health = tostring(health)
				cbh.PlayerPercent:SetText(health.."  "..healthpercent.."%")
			elseif cbh.playerinfo.health <= 0 or math.ceil(healthcalc) == 0 then
				cbh.PlayerPercent:SetText("DEAD")
				cbh.playerinfo.dead = true
			end
		-- end
	end
end



function cbh.PlayerUpdateHPMax(hEvent, units)
	if cbhPlayerValues.enabled and units[cbh.playerinfo.id] then
		local tvalue = units[cbh.playerinfo.id]
		cbh.playerinfo.healthMax = tvalue
		local tempid = {[cbh.playerinfo.id] = cbh.playerinfo.health}
		cbh.PlayerUpdateHP(x, tempid)
	end
end


--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--				FRAME UPDATE MANA
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.PlayerUpdateMana(x, units)
	if cbhPlayerValues.enabled and units[cbh.playerinfo.id] then
		cbh.playerinfo.mana = units[cbh.playerinfo.id]
		local manacalc = (cbh.playerinfo.mana / cbh.playerinfo.manaMax)
		local manatick = (-manacalc * cbhPlayerValues.fwidth + cbhPlayerValues.fwidth)
		cbh.PlayerMana:SetWidth(manatick)
	end
end

function cbh.PlayerUpdateManaMax(hEvent, units)
	if cbhPlayerValues.enabled and units[cbh.playerinfo.id] then
		local tvalue = units[cbh.playerinfo.id]
		cbh.playerinfo.manaMax = tvalue
		local tempid = {[cbh.playerinfo.id] = cbh.playerinfo.mana}
		cbh.PlayerUpdateMana(x, tempid)
	end
end


--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--				FRAME UPDATE POWER
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.PlayerUpdatePower(x, units)
	if cbhPlayerValues.enabled and units[cbh.playerinfo.id] then
		cbh.playerinfo.power = units[cbh.playerinfo.id]
		local powercalc = (cbh.playerinfo.power / 100)
		local powertick = (-powercalc * cbhPlayerValues.fwidth + cbhPlayerValues.fwidth)
		cbh.PlayerPower:SetWidth(powertick)
	end
end


--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--			FRAME UPDATE ENERGY
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.PlayerUpdateEnergy(x, units)
	if cbhPlayerValues.enabled and units[cbh.playerinfo.id] then
		cbh.playerinfo.energy = units[cbh.playerinfo.id]
		local energycalc = (cbh.playerinfo.energy / cbh.playerinfo.energyMax)
		local energytick = (-energycalc * cbhPlayerValues.fwidth + cbhPlayerValues.fwidth)
		cbh.PlayerEnergy:SetWidth(energytick)
	end
end

function cbh.PlayerUpdateEnergyMax(hEvent, units)
	if cbhPlayerValues.enabled and units[cbh.playerinfo.id] then
		local tvalue = units[cbh.playerinfo.id]
		cbh.playerinfo.energyMax = tvalue
		local tempid = {[cbh.playerinfo.id] = cbh.playerinfo.energy}
		cbh.PlayerUpdateEnergy(x, tempid)
	end
end


--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--			FRAME UPDATE CHARGE
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.PlayerUpdateCharge(x, units)
	if cbhPlayerValues.enabled and units[cbh.playerinfo.id] then
		cbh.playerinfo.charge = units[cbh.playerinfo.id]
		local chargecalc = (cbh.playerinfo.charge / 100)
		local chargetick = (-chargecalc * cbhPlayerValues.fwidth + cbhPlayerValues.fwidth)
		cbh.PlayerCharge:SetWidth(chargetick)
	end
end

function cbh.PlayerUpdateChargeMax(hEvent, units)
	if cbhPlayerValues.enabled and units[cbh.playerinfo.id] then
		local tvalue = units[cbh.playerinfo.id]
		cbh.playerinfo.chargeMax = tvalue
		local tempid = {[cbh.playerinfo.id] = cbh.playerinfo.mana}
		cbh.PlayerUpdateCharge(x, tempid)
	end
end


--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--			FRAME UPDATE COMBOS
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.PlayerUpdateCombo(hEvent, units, c)
	if cbhPlayerValues.enabled and units[cbh.playerinfo.id] then
		local tvalue = units[cbh.playerinfo.id]
		cbh.playerinfo.combo = tvalue
		for i = 1, 5 do
			if cbh.playerinfo.combo >= i then
				cbh.PlayerCombo[i]:SetVisible(true)
			else
				cbh.PlayerCombo[i]:SetVisible(false)
			end
		end
	end
end


--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--			FRAME UPDATE LEVEL
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.PlayerUpdateLevel(hEvent, units)
	if cbhPlayerValues.enabled and units[cbh.playerinfo.id] then
		local tvalue = units[cbh.playerinfo.id]
		cbh.playerinfo.level = tvalue
		cbh.PlayerLevel:SetText(tostring(cbh.playerinfo.level))
	end
end


--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--		FRAME UPDATE RAID MARK
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.PlayerUpdateMark(hEvent, units)
	if cbhPlayerValues.enabled and units[cbh.playerinfo.id] ~= nil then
		if units[cbh.playerinfo.id] ~= false then
			local tvalue = units[cbh.playerinfo.id]
			cbh.PlayerRaidMark:SetVisible(true)
			cbh.PlayerRaidMark:SetTexture("Rift", cbh.RaidMarkerImages[tvalue])
		else
			cbh.PlayerRaidMark:SetVisible(false)
		end
	end
end


--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--		FRAME UPDATE MENTORING
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.PlayerMentored(hEvent, units)
	if cbhPlayerValues.enabled and units[cbh.playerinfo.id] then
		local tuid = cbh.unitDetail("player")
		cbh.playerinfo.health = tuid.health
		cbh.playerinfo.healthMax = tuid.healthMax
		cbh.playerinfo.manaMax = tuid.manaMax
	end
end


--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--	FRAME UPDATE PLANAR CHARGES
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.PlayerUpdatePlanar(hEvent, units)
	if cbhPlayerValues.enabled and units[cbh.playerinfo.id] then
		local tvalue = units[cbh.playerinfo.id]
		cbh.playerinfo.planar = tvalue
		cbh.PlayerPlanarChargeText:SetText(tostring(cbh.playerinfo.planar))
	end
end


--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--			FRAME UPDATE VITALITY
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.PlayerUpdateVitality(hEvent, units)
	if cbhPlayerValues.enabled and units[cbh.playerinfo.id] then
		local tvalue = units[cbh.playerinfo.id]
		cbh.playerinfo.vitality = tvalue
		cbh.PlayerVitalityText:SetText(cbh.playerinfo.vitality.."%")
	end
end


--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--			FRAME UPDATE PVP
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.PlayerUpdatePVP(hEvent, units)
	if cbhPlayerValues.enabled and units[cbh.playerinfo.id] ~= nil then
		local tvalue = units[cbh.playerinfo.id]
		cbh.playerinfo.pvp = tvalue
		if cbh.playerinfo.pvp and cbhPlayerValues.pvpalwaysshow then
			cbh.PlayerPvPMark:SetAlpha(1)
		else
			cbh.PlayerPvPMark:SetAlpha(0)
		end
	end
end


--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--			FRAME UPDATE ROLE
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.UnitRoleCheck(hEvent, units)
	if cbhPlayerValues.enabled and units[cbh.playerinfo.id] then
		local tvalue = units[cbh.playerinfo.id]
		cbh.PlayerRole:SetTexture("Rift", cbh.RoleImgs[tvalue])
	end
end



--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--				FRAME BUFF ADD
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.PlayerBuffAdding(hEvent, unit, buffs)
	if cbhPlayerValues.enabled and unit == cbh.playerinfo.id then
		if not cbh.PlayerBuffTable[unit] then 
			cbh.PlayerBuffTable[unit] = {}
		end
		if buffs ~= nil then
			for k in pairs(buffs) do
				local buffinfo = cbh.buffDetail(unit, k)
				if  buffinfo.caster == cbh.playerinfo.id and not buffinfo.debuff and buffinfo.remaining and buffinfo.remaining <= 31 then	-- had to make it 31 to actually catch 30 second buffs due to the long decimals making the remaining time greater than 30
					cbh.PlayerBuffTable[unit][buffinfo.id] = buffinfo
					-- cbh.playerinfo.buffcount = cbh.playerinfo.buffcount + 1
				end
			end
			-- for i = 1, cbh.playerinfo.buffcount do
			local tbcount = 0
			for i, v in pairs(cbh.PlayerBuffTable[unit]) do
				tbcount = tbcount + 1
				v.slot = tbcount
				-- if v.slot ~= v.oldslot or v.oldslot == nil then
				if tbcount <= cbhPlayerValues.buffcount and (v.slot ~= v.oldslot or v.oldslot == nil) then
					cbh.PlayerBuffs[tbcount]:SetTexture("Rift", v.icon)
					cbh.PlayerBuffs[tbcount]:SetVisible(true)
					cbh.PlayerBuffsCounter[tbcount]:SetVisible(true)
					cbh.PlayerBuffs[tbcount]:SetAlpha(1)
					cbh.PlayerBuffsCounter[tbcount]:SetAlpha(1)
					v.oldslot = v.slot
					if v.stack then
						cbh.PlayerBuffsStackCounter[tbcount]:SetVisible(true)
						cbh.PlayerBuffsStackCounter[tbcount]:SetAlpha(1)
						cbh.PlayerBuffsStackCounter[tbcount]:SetText(tostring(v.stack))
					else
						cbh.PlayerBuffsStackCounter[tbcount]:SetVisible(false)
					end
				end
			end
			cbh.playerinfo.buffcount = tbcount
			if cbh.playerinfo.buffcount < cbhPlayerValues.buffcount then
				-- print("BUFF CLEANUP")
				-- for i = cbh.playerinfo.buffcount + 1, cbhPlayerValues.buffcount do
				for i = cbhPlayerValues.buffcount, cbh.playerinfo.buffcount+1, -1 do
					cbh.PlayerBuffs[i]:SetVisible(false)
					cbh.PlayerBuffsCounter[i]:SetVisible(false)
					cbh.PlayerBuffsStackCounter[i]:SetVisible(false)
				end
			end
		end
	end
end


--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--			FRAME BUFF REMOVE
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.PlayerBuffRemoving(hEvent, unit, buffs)
	if cbhPlayerValues.enabled and unit == cbh.playerinfo.id then
		if cbh.PlayerBuffTable[unit] then
			for k, v in pairs(cbh.PlayerBuffTable[unit]) do
				if buffs[v.id] then
					-- table.remove(cbh.PlayerBuffTable[unit], v.slot)
					cbh.PlayerBuffTable[unit][v.id] = nil
					-- cbh.playerinfo.buffcount = cbh.playerinfo.buffcount - 1
				end
			end
			if cbh.playerinfo.buffcount == 0 then
				for i = 1, cbhPlayerValues.buffcount do
					cbh.PlayerBuffs[i]:SetVisible(false)
					cbh.PlayerBuffsCounter[i]:SetVisible(false)
				end
				cbh.PlayerBuffTable[unit] = nil
			else
				-- for i = 1, cbh.playerinfo.buffcount do
				local tbcount = 0
				for i, v in pairs(cbh.PlayerBuffTable[unit]) do
					tbcount = tbcount + 1
					v.slot = tbcount
					if tbcount <= cbhPlayerValues.buffcount and (v.slot ~= v.oldslot or v.oldslot == nil) then
						cbh.PlayerBuffs[tbcount]:SetTexture("Rift", v.icon)
						cbh.PlayerBuffs[tbcount]:SetVisible(true)
						cbh.PlayerBuffsCounter[tbcount]:SetVisible(true)
						cbh.PlayerBuffs[tbcount]:SetAlpha(1)
						cbh.PlayerBuffsCounter[tbcount]:SetAlpha(1)
						if v.stack then
							cbh.PlayerBuffsStackCounter[tbcount]:SetVisible(true)
							cbh.PlayerBuffsStackCounter[tbcount]:SetAlpha(1)
							cbh.PlayerBuffsStackCounter[tbcount]:SetText(tostring(v.stack))
						else
							cbh.PlayerBuffsStackCounter[tbcount]:SetVisible(false)
						end
						v.oldslot = v.slot
					end
				end
				cbh.playerinfo.buffcount = tbcount
				if cbh.playerinfo.buffcount < cbhPlayerValues.buffcount then
					-- print("BUFF CLEANUP")
					-- for i = cbh.playerinfo.buffcount + 1, cbhPlayerValues.buffcount do
					for i = cbhPlayerValues.buffcount, cbh.playerinfo.buffcount+1, -1 do
						cbh.PlayerBuffs[i]:SetVisible(false)
						cbh.PlayerBuffsCounter[i]:SetVisible(false)
						cbh.PlayerBuffsStackCounter[i]:SetVisible(false)
					end
				end
			end
		end
	end
end

local timeFrame = _G.Inspect.Time.Frame
local lastBuffUpdate = 0

function cbh.PlayerBuffThrottle(throttle)
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
function cbh.PlayerBuffWatch(hEvent)
	if cbhPlayerValues and cbhPlayerValues.enabled and cbh.playerinfo.buffcount > 0 then
		local timer = cbh.PlayerBuffThrottle(0.5)
		if not timer then return end
		
		local tid = cbh.playerinfo.id
		-- local tempbuffcount = 0
		for k, v in pairs(cbh.PlayerBuffTable[tid]) do
			if k and v and v.duration and v.begin then
				-- tempbuffcount = tempbuffcount + 1
				if v.slot and v.slot <= cbhPlayerValues.buffcount then
					-- if v.slot ~= v.oldslot then
						-- cbh.PlayerBuffs[v.slot]:SetTexture("Rift", v.icon)
						-- cbh.PlayerBuffs[v.slot]:SetVisible(true)
						-- cbh.PlayerBuffsCounter[v.slot]:SetVisible(true)
						-- v.visible = true
						-- v.oldslot = v.slot
						-- cbh.PlayerBuffs[v.slot]:SetAlpha(1)
						-- cbh.PlayerBuffsCounter[v.slot]:SetAlpha(1)
					-- end
					v.remaining = v.duration - (timeFrame() - v.begin)
					if v.remaining > 60 then
						-- v.remaining = cbh.round(v.remaining/60, 0)
						v.remaining = cbh.mceil(v.remaining/60)
						cbh.PlayerBuffsCounter[v.slot]:SetText(cbh.makestring(v.remaining).."m")
					else
						-- v.remaining = cbh.round(v.remaining, 0)
						v.remaining = cbh.mceil(v.remaining, 0.5)
						cbh.PlayerBuffsCounter[v.slot]:SetText(cbh.makestring(v.remaining))
						if v.remaining and v.remaining <= 0 then
							cbh.PlayerBuffs[v.slot]:SetAlpha(0)
							cbh.PlayerBuffsCounter[v.slot]:SetAlpha(0)
						-- elseif v.remaining and v.remaining > 0 and v.remaining < 3 then
						elseif v.remaining < 3 then
							cbh.PlayerBuffs[v.slot]:SetAlpha(-(cbh.PlayerBuffs[v.slot]:GetAlpha()))
							cbh.PlayerBuffsCounter[v.slot]:SetAlpha(-(cbh.PlayerBuffsCounter[v.slot]:GetAlpha()))
						-- else
							-- cbh.PlayerBuffs[v.slot]:SetAlpha(1)
							-- cbh.PlayerBuffsCounter[v.slot]:SetAlpha(1)
						end
					end
				end
			end
		end
	end
end


function cbh.PlayerBuffChanging(x, unit, buffs)
	if cbhPlayerValues.enabled and unit == cbh.playerinfo.id then
		if buffs ~= nil and cbh.PlayerBuffTable[unit] then
			for k, v in pairs(cbh.PlayerBuffTable[unit]) do
				if buffs[v.id] then
					local buffinfo = cbh.buffDetail(unit, k)
					if v.slot <= cbhPlayerValues.buffcount and buffinfo.caster == cbh.playerinfo.id and not buffinfo.debuff and buffinfo.stack then
						v.stack = buffinfo.stack
						cbh.PlayerBuffsStackCounter[v.slot]:SetText(tostring(buffinfo.stack))
					end
				end
			end
		end
	end
end



--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--				COMBAT HANDLING
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.PlayerCombatEnter()
	if cbhPlayerValues.enabled then
		cbh.PlayerCombat:SetVisible(true)
		if cbhPlayerValues.fadeooc then cbh.PlayerWindow:SetAlpha(1) end
	end
end


function cbh.PlayerCombatLeave()
	if cbhPlayerValues.enabled then
		cbh.PlayerCombat:SetVisible(false)
		if cbhPlayerValues.fadeooc and not cbh.UnitStatus["target"] then cbh.PlayerWindow:SetAlpha(0.1) end
	end
end




--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--				FRAME MOUSEOVER
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.PlayerMouseOver(unit)
	if cbhPlayerValues.enabled and unit == cbh.playerinfo.id then
		cbhplayerover = cbh.playerinfo.id
		if cbh.playerinfo.pvp then cbh.PlayerPvPMark:SetAlpha(1) end	-- show pvp flag in mouse over
		if cbhPlayerValues.fadeooc then cbh.PlayerWindow:SetAlpha(1) end
		if not cbhPlayerValues.planarchargealwaysshow then cbh.PlayerPlanarCharge:SetAlpha(1) cbh.PlayerPlanarChargeText:SetAlpha(1) end
		if not cbhPlayerValues.vitalityalwaysshow then cbh.PlayerVitality:SetAlpha(1) cbh.PlayerVitalityText:SetAlpha(1) end
	elseif cbhPlayerValues.enabled then
		if not cbhPlayerValues.pvpalwaysshow then cbh.PlayerPvPMark:SetAlpha(0) end
		if not cbhPlayerValues.planarchargealwaysshow then cbh.PlayerPlanarCharge:SetAlpha(0) cbh.PlayerPlanarChargeText:SetAlpha(0) end
		if not cbhPlayerValues.vitalityalwaysshow then cbh.PlayerVitality:SetAlpha(0) cbh.PlayerVitalityText:SetAlpha(0) end
		if cbhPlayerValues.fadeooc and not cbh.UnitStatus["target"] and not cbhValues.isincombat then cbh.PlayerWindow:SetAlpha(0.1) end
	end
end



--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--			FRAME COMMAND SETTINGS
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.PlayerToggle(t)
	if not t then
		cbhPlayerValues.enabled = true
		if not cbh.PlayerLoaded then cbh.PlayerFrameSetup() cbh.PlayerFrameUpdate() end
		cbh.PlayerWindow:SetVisible(true)
	else
		cbhPlayerValues.enabled = false
		cbh.PlayerWindow:SetVisible(false)
	end
end



--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--			COMMAND LINE OPTIONS
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.UnitSlashCommands(hEvent, p)
	-- p = parameters passed after cbhu
	if p == "ptoggle" then
		cbh.PlayerToggle(cbhPlayerValues.enabled)
	elseif p == "ttoggle" then
		cbh.TargetToggle(cbhTargetValues.enabled)
	elseif p == "rplayer" then
		cbhPlayerValues = nil
	elseif p == "rtarget" then
		cbhTargetValues = nil
	else
		print("----------------------------------------")
		print("CBH Unit Frames Help Menu")
		print("----------------------------------------")
		print("More options coming soon. \nUNIT FRAMES ARE IN BETA.\n")
		print("/cbhu ptoggle -- Toggles Player frame on/off")
		print("/cbhu ttoggle -- Toggles Target frame on/off")
		print("/cbhu rplayer -- Reset Player frame settings (REQUIRES RELOADUI)")
		print("/cbhu rtarget -- Reset Target frame settings (REQUIRES RELOADUI)")
		-- print("/cbh show	-- Show window")
		-- print("/cbh hide	-- Hide window")
		-- print("/cbh toggle	-- Toggles displaying main window")
		-- print("/cbh reset	-- Reset all settings AND clickbinds to default!")
		-- print("/cbh rbufflist	-- Reset tracked buffs")
		-- print("/cbh rbuffcolors	-- Reset all buff coloring to defaults")
		-- print("/cbh rcbhvalues	-- Reset location, texture, size, etc settings to defaults")
		-- print(" ")
		-- print("/cbh config  -- Display config window")
		-- print("/cbh lock -- Allows you to move the frame. Type again to lock")
		-- print("/cbh tt -- Toggles tooltips on frame mouseover")
	end
end


--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--	FRAME UPDATE FULL AVAILABLE
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.PlayerFill(x, units)
	if not cbh.PlayerLoaded and units[cbh.unitLookup("player")] then
		cbh.playerinfo = cbh.unitDetail("player")
		-- print(cbh.playerinfo.combo)
		cbh.PlayerFrameUpdate()
		-- after the player information has been loaded, detach will clear this event from the table
		Command.Event.Detach(Event.Unit.Availability.Full, cbh.PlayerFill, "PlayerFill")

		-- BUFF MONITORING
		Command.Event.Attach(Event.Buff.Add, cbh.PlayerBuffAdding, "PlayerBuffAdding")
		Command.Event.Attach(Event.Buff.Remove, cbh.PlayerBuffRemoving, "PlayerBuffRemoving")
		Command.Event.Attach(Event.Buff.Change, cbh.PlayerBuffChanging, "PlayerBuffRemoving")
		Command.Event.Attach(Event.System.Update.Begin, cbh.PlayerBuffWatch, "PlayerBuffWatch")
	end
end


-- UI.Native.PortraitPlayer

Command.Event.Attach(Command.Slash.Register("cbhu"), cbh.UnitSlashCommands, "SlashCommands")

Command.Event.Attach(Event.Addon.SavedVariables.Load.End, cbh.PlayerLoadSettings, "PlayerLoadSettings")
Command.Event.Attach(Event.Addon.Startup.End, cbh.PlayerFrameSetup, "PlayerFrameSetup")
Command.Event.Attach(Event.Unit.Availability.Full, cbh.PlayerFill, "PlayerFill")

Command.Event.Attach(Event.System.Secure.Enter, cbh.PlayerCombatEnter, "PlayerCombatEnter")
Command.Event.Attach(Event.System.Secure.Leave, cbh.PlayerCombatLeave, "PlayerCombatLeave")

Command.Event.Attach(Event.Unit.Detail.Health, cbh.PlayerUpdateHP, "PlayerUpdateHP")
Command.Event.Attach(Event.Unit.Detail.HealthMax, cbh.PlayerUpdateHPMax, "PlayerUpdateHPMax")
Command.Event.Attach(Event.Unit.Detail.Mana, cbh.PlayerUpdateMana, "UpdateMana")
Command.Event.Attach(Event.Unit.Detail.ManaMax, cbh.PlayerUpdateManaMax, "UpdateManaMax")
Command.Event.Attach(Event.Unit.Detail.Power, cbh.PlayerUpdatePower, "PlayerUpdatePower")
Command.Event.Attach(Event.Unit.Detail.Energy, cbh.PlayerUpdateEnergy, "PlayerUpdateEnergy")
Command.Event.Attach(Event.Unit.Detail.EnergyMax, cbh.PlayerUpdateEnergyMax, "PlayerUpdateEnergyMax")
Command.Event.Attach(Event.Unit.Detail.Combo, cbh.PlayerUpdateCombo, "PlayerUpdateCombo")

Command.Event.Attach(Event.Unit.Detail.Charge, cbh.PlayerUpdateCharge, "UpdateCharge")
Command.Event.Attach(Event.Unit.Detail.ChargeMax, cbh.PlayerUpdateChargeMax, "UpdateChargeMax")
Command.Event.Attach(Event.Unit.Detail.Level, cbh.PlayerUpdateLevel, "PlayerUpdateLevel")
Command.Event.Attach(Event.Unit.Detail.Mark, cbh.PlayerUpdateMark, "PlayerUpdateMark")
Command.Event.Attach(Event.Unit.Detail.Planar, cbh.PlayerUpdatePlanar, "PlayerUpdatePlanar")
Command.Event.Attach(Event.Unit.Detail.Vitality, cbh.PlayerUpdateVitality, "PlayerUpdateVitality")
Command.Event.Attach(Event.Unit.Detail.Mentoring, cbh.PlayerMentored, "PlayerMentored")
Command.Event.Attach(Event.Unit.Detail.Role, cbh.UnitRoleCheck, "UpdateRole")
Command.Event.Attach(Event.Unit.Detail.Pvp, cbh.PlayerUpdatePVP, "UpdateRole")

table.insert(Library.LibUnitChange.Register("mouseover"), {cbh.PlayerMouseOver, "ClickBoxHealer", "cbhOnUnitMouseOver"}) -- create a mouseover event


-- add a check for Event.Combat.Death instead of that last calculation to make it zero