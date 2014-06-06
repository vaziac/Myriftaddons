--[[
file: optionWindow.lua
by: Solsis00
for: ClickBoxHealer

This file houses the configuration window for CBH.

**COMPLETE: Converted to local cbh table successfully.
]]--


local addon, cbh = ...


function cbh.TargetConfigCreate()
	cbh.TargetConfig = UI.CreateFrame("SimpleTabView", "OptionsWindowFrame", cbh.WindowOptions)
	cbh.TargetConfigA = UI.CreateFrame("Frame", "TargetConfigA", cbh.TargetConfig)
	-- cbh.TargetConfigB = UI.CreateFrame("Frame", "TargetConfigB", cbh.TargetConfig)
	-- cbh.TargetConfigC = UI.CreateFrame("Frame", "TargetConfigC", cbh.TargetConfig)
	cbh.TargetConfig:AddTab("Basics", cbh.TargetConfigA)
	-- cbh.TargetConfig:AddTab("Appearance", cbh.TargetConfigB)
	-- cbh.TargetConfig:AddTab("Positioning", cbh.TargetConfigC)
	
	
	--[[ XXXXXXXXXXXXXXXXXXXXXXX ]]--
	--				BASICS TAB
	--[[ XXXXXXXXXXXXXXXXXXXXXXX ]]--
	cbh.TargetFrameToggle = UI.CreateFrame("SimpleCheckbox", "TargetFrameToggle", cbh.TargetConfigA)
	
	
	--[[ APPEARANCES TAB ]]--
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.TargetTextureText = UI.CreateFrame("Text", "TargetTextureText", cbh.TargetConfigA)
	cbh.TargetTexture = UI.CreateFrame("SimpleSelect", "TargetTexture", cbh.TargetConfigA)
	cbh.TargetTextureDup = UI.CreateFrame("SimpleCheckbox", "TargetTextureDup", cbh.TargetConfigA)

	-- CUSTOM COLOR SELECTIONS
	cbh.TargetPieces = {"Healthbar", "Health backdrop", "Resource bar", "Name", "Percentage"}
	cbh.TargetColorOptions = UI.CreateFrame("Frame", "TargetColorOptions", cbh.TargetConfigA)
	cbh.TargetColorOptionsText = UI.CreateFrame("Text", "TargetColorOptionsText", cbh.TargetConfigA)
	cbh.TargetColorPieces = UI.CreateFrame("SimpleList", "TargetColorPiecesList", cbh.TargetConfigA)
	cbh.TargetClassColor = UI.CreateFrame("SimpleCheckbox", "TargetClassColor", cbh.TargetConfigA)
	cbh.TargetGradients = UI.CreateFrame("SimpleCheckbox", "TargetGradients", cbh.TargetConfigA)
	
	-- CUSTOM COLOR SLIDERS
	cbh.TargetColorSliderR = UI.CreateFrame("SimpleSlider", "TargetColorSliderR", cbh.TargetConfigA)
	cbh.TargetColorSliderG = UI.CreateFrame("SimpleSlider", "TargetColorSliderG", cbh.TargetConfigA)
	cbh.TargetColorSliderB = UI.CreateFrame("SimpleSlider", "TargetColorSliderB", cbh.TargetConfigA)
	cbh.TargetColorSliderA = UI.CreateFrame("SimpleSlider", "TargetColorSliderA", cbh.TargetConfigA)
	cbh.TargetColorSliderText = UI.CreateFrame("Text", "TextCallingColor", cbh.TargetConfigA)

	

	--[[ POSITIONING TAB ]]--
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.TargetPositionList = {"Healthbar", "Resource bar", "Name", "Level", "Percentage","Role Icon", "Raid Mark", "PvP Mark", "Tier Icon", "Public Groups", "Buffs", "Debuffs"}
	cbh.TargetPositionPieces = UI.CreateFrame("SimpleList", "TargetColorPiecesList", cbh.TargetConfigA)

	cbh.TargetHealthbarOptions = UI.CreateFrame("Frame", "TargetHealthbarOptions", cbh.TargetConfigA)
	cbh.TargetHealthbarLocationText = UI.CreateFrame("Text", "HealthbarLocationText", cbh.TargetHealthbarOptions)
	cbh.TargetHealthbarSizerW = UI.CreateFrame("SimpleSlider", "TargetHealthbarSizerW", cbh.TargetHealthbarOptions)
	cbh.TargetHealthbarSizerH = UI.CreateFrame("SimpleSlider", "TargetHealthbarSizerH", cbh.TargetHealthbarOptions)

	cbh.TargetManabarOptions = UI.CreateFrame("Frame", "TargetManabarOptions", cbh.TargetConfigA)
	cbh.TargetManabarLocationText = UI.CreateFrame("Text", "ManabarLocationText", cbh.TargetManabarOptions)
	cbh.TargetManabarSizerH = UI.CreateFrame("SimpleSlider", "TargetManabarSizer", cbh.TargetManabarOptions)

	cbh.TargetNameOptions = UI.CreateFrame("Frame", "TargetNameOptions", cbh.TargetConfigA)
	cbh.TargetNameLocation = UI.CreateFrame("SimpleSelect", "NameLocation", cbh.TargetNameOptions)
	cbh.TargetNameLocationText = UI.CreateFrame("Text", "NameLocationText", cbh.TargetNameOptions)
	cbh.TargetNameLengthOption = UI.CreateFrame("SimpleCheckbox", "NameLengthOption", cbh.TargetNameOptions)
	cbh.TargetNameLength = UI.CreateFrame("SimpleSlider", "NameLength", cbh.TargetNameOptions)
	cbh.TargetNameFontSizer = UI.CreateFrame("SimpleSlider", "TargetNameFontSizer", cbh.TargetNameOptions)
	cbh.TargetNameOffsetText = UI.CreateFrame("Text", "TargetNameOffsetX", cbh.TargetNameOptions)
	cbh.TargetNameOffsetX = UI.CreateFrame("SimpleSlider", "TargetNameOffsetX", cbh.TargetNameOptions)
	cbh.TargetNameOffsetY = UI.CreateFrame("SimpleSlider", "TargetNameOffsetY", cbh.TargetNameOptions)

	cbh.TargetLevelOptions = UI.CreateFrame("Frame", "TargetLevelOptions", cbh.TargetConfigA)
	cbh.TargetLevelLocationText = UI.CreateFrame("Text", "LevelLocationText", cbh.TargetLevelOptions)
	cbh.TargetLevelSizer = UI.CreateFrame("SimpleSlider", "TargetLevelSizer", cbh.TargetLevelOptions)
	cbh.TargetLevelLocation = UI.CreateFrame("SimpleSelect", "LevelLocation", cbh.TargetLevelOptions)
	cbh.TargetLevelOffsetText = UI.CreateFrame("Text", "TargetLevelOffsetX", cbh.TargetLevelOptions)
	cbh.TargetLevelOffsetX = UI.CreateFrame("SimpleSlider", "TargetLevelOffsetX", cbh.TargetLevelOptions)
	cbh.TargetLevelOffsetY = UI.CreateFrame("SimpleSlider", "TargetLevelOffsetY", cbh.TargetLevelOptions)

	cbh.TargetPercentOptions = UI.CreateFrame("Frame", "TargetPercentOptions", cbh.TargetConfigA)
	cbh.TargetPercentLocationText = UI.CreateFrame("Text", "PercentLocationText", cbh.TargetPercentOptions)
	cbh.TargetPercentToggle = UI.CreateFrame("SimpleCheckbox", "TargetPercentToggle", cbh.TargetPercentOptions)
	cbh.TargetPercentSizer = UI.CreateFrame("SimpleSlider", "TargetPercentSizer", cbh.TargetPercentOptions)
	cbh.TargetPercentLocation = UI.CreateFrame("SimpleSelect", "PercentLocation", cbh.TargetPercentOptions)
	cbh.TargetPercentOffsetText = UI.CreateFrame("Text", "TargetPercentOffsetX", cbh.TargetPercentOptions)
	cbh.TargetPercentOffsetX = UI.CreateFrame("SimpleSlider", "TargetPercentOffsetX", cbh.TargetPercentOptions)
	cbh.TargetPercentOffsetY = UI.CreateFrame("SimpleSlider", "TargetPercentOffsetY", cbh.TargetPercentOptions)

	cbh.TargetRoleOptions = UI.CreateFrame("Frame", "TargetRoleOptions", cbh.TargetConfigA)
	cbh.TargetRoleLocationText = UI.CreateFrame("Text", "RoleLocationText", cbh.TargetRoleOptions)
	cbh.TargetRoleToggle = UI.CreateFrame("SimpleCheckbox", "TargetRoleToggle", cbh.TargetRoleOptions)
	cbh.TargetRoleSizer = UI.CreateFrame("SimpleSlider", "TargetRoleSizer", cbh.TargetRoleOptions)
	cbh.TargetRoleLocation = UI.CreateFrame("SimpleSelect", "RoleLocation", cbh.TargetRoleOptions)
	cbh.TargetRoleOffsetText = UI.CreateFrame("Text", "TargetRoleOffsetX", cbh.TargetRoleOptions)
	cbh.TargetRoleOffsetX = UI.CreateFrame("SimpleSlider", "TargetRoleOffsetX", cbh.TargetRoleOptions)
	cbh.TargetRoleOffsetY = UI.CreateFrame("SimpleSlider", "TargetRoleOffsetY", cbh.TargetRoleOptions)

	cbh.TargetRaidMarkOptions = UI.CreateFrame("Frame", "TargetRaidMarkOptions", cbh.TargetConfigA)
	cbh.TargetRaidMarkLocationText = UI.CreateFrame("Text", "RaidMarkLocationText", cbh.TargetRaidMarkOptions)
	cbh.TargetRaidMarkSizer = UI.CreateFrame("SimpleSlider", "TargetRaidMarkSizer", cbh.TargetRaidMarkOptions)
	cbh.TargetRaidMarkLocation = UI.CreateFrame("SimpleSelect", "RaidMarkLocation", cbh.TargetRaidMarkOptions)
	cbh.TargetRaidMarkOffsetText = UI.CreateFrame("Text", "TargetRaidMarkOffsetX", cbh.TargetRaidMarkOptions)
	cbh.TargetRaidMarkOffsetX = UI.CreateFrame("SimpleSlider", "TargetRaidMarkOffsetX", cbh.TargetRaidMarkOptions)
	cbh.TargetRaidMarkOffsetY = UI.CreateFrame("SimpleSlider", "TargetRaidMarkOffsetY", cbh.TargetRaidMarkOptions)

	cbh.TargetPvPMarkOptions = UI.CreateFrame("Frame", "TargetPvPMarkOptions", cbh.TargetConfigA)
	cbh.TargetPvPMarkLocationText = UI.CreateFrame("Text", "PvPMarkLocationText", cbh.TargetPvPMarkOptions)
	-- cbh.TargetPvPMarkToggle = UI.CreateFrame("SimpleCheckbox", "TargetPvPMarkToggle", cbh.TargetPvPMarkOptions)
	-- cbh.TargetPvPMarkSizer = UI.CreateFrame("SimpleSlider", "TargetPvPMarkSizer", cbh.TargetPvPMarkOptions)
	-- cbh.TargetPvPMarkLocation = UI.CreateFrame("SimpleSelect", "PvPMarkLocation", cbh.TargetPvPMarkOptions)
	-- cbh.TargetPvPMarkOffsetText = UI.CreateFrame("Text", "TargetPvPMarkOffsetText", cbh.TargetPvPMarkOptions)
	-- cbh.TargetPvPMarkOffsetX = UI.CreateFrame("SimpleSlider", "TargetPvPMarkOffsetX", cbh.TargetPvPMarkOptions)
	-- cbh.TargetPvPMarkOffsetY = UI.CreateFrame("SimpleSlider", "TargetPvPMarkOffsetY", cbh.TargetPvPMarkOptions)

	cbh.TargetTierOptions = UI.CreateFrame("Frame", "TargetTierOptions", cbh.TargetConfigA)
	cbh.TargetTierLocationText = UI.CreateFrame("Text", "TierLocationText", cbh.TargetTierOptions)
	cbh.TargetTierSizer = UI.CreateFrame("SimpleSlider", "TargetTierSizer", cbh.TargetTierOptions)
	cbh.TargetTierLocation = UI.CreateFrame("SimpleSelect", "TierLocation", cbh.TargetTierOptions)
	cbh.TargetTierOffsetText = UI.CreateFrame("Text", "TargetTierOffsetText", cbh.TargetTierOptions)
	cbh.TargetTierOffsetX = UI.CreateFrame("SimpleSlider", "TargetTierOffsetX", cbh.TargetTierOptions)
	cbh.TargetTierOffsetY = UI.CreateFrame("SimpleSlider", "TargetTierOffsetY", cbh.TargetTierOptions)

	cbh.TargetPublicIconOptions = UI.CreateFrame("Frame", "TargetPublicIconOptions", cbh.TargetConfigA)
	cbh.TargetPublicIconLocationText = UI.CreateFrame("Text", "PublicIconLocationText", cbh.TargetPublicIconOptions)
	cbh.TargetPublicIconSizer = UI.CreateFrame("SimpleSlider", "TargetPublicIconSizer", cbh.TargetPublicIconOptions)
	cbh.TargetPublicIconLocation = UI.CreateFrame("SimpleSelect", "PublicIconLocation", cbh.TargetPublicIconOptions)
	cbh.TargetPublicIconOffsetText = UI.CreateFrame("Text", "TargetPublicIconOffsetText", cbh.TargetPublicIconOptions)
	cbh.TargetPublicIconOffsetX = UI.CreateFrame("SimpleSlider", "TargetPublicIconOffsetX", cbh.TargetPublicIconOptions)
	cbh.TargetPublicIconOffsetY = UI.CreateFrame("SimpleSlider", "TargetPublicIconOffsetY", cbh.TargetPublicIconOptions)


	-- buff setup
	cbh.TargetBuffsOptions = UI.CreateFrame("Frame", "TargetBuffsOptions", cbh.TargetConfigA)
	cbh.TargetBuffsLocationText = UI.CreateFrame("Text", "BuffLocationText", cbh.TargetBuffsOptions)
	cbh.TargetBuffsReverseToggle = UI.CreateFrame("SimpleCheckbox", "TargetBuffsReverseToggle", cbh.TargetBuffsOptions)
	cbh.TargetBuffsSizerText = UI.CreateFrame("Text", "TargetBuffsSizerText", cbh.TargetBuffsOptions)
	cbh.TargetBuffsSizer = UI.CreateFrame("SimpleSlider", "TargetBuffsSizer", cbh.TargetBuffsOptions)
	cbh.TargetBuffsLocation = UI.CreateFrame("SimpleCheckbox", "BuffLocation", cbh.TargetBuffsOptions)
	cbh.TargetBuffsOffsetText = UI.CreateFrame("Text", "TargetBuffsOffsetText", cbh.TargetBuffsOptions)
	-- cbh.TargetBuffsOffsetX = UI.CreateFrame("SimpleSlider", "TargetBuffsOffsetX", cbh.TargetBuffsOptions)
	cbh.TargetBuffsOffsetY = UI.CreateFrame("SimpleSlider", "TargetBuffsOffsetY", cbh.TargetBuffsOptions)

	cbh.TargetDebuffsOptions = UI.CreateFrame("Frame", "TargetDebuffsOptions", cbh.TargetConfigA)
	cbh.TargetDebuffsLocationText = UI.CreateFrame("Text", "TargetDebuffsLocationText", cbh.TargetDebuffsOptions)
	cbh.TargetDebuffsReverseToggle = UI.CreateFrame("SimpleCheckbox", "TargetDebuffsReverseToggle", cbh.TargetDebuffsOptions)
	cbh.TargetDebuffsSizerText = UI.CreateFrame("Text", "TargetDebuffsSizerText", cbh.TargetDebuffsOptions)
	cbh.TargetDebuffsSizer = UI.CreateFrame("SimpleSlider", "TargetDebuffsSizer", cbh.TargetDebuffsOptions)
	cbh.TargetDebuffsLocation = UI.CreateFrame("SimpleCheckbox", "TargetDebuffsLocation", cbh.TargetDebuffsOptions)
	cbh.TargetDebuffsOffsetText = UI.CreateFrame("Text", "TargetDebuffsOffsetText", cbh.TargetDebuffsOptions)
	-- cbh.TargetDebuffsOffsetX = UI.CreateFrame("SimpleSlider", "TargetDebuffsOffsetX", cbh.TargetDebuffsOptions)
	cbh.TargetDebuffsOffsetY = UI.CreateFrame("SimpleSlider", "TargetDebuffsOffsetY", cbh.TargetDebuffsOptions)
