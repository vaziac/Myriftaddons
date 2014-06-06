--[[
file: optionWindow.lua
by: Solsis00
for: ClickBoxHealer

This file houses the configuration window for CBH.

**COMPLETE: Converted to local cbh table successfully.
]]--


local addon, cbh = ...


--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--			PLAYER CONFIG CREATION
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.PlayerConfigCreate()
	cbh.PlayerConfig = UI.CreateFrame("SimpleTabView", "OptionsWindowFrame", cbh.WindowOptions)
	cbh.PlayerConfigA = UI.CreateFrame("Frame", "PlayerConfigA", cbh.PlayerConfig)
	-- cbh.PlayerConfigB = UI.CreateFrame("Frame", "PlayerConfigA", cbh.PlayerConfig)
	-- cbh.PlayerConfigC = UI.CreateFrame("Frame", "PlayerConfigC", cbh.PlayerConfig)
	cbh.PlayerConfig:AddTab("Basics", cbh.PlayerConfigA)
	-- cbh.PlayerConfig:AddTab("Appearance", cbh.PlayerConfigB)
	-- cbh.PlayerConfig:AddTab("Positioning", cbh.PlayerConfigC)
	
	

	--[[ BASICS TAB ]]--
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.PlayerFrameToggle = UI.CreateFrame("SimpleCheckbox", "PlayerFrameToggle", cbh.PlayerConfigA)
	cbh.PlayerFadeOOC = UI.CreateFrame("SimpleCheckbox", "PlayerFadeOOC", cbh.PlayerConfigA)

	

	--[[ APPEARANCES TAB ]]--
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.PlayerTextureText = UI.CreateFrame("Text", "PlayerTextureText", cbh.PlayerConfigA)
	cbh.PlayerTexture = UI.CreateFrame("SimpleSelect", "PlayerTexture", cbh.PlayerConfigA)
	cbh.PlayerTextureDup = UI.CreateFrame("SimpleCheckbox", "PlayerTextureDup", cbh.PlayerConfigA)

	-- CUSTOM COLOR SELECTIONS
	cbh.PlayerPieces = {"Healthbar", "Health backdrop", "Manabar", "Name", "Percentage"}
	cbh.PlayerColorOptions = UI.CreateFrame("Frame", "PlayerColorOptions", cbh.PlayerConfigA)
	cbh.PlayerColorOptionsText = UI.CreateFrame("Text", "PlayerColorOptionsText", cbh.PlayerConfigA)
	cbh.PlayerColorPieces = UI.CreateFrame("SimpleList", "PlayerColorPiecesList", cbh.PlayerConfigA)
	cbh.PlayerClassColor = UI.CreateFrame("SimpleCheckbox", "PlayerClassColor", cbh.PlayerConfigA)
	cbh.PlayerGradients = UI.CreateFrame("SimpleCheckbox", "PlayerGradients", cbh.PlayerConfigA)
	
	-- CUSTOM COLOR SLIDERS
	cbh.PlayerColorSliderR = UI.CreateFrame("SimpleSlider", "PlayerColorSliderR", cbh.PlayerConfigA)
	cbh.PlayerColorSliderG = UI.CreateFrame("SimpleSlider", "PlayerColorSliderG", cbh.PlayerConfigA)
	cbh.PlayerColorSliderB = UI.CreateFrame("SimpleSlider", "PlayerColorSliderB", cbh.PlayerConfigA)
	cbh.PlayerColorSliderA = UI.CreateFrame("SimpleSlider", "PlayerColorSliderA", cbh.PlayerConfigA)
	cbh.PlayerColorSliderText = UI.CreateFrame("Text", "TextCallingColor", cbh.PlayerConfigA)

	

	--[[ POSITIONING TAB ]]--
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.PlayerPositionList = {"Healthbar", "Manabar", "Name", "Level", "Percentage","Role Icon", "Raid Mark", "PvP Mark", "Combat Icon", "Planar Charges", "Vitality", "Buffs"}
	cbh.PlayerPositionPieces = UI.CreateFrame("SimpleList", "PlayerColorPiecesList", cbh.PlayerConfigA)

	cbh.PlayerHealthbarOptions = UI.CreateFrame("Frame", "PlayerHealthbarOptions", cbh.PlayerConfigA)
	cbh.PlayerHealthbarLocationText = UI.CreateFrame("Text", "HealthbarLocationText", cbh.PlayerHealthbarOptions)
	cbh.PlayerHealthbarSizerW = UI.CreateFrame("SimpleSlider", "PlayerHealthbarSizerW", cbh.PlayerHealthbarOptions)
	cbh.PlayerHealthbarSizerH = UI.CreateFrame("SimpleSlider", "PlayerHealthbarSizerH", cbh.PlayerHealthbarOptions)

	cbh.PlayerManabarOptions = UI.CreateFrame("Frame", "PlayerManabarOptions", cbh.PlayerConfigA)
	cbh.PlayerManabarLocationText = UI.CreateFrame("Text", "ManabarLocationText", cbh.PlayerManabarOptions)
	cbh.PlayerManabarSizerH = UI.CreateFrame("SimpleSlider", "PlayerManabarSizer", cbh.PlayerManabarOptions)

	cbh.PlayerNameOptions = UI.CreateFrame("Frame", "PlayerNameOptions", cbh.PlayerConfigA)
	cbh.PlayerNameLocation = UI.CreateFrame("SimpleSelect", "NameLocation", cbh.PlayerNameOptions)
	cbh.PlayerNameLocationText = UI.CreateFrame("Text", "NameLocationText", cbh.PlayerNameOptions)
	cbh.PlayerNameLengthOption = UI.CreateFrame("SimpleCheckbox", "NameLengthOption", cbh.PlayerNameOptions)
	cbh.PlayerNameLength = UI.CreateFrame("SimpleSlider", "NameLength", cbh.PlayerNameOptions)
	cbh.PlayerNameFontSizer = UI.CreateFrame("SimpleSlider", "PlayerNameFontSizer", cbh.PlayerNameOptions)
	cbh.PlayerNameOffsetText = UI.CreateFrame("Text", "PlayerNameOffsetX", cbh.PlayerNameOptions)
	cbh.PlayerNameOffsetX = UI.CreateFrame("SimpleSlider", "PlayerNameOffsetX", cbh.PlayerNameOptions)
	cbh.PlayerNameOffsetY = UI.CreateFrame("SimpleSlider", "PlayerNameOffsetY", cbh.PlayerNameOptions)

	cbh.PlayerLevelOptions = UI.CreateFrame("Frame", "PlayerLevelOptions", cbh.PlayerConfigA)
	cbh.PlayerLevelLocationText = UI.CreateFrame("Text", "LevelLocationText", cbh.PlayerLevelOptions)
	cbh.PlayerLevelSizer = UI.CreateFrame("SimpleSlider", "PlayerLevelSizer", cbh.PlayerLevelOptions)
	cbh.PlayerLevelLocation = UI.CreateFrame("SimpleSelect", "LevelLocation", cbh.PlayerLevelOptions)
	cbh.PlayerLevelOffsetText = UI.CreateFrame("Text", "PlayerLevelOffsetX", cbh.PlayerLevelOptions)
	cbh.PlayerLevelOffsetX = UI.CreateFrame("SimpleSlider", "PlayerLevelOffsetX", cbh.PlayerLevelOptions)
	cbh.PlayerLevelOffsetY = UI.CreateFrame("SimpleSlider", "PlayerLevelOffsetY", cbh.PlayerLevelOptions)

	cbh.PlayerPercentOptions = UI.CreateFrame("Frame", "PlayerPercentOptions", cbh.PlayerConfigA)
	cbh.PlayerPercentLocationText = UI.CreateFrame("Text", "PercentLocationText", cbh.PlayerPercentOptions)
	cbh.PlayerPercentToggle = UI.CreateFrame("SimpleCheckbox", "PlayerPercentToggle", cbh.PlayerPercentOptions)
	cbh.PlayerPercentSizer = UI.CreateFrame("SimpleSlider", "PlayerPercentSizer", cbh.PlayerPercentOptions)
	cbh.PlayerPercentLocation = UI.CreateFrame("SimpleSelect", "PercentLocation", cbh.PlayerPercentOptions)
	cbh.PlayerPercentOffsetText = UI.CreateFrame("Text", "PlayerPercentOffsetX", cbh.PlayerPercentOptions)
	cbh.PlayerPercentOffsetX = UI.CreateFrame("SimpleSlider", "PlayerPercentOffsetX", cbh.PlayerPercentOptions)
	cbh.PlayerPercentOffsetY = UI.CreateFrame("SimpleSlider", "PlayerPercentOffsetY", cbh.PlayerPercentOptions)

	cbh.PlayerRoleOptions = UI.CreateFrame("Frame", "PlayerRoleOptions", cbh.PlayerConfigA)
	cbh.PlayerRoleLocationText = UI.CreateFrame("Text", "RoleLocationText", cbh.PlayerRoleOptions)
	cbh.PlayerRoleToggle = UI.CreateFrame("SimpleCheckbox", "PlayerRoleToggle", cbh.PlayerRoleOptions)
	cbh.PlayerRoleSizer = UI.CreateFrame("SimpleSlider", "PlayerRoleSizer", cbh.PlayerRoleOptions)
	cbh.PlayerRoleLocation = UI.CreateFrame("SimpleSelect", "RoleLocation", cbh.PlayerRoleOptions)
	cbh.PlayerRoleOffsetText = UI.CreateFrame("Text", "PlayerRoleOffsetX", cbh.PlayerRoleOptions)
	cbh.PlayerRoleOffsetX = UI.CreateFrame("SimpleSlider", "PlayerRoleOffsetX", cbh.PlayerRoleOptions)
	cbh.PlayerRoleOffsetY = UI.CreateFrame("SimpleSlider", "PlayerRoleOffsetY", cbh.PlayerRoleOptions)

	cbh.PlayerRaidMarkOptions = UI.CreateFrame("Frame", "PlayerRaidMarkOptions", cbh.PlayerConfigA)
	cbh.PlayerRaidMarkLocationText = UI.CreateFrame("Text", "RaidMarkLocationText", cbh.PlayerRaidMarkOptions)
	cbh.PlayerRaidMarkSizer = UI.CreateFrame("SimpleSlider", "PlayerRaidMarkSizer", cbh.PlayerRaidMarkOptions)
	cbh.PlayerRaidMarkLocation = UI.CreateFrame("SimpleSelect", "RaidMarkLocation", cbh.PlayerRaidMarkOptions)
	cbh.PlayerRaidMarkOffsetText = UI.CreateFrame("Text", "PlayerRaidMarkOffsetX", cbh.PlayerRaidMarkOptions)
	cbh.PlayerRaidMarkOffsetX = UI.CreateFrame("SimpleSlider", "PlayerRaidMarkOffsetX", cbh.PlayerRaidMarkOptions)
	cbh.PlayerRaidMarkOffsetY = UI.CreateFrame("SimpleSlider", "PlayerRaidMarkOffsetY", cbh.PlayerRaidMarkOptions)

	cbh.PlayerPvPMarkOptions = UI.CreateFrame("Frame", "PlayerPvPMarkOptions", cbh.PlayerConfigA)
	cbh.PlayerPvPMarkLocationText = UI.CreateFrame("Text", "PvPMarkLocationText", cbh.PlayerPvPMarkOptions)
	cbh.PlayerPvPMarkToggle = UI.CreateFrame("SimpleCheckbox", "PlayerPvPMarkToggle", cbh.PlayerPvPMarkOptions)
	cbh.PlayerPvPMarkSizer = UI.CreateFrame("SimpleSlider", "PlayerPvPMarkSizer", cbh.PlayerPvPMarkOptions)
	cbh.PlayerPvPMarkLocation = UI.CreateFrame("SimpleSelect", "PvPMarkLocation", cbh.PlayerPvPMarkOptions)
	cbh.PlayerPvPMarkOffsetText = UI.CreateFrame("Text", "PlayerPvPMarkOffsetText", cbh.PlayerPvPMarkOptions)
	cbh.PlayerPvPMarkOffsetX = UI.CreateFrame("SimpleSlider", "PlayerPvPMarkOffsetX", cbh.PlayerPvPMarkOptions)
	cbh.PlayerPvPMarkOffsetY = UI.CreateFrame("SimpleSlider", "PlayerPvPMarkOffsetY", cbh.PlayerPvPMarkOptions)

	cbh.PlayerCombatOptions = UI.CreateFrame("Frame", "PlayerCombatOptions", cbh.PlayerConfigA)
	cbh.PlayerCombatLocationText = UI.CreateFrame("Text", "CombatLocationText", cbh.PlayerCombatOptions)
	cbh.PlayerCombatSizer = UI.CreateFrame("SimpleSlider", "PlayerCombatSizer", cbh.PlayerCombatOptions)
	cbh.PlayerCombatLocation = UI.CreateFrame("SimpleSelect", "CombatLocation", cbh.PlayerCombatOptions)
	cbh.PlayerCombatOffsetText = UI.CreateFrame("Text", "PlayerCombatOffsetText", cbh.PlayerCombatOptions)
	cbh.PlayerCombatOffsetX = UI.CreateFrame("SimpleSlider", "PlayerCombatOffsetX", cbh.PlayerCombatOptions)
	cbh.PlayerCombatOffsetY = UI.CreateFrame("SimpleSlider", "PlayerCombatOffsetY", cbh.PlayerCombatOptions)

	cbh.PlayerPlanarChargeOptions = UI.CreateFrame("Frame", "PlayerPlanarChargeOptions", cbh.PlayerConfigA)
	cbh.PlayerPlanarChargeLocationText = UI.CreateFrame("Text", "PlanarChargesLocationText", cbh.PlayerPlanarChargeOptions)
	cbh.PlayerPlanarChargeToggle = UI.CreateFrame("SimpleCheckbox", "PlayerPlanarChargesToggle", cbh.PlayerPlanarChargeOptions)
	cbh.PlayerPlanarChargeSizer = UI.CreateFrame("SimpleSlider", "PlayerPlanarChargesSizer", cbh.PlayerPlanarChargeOptions)
	cbh.PlayerPlanarChargeLocation = UI.CreateFrame("SimpleSelect", "PlanarChargesLocation", cbh.PlayerPlanarChargeOptions)
	cbh.PlayerPlanarChargeOffsetText = UI.CreateFrame("Text", "PlayerPlanarChargesOffsetText", cbh.PlayerPlanarChargeOptions)
	cbh.PlayerPlanarChargeOffsetX = UI.CreateFrame("SimpleSlider", "PlayerPlanarChargesOffsetX", cbh.PlayerPlanarChargeOptions)
	cbh.PlayerPlanarChargeOffsetY = UI.CreateFrame("SimpleSlider", "PlayerPlanarChargesOffsetY", cbh.PlayerPlanarChargeOptions)

	cbh.PlayerVitalityOptions = UI.CreateFrame("Frame", "PlayerVitalityOptions", cbh.PlayerConfigA)
	cbh.PlayerVitalityLocationText = UI.CreateFrame("Text", "VitalityLocationText", cbh.PlayerVitalityOptions)
	cbh.PlayerVitalityToggle = UI.CreateFrame("SimpleCheckbox", "PlayerVitalityToggle", cbh.PlayerVitalityOptions)
	cbh.PlayerVitalitySizer = UI.CreateFrame("SimpleSlider", "PlayerVitalitySizer", cbh.PlayerVitalityOptions)
	cbh.PlayerVitalityLocation = UI.CreateFrame("SimpleSelect", "VitalityLocation", cbh.PlayerVitalityOptions)
	cbh.PlayerVitalityOffsetText = UI.CreateFrame("Text", "PlayerVitalityOffsetText", cbh.PlayerVitalityOptions)
	cbh.PlayerVitalityOffsetX = UI.CreateFrame("SimpleSlider", "PlayerVitalityOffsetX", cbh.PlayerVitalityOptions)
	cbh.PlayerVitalityOffsetY = UI.CreateFrame("SimpleSlider", "PlayerVitalityOffsetY", cbh.PlayerVitalityOptions)

	-- buff setup
	cbh.PlayerBuffOptions = UI.CreateFrame("Frame", "PlayerBuffOptions", cbh.PlayerConfigA)
	cbh.PlayerBuffLocationText = UI.CreateFrame("Text", "BuffLocationText", cbh.PlayerBuffOptions)
	cbh.PlayerBuffReverseToggle = UI.CreateFrame("SimpleCheckbox", "PlayerBuffReverseToggle", cbh.PlayerBuffOptions)
	cbh.PlayerBuffSizerText = UI.CreateFrame("Text", "PlayerBuffSizerText", cbh.PlayerBuffOptions)
	cbh.PlayerBuffSizer = UI.CreateFrame("SimpleSlider", "PlayerBuffSizer", cbh.PlayerBuffOptions)
	cbh.PlayerBuffLocation = UI.CreateFrame("SimpleCheckbox", "BuffLocation", cbh.PlayerBuffOptions)
	cbh.PlayerBuffOffsetText = UI.CreateFrame("Text", "PlayerBuffOffsetText", cbh.PlayerBuffOptions)
	-- cbh.PlayerBuffOffsetX = UI.CreateFrame("SimpleSlider", "PlayerBuffOffsetX", cbh.PlayerBuffOptions)
	cbh.PlayerBuffOffsetY = UI.CreateFrame("SimpleSlider", "PlayerBuffOffsetY", cbh.PlayerBuffOptions)