end


--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
--			OPTION WINDOW SETUP
--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]

function cbh.TargetConfigSetup()
	if cbhValues.isincombat then return end

	-- Calls the creation of the frames objects
	cbh.TargetConfigCreate()
	
	-- Target option window
	cbh.TargetConfig:SetPoint("TOPLEFT", cbh.WindowOptions, "TOPLEFT", 15, 20)
	cbh.TargetConfig:SetPoint("BOTTOMRIGHT", cbh.WindowOptions, "BOTTOMRIGHT", -15, -15)
	cbh.TargetConfig:SetBackgroundColor(0, 0, 0, 0)
	cbh.TargetConfig:SetTabContentBackgroundColor(0, 0, 0, 0.6)
	cbh.TargetConfig:SetActiveTabBackgroundColor(0.1, 0.3, 0.1, 0.9)
	cbh.TargetConfig:SetInactiveTabBackgroundColor(0, 0, 0, 0.75)
	cbh.TargetConfig:SetActiveFontColor(0.75, 0.75, 0.75, 1)
	cbh.TargetConfig:SetInactiveFontColor(0.2, 0.2, 0.2, 0.3)
	cbh.TargetConfig:SetVisible(false)

	TargetBasicTab()
	TargetAppearanceTab()
	TargetPositioningTab()
	
	cbhTargetConfigSetup = true
end



function TargetBasicTab()
	cbh.TargetFrameToggle:SetPoint("TOPLEFT", cbh.WindowOptionsA, "TOPLEFT", 10, 10)
	cbh.TargetFrameToggle:SetLayer(2)
	cbh.TargetFrameToggle:SetText("Show Target Frame (beta)")
	cbh.TargetFrameToggle:SetFontSize(14)
	cbh.TargetFrameToggle:SetChecked(cbhTargetValues.enabled == true)
	function cbh.TargetFrameToggle.Event.CheckboxChange()
		cbh.TargetToggle(cbhTargetValues.enabled)
	end
end