end


--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--			PLAYER CONFIG SETUP
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.PlayerConfigSetup()
	if cbhValues.isincombat then return end

	-- Calls the creation of the frames objects
	cbh.PlayerConfigCreate()
	
	-- Player option window
	cbh.PlayerConfig:SetPoint("TOPLEFT", cbh.WindowOptions, "TOPLEFT", 15, 20)
	cbh.PlayerConfig:SetPoint("BOTTOMRIGHT", cbh.WindowOptions, "BOTTOMRIGHT", -15, -15)
	cbh.PlayerConfig:SetBackgroundColor(0, 0, 0, 0)
	cbh.PlayerConfig:SetTabContentBackgroundColor(0, 0, 0, 0.6)
	cbh.PlayerConfig:SetActiveTabBackgroundColor(0.1, 0.3, 0.1, 0.9)
	cbh.PlayerConfig:SetInactiveTabBackgroundColor(0, 0, 0, 0.75)
	cbh.PlayerConfig:SetActiveFontColor(0.75, 0.75, 0.75, 1)
	cbh.PlayerConfig:SetInactiveFontColor(0.2, 0.2, 0.2, 0.3)
	cbh.PlayerConfig:SetVisible(false)

	cbh.PlayerBasicTab()
	cbh.PlayerAppearanceTab()
	cbh.PlayerPositioningTab()
	
	cbhPlayerConfigSetup = true
end



--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--			PLAYER CONFIG BASIC TAB
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.PlayerBasicTab()
	cbh.PlayerFrameToggle:SetPoint("TOPLEFT", cbh.WindowOptionsA, "TOPLEFT", 10, 10)
	cbh.PlayerFrameToggle:SetLayer(2)
	cbh.PlayerFrameToggle:SetText("Show Player Frame (beta)")
	cbh.PlayerFrameToggle:SetFontSize(14)
	cbh.PlayerFrameToggle:SetChecked(cbhPlayerValues.enabled == true)
	function cbh.PlayerFrameToggle.Event.CheckboxChange()
		cbh.PlayerToggle(cbhPlayerValues.enabled)	-- found in cbhplayer file
	end

	cbh.PlayerFadeOOC:SetPoint("TOPLEFT", cbh.WindowOptionsA, "TOPLEFT", 10, 40)
	cbh.PlayerFadeOOC:SetLayer(2)
	cbh.PlayerFadeOOC:SetText("Fade out of combat")
	cbh.PlayerFadeOOC:SetFontSize(14)
	cbh.PlayerFadeOOC:SetChecked(cbhPlayerValues.fadeooc == true)
	function cbh.PlayerFadeOOC.Event.CheckboxChange()
		cbhPlayerValues.fadeooc = cbh.PlayerFadeOOC:GetChecked()
		if not cbhValues.isincombat then
			if cbhPlayerValues.fadeooc and not cbh.UnitStatus["target"] then
				cbh.PlayerWindow:SetAlpha(0.1)
			else
				cbh.PlayerWindow:SetAlpha(1)
			end
		end
	end
end



--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--			PLAYER CONFIG VISUALS TAB
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.PlayerAppearanceTab()
	cbhPlayerTempColors = {}
	for i = 1, 5 do
		cbhPlayerTempColors[i] = {}
		cbhPlayerTempColors[i].r = cbhPlayerValues["Colors"][i].r
		cbhPlayerTempColors[i].g = cbhPlayerValues["Colors"][i].g
		cbhPlayerTempColors[i].b = cbhPlayerValues["Colors"][i].b
		cbhPlayerTempColors[i].a = cbhPlayerValues["Colors"][i].a
	end
	

	-- COLORING LIST
	cbh.PlayerColorPieces:SetPoint("TOPLEFT", cbh.PlayerConfigA, "TOPLEFT", 10, 70)
	cbh.PlayerColorPieces:SetWidth(140)
	cbh.PlayerColorPieces:SetFontSize(15)
	cbh.PlayerColorPieces:SetBorder(1, 1, 1, 1, 0)
	cbh.PlayerColorPieces:SetItems(cbh.PlayerPieces)
	cbh.PlayerColorPieces:SetSelectedIndex(1)
	local cbhcolorindex = 1
	
	
	--[[ PLAYER COLOR OPTIONS ]]
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.PlayerColorOptions:SetPoint("TOPLEFT", cbh.PlayerColorPieces, "TOPRIGHT", 10, 0)
	cbh.PlayerColorOptions:SetBackgroundColor(.25, .25, .25, .5)
	cbh.PlayerColorOptions:SetWidth(300)
	cbh.PlayerColorOptions:SetHeight(200)
	cbh.PlayerColorOptions:SetLayer(0)
	-- cbh.PlayerColorOptions:SetVisible(false)
	
	cbh.PlayerColorOptionsText:SetPoint("TOPLEFT", cbh.PlayerColorOptions, "TOPLEFT", 5, 0)
	cbh.PlayerColorOptionsText:SetFontSize(15)
	cbh.PlayerColorOptionsText:SetText("Player Color Options")

	
	
	
	-- TEXTURE SELECTION OPTIONS
	cbh.PlayerTextureText:SetPoint("TOPLEFT", cbh.PlayerColorPieces, "BOTTOMLEFT", 0, 30)
	cbh.PlayerTextureText:SetFontSize(14)
	cbh.PlayerTextureText:SetFontColor(1,1,1,1)
	cbh.PlayerTextureText:SetText("Player Texture")
	
	cbh.PlayerTexture:SetPoint("TOPLEFT", cbh.PlayerTextureText, "TOPLEFT", 0, 30)
	cbh.PlayerTexture:SetItems(cbh.GlobalTextures)
	cbh.PlayerTexture:SetSelectedItem(cbhPlayerValues.texture, silent)
	cbh.PlayerTexture:SetWidth(140)
	cbh.PlayerTexture.Event.ItemSelect = function(view, item)
		cbhPlayerValues.texture = item
		if cbhPlayerValues.enabled then
			cbh.PlayerFrame:SetTexture("ClickBoxHealer", "Textures/"..cbhPlayerValues.texture)
			cbh.PlayerManaFrame:SetTexture("ClickBoxHealer", "Textures/"..cbhPlayerValues.texture)
		end
		if cbhPlayerValues.texturedup then 
			cbhTargetValues.texture = item
			if cbhTargetValues.enabled then
				cbh.TargetFrame:SetTexture("ClickBoxHealer", "Textures/"..cbhTargetValues.texture)
				-- cbh.TargetManaFrame:SetTexture("ClickBoxHealer", "Textures/"..cbhTargetValues.texture)
			end
		end
	end
	
	
	-- DUPLICATE TEXTURE TO TARGETFRAME
	-- cbh.PlayerTextureDup:SetPoint("TOPLEFT", cbh.PlayerTextureText, "TOPLEFT", 0, 60)
	-- cbh.PlayerTextureDup:SetLayer(2)
	-- cbh.PlayerTextureDup:SetText("Same for player/target")
	-- cbh.PlayerTextureDup:SetFontSize(14)
	-- cbh.PlayerTextureDup:SetChecked(cbhPlayerValues.texturedup == true)
	-- function cbh.PlayerTextureDup.Event.CheckboxChange()
		-- cbhPlayerValues.texturedup = cbh.PlayerTextureDup:GetChecked()
		-- if cbhPlayerValues.texturedup then
			-- if cbhPlayerValues.enabled then cbh.PlayerFrame:SetTexture("ClickBoxHealer", "Textures/"..cbhPlayerValues.texture) end
			-- cbhTargetValues.texture = cbh.PlayerTexture:GetSelectedItem()
			-- if cbhTargetValues.enabled then cbh.TargetFrame:SetTexture("ClickBoxHealer", "Textures/"..cbhTargetValues.texture) end
		-- end
	-- end
	

	-- SET CLASS COLOR TO OBJECTS
	cbh.PlayerClassColor:SetPoint("TOPLEFT", cbh.PlayerColorOptionsText, "TOPLEFT", 0, 30)
	cbh.PlayerClassColor:SetLayer(2)
	cbh.PlayerClassColor:SetText("Class Color Item")
	cbh.PlayerClassColor:SetFontSize(14)
	cbh.PlayerClassColor:SetChecked(cbhPlayerValues["Colors"][1].classcolor == true)
	cbh.PlayerClassColor:SetVisible(false)
	function cbh.PlayerClassColor.Event.CheckboxChange()
		cbhPlayerValues["Colors"][cbhcolorindex].classcolor = cbh.PlayerClassColor:GetChecked()
		if cbhcolorindex == 3 then
			if cbhPlayerValues["Colors"][3].classcolor then
				cbh.PlayerManaFrame:SetBackgroundColor(cbh.ClassColors[cbh.playerinfo.calling].r, cbh.ClassColors[cbh.playerinfo.calling].g, cbh.ClassColors[cbh.playerinfo.calling].b, cbhPlayerValues["Colors"][3].a)
			else
				cbh.PlayerManaFrame:SetBackgroundColor(cbhPlayerTempColors[3].r, cbhPlayerTempColors[3].g, cbhPlayerTempColors[3].b, cbhPlayerTempColors[3].a)
			end
		elseif cbhcolorindex == 4 then
			if cbhPlayerValues["Colors"][4].classcolor then
				cbh.PlayerName:SetFontColor(cbh.ClassColors[cbh.playerinfo.calling].r, cbh.ClassColors[cbh.playerinfo.calling].g, cbh.ClassColors[cbh.playerinfo.calling].b, cbhPlayerValues["Colors"][4].a)
			else
				cbh.PlayerName:SetFontColor(cbhPlayerTempColors[4].r, cbhPlayerTempColors[4].g, cbhPlayerTempColors[4].b, cbhPlayerTempColors[4].a)
			end
		end
	end

	-- SET % GRADIENT TO COLOR
	cbh.PlayerGradients:SetPoint("TOPLEFT", cbh.PlayerClassColor, "TOPRIGHT", 20, 0)
	cbh.PlayerGradients:SetLayer(2)
	cbh.PlayerGradients:SetText("Gradient Color Item")
	cbh.PlayerGradients:SetFontSize(14)
	cbh.PlayerGradients:SetChecked(cbhPlayerValues["Colors"][1].gradient == true)
	function cbh.PlayerGradients.Event.CheckboxChange()
		if cbhcolorindex == 1 then
			cbhPlayerValues["Colors"][1].gradient = cbh.PlayerGradients:GetChecked()
			if cbhPlayerValues["Colors"][1].gradient == false then
				cbh.PlayerFrame:SetBackgroundColor(cbhPlayerTempColors[1].r, cbhPlayerTempColors[1].g, cbhPlayerTempColors[1].b, cbhPlayerTempColors[1].a)
			end
		end
	end
	
	
	-- Color sliders for various pieces of the unit frame
	cbh.PlayerColorSliderText:SetPoint("TOPLEFT", cbh.PlayerColorOptionsText, "TOPLEFT", 0, 60)
	cbh.PlayerColorSliderText:SetText("Player Frame Color Options.  r, g, b")
	cbh.PlayerColorSliderText:SetFontSize(14)
	cbh.PlayerColorSliderText:SetLayer(2)

	cbh.PlayerColorSliderR:SetPoint("TOPLEFT", cbh.PlayerColorSliderText, "BOTTOMLEFT", 0, 0)
	cbh.PlayerColorSliderR:SetRange(0, 100)
	cbh.PlayerColorSliderR:SetPosition(math.floor((cbhPlayerTempColors[cbhcolorindex].r * 100) + 0.5))

	cbh.PlayerColorSliderG:SetPoint("TOPLEFT", cbh.PlayerColorSliderR, "BOTTOMLEFT", 0, 5)
	cbh.PlayerColorSliderG:SetRange(0, 100)
	cbh.PlayerColorSliderG:SetPosition(math.floor((cbhPlayerTempColors[cbhcolorindex].g * 100) + 0.5))

	cbh.PlayerColorSliderB:SetPoint("TOPLEFT", cbh.PlayerColorSliderG, "BOTTOMLEFT", 0, 5)
	cbh.PlayerColorSliderB:SetRange(0, 100)
	cbh.PlayerColorSliderB:SetPosition(math.floor((cbhPlayerTempColors[cbhcolorindex].b * 100) + 0.5))

	cbh.PlayerColorSliderA:SetPoint("TOPLEFT", cbh.PlayerColorSliderB, "BOTTOMLEFT", 0, 5)
	cbh.PlayerColorSliderA:SetRange(0, 100)
	cbh.PlayerColorSliderA:SetPosition(math.floor((cbhPlayerTempColors[cbhcolorindex].a * 100) + 0.5))

	local function SetSliderPositions()
		-- if not cbhPlayerValues["Colors"][cbhcolorindex].classcolor then
			cbh.PlayerColorSliderR:SetPosition(math.floor((cbhPlayerTempColors[cbhcolorindex].r * 100) + 0.5))
			cbh.PlayerColorSliderG:SetPosition(math.floor((cbhPlayerTempColors[cbhcolorindex].g * 100) + 0.5))
			cbh.PlayerColorSliderB:SetPosition(math.floor((cbhPlayerTempColors[cbhcolorindex].b * 100) + 0.5))
		-- end
		cbh.PlayerColorSliderA:SetPosition(math.floor((cbhPlayerTempColors[cbhcolorindex].a * 100) + 0.5))
	end
	
	
	cbh.PlayerColorPieces.Event.ItemSelect = function(view, item, value, index)
	-- "Healthbar", "Health backdrop", "Manabar", "Name", "Percentage"
		if index == nil then index = 1 end
		if index == 1 then
			cbhcolorindex = index
			cbh.PlayerClassColor:SetChecked(cbhPlayerValues["Colors"][cbhcolorindex].classcolor == true)
			cbh.PlayerColorSliderA:SetVisible(true)
			SetSliderPositions()
		elseif index == 2 then
			cbhcolorindex = index
			cbh.PlayerClassColor:SetChecked(cbhPlayerValues["Colors"][cbhcolorindex].classcolor == true)
			cbh.PlayerColorSliderA:SetVisible(true)
			SetSliderPositions()
		elseif index == 3 then
			cbhcolorindex = index
			cbh.PlayerClassColor:SetChecked(cbhPlayerValues["Colors"][cbhcolorindex].classcolor == true)
			cbh.PlayerColorSliderA:SetVisible(true)
			SetSliderPositions()
		elseif index == 4 then
			cbhcolorindex = index
			cbh.PlayerClassColor:SetChecked(cbhPlayerValues["Colors"][cbhcolorindex].classcolor == true)
			SetSliderPositions()
			cbh.PlayerColorSliderA:SetVisible(false)
		elseif index == 5 then
			cbhcolorindex = index
			cbh.PlayerClassColor:SetChecked(cbhPlayerValues["Colors"][cbhcolorindex].classcolor == true)
			SetSliderPositions()
			cbh.PlayerColorSliderA:SetVisible(false)
		end
		if index > 1 then cbh.PlayerGradients:SetVisible(false) else cbh.PlayerGradients:SetVisible(true) end
		if index ~= 3 and index ~= 4 then cbh.PlayerClassColor:SetVisible(false) else cbh.PlayerClassColor:SetVisible(true) end
	end

	local red, green, blue, alpha

	local function PlayerUpdateColorChanges()
		-- "Healthbar", "Health backdrop", "Manabar", "Name", "Percentage"
		if cbhcolorindex == nil then cbhcolorindex = 1 end
		if not cbhPlayerValues["Colors"][cbhcolorindex].classcolor then
			red = cbhPlayerTempColors[cbhcolorindex].r
			green = cbhPlayerTempColors[cbhcolorindex].g
			blue = cbhPlayerTempColors[cbhcolorindex].b
		else
			red = cbh.ClassColors[cbh.playerinfo.calling].r
			green = cbh.ClassColors[cbh.playerinfo.calling].g
			blue = cbh.ClassColors[cbh.playerinfo.calling].b
		end
		alpha = cbhPlayerTempColors[cbhcolorindex].a
		-- if cbhcolorindex == 1 then
			-- cbh.PlayerFrame:SetBackgroundColor(cbhPlayerTempColors[cbhcolorindex].r, cbhPlayerTempColors[cbhcolorindex].g, cbhPlayerTempColors[cbhcolorindex].b, cbhPlayerTempColors[cbhcolorindex].a)
		-- elseif cbhcolorindex == 2 then
			-- cbh.PlayerHP:SetBackgroundColor(cbhPlayerTempColors[cbhcolorindex].r, cbhPlayerTempColors[cbhcolorindex].g, cbhPlayerTempColors[cbhcolorindex].b, cbhPlayerTempColors[cbhcolorindex].a)
		-- elseif cbhcolorindex == 3 then
			-- cbh.PlayerManaFrame:SetBackgroundColor(cbhPlayerTempColors[cbhcolorindex].r, cbhPlayerTempColors[cbhcolorindex].g, cbhPlayerTempColors[cbhcolorindex].b, cbhPlayerTempColors[cbhcolorindex].a)
		-- elseif cbhcolorindex == 4 then
			-- cbh.PlayerName:SetFontColor(cbhPlayerTempColors[cbhcolorindex].r, cbhPlayerTempColors[cbhcolorindex].g, cbhPlayerTempColors[cbhcolorindex].b, cbhPlayerTempColors[cbhcolorindex].a)
		-- elseif cbhcolorindex == 5 then
			-- cbh.PlayerPercent:SetFontColor(cbhPlayerTempColors[cbhcolorindex].r, cbhPlayerTempColors[cbhcolorindex].g, cbhPlayerTempColors[cbhcolorindex].b, cbhPlayerTempColors[cbhcolorindex].a)
		-- end
		if cbhcolorindex == 1 then
			cbh.PlayerFrame:SetBackgroundColor(red, green, blue, alpha)
		elseif cbhcolorindex == 2 then
			cbh.PlayerHP:SetBackgroundColor(red, green, blue, alpha)
		elseif cbhcolorindex == 3 then
			cbh.PlayerManaFrame:SetBackgroundColor(red, green, blue, alpha)
		elseif cbhcolorindex == 4 then
			cbh.PlayerName:SetFontColor(red, green, blue, alpha)
		elseif cbhcolorindex == 5 then
			cbh.PlayerPercent:SetFontColor(red, green, blue, alpha)
		end
	end

	function cbh.PlayerColorSliderR.Event.SliderChange()
		cbhPlayerTempColors[cbhcolorindex].r = (cbh.PlayerColorSliderR:GetPosition() / 100)
		PlayerUpdateColorChanges()
	end
	function cbh.PlayerColorSliderG.Event.SliderChange()
		cbhPlayerTempColors[cbhcolorindex].g = (cbh.PlayerColorSliderG:GetPosition() / 100)
		PlayerUpdateColorChanges()
	end
	function cbh.PlayerColorSliderB.Event.SliderChange()
		cbhPlayerTempColors[cbhcolorindex].b = (cbh.PlayerColorSliderB:GetPosition() / 100)
		PlayerUpdateColorChanges()
	end
	function cbh.PlayerColorSliderA.Event.SliderChange()
		cbhPlayerTempColors[cbhcolorindex].a = (cbh.PlayerColorSliderA:GetPosition() / 100)
		PlayerUpdateColorChanges()
	end
	
	local function ClearPlayerOptions()
		cbh.PlayerHealthbarOptions:SetVisible(false)
		cbh.PlayerManabarOptions:SetVisible(false)
		cbh.PlayerNameOptions:SetVisible(false)
		cbh.PlayerLevelOptions:SetVisible(false)
		cbh.PlayerPercentOptions:SetVisible(false)
		cbh.PlayerRoleOptions:SetVisible(false)
		cbh.PlayerRaidMarkOptions:SetVisible(false)
		cbh.PlayerPvPMarkOptions:SetVisible(false)
		cbh.PlayerCombatOptions:SetVisible(false)
		cbh.PlayerPlanarChargeOptions:SetVisible(false)
		cbh.PlayerVitalityOptions:SetVisible(false)
		cbh.PlayerBuffOptions:SetVisible(false)
	end
	
	-- POSITIONING ITEM LIST
	cbh.PlayerPositionPieces:SetPoint("TOPLEFT", cbh.PlayerConfigA, "TOPLEFT", 10, 340)
	cbh.PlayerPositionPieces:SetWidth(140)
	cbh.PlayerPositionPieces:SetFontSize(15)
	cbh.PlayerPositionPieces:SetBorder(1, 1, 1, 1, 0)
	cbh.PlayerPositionPieces:SetItems(cbh.PlayerPositionList)
	cbh.PlayerPositionPieces:SetSelectedIndex(1)
	local cbhposindex = 1

	cbh.PlayerPositionPieces.Event.ItemSelect = function(view, item, value, index)
	-- {"Healthbar", "Manabar", "Name", "Percentage","Role Icon", "Raid Mark", "PvP Mark", "Buffs"}
		if index == nil then index = 1 end
		if index == 1 then
			cbhposindex = index
			ClearPlayerOptions()
			cbh.PlayerHealthbarOptions:SetVisible(true)
		elseif index == 2 then
			cbhposindex = index
			ClearPlayerOptions()
			cbh.PlayerManabarOptions:SetVisible(true)
		elseif index == 3 then
			cbhposindex = index
			ClearPlayerOptions()
			cbh.PlayerNameOptions:SetVisible(true)
		elseif index == 4 then
			cbhposindex = index
			ClearPlayerOptions()
			cbh.PlayerLevelOptions:SetVisible(true)
		elseif index == 5 then
			cbhposindex = index
			ClearPlayerOptions()
			cbh.PlayerPercentOptions:SetVisible(true)
		elseif index == 6 then
			cbhposindex = index
			ClearPlayerOptions()
			cbh.PlayerRoleOptions:SetVisible(true)
		elseif index == 7 then
			cbhposindex = index
			ClearPlayerOptions()
			cbh.PlayerRaidMarkOptions:SetVisible(true)
		elseif index == 8 then
			cbhposindex = index
			ClearPlayerOptions()
			cbh.PlayerPvPMarkOptions:SetVisible(true)
		elseif index == 9 then
			cbhposindex = index
			ClearPlayerOptions()
			cbh.PlayerCombatOptions:SetVisible(true)
		elseif index == 10 then
			cbhposindex = index
			ClearPlayerOptions()
			cbh.PlayerPlanarChargeOptions:SetVisible(true)
		elseif index == 11 then
			cbhposindex = index
			ClearPlayerOptions()
			cbh.PlayerVitalityOptions:SetVisible(true)
		elseif index == 12 then
			cbhposindex = index
			ClearPlayerOptions()
			cbh.PlayerBuffOptions:SetVisible(true)
		end
	end	