function TargetAppearanceTab()
	cbhTargetTempColors = {}
	for i = 1, 5 do
		cbhTargetTempColors[i] = {}
		cbhTargetTempColors[i].r = cbhTargetValues["Colors"][i].r
		cbhTargetTempColors[i].g = cbhTargetValues["Colors"][i].g
		cbhTargetTempColors[i].b = cbhTargetValues["Colors"][i].b
		cbhTargetTempColors[i].a = cbhTargetValues["Colors"][i].a
	end
	

	-- COLORING LIST
	cbh.TargetColorPieces:SetPoint("TOPLEFT", cbh.TargetConfigA, "TOPLEFT", 10, 70)
	cbh.TargetColorPieces:SetWidth(140)
	cbh.TargetColorPieces:SetFontSize(15)
	cbh.TargetColorPieces:SetBorder(1, 1, 1, 1, 0)
	cbh.TargetColorPieces:SetItems(cbh.TargetPieces)
	cbh.TargetColorPieces:SetSelectedIndex(1)
	local cbhcolorindex = 1
	
	
	--[[ Target COLOR OPTIONS ]]
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.TargetColorOptions:SetPoint("TOPLEFT", cbh.TargetColorPieces, "TOPRIGHT", 10, 0)
	cbh.TargetColorOptions:SetBackgroundColor(.25, .25, .25, .5)
	cbh.TargetColorOptions:SetWidth(300)
	cbh.TargetColorOptions:SetHeight(200)
	cbh.TargetColorOptions:SetLayer(0)
	-- cbh.TargetColorOptions:SetVisible(false)
	
	cbh.TargetColorOptionsText:SetPoint("TOPLEFT", cbh.TargetColorOptions, "TOPLEFT", 5, 0)
	cbh.TargetColorOptionsText:SetFontSize(15)
	cbh.TargetColorOptionsText:SetText("Target Color Options")



	-- TEXTURE SELECTION OPTIONS
	cbh.TargetTextureText:SetPoint("TOPLEFT", cbh.TargetColorPieces, "BOTTOMLEFT", 0, 30)
	cbh.TargetTextureText:SetFontSize(14)
	cbh.TargetTextureText:SetFontColor(1,1,1,1)
	cbh.TargetTextureText:SetText("Target Texture")
	
	cbh.TargetTexture:SetPoint("TOPLEFT", cbh.TargetTextureText, "TOPLEFT", 0, 30)
	cbh.TargetTexture:SetItems(cbh.GlobalTextures)
	cbh.TargetTexture:SetSelectedItem(cbhTargetValues.texture, silent)
	cbh.TargetTexture:SetWidth(100)
	cbh.TargetTexture.Event.ItemSelect = function(view, item)
		cbhTargetValues.texture = item
		if cbhTargetValues.enabled then
			if cbhTargetValues.texturedup then 
				cbh.TargetFrame:SetTexture("ClickBoxHealer", "Textures/"..cbhPlayerValues.texture)
			else
				cbh.TargetFrame:SetTexture("ClickBoxHealer", "Textures/"..cbhTargetValues.texture)
				-- cbh.TargetManaFrame:SetTexture("ClickBoxHealer", "Textures/"..cbhTargetValues.texture)
			end
		end
	end
	
	
	-- DUPLICATE TEXTURE TO TARGETFRAME
	cbh.TargetTextureDup:SetPoint("TOPLEFT", cbh.TargetTextureText, "TOPLEFT", 0, 60)
	cbh.TargetTextureDup:SetLayer(2)
	cbh.TargetTextureDup:SetText("Copy Texture from Player")
	cbh.TargetTextureDup:SetFontSize(14)
	cbh.TargetTextureDup:SetChecked(cbhTargetValues.texturedup == true)
	function cbh.TargetTextureDup.Event.CheckboxChange()
		cbhTargetValues.texturedup = cbh.TargetTextureDup:GetChecked()
		if cbhTargetValues.texturedup then
			if cbhTargetValues.enabled then cbh.TargetFrame:SetTexture("ClickBoxHealer", "Textures/"..cbhPlayerValues.texture) end
		else
			if cbhTargetValues.enabled then cbh.TargetFrame:SetTexture("ClickBoxHealer", "Textures/"..cbhTargetValues.texture) end
		end
	end
	

	-- SET CLASS COLOR TO OBJECTS
	cbh.TargetClassColor:SetPoint("TOPLEFT", cbh.TargetColorOptionsText, "TOPLEFT", 0, 30)
	cbh.TargetClassColor:SetLayer(2)
	cbh.TargetClassColor:SetText("Class Color Item")
	cbh.TargetClassColor:SetFontSize(14)
	cbh.TargetClassColor:SetChecked(cbhTargetValues["Colors"][1].classcolor == true)
	cbh.TargetClassColor:SetVisible(false)
	function cbh.TargetClassColor.Event.CheckboxChange()
		cbhTargetValues["Colors"][cbhcolorindex].classcolor = cbh.TargetClassColor:GetChecked()
		if cbhcolorindex == 3 then
			if cbhTargetValues["Colors"][3].classcolor then
				-- cbh.TargetManaFrame:SetBackgroundColor(cbh.ClassColors[cbh.targetinfo.calling].r, cbh.ClassColors[cbh.targetinfo.calling].g, cbh.ClassColors[cbh.targetinfo.calling].b, cbhTargetValues["Colors"][3].a)
			-- else
				-- cbh.TargetManaFrame:SetBackgroundColor(cbhTargetValues["Colors"][3].r, cbhTargetValues["Colors"][3].g, cbhTargetValues["Colors"][3].b, cbhTargetValues["Colors"][3].a)
			end
		elseif cbhcolorindex == 4 then
			if cbhTargetValues["Colors"][4].classcolor then
				cbh.TargetName:SetFontColor(cbh.ClassColors[cbh.targetinfo.calling].r, cbh.ClassColors[cbh.targetinfo.calling].g, cbh.ClassColors[cbh.targetinfo.calling].b, cbhTargetValues["Colors"][4].a)
			else
				cbh.TargetName:SetFontColor(cbhTargetTempColors[4].r, cbhTargetTempColors[4].g, cbhTargetTempColors[4].b, cbhTargetTempColors[4].a)
			end
		end
	end

	-- SET % GRADIENT TO COLOR
	cbh.TargetGradients:SetPoint("TOPLEFT", cbh.TargetClassColor, "TOPRIGHT", 20, 0)
	cbh.TargetGradients:SetLayer(2)
	cbh.TargetGradients:SetText("Gradient Color Item")
	cbh.TargetGradients:SetFontSize(14)
	cbh.TargetGradients:SetChecked(cbhTargetValues["Colors"][1].gradient == true)
	function cbh.TargetGradients.Event.CheckboxChange()
		if cbhcolorindex == 1 then
			cbhTargetValues["Colors"][1].gradient = cbh.TargetGradients:GetChecked()
			if cbhTargetValues["Colors"][1].gradient == false then
				cbh.TargetFrame:SetBackgroundColor(cbhTargetTempColors[1].r, cbhTargetTempColors[1].g, cbhTargetTempColors[1].b, cbhTargetTempColors[1].a)
			end
		end
	end
	
	
	-- Color sliders for various pieces of the unit frame
	cbh.TargetColorSliderText:SetPoint("TOPLEFT", cbh.TargetColorOptionsText, "TOPLEFT", 0, 60)
	cbh.TargetColorSliderText:SetText("Target Frame Color Options.  r, g, b")
	cbh.TargetColorSliderText:SetFontSize(14)
	cbh.TargetColorSliderText:SetLayer(2)

	cbh.TargetColorSliderR:SetPoint("TOPLEFT", cbh.TargetColorSliderText, "BOTTOMLEFT", 0, 0)
	cbh.TargetColorSliderR:SetRange(0, 100)
	cbh.TargetColorSliderR:SetPosition(math.floor((cbhTargetTempColors[cbhcolorindex].r * 100) + 0.5))

	cbh.TargetColorSliderG:SetPoint("TOPLEFT", cbh.TargetColorSliderR, "BOTTOMLEFT", 0, 5)
	cbh.TargetColorSliderG:SetRange(0, 100)
	cbh.TargetColorSliderG:SetPosition(math.floor((cbhTargetTempColors[cbhcolorindex].g * 100) + 0.5))

	cbh.TargetColorSliderB:SetPoint("TOPLEFT", cbh.TargetColorSliderG, "BOTTOMLEFT", 0, 5)
	cbh.TargetColorSliderB:SetRange(0, 100)
	cbh.TargetColorSliderB:SetPosition(math.floor((cbhTargetTempColors[cbhcolorindex].b * 100) + 0.5))

	cbh.TargetColorSliderA:SetPoint("TOPLEFT", cbh.TargetColorSliderB, "BOTTOMLEFT", 0, 5)
	cbh.TargetColorSliderA:SetRange(0, 100)
	cbh.TargetColorSliderA:SetPosition(math.floor((cbhTargetTempColors[cbhcolorindex].a * 100) + 0.5))

	local function SetSliderPositions()
		-- if not cbhTargetValues["Colors"][cbhcolorindex].classcolor then
			cbh.TargetColorSliderR:SetPosition(math.floor((cbhTargetTempColors[cbhcolorindex].r * 100) + 0.5))
			cbh.TargetColorSliderG:SetPosition(math.floor((cbhTargetTempColors[cbhcolorindex].g * 100) + 0.5))
			cbh.TargetColorSliderB:SetPosition(math.floor((cbhTargetTempColors[cbhcolorindex].b * 100) + 0.5))
		-- end
		cbh.TargetColorSliderA:SetPosition(math.floor((cbhTargetTempColors[cbhcolorindex].a * 100) + 0.5))
	end
	
	
	cbh.TargetColorPieces.Event.ItemSelect = function(view, item, value, index)
	-- "Healthbar", "Health backdrop", "Manabar", "Name", "Percentage"
		if index == nil then index = 1 end
		if index == 1 then
			cbhcolorindex = index
			cbh.TargetClassColor:SetChecked(cbhTargetValues["Colors"][cbhcolorindex].classcolor == true)
			cbh.TargetColorSliderA:SetVisible(true)
			SetSliderPositions()
		elseif index == 2 then
			cbhcolorindex = index
			cbh.TargetClassColor:SetChecked(cbhTargetValues["Colors"][cbhcolorindex].classcolor == true)
			cbh.TargetColorSliderA:SetVisible(true)
			SetSliderPositions()
		elseif index == 3 then
			cbhcolorindex = index
			cbh.TargetClassColor:SetChecked(cbhTargetValues["Colors"][cbhcolorindex].classcolor == true)
			cbh.TargetColorSliderA:SetVisible(true)
			SetSliderPositions()
		elseif index == 4 then
			cbhcolorindex = index
			cbh.TargetClassColor:SetChecked(cbhTargetValues["Colors"][cbhcolorindex].classcolor == true)
			SetSliderPositions()
			cbh.TargetColorSliderA:SetVisible(false)
		elseif index == 5 then
			cbhcolorindex = index
			cbh.TargetClassColor:SetChecked(cbhTargetValues["Colors"][cbhcolorindex].classcolor == true)
			SetSliderPositions()
			cbh.TargetColorSliderA:SetVisible(false)
		end
		if index > 1 then cbh.TargetGradients:SetVisible(false) else cbh.TargetGradients:SetVisible(true) end
		if index ~= 3 and index ~= 4 then cbh.TargetClassColor:SetVisible(false) else cbh.TargetClassColor:SetVisible(true) end
	end

	local red, green, blue, alpha

	local function TargetUpdateColorChanges()
		-- "Healthbar", "Health backdrop", "Manabar", "Name", "Percentage"
		if cbhcolorindex == nil then cbhcolorindex = 1 end
		if not cbhTargetValues["Colors"][cbhcolorindex].classcolor then
			red = cbhTargetTempColors[cbhcolorindex].r
			green = cbhTargetTempColors[cbhcolorindex].g
			blue = cbhTargetTempColors[cbhcolorindex].b
		else
			red = cbh.ClassColors[cbh.targetinfo.calling].r
			green = cbh.ClassColors[cbh.targetinfo.calling].g
			blue = cbh.ClassColors[cbh.targetinfo.calling].b
		end
		alpha = cbhTargetTempColors[cbhcolorindex].a
		-- if cbhcolorindex == 1 then
			-- cbh.TargetFrame:SetBackgroundColor(cbhTargetTempColors[cbhcolorindex].r, cbhTargetTempColors[cbhcolorindex].g, cbhTargetTempColors[cbhcolorindex].b, cbhTargetTempColors[cbhcolorindex].a)
		-- elseif cbhcolorindex == 2 then
			-- cbh.TargetHP:SetBackgroundColor(cbhTargetTempColors[cbhcolorindex].r, cbhTargetTempColors[cbhcolorindex].g, cbhTargetTempColors[cbhcolorindex].b, cbhTargetTempColors[cbhcolorindex].a)
		-- elseif cbhcolorindex == 3 then
			-- cbh.TargetManaFrame:SetBackgroundColor(cbhTargetTempColors[cbhcolorindex].r, cbhTargetTempColors[cbhcolorindex].g, cbhTargetTempColors[cbhcolorindex].b, cbhTargetTempColors[cbhcolorindex].a)
		-- elseif cbhcolorindex == 4 then
			-- cbh.TargetName:SetFontColor(cbhTargetTempColors[cbhcolorindex].r, cbhTargetTempColors[cbhcolorindex].g, cbhTargetTempColors[cbhcolorindex].b, cbhTargetTempColors[cbhcolorindex].a)
		-- elseif cbhcolorindex == 5 then
			-- cbh.TargetPercent:SetFontColor(cbhTargetTempColors[cbhcolorindex].r, cbhTargetTempColors[cbhcolorindex].g, cbhTargetTempColors[cbhcolorindex].b, cbhTargetTempColors[cbhcolorindex].a)
		-- end
		if cbhcolorindex == 1 then
			cbh.TargetFrame:SetBackgroundColor(red, green, blue, alpha)
		elseif cbhcolorindex == 2 then
			cbh.TargetHP:SetBackgroundColor(red, green, blue, alpha)
		elseif cbhcolorindex == 3 then
			-- cbh.TargetManaFrame:SetBackgroundColor(red, green, blue, alpha)
		elseif cbhcolorindex == 4 then
			cbh.TargetName:SetFontColor(red, green, blue, alpha)
		elseif cbhcolorindex == 5 then
			cbh.TargetPercent:SetFontColor(red, green, blue, alpha)
		end
	end

	function cbh.TargetColorSliderR.Event.SliderChange()
		cbhTargetTempColors[cbhcolorindex].r = (cbh.TargetColorSliderR:GetPosition() / 100)
		TargetUpdateColorChanges()
	end
	function cbh.TargetColorSliderG.Event.SliderChange()
		cbhTargetTempColors[cbhcolorindex].g = (cbh.TargetColorSliderG:GetPosition() / 100)
		TargetUpdateColorChanges()
	end
	function cbh.TargetColorSliderB.Event.SliderChange()
		cbhTargetTempColors[cbhcolorindex].b = (cbh.TargetColorSliderB:GetPosition() / 100)
		TargetUpdateColorChanges()
	end
	function cbh.TargetColorSliderA.Event.SliderChange()
		cbhTargetTempColors[cbhcolorindex].a = (cbh.TargetColorSliderA:GetPosition() / 100)
		TargetUpdateColorChanges()
	end
	
	local function ClearTargetOptions()
		cbh.TargetHealthbarOptions:SetVisible(false)
		cbh.TargetManabarOptions:SetVisible(false)
		cbh.TargetNameOptions:SetVisible(false)
		cbh.TargetLevelOptions:SetVisible(false)
		cbh.TargetPercentOptions:SetVisible(false)
		cbh.TargetRoleOptions:SetVisible(false)
		cbh.TargetRaidMarkOptions:SetVisible(false)
		cbh.TargetPvPMarkOptions:SetVisible(false)
		cbh.TargetTierOptions:SetVisible(false)
		cbh.TargetPublicIconOptions:SetVisible(false)
		cbh.TargetBuffsOptions:SetVisible(false)
		cbh.TargetDebuffsOptions:SetVisible(false)
	end
	
	-- POSITIONING ITEM LIST
	cbh.TargetPositionPieces:SetPoint("TOPLEFT", cbh.TargetConfigA, "TOPLEFT", 10, 340)
	cbh.TargetPositionPieces:SetWidth(140)
	cbh.TargetPositionPieces:SetFontSize(15)
	cbh.TargetPositionPieces:SetBorder(1, 1, 1, 1, 0)
	cbh.TargetPositionPieces:SetItems(cbh.TargetPositionList)
	cbh.TargetPositionPieces:SetSelectedIndex(1)
	local cbhposindex = 1

	cbh.TargetPositionPieces.Event.ItemSelect = function(view, item, value, index)
	-- {"Healthbar", "Manabar", "Name", "Percentage","Role Icon", "Raid Mark", "PvP Mark", "Buffs"}
		if index == nil then index = 1 end
		if index == 1 then
			cbhposindex = index
			ClearTargetOptions()
			cbh.TargetHealthbarOptions:SetVisible(true)
		elseif index == 2 then
			cbhposindex = index
			ClearTargetOptions()
			cbh.TargetManabarOptions:SetVisible(true)
		elseif index == 3 then
			cbhposindex = index
			ClearTargetOptions()
			cbh.TargetNameOptions:SetVisible(true)
		elseif index == 4 then
			cbhposindex = index
			ClearTargetOptions()
			cbh.TargetLevelOptions:SetVisible(true)
		elseif index == 5 then
			cbhposindex = index
			ClearTargetOptions()
			cbh.TargetPercentOptions:SetVisible(true)
		elseif index == 6 then
			cbhposindex = index
			ClearTargetOptions()
			cbh.TargetRoleOptions:SetVisible(true)
		elseif index == 7 then
			cbhposindex = index
			ClearTargetOptions()
			cbh.TargetRaidMarkOptions:SetVisible(true)
		elseif index == 8 then
			cbhposindex = index
			ClearTargetOptions()
			cbh.TargetPvPMarkOptions:SetVisible(true)
		elseif index == 9 then
			cbhposindex = index
			ClearTargetOptions()
			cbh.TargetTierOptions:SetVisible(true)
		elseif index == 10 then
			cbhposindex = index
			ClearTargetOptions()
			cbh.TargetPublicIconOptions:SetVisible(true)
		elseif index == 11 then
			cbhposindex = index
			ClearTargetOptions()
			cbh.TargetBuffsOptions:SetVisible(true)
		elseif index == 12 then
			cbhposindex = index
			ClearTargetOptions()
			cbh.TargetDebuffsOptions:SetVisible(true)
		end
	end	

end