end


--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--		PLAYER CONFIG POSITIONING TAB
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.PlayerPositioningTab()
	--[[ HEALTH BAR OPTIONS ]]
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.PlayerHealthbarOptions:SetPoint("TOPLEFT", cbh.PlayerPositionPieces, "TOPRIGHT", 10, 0)
	cbh.PlayerHealthbarOptions:SetBackgroundColor(.25, .25, .25, .5)
	cbh.PlayerHealthbarOptions:SetWidth(300)
	cbh.PlayerHealthbarOptions:SetHeight(cbh.PlayerPositionPieces:GetHeight())
	
	cbh.PlayerHealthbarLocationText:SetPoint("TOPLEFT", cbh.PlayerHealthbarOptions, "TOPLEFT", 5, 0)
	cbh.PlayerHealthbarLocationText:SetFontSize(15)
	cbh.PlayerHealthbarLocationText:SetText("Player Healthbar Size")
	-- slider for width
	cbh.PlayerHealthbarSizerW:SetPoint("TOPLEFT", cbh.PlayerHealthbarLocationText, "TOPLEFT", 0, 30)
	cbh.PlayerHealthbarSizerW:SetRange(50, 300)
	cbh.PlayerHealthbarSizerW:SetPosition(cbhPlayerValues.fwidth)
	-- slider for height
	cbh.PlayerHealthbarSizerH:SetPoint("TOPLEFT", cbh.PlayerHealthbarLocationText, "TOPLEFT", 0, 60)
	cbh.PlayerHealthbarSizerH:SetRange(10, 300)
	cbh.PlayerHealthbarSizerH:SetPosition(cbhPlayerValues.fheight)
	function cbh.PlayerHealthbarSizerW.Event.SliderChange()
		cbhPlayerValues.fwidth = (cbh.PlayerHealthbarSizerW:GetPosition())
		cbh.PlayerFrame:SetWidth(cbhPlayerValues.fwidth)
		-- cbh.PlayerHP:SetWidth(0)
		cbh.PlayerManaFrame:SetWidth(cbhPlayerValues.fwidth)
		-- cbh.PlayerMana:SetWidth(0)
	end
	function cbh.PlayerHealthbarSizerH.Event.SliderChange()
		cbhPlayerValues.fheight = (cbh.PlayerHealthbarSizerH:GetPosition())
		cbh.PlayerFrame:SetHeight(cbhPlayerValues.fheight)
		cbh.PlayerHP:SetHeight(cbhPlayerValues.fheight)
	end
	

	--[[ MANA BAR OPTIONS ]]
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.PlayerManabarOptions:SetPoint("TOPLEFT", cbh.PlayerPositionPieces, "TOPRIGHT", 10, 0)
	cbh.PlayerManabarOptions:SetBackgroundColor(.25, .25, .25, .5)
	cbh.PlayerManabarOptions:SetWidth(300)
	cbh.PlayerManabarOptions:SetHeight(cbh.PlayerPositionPieces:GetHeight())
	cbh.PlayerManabarOptions:SetVisible(false)
	
	cbh.PlayerManabarLocationText:SetPoint("TOPLEFT", cbh.PlayerManabarOptions, "TOPLEFT", 5, 0)
	cbh.PlayerManabarLocationText:SetFontSize(15)
	cbh.PlayerManabarLocationText:SetText("Player Manabar Size")
	-- slider for height
	cbh.PlayerManabarSizerH:SetPoint("TOPLEFT", cbh.PlayerManabarLocationText, "TOPLEFT", 0, 30)
	cbh.PlayerManabarSizerH:SetRange(0, 100)
	-- cbh.PlayerManabarSizerH:SetWidth(250)
	cbh.PlayerManabarSizerH:SetPosition(cbhPlayerValues.mfheight)
	function cbh.PlayerManabarSizerH.Event.SliderChange()
		cbhPlayerValues.mfheight = (cbh.PlayerManabarSizerH:GetPosition())
		cbh.PlayerManaFrame:SetHeight(cbhPlayerValues.mfheight)
		cbh.PlayerMana:SetHeight(cbhPlayerValues.mfheight)
	end
	

	--[[ UNIT NAME SETTINGS ]]
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.PlayerNameOptions:SetPoint("TOPLEFT", cbh.PlayerPositionPieces, "TOPRIGHT", 10, 0)
	cbh.PlayerNameOptions:SetBackgroundColor(.25, .25, .25, .5)
	cbh.PlayerNameOptions:SetWidth(300)
	cbh.PlayerNameOptions:SetHeight(cbh.PlayerPositionPieces:GetHeight())
	cbh.PlayerNameOptions:SetVisible(false)
	
	cbh.PlayerNameLocationText:SetPoint("TOPLEFT", cbh.PlayerNameOptions, "TOPLEFT", 5, 0)
	cbh.PlayerNameLocationText:SetFontSize(15)
	cbh.PlayerNameLocationText:SetText("Player Name Location/Size")
	cbh.PlayerNameFontSizer:SetPoint("TOPLEFT", cbh.PlayerNameLocationText, "TOPLEFT", 0, 30)
	cbh.PlayerNameFontSizer:SetRange(0, 72)
	cbh.PlayerNameFontSizer:SetWidth(125)
	cbh.PlayerNameFontSizer:SetPosition(cbhPlayerValues.namefontsize)
	function cbh.PlayerNameFontSizer.Event.SliderChange()
		cbhPlayerValues.namefontsize = (cbh.PlayerNameFontSizer:GetPosition())
		cbh.PlayerName:SetFontSize(cbhPlayerValues.namefontsize)
	end

	cbh.PlayerNameLocation:SetPoint("TOPLEFT", cbh.PlayerNameFontSizer, "TOPRIGHT", 10, 0)
	cbh.PlayerNameLocation:SetLayer(5)
	cbh.PlayerNameLocation:SetFontSize(14)
	cbh.PlayerNameLocation:SetItems(cbh.SetPoint)
	cbh.PlayerNameLocation:SetSelectedItem(cbhPlayerValues.namelocation, silent)
	cbh.PlayerNameLocation:SetWidth(125)
	cbh.PlayerNameLocation.Event.ItemSelect = function(view, item)
		cbhPlayerValues.namelocation = item
		cbh.PlayerName:ClearAll()
		cbh.PlayerName:SetPoint(cbhPlayerValues.namelocation, cbh.PlayerFrame, cbhPlayerValues.namelocation, cbhPlayerValues.nameoffsetx, cbhPlayerValues.nameoffsety)
	end

	-- PLAYER NAME LENGTH
	cbh.PlayerNameLengthOption:SetPoint("TOPLEFT", cbh.PlayerNameFontSizer, "TOPLEFT", 0, 30)
	cbh.PlayerNameLengthOption:SetFontSize(14)
	cbh.PlayerNameLengthOption:SetLayer(1)
	cbh.PlayerNameLengthOption:SetText("Player Name Length Auto")
	cbh.PlayerNameLengthOption:SetChecked(cbhPlayerValues.namelengthauto == true)
	function cbh.PlayerNameLengthOption.Event.CheckboxChange()
		if cbh.PlayerNameLengthOption:GetChecked() == true then
			cbhPlayerValues.namelengthauto = true
			cbh.PlayerNameLength:SetVisible(false)
		else
			cbhPlayerValues.namelengthauto = false
			cbh.PlayerNameLength:SetVisible(true)
		end
		cbh.nameCalc(cbh.playerinfo.name, nil, "player")
	end

	-- SLIDER TO CHANGE NAME LENGTH  **HIDES IF AUTO IS TRUE**
	cbh.PlayerNameLength:SetPoint("TOPLEFT", cbh.PlayerNameLengthOption, "TOPLEFT", 0, 20)
	cbh.PlayerNameLength:SetRange(0, 16)
	cbh.PlayerNameLength:SetPosition(cbhPlayerValues.namelength)
	function cbh.PlayerNameLength.Event.SliderChange()
		cbhPlayerValues.namelength = cbh.PlayerNameLength:GetPosition()
		cbh.nameCalc(cbh.playerinfo.name, nil, "player")
	end

	-- PLAYER NAME OFFSET
	cbh.PlayerNameOffsetText:SetPoint("TOPLEFT", cbh.PlayerNameLength, "TOPLEFT", 0, 40)
	cbh.PlayerNameOffsetText:SetFontSize(15)
	cbh.PlayerNameOffsetText:SetText("Offset Name: x, y")
	cbh.PlayerNameOffsetX:SetPoint("TOPLEFT", cbh.PlayerNameOffsetText, "TOPLEFT", 0, 30)
	cbh.PlayerNameOffsetX:SetRange(-100, 100)
	cbh.PlayerNameOffsetX:SetWidth(125)
	cbh.PlayerNameOffsetX:SetPosition(cbhPlayerValues.nameoffsetx)
	function cbh.PlayerNameOffsetX.Event.SliderChange()
		cbhPlayerValues.nameoffsetx = (cbh.PlayerNameOffsetX:GetPosition())
		cbh.PlayerName:ClearAll()
		cbh.PlayerName:SetPoint(cbhPlayerValues.namelocation, cbh.PlayerFrame, cbhPlayerValues.namelocation, cbhPlayerValues.nameoffsetx, cbhPlayerValues.nameoffsety)
	end
	cbh.PlayerNameOffsetY:SetPoint("TOPLEFT", cbh.PlayerNameOffsetX, "TOPRIGHT", 20, 0)
	cbh.PlayerNameOffsetY:SetRange(-100, 100)
	cbh.PlayerNameOffsetY:SetWidth(125)
	cbh.PlayerNameOffsetY:SetPosition(cbhPlayerValues.nameoffsety)
	function cbh.PlayerNameOffsetY.Event.SliderChange()
		cbhPlayerValues.nameoffsety = (cbh.PlayerNameOffsetY:GetPosition())
		cbh.PlayerName:ClearAll()
		cbh.PlayerName:SetPoint(cbhPlayerValues.namelocation, cbh.PlayerFrame, cbhPlayerValues.namelocation, cbhPlayerValues.nameoffsetx, cbhPlayerValues.nameoffsety)
	end

	
	
	--[[ LEVEL OPTIONS ]]
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.PlayerLevelOptions:SetPoint("TOPLEFT", cbh.PlayerPositionPieces, "TOPRIGHT", 10, 0)
	cbh.PlayerLevelOptions:SetBackgroundColor(.25, .25, .25, .5)
	cbh.PlayerLevelOptions:SetWidth(300)
	cbh.PlayerLevelOptions:SetHeight(cbh.PlayerPositionPieces:GetHeight())
	cbh.PlayerLevelOptions:SetVisible(false)
	
	cbh.PlayerLevelLocationText:SetPoint("TOPLEFT", cbh.PlayerLevelOptions, "TOPLEFT", 5, 0)
	cbh.PlayerLevelLocationText:SetFontSize(15)
	cbh.PlayerLevelLocationText:SetText("Player Level Location/Size")
	cbh.PlayerLevelSizer:SetPoint("TOPLEFT", cbh.PlayerLevelLocationText, "TOPLEFT", 0, 60)
	cbh.PlayerLevelSizer:SetRange(0, 72)
	cbh.PlayerLevelSizer:SetWidth(125)
	cbh.PlayerLevelSizer:SetPosition(cbhPlayerValues.levelsize)
	function cbh.PlayerLevelSizer.Event.SliderChange()
		cbhPlayerValues.levelsize = (cbh.PlayerLevelSizer:GetPosition())
		cbh.PlayerLevel:SetFontSize(cbhPlayerValues.levelsize)
	end

	cbh.PlayerLevelLocation:SetPoint("TOPLEFT", cbh.PlayerLevelSizer, "TOPRIGHT", 10, 0)
	cbh.PlayerLevelLocation:SetLayer(5)
	cbh.PlayerLevelLocation:SetFontSize(14)
	cbh.PlayerLevelLocation:SetItems(cbh.SetPoint)
	cbh.PlayerLevelLocation:SetSelectedItem(cbhPlayerValues.levellocation, silent)
	cbh.PlayerLevelLocation:SetWidth(125)
	cbh.PlayerLevelLocation.Event.ItemSelect = function(view, item)
		cbhPlayerValues.levellocation = item
		cbh.PlayerLevel:ClearAll()
		cbh.PlayerLevel:SetPoint(cbhPlayerValues.levellocation, cbh.PlayerFrame, cbhPlayerValues.levellocation, cbhPlayerValues.leveloffsetx, cbhPlayerValues.leveloffsety)
	end
	
	-- PLAYER Level OFFSET
	cbh.PlayerLevelOffsetText:SetPoint("TOPLEFT", cbh.PlayerLevelSizer, "TOPLEFT", 0, 40)
	cbh.PlayerLevelOffsetText:SetFontSize(15)
	cbh.PlayerLevelOffsetText:SetText("Offset Level: x, y")
	cbh.PlayerLevelOffsetX:SetPoint("TOPLEFT", cbh.PlayerLevelOffsetText, "TOPLEFT", 0, 30)
	cbh.PlayerLevelOffsetX:SetRange(-100, 100)
	cbh.PlayerLevelOffsetX:SetPosition(cbhPlayerValues.leveloffsetx)
	function cbh.PlayerLevelOffsetX.Event.SliderChange()
		cbhPlayerValues.leveloffsetx = (cbh.PlayerLevelOffsetX:GetPosition())
		cbh.PlayerLevel:ClearAll()
		cbh.PlayerLevel:SetPoint(cbhPlayerValues.levellocation, cbh.PlayerFrame, cbhPlayerValues.levellocation, cbhPlayerValues.leveloffsetx, cbhPlayerValues.leveloffsety)
	end
	cbh.PlayerLevelOffsetY:SetPoint("TOPLEFT", cbh.PlayerLevelOffsetX, "TOPLEFT", 0, 30)
	cbh.PlayerLevelOffsetY:SetRange(-100, 100)
	cbh.PlayerLevelOffsetY:SetPosition(cbhPlayerValues.leveloffsety)
	function cbh.PlayerLevelOffsetY.Event.SliderChange()
		cbhPlayerValues.leveloffsety = (cbh.PlayerLevelOffsetY:GetPosition())
		cbh.PlayerLevel:ClearAll()
		cbh.PlayerLevel:SetPoint(cbhPlayerValues.levellocation, cbh.PlayerFrame, cbhPlayerValues.levellocation, cbhPlayerValues.leveloffsetx, cbhPlayerValues.leveloffsety)
	end

	
	--[[ HEALTH PERCENT OPTIONS ]]
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.PlayerPercentOptions:SetPoint("TOPLEFT", cbh.PlayerPositionPieces, "TOPRIGHT", 10, 0)
	cbh.PlayerPercentOptions:SetBackgroundColor(.25, .25, .25, .5)
	cbh.PlayerPercentOptions:SetWidth(300)
	cbh.PlayerPercentOptions:SetHeight(cbh.PlayerPositionPieces:GetHeight())
	cbh.PlayerPercentOptions:SetVisible(false)
	
	cbh.PlayerPercentLocationText:SetPoint("TOPLEFT", cbh.PlayerPercentOptions, "TOPLEFT", 5, 0)
	cbh.PlayerPercentLocationText:SetFontSize(15)
	cbh.PlayerPercentLocationText:SetText("Player Percent Location/Size")
	
	cbh.PlayerPercentToggle:SetPoint("TOPLEFT", cbh.PlayerPercentLocationText, "TOPLEFT", 0, 30)
	cbh.PlayerPercentToggle:SetFontSize(14)
	cbh.PlayerPercentToggle:SetLayer(1)
	cbh.PlayerPercentToggle:SetText("Toggle Text Health On/Off")
	cbh.PlayerPercentToggle:SetChecked(cbhPlayerValues.percentshow == true)
	function cbh.PlayerPercentToggle.Event.CheckboxChange()
		cbhPlayerValues.percentshow = cbh.PlayerPercentToggle:GetChecked()
		if cbhPlayerValues.percentshow then
			cbh.PlayerPercent:SetVisible(true)
		else
			cbh.PlayerPercent:SetVisible(false)
		end
	end

	cbh.PlayerPercentSizer:SetPoint("TOPLEFT", cbh.PlayerPercentLocationText, "TOPLEFT", 0, 60)
	cbh.PlayerPercentSizer:SetRange(0, 72)
	cbh.PlayerPercentSizer:SetWidth(125)
	cbh.PlayerPercentSizer:SetPosition(cbhPlayerValues.percentfontsize)
	function cbh.PlayerPercentSizer.Event.SliderChange()
		cbhPlayerValues.percentfontsize = (cbh.PlayerPercentSizer:GetPosition())
		cbh.PlayerPercent:SetFontSize(cbhPlayerValues.percentfontsize)
	end

	cbh.PlayerPercentLocation:SetPoint("TOPLEFT", cbh.PlayerPercentSizer, "TOPRIGHT", 10, 0)
	cbh.PlayerPercentLocation:SetLayer(5)
	cbh.PlayerPercentLocation:SetFontSize(14)
	cbh.PlayerPercentLocation:SetItems(cbh.SetPoint)
	cbh.PlayerPercentLocation:SetSelectedItem(cbhPlayerValues.percentlocation, silent)
	cbh.PlayerPercentLocation:SetWidth(125)
	cbh.PlayerPercentLocation.Event.ItemSelect = function(view, item)
		cbhPlayerValues.percentlocation = item
		cbh.PlayerPercent:ClearAll()
		cbh.PlayerPercent:SetPoint(cbhPlayerValues.percentlocation, cbh.PlayerFrame, cbhPlayerValues.percentlocation, cbhPlayerValues.percentoffsetx, cbhPlayerValues.percentoffsety)
	end
	
	-- PLAYER Percent OFFSET
	cbh.PlayerPercentOffsetText:SetPoint("TOPLEFT", cbh.PlayerPercentSizer, "TOPLEFT", 0, 40)
	cbh.PlayerPercentOffsetText:SetFontSize(15)
	cbh.PlayerPercentOffsetText:SetText("Offset Percent: x, y")
	cbh.PlayerPercentOffsetX:SetPoint("TOPLEFT", cbh.PlayerPercentOffsetText, "TOPLEFT", 0, 30)
	cbh.PlayerPercentOffsetX:SetRange(-100, 100)
	cbh.PlayerPercentOffsetX:SetPosition(cbhPlayerValues.percentoffsetx)
	function cbh.PlayerPercentOffsetX.Event.SliderChange()
		cbhPlayerValues.percentoffsetx = (cbh.PlayerPercentOffsetX:GetPosition())
		cbh.PlayerPercent:ClearAll()
		cbh.PlayerPercent:SetPoint(cbhPlayerValues.percentlocation, cbh.PlayerFrame, cbhPlayerValues.percentlocation, cbhPlayerValues.percentoffsetx, cbhPlayerValues.percentoffsety)
	end
	cbh.PlayerPercentOffsetY:SetPoint("TOPLEFT", cbh.PlayerPercentOffsetX, "TOPLEFT", 0, 30)
	cbh.PlayerPercentOffsetY:SetRange(-100, 100)
	cbh.PlayerPercentOffsetY:SetPosition(cbhPlayerValues.percentoffsety)
	function cbh.PlayerPercentOffsetY.Event.SliderChange()
		cbhPlayerValues.percentoffsety = (cbh.PlayerPercentOffsetY:GetPosition())
		cbh.PlayerPercent:ClearAll()
		cbh.PlayerPercent:SetPoint(cbhPlayerValues.percentlocation, cbh.PlayerFrame, cbhPlayerValues.percentlocation, cbhPlayerValues.percentoffsetx, cbhPlayerValues.percentoffsety)
	end

	
	
	--[[ DUNGEON ROLE OPTIONS ]]
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.PlayerRoleOptions:SetPoint("TOPLEFT", cbh.PlayerPositionPieces, "TOPRIGHT", 10, 0)
	cbh.PlayerRoleOptions:SetBackgroundColor(.25, .25, .25, .5)
	cbh.PlayerRoleOptions:SetWidth(300)
	cbh.PlayerRoleOptions:SetHeight(cbh.PlayerPositionPieces:GetHeight())
	cbh.PlayerRoleOptions:SetVisible(false)
	
	cbh.PlayerRoleLocationText:SetPoint("TOPLEFT", cbh.PlayerRoleOptions, "TOPLEFT", 5, 0)
	cbh.PlayerRoleLocationText:SetFontSize(15)
	cbh.PlayerRoleLocationText:SetText("Player Role Location/Size")

	cbh.PlayerRoleToggle:SetPoint("TOPLEFT", cbh.PlayerRoleLocationText, "TOPLEFT", 0, 30)
	cbh.PlayerRoleToggle:SetFontSize(14)
	cbh.PlayerRoleToggle:SetLayer(1)
	cbh.PlayerRoleToggle:SetText("Toggle Role On/Off")
	cbh.PlayerRoleToggle:SetChecked(cbhPlayerValues.roleshow == true)
	function cbh.PlayerRoleToggle.Event.CheckboxChange()
		cbhPlayerValues.roleshow = cbh.PlayerRoleToggle:GetChecked()
		cbh.PlayerRole:SetVisible(cbhPlayerValues.roleshow)
	end

	cbh.PlayerRoleSizer:SetPoint("TOPLEFT", cbh.PlayerRoleLocationText, "TOPLEFT", 0, 60)
	cbh.PlayerRoleSizer:SetRange(0, 72)
	cbh.PlayerRoleSizer:SetWidth(125)
	cbh.PlayerRoleSizer:SetPosition(cbhPlayerValues.rolesize)
	function cbh.PlayerRoleSizer.Event.SliderChange()
		cbhPlayerValues.rolesize = (cbh.PlayerRoleSizer:GetPosition())
		cbh.PlayerRole:SetWidth(cbhPlayerValues.rolesize)
		cbh.PlayerRole:SetHeight(cbhPlayerValues.rolesize)
	end

	cbh.PlayerRoleLocation:SetPoint("TOPLEFT", cbh.PlayerRoleSizer, "TOPRIGHT", 10, 0)
	cbh.PlayerRoleLocation:SetLayer(5)
	cbh.PlayerRoleLocation:SetFontSize(14)
	cbh.PlayerRoleLocation:SetItems(cbh.SetPoint)
	cbh.PlayerRoleLocation:SetSelectedItem(cbhPlayerValues.rolelocation, silent)
	cbh.PlayerRoleLocation:SetWidth(125)
	cbh.PlayerRoleLocation.Event.ItemSelect = function(view, item)
		cbhPlayerValues.rolelocation = item
		cbh.PlayerRole:ClearAll()
		cbh.PlayerRole:SetPoint(cbhPlayerValues.rolelocation, cbh.PlayerFrame, cbhPlayerValues.rolelocation, cbhPlayerValues.roleoffsetx, cbhPlayerValues.roleoffsety)
		cbh.PlayerRole:SetWidth(cbhPlayerValues.rolesize)
		cbh.PlayerRole:SetHeight(cbhPlayerValues.rolesize)
	end
	
	-- PLAYER Role OFFSET
	cbh.PlayerRoleOffsetText:SetPoint("TOPLEFT", cbh.PlayerRoleSizer, "TOPLEFT", 0, 40)
	cbh.PlayerRoleOffsetText:SetFontSize(15)
	cbh.PlayerRoleOffsetText:SetText("Offset Role: x, y")
	cbh.PlayerRoleOffsetX:SetPoint("TOPLEFT", cbh.PlayerRoleOffsetText, "TOPLEFT", 0, 30)
	cbh.PlayerRoleOffsetX:SetRange(-100, 100)
	cbh.PlayerRoleOffsetX:SetPosition(cbhPlayerValues.roleoffsetx)
	function cbh.PlayerRoleOffsetX.Event.SliderChange()
		cbhPlayerValues.roleoffsetx = (cbh.PlayerRoleOffsetX:GetPosition())
		cbh.PlayerRole:ClearPoint(x, y)
		cbh.PlayerRole:SetPoint(cbhPlayerValues.rolelocation, cbh.PlayerFrame, cbhPlayerValues.rolelocation, cbhPlayerValues.roleoffsetx, cbhPlayerValues.roleoffsety)
	end
	cbh.PlayerRoleOffsetY:SetPoint("TOPLEFT", cbh.PlayerRoleOffsetX, "TOPLEFT", 0, 30)
	cbh.PlayerRoleOffsetY:SetRange(-100, 100)
	cbh.PlayerRoleOffsetY:SetPosition(cbhPlayerValues.roleoffsety)
	function cbh.PlayerRoleOffsetY.Event.SliderChange()
		cbhPlayerValues.roleoffsety = (cbh.PlayerRoleOffsetY:GetPosition())
		cbh.PlayerRole:ClearPoint(x, y)
		cbh.PlayerRole:SetPoint(cbhPlayerValues.rolelocation, cbh.PlayerFrame, cbhPlayerValues.rolelocation, cbhPlayerValues.roleoffsetx, cbhPlayerValues.roleoffsety)
	end

	
	
	--[[ RAID MARK OPTIONS ]]--
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.PlayerRaidMarkOptions:SetPoint("TOPLEFT", cbh.PlayerPositionPieces, "TOPRIGHT", 10, 0)
	cbh.PlayerRaidMarkOptions:SetBackgroundColor(.25, .25, .25, .5)
	cbh.PlayerRaidMarkOptions:SetWidth(300)
	cbh.PlayerRaidMarkOptions:SetHeight(cbh.PlayerPositionPieces:GetHeight())
	cbh.PlayerRaidMarkOptions:SetVisible(false)
	
	cbh.PlayerRaidMarkLocationText:SetPoint("TOPLEFT", cbh.PlayerRaidMarkOptions, "TOPLEFT", 5, 0)
	cbh.PlayerRaidMarkLocationText:SetFontSize(15)
	cbh.PlayerRaidMarkLocationText:SetText("Player RaidMark Location/Size")
	cbh.PlayerRaidMarkSizer:SetPoint("TOPLEFT", cbh.PlayerRaidMarkLocationText, "TOPLEFT", 0, 30)
	cbh.PlayerRaidMarkSizer:SetRange(0, 72)
	cbh.PlayerRaidMarkSizer:SetWidth(125)
	cbh.PlayerRaidMarkSizer:SetPosition(cbhPlayerValues.raidmarksize)
	function cbh.PlayerRaidMarkSizer.Event.SliderChange()
		cbhPlayerValues.raidmarksize = (cbh.PlayerRaidMarkSizer:GetPosition())
		cbh.PlayerRaidMark:SetWidth(cbhPlayerValues.raidmarksize)
		cbh.PlayerRaidMark:SetHeight(cbhPlayerValues.raidmarksize)
	end

	cbh.PlayerRaidMarkLocation:SetPoint("TOPLEFT", cbh.PlayerRaidMarkSizer, "TOPRIGHT", 10, 0)
	cbh.PlayerRaidMarkLocation:SetLayer(5)
	cbh.PlayerRaidMarkLocation:SetFontSize(14)
	cbh.PlayerRaidMarkLocation:SetItems(cbh.SetPoint)
	cbh.PlayerRaidMarkLocation:SetSelectedItem(cbhPlayerValues.raidmarklocation, silent)
	cbh.PlayerRaidMarkLocation:SetWidth(125)
	cbh.PlayerRaidMarkLocation.Event.ItemSelect = function(view, item)
		cbhPlayerValues.raidmarklocation = item
		cbh.PlayerRaidMark:ClearAll()
		cbh.PlayerRaidMark:SetPoint(cbhPlayerValues.raidmarklocation, cbh.PlayerFrame, cbhPlayerValues.raidmarklocation, cbhPlayerValues.raidmarkoffsetx, cbhPlayerValues.raidmarkoffsety)
		cbh.PlayerRaidMark:SetWidth(cbhPlayerValues.raidmarksize)
		cbh.PlayerRaidMark:SetHeight(cbhPlayerValues.raidmarksize)
	end
	
	-- PLAYER RaidMark OFFSET
	cbh.PlayerRaidMarkOffsetText:SetPoint("TOPLEFT", cbh.PlayerRaidMarkSizer, "TOPLEFT", 0, 40)
	cbh.PlayerRaidMarkOffsetText:SetFontSize(15)
	cbh.PlayerRaidMarkOffsetText:SetText("Offset RaidMark: x, y")
	cbh.PlayerRaidMarkOffsetX:SetPoint("TOPLEFT", cbh.PlayerRaidMarkOffsetText, "TOPLEFT", 0, 30)
	cbh.PlayerRaidMarkOffsetX:SetRange(-100, 100)
	cbh.PlayerRaidMarkOffsetX:SetPosition(cbhPlayerValues.raidmarkoffsetx)
	function cbh.PlayerRaidMarkOffsetX.Event.SliderChange()
		cbhPlayerValues.raidmarkoffsetx = (cbh.PlayerRaidMarkOffsetX:GetPosition())
		cbh.PlayerRaidMark:ClearPoint(x, y)
		cbh.PlayerRaidMark:SetPoint(cbhPlayerValues.raidmarklocation, cbh.PlayerFrame, cbhPlayerValues.raidmarklocation, cbhPlayerValues.raidmarkoffsetx, cbhPlayerValues.raidmarkoffsety)
	end
	cbh.PlayerRaidMarkOffsetY:SetPoint("TOPLEFT", cbh.PlayerRaidMarkOffsetX, "TOPLEFT", 0, 30)
	cbh.PlayerRaidMarkOffsetY:SetRange(-100, 100)
	cbh.PlayerRaidMarkOffsetY:SetPosition(cbhPlayerValues.raidmarkoffsety)
	function cbh.PlayerRaidMarkOffsetY.Event.SliderChange()
		cbhPlayerValues.raidmarkoffsety = (cbh.PlayerRaidMarkOffsetY:GetPosition())
		cbh.PlayerRaidMark:ClearPoint(x, y)
		cbh.PlayerRaidMark:SetPoint(cbhPlayerValues.raidmarklocation, cbh.PlayerFrame, cbhPlayerValues.raidmarklocation, cbhPlayerValues.raidmarkoffsetx, cbhPlayerValues.raidmarkoffsety)
	end

	
	
	--[[ PVP MARK OPTIONS ]]--
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.PlayerPvPMarkOptions:SetPoint("TOPLEFT", cbh.PlayerPositionPieces, "TOPRIGHT", 10, 0)
	cbh.PlayerPvPMarkOptions:SetBackgroundColor(.25, .25, .25, .5)
	cbh.PlayerPvPMarkOptions:SetWidth(300)
	cbh.PlayerPvPMarkOptions:SetHeight(cbh.PlayerPositionPieces:GetHeight())
	cbh.PlayerPvPMarkOptions:SetVisible(false)
	
	cbh.PlayerPvPMarkLocationText:SetPoint("TOPLEFT", cbh.PlayerPvPMarkOptions, "TOPLEFT", 5, 0)
	cbh.PlayerPvPMarkLocationText:SetFontSize(15)
	cbh.PlayerPvPMarkLocationText:SetText("Player PvPMark Location/Size")

	cbh.PlayerPvPMarkToggle:SetPoint("TOPLEFT", cbh.PlayerPvPMarkLocationText, "TOPLEFT", 0, 30)
	cbh.PlayerPvPMarkToggle:SetFontSize(14)
	cbh.PlayerPvPMarkToggle:SetLayer(1)
	cbh.PlayerPvPMarkToggle:SetText("PvP Flag Always Visible (default: mouseover)")
	cbh.PlayerPvPMarkToggle:SetChecked(cbhPlayerValues.pvpalwaysshow == true)
	function cbh.PlayerPvPMarkToggle.Event.CheckboxChange()
		cbhPlayerValues.pvpalwaysshow = cbh.PlayerPvPMarkToggle:GetChecked()
		if cbh.playerinfo.pvp and cbhPlayerValues.pvpalwaysshow then
			cbh.PlayerPvPMark:SetAlpha(1)
		else
			cbh.PlayerPvPMark:SetAlpha(0)
		end
	end

	cbh.PlayerPvPMarkSizer:SetPoint("TOPLEFT", cbh.PlayerPvPMarkLocationText, "TOPLEFT", 0, 60)
	cbh.PlayerPvPMarkSizer:SetRange(0, 72)
	cbh.PlayerPvPMarkSizer:SetWidth(125)
	cbh.PlayerPvPMarkSizer:SetPosition(cbhPlayerValues.pvpmarksize)
	function cbh.PlayerPvPMarkSizer.Event.SliderChange()
		cbhPlayerValues.pvpmarksize = (cbh.PlayerPvPMarkSizer:GetPosition())
		cbh.PlayerPvPMark:SetFontSize(cbhPlayerValues.pvpmarksize)
	end

	cbh.PlayerPvPMarkLocation:SetPoint("TOPLEFT", cbh.PlayerPvPMarkSizer, "TOPRIGHT", 10, 0)
	cbh.PlayerPvPMarkLocation:SetLayer(5)
	cbh.PlayerPvPMarkLocation:SetFontSize(14)
	cbh.PlayerPvPMarkLocation:SetItems(cbh.SetPoint)
	cbh.PlayerPvPMarkLocation:SetSelectedItem(cbhPlayerValues.pvpmarklocation, silent)
	cbh.PlayerPvPMarkLocation:SetWidth(125)
	cbh.PlayerPvPMarkLocation.Event.ItemSelect = function(view, item)
		cbhPlayerValues.pvpmarklocation = item
		cbh.PlayerPvPMark:ClearAll()
		cbh.PlayerPvPMark:SetPoint(cbhPlayerValues.pvpmarklocation, cbh.PlayerFrame, cbhPlayerValues.pvpmarklocation, cbhPlayerValues.pvpmarkoffsetx, cbhPlayerValues.pvpmarkoffsety)
	end
	
	-- PLAYER PvPMark OFFSET
	cbh.PlayerPvPMarkOffsetText:SetPoint("TOPLEFT", cbh.PlayerPvPMarkSizer, "TOPLEFT", 0, 40)
	cbh.PlayerPvPMarkOffsetText:SetFontSize(15)
	cbh.PlayerPvPMarkOffsetText:SetText("Offset PvPMark: x, y")
	cbh.PlayerPvPMarkOffsetX:SetPoint("TOPLEFT", cbh.PlayerPvPMarkOffsetText, "TOPLEFT", 0, 30)
	cbh.PlayerPvPMarkOffsetX:SetRange(-100, 100)
	cbh.PlayerPvPMarkOffsetX:SetPosition(cbhPlayerValues.pvpmarkoffsetx)
	function cbh.PlayerPvPMarkOffsetX.Event.SliderChange()
		cbhPlayerValues.pvpmarkoffsetx = (cbh.PlayerPvPMarkOffsetX:GetPosition())
		cbh.PlayerPvPMark:ClearPoint(x, y)
		cbh.PlayerPvPMark:SetPoint(cbhPlayerValues.pvpmarklocation, cbh.PlayerFrame, cbhPlayerValues.pvpmarklocation, cbhPlayerValues.pvpmarkoffsetx, cbhPlayerValues.pvpmarkoffsety)
	end
	cbh.PlayerPvPMarkOffsetY:SetPoint("TOPLEFT", cbh.PlayerPvPMarkOffsetX, "TOPLEFT", 0, 30)
	cbh.PlayerPvPMarkOffsetY:SetRange(-100, 100)
	cbh.PlayerPvPMarkOffsetY:SetPosition(cbhPlayerValues.pvpmarkoffsety)
	function cbh.PlayerPvPMarkOffsetY.Event.SliderChange()
		cbhPlayerValues.pvpmarkoffsety = (cbh.PlayerPvPMarkOffsetY:GetPosition())
		cbh.PlayerPvPMark:ClearPoint(x, y)
		cbh.PlayerPvPMark:SetPoint(cbhPlayerValues.pvpmarklocation, cbh.PlayerFrame, cbhPlayerValues.pvpmarklocation, cbhPlayerValues.pvpmarkoffsetx, cbhPlayerValues.pvpmarkoffsety)
	end

	
	
	--[[ COMBAT ICON OPTIONS ]]--
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.PlayerCombatOptions:SetPoint("TOPLEFT", cbh.PlayerPositionPieces, "TOPRIGHT", 10, 0)
	cbh.PlayerCombatOptions:SetBackgroundColor(.25, .25, .25, .5)
	cbh.PlayerCombatOptions:SetWidth(300)
	cbh.PlayerCombatOptions:SetHeight(cbh.PlayerPositionPieces:GetHeight())
	cbh.PlayerCombatOptions:SetVisible(false)
	
	cbh.PlayerCombatLocationText:SetPoint("TOPLEFT", cbh.PlayerCombatOptions, "TOPLEFT", 5, 0)
	cbh.PlayerCombatLocationText:SetFontSize(15)
	cbh.PlayerCombatLocationText:SetText("Player Combat Location/Size")
	cbh.PlayerCombatSizer:SetPoint("TOPLEFT", cbh.PlayerCombatLocationText, "TOPLEFT", 0, 30)
	cbh.PlayerCombatSizer:SetRange(0, 72)
	cbh.PlayerCombatSizer:SetWidth(125)
	cbh.PlayerCombatSizer:SetPosition(cbhPlayerValues.combatsize)
	function cbh.PlayerCombatSizer.Event.SliderChange()
		cbhPlayerValues.combatsize = (cbh.PlayerCombatSizer:GetPosition())
		cbh.PlayerCombat:SetWidth(cbhPlayerValues.combatsize)
		cbh.PlayerCombat:SetHeight(cbhPlayerValues.combatsize)
	end

	cbh.PlayerCombatLocation:SetPoint("TOPLEFT", cbh.PlayerCombatSizer, "TOPRIGHT", 10, 0)
	cbh.PlayerCombatLocation:SetLayer(5)
	cbh.PlayerCombatLocation:SetFontSize(14)
	cbh.PlayerCombatLocation:SetItems(cbh.SetPoint)
	cbh.PlayerCombatLocation:SetSelectedItem(cbhPlayerValues.combatlocation, silent)
	cbh.PlayerCombatLocation:SetWidth(125)
	cbh.PlayerCombatLocation.Event.ItemSelect = function(view, item)
		cbhPlayerValues.combatlocation = item
		cbh.PlayerCombat:ClearAll()
		cbh.PlayerCombat:SetPoint(cbhPlayerValues.combatlocation, cbh.PlayerFrame, cbhPlayerValues.combatlocation, cbhPlayerValues.combatoffsetx, cbhPlayerValues.combatoffsety)
		cbh.PlayerCombat:SetWidth(cbhPlayerValues.combatsize)
		cbh.PlayerCombat:SetHeight(cbhPlayerValues.combatsize)
	end
	
	-- PLAYER Combat OFFSET
	cbh.PlayerCombatOffsetText:SetPoint("TOPLEFT", cbh.PlayerCombatSizer, "TOPLEFT", 0, 40)
	cbh.PlayerCombatOffsetText:SetFontSize(15)
	cbh.PlayerCombatOffsetText:SetText("Offset Combat: x, y")
	cbh.PlayerCombatOffsetX:SetPoint("TOPLEFT", cbh.PlayerCombatOffsetText, "TOPLEFT", 0, 30)
	cbh.PlayerCombatOffsetX:SetRange(-100, 100)
	cbh.PlayerCombatOffsetX:SetPosition(cbhPlayerValues.combatoffsetx)
	function cbh.PlayerCombatOffsetX.Event.SliderChange()
		cbhPlayerValues.combatoffsetx = (cbh.PlayerCombatOffsetX:GetPosition())
		cbh.PlayerCombat:ClearPoint(x, y)
		cbh.PlayerCombat:SetPoint(cbhPlayerValues.combatlocation, cbh.PlayerFrame, cbhPlayerValues.combatlocation, cbhPlayerValues.combatoffsetx, cbhPlayerValues.combatoffsety)
	end
	cbh.PlayerCombatOffsetY:SetPoint("TOPLEFT", cbh.PlayerCombatOffsetX, "TOPLEFT", 0, 30)
	cbh.PlayerCombatOffsetY:SetRange(-100, 100)
	cbh.PlayerCombatOffsetY:SetPosition(cbhPlayerValues.combatoffsety)
	function cbh.PlayerCombatOffsetY.Event.SliderChange()
		cbhPlayerValues.combatoffsety = (cbh.PlayerCombatOffsetY:GetPosition())
		cbh.PlayerCombat:ClearPoint(x, y)
		cbh.PlayerCombat:SetPoint(cbhPlayerValues.combatlocation, cbh.PlayerFrame, cbhPlayerValues.combatlocation, cbhPlayerValues.combatoffsetx, cbhPlayerValues.combatoffsety)
	end

	
	
	--[[ PLANAR CHARGES OPTIONS ]]--
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.PlayerPlanarChargeOptions:SetPoint("TOPLEFT", cbh.PlayerPositionPieces, "TOPRIGHT", 10, 0)
	cbh.PlayerPlanarChargeOptions:SetBackgroundColor(.25, .25, .25, .5)
	cbh.PlayerPlanarChargeOptions:SetWidth(300)
	cbh.PlayerPlanarChargeOptions:SetHeight(cbh.PlayerPositionPieces:GetHeight())
	cbh.PlayerPlanarChargeOptions:SetVisible(false)
	
	cbh.PlayerPlanarChargeLocationText:SetPoint("TOPLEFT", cbh.PlayerPlanarChargeOptions, "TOPLEFT", 5, 0)
	cbh.PlayerPlanarChargeLocationText:SetFontSize(15)
	cbh.PlayerPlanarChargeLocationText:SetText("Player Planar Charge Location/Size")

	cbh.PlayerPlanarChargeToggle:SetPoint("TOPLEFT", cbh.PlayerPlanarChargeLocationText, "TOPLEFT", 0, 30)
	cbh.PlayerPlanarChargeToggle:SetFontSize(14)
	cbh.PlayerPlanarChargeToggle:SetLayer(1)
	cbh.PlayerPlanarChargeToggle:SetText("Charges Always Visible (default: mouseover)")
	cbh.PlayerPlanarChargeToggle:SetChecked(cbhPlayerValues.planarchargealwaysshow == true)
	function cbh.PlayerPlanarChargeToggle.Event.CheckboxChange()
		cbhPlayerValues.planarchargealwaysshow = cbh.PlayerPlanarChargeToggle:GetChecked()
		if cbhPlayerValues.planarchargealwaysshow then
			cbh.PlayerPlanarCharge:SetAlpha(1)
			cbh.PlayerPlanarChargeText:SetAlpha(1)
		else
			cbh.PlayerPlanarCharge:SetAlpha(0)
			cbh.PlayerPlanarChargeText:SetAlpha(0)
		end
	end

	cbh.PlayerPlanarChargeSizer:SetPoint("TOPLEFT", cbh.PlayerPlanarChargeLocationText, "TOPLEFT", 0, 60)
	cbh.PlayerPlanarChargeSizer:SetRange(0, 72)
	cbh.PlayerPlanarChargeSizer:SetWidth(125)
	cbh.PlayerPlanarChargeSizer:SetPosition(cbhPlayerValues.planarchargesize)
	function cbh.PlayerPlanarChargeSizer.Event.SliderChange()
		cbhPlayerValues.planarchargesize = (cbh.PlayerPlanarChargeSizer:GetPosition())
		cbh.PlayerPlanarCharge:SetWidth(cbhPlayerValues.planarchargesize)
		cbh.PlayerPlanarCharge:SetHeight(cbhPlayerValues.planarchargesize)
	end

	cbh.PlayerPlanarChargeLocation:SetPoint("TOPLEFT", cbh.PlayerPlanarChargeSizer, "TOPRIGHT", 10, 0)
	cbh.PlayerPlanarChargeLocation:SetLayer(5)
	cbh.PlayerPlanarChargeLocation:SetFontSize(14)
	cbh.PlayerPlanarChargeLocation:SetItems(cbh.SetPoint)
	cbh.PlayerPlanarChargeLocation:SetSelectedItem(cbhPlayerValues.planarchargelocation, silent)
	cbh.PlayerPlanarChargeLocation:SetWidth(125)
	cbh.PlayerPlanarChargeLocation.Event.ItemSelect = function(view, item)
		cbhPlayerValues.planarchargelocation = item
		cbh.PlayerPlanarCharge:ClearAll()
		cbh.PlayerPlanarCharge:SetPoint(cbhPlayerValues.planarchargelocation, cbh.PlayerFrame, cbhPlayerValues.planarchargelocation, cbhPlayerValues.planarchargeoffsetx, cbhPlayerValues.planarchargeoffsety)
		cbh.PlayerPlanarCharge:SetWidth(cbhPlayerValues.planarchargesize)
		cbh.PlayerPlanarCharge:SetHeight(cbhPlayerValues.planarchargesize)
	end
	
	-- PLAYER PlanarCharge OFFSET
	cbh.PlayerPlanarChargeOffsetText:SetPoint("TOPLEFT", cbh.PlayerPlanarChargeSizer, "TOPLEFT", 0, 40)
	cbh.PlayerPlanarChargeOffsetText:SetFontSize(15)
	cbh.PlayerPlanarChargeOffsetText:SetText("Offset PlanarCharge: x, y")
	cbh.PlayerPlanarChargeOffsetX:SetPoint("TOPLEFT", cbh.PlayerPlanarChargeOffsetText, "TOPLEFT", 0, 30)
	cbh.PlayerPlanarChargeOffsetX:SetRange(-100, 100)
	cbh.PlayerPlanarChargeOffsetX:SetPosition(cbhPlayerValues.planarchargeoffsetx)
	function cbh.PlayerPlanarChargeOffsetX.Event.SliderChange()
		cbhPlayerValues.planarchargeoffsetx = (cbh.PlayerPlanarChargeOffsetX:GetPosition())
		cbh.PlayerPlanarCharge:ClearPoint(x, y)
		cbh.PlayerPlanarCharge:SetPoint(cbhPlayerValues.planarchargelocation, cbh.PlayerFrame, cbhPlayerValues.planarchargelocation, cbhPlayerValues.planarchargeoffsetx, cbhPlayerValues.planarchargeoffsety)
	end
	cbh.PlayerPlanarChargeOffsetY:SetPoint("TOPLEFT", cbh.PlayerPlanarChargeOffsetX, "TOPLEFT", 0, 30)
	cbh.PlayerPlanarChargeOffsetY:SetRange(-100, 100)
	cbh.PlayerPlanarChargeOffsetY:SetPosition(cbhPlayerValues.planarchargeoffsety)
	function cbh.PlayerPlanarChargeOffsetY.Event.SliderChange()
		cbhPlayerValues.planarchargeoffsety = (cbh.PlayerPlanarChargeOffsetY:GetPosition())
		cbh.PlayerPlanarCharge:ClearPoint(x, y)
		cbh.PlayerPlanarCharge:SetPoint(cbhPlayerValues.planarchargelocation, cbh.PlayerFrame, cbhPlayerValues.planarchargelocation, cbhPlayerValues.planarchargeoffsetx, cbhPlayerValues.planarchargeoffsety)
	end

	
	
	--[[ VITALITY ICON OPTIONS ]]--
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.PlayerVitalityOptions:SetPoint("TOPLEFT", cbh.PlayerPositionPieces, "TOPRIGHT", 10, 0)
	cbh.PlayerVitalityOptions:SetBackgroundColor(.25, .25, .25, .5)
	cbh.PlayerVitalityOptions:SetWidth(300)
	cbh.PlayerVitalityOptions:SetHeight(cbh.PlayerPositionPieces:GetHeight())
	cbh.PlayerVitalityOptions:SetVisible(false)
	
	cbh.PlayerVitalityLocationText:SetPoint("TOPLEFT", cbh.PlayerVitalityOptions, "TOPLEFT", 5, 0)
	cbh.PlayerVitalityLocationText:SetFontSize(15)
	cbh.PlayerVitalityLocationText:SetText("Player Planar Charge Location/Size")

	cbh.PlayerVitalityToggle:SetPoint("TOPLEFT", cbh.PlayerVitalityLocationText, "TOPLEFT", 0, 30)
	cbh.PlayerVitalityToggle:SetFontSize(14)
	cbh.PlayerVitalityToggle:SetLayer(1)
	cbh.PlayerVitalityToggle:SetText("Vitality Always Visible (default: mouseover)")
	cbh.PlayerVitalityToggle:SetChecked(cbhPlayerValues.vitalityalwaysshow == true)
	function cbh.PlayerVitalityToggle.Event.CheckboxChange()
		cbhPlayerValues.vitalityalwaysshow = cbh.PlayerVitalityToggle:GetChecked()
		if cbhPlayerValues.vitalityalwaysshow then
			cbh.PlayerVitality:SetAlpha(1)
			cbh.PlayerVitalityText:SetAlpha(1)
		else
			cbh.PlayerVitality:SetAlpha(0)
			cbh.PlayerVitalityText:SetAlpha(0)
		end
	end

	cbh.PlayerVitalitySizer:SetPoint("TOPLEFT", cbh.PlayerVitalityLocationText, "TOPLEFT", 0, 60)
	cbh.PlayerVitalitySizer:SetRange(0, 72)
	cbh.PlayerVitalitySizer:SetWidth(125)
	cbh.PlayerVitalitySizer:SetPosition(cbhPlayerValues.vitalitysize)
	function cbh.PlayerVitalitySizer.Event.SliderChange()
		cbhPlayerValues.vitalitysize = (cbh.PlayerVitalitySizer:GetPosition())
		cbh.PlayerVitality:SetWidth(cbhPlayerValues.vitalitysize)
		cbh.PlayerVitality:SetHeight(cbhPlayerValues.vitalitysize)
	end

	cbh.PlayerVitalityLocation:SetPoint("TOPLEFT", cbh.PlayerVitalitySizer, "TOPRIGHT", 10, 0)
	cbh.PlayerVitalityLocation:SetLayer(5)
	cbh.PlayerVitalityLocation:SetFontSize(14)
	cbh.PlayerVitalityLocation:SetItems(cbh.SetPoint)
	cbh.PlayerVitalityLocation:SetSelectedItem(cbhPlayerValues.vitalitylocation, silent)
	cbh.PlayerVitalityLocation:SetWidth(125)
	cbh.PlayerVitalityLocation.Event.ItemSelect = function(view, item)
		cbhPlayerValues.vitalitylocation = item
		cbh.PlayerVitality:ClearAll()
		cbh.PlayerVitality:SetPoint(cbhPlayerValues.vitalitylocation, cbh.PlayerFrame, cbhPlayerValues.vitalitylocation, cbhPlayerValues.vitalityoffsetx, cbhPlayerValues.vitalityoffsety)
		cbh.PlayerVitality:SetWidth(cbhPlayerValues.vitalitysize)
		cbh.PlayerVitality:SetHeight(cbhPlayerValues.vitalitysize)
	end
	
	-- PLAYER Vitality OFFSET
	cbh.PlayerVitalityOffsetText:SetPoint("TOPLEFT", cbh.PlayerVitalitySizer, "TOPLEFT", 0, 40)
	cbh.PlayerVitalityOffsetText:SetFontSize(15)
	cbh.PlayerVitalityOffsetText:SetText("Offset Vitality: x, y")
	cbh.PlayerVitalityOffsetX:SetPoint("TOPLEFT", cbh.PlayerVitalityOffsetText, "TOPLEFT", 0, 30)
	cbh.PlayerVitalityOffsetX:SetRange(-100, 100)
	cbh.PlayerVitalityOffsetX:SetPosition(cbhPlayerValues.vitalityoffsetx)
	function cbh.PlayerVitalityOffsetX.Event.SliderChange()
		cbhPlayerValues.vitalityoffsetx = (cbh.PlayerVitalityOffsetX:GetPosition())
		cbh.PlayerVitality:ClearPoint(x, y)
		cbh.PlayerVitality:SetPoint(cbhPlayerValues.vitalitylocation, cbh.PlayerFrame, cbhPlayerValues.vitalitylocation, cbhPlayerValues.vitalityoffsetx, cbhPlayerValues.vitalityoffsety)
	end
	cbh.PlayerVitalityOffsetY:SetPoint("TOPLEFT", cbh.PlayerVitalityOffsetX, "TOPLEFT", 0, 30)
	cbh.PlayerVitalityOffsetY:SetRange(-100, 100)
	cbh.PlayerVitalityOffsetY:SetPosition(cbhPlayerValues.vitalityoffsety)
	function cbh.PlayerVitalityOffsetY.Event.SliderChange()
		cbhPlayerValues.vitalityoffsety = (cbh.PlayerVitalityOffsetY:GetPosition())
		cbh.PlayerVitality:ClearPoint(x, y)
		cbh.PlayerVitality:SetPoint(cbhPlayerValues.vitalitylocation, cbh.PlayerFrame, cbhPlayerValues.vitalitylocation, cbhPlayerValues.vitalityoffsetx, cbhPlayerValues.vitalityoffsety)
	end

	
	

	
	--[[ BUFF OPTIONS ]]--
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.PlayerBuffOptions:SetPoint("TOPLEFT", cbh.PlayerPositionPieces, "TOPRIGHT", 10, 0)
	cbh.PlayerBuffOptions:SetBackgroundColor(.25, .25, .25, .5)
	cbh.PlayerBuffOptions:SetWidth(300)
	cbh.PlayerBuffOptions:SetHeight(cbh.PlayerPositionPieces:GetHeight())
	cbh.PlayerBuffOptions:SetVisible(false)
	
	cbh.PlayerBuffLocationText:SetPoint("TOPLEFT", cbh.PlayerBuffOptions, "TOPLEFT", 0, 0)
	cbh.PlayerBuffLocationText:SetFontSize(16)
	cbh.PlayerBuffLocationText:SetText("Player Buff Location")

	cbh.PlayerBuffLocation:SetPoint("TOPLEFT", cbh.PlayerBuffLocationText, "TOPLEFT", 0, 30)
	cbh.PlayerBuffLocation:SetFontSize(14)
	cbh.PlayerBuffLocation:SetLayer(1)
	cbh.PlayerBuffLocation:SetText("Toggle buffs above/below frame")
	cbh.PlayerBuffLocation:SetChecked(cbhPlayerValues.buffontop == true)
	function cbh.PlayerBuffLocation.Event.CheckboxChange()
		cbhPlayerValues.buffontop = cbh.PlayerBuffLocation:GetChecked()
		if cbhPlayerValues.buffontop and cbhPlayerValues.buffreverse then
			cbhPlayerValues.bufflocation = "BOTTOMRIGHT"
			cbhPlayerValues.buffattach = "TOPRIGHT"
		elseif cbhPlayerValues.buffontop and not cbhPlayerValues.buffreverse then
			cbhPlayerValues.bufflocation = "BOTTOMLEFT"
			cbhPlayerValues.buffattach = "TOPLEFT"
		elseif not cbhPlayerValues.buffontop and cbhPlayerValues.buffreverse then
			cbhPlayerValues.bufflocation = "TOPRIGHT"
			cbhPlayerValues.buffattach = "BOTTOMRIGHT"
		elseif not cbhPlayerValues.buffontop and not cbhPlayerValues.buffreverse then
			cbhPlayerValues.bufflocation = "TOPLEFT"
			cbhPlayerValues.buffattach = "BOTTOMLEFT"
		end
		local tbuffsize = (cbhPlayerValues.fwidth/cbhPlayerValues.buffcount)-(4*cbhPlayerValues.buffcount/cbhPlayerValues.buffcount)
		local bufftempx = 0
		for i = 1, cbhPlayerValues.buffcount do
			cbh.PlayerBuffs[i]:ClearAll()
			cbh.PlayerBuffs[i]:SetPoint(cbhPlayerValues.bufflocation, cbh.PlayerFrame, cbhPlayerValues.buffattach, bufftempx, cbhPlayerValues.buffoffsety)
			cbh.PlayerBuffs[i]:SetLayer(2)
			cbh.PlayerBuffs[i]:SetWidth(tbuffsize)
			cbh.PlayerBuffs[i]:SetHeight(tbuffsize)
			bufftempx = (tbuffsize+5)*i
			if cbhPlayerValues.buffreverse then	bufftempx = -(bufftempx) end
		end
	end


	cbh.PlayerBuffReverseToggle:SetPoint("TOPLEFT", cbh.PlayerBuffLocationText, "TOPLEFT", 0, 60)
	cbh.PlayerBuffReverseToggle:SetFontSize(14)
	cbh.PlayerBuffReverseToggle:SetLayer(1)
	cbh.PlayerBuffReverseToggle:SetText("Buff order right to left")
	cbh.PlayerBuffReverseToggle:SetChecked(cbhPlayerValues.buffreverse == true)
	function cbh.PlayerBuffReverseToggle.Event.CheckboxChange()
		cbhPlayerValues.buffreverse = cbh.PlayerBuffReverseToggle:GetChecked()
		if cbhPlayerValues.buffontop and cbhPlayerValues.buffreverse then
			cbhPlayerValues.bufflocation = "BOTTOMRIGHT"
			cbhPlayerValues.buffattach = "TOPRIGHT"
		elseif cbhPlayerValues.buffontop and not cbhPlayerValues.buffreverse then
			cbhPlayerValues.bufflocation = "BOTTOMLEFT"
			cbhPlayerValues.buffattach = "TOPLEFT"
		elseif not cbhPlayerValues.buffontop and cbhPlayerValues.buffreverse then
			cbhPlayerValues.bufflocation = "TOPRIGHT"
			cbhPlayerValues.buffattach = "BOTTOMRIGHT"
		elseif not cbhPlayerValues.buffontop and not cbhPlayerValues.buffreverse then
			cbhPlayerValues.bufflocation = "TOPLEFT"
			cbhPlayerValues.buffattach = "BOTTOMLEFT"
		end
		local tbuffsize = (cbhPlayerValues.fwidth/cbhPlayerValues.buffcount)-(4*cbhPlayerValues.buffcount/cbhPlayerValues.buffcount)
		local bufftempx = 0
		for i = 1, cbhPlayerValues.buffcount do
			cbh.PlayerBuffs[i]:ClearAll()
			cbh.PlayerBuffs[i]:SetPoint(cbhPlayerValues.bufflocation, cbh.PlayerFrame, cbhPlayerValues.buffattach, bufftempx, cbhPlayerValues.buffoffsety)
			cbh.PlayerBuffs[i]:SetLayer(2)
			cbh.PlayerBuffs[i]:SetWidth(tbuffsize)
			cbh.PlayerBuffs[i]:SetHeight(tbuffsize)
			bufftempx = (tbuffsize+5)*i
			if cbhPlayerValues.buffreverse then	bufftempx = -(bufftempx) end
		end
	end

	
	cbh.PlayerBuffSizerText:SetPoint("TOPLEFT", cbh.PlayerBuffLocationText, "TOPLEFT", 0, 90)
	cbh.PlayerBuffSizerText:SetFontSize(15)
	cbh.PlayerBuffSizerText:SetText("Player Buff Count")
	cbh.PlayerBuffSizer:SetPoint("TOPLEFT", cbh.PlayerBuffSizerText, "TOPLEFT", 0, 30)
	cbh.PlayerBuffSizer:SetRange(0, 12)
	cbh.PlayerBuffSizer:SetWidth(125)
	cbh.PlayerBuffSizer:SetPosition(cbhPlayerValues.buffcount)
	function cbh.PlayerBuffSizer.Event.SliderChange()
		cbhPlayerValues.buffcount = (cbh.PlayerBuffSizer:GetPosition())
		local tbuffsize = (cbhPlayerValues.fwidth/cbhPlayerValues.buffcount)-(4*cbhPlayerValues.buffcount/cbhPlayerValues.buffcount)
		local bufftempx = 0
		for i = 1, cbhPlayerValues.buffcount do
			if not cbh.PlayerBuffs[i] then
				cbh.PlayerBuffs[i] = UI.CreateFrame("Texture", "PlayerBuffs", cbh.PlayerWindow)
				cbh.PlayerBuffsCounter[i] = UI.CreateFrame("Text", "PlayerBuffsCounter", cbh.PlayerWindow)
				cbh.PlayerBuffsStackCounter[i] = UI.CreateFrame("Text", "PlayerBuffsStackCounter", cbh.PlayerWindow)
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
			cbh.PlayerBuffs[i]:ClearAll()
			cbh.PlayerBuffs[i]:SetPoint(cbhPlayerValues.bufflocation, cbh.PlayerFrame, cbhPlayerValues.buffattach, bufftempx, cbhPlayerValues.buffoffsety)
			cbh.PlayerBuffs[i]:SetLayer(2)
			cbh.PlayerBuffs[i]:SetWidth(tbuffsize)
			cbh.PlayerBuffs[i]:SetHeight(tbuffsize)
			bufftempx = (tbuffsize+5)*i
			if cbhPlayerValues.buffreverse then	bufftempx = -(bufftempx) end
		end
	end

	-- PLAYER Buff OFFSET
	cbh.PlayerBuffOffsetText:SetPoint("TOPLEFT", cbh.PlayerBuffSizer, "TOPLEFT", 0, 40)
	cbh.PlayerBuffOffsetText:SetFontSize(15)
	cbh.PlayerBuffOffsetText:SetText("Offset Buffs Vertical")
	-- cbh.PlayerBuffOffsetX:SetPoint("TOPLEFT", cbh.PlayerBuffOffsetText, "TOPLEFT", 0, 30)
	-- cbh.PlayerBuffOffsetX:SetRange(-100, 100)
	-- cbh.PlayerBuffOffsetX:SetPosition(cbhPlayerValues.Buffoffsetx)
	-- function cbh.PlayerBuffOffsetX.Event.SliderChange()
		-- cbhPlayerValues.Buffoffsetx = (cbh.PlayerBuffOffsetX:GetPosition())
		-- cbh.PlayerBuff:ClearPoint(x, y)
		-- cbh.PlayerBuff:SetPoint(cbhPlayerValues.Bufflocation, cbh.PlayerFrame, cbhPlayerValues.Bufflocation, cbhPlayerValues.Buffoffsetx, cbhPlayerValues.Buffoffsety)
	-- end
	-- cbh.PlayerBuffOffsetY:SetPoint("TOPLEFT", cbh.PlayerBuffOffsetX, "TOPLEFT", 0, 30)
	cbh.PlayerBuffOffsetY:SetPoint("TOPLEFT", cbh.PlayerBuffOffsetText, "TOPLEFT", 0, 30)
	cbh.PlayerBuffOffsetY:SetRange(-100, 100)
	cbh.PlayerBuffOffsetY:SetPosition(cbhPlayerValues.buffoffsety)
	function cbh.PlayerBuffOffsetY.Event.SliderChange()
		cbhPlayerValues.buffoffsety = (cbh.PlayerBuffOffsetY:GetPosition())
		local tbuffsize = (cbhPlayerValues.fwidth/cbhPlayerValues.buffcount)-(4*cbhPlayerValues.buffcount/cbhPlayerValues.buffcount)
		local bufftempx = 0
		for i = 1, cbhPlayerValues.buffcount do
			cbh.PlayerBuffs[i]:ClearAll()
			cbh.PlayerBuffs[i]:SetPoint(cbhPlayerValues.bufflocation, cbh.PlayerFrame, cbhPlayerValues.buffattach, bufftempx, cbhPlayerValues.buffoffsety)
			cbh.PlayerBuffs[i]:SetLayer(2)
			cbh.PlayerBuffs[i]:SetWidth(tbuffsize)
			cbh.PlayerBuffs[i]:SetHeight(tbuffsize)
			bufftempx = (tbuffsize+5)*i
			if cbhPlayerValues.buffreverse then	bufftempx = -(bufftempx) end
		end
	end
end



--[[

NOTES

]]--