function TargetPositioningTab()
	--[[ HEALTH BAR OPTIONS ]]
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.TargetHealthbarOptions:SetPoint("TOPLEFT", cbh.TargetPositionPieces, "TOPRIGHT", 10, 0)
	cbh.TargetHealthbarOptions:SetBackgroundColor(.25, .25, .25, .5)
	cbh.TargetHealthbarOptions:SetWidth(300)
	cbh.TargetHealthbarOptions:SetHeight(cbh.TargetPositionPieces:GetHeight())
	
	cbh.TargetHealthbarLocationText:SetPoint("TOPLEFT", cbh.TargetHealthbarOptions, "TOPLEFT", 5, 0)
	cbh.TargetHealthbarLocationText:SetFontSize(15)
	cbh.TargetHealthbarLocationText:SetText("Target Healthbar Size")
	-- slider for width
	cbh.TargetHealthbarSizerW:SetPoint("TOPLEFT", cbh.TargetHealthbarLocationText, "TOPLEFT", 0, 30)
	cbh.TargetHealthbarSizerW:SetRange(50, 300)
	cbh.TargetHealthbarSizerW:SetPosition(cbhTargetValues.fwidth)
	-- slider for height
	cbh.TargetHealthbarSizerH:SetPoint("TOPLEFT", cbh.TargetHealthbarLocationText, "TOPLEFT", 0, 60)
	cbh.TargetHealthbarSizerH:SetRange(10, 300)
	cbh.TargetHealthbarSizerH:SetPosition(cbhTargetValues.fheight)
	function cbh.TargetHealthbarSizerW.Event.SliderChange()
		cbhTargetValues.fwidth = (cbh.TargetHealthbarSizerW:GetPosition())
		cbh.TargetFrame:SetWidth(cbhTargetValues.fwidth)
		-- cbh.TargetHP:SetWidth(0)
		-- cbh.TargetManaFrame:SetWidth(cbhTargetValues.fwidth)
		-- cbh.TargetMana:SetWidth(0)
	end
	function cbh.TargetHealthbarSizerH.Event.SliderChange()
		cbhTargetValues.fheight = (cbh.TargetHealthbarSizerH:GetPosition())
		cbh.TargetFrame:SetHeight(cbhTargetValues.fheight)
		cbh.TargetHP:SetHeight(cbhTargetValues.fheight)
	end
	

	--[[ MANA BAR OPTIONS ]]
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.TargetManabarOptions:SetPoint("TOPLEFT", cbh.TargetPositionPieces, "TOPRIGHT", 10, 0)
	cbh.TargetManabarOptions:SetBackgroundColor(.25, .25, .25, .5)
	cbh.TargetManabarOptions:SetWidth(300)
	cbh.TargetManabarOptions:SetHeight(cbh.TargetPositionPieces:GetHeight())
	cbh.TargetManabarOptions:SetVisible(false)
	
	cbh.TargetManabarLocationText:SetPoint("TOPLEFT", cbh.TargetManabarOptions, "TOPLEFT", 5, 0)
	cbh.TargetManabarLocationText:SetFontSize(15)
	cbh.TargetManabarLocationText:SetText("Target Resource bar Size (INCOMPLETE!!)")
	-- slider for height
	cbh.TargetManabarSizerH:SetPoint("TOPLEFT", cbh.TargetManabarLocationText, "TOPLEFT", 0, 30)
	cbh.TargetManabarSizerH:SetVisible(false)
	-- cbh.TargetManabarSizerH:SetRange(0, 100)
	-- cbh.TargetManabarSizerH:SetPosition(cbhTargetValues.rbheight)
	-- function cbh.TargetManabarSizerH.Event.SliderChange()
		-- cbhTargetValues.rbheight = (cbh.TargetManabarSizerH:GetPosition())
		-- cbh.TargetManaFrame:SetHeight(cbhTargetValues.mfheight)
		-- cbh.TargetMana:SetHeight(cbhTargetValues.mfheight)
	-- end
	

	--[[ UNIT NAME SETTINGS ]]
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.TargetNameOptions:SetPoint("TOPLEFT", cbh.TargetPositionPieces, "TOPRIGHT", 10, 0)
	cbh.TargetNameOptions:SetBackgroundColor(.25, .25, .25, .5)
	cbh.TargetNameOptions:SetWidth(300)
	cbh.TargetNameOptions:SetHeight(cbh.TargetPositionPieces:GetHeight())
	cbh.TargetNameOptions:SetVisible(false)
	
	cbh.TargetNameLocationText:SetPoint("TOPLEFT", cbh.TargetNameOptions, "TOPLEFT", 5, 0)
	cbh.TargetNameLocationText:SetFontSize(15)
	cbh.TargetNameLocationText:SetText("Target Name Location/Size")
	cbh.TargetNameFontSizer:SetPoint("TOPLEFT", cbh.TargetNameLocationText, "TOPLEFT", 0, 30)
	cbh.TargetNameFontSizer:SetRange(0, 72)
	cbh.TargetNameFontSizer:SetWidth(125)
	cbh.TargetNameFontSizer:SetPosition(cbhTargetValues.namefontsize)
	function cbh.TargetNameFontSizer.Event.SliderChange()
		cbhTargetValues.namefontsize = (cbh.TargetNameFontSizer:GetPosition())
		cbh.TargetName:SetFontSize(cbhTargetValues.namefontsize)
	end

	cbh.TargetNameLocation:SetPoint("TOPLEFT", cbh.TargetNameFontSizer, "TOPRIGHT", 10, 0)
	cbh.TargetNameLocation:SetLayer(5)
	cbh.TargetNameLocation:SetFontSize(14)
	cbh.TargetNameLocation:SetItems(cbh.SetPoint)
	cbh.TargetNameLocation:SetSelectedItem(cbhTargetValues.namelocation, silent)
	cbh.TargetNameLocation:SetWidth(125)
	cbh.TargetNameLocation.Event.ItemSelect = function(view, item)
		cbhTargetValues.namelocation = item
		cbh.TargetName:ClearAll()
		cbh.TargetName:SetPoint(cbhTargetValues.namelocation, cbh.TargetFrame, cbhTargetValues.namelocation, cbhTargetValues.nameoffsetx, cbhTargetValues.nameoffsety)
	end

	-- Target NAME LENGTH
	cbh.TargetNameLengthOption:SetPoint("TOPLEFT", cbh.TargetNameFontSizer, "TOPLEFT", 0, 30)
	cbh.TargetNameLengthOption:SetFontSize(14)
	cbh.TargetNameLengthOption:SetLayer(1)
	cbh.TargetNameLengthOption:SetText("Target Name Length Auto")
	cbh.TargetNameLengthOption:SetChecked(cbhTargetValues.namelengthauto == true)
	function cbh.TargetNameLengthOption.Event.CheckboxChange()
		if cbh.TargetNameLengthOption:GetChecked() == true then
			cbhTargetValues.namelengthauto = true
			cbh.TargetNameLength:SetVisible(false)
		else
			cbhTargetValues.namelengthauto = false
			cbh.TargetNameLength:SetVisible(true)
		end
		cbh.nameCalc(cbh.targetinfo.name, nil, "target")
	end

	-- SLIDER TO CHANGE NAME LENGTH  **HIDES IF AUTO IS TRUE**
	cbh.TargetNameLength:SetPoint("TOPLEFT", cbh.TargetNameLengthOption, "TOPLEFT", 0, 20)
	cbh.TargetNameLength:SetRange(0, 16)
	cbh.TargetNameLength:SetPosition(cbhTargetValues.namelength)
	function cbh.TargetNameLength.Event.SliderChange()
		cbhTargetValues.namelength = cbh.TargetNameLength:GetPosition()
		cbh.nameCalc(cbh.targetinfo.name, nil, "target")
	end

	-- Target NAME OFFSET
	cbh.TargetNameOffsetText:SetPoint("TOPLEFT", cbh.TargetNameLength, "TOPLEFT", 0, 40)
	cbh.TargetNameOffsetText:SetFontSize(15)
	cbh.TargetNameOffsetText:SetText("Offset Name: x, y")
	cbh.TargetNameOffsetX:SetPoint("TOPLEFT", cbh.TargetNameOffsetText, "TOPLEFT", 0, 30)
	cbh.TargetNameOffsetX:SetRange(-100, 100)
	cbh.TargetNameOffsetX:SetWidth(125)
	cbh.TargetNameOffsetX:SetPosition(cbhTargetValues.nameoffsetx)
	function cbh.TargetNameOffsetX.Event.SliderChange()
		cbhTargetValues.nameoffsetx = (cbh.TargetNameOffsetX:GetPosition())
		cbh.TargetName:ClearAll()
		cbh.TargetName:SetPoint(cbhTargetValues.namelocation, cbh.TargetFrame, cbhTargetValues.namelocation, cbhTargetValues.nameoffsetx, cbhTargetValues.nameoffsety)
	end
	cbh.TargetNameOffsetY:SetPoint("TOPLEFT", cbh.TargetNameOffsetX, "TOPRIGHT", 20, 0)
	cbh.TargetNameOffsetY:SetRange(-100, 100)
	cbh.TargetNameOffsetY:SetWidth(125)
	cbh.TargetNameOffsetY:SetPosition(cbhTargetValues.nameoffsety)
	function cbh.TargetNameOffsetY.Event.SliderChange()
		cbhTargetValues.nameoffsety = (cbh.TargetNameOffsetY:GetPosition())
		cbh.TargetName:ClearAll()
		cbh.TargetName:SetPoint(cbhTargetValues.namelocation, cbh.TargetFrame, cbhTargetValues.namelocation, cbhTargetValues.nameoffsetx, cbhTargetValues.nameoffsety)
	end

	
	
	--[[ LEVEL OPTIONS ]]
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.TargetLevelOptions:SetPoint("TOPLEFT", cbh.TargetPositionPieces, "TOPRIGHT", 10, 0)
	cbh.TargetLevelOptions:SetBackgroundColor(.25, .25, .25, .5)
	cbh.TargetLevelOptions:SetWidth(300)
	cbh.TargetLevelOptions:SetHeight(cbh.TargetPositionPieces:GetHeight())
	cbh.TargetLevelOptions:SetVisible(false)
	
	cbh.TargetLevelLocationText:SetPoint("TOPLEFT", cbh.TargetLevelOptions, "TOPLEFT", 5, 0)
	cbh.TargetLevelLocationText:SetFontSize(15)
	cbh.TargetLevelLocationText:SetText("Target Level Location/Size")
	cbh.TargetLevelSizer:SetPoint("TOPLEFT", cbh.TargetLevelLocationText, "TOPLEFT", 0, 60)
	cbh.TargetLevelSizer:SetRange(0, 72)
	cbh.TargetLevelSizer:SetWidth(125)
	cbh.TargetLevelSizer:SetPosition(cbhTargetValues.levelsize)
	function cbh.TargetLevelSizer.Event.SliderChange()
		cbhTargetValues.levelsize = (cbh.TargetLevelSizer:GetPosition())
		cbh.TargetLevel:SetFontSize(cbhTargetValues.levelsize)
	end

	cbh.TargetLevelLocation:SetPoint("TOPLEFT", cbh.TargetLevelSizer, "TOPRIGHT", 10, 0)
	cbh.TargetLevelLocation:SetLayer(5)
	cbh.TargetLevelLocation:SetFontSize(14)
	cbh.TargetLevelLocation:SetItems(cbh.SetPoint)
	cbh.TargetLevelLocation:SetSelectedItem(cbhTargetValues.levellocation, silent)
	cbh.TargetLevelLocation:SetWidth(125)
	cbh.TargetLevelLocation.Event.ItemSelect = function(view, item)
		cbhTargetValues.levellocation = item
		cbh.TargetLevel:ClearAll()
		cbh.TargetLevel:SetPoint(cbhTargetValues.levellocation, cbh.TargetFrame, cbhTargetValues.levellocation, cbhTargetValues.leveloffsetx, cbhTargetValues.leveloffsety)
	end
	
	-- Target Level OFFSET
	cbh.TargetLevelOffsetText:SetPoint("TOPLEFT", cbh.TargetLevelSizer, "TOPLEFT", 0, 40)
	cbh.TargetLevelOffsetText:SetFontSize(15)
	cbh.TargetLevelOffsetText:SetText("Offset Level: x, y")
	cbh.TargetLevelOffsetX:SetPoint("TOPLEFT", cbh.TargetLevelOffsetText, "TOPLEFT", 0, 30)
	cbh.TargetLevelOffsetX:SetRange(-100, 100)
	cbh.TargetLevelOffsetX:SetPosition(cbhTargetValues.leveloffsetx)
	function cbh.TargetLevelOffsetX.Event.SliderChange()
		cbhTargetValues.leveloffsetx = (cbh.TargetLevelOffsetX:GetPosition())
		cbh.TargetLevel:ClearAll()
		cbh.TargetLevel:SetPoint(cbhTargetValues.levellocation, cbh.TargetFrame, cbhTargetValues.levellocation, cbhTargetValues.leveloffsetx, cbhTargetValues.leveloffsety)
	end
	cbh.TargetLevelOffsetY:SetPoint("TOPLEFT", cbh.TargetLevelOffsetX, "TOPLEFT", 0, 30)
	cbh.TargetLevelOffsetY:SetRange(-100, 100)
	cbh.TargetLevelOffsetY:SetPosition(cbhTargetValues.leveloffsety)
	function cbh.TargetLevelOffsetY.Event.SliderChange()
		cbhTargetValues.leveloffsety = (cbh.TargetLevelOffsetY:GetPosition())
		cbh.TargetLevel:ClearAll()
		cbh.TargetLevel:SetPoint(cbhTargetValues.levellocation, cbh.TargetFrame, cbhTargetValues.levellocation, cbhTargetValues.leveloffsetx, cbhTargetValues.leveloffsety)
	end

	
	--[[ HEALTH PERCENT OPTIONS ]]
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.TargetPercentOptions:SetPoint("TOPLEFT", cbh.TargetPositionPieces, "TOPRIGHT", 10, 0)
	cbh.TargetPercentOptions:SetBackgroundColor(.25, .25, .25, .5)
	cbh.TargetPercentOptions:SetWidth(300)
	cbh.TargetPercentOptions:SetHeight(cbh.TargetPositionPieces:GetHeight())
	cbh.TargetPercentOptions:SetVisible(false)
	
	cbh.TargetPercentLocationText:SetPoint("TOPLEFT", cbh.TargetPercentOptions, "TOPLEFT", 5, 0)
	cbh.TargetPercentLocationText:SetFontSize(15)
	cbh.TargetPercentLocationText:SetText("Target Percent Location/Size")
	
	cbh.TargetPercentToggle:SetPoint("TOPLEFT", cbh.TargetPercentLocationText, "TOPLEFT", 0, 30)
	cbh.TargetPercentToggle:SetFontSize(14)
	cbh.TargetPercentToggle:SetLayer(1)
	cbh.TargetPercentToggle:SetText("Toggle Text Health On/Off")
	cbh.TargetPercentToggle:SetChecked(cbhTargetValues.percentshow == true)
	function cbh.TargetPercentToggle.Event.CheckboxChange()
		cbhTargetValues.percentshow = cbh.TargetPercentToggle:GetChecked()
		if cbhTargetValues.percentshow then
			cbh.TargetPercent:SetVisible(true)
		else
			cbh.TargetPercent:SetVisible(false)
		end
	end

	cbh.TargetPercentSizer:SetPoint("TOPLEFT", cbh.TargetPercentLocationText, "TOPLEFT", 0, 60)
	cbh.TargetPercentSizer:SetRange(0, 72)
	cbh.TargetPercentSizer:SetWidth(125)
	cbh.TargetPercentSizer:SetPosition(cbhTargetValues.percentfontsize)
	function cbh.TargetPercentSizer.Event.SliderChange()
		cbhTargetValues.percentfontsize = (cbh.TargetPercentSizer:GetPosition())
		cbh.TargetPercent:SetFontSize(cbhTargetValues.percentfontsize)
	end

	cbh.TargetPercentLocation:SetPoint("TOPLEFT", cbh.TargetPercentSizer, "TOPRIGHT", 10, 0)
	cbh.TargetPercentLocation:SetLayer(5)
	cbh.TargetPercentLocation:SetFontSize(14)
	cbh.TargetPercentLocation:SetItems(cbh.SetPoint)
	cbh.TargetPercentLocation:SetSelectedItem(cbhTargetValues.percentlocation, silent)
	cbh.TargetPercentLocation:SetWidth(125)
	cbh.TargetPercentLocation.Event.ItemSelect = function(view, item)
		cbhTargetValues.percentlocation = item
		cbh.TargetPercent:ClearAll()
		cbh.TargetPercent:SetPoint(cbhTargetValues.percentlocation, cbh.TargetFrame, cbhTargetValues.percentlocation, cbhTargetValues.percentoffsetx, cbhTargetValues.percentoffsety)
	end
	
	-- Target Percent OFFSET
	cbh.TargetPercentOffsetText:SetPoint("TOPLEFT", cbh.TargetPercentSizer, "TOPLEFT", 0, 40)
	cbh.TargetPercentOffsetText:SetFontSize(15)
	cbh.TargetPercentOffsetText:SetText("Offset Percent: x, y")
	cbh.TargetPercentOffsetX:SetPoint("TOPLEFT", cbh.TargetPercentOffsetText, "TOPLEFT", 0, 30)
	cbh.TargetPercentOffsetX:SetRange(-100, 100)
	cbh.TargetPercentOffsetX:SetPosition(cbhTargetValues.percentoffsetx)
	function cbh.TargetPercentOffsetX.Event.SliderChange()
		cbhTargetValues.percentoffsetx = (cbh.TargetPercentOffsetX:GetPosition())
		cbh.TargetPercent:ClearAll()
		cbh.TargetPercent:SetPoint(cbhTargetValues.percentlocation, cbh.TargetFrame, cbhTargetValues.percentlocation, cbhTargetValues.percentoffsetx, cbhTargetValues.percentoffsety)
	end
	cbh.TargetPercentOffsetY:SetPoint("TOPLEFT", cbh.TargetPercentOffsetX, "TOPLEFT", 0, 30)
	cbh.TargetPercentOffsetY:SetRange(-100, 100)
	cbh.TargetPercentOffsetY:SetPosition(cbhTargetValues.percentoffsety)
	function cbh.TargetPercentOffsetY.Event.SliderChange()
		cbhTargetValues.percentoffsety = (cbh.TargetPercentOffsetY:GetPosition())
		cbh.TargetPercent:ClearAll()
		cbh.TargetPercent:SetPoint(cbhTargetValues.percentlocation, cbh.TargetFrame, cbhTargetValues.percentlocation, cbhTargetValues.percentoffsetx, cbhTargetValues.percentoffsety)
	end

	
	
	--[[ DUNGEON ROLE OPTIONS ]]
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.TargetRoleOptions:SetPoint("TOPLEFT", cbh.TargetPositionPieces, "TOPRIGHT", 10, 0)
	cbh.TargetRoleOptions:SetBackgroundColor(.25, .25, .25, .5)
	cbh.TargetRoleOptions:SetWidth(300)
	cbh.TargetRoleOptions:SetHeight(cbh.TargetPositionPieces:GetHeight())
	cbh.TargetRoleOptions:SetVisible(false)
	
	cbh.TargetRoleLocationText:SetPoint("TOPLEFT", cbh.TargetRoleOptions, "TOPLEFT", 5, 0)
	cbh.TargetRoleLocationText:SetFontSize(15)
	cbh.TargetRoleLocationText:SetText("Target Role Location/Size")

	cbh.TargetRoleToggle:SetPoint("TOPLEFT", cbh.TargetRoleLocationText, "TOPLEFT", 0, 30)
	cbh.TargetRoleToggle:SetFontSize(14)
	cbh.TargetRoleToggle:SetLayer(1)
	cbh.TargetRoleToggle:SetText("Toggle Role On/Off")
	cbh.TargetRoleToggle:SetChecked(cbhTargetValues.roleshow == true)
	function cbh.TargetRoleToggle.Event.CheckboxChange()
		cbhTargetValues.roleshow = cbh.TargetRoleToggle:GetChecked()
		cbh.TargetRole:SetVisible(cbhTargetValues.roleshow)
	end

	cbh.TargetRoleSizer:SetPoint("TOPLEFT", cbh.TargetRoleLocationText, "TOPLEFT", 0, 60)
	cbh.TargetRoleSizer:SetRange(0, 72)
	cbh.TargetRoleSizer:SetWidth(125)
	cbh.TargetRoleSizer:SetPosition(cbhTargetValues.rolesize)
	function cbh.TargetRoleSizer.Event.SliderChange()
		cbhTargetValues.rolesize = (cbh.TargetRoleSizer:GetPosition())
		cbh.TargetRole:SetWidth(cbhTargetValues.rolesize)
		cbh.TargetRole:SetHeight(cbhTargetValues.rolesize)
	end

	cbh.TargetRoleLocation:SetPoint("TOPLEFT", cbh.TargetRoleSizer, "TOPRIGHT", 10, 0)
	cbh.TargetRoleLocation:SetLayer(5)
	cbh.TargetRoleLocation:SetFontSize(14)
	cbh.TargetRoleLocation:SetItems(cbh.SetPoint)
	cbh.TargetRoleLocation:SetSelectedItem(cbhTargetValues.rolelocation, silent)
	cbh.TargetRoleLocation:SetWidth(125)
	cbh.TargetRoleLocation.Event.ItemSelect = function(view, item)
		cbhTargetValues.rolelocation = item
		cbh.TargetRole:ClearAll()
		cbh.TargetRole:SetPoint(cbhTargetValues.rolelocation, cbh.TargetFrame, cbhTargetValues.rolelocation, cbhTargetValues.roleoffsetx, cbhTargetValues.roleoffsety)
		cbh.TargetRole:SetWidth(cbhTargetValues.rolesize)
		cbh.TargetRole:SetHeight(cbhTargetValues.rolesize)
	end
	
	-- Target Role OFFSET
	cbh.TargetRoleOffsetText:SetPoint("TOPLEFT", cbh.TargetRoleSizer, "TOPLEFT", 0, 40)
	cbh.TargetRoleOffsetText:SetFontSize(15)
	cbh.TargetRoleOffsetText:SetText("Offset Role: x, y")
	cbh.TargetRoleOffsetX:SetPoint("TOPLEFT", cbh.TargetRoleOffsetText, "TOPLEFT", 0, 30)
	cbh.TargetRoleOffsetX:SetRange(-100, 100)
	cbh.TargetRoleOffsetX:SetPosition(cbhTargetValues.roleoffsetx)
	function cbh.TargetRoleOffsetX.Event.SliderChange()
		cbhTargetValues.roleoffsetx = (cbh.TargetRoleOffsetX:GetPosition())
		cbh.TargetRole:ClearPoint(x, y)
		cbh.TargetRole:SetPoint(cbhTargetValues.rolelocation, cbh.TargetFrame, cbhTargetValues.rolelocation, cbhTargetValues.roleoffsetx, cbhTargetValues.roleoffsety)
	end
	cbh.TargetRoleOffsetY:SetPoint("TOPLEFT", cbh.TargetRoleOffsetX, "TOPLEFT", 0, 30)
	cbh.TargetRoleOffsetY:SetRange(-100, 100)
	cbh.TargetRoleOffsetY:SetPosition(cbhTargetValues.roleoffsety)
	function cbh.TargetRoleOffsetY.Event.SliderChange()
		cbhTargetValues.roleoffsety = (cbh.TargetRoleOffsetY:GetPosition())
		cbh.TargetRole:ClearPoint(x, y)
		cbh.TargetRole:SetPoint(cbhTargetValues.rolelocation, cbh.TargetFrame, cbhTargetValues.rolelocation, cbhTargetValues.roleoffsetx, cbhTargetValues.roleoffsety)
	end

	
	
	--[[ RAID MARK OPTIONS ]]--
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.TargetRaidMarkOptions:SetPoint("TOPLEFT", cbh.TargetPositionPieces, "TOPRIGHT", 10, 0)
	cbh.TargetRaidMarkOptions:SetBackgroundColor(.25, .25, .25, .5)
	cbh.TargetRaidMarkOptions:SetWidth(300)
	cbh.TargetRaidMarkOptions:SetHeight(cbh.TargetPositionPieces:GetHeight())
	cbh.TargetRaidMarkOptions:SetVisible(false)
	
	cbh.TargetRaidMarkLocationText:SetPoint("TOPLEFT", cbh.TargetRaidMarkOptions, "TOPLEFT", 5, 0)
	cbh.TargetRaidMarkLocationText:SetFontSize(15)
	cbh.TargetRaidMarkLocationText:SetText("Target RaidMark Location/Size")
	cbh.TargetRaidMarkSizer:SetPoint("TOPLEFT", cbh.TargetRaidMarkLocationText, "TOPLEFT", 0, 30)
	cbh.TargetRaidMarkSizer:SetRange(0, 72)
	cbh.TargetRaidMarkSizer:SetWidth(125)
	cbh.TargetRaidMarkSizer:SetPosition(cbhTargetValues.raidmarksize)
	function cbh.TargetRaidMarkSizer.Event.SliderChange()
		cbhTargetValues.raidmarksize = (cbh.TargetRaidMarkSizer:GetPosition())
		cbh.TargetRaidMark:SetWidth(cbhTargetValues.raidmarksize)
		cbh.TargetRaidMark:SetHeight(cbhTargetValues.raidmarksize)
	end

	cbh.TargetRaidMarkLocation:SetPoint("TOPLEFT", cbh.TargetRaidMarkSizer, "TOPRIGHT", 10, 0)
	cbh.TargetRaidMarkLocation:SetLayer(5)
	cbh.TargetRaidMarkLocation:SetFontSize(14)
	cbh.TargetRaidMarkLocation:SetItems(cbh.SetPoint)
	cbh.TargetRaidMarkLocation:SetSelectedItem(cbhTargetValues.raidmarklocation, silent)
	cbh.TargetRaidMarkLocation:SetWidth(125)
	cbh.TargetRaidMarkLocation.Event.ItemSelect = function(view, item)
		cbhTargetValues.raidmarklocation = item
		cbh.TargetRaidMark:ClearAll()
		cbh.TargetRaidMark:SetPoint(cbhTargetValues.raidmarklocation, cbh.TargetFrame, cbhTargetValues.raidmarklocation, cbhTargetValues.raidmarkoffsetx, cbhTargetValues.raidmarkoffsety)
		cbh.TargetRaidMark:SetWidth(cbhTargetValues.raidmarksize)
		cbh.TargetRaidMark:SetHeight(cbhTargetValues.raidmarksize)
	end
	
	-- Target RaidMark OFFSET
	cbh.TargetRaidMarkOffsetText:SetPoint("TOPLEFT", cbh.TargetRaidMarkSizer, "TOPLEFT", 0, 40)
	cbh.TargetRaidMarkOffsetText:SetFontSize(15)
	cbh.TargetRaidMarkOffsetText:SetText("Offset RaidMark: x, y")
	cbh.TargetRaidMarkOffsetX:SetPoint("TOPLEFT", cbh.TargetRaidMarkOffsetText, "TOPLEFT", 0, 30)
	cbh.TargetRaidMarkOffsetX:SetRange(-100, 100)
	cbh.TargetRaidMarkOffsetX:SetPosition(cbhTargetValues.raidmarkoffsetx)
	function cbh.TargetRaidMarkOffsetX.Event.SliderChange()
		cbhTargetValues.raidmarkoffsetx = (cbh.TargetRaidMarkOffsetX:GetPosition())
		cbh.TargetRaidMark:ClearPoint(x, y)
		cbh.TargetRaidMark:SetPoint(cbhTargetValues.raidmarklocation, cbh.TargetFrame, cbhTargetValues.raidmarklocation, cbhTargetValues.raidmarkoffsetx, cbhTargetValues.raidmarkoffsety)
	end
	cbh.TargetRaidMarkOffsetY:SetPoint("TOPLEFT", cbh.TargetRaidMarkOffsetX, "TOPLEFT", 0, 30)
	cbh.TargetRaidMarkOffsetY:SetRange(-100, 100)
	cbh.TargetRaidMarkOffsetY:SetPosition(cbhTargetValues.raidmarkoffsety)
	function cbh.TargetRaidMarkOffsetY.Event.SliderChange()
		cbhTargetValues.raidmarkoffsety = (cbh.TargetRaidMarkOffsetY:GetPosition())
		cbh.TargetRaidMark:ClearPoint(x, y)
		cbh.TargetRaidMark:SetPoint(cbhTargetValues.raidmarklocation, cbh.TargetFrame, cbhTargetValues.raidmarklocation, cbhTargetValues.raidmarkoffsetx, cbhTargetValues.raidmarkoffsety)
	end

	
	
	--[[ PVP MARK OPTIONS ]]--
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.TargetPvPMarkOptions:SetPoint("TOPLEFT", cbh.TargetPositionPieces, "TOPRIGHT", 10, 0)
	cbh.TargetPvPMarkOptions:SetBackgroundColor(.25, .25, .25, .5)
	cbh.TargetPvPMarkOptions:SetWidth(300)
	cbh.TargetPvPMarkOptions:SetHeight(cbh.TargetPositionPieces:GetHeight())
	cbh.TargetPvPMarkOptions:SetVisible(false)
	
	cbh.TargetPvPMarkLocationText:SetPoint("TOPLEFT", cbh.TargetPvPMarkOptions, "TOPLEFT", 5, 0)
	cbh.TargetPvPMarkLocationText:SetFontSize(15)
	-- cbh.TargetPvPMarkLocationText:SetText("Target PvPMark Location/Size")
	cbh.TargetPvPMarkLocationText:SetText("Target PvPMark Currently in testing")

	-- cbh.TargetPvPMarkToggle:SetPoint("TOPLEFT", cbh.TargetPvPMarkLocationText, "TOPLEFT", 0, 30)
	-- cbh.TargetPvPMarkToggle:SetFontSize(14)
	-- cbh.TargetPvPMarkToggle:SetLayer(1)
	-- cbh.TargetPvPMarkToggle:SetText("PvP Flag Always Visible (default: mouseover)")
	-- cbh.TargetPvPMarkToggle:SetChecked(cbhTargetValues.pvpalwaysshow == true)
	-- function cbh.TargetPvPMarkToggle.Event.CheckboxChange()
		-- cbhTargetValues.pvpalwaysshow = cbh.TargetPvPMarkToggle:GetChecked()
		-- if cbh.targetinfo.pvp and cbhTargetValues.pvpalwaysshow then
			-- cbh.TargetPvPMark:SetAlpha(1)
		-- else
			-- cbh.TargetPvPMark:SetAlpha(0)
		-- end
	-- end

	-- cbh.TargetPvPMarkSizer:SetPoint("TOPLEFT", cbh.TargetPvPMarkLocationText, "TOPLEFT", 0, 60)
	-- cbh.TargetPvPMarkSizer:SetRange(0, 72)
	-- cbh.TargetPvPMarkSizer:SetWidth(125)
	-- cbh.TargetPvPMarkSizer:SetPosition(cbhTargetValues.pvpmarksize)
	-- function cbh.TargetPvPMarkSizer.Event.SliderChange()
		-- cbhTargetValues.pvpmarksize = (cbh.TargetPvPMarkSizer:GetPosition())
		-- cbh.TargetPvPMark:SetFontSize(cbhTargetValues.pvpmarksize)
	-- end

	-- cbh.TargetPvPMarkLocation:SetPoint("TOPLEFT", cbh.TargetPvPMarkSizer, "TOPRIGHT", 10, 0)
	-- cbh.TargetPvPMarkLocation:SetLayer(5)
	-- cbh.TargetPvPMarkLocation:SetFontSize(14)
	-- cbh.TargetPvPMarkLocation:SetItems(cbh.SetPoint)
	-- cbh.TargetPvPMarkLocation:SetSelectedItem(cbhTargetValues.pvpmarklocation, silent)
	-- cbh.TargetPvPMarkLocation:SetWidth(125)
	-- cbh.TargetPvPMarkLocation.Event.ItemSelect = function(view, item)
		-- cbhTargetValues.pvpmarklocation = item
		-- cbh.TargetPvPMark:ClearAll()
		-- cbh.TargetPvPMark:SetPoint(cbhTargetValues.pvpmarklocation, cbh.TargetFrame, cbhTargetValues.pvpmarklocation, cbhTargetValues.pvpmarkoffsetx, cbhTargetValues.pvpmarkoffsety)
	-- end
	
	-- cbh.TargetPvPMarkOffsetText:SetPoint("TOPLEFT", cbh.TargetPvPMarkSizer, "TOPLEFT", 0, 40)
	-- cbh.TargetPvPMarkOffsetText:SetFontSize(15)
	-- cbh.TargetPvPMarkOffsetText:SetText("Offset PvPMark: x, y")
	-- cbh.TargetPvPMarkOffsetX:SetPoint("TOPLEFT", cbh.TargetPvPMarkOffsetText, "TOPLEFT", 0, 30)
	-- cbh.TargetPvPMarkOffsetX:SetRange(-100, 100)
	-- cbh.TargetPvPMarkOffsetX:SetPosition(cbhTargetValues.pvpmarkoffsetx)
	-- function cbh.TargetPvPMarkOffsetX.Event.SliderChange()
		-- cbhTargetValues.pvpmarkoffsetx = (cbh.TargetPvPMarkOffsetX:GetPosition())
		-- cbh.TargetPvPMark:ClearPoint(x, y)
		-- cbh.TargetPvPMark:SetPoint(cbhTargetValues.pvpmarklocation, cbh.TargetFrame, cbhTargetValues.pvpmarklocation, cbhTargetValues.pvpmarkoffsetx, cbhTargetValues.pvpmarkoffsety)
	-- end
	-- cbh.TargetPvPMarkOffsetY:SetPoint("TOPLEFT", cbh.TargetPvPMarkOffsetX, "TOPLEFT", 0, 30)
	-- cbh.TargetPvPMarkOffsetY:SetRange(-100, 100)
	-- cbh.TargetPvPMarkOffsetY:SetPosition(cbhTargetValues.pvpmarkoffsety)
	-- function cbh.TargetPvPMarkOffsetY.Event.SliderChange()
		-- cbhTargetValues.pvpmarkoffsety = (cbh.TargetPvPMarkOffsetY:GetPosition())
		-- cbh.TargetPvPMark:ClearPoint(x, y)
		-- cbh.TargetPvPMark:SetPoint(cbhTargetValues.pvpmarklocation, cbh.TargetFrame, cbhTargetValues.pvpmarklocation, cbhTargetValues.pvpmarkoffsetx, cbhTargetValues.pvpmarkoffsety)
	-- end

	
	
	--[[ Tier ICON OPTIONS ]]--
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.TargetTierOptions:SetPoint("TOPLEFT", cbh.TargetPositionPieces, "TOPRIGHT", 10, 0)
	cbh.TargetTierOptions:SetBackgroundColor(.25, .25, .25, .5)
	cbh.TargetTierOptions:SetWidth(300)
	cbh.TargetTierOptions:SetHeight(cbh.TargetPositionPieces:GetHeight())
	cbh.TargetTierOptions:SetVisible(false)
	
	cbh.TargetTierLocationText:SetPoint("TOPLEFT", cbh.TargetTierOptions, "TOPLEFT", 5, 0)
	cbh.TargetTierLocationText:SetFontSize(15)
	cbh.TargetTierLocationText:SetText("Tier Icon Location/Size")
	cbh.TargetTierSizer:SetPoint("TOPLEFT", cbh.TargetTierLocationText, "TOPLEFT", 0, 30)
	cbh.TargetTierSizer:SetRange(0, 120)
	cbh.TargetTierSizer:SetWidth(125)
	cbh.TargetTierSizer:SetPosition(cbhTargetValues.tiersize)
	function cbh.TargetTierSizer.Event.SliderChange()
		cbhTargetValues.tiersize = (cbh.TargetTierSizer:GetPosition())
		cbh.TargetTier:SetWidth(cbhTargetValues.tiersize)
		cbh.TargetTier:SetHeight(cbhTargetValues.tiersize)
	end

	cbh.TargetTierLocation:SetPoint("TOPLEFT", cbh.TargetTierSizer, "TOPRIGHT", 10, 0)
	cbh.TargetTierLocation:SetLayer(5)
	cbh.TargetTierLocation:SetFontSize(14)
	cbh.TargetTierLocation:SetItems(cbh.SetPoint)
	cbh.TargetTierLocation:SetSelectedItem(cbhTargetValues.tierlocation, silent)
	cbh.TargetTierLocation:SetWidth(125)
	cbh.TargetTierLocation.Event.ItemSelect = function(view, item)
		cbhTargetValues.tierlocation = item
		cbh.TargetTier:ClearAll()
		cbh.TargetTier:SetPoint(cbhTargetValues.tierlocation, cbh.TargetFrame, cbhTargetValues.tierlocation, cbhTargetValues.tieroffsetx, cbhTargetValues.tieroffsety)
		cbh.TargetTier:SetWidth(cbhTargetValues.tiersize)
		cbh.TargetTier:SetHeight(cbhTargetValues.tiersize)
	end
	
	-- Target Tier OFFSET
	cbh.TargetTierOffsetText:SetPoint("TOPLEFT", cbh.TargetTierSizer, "TOPLEFT", 0, 40)
	cbh.TargetTierOffsetText:SetFontSize(15)
	cbh.TargetTierOffsetText:SetText("Offset Tier: x, y")
	cbh.TargetTierOffsetX:SetPoint("TOPLEFT", cbh.TargetTierOffsetText, "TOPLEFT", 0, 30)
	cbh.TargetTierOffsetX:SetRange(-100, 100)
	cbh.TargetTierOffsetX:SetPosition(cbhTargetValues.tieroffsetx)
	function cbh.TargetTierOffsetX.Event.SliderChange()
		cbhTargetValues.tieroffsetx = (cbh.TargetTierOffsetX:GetPosition())
		cbh.TargetTier:ClearPoint(x, y)
		cbh.TargetTier:SetPoint(cbhTargetValues.tierlocation, cbh.TargetFrame, cbhTargetValues.tierlocation, cbhTargetValues.tieroffsetx, cbhTargetValues.tieroffsety)
	end
	cbh.TargetTierOffsetY:SetPoint("TOPLEFT", cbh.TargetTierOffsetX, "TOPLEFT", 0, 30)
	cbh.TargetTierOffsetY:SetRange(-100, 100)
	cbh.TargetTierOffsetY:SetPosition(cbhTargetValues.tieroffsety)
	function cbh.TargetTierOffsetY.Event.SliderChange()
		cbhTargetValues.tieroffsety = (cbh.TargetTierOffsetY:GetPosition())
		cbh.TargetTier:ClearPoint(x, y)
		cbh.TargetTier:SetPoint(cbhTargetValues.tierlocation, cbh.TargetFrame, cbhTargetValues.tierlocation, cbhTargetValues.tieroffsetx, cbhTargetValues.tieroffsety)
	end	
	
	
	--[[ Public ICON OPTIONS ]]--
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.TargetPublicIconOptions:SetPoint("TOPLEFT", cbh.TargetPositionPieces, "TOPRIGHT", 10, 0)
	cbh.TargetPublicIconOptions:SetBackgroundColor(.25, .25, .25, .5)
	cbh.TargetPublicIconOptions:SetWidth(300)
	cbh.TargetPublicIconOptions:SetHeight(cbh.TargetPositionPieces:GetHeight())
	cbh.TargetPublicIconOptions:SetVisible(false)
	
	cbh.TargetPublicIconLocationText:SetPoint("TOPLEFT", cbh.TargetPublicIconOptions, "TOPLEFT", 5, 0)
	cbh.TargetPublicIconLocationText:SetFontSize(15)
	cbh.TargetPublicIconLocationText:SetText("Public Icon Location/Size")
	cbh.TargetPublicIconSizer:SetPoint("TOPLEFT", cbh.TargetPublicIconLocationText, "TOPLEFT", 0, 30)
	cbh.TargetPublicIconSizer:SetRange(0, 72)
	cbh.TargetPublicIconSizer:SetWidth(125)
	cbh.TargetPublicIconSizer:SetPosition(cbhTargetValues.publiciconsize)
	function cbh.TargetPublicIconSizer.Event.SliderChange()
		cbhTargetValues.publiciconsize = (cbh.TargetPublicIconSizer:GetPosition())
		cbh.TargetPublicIcon:SetWidth(cbhTargetValues.publiciconsize)
		cbh.TargetPublicIcon:SetHeight(cbhTargetValues.publiciconsize)
		cbh.TargetPublicIconText:SetFontSize(cbhTargetValues.publiciconsize)
	end

	cbh.TargetPublicIconLocation:SetPoint("TOPLEFT", cbh.TargetPublicIconSizer, "TOPRIGHT", 10, 0)
	cbh.TargetPublicIconLocation:SetLayer(5)
	cbh.TargetPublicIconLocation:SetFontSize(14)
	cbh.TargetPublicIconLocation:SetItems(cbh.SetPoint)
	cbh.TargetPublicIconLocation:SetSelectedItem(cbhTargetValues.publiciconlocation, silent)
	cbh.TargetPublicIconLocation:SetWidth(125)
	cbh.TargetPublicIconLocation.Event.ItemSelect = function(view, item)
		cbhTargetValues.publiciconlocation = item
		cbh.TargetPublicIcon:ClearAll()
		cbh.TargetPublicIcon:SetPoint(cbhTargetValues.publiciconlocation, cbh.TargetFrame, cbhTargetValues.publiciconlocation, cbhTargetValues.publiciconoffsetx, cbhTargetValues.publiciconoffsety)
		cbh.TargetPublicIcon:SetWidth(cbhTargetValues.publiciconsize)
		cbh.TargetPublicIcon:SetHeight(cbhTargetValues.publiciconsize)
	end
	
	-- Target PublicIcon OFFSET
	cbh.TargetPublicIconOffsetText:SetPoint("TOPLEFT", cbh.TargetPublicIconSizer, "TOPLEFT", 0, 40)
	cbh.TargetPublicIconOffsetText:SetFontSize(15)
	cbh.TargetPublicIconOffsetText:SetText("Offset Public Icon: x, y")
	cbh.TargetPublicIconOffsetX:SetPoint("TOPLEFT", cbh.TargetPublicIconOffsetText, "TOPLEFT", 0, 30)
	cbh.TargetPublicIconOffsetX:SetRange(-100, 100)
	cbh.TargetPublicIconOffsetX:SetPosition(cbhTargetValues.publiciconoffsetx)
	function cbh.TargetPublicIconOffsetX.Event.SliderChange()
		cbhTargetValues.publiciconoffsetx = (cbh.TargetPublicIconOffsetX:GetPosition())
		cbh.TargetPublicIcon:ClearPoint(x, y)
		cbh.TargetPublicIcon:SetPoint(cbhTargetValues.publiciconlocation, cbh.TargetFrame, cbhTargetValues.publiciconlocation, cbhTargetValues.publiciconoffsetx, cbhTargetValues.publiciconoffsety)
	end
	cbh.TargetPublicIconOffsetY:SetPoint("TOPLEFT", cbh.TargetPublicIconOffsetX, "TOPLEFT", 0, 30)
	cbh.TargetPublicIconOffsetY:SetRange(-100, 100)
	cbh.TargetPublicIconOffsetY:SetPosition(cbhTargetValues.publiciconoffsety)
	function cbh.TargetPublicIconOffsetY.Event.SliderChange()
		cbhTargetValues.publiciconoffsety = (cbh.TargetPublicIconOffsetY:GetPosition())
		cbh.TargetPublicIcon:ClearPoint(x, y)
		cbh.TargetPublicIcon:SetPoint(cbhTargetValues.publiciconlocation, cbh.TargetFrame, cbhTargetValues.publiciconlocation, cbhTargetValues.publiciconoffsetx, cbhTargetValues.publiciconoffsety)
	end

	
	
	
	

	
	--[[ BUFF OPTIONS ]]--
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.TargetBuffsOptions:SetPoint("TOPLEFT", cbh.TargetPositionPieces, "TOPRIGHT", 10, 0)
	cbh.TargetBuffsOptions:SetBackgroundColor(.25, .25, .25, .5)
	cbh.TargetBuffsOptions:SetWidth(300)
	cbh.TargetBuffsOptions:SetHeight(cbh.TargetPositionPieces:GetHeight())
	cbh.TargetBuffsOptions:SetVisible(false)
	
	cbh.TargetBuffsLocationText:SetPoint("TOPLEFT", cbh.TargetBuffsOptions, "TOPLEFT", 0, 0)
	cbh.TargetBuffsLocationText:SetFontSize(16)
	cbh.TargetBuffsLocationText:SetText("Target Buff Location")

	cbh.TargetBuffsLocation:SetPoint("TOPLEFT", cbh.TargetBuffsLocationText, "TOPLEFT", 0, 30)
	cbh.TargetBuffsLocation:SetFontSize(14)
	cbh.TargetBuffsLocation:SetLayer(1)
	cbh.TargetBuffsLocation:SetText("Toggle buffs above/below frame")
	cbh.TargetBuffsLocation:SetChecked(cbhTargetValues.buffontop == true)
	function cbh.TargetBuffsLocation.Event.CheckboxChange()
		cbhTargetValues.buffontop = cbh.TargetBuffsLocation:GetChecked()
		if cbhTargetValues.buffontop and cbhTargetValues.buffreverse then
			cbhTargetValues.bufflocation = "BOTTOMRIGHT"
			cbhTargetValues.buffattach = "TOPRIGHT"
		elseif cbhTargetValues.buffontop and not cbhTargetValues.buffreverse then
			cbhTargetValues.bufflocation = "BOTTOMLEFT"
			cbhTargetValues.buffattach = "TOPLEFT"
		elseif not cbhTargetValues.buffontop and cbhTargetValues.buffreverse then
			cbhTargetValues.bufflocation = "TOPRIGHT"
			cbhTargetValues.buffattach = "BOTTOMRIGHT"
		elseif not cbhTargetValues.buffontop and not cbhTargetValues.buffreverse then
			cbhTargetValues.bufflocation = "TOPLEFT"
			cbhTargetValues.buffattach = "BOTTOMLEFT"
		end
		local tbuffsize = (cbhTargetValues.fwidth/cbhTargetValues.buffcount)-(4*cbhTargetValues.buffcount/cbhTargetValues.buffcount)
		local bufftempx = 0
		for i = 1, cbhTargetValues.buffcount do
			cbh.TargetBuffs[i]:ClearAll()
			cbh.TargetBuffs[i]:SetPoint(cbhTargetValues.bufflocation, cbh.TargetFrame, cbhTargetValues.buffattach, bufftempx, cbhTargetValues.buffoffsety)
			cbh.TargetBuffs[i]:SetLayer(2)
			cbh.TargetBuffs[i]:SetWidth(tbuffsize)
			cbh.TargetBuffs[i]:SetHeight(tbuffsize)
			bufftempx = (tbuffsize+5)*i
			if cbhTargetValues.buffreverse then bufftempx = -(bufftempx) end
		end
	end


	cbh.TargetBuffsReverseToggle:SetPoint("TOPLEFT", cbh.TargetBuffsLocationText, "TOPLEFT", 0, 60)
	cbh.TargetBuffsReverseToggle:SetFontSize(14)
	cbh.TargetBuffsReverseToggle:SetLayer(1)
	cbh.TargetBuffsReverseToggle:SetText("Buff order right to left")
	cbh.TargetBuffsReverseToggle:SetChecked(cbhTargetValues.buffreverse == true)
	function cbh.TargetBuffsReverseToggle.Event.CheckboxChange()
		cbhTargetValues.buffreverse = cbh.TargetBuffsReverseToggle:GetChecked()
		if cbhTargetValues.buffontop and cbhTargetValues.buffreverse then
			cbhTargetValues.bufflocation = "BOTTOMRIGHT"
			cbhTargetValues.buffattach = "TOPRIGHT"
		elseif cbhTargetValues.buffontop and not cbhTargetValues.buffreverse then
			cbhTargetValues.bufflocation = "BOTTOMLEFT"
			cbhTargetValues.buffattach = "TOPLEFT"
		elseif not cbhTargetValues.buffontop and cbhTargetValues.buffreverse then
			cbhTargetValues.bufflocation = "TOPRIGHT"
			cbhTargetValues.buffattach = "BOTTOMRIGHT"
		elseif not cbhTargetValues.buffontop and not cbhTargetValues.buffreverse then
			cbhTargetValues.bufflocation = "TOPLEFT"
			cbhTargetValues.buffattach = "BOTTOMLEFT"
		end
		local tbuffsize = (cbhTargetValues.fwidth/cbhTargetValues.buffcount)-(4*cbhTargetValues.buffcount/cbhTargetValues.buffcount)
		local bufftempx = 0
		for i = 1, cbhTargetValues.buffcount do
			cbh.TargetBuffs[i]:ClearAll()
			cbh.TargetBuffs[i]:SetPoint(cbhTargetValues.bufflocation, cbh.TargetFrame, cbhTargetValues.buffattach, bufftempx, cbhTargetValues.buffoffsety)
			cbh.TargetBuffs[i]:SetLayer(2)
			cbh.TargetBuffs[i]:SetWidth(tbuffsize)
			cbh.TargetBuffs[i]:SetHeight(tbuffsize)
			bufftempx = (tbuffsize+5)*i
			if cbhTargetValues.buffreverse then bufftempx = -(bufftempx) end
		end
	end

	
	cbh.TargetBuffsSizerText:SetPoint("TOPLEFT", cbh.TargetBuffsLocationText, "TOPLEFT", 0, 90)
	cbh.TargetBuffsSizerText:SetFontSize(15)
	cbh.TargetBuffsSizerText:SetText("Target Buff Count")
	cbh.TargetBuffsSizer:SetPoint("TOPLEFT", cbh.TargetBuffsSizerText, "TOPLEFT", 0, 30)
	cbh.TargetBuffsSizer:SetRange(0, 12)
	cbh.TargetBuffsSizer:SetWidth(125)
	cbh.TargetBuffsSizer:SetPosition(cbhTargetValues.buffcount)
	function cbh.TargetBuffsSizer.Event.SliderChange()
		cbhTargetValues.buffcount = (cbh.TargetBuffsSizer:GetPosition())
		local tbuffsize = (cbhTargetValues.fwidth/cbhTargetValues.buffcount)-(4*cbhTargetValues.buffcount/cbhTargetValues.buffcount)
		local bufftempx = 0
		for i = 1, cbhTargetValues.buffcount do
			if not cbh.TargetBuffs[i] then
				cbh.TargetBuffs[i] = UI.CreateFrame("Texture", "TargetBuffs", cbh.TargetWindow)
				cbh.TargetBuffsCounter[i] = UI.CreateFrame("Text", "TargetBuffsCounter", cbh.TargetWindow)
				cbh.TargetBuffsStackCounter[i] = UI.CreateFrame("Text", "TargetBuffsStackCounter", cbh.TargetWindow)
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
			cbh.TargetBuffs[i]:ClearAll()
			cbh.TargetBuffs[i]:SetPoint(cbhTargetValues.bufflocation, cbh.TargetFrame, cbhTargetValues.buffattach, bufftempx, cbhTargetValues.buffoffsety)
			cbh.TargetBuffs[i]:SetLayer(2)
			cbh.TargetBuffs[i]:SetWidth(tbuffsize)
			cbh.TargetBuffs[i]:SetHeight(tbuffsize)
			bufftempx = (tbuffsize+5)*i
			if cbhTargetValues.buffreverse then bufftempx = -(bufftempx) end
		end
	end

	-- Target Buff OFFSET
	cbh.TargetBuffsOffsetText:SetPoint("TOPLEFT", cbh.TargetBuffsSizer, "TOPLEFT", 0, 40)
	cbh.TargetBuffsOffsetText:SetFontSize(15)
	cbh.TargetBuffsOffsetText:SetText("Offset Buffs Vertical")
	-- cbh.TargetBuffsOffsetX:SetPoint("TOPLEFT", cbh.TargetBuffsOffsetText, "TOPLEFT", 0, 30)
	-- cbh.TargetBuffsOffsetX:SetRange(-100, 100)
	-- cbh.TargetBuffsOffsetX:SetPosition(cbhTargetValues.Buffoffsetx)
	-- function cbh.TargetBuffsOffsetX.Event.SliderChange()
		-- cbhTargetValues.Buffoffsetx = (cbh.TargetBuffsOffsetX:GetPosition())
		-- cbh.TargetBuffs:ClearPoint(x, y)
		-- cbh.TargetBuffs:SetPoint(cbhTargetValues.Bufflocation, cbh.TargetFrame, cbhTargetValues.Bufflocation, cbhTargetValues.Buffoffsetx, cbhTargetValues.Buffoffsety)
	-- end
	-- cbh.TargetBuffsOffsetY:SetPoint("TOPLEFT", cbh.TargetBuffsOffsetX, "TOPLEFT", 0, 30)
	cbh.TargetBuffsOffsetY:SetPoint("TOPLEFT", cbh.TargetBuffsOffsetText, "TOPLEFT", 0, 30)
	cbh.TargetBuffsOffsetY:SetRange(-100, 100)
	cbh.TargetBuffsOffsetY:SetPosition(cbhTargetValues.buffoffsety)
	function cbh.TargetBuffsOffsetY.Event.SliderChange()
		cbhTargetValues.buffoffsety = (cbh.TargetBuffsOffsetY:GetPosition())
		local tbuffsize = (cbhTargetValues.fwidth/cbhTargetValues.buffcount)-(4*cbhTargetValues.buffcount/cbhTargetValues.buffcount)
		local bufftempx = 0
		for i = 1, cbhTargetValues.buffcount do
			cbh.TargetBuffs[i]:ClearAll()
			cbh.TargetBuffs[i]:SetPoint(cbhTargetValues.bufflocation, cbh.TargetFrame, cbhTargetValues.buffattach, bufftempx, cbhTargetValues.buffoffsety)
			cbh.TargetBuffs[i]:SetLayer(2)
			cbh.TargetBuffs[i]:SetWidth(tbuffsize)
			cbh.TargetBuffs[i]:SetHeight(tbuffsize)
			bufftempx = (tbuffsize+5)*i
			if cbhTargetValues.buffreverse then bufftempx = -(bufftempx) end
		end
	end

	
	
	--[[ DEBUFF OPTIONS ]]--
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	cbh.TargetDebuffsOptions:SetPoint("TOPLEFT", cbh.TargetPositionPieces, "TOPRIGHT", 10, 0)
	cbh.TargetDebuffsOptions:SetBackgroundColor(.25, .25, .25, .5)
	cbh.TargetDebuffsOptions:SetWidth(300)
	cbh.TargetDebuffsOptions:SetHeight(cbh.TargetPositionPieces:GetHeight())
	cbh.TargetDebuffsOptions:SetVisible(false)
	
	cbh.TargetDebuffsLocationText:SetPoint("TOPLEFT", cbh.TargetDebuffsOptions, "TOPLEFT", 0, 0)
	cbh.TargetDebuffsLocationText:SetFontSize(16)
	cbh.TargetDebuffsLocationText:SetText("Target Debuff Location")

	cbh.TargetDebuffsLocation:SetPoint("TOPLEFT", cbh.TargetDebuffsLocationText, "TOPLEFT", 0, 30)
	cbh.TargetDebuffsLocation:SetFontSize(14)
	cbh.TargetDebuffsLocation:SetLayer(1)
	cbh.TargetDebuffsLocation:SetText("Toggle Debuffs above/below frame")
	cbh.TargetDebuffsLocation:SetChecked(cbhTargetValues.debuffontop == true)
	function cbh.TargetDebuffsLocation.Event.CheckboxChange()
		cbhTargetValues.debuffontop = cbh.TargetDebuffsLocation:GetChecked()
		if cbhTargetValues.debuffontop and cbhTargetValues.debuffreverse then
			cbhTargetValues.debufflocation = "BOTTOMRIGHT"
			cbhTargetValues.debuffattach = "TOPRIGHT"
		elseif cbhTargetValues.debuffontop and not cbhTargetValues.debuffreverse then
			cbhTargetValues.debufflocation = "BOTTOMLEFT"
			cbhTargetValues.debuffattach = "TOPLEFT"
		elseif not cbhTargetValues.debuffontop and cbhTargetValues.debuffreverse then
			cbhTargetValues.debufflocation = "TOPRIGHT"
			cbhTargetValues.debuffattach = "BOTTOMRIGHT"
		elseif not cbhTargetValues.debuffontop and not cbhTargetValues.debuffreverse then
			cbhTargetValues.debufflocation = "TOPLEFT"
			cbhTargetValues.debuffattach = "BOTTOMLEFT"
		end
		local tDebuffsize = (cbhTargetValues.fwidth/cbhTargetValues.debuffcount)-(4*cbhTargetValues.debuffcount/cbhTargetValues.debuffcount)
		local debufftempx = 0
		for i = 1, cbhTargetValues.debuffcount do
			cbh.TargetDebuffs[i]:ClearAll()
			cbh.TargetDebuffs[i]:SetPoint(cbhTargetValues.debufflocation, cbh.TargetFrame, cbhTargetValues.debuffattach, debufftempx, cbhTargetValues.debuffoffsety)
			cbh.TargetDebuffs[i]:SetLayer(2)
			cbh.TargetDebuffs[i]:SetWidth(tDebuffsize)
			cbh.TargetDebuffs[i]:SetHeight(tDebuffsize)
			debufftempx = (tDebuffsize+5)*i
			if cbhTargetValues.debuffreverse then debufftempx = -(debufftempx) end
		end
	end


	cbh.TargetDebuffsReverseToggle:SetPoint("TOPLEFT", cbh.TargetDebuffsLocationText, "TOPLEFT", 0, 60)
	cbh.TargetDebuffsReverseToggle:SetFontSize(14)
	cbh.TargetDebuffsReverseToggle:SetLayer(1)
	cbh.TargetDebuffsReverseToggle:SetText("Debuffs order right to left")
	cbh.TargetDebuffsReverseToggle:SetChecked(cbhTargetValues.debuffreverse == true)
	function cbh.TargetDebuffsReverseToggle.Event.CheckboxChange()
		cbhTargetValues.debuffreverse = cbh.TargetDebuffsReverseToggle:GetChecked()
		if cbhTargetValues.debuffontop and cbhTargetValues.debuffreverse then
			cbhTargetValues.debufflocation = "BOTTOMRIGHT"
			cbhTargetValues.debuffattach = "TOPRIGHT"
		elseif cbhTargetValues.debuffontop and not cbhTargetValues.debuffreverse then
			cbhTargetValues.debufflocation = "BOTTOMLEFT"
			cbhTargetValues.debuffattach = "TOPLEFT"
		elseif not cbhTargetValues.debuffontop and cbhTargetValues.debuffreverse then
			cbhTargetValues.debufflocation = "TOPRIGHT"
			cbhTargetValues.debuffattach = "BOTTOMRIGHT"
		elseif not cbhTargetValues.debuffontop and not cbhTargetValues.debuffreverse then
			cbhTargetValues.debufflocation = "TOPLEFT"
			cbhTargetValues.debuffattach = "BOTTOMLEFT"
		end
		local tDebuffsize = (cbhTargetValues.fwidth/cbhTargetValues.debuffcount)-(4*cbhTargetValues.debuffcount/cbhTargetValues.debuffcount)
		local debufftempx = 0
		for i = 1, cbhTargetValues.debuffcount do
			cbh.TargetDebuffs[i]:ClearAll()
			cbh.TargetDebuffs[i]:SetPoint(cbhTargetValues.debufflocation, cbh.TargetFrame, cbhTargetValues.debuffattach, debufftempx, cbhTargetValues.debuffoffsety)
			cbh.TargetDebuffs[i]:SetLayer(2)
			cbh.TargetDebuffs[i]:SetWidth(tDebuffsize)
			cbh.TargetDebuffs[i]:SetHeight(tDebuffsize)
			debufftempx = (tDebuffsize+5)*i
			if cbhTargetValues.debuffreverse then debufftempx = -(debufftempx) end
		end
	end

	
	cbh.TargetDebuffsSizerText:SetPoint("TOPLEFT", cbh.TargetDebuffsLocationText, "TOPLEFT", 0, 90)
	cbh.TargetDebuffsSizerText:SetFontSize(15)
	cbh.TargetDebuffsSizerText:SetText("Target Debuff Count")
	cbh.TargetDebuffsSizer:SetPoint("TOPLEFT", cbh.TargetDebuffsSizerText, "TOPLEFT", 0, 30)
	cbh.TargetDebuffsSizer:SetRange(0, 12)
	cbh.TargetDebuffsSizer:SetWidth(125)
	cbh.TargetDebuffsSizer:SetPosition(cbhTargetValues.debuffcount)
	function cbh.TargetDebuffsSizer.Event.SliderChange()
		cbhTargetValues.debuffcount = (cbh.TargetDebuffsSizer:GetPosition())
		local tDebuffsize = (cbhTargetValues.fwidth/cbhTargetValues.debuffcount)-(4*cbhTargetValues.debuffcount/cbhTargetValues.debuffcount)
		local debufftempx = 0
		for i = 1, cbhTargetValues.debuffcount do
			if not cbh.TargetDebuffs[i] then
				cbh.TargetDebuffs[i] = UI.CreateFrame("Texture", "TargetDebuffs", cbh.TargetWindow)
				cbh.TargetDebuffsCounter[i] = UI.CreateFrame("Text", "TargetDebuffsCounter", cbh.TargetWindow)
				cbh.TargetDebuffsStackCounter[i] = UI.CreateFrame("Text", "TargetDebuffsStackCounter", cbh.TargetWindow)
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
			cbh.TargetDebuffs[i]:ClearAll()
			cbh.TargetDebuffs[i]:SetPoint(cbhTargetValues.debufflocation, cbh.TargetFrame, cbhTargetValues.debuffattach, debufftempx, cbhTargetValues.debuffoffsety)
			cbh.TargetDebuffs[i]:SetLayer(2)
			cbh.TargetDebuffs[i]:SetWidth(tDebuffsize)
			cbh.TargetDebuffs[i]:SetHeight(tDebuffsize)
			debufftempx = (tDebuffsize+5)*i
			if cbhTargetValues.debuffreverse then debufftempx = -(debufftempx) end
		end
	end

	-- Target Buff OFFSET
	cbh.TargetDebuffsOffsetText:SetPoint("TOPLEFT", cbh.TargetDebuffsSizer, "TOPLEFT", 0, 40)
	cbh.TargetDebuffsOffsetText:SetFontSize(15)
	cbh.TargetDebuffsOffsetText:SetText("Offset Debuffs Vertical")
	-- cbh.TargetDebuffsOffsetX:SetPoint("TOPLEFT", cbh.TargetDebuffsOffsetText, "TOPLEFT", 0, 30)
	-- cbh.TargetDebuffsOffsetX:SetRange(-100, 100)
	-- cbh.TargetDebuffsOffsetX:SetPosition(cbhTargetValues.Buffoffsetx)
	-- function cbh.TargetDebuffsOffsetX.Event.SliderChange()
		-- cbhTargetValues.Buffoffsetx = (cbh.TargetDebuffsOffsetX:GetPosition())
		-- cbh.TargetDebuffs:ClearPoint(x, y)
		-- cbh.TargetDebuffs:SetPoint(cbhTargetValues.Bufflocation, cbh.TargetFrame, cbhTargetValues.Bufflocation, cbhTargetValues.Buffoffsetx, cbhTargetValues.Buffoffsety)
	-- end
	-- cbh.TargetDebuffsOffsetY:SetPoint("TOPLEFT", cbh.TargetDebuffsOffsetX, "TOPLEFT", 0, 30)
	cbh.TargetDebuffsOffsetY:SetPoint("TOPLEFT", cbh.TargetDebuffsOffsetText, "TOPLEFT", 0, 30)
	cbh.TargetDebuffsOffsetY:SetRange(-100, 100)
	cbh.TargetDebuffsOffsetY:SetPosition(cbhTargetValues.debuffoffsety)
	function cbh.TargetDebuffsOffsetY.Event.SliderChange()
		cbhTargetValues.debuffoffsety = (cbh.TargetDebuffsOffsetY:GetPosition())
		local tDebuffsize = (cbhTargetValues.fwidth/cbhTargetValues.debuffcount)-(4*cbhTargetValues.debuffcount/cbhTargetValues.debuffcount)
		local debufftempx = 0
		for i = 1, cbhTargetValues.debuffcount do
			cbh.TargetDebuffs[i]:ClearAll()
			cbh.TargetDebuffs[i]:SetPoint(cbhTargetValues.debufflocation, cbh.TargetFrame, cbhTargetValues.debuffattach, debufftempx, cbhTargetValues.debuffoffsety)
			cbh.TargetDebuffs[i]:SetLayer(2)
			cbh.TargetDebuffs[i]:SetWidth(tDebuffsize)
			cbh.TargetDebuffs[i]:SetHeight(tDebuffsize)
			debufftempx = (tDebuffsize+5)*i
			if cbhTargetValues.debuffreverse then debufftempx = -(debufftempx) end
		end
	end
end
