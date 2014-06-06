--[[
file: optionWindow.lua
by: Solsis00
for: ClickBoxHealer

This file houses the configuration window for CBH.

**COMPLETE: Converted to local cbh table successfully.
]]--


local addon, cbh = ...

cbh.optionsloaded = false



cbhoptionText = [[
"Configuration Window will begin getting a complete overhaul as I segment out all the new options. Please make sure you look through all the options before posting that you can't find something that was previously there.

<<-----  NEW OPTIONS HAVE ARRIVED!  Please use the tabs at the LEFT and BOTTOM of the window to access the different component configurations for CBH.

Thanks again for downloading. Enjoy!  :D
]]

--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--			GENERAL OPTIONS TAB
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]

function cbh.BasicInfo()
	cbh.InfoTabText:SetPoint("TOPLEFT", cbh.WindowOptionsA, "TOPLEFT", 20, 20)
	cbh.InfoTabText:SetWidth(300)
	cbh.InfoTabText:SetHeight(600)
	cbh.InfoTabText:SetFontSize(16)
	cbh.InfoTabText:SetWordwrap(true)
	cbh.InfoTabText:SetFontColor(1,1,1,1)
	cbh.InfoTabText:SetText(cbhoptionText)
	cbh.InfoTabText:SetEffectGlow(cbh.ConfigGlowTable)


	-- TOGGLE OUT OF COMBAT DISPLAY
	cbh.OutofCombat:SetPoint("TOPLEFT", cbh.WindowOptionsA, "TOPLEFT", 590, 20)
	cbh.OutofCombat:SetFontSize(14)
	cbh.OutofCombat:SetLayer(1)
	cbh.OutofCombat:SetText("Toggle out of combat fade")
	cbh.OutofCombat:SetChecked(cbhValues.hideooc == true)
	function cbh.OutofCombat.Event.CheckboxChange()
		if cbh.OutofCombat:GetChecked() == true then
			cbhValues.hideooc = true
			for groupnum = 1, 20 do
				if cbh.UnitStatus[groupnum].los then
					cbh.HideOutofCombat(groupnum, cbh.UnitStatus[groupnum].los)
				elseif cbh.UnitStatus[groupnum].outofrange then
					cbh.HideOutofCombat(groupnum, cbh.UnitStatus[groupnum].outofrange)
				else
					cbh.HideOutofCombat(groupnum, cbh.UnitStatus[groupnum].los)
				end
			end
		else
			cbhValues.hideooc = false
			for j = 1, 20 do
				if not cbh.UnitStatus[j].outofrange and not cbh.UnitStatus[j].los then
					cbh.groupBF[j]:SetAlpha(1)
					cbh.UnitStatus[j].oocalpha = 1
				else
					cbh.groupBF[j]:SetAlpha(cbhValues.alphasetting)
					cbh.UnitStatus[j].oocalpha = cbhValues.alphasetting	--does cbhValues.alphasetting exist? Check! and validate this routine
				end
			end
		end
	end


	-- OUT OF COMBAT FADE ALPHA
	cbh.OutofCombatAlphaText:SetPoint("TOPLEFT", cbh.WindowOptionsA, "TOPLEFT", 590, 50)
	cbh.OutofCombatAlphaText:SetFontSize(cbhValues.optfontsize)
	cbh.OutofCombatAlphaText:SetText("Sets Out of Combat Alpha")

	cbh.OutofCombatAlpha:SetPoint("TOPLEFT", cbh.WindowOptionsA, "TOPLEFT", 590, 70)
	cbh.OutofCombatAlpha:SetRange(0, 100)
	cbh.OutofCombatAlpha:SetWidth(100)
	cbh.OutofCombatAlpha:SetPosition(math.floor(cbhValues.oocalpha*100))
	function cbh.OutofCombatAlpha.Event.SliderChange()
		cbhValues.oocalpha = (cbh.OutofCombatAlpha:GetPosition() / 100)
		for groupnum = 1, 20 do
			if cbh.UnitStatus[groupnum].los then
				cbh.HideOutofCombat(groupnum, cbh.UnitStatus[groupnum].los)
			elseif cbh.UnitStatus[groupnum].outofrange then
				cbh.HideOutofCombat(groupnum, cbh.UnitStatus[groupnum].outofrange)
			else
				cbh.HideOutofCombat(groupnum, cbh.UnitStatus[groupnum].los)
			end
		end
	end


	-- MINIMAP TOGGLE OPTION
	cbh.MMBToggle:SetPoint("TOPLEFT", cbh.WindowOptionsA, "TOPLEFT", 590, 120)
	cbh.MMBToggle:SetFontSize(14)
	cbh.MMBToggle:SetLayer(1)
	cbh.MMBToggle:SetText("Show Minimap Button")
	cbh.MMBToggle:SetChecked(cbhValues.MMBVis == true)
	function cbh.MMBToggle.Event.CheckboxChange()
		if cbh.MMBToggle:GetChecked() == true then
			cbhValues.MMBVis = true
		else
			cbhValues.MMBVis = false
		end
		cbh.ToggleMMB()
	end




	cbh.NotificationToggle:SetPoint("BOTTOMLEFT", cbh.WindowOptionsA, "BOTTOMLEFT", 10, -10)
	cbh.NotificationToggle:SetLayer(2)
	cbh.NotificationToggle:SetText("Show Notifications")
	cbh.NotificationToggle:EventAttach(Event.UI.Input.Mouse.Left.Click, function(self, h)
		cbh.NotifyWindow:SetVisible(true)
	end, "Event.UI.Input.Mouse.Left.Click")
end






--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
--[[						UNIT FRAME COLOR/LAYOUT OPTIONS]]
--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]

function cbh.FrameOptions()
	cbh.TempColors = {}

	for i = 1, 8 do
		cbh.TempColors[i] = {}
		cbh.TempColors[i].r = cbhCallingColors[i].r
		cbh.TempColors[i].g = cbhCallingColors[i].g
		cbh.TempColors[i].b = cbhCallingColors[i].b
		cbh.TempColors[i].a = cbhCallingColors[i].a
	end

	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	--[[ xxxxxxxxxxxxx COLUMN 1 xxxxxxxxxxxxx ]]--
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]

	-- Selection box for calling
	cbh.CallingSelText:SetPoint("TOPLEFT", cbh.WindowOptionsB, "TOPLEFT", 10, 10)
	cbh.CallingSelText:SetFontSize(14)
	cbh.CallingSelText:SetText("Select an item to customize the color.")

	cbh.OptionsCallingSelector:SetPoint("TOPLEFT", cbh.CallingSelText, "BOTTOMLEFT", 0, 0)
	cbh.OptionsCallingSelector:SetWidth(140)
	cbh.OptionsCallingSelector:SetFontSize(cbhValues.optfontsize)
	cbh.OptionsCallingSelector:SetBorder(1, 1, 1, 1, 0)
	cbhcallinglist = {"Warrior", "Cleric", "Mage", "Rogue", "Percentage", "BackColor", "HealthColor", "Absorb Shield"}
	cbhclindex = 1
	cbh.OptionsCallingSelector:SetItems(cbhcallinglist)
	cbh.OptionsCallingSelector:SetSelectedIndex(1)


	-- Color sliders for various pieces of the unit frame
	cbh.OptionsColorSliderText:SetPoint("TOPLEFT", cbh.OptionsCallingSelector, "BOTTOMLEFT", 0, 20)
	cbh.OptionsColorSliderText:SetText("Unit Frame Color Options.  r, g, b")
	cbh.OptionsColorSliderText:SetFontSize(cbhValues.optfontsize)
	-- Red
	cbh.OptionsColorSliderR:SetPoint("TOPLEFT", cbh.OptionsColorSliderText, "BOTTOMLEFT", 0, 0)
	cbh.OptionsColorSliderR:SetRange(0, 100)
	cbh.OptionsColorSliderR:SetPosition(math.floor((cbh.TempColors[1].r * 100) + 0.5))
	-- Green
	cbh.OptionsColorSliderG:SetPoint("TOPLEFT", cbh.OptionsColorSliderR, "BOTTOMLEFT", 0, 5)
	cbh.OptionsColorSliderG:SetRange(0, 100)
	cbh.OptionsColorSliderG:SetPosition(math.floor((cbh.TempColors[1].g * 100) + 0.5))
	-- Blue
	cbh.OptionsColorSliderB:SetPoint("TOPLEFT", cbh.OptionsColorSliderG, "BOTTOMLEFT", 0, 5)
	cbh.OptionsColorSliderB:SetRange(0, 100)
	cbh.OptionsColorSliderB:SetPosition(math.floor((cbh.TempColors[1].b * 100) + 0.5))
	-- Opacity (Alpha) slider for the backframe coloring.
	cbh.OptionsColorSliderBFCA:SetPoint("TOPLEFT", cbh.OptionsColorSliderB, "BOTTOMLEFT", 0, 5)
	cbh.OptionsColorSliderBFCA:SetRange(0, 100)
	cbh.OptionsColorSliderBFCA:SetVisible(false)



	-- Event that is triggered when you select Warrior, Cleric, etc from the menu
	cbh.OptionsCallingSelector.Event.ItemSelect = function(view, item, value, index)
		cbhclindex = index
		if cbhclindex == nil then cbhclindex = 1 end
		if index < 5 then
			cbh.OptionsColor1:SetText("I am a "..cbh.OptionsCallingSelector:GetSelectedItem(item))
		end
		cbh.OptionsColorSliderR:SetPosition(math.floor((cbh.TempColors[cbhclindex].r * 100) + 0.5))
		cbh.OptionsColorSliderG:SetPosition(math.floor((cbh.TempColors[cbhclindex].g * 100) + 0.5))
		cbh.OptionsColorSliderB:SetPosition(math.floor((cbh.TempColors[cbhclindex].b * 100) + 0.5))
		if cbhclindex == 6 or cbhclindex == 7 then
			cbh.OptionsColorSliderBFCA:SetVisible(true)
			cbh.OptionsColorSliderBFCA:SetPosition(math.floor((cbh.TempColors[cbhclindex].a * 100) + 0.5))
		else
			cbh.OptionsColorSliderBFCA:SetVisible(false)
		end
	end

	-- Update function to apply calling color changes
	function cbh.UpdateCallingColorChanges()
		if cbhclindex == nil then sel = 1 else sel = cbhclindex end
		if sel <= 4 then
			cbh.OptionsColor1:SetFontColor(cbh.TempColors[sel].r, cbh.TempColors[sel].g, cbh.TempColors[sel].b, 1)
		elseif sel == 5 then	--health status
			cbh.OptionsColor2:SetFontColor(cbh.TempColors[sel].r, cbh.TempColors[sel].g, cbh.TempColors[sel].b, 1)
		elseif sel == 6 then	--background color
			cbh.OptionsUITextureBF:SetBackgroundColor(cbh.TempColors[cbhclindex].r, cbh.TempColors[cbhclindex].g, cbh.TempColors[cbhclindex].b, cbh.TempColors[cbhclindex].a)
		elseif sel == 7 then	--health color
			cbh.OptionsUITexture:SetBackgroundColor(cbh.TempColors[cbhclindex].r, cbh.TempColors[cbhclindex].g, cbh.TempColors[cbhclindex].b, cbh.TempColors[cbhclindex].a)
		elseif sel == 8 then	--absorb color
			cbh.OptionsUITextureAb:SetBackgroundColor(cbh.TempColors[sel].r, cbh.TempColors[sel].g, cbh.TempColors[sel].b, 1)
		end
	end

	function cbh.OptionsColorSliderR.Event.SliderChange()
		cbh.TempColors[cbhclindex].r = (cbh.OptionsColorSliderR:GetPosition() / 100)
		cbh.UpdateCallingColorChanges()
	end
	function cbh.OptionsColorSliderG.Event.SliderChange()
		cbh.TempColors[cbhclindex].g = (cbh.OptionsColorSliderG:GetPosition() / 100)
		cbh.UpdateCallingColorChanges()
	end
	function cbh.OptionsColorSliderB.Event.SliderChange()
		cbh.TempColors[cbhclindex].b = (cbh.OptionsColorSliderB:GetPosition() / 100)
		cbh.UpdateCallingColorChanges()
	end
	function cbh.OptionsColorSliderBFCA.Event.SliderChange()
		cbh.TempColors[cbhclindex].a = (cbh.OptionsColorSliderBFCA:GetPosition() / 100)
		cbh.UpdateCallingColorChanges()
		-- cbh.OptionsUITextureBF:SetBackgroundColor(cbh.TempColors[6].r, cbh.TempColors[6].g, cbh.TempColors[6].b, 1)--cbh.TempColors[6].a)
	end


	-- OPTION TO USE HEALTH GRADIENT RATHER THAN ONE COLOR
	cbh.OptionsColorToggle:SetPoint("TOPLEFT", cbh.OptionsColorSliderB, "TOPLEFT", 0, 60)
	cbh.OptionsColorToggle:SetFontSize(14)
	cbh.OptionsColorToggle:SetLayer(1)
	cbh.OptionsColorToggle:SetText("Color health by %")
	cbh.OptionsColorToggle:SetChecked(cbhValues.healthgradient == true)
	function cbh.OptionsColorToggle.Event.CheckboxChange()
		if cbh.OptionsColorToggle:GetChecked() == true then
			cbhValues.healthgradient = true
		else
			cbhValues.healthgradient = false
		end
	end


	-- UNIT NAME SETTINGS
	cbh.NameLocationText:SetPoint("TOPLEFT", cbh.OptionsColorToggle, "TOPLEFT", 0, 75)
	cbh.NameLocationText:SetFontSize(14)
	cbh.NameLocationText:SetText("Name Location/Size")
	cbh.FontSizer:SetPoint("TOPLEFT", cbh.NameLocationText, "TOPLEFT", 0, 20)
	cbh.FontSizer:SetRange(0, 24)
	cbh.FontSizer:SetWidth(125)
	cbh.FontSizer:SetPosition(cbhValues.namesize)
	function cbh.FontSizer.Event.SliderChange()
		cbhValues.namesize = (cbh.FontSizer:GetPosition())
		for i = 1, 20 do
			cbh.groupName[i]:SetFontSize(cbhValues.namesize)
		end
	end

	cbh.NameLocation:SetPoint("TOPLEFT", cbh.FontSizer, "TOPRIGHT", 10, 0)
	cbh.NameLocation:SetLayer(5)
	cbh.NameLocation:SetFontSize(14)
	cbh.NameLocation:SetItems(cbh.SetPoint)
	cbh.NameLocation:SetSelectedItem(cbhValues.namesetpoint, silent)
	-- cbh.NameLocation:ResizeToFit()
	cbh.NameLocation:SetWidth(125)
	cbh.NameLocation.Event.ItemSelect = function(view, item)
		cbhValues.namesetpoint = item
		cbh.NameLocation:SetWidth(125)
		-- cbh.CreateGroupFrames()
		for groupnum = 1,20 do
			cbh.groupName[groupnum]:ClearAll()
			cbh.groupName[groupnum]:SetPoint(cbhValues.namesetpoint, cbh.groupBase[groupnum], cbhValues.namesetpoint, 0, 0)
		end
	end


	-- FUNCTION FOR THE FOLLOWING 2 NAME OPTIONS TO GET RE-CALCULATED
	local function cbhAdjustNameLength()
		for groupnum = 1, 20 do
			if cbh.UnitStatus[groupnum].name then
				sendname = cbh.UnitStatus[groupnum].name
				cbh.nameCalc(sendname, groupnum)
			end
		end
	end

	cbh.NameLengthOption:SetPoint("TOPLEFT", cbh.FontSizer, "TOPLEFT", 0, 30)
	cbh.NameLengthOption:SetFontSize(14)
	cbh.NameLengthOption:SetLayer(1)
	cbh.NameLengthOption:SetText("Name Length Auto")
	cbh.NameLengthOption:SetChecked(cbhValues.namelengthauto == true)
	function cbh.NameLengthOption.Event.CheckboxChange()
		if cbh.NameLengthOption:GetChecked() == true then
			cbhValues.namelengthauto = true
			cbh.NameLength:SetVisible(false)
		else
			cbhValues.namelengthauto = false
			cbh.NameLength:SetVisible(true)
		end
		cbhAdjustNameLength()
	end

	-- SLIDER TO CHANGE NAME LENGTH  **HIDES IF AUTO IS TRUE**
	cbh.NameLength:SetPoint("TOPLEFT", cbh.NameLengthOption, "TOPLEFT", 0, 20)
	cbh.NameLength:SetRange(0, 16)
	cbh.NameLength:SetPosition(cbhValues.namelength)
	function cbh.NameLength.Event.SliderChange()
		cbhValues.namelength = cbh.NameLength:GetPosition()
		cbhAdjustNameLength()
	end

	-- ROLE ICON SETTINGS
	cbh.RoleLocationText:SetPoint("TOPLEFT", cbh.NameLength, "TOPLEFT", 0, 30)
	cbh.RoleLocationText:SetFontSize(14)
	cbh.RoleLocationText:SetText("Role Icon Location/Size")
	cbh.RoleSize:SetPoint("TOPLEFT", cbh.RoleLocationText, "TOPLEFT", 0, 20)
	cbh.RoleSize:SetRange(4, 24)
	cbh.RoleSize:SetWidth(125)
	cbh.RoleSize:SetPosition(cbhValues.rolesize)
	function cbh.RoleSize.Event.SliderChange()
		cbhValues.rolesize = cbh.RoleSize:GetPosition()
		cbh.CreateGroupFrames()
	end

	cbh.RoleLocation:SetPoint("TOPLEFT", cbh.RoleSize, "TOPRIGHT", 10, 0)
	cbh.RoleLocation:SetLayer(5)
	cbh.RoleLocation:SetFontSize(14)
	cbh.RoleLocation:SetItems(cbh.SetPoint)
	cbh.RoleLocation:SetSelectedItem(cbhValues.rolesetpoint, silent)
	-- cbh.RoleLocation:ResizeToFit()
	cbh.RoleLocation:SetWidth(125)
	cbh.RoleLocation.Event.ItemSelect = function(view, item)
		cbhValues.rolesetpoint = item
		cbh.RoleLocation:SetWidth(125)
		-- cbh.CreateGroupFrames()
		for groupnum = 1,20 do
			cbh.groupRole[groupnum]:ClearAll()
			cbh.groupRole[groupnum]:SetPoint(cbhValues.rolesetpoint, cbh.groupBase[groupnum], cbhValues.rolesetpoint, 0, 0)
			cbh.groupRole[groupnum]:SetWidth(cbhValues.rolesize)
			cbh.groupRole[groupnum]:SetHeight(cbhValues.rolesize)
		end
	end

	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	--[[ xxxxxxxxxxxxx COLUMN 2 xxxxxxxxxxxxx ]]--
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]

	-- PREVIEW HEALTH FRAME TEXTURE
	cbh.UFPreviewText:SetPoint("TOPLEFT", cbh.WindowOptionsB, "TOPLEFT", 300, 10)
	cbh.UFPreviewText:SetFontSize(14)
	cbh.UFPreviewText:SetText("Unit frame preview")

	cbh.OptionsUITexture:SetPoint("TOPLEFT", cbh.UFPreviewText, "BOTTOMLEFT", 0, 0)
	cbh.OptionsUITexture:SetTexture("ClickBoxHealer", "Textures/"..cbhValues.texture)
	cbh.OptionsUITexture:SetBackgroundColor(cbh.TempColors[7].r, cbh.TempColors[7].g, cbh.TempColors[7].b, cbh.TempColors[7].a)
	cbh.OptionsUITexture:SetWidth(130)
	cbh.OptionsUITexture:SetHeight(80)
	cbh.OptionsUITexture:SetLayer(3)

	-- PREVIEW BACKFRAME COLOR WITH TEXTURE SETUP
	cbh.OptionsUITextureBF:SetPoint("TOPLEFT", cbh.OptionsUITexture, "TOPLEFT", 0, 0)
	cbh.OptionsUITextureBF:SetBackgroundColor(cbh.TempColors[6].r, cbh.TempColors[6].g, cbh.TempColors[6].b, cbh.TempColors[6].a)
	cbh.OptionsUITextureBF:SetWidth(200)
	cbh.OptionsUITextureBF:SetHeight(80)
	cbh.OptionsUITextureBF:SetLayer(2)

	-- PREVIEW BACKFRAME COLOR WITH TEXTURE SETUP
	cbh.OptionsUITextureAb:SetPoint("BOTTOMLEFT", cbh.OptionsUITexture, "BOTTOMLEFT", 0, 0)
	cbh.OptionsUITextureAb:SetBackgroundColor(cbh.TempColors[8].r, cbh.TempColors[8].g, cbh.TempColors[8].b, cbh.TempColors[8].a)
	cbh.OptionsUITextureAb:SetTexture("ClickBoxHealer", "Textures/"..cbhValues.texture)
	cbh.OptionsUITextureAb:SetWidth(100)
	cbh.OptionsUITextureAb:SetHeight(10)
	cbh.OptionsUITextureAb:SetLayer(3)

	-- PREVIEW OF OPTIONSCOLOR1 = UNIT NAME COLOR BY CALLING
	cbh.OptionsColor1:SetPoint("CENTER", cbh.OptionsUITextureBF, "CENTER", 0, -20)
	cbh.OptionsColor1:SetLayer(5)
	cbh.OptionsColor1:SetFontSize(18)
	cbh.OptionsColor1:SetFontColor(cbh.TempColors[1].r, cbh.TempColors[1].g, cbh.TempColors[1].b, 1)
	cbh.OptionsColor1:SetText("I am a "..cbh.OptionsCallingSelector:GetSelectedItem(item))

	-- PREVIEW OF OPTIONSCOLOR2 = COLORING FOR NUMERIC HEALTH PERCENT
	cbh.OptionsColor2:SetPoint("CENTER", cbh.OptionsUITextureBF, "CENTER", 0, 20)
	cbh.OptionsColor2:SetLayer(5)
	cbh.OptionsColor2:SetFontSize(16)
	cbh.OptionsColor2:SetFontColor(cbh.TempColors[5].r, cbh.TempColors[5].g, cbh.TempColors[5].b, 1)
	cbh.OptionsColor2:SetText("Percentage 100%")


	-- BOX TO SELECT THE TEXTURES AVAILABLE
	cbh.TextureSelText:SetPoint("TOPLEFT", cbh.OptionsUITexture, "BOTTOMLEFT", 0, 10)
	cbh.TextureSelText:SetFontSize(14)
	cbh.TextureSelText:SetText("Select custom texture")

	cbh.OptionsTextureSelector:SetPoint("TOPLEFT", cbh.TextureSelText, "BOTTOMLEFT", 0, 0)
	cbh.OptionsTextureSelector:SetLayer(5)
	cbh.OptionsTextureSelector:SetFontSize(14)
	-- cbh.texturelist = {}

	-- table.insert(cbh.texturelist, 1, "none")
	-- for i = 1, 18 do
		-- table.insert(cbh.texturelist, "health_"..i..".png")
	-- end

	cbh.OptionsTextureSelector:SetItems(cbh.GlobalTextures)
	cbh.OptionsTextureSelector:SetSelectedItem(cbhValues.texture, silent)
	cbh.OptionsTextureSelector:ResizeToFit()
	cbh.OptionsTextureSelector.Event.ItemSelect = function(view, item)
		cbhValues.texture = item
		-- cbhPlayerValues.texture = item
		cbhTargetValues.texture = item
		-- print(item)
		cbh.OptionsUITexture:SetTexture("ClickBoxHealer", "Textures/"..cbhValues.texture)
		for i = 1, 20 do
			cbh.groupHF[i]:SetTexture("ClickBoxHealer", "Textures/"..cbhValues.texture)
			cbh.groupMF[i]:SetTexture("ClickBoxHealer", "Textures/"..cbhValues.texture)
			cbh.groupAbsBot[i]:SetTexture("ClickBoxHealer", "Textures/"..cbhValues.texture)
			-- if cbhPlayerValues.enabled then cbh.PlayerFrame:SetTexture("ClickBoxHealer", "Textures/"..cbhPlayerValues.texture) end --temporary until separate options are made
			if cbhTargetValues.enabled then cbh.TargetFrame:SetTexture("ClickBoxHealer", "Textures/"..cbhTargetValues.texture) end --temporary until separate options are made
		end
		cbh.OptionsTextureSelector:ResizeToFit()
	end


	-- SIZE OF EACH FRAME
	cbh.groupSizeText:SetPoint("TOPLEFT", cbh.WindowOptionsB, "TOPLEFT", 300, 200)
	cbh.groupSizeText:SetFontSize(14)
	cbh.groupSizeText:SetText("Size of unit frames  (width/height)")
	cbh.groupWidth:SetPoint("TOPLEFT", cbh.groupSizeText, "TOPLEFT", 0, 20)
	cbh.groupWidth:SetRange(0, 200)
	cbh.groupWidth:SetPosition(cbhValues.ufwidth)
	function cbh.groupWidth.Event.SliderChange()
		cbhValues.ufwidth = cbh.groupWidth:GetPosition()
		cbh.CreateGroupFrames()
	end

	-- SETS FRAME HEIGHT
	cbh.groupHeight:SetPoint("TOPLEFT", cbh.groupWidth, "TOPLEFT", 0, 30)
	cbh.groupHeight:SetRange(0, 200)
	cbh.groupHeight:SetPosition(cbhValues.ufheight)
	function cbh.groupHeight.Event.SliderChange()
		cbhValues.ufheight = cbh.groupHeight:GetPosition()
		cbh.CreateGroupFrames()
	end

	

	-- HORIZONTAL AND VERTICAL SPACING SELECTIONS
	cbh.groupSpacingText:SetPoint("TOPLEFT", cbh.groupHeight, "TOPLEFT", 0, 30)
	cbh.groupSpacingText:SetFontSize(14)
	cbh.groupSpacingText:SetText("Set spacing between frames (width/height)")
	cbh.groupHSpacing:SetPoint("TOPLEFT", cbh.groupSpacingText, "TOPLEFT", 0, 20)
	cbh.groupHSpacing:SetRange(0, 50)
	cbh.groupHSpacing:SetPosition(cbhValues.ufhgap)
	function cbh.groupHSpacing.Event.SliderChange()
		cbhValues.ufhgap = (cbh.groupHSpacing:GetPosition())
		cbh.CreateGroupFrames()
	end

	-- SETS VERTICAL SPACING BETWEEN FRAMES
	cbh.groupVSpacing:SetPoint("TOPLEFT", cbh.groupHSpacing, "TOPLEFT", 0, 30)
	cbh.groupVSpacing:SetRange(0, 50)
	cbh.groupVSpacing:SetPosition(cbhValues.ufvgap)
	function cbh.groupVSpacing.Event.SliderChange()
		cbhValues.ufvgap = (cbh.groupVSpacing:GetPosition())
		cbh.CreateGroupFrames()
	end



	-- RANGE/LOS ALPHA SLIDER
	cbh.AlphaSettingText:SetPoint("TOPLEFT", cbh.groupVSpacing, "TOPLEFT", 0, 30)
	cbh.AlphaSettingText:SetFontSize(14)
	cbh.AlphaSettingText:SetText("Adjust transparency for OoR/sight units")
	cbh.AlphaSetting:SetPoint("TOPLEFT", cbh.AlphaSettingText, "TOPLEFT", 0, 20)
	cbh.AlphaSetting:SetRange(0, 100)
	cbh.AlphaSetting:SetPosition(math.floor((cbhValues.alphasetting * 100) + 0.5))
	function cbh.AlphaSetting.Event.SliderChange()
		cbhValues.alphasetting = (cbh.AlphaSetting:GetPosition() / 100)
		for groupnum = 1, 20 do
			if cbh.UnitStatus[groupnum].outofrange or cbh.UnitStatus[groupnum].los then
					if not cbhValues.isincombat and cbh.UnitStatus[groupnum].oocalpha ~= cbhValues.oocalpha then
						cbh.groupBF[groupnum]:SetAlpha(cbhValues.oocalpha - 0.05)
						cbh.UnitStatus[groupnum].oocalpha = cbhValues.oocalpha
					elseif cbhValues.isincombat and cbh.UnitStatus[groupnum].oocalpha ~= cbhValues.alphasetting then
						cbh.groupBF[groupnum]:SetAlpha(cbhValues.alphasetting)
						cbh.UnitStatus[groupnum].oocalpha = cbhValues.alphasetting
					end
				-- cbh.groupBF[i]:SetAlpha(cbhValues.alphasetting)
			end
		end
	end


	-- MANA BAR SIZE SLIDER
	cbh.ManabarSizeText:SetPoint("TOPLEFT", cbh.AlphaSetting, "TOPLEFT", 0, 30)
	cbh.ManabarSizeText:SetFontSize(cbhValues.optfontsize)
	cbh.ManabarSizeText:SetText("Mana/Resource bar height")
	cbh.ManabarSizeHeight:SetPoint("TOPLEFT", cbh.ManabarSizeText, "TOPLEFT", 0, 20)
	cbh.ManabarSizeHeight:SetRange(0, 24)
	cbh.ManabarSizeHeight:SetPosition(cbhValues.mbheight)
	function cbh.ManabarSizeHeight.Event.SliderChange()
		cbhValues.mbheight = (cbh.ManabarSizeHeight:GetPosition())
		-- cbh.CreateGroupFrames()
		for groupnum = 1, 20 do
			cbh.framepos[groupnum].ymb = cbh.framepos[groupnum].y-cbhValues.mbheight
			if cbh.UnitStatus[groupnum].mana then
				if cbhValues.ordervup then cbh.groupBF[groupnum]:SetPoint("TOPRIGHT", cbh.groupHF[groupnum], "TOPRIGHT", cbh.framepos[groupnum].x, cbh.framepos[groupnum].ymb) end
				cbh.groupMB[groupnum]:SetVisible(true)
				cbh.groupMF[groupnum]:SetVisible(true)
				cbh.groupBF[groupnum]:SetHeight(cbhValues.ufheight-cbhValues.mbheight)
				cbh.groupHF[groupnum]:SetHeight(cbhValues.ufheight-cbhValues.mbheight)
				-- cbhAdjustAbsBar(groupnum, 1)
			else
				cbh.groupBF[groupnum]:SetPoint("TOPRIGHT", cbh.groupHF[groupnum], "TOPRIGHT", cbh.framepos[groupnum].x, cbh.framepos[groupnum].y)
				cbh.groupMB[groupnum]:SetVisible(false)
				cbh.groupMF[groupnum]:SetVisible(false)
				cbh.groupBF[groupnum]:SetHeight(cbhValues.ufheight)
				cbh.groupHF[groupnum]:SetHeight(cbhValues.ufheight)
				-- cbhAdjustAbsBar(groupnum, 0)
			end
			cbh.groupMB[groupnum]:SetHeight(cbhValues.mbheight)
			cbh.groupMF[groupnum]:SetHeight(cbhValues.mbheight)
		end
	end



	-- Shield Bar Height
	cbh.AbsbarSizeText:SetPoint("TOPLEFT", cbh.ManabarSizeHeight, "TOPLEFT", 0, 30)
	cbh.AbsbarSizeText:SetFontSize(cbhValues.optfontsize)
	cbh.AbsbarSizeText:SetText("Absorb bar height")
	cbh.AbsbarSizeHeight:SetPoint("TOPLEFT", cbh.AbsbarSizeText, "TOPLEFT", 0, 20)
	cbh.AbsbarSizeHeight:SetRange(0, 24)
	cbh.AbsbarSizeHeight:SetPosition(cbhValues.absheight)
	function cbh.AbsbarSizeHeight.Event.SliderChange()
		cbhValues.absheight = (cbh.AbsbarSizeHeight:GetPosition())
		-- cbh.CreateGroupFrames()
		for groupnum = 1, 20 do
			cbh.groupAbsBot[groupnum]:SetHeight(cbhValues.absheight)
		end
	end



	-- RAID MARKER SETTINGS
	cbh.RMarkLocationText:SetPoint("TOPLEFT", cbh.AbsbarSizeHeight, "TOPLEFT", 0, 30)
	cbh.RMarkLocationText:SetFontSize(14)
	cbh.RMarkLocationText:SetText("RaidMark Location")
	cbh.RMarkSize:SetPoint("TOPLEFT", cbh.RMarkLocationText, "TOPLEFT", 0, 20)
	cbh.RMarkSize:SetRange(4, 32)
	cbh.RMarkSize:SetWidth(125)
	cbh.RMarkSize:SetPosition(cbhValues.raidmarkersize)
	function cbh.RMarkSize.Event.SliderChange()
		cbhValues.raidmarkersize = cbh.RMarkSize:GetPosition()
		cbh.CreateGroupFrames()
	end

	cbh.RMarkLocation:SetPoint("TOPLEFT", cbh.RMarkSize, "TOPRIGHT", 10, 0)
	cbh.RMarkLocation:SetLayer(5)
	cbh.RMarkLocation:SetFontSize(14)
	cbh.RMarkLocation:SetItems(cbh.SetPoint)
	cbh.RMarkLocation:SetSelectedItem(cbhValues.rmarksetpoint, silent)
	-- cbh.RMarkLocation:ResizeToFit()
	cbh.RMarkLocation:SetWidth(125)
	cbh.RMarkLocation.Event.ItemSelect = function(view, item)
		cbhValues.rmarksetpoint = item
		cbh.RMarkLocation:SetWidth(125)
		-- cbh.CreateGroupFrames()
		for groupnum = 1,20 do
			cbh.RaidMarker[groupnum]:ClearAll()
			cbh.RaidMarker[groupnum]:SetPoint(cbhValues.rmarksetpoint, cbh.groupBase[groupnum], cbhValues.rmarksetpoint, 0, 0)
			cbh.RaidMarker[groupnum]:SetWidth(cbhValues.raidmarkersize)
			cbh.RaidMarker[groupnum]:SetHeight(cbhValues.raidmarkersize)
		end
	end


	-- READY CHECK SETTINGS
	cbh.ReadyCheckText:SetPoint("TOPLEFT", cbh.RMarkSize, "TOPLEFT", 0, 30)
	cbh.ReadyCheckText:SetFontSize(14)
	cbh.ReadyCheckText:SetText("Ready Check Loc/Size")
	cbh.ReadyCheckSize:SetPoint("TOPLEFT", cbh.ReadyCheckText, "TOPLEFT", 0, 20)
	cbh.ReadyCheckSize:SetRange(0, 48)
	cbh.ReadyCheckSize:SetWidth(125)
	cbh.ReadyCheckSize:SetPosition(cbhValues.readychecksize)
	function cbh.ReadyCheckSize.Event.SliderChange()
		cbhValues.readychecksize = (cbh.ReadyCheckSize:GetPosition())
		for i = 1, 20 do
			cbh.groupRDY[i]:SetWidth(cbhValues.readychecksize)
			cbh.groupRDY[i]:SetHeight(cbhValues.readychecksize)
		end
	end

	cbh.ReadyCheckLocation:SetPoint("TOPLEFT", cbh.ReadyCheckSize, "TOPRIGHT", 10, 0)
	cbh.ReadyCheckLocation:SetLayer(5)
	cbh.ReadyCheckLocation:SetFontSize(14)
	cbh.ReadyCheckLocation:SetItems(cbh.SetPoint)
	cbh.ReadyCheckLocation:SetSelectedItem(cbhValues.readychecksetpoint, silent)
	-- cbh.ReadyCheckLocation:ResizeToFit()
	cbh.ReadyCheckLocation:SetWidth(125)
	cbh.ReadyCheckLocation.Event.ItemSelect = function(view, item)
		cbhValues.readychecksetpoint = item
		cbh.ReadyCheckLocation:SetWidth(125)
		for groupnum = 1, 20 do
			cbh.groupRDY[groupnum]:ClearAll()
			cbh.groupRDY[groupnum]:SetPoint(cbhValues.readychecksetpoint, cbh.groupBase[groupnum], cbhValues.readychecksetpoint, 0, 0)
			if not cbh.readychecking then
				cbh.groupRDY[groupnum]:SetVisible(false)
			end
		end
	end




	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
	--[[ xxxxxxxxxxxxx COLUMN 3 xxxxxxxxxxxxx ]]--
	--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]

	-- COLUMN SORTING SLIDER AND TEXT
	cbh.groupColumnsText = UI.CreateFrame("Text", "Unit Column Text", cbh.WindowOptionsB)
	cbh.groupColumnsText:SetPoint("TOPLEFT", cbh.WindowOptionsB, "TOPLEFT", 590, 10)
	cbh.groupColumnsText:SetFontSize(cbhValues.optfontsize)
	cbh.groupColumnsText:SetText("Number of Unit Columns")

	-- cbh.groupColumns:SetPoint("TOPLEFT", cbh.WindowOptionsB, "TOPLEFT", 590, 30)
	-- cbh.groupColumns:SetRange(1, 4)
	-- cbh.groupColumns:SetWidth(100)
	-- cbh.groupColumns:SetPosition(cbhValues.ufcols)
	-- function cbh.groupColumns.Event.SliderChange()
		-- cbhValues.ufcols = cbh.groupColumns:GetPosition()
		-- cbh.CreateGroupFrames()
	-- end

	cbh.groupColumns:SetPoint("TOPLEFT", cbh.WindowOptionsB, "TOPLEFT", 590, 30)
	cbh.groupColumns:SetLayer(5)
	cbh.groupColumns:SetFontSize(14)
	cbh.UnitColumns = {[1]="1x20", [2]="2x10", [4]="4x5"}
	cbh.groupColumns:SetItems(cbh.UnitColumns)
	cbh.groupColumns:SetSelectedItem(cbh.UnitColumns[cbhValues.ufcols], silent)
	cbh.groupColumns:ResizeToFit()
	cbh.groupColumns.Event.ItemSelect = function(view, item)
		if item == "1x20" then
			cbhValues.ufcols = 1
		elseif item == "2x10" then
			cbhValues.ufcols = 2
		elseif item == "4x5" then
			cbhValues.ufcols = 4
		end
		cbh.CreateGroupFrames()
		-- for i = 1, 20 do
			-- NOTHING FOR NOW
		-- end
		cbh.groupColumns:ResizeToFit()
	end


	-- DRAW FRAMES IN HORIZONTAL GROUPS
	cbh.groupOrderHLeft:SetPoint("TOPLEFT", cbh.WindowOptionsB, "TOPLEFT", 590, 60)
	cbh.groupOrderHLeft:SetFontSize(14)
	cbh.groupOrderHLeft:SetLayer(1)
	cbh.groupOrderHLeft:SetText("Draw frames horizontal")
	cbh.groupOrderHLeft:SetChecked(cbhValues.orderhleft == true)
	function cbh.groupOrderHLeft.Event.CheckboxChange()
		if cbh.groupOrderHLeft:GetChecked() == true then
			cbhValues.orderhleft = true
		else
			cbhValues.orderhleft = false
		end
		cbh.CreateGroupFrames()
	end

	-- GROW FRAMES FROM BOTTOM TO TOP
	cbh.groupOrderVup:SetPoint("TOPLEFT", cbh.groupOrderHLeft, "TOPLEFT", 0, 30)
	cbh.groupOrderVup:SetFontSize(14)
	cbh.groupOrderVup:SetLayer(1)
	cbh.groupOrderVup:SetText("Grow frames up")
	cbh.groupOrderVup:SetChecked(cbhValues.ordervup == true)
	function cbh.groupOrderVup.Event.CheckboxChange()
		if cbh.groupOrderVup:GetChecked() == true then
			cbhValues.ordervup = true
		else
			cbhValues.ordervup = false
		end
		cbh.CreateGroupFrames()
	end

	-- GROW FRAMES RIGHT TO LEFT
	cbh.groupOrderHRight:SetPoint("TOPLEFT", cbh.groupOrderVup, "TOPLEFT", 0, 30)
	cbh.groupOrderHRight:SetFontSize(14)
	cbh.groupOrderHRight:SetLayer(1)
	cbh.groupOrderHRight:SetText("Grow frames right to left")
	cbh.groupOrderHRight:SetChecked(cbhValues.orderhright == true)
	function cbh.groupOrderHRight.Event.CheckboxChange()
		if cbh.groupOrderHRight:GetChecked() == true then
			cbhValues.orderhright = true
		else
			cbhValues.orderhright = false
		end
		cbh.CreateGroupFrames()
	end


	-- TOGGLE FASTER HEALTH UPDATES
	-- cbh.UIFastCPU:SetPoint("TOPLEFT", cbh.groupOrderHRight, "TOPLEFT", 0, 30)
	-- cbh.UIFastCPU:SetFontSize(14)
	-- cbh.UIFastCPU:SetLayer(1)
	-- cbh.UIFastCPU:SetText("Faster Health Updates")
	-- cbh.UIFastCPU:ResizeToFit()

	-- cbh.UIFastCPUText:EventAttach(Event.UI.Input.Mouse.Cursor.In, function(self, h)
		-- cbh.GenericTooltip:Show(cbh.UIFastCPU, "Causes extra CPU", "BOTTOMLEFT")
	-- end, "Event.UI.Input.Mouse.Cursor.In")

	-- cbh.UIFastCPUText:EventAttach(Event.UI.Input.Mouse.Cursor.Out, function(self, h)
		-- cbh.GenericTooltip:Hide(cbh.UIFastCPU)
	-- end, "Event.UI.Input.Mouse.Cursor.Out")

	-- if cbhValues.fastupdates == 0.25 then
		-- cbh.UIFastCPU:SetChecked(true)
	-- end

	-- function cbh.UIFastCPU.Event.CheckboxChange()
		-- if cbh.UIFastCPU:GetChecked() == true then
			-- cbhValues.fastupdates = 0.25
		-- else
			-- cbhValues.fastupdates = 1
		-- end
	-- end




	-- TOGGLE CLASS ROLE CHECKING
	cbh.RoleToggle:SetPoint("TOPLEFT", cbh.groupOrderHRight, "TOPLEFT", 0, 30)
	cbh.RoleToggle:SetFontSize(14)
	cbh.RoleToggle:SetLayer(1)
	cbh.RoleToggle:SetText("Track Class Roles")
	cbh.RoleToggle:SetChecked(cbhValues.rolewatch == true)
	function cbh.RoleToggle.Event.CheckboxChange()
		if cbh.RoleToggle:GetChecked() == true then
			cbhValues.rolewatch = true
			for n = 1, 20 do
				cbh.groupRole[n]:SetVisible(true)
			end
		else
			cbhValues.rolewatch = false
			for n = 1, 20 do
				cbh.groupRole[n]:SetVisible(false)
			end
		end
	end


	-- TOGGLE PET FRAMES
	cbh.ShowPetsToggle:SetPoint("TOPLEFT", cbh.RoleToggle, "TOPLEFT", 0, 30)
	cbh.ShowPetsToggle:SetFontSize(14)
	cbh.ShowPetsToggle:SetLayer(1)
	cbh.ShowPetsToggle:SetText("Toggle Pets")
	cbh.ShowPetsToggle:SetChecked(cbhValues.pet == true)
	function cbh.ShowPetsToggle.Event.CheckboxChange()
		if cbh.ShowPetsToggle:GetChecked() == true then
			cbhValues.pet = true
		else
			cbhValues.pet = false
		end
	end


	-- TOGGLE MOUSEOVER TOOLTIPS
	cbh.TooltipsToggle:SetPoint("TOPLEFT", cbh.ShowPetsToggle, "TOPLEFT", 0, 30)
	cbh.TooltipsToggle:SetFontSize(14)
	cbh.TooltipsToggle:SetLayer(1)
	cbh.TooltipsToggle:SetText("Toggle Tooltips")
	cbh.TooltipsToggle:SetChecked(cbhValues.showtooltips == true)
	function cbh.TooltipsToggle.Event.CheckboxChange()
		if cbh.TooltipsToggle:GetChecked() == true then
			cbhValues.showtooltips = true
			cbh.ToggleTT(1)
		else
			cbhValues.showtooltips = false
			cbh.ToggleTT(1)
		end
	end


	-- TOGGLE CHECKING FOR OUT OF RANGE UNITS
	cbh.RangeToggle:SetPoint("TOPLEFT", cbh.TooltipsToggle, "TOPLEFT", 0, 30)
	cbh.RangeToggle:SetFontSize(14)
	cbh.RangeToggle:SetLayer(1)
	cbh.RangeToggle:SetText("Fade out of range units")
	cbh.RangeToggle:SetChecked(cbhValues.rangecheck == true)
	function cbh.RangeToggle.Event.CheckboxChange()
		if cbh.RangeToggle:GetChecked() == true then
			cbhValues.rangecheck = true
		else
			cbhValues.rangecheck = false
		end
	end


	-- TOGGLE 35 YARD CHECK INSTEAD OF DEFAULT 30 YARDS
	cbh.RangeDistance:SetPoint("TOPLEFT", cbh.RangeToggle, "TOPLEFT", 0, 30)
	cbh.RangeDistance:SetFontSize(14)
	cbh.RangeDistance:SetLayer(1)
	cbh.RangeDistance:SetText("Range check 35 yards (default 30)")
	if cbhValues.rangecheckdist == 35 then
		cbh.RangeDistance:SetChecked(true)
	else
		cbh.RangeDistance:SetChecked(false)
	end
	function cbh.RangeDistance.Event.CheckboxChange()
		if cbh.RangeDistance:GetChecked() == true then
			cbhValues.rangecheckdist = 35
		else
			cbhValues.rangecheckdist = 30
		end
		cbh.rangevalue = cbhValues.rangecheckdist^2
		for i = 1,20 do
			cbh.UnitStatus[i].outofrange = nil
			cbh.UnitStatus[i].oocalpha = nil
		end
	end


	-- TOGGLE SHOWING ABSORB EFFECTS ON FRAMES
	cbh.AbsorbToggle:SetPoint("TOPLEFT", cbh.RangeDistance, "TOPLEFT", 0, 30)
	cbh.AbsorbToggle:SetFontSize(14)
	cbh.AbsorbToggle:SetLayer(1)
	cbh.AbsorbToggle:SetText("Show absorption effects on frames")
	cbh.AbsorbToggle:SetChecked(cbhValues.absShow == true)
	function cbh.AbsorbToggle.Event.CheckboxChange()
		if cbh.AbsorbToggle:GetChecked() == true then
			cbhValues.absShow = true
		else
			cbhValues.absShow = false
			for i = 1, 20 do
				cbh.groupAbsBot[i]:SetWidth(0)
				cbh.groupAbsBot[i]:SetAlpha(0)
			end
		end
	end


	-- TOGGLE CLASS COLORING MANA BARS
	cbh.manaClassColor:SetPoint("TOPLEFT", cbh.AbsorbToggle, "TOPLEFT", 0, 30)
	cbh.manaClassColor:SetFontSize(14)
	cbh.manaClassColor:SetLayer(1)
	cbh.manaClassColor:SetText("Class Color mana bars")
	cbh.manaClassColor:SetChecked(cbhValues.manaCC == true)
	function cbh.manaClassColor.Event.CheckboxChange()
		if cbh.manaClassColor:GetChecked() == true then
			cbhValues.manaCC = true
		else
			cbhValues.manaCC = false
		end
		for groupnum = 1, 20 do
			if cbhValues.manaCC then
				for i = 1, 4 do
					if cbh.UnitStatus[groupnum].calling == cbh.Calling[i] then
						cbh.groupMF[groupnum]:SetBackgroundColor(cbhCallingColors[i].r, cbhCallingColors[i].g, cbhCallingColors[i].b, 1)
					elseif cbh.UnitStatus[groupnum].calling == nil then
						cbh.groupName[groupnum]:SetFontColor(.8, .8, .8, 1)
					end
				end
			else
				cbh.groupMF[groupnum]:SetBackgroundColor(0,0,1,1)
			end
		end
	end

	-- TOGGLE RIGHT CLICK ON FRAMES FUNCTIONALITY
	cbh.CMenuToggle:SetPoint("TOPLEFT", cbh.manaClassColor, "TOPLEFT", 0, 30)
	cbh.CMenuToggle:SetFontSize(14)
	cbh.CMenuToggle:SetLayer(1)
	cbh.CMenuToggle:SetText("Toggle Right Click Menus")
	cbh.CMenuToggle:SetChecked(cbhValues.cmenu == true)
	function cbh.CMenuToggle.Event.CheckboxChange()
		if cbh.CMenuToggle:GetChecked() == true then
			cbhValues.cmenu = true
			cbh.CMenuToggleText:SetVisible(true)
		else
			cbhValues.cmenu = false
			cbh.CMenuToggleText:SetVisible(false)
		end
	end

	cbh.CMenuToggleText:SetPoint("TOPLEFT", cbh.CMenuToggle, "TOPLEFT", 15, 0)
	cbh.CMenuToggleText:SetWidth(150)
	cbh.CMenuToggleText:SetHeight(20)
	cbh.CMenuToggleText:SetLayer(2)
	-- cbh.CMenuToggleText:SetBackgroundColor(1,0,0,.25)

	cbh.CMenuToggleText:EventAttach(Event.UI.Input.Mouse.Cursor.In, function(self, h)
		cbh.GenericTooltip:Show(cbh.CMenuToggle, "WARNING: Enabling context menus will disable Right Click binding!", "BOTTOMLEFT")
	end, "Event.UI.Input.Mouse.Cursor.In")

	cbh.CMenuToggleText:EventAttach(Event.UI.Input.Mouse.Cursor.Out, function(self, h)
		cbh.GenericTooltip:Hide(cbh.CMenuToggle)
	end, "Event.UI.Input.Mouse.Cursor.Out")


	-- Warning text for CMenu option
	-- cbh.CMenuToggleText:SetPoint("TOPLEFT", cbh.CMenuToggle, "BOTTOMLEFT", 0, 0)
	-- cbh.CMenuToggleText:SetFontSize(15)
	-- cbh.CMenuToggleText:SetFontColor(1, 0, 0)
	-- cbh.CMenuToggleText:SetWordwrap(true)
	-- cbh.CMenuToggleText:SetWidth(250)
	-- cbh.CMenuToggleText:SetText("WARNING: Enabling context menus will disable Right Click binding!")
	-- cbh.CMenuToggleText:SetVisible(cbhValues.cmenu == true)



	-- STATUS TEXT SETTINGS
	cbh.StatusLocationText:SetPoint("TOPLEFT", cbh.CMenuToggle, "TOPLEFT", 0, 30)
	cbh.StatusLocationText:SetFontSize(14)
	cbh.StatusLocationText:SetText("Status Location/Size")
	cbh.StatusFontSizer:SetPoint("TOPLEFT", cbh.StatusLocationText, "TOPLEFT", 0, 20)
	cbh.StatusFontSizer:SetRange(0, 24)
	cbh.StatusFontSizer:SetWidth(125)
	cbh.StatusFontSizer:SetPosition(cbhValues.statussize)
	function cbh.StatusFontSizer.Event.SliderChange()
		cbhValues.statussize = (cbh.StatusFontSizer:GetPosition())
		for i = 1, 20 do
			cbh.groupStatus[i]:SetFontSize(cbhValues.statussize)
		end
	end

	cbh.StatusLocation:SetPoint("TOPLEFT", cbh.StatusFontSizer, "TOPRIGHT", 10, 0)
	cbh.StatusLocation:SetLayer(5)
	cbh.StatusLocation:SetFontSize(14)
	cbh.StatusLocation:SetItems(cbh.SetPoint)
	cbh.StatusLocation:SetSelectedItem(cbhValues.statussetpoint, silent)
	-- cbh.StatusLocation:ResizeToFit()
	cbh.StatusLocation:SetWidth(125)
	cbh.StatusLocation.Event.ItemSelect = function(view, item)
		cbhValues.statussetpoint = item
		cbh.StatusLocation:SetWidth(125)
		-- cbh.CreateGroupFrames()
		for groupnum = 1,20 do
			cbh.groupStatus[groupnum]:ClearAll()
			cbh.groupStatus[groupnum]:SetPoint(cbhValues.statussetpoint, cbh.groupBase[groupnum], cbhValues.statussetpoint, 0, 0)
		end
	end


	cbh.StatusDisplayText:SetPoint("TOPLEFT", cbh.StatusFontSizer, "TOPLEFT", 0, 30)
	cbh.StatusDisplayText:SetFontSize(14)
	cbh.StatusDisplayText:SetText("Display Health as: ")
	cbh.StatusDisplay:SetPoint("TOPLEFT", cbh.StatusDisplayText, "TOPRIGHT", 5, 0)
	cbh.StatusDisplay:SetLayer(5)
	cbh.StatusDisplay:SetFontSize(14)
	cbh.StatusDisplay:SetItems(cbh.StatusOptions)
	cbh.StatusDisplay:SetSelectedItem(cbhValues.statusdisplay, silent)
	cbh.StatusDisplay:ResizeToFit()
	cbh.StatusDisplay.Event.ItemSelect = function(view, item)
		cbhValues.statusdisplay = item
		cbh.StatusDisplay:ResizeToFit()
		-- cbh.CreateGroupFrames()
		for groupnum = 1,20 do
			if cbh.UnitStatus[groupnum].uid then
				local tempID = {cbh.UnitStatus[groupnum].uid}
				cbh.UpdateHP(hEvent, tempID)
			end
		end
	end


	-- TOGGLES SHOWING HEALTH PERCENT ON RAID FRAMES
	cbh.HideHealthToggle:SetPoint("TOPLEFT", cbh.StatusDisplayText, "TOPLEFT", 0, 30)
	cbh.HideHealthToggle:SetFontSize(14)
	cbh.HideHealthToggle:SetLayer(1)
	cbh.HideHealthToggle:SetText("Hide health status on frames")
	cbh.HideHealthToggle:SetChecked(cbhValues.hidehealth == true)
	function cbh.HideHealthToggle.Event.CheckboxChange()
		if cbh.HideHealthToggle:GetChecked() == true then
			cbhValues.hidehealth = true
			for i = 1, 20 do
				local statusString = cbh.groupStatus[i]:GetText()
				if string.find(statusString, "Offline") == nil and string.find(statusString, "In Warfront") == nil then
					cbh.groupStatus[i]:SetText("")
				end
			end
		else
			cbhValues.hidehealth = false
			for i = 1, 20 do
				if not cbh.UnitStatus[i].offline then
					cbh.groupStatus[i]:SetText("100%")
				else cbh.groupStatus[i]:SetText("Offline") end
			end
		end
	end
end




--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
--[[												ABILITIES TAB LAYOUT]]
--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]


function cbh.AbilityOptions()
	cbh.tAbilityListScroll:SetPoint("TOPLEFT", cbh.WindowOptionsTab, "TOPLEFT", 10, 10)
	cbh.tAbilityListScroll:SetBackgroundColor(0, 0, 0, 0.65)
	cbh.tAbilityListScroll:SetWidth(225)
	cbh.tAbilityListScroll:SetHeight(600)
	cbh.tAbilityListScroll:SetLayer(5)
	cbh.tAbilityListScroll:SetVisible(false)
	cbh.tAbilityListScroll:SetScrollbarWidth(10)
	cbh.tAbilityListScroll:SetContent(cbh.tAbilityContainer)

	-- local radloc = cbh.tAbilityListScroll:GetWidth() + 90	--value to get static position for the radio elements based on the current size of the frame
	local radloc = 90	--value to get static position for the radio elements based on the current size of the frame
	local radioWidth = 125

	cbh.OptionsRadioA[1]:SetPoint("TOPLEFT", cbh.tAbilityListScroll, "TOPRIGHT", radloc, 15)
	cbh.OptionsRadioA[2]:SetPoint("TOPLEFT", cbh.tAbilityListScroll, "TOPRIGHT", radloc + radioWidth, 15)
	cbh.OptionsRadioA[3]:SetPoint("TOPLEFT", cbh.tAbilityListScroll, "TOPRIGHT", radloc + radioWidth * 2, 15)
	cbh.OptionsRadioA[4]:SetPoint("TOPLEFT", cbh.tAbilityListScroll, "TOPRIGHT", radloc - radioWidth / 2, 40)
	cbh.OptionsRadioA[5]:SetPoint("TOPLEFT", cbh.tAbilityListScroll, "TOPRIGHT", radloc + radioWidth  / 2, 40)
	cbh.OptionsRadioA[6]:SetPoint("TOPLEFT", cbh.tAbilityListScroll, "TOPRIGHT", radloc + radioWidth * 1.5, 40)
	cbh.OptionsRadioA[7]:SetPoint("TOPLEFT", cbh.tAbilityListScroll, "TOPRIGHT", radloc + radioWidth  * 2.5, 40)


	for i = 1, 7 do
		cbh.OptionsRadioA[i]:SetText(cbh.OptionsText[i])
		cbh.OptionsRadioA[i]:SetLayer(2)
		cbh.OptionsRadioA[i]:SetFontSize(16)
	end

	cbh.OptionsRadioA[1]:SetSelected(true)
	optionSelected = 1
	modSelected = 1

	function cbh.OptionsSetA.Event:RadioButtonChange()
		optionSelected = cbh.OptionsSetA:GetSelectedIndex()
		for i = 1, 4 do
			cbh.OptionsModTextInput[i]:SetText(cbhMacroButton[cbhValues.roleset][optionSelected][i])
		end
		if cbh.OptionsModTextInput[modSelected]:GetText() == "Custom Macro" then
			cbh.CustomMacroOpen:SetChecked(true)
			cbh.WindowOptionsEditor:SetVisible(true)
			cbh.tAbilityHelpText:SetVisible(false)
			cbh.OptionsCustomHelp:SetVisible(true)
			cbh.OptionsCustom:SetText(cbhMacroText[cbhValues.roleset][optionSelected])
		else
			cbh.CustomMacroOpen:SetChecked(false)
			cbh.WindowOptionsEditor:SetVisible(false)
			cbh.OptionsCustomHelp:SetVisible(false)
			cbh.tAbilityHelpText:SetVisible(true)
			-- cbh.OptionsCustom:SetText("")
		end
	end

	cbh.OptionsRadioSeperator:SetPoint("TOPLEFT", cbh.tAbilityListScroll, "TOPRIGHT", 10, 85)
	cbh.OptionsRadioSeperator:SetTexture("ClickBoxHealer", "Textures/health_1.png")
	cbh.OptionsRadioSeperator:SetBackgroundColor(0.35, 0.35, 0.35, 1)
	cbh.OptionsRadioSeperator:SetWidth(550)
	cbh.OptionsRadioSeperator:SetHeight(2)
	cbh.OptionsRadioSeperator:SetLayer(3)

	for i = 1, 4 do
		cbh.OptionsModText[i] = UI.CreateFrame("Text", "OptionsModText", cbh.WindowOptionsC)
		cbh.OptionsModTextInput[i] = UI.CreateFrame("Text", "OptionsModText", cbh.WindowOptionsC)

		cbh.OptionsModText[i]:SetPoint("TOPLEFT", cbh.tAbilityListScroll, "TOPRIGHT", 20, 100+(40 * i))
		cbh.OptionsModText[i]:SetText(cbh.OptionsText[(i + 7)])
		cbh.OptionsModText[i]:SetLayer(2)
		cbh.OptionsModText[i]:SetFontSize(16)
		cbh.OptionsModTextInput[i]:SetPoint("LEFTCENTER", cbh.OptionsModText[i], "LEFTCENTER", 80, 0)
		cbh.OptionsModTextInput[i]:SetWidth(220)
		cbh.OptionsModTextInput[i]:SetHeight(30)
		cbh.OptionsModTextInput[i]:SetLayer(2)
		cbh.OptionsModTextInput[i]:SetText(cbhMacroButton[cbhValues.roleset][optionSelected][i])
		cbh.OptionsModTextInput[i]:SetFontSize(16)
		cbh.OptionsModTextInput[i]:SetBackgroundColor(0.4, 0.4, 0.4, 1)

		cbh.OptionsModTextInput[i]:EventAttach(Event.UI.Input.Mouse.Left.Up, function(self, h)
			modtext = cbh.OptionsText[(i + 11)]
			local language = Inspect.System.Language()
			if language == "German" and modtext == "[ctrl]" then
				modtext = "[strg]"
			elseif language == "French" and modtext == "[shift]" then
				modtext = "[maj]"
			end

			if cbh.spellholding ~= nil then
				cbh.CheckifCustom()
				cbh.OptionsModTextInput[i]:SetText("cast "..modtext.." ## "..cbh.spellholding)
				cbhMacroButton[cbhValues.roleset][optionSelected][i] = "cast "..modtext.." ## "..cbh.spellholding
				cbh.ConcatMacros()
				cbh.processMacroText(cbh.UnitsTable)
				cbh.spellholding = nil
			else
				cbh.CheckifCustom()
				cbh.OptionsModTextInput[i]:SetText("target "..modtext.." ##")
				cbhMacroButton[cbhValues.roleset][optionSelected][i] = "target "..modtext.." ##"
				cbh.ConcatMacros()
				cbh.processMacroText(cbh.UnitsTable)
			end
		end, "Event.UI.Input.Mouse.Left.Up")

		cbh.OptionsModTextInput[i]:EventAttach(Event.UI.Input.Mouse.Right.Click, function(self, h)
			modtext = cbh.OptionsText[(i + 11)]
			cbh.CheckifCustom()
			cbh.OptionsModTextInput[i]:SetText("")
			cbhMacroButton[cbhValues.roleset][optionSelected][i] = ""
			cbh.ConcatMacros()
			cbh.processMacroText(cbh.UnitsTable)
		end, "Event.UI.Input.Mouse.Right.Click")
	end

	cbh.tAbilityHelpText:SetPoint("TOPLEFT", cbh.OptionsModTextInput[1], "TOPRIGHT", 20, -2)
	cbh.tAbilityHelpText:SetWidth(250)
	cbh.tAbilityHelpText:SetFontSize(15)
	cbh.tAbilityHelpText:SetLayer(3)
	cbh.tAbilityHelpText:SetWordwrap(true)
	cbh.tAbilityHelpText:SetText("Drag and drop the spell to the desired MOD key (ie. Shift, etc.) \n\nLeft-Click a binding box to set target player \n\nRight-Click box to clear current spell \n\n\n\nThe same method can be used to set HoTs to track in the corners listed below. \n\nDrag and drop a spell in the desired location. \n\nLeft-Click to set a custom spell to track at that location. \n\nRight-Click to clear current tracked spell.")


	function cbh.ConcatMacros()
		local temp = ""
		for z = 1, 4 do
			if string.len(cbhMacroButton[cbhValues.roleset][optionSelected][z]) > 1 then
				temp = temp .. cbhMacroButton[cbhValues.roleset][optionSelected][z] .. "\13"
			end
		end
		cbhMacroText[cbhValues.roleset][optionSelected] = temp
	end

	-- cbh.CustomMacroOpen = UI.CreateFrame("RiftButton", "OpenCustomBuffAdd", cbh.WindowOptionsC)
	cbh.CustomMacroOpen = UI.CreateFrame("SimpleCheckbox", "OpenCustomBuffAdd", cbh.WindowOptionsC)
	cbh.CustomMacroOpen:SetPoint("TOPLEFT", cbh.tAbilityListScroll, "TOPRIGHT", 100, 100)
	cbh.CustomMacroOpen:SetText("Enable Custom Macro")
	cbh.CustomMacroOpen:SetFontSize(14)
	function cbh.CustomMacroOpen.Event.CheckboxChange()
		if cbh.CustomMacroOpen:GetChecked() then
			cbh.WindowOptionsEditor:SetVisible(true)
			cbh.tAbilityHelpText:SetVisible(false)
			cbh.OptionsCustomHelp:SetVisible(true)
			cbh.OptionsCustom:SetText(cbhMacroText[cbhValues.roleset][optionSelected])

			-- local txt = cbhMacroText[cbhValues.roleset][optionSelected]
			-- cbh.OptionsCustom:SetText(cbhMacroText[cbhValues.roleset][optionSelected])
		else
			cbh.CustomMacroOpen:SetChecked(false)
			cbh.WindowOptionsEditor:SetVisible(false)
			cbh.OptionsCustomHelp:SetVisible(false)
			cbh.tAbilityHelpText:SetVisible(true)
			ClearKeyFocus()
		end
	end

	if cbh.OptionsModTextInput[modSelected]:GetText() == "Custom Macro" then
		cbh.CustomMacroOpen:SetChecked(true)
		cbh.WindowOptionsEditor:SetVisible(true)
		cbh.tAbilityHelpText:SetVisible(false)
		cbh.OptionsCustomHelp:SetVisible(true)
		cbh.OptionsCustom:SetText(cbhMacroText[cbhValues.roleset][optionSelected])
	else
		cbh.CustomMacroOpen:SetChecked(false)
		cbh.WindowOptionsEditor:SetVisible(false)
		cbh.OptionsCustomHelp:SetVisible(false)
		cbh.tAbilityHelpText:SetVisible(true)
		-- cbh.OptionsCustom:SetText("")
	end

	function cbh.CheckifCustom()	-- checks if currently custom macros are set. If so then clears them.
		if cbh.OptionsModTextInput[modSelected]:GetText() == "Custom Macro" then
			for z = 1, 4 do
				cbh.OptionsModTextInput[z]:SetText("")
				cbhMacroButton[cbhValues.roleset][optionSelected][z] = ""
			end
		end
	end



	-- cbh.CustomMacroOpen:EventAttach(Event.UI.Input.Mouse.Left.Down, function(self, h)
		-- cbh.WindowOptionsTab:SetVisible(false)
		-- if not cbh.WindowOptionsEditor:GetVisible() then
			-- cbh.WindowOptionsEditor:SetVisible(true)
			-- local txt = cbhMacroText[cbhValues.roleset][optionSelected]
		-- else
			-- cbh.WindowOptionsEditor:SetVisible(false)
			-- ClearKeyFocus()
		-- end
	-- end, "Event.UI.Input.Mouse.Left.Down")

	-- Custom Macro Editor
	cbh.WindowOptionsEditor:SetPoint("TOPLEFT", cbh.OptionsModTextInput[1], "TOPLEFT", 0, 0)
	-- cbh.WindowOptionsEditor:SetPoint("TOPLEFT", cbh.WindowOptions, "TOPLEFT", 20, 60)
	-- cbh.WindowOptionsEditor:SetPoint("BOTTOMRIGHT", cbh.WindowOptions, "BOTTOMRIGHT", -20, -20)
	-- cbh.WindowOptionsEditor:SetBackgroundColor(0, 0, 0, 1)
	cbh.WindowOptionsEditor:SetLayer(3)

	cbh.OptionsCustom:SetPoint("TOPLEFT", cbh.WindowOptionsEditor, "TOPLEFT", 0, 0)
	-- cbh.OptionsCustom:SetPoint("TOPLEFT", cbh.WindowOptionsEditor, "TOPLEFT", 280, 20)
	cbh.OptionsCustom:SetWidth(225)
	cbh.OptionsCustom:SetHeight(150)
	cbh.OptionsCustom:SetLayer(3)
	cbh.OptionsCustom:SetBackgroundColor(0.25,0.25,.25,1)

	cbh.OptionsCustomHelp:SetPoint("TOPLEFT", cbh.OptionsModTextInput[1], "TOPRIGHT", 20, -20)
	-- cbh.OptionsCustomHelp:SetBackgroundColor(0, 0, 0, 1)
	cbh.OptionsCustomHelp:SetFontSize(16)
	cbh.OptionsCustomHelp:SetWidth(270)
	-- cbh.OptionsCustomHelp:SetHeight(235)
	cbh.OptionsCustomHelp:SetLayer(3)
	cbh.OptionsCustomHelp:SetWordwrap(true)
	cbh.OptionsCustomHelp:SetText(cbh.OptionsCustomHelpText)

	cbh.CustomMacroCancel:SetPoint("TOPLEFT", cbh.OptionsCustom, "BOTTOMLEFT", 0, 0)
	cbh.CustomMacroCancel:SetLayer(3)
	cbh.CustomMacroCancel:SetWidth(115)
	cbh.CustomMacroCancel:SetText("Cancel")

	cbh.OptionsCustomButton:SetPoint("TOPLEFT", cbh.CustomMacroCancel, "TOPRIGHT", 2, 0)
	cbh.OptionsCustomButton:SetLayer(3)
	cbh.OptionsCustomButton:SetWidth(115)
	cbh.OptionsCustomButton:SetText("Save Macro")

	function cbh.OptionsCustom.Event:KeyDown(button)
		-- local code = string.byte(button)
		local txt = cbh.OptionsCustom:GetText()
		local pos = cbh.OptionsCustom:GetCursor()
		-- split txt into two by pos
		local txtPre = string.sub(txt, 0, pos)
		local txtPost = string.sub(txt, pos+1)
		cbh.OptionsCustom:SetKeyFocus(true)
		-- if tonumber(code) == 13 then
		if button == "Return" then
			cbh.OptionsCustom:SetText(txtPre.."\n"..txtPost)
			cbh.OptionsCustom:SetSelection(pos,pos+1)
		-- elseif tonumber(code) == 9 then
		elseif button == "Tab" then
			cbh.OptionsCustom:SetText(txtPre.."\t "..txtPost)
			cbh.OptionsCustom:SetSelection(pos+1,pos+2)
		end
		_, count = string.gsub(cbh.OptionsCustom:GetText(), "\r", "\r")
		local t = cbh.OptionsCustom:GetText()
		cbh.OptionsCustom:SetHeight(math.max(14*(count), 150))
	end

	-- function cbh.OptionsCustomButton.Event.LeftPress()
	cbh.OptionsCustomButton:EventAttach(Event.UI.Input.Mouse.Left.Down, function(self, h)
		cbhMacroText[cbhValues.roleset][optionSelected] = cbh.OptionsCustom:GetText()
		for i = 1, 4 do
			cbh.OptionsModTextInput[i]:SetText("Custom Macro")
			cbhMacroButton[cbhValues.roleset][optionSelected][i] = "Custom Macro"
		end
		-- cbh.WindowOptionsTab:SetVisible(true)
		-- cbh.WindowOptionsEditor:SetVisible(false)
		ClearKeyFocus()
		cbh.processMacroText(cbh.UnitsTable)
	end, "Event.UI.Input.Mouse.Left.Down")

	cbh.CustomMacroCancel:EventAttach(Event.UI.Input.Mouse.Left.Down, function(self, h)
		ClearKeyFocus()
		cbh.OptionsCustom:SetText(cbhMacroText[cbhValues.roleset][optionSelected])
		-- cbh.WindowOptionsEditor:SetVisible(false)
		-- cbh.WindowOptionsTab:SetVisible(true)
	end, "Event.UI.Input.Mouse.Left.Down")
end


function cbh.AbilityListUpdate()
	-- Recreate tables here due to nil'ing them on role changes
	cbh.tAbilityIcons = {}
	cbh.tAbilityIconsText = {}
	cbh.tAbilityIconsCopy = {}

	cbh.AbilityList = {}
	cbh.SortAbilityList = {}

	local list = cbh.abilList()
	local details = cbh.abilDetail(list)

	for k, a in pairs(details) do
		if cbh.AbilityList[a.name] then
		elseif a.passive then
		elseif a.racial then
		elseif a.continuous then
		elseif string.find(a.name, "Resurrection") ~= nil then
			table.insert(cbh.SortAbilityList, a.name)
			cbh.AbilityList[a.name] = a.icon
		elseif a.castingTime and a.castingTime >= 5 then
		elseif string.find(a.name, "Augmentation") ~= nil then
		elseif string.find(a.name, "Patron's") ~= nil then
		elseif string.find(a.name, "Track") ~= nil then
		elseif string.find(a.name, "Summon") ~= nil then
		elseif string.find(a.name, "Role") ~= nil then
		elseif string.find(a.name, "Lure") ~= nil then
		elseif string.find(a.name, "Toggle") ~= nil then
		elseif string.find(a.name, "Wardstone") ~= nil then
		elseif string.find(a.name, "Salvage") ~= nil then
		else
			table.insert(cbh.SortAbilityList, a.name)
			cbh.AbilityList[a.name] = a.icon
		end
	end
	table.sort(cbh.SortAbilityList)

	Command.System.Watchdog.Quiet()
	cbh.CreateAbilities()
end


function cbh.CreateAbilities(adetails)
	local abilitycount = 0
	for k, v in pairs(cbh.SortAbilityList) do
		local aname = v
		local aicon = cbh.AbilityList[v]

		if cbh.tAbilityIcons[aname] == nil then
			cbh.tAbilityIcons[aname] = UI.CreateFrame("Texture", "tAbilityIcons", cbh.tAbilityContainer)
			cbh.tAbilityIconsText[aname] = UI.CreateFrame("Text", "tAbilityIconsText", cbh.tAbilityIcons[aname])
			cbh.tAbilityIcons[aname]:SetPoint("TOPLEFT", cbh.tAbilityContainer, "TOPLEFT", 0, abilitycount*32)
			cbh.tAbilityIconsText[aname]:SetPoint("LEFTCENTER", cbh.tAbilityIcons[aname], "RIGHTCENTER", 0, 0)
		end

		cbh.tAbilityIcons[aname]:SetVisible(true)
		cbh.tAbilityIconsText[aname]:SetVisible(true)

		if string.len(aname) > 15 then
			tname = string.sub(aname, 1, 15)
			cbh.tAbilityIconsText[aname]:SetText(tname.."...")
		else
			cbh.tAbilityIconsText[aname]:SetText(aname)
		end
		cbh.tAbilityIconsText[aname]:SetFontSize(16)
		cbh.tAbilityIconsText[aname]:SetLayer(5)
		cbh.tAbilityIcons[aname]:SetTexture("Rift", aicon)
		cbh.tAbilityIcons[aname]:SetWidth(24)
		cbh.tAbilityIcons[aname]:SetHeight(24)
		cbh.tAbilityIcons[aname]:SetLayer(5)

		-- Left Mouse down to pick up a spell
		cbh.tAbilityIcons[aname]:EventAttach(Event.UI.Input.Mouse.Left.Down, function(self, h)
			cbh.IconDown(self, aname, aicon)
		end, "Event.UI.Input.Mouse.Left.Down")

		-- Left Mouse down + moving to drag around
		cbh.tAbilityIcons[aname]:EventAttach(Event.UI.Input.Mouse.Cursor.Move, function(self, h)
			cbh.IconDrag(self, aname, aicon)
		end, "Event.UI.Input.Mouse.Cursor.Move")

		-- LEFT MOUSE UP to release the spell and either dump it or bind if in proper location
		cbh.tAbilityIcons[aname]:EventAttach(Event.UI.Input.Mouse.Left.Up, function(self, h)
			cbh.IconUp(self, aname, aicon)
		end, "Event.UI.Input.Mouse.Left.Up")

		cbh.tAbilityIcons[aname]:EventAttach(Event.UI.Input.Mouse.Left.Upoutside, function(self, h)
			cbh.IconUp(self, aname, aicon)
		end, "Event.UI.Input.Mouse.Left.Upoutside")


		-- LEFT MOUSE ACTIONS for IconText
		cbh.tAbilityIconsText[aname]:EventAttach(Event.UI.Input.Mouse.Left.Down, function(self, h)
			cbh.IconDown(self, aname, aicon)
		end, "Event.UI.Input.Mouse.Left.Down")

		cbh.tAbilityIconsText[aname]:EventAttach(Event.UI.Input.Mouse.Cursor.Move, function(self, h)
			cbh.IconDrag(self, aname, aicon)
		end, "Event.UI.Input.Mouse.Cursor.Move")

		cbh.tAbilityIconsText[aname]:EventAttach(Event.UI.Input.Mouse.Left.Up, function(self, h)
			cbh.IconUp(self, aname, aicon)
		end, "Event.UI.Input.Mouse.Left.Up")

		cbh.tAbilityIconsText[aname]:EventAttach(Event.UI.Input.Mouse.Left.Upoutside, function(self, h)
			cbh.IconUp(self, aname, aicon)
		end, "Event.UI.Input.Mouse.Left.Upoutside")


		-- cbh.tAbilityIconsText[aname]:EventAttach(Event.UI.Input.Mouse.Cursor.In, function(self, h)
			-- cbh.tAbilityListScrollTip:Show(cbh.tAbilityIconsText[aname], aname, "BOTTOMLEFT")
		-- end, "Event.UI.Input.Mouse.Cursor.In")

		-- cbh.tAbilityIconsText[aname]:EventAttach(Event.UI.Input.Mouse.Cursor.Out, function(self, h)
			-- cbh.tAbilityListScrollTip:Hide(cbh.tAbilityIconsText[aname])
		-- end, "Event.UI.Input.Mouse.Cursor.In")

		cbh.tAbilityIconsText[aname]:EventAttach(Event.UI.Input.Mouse.Cursor.In, function(self, h)
			cbh.GenericTooltip:Show(cbh.tAbilityIconsText[aname], aname, "BOTTOMLEFT")
		end, "Event.UI.Input.Mouse.Cursor.In")

		cbh.tAbilityIconsText[aname]:EventAttach(Event.UI.Input.Mouse.Cursor.Out, function(self, h)
			cbh.GenericTooltip:Hide(cbh.tAbilityIconsText[aname])
		end, "Event.UI.Input.Mouse.Cursor.In")

		abilitycount = k
	end
	cbh.tAbilityContainer:SetHeight(abilitycount*32)
end

function cbh.IconDown(self, aname, aicon)
	if cbh.tAbilityIconsCopy[aname] == nil then
		cbh.tAbilityIconsCopy[aname] = UI.CreateFrame("Texture", "tAbilityIcons", cbh.WindowOptionsTab)
		cbh.tAbilityIconsCopy[aname]:SetTexture("Rift", aicon)
		cbh.tAbilityIconsCopy[aname]:SetLayer(6)
	end
	cbh.spellholding = aname
	self.mDown = true
	local m = Inspect.Mouse()
	cbh.tAbilityIconsCopy[aname]:SetPoint("TOPLEFT", UIParent, "TOPLEFT", m.x-12, m.y-12)
end

function cbh.IconDrag(self, aname, aicon)
	if self.mDown then
		local m = Inspect.Mouse()
		cbh.tAbilityIconsCopy[aname]:SetPoint("TOPLEFT", UIParent, "TOPLEFT", m.x-12, m.y-12)
	end
end

function cbh.IconUp(self, aname, aicon)
	if cbh.spellholding then
		if cbh.tAbilityIconsCopy[aname] then
			cbh.tAbilityIconsCopy[aname]:ClearAll()
		end
		cbh.tAbilityIconsCopy[aname]:SetVisible(false)
		cbh.tAbilityIconsCopy[aname] = nil
		self.mDown = false
	end
end


context = UI.CreateContext("Fluff Context")
focushack = UI.CreateFrame("RiftTextfield", "focus hack", context)
focushack:SetVisible(false)

function ClearKeyFocus()
	focushack:SetKeyFocus(true)
	focushack:SetKeyFocus(false)
end


-- I believe this stuff can be removed
 --explode(seperator, string)
-- function explode(d,p)
	-- local t, ll
	-- t={}
	-- ll=0
	-- if(#p == 1) then return {p} end
	-- while true do
		-- l=string.find(p,d,ll,true) -- find the next d in the string
		-- if l~=nil then -- if "not not" found then..
			-- table.insert(t, string.sub(p,ll,l-1)) -- Save it in our array.
			-- ll=l+1 -- save just after where we found it for searching next time.
		-- else
			-- table.insert(t, string.sub(p,ll)) -- Save what's left in our array.
			-- break -- Break at end, as it should be, according to the lua manual.
		-- end
    -- end
	-- return t
-- end

-- function same(a, b)
	-- if #a ~= #b then return false
	-- else
		-- for i=1, #a do
			-- if a[i] ~= b[i] then return false end
		-- end
		-- return true
	-- end
-- end




--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
--[[														BUFF TAB LAYOUT]]
--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]

function cbh.BuffOptionsTab()
	for i = 1, 9 do
		-- CREATES TEXT TO THE LEFT OF THE TEXT FIELDS
		cbh.BuffOptions[i] = UI.CreateFrame("Text", "BuffOptions", cbh.WindowOptionsD)
		cbh.BuffOptions[i]:SetPoint("BOTTOMLEFT", cbh.tAbilityListScroll, "BOTTOMRIGHT", 20, -350+(i*40))
		cbh.BuffOptions[i]:SetText(cbh.SetPoint[i])
		cbh.BuffOptions[i]:SetLayer(3)
		cbh.BuffOptions[i]:SetFontSize(16)

		-- CREATES TEXT FIELDS TO DISPLAY SPELLS WHEN SET
		cbh.BuffTextDisplay[i] = UI.CreateFrame("Text", "BuffOptionsSelText", cbh.WindowOptionsD)
		cbh.BuffTextDisplay[i]:SetPoint("LEFTCENTER", cbh.BuffOptions[i], "LEFTCENTER", 150, 0)
		cbh.BuffTextDisplay[i]:SetWidth(200)
		cbh.BuffTextDisplay[i]:SetHeight(30)
		cbh.BuffTextDisplay[i]:SetLayer(3)
		cbh.BuffTextDisplay[i]:SetText(cbhBuffListA[cbhValues.roleset][i])
		cbh.BuffTextDisplay[i]:SetFontSize(16)
		cbh.BuffTextDisplay[i]:SetBackgroundColor(0.4, 0.4, 0.4, 1)

		cbh.BuffTextDisplay[i]:EventAttach(Event.UI.Input.Mouse.Left.Down, function(self, h)
			cbh.bufftrackloc = i
			cbh.CustomBuff:SetVisible(true)
			cbh.CustomBuff:SetLayer(5)
			cbh.CustomBuffLocText:SetText(cbhBuffListA[cbhValues.roleset][i])
			cbh.CustomBuffAdd:SetText(cbhBuffListA[cbhValues.roleset][i])
			cbh.CustomBuffAdd:SetKeyFocus(true)
		end, "Event.UI.Input.Mouse.Left.Down")

		cbh.BuffTextDisplay[i]:EventAttach(Event.UI.Input.Mouse.Left.Up, function(self, h)
			if cbh.spellholding then
				cbh.BuffTextDisplay[i]:SetText(cbh.spellholding)
				cbhBuffListA[cbhValues.roleset][i] = cbh.spellholding
				cbh.spellholding = nil
			end
		end, "Event.UI.Input.Mouse.Left.Up")

		cbh.BuffTextDisplay[i]:EventAttach(Event.UI.Input.Mouse.Right.Click, function(self, h)
			cbh.BuffTextDisplay[i]:SetText("")
			cbhBuffListA[cbhValues.roleset][i] = ""
		end, "Event.UI.Input.Mouse.Right.Click")
	end

	cbh.CustomBuff:SetPoint("TOPLEFT", cbh.BuffTextDisplay[1], "TOPRIGHT", -50, 10)
	cbh.CustomBuff:SetWidth(270)
	cbh.CustomBuff:SetHeight(100)
	cbh.CustomBuff:SetVisible(false)
	cbh.CustomBuff:SetBackgroundColor(.1, .1, .1, 1)
	cbh.CustomBuff:SetLayer(3)

	cbh.CustomBuffLocText:SetPoint("TOPLEFT", cbh.CustomBuff, "TOPLEFT", 4, 4)
	cbh.CustomBuffLocText:SetHeight(18)

	cbh.CustomBuffAdd:SetPoint("TOPLEFT", cbh.CustomBuffLocText, "BOTTOMLEFT", 0, 4)
	cbh.CustomBuffAdd:SetWidth(262)
	cbh.CustomBuffAdd:SetHeight(30)
	cbh.CustomBuffAdd:SetLayer(3)
	cbh.CustomBuffAdd:SetText("")
	cbh.CustomBuffAdd:SetBackgroundColor(0,1,1,.5)

	cbh.CustomBuffAddButton:SetPoint("BOTTOMLEFT", cbh.CustomBuff, "BOTTOMLEFT", 0, -4)
	cbh.CustomBuffAddButton:SetLayer(3)
	cbh.CustomBuffAddButton:SetText("Accept")

	cbh.CustomBuffCanButton:SetPoint("TOPLEFT", cbh.CustomBuffAddButton, "TOPRIGHT", 0, 0)
	cbh.CustomBuffCanButton:SetLayer(3)
	cbh.CustomBuffCanButton:SetText("Cancel")


	-- function cbh.CustomBuffAddButton.Event.LeftPress()
	cbh.CustomBuffAddButton:EventAttach(Event.UI.Input.Mouse.Left.Click, function(self, h)
		local bufftoadd = cbh.CustomBuffAdd:GetText()
		local buffloc = cbh.bufftrackloc
		print("Custom spell "..bufftoadd.." selected and configured")
		cbh.BuffTextDisplay[buffloc]:SetText(bufftoadd)
		cbhBuffListA[cbhValues.roleset][buffloc] = bufftoadd
		cbh.CustomBuff:SetVisible(false)
		cbh.WindowOptionsTab:SetVisible(true)
		ClearKeyFocus()
		cbh.bufftrackloc = nil
	end, "Event.UI.Input.Mouse.Left.Click")

	-- function cbh.CustomBuffCanButton.Event.LeftPress()
	cbh.CustomBuffCanButton:EventAttach(Event.UI.Input.Mouse.Left.Click, function(self, h)
		cbh.CustomBuff:SetVisible(false)
		cbh.WindowOptionsTab:SetVisible(true)
		ClearKeyFocus()
		cbh.bufftrackloc = nil
	end, "Event.UI.Input.Mouse.Left.Click")


	-- BUFF CUSTOM COLOR OBJECTS
	cbh.BuffColorText:SetPoint("TOPLEFT", cbh.tAbilityListScroll, "TOPRIGHT", 20, 0)
	cbh.BuffColorText:SetFontSize(14)
	cbh.BuffColorText:SetText("Set Custom Buff Color")

	cbh.BuffColorList:SetPoint("TOPLEFT", cbh.BuffColorText, "BOTTOMLEFT", 0, 0)
	cbh.BuffColorList:SetWidth(150)
	cbh.BuffColorList:SetHeight(150)
	cbh.BuffColorList:SetBorder(1, 1, 1, 1, 0)
	cbh.BuffColorList:SetLayer(1)

	if not cbhValues.buffwarncolor then
		cbh.BuffColorList:SetItems(cbh.BuffOptionsText)
	else
		cbh.BuffColorList:SetItems(cbh.BuffWarnColorText)
	end
	cbh.BuffColorList:GetItems()
	cbh.BuffColorList:SetFontSize(14)
	cbh.BuffColorList:SetSelectedIndex(1)

	-- RED
	cbh.BuffColorR:SetPoint("TOPLEFT", cbh.BuffColorList, "BOTTOMLEFT", 0, 20)
	cbh.BuffColorR:SetWidth(150)
	cbh.BuffColorR:SetRange(0, 100)
	cbh.BuffColorR:SetPosition(math.floor((cbhColorGlobal[cbhValues.roleset][1].r * 100) + 0.5))
	-- GREEN
	cbh.BuffColorG:SetPoint("TOPLEFT", cbh.BuffColorList, "BOTTOMLEFT", 0, 50)
	cbh.BuffColorG:SetWidth(150)
	cbh.BuffColorG:SetRange(0, 100)
	cbh.BuffColorG:SetPosition(math.floor((cbhColorGlobal[cbhValues.roleset][1].g * 100) + 0.5))
	-- BLUE
	cbh.BuffColorB:SetPoint("TOPLEFT", cbh.BuffColorList, "BOTTOMLEFT", 0, 80)
	cbh.BuffColorB:SetWidth(150)
	cbh.BuffColorB:SetRange(0, 100)
	cbh.BuffColorB:SetPosition(math.floor((cbhColorGlobal[cbhValues.roleset][1].b * 100) + 0.5))

	function cbh.BuffColorR.Event.SliderChange()
		cbh.BuffColorUpdate(cbh.BuffColorList:GetSelectedIndex(), 1)
	end

	function cbh.BuffColorG.Event.SliderChange()
		cbh.BuffColorUpdate(cbh.BuffColorList:GetSelectedIndex(), 2)
	end

	function cbh.BuffColorB.Event.SliderChange()
		cbh.BuffColorUpdate(cbh.BuffColorList:GetSelectedIndex(), 3)
	end

	-- Event that is triggered when you select an option on the Buff Color list
	cbh.BuffColorList.Event.ItemSelect = function(view, item, value, index)
		if index == nil then index = 1 end
		cbh.BuffColorR:SetPosition(math.floor((cbhColorGlobal[cbhValues.roleset][index].r * 100) + 0.5))
		cbh.BuffColorG:SetPosition(math.floor((cbhColorGlobal[cbhValues.roleset][index].g * 100) + 0.5))
		cbh.BuffColorB:SetPosition(math.floor((cbhColorGlobal[cbhValues.roleset][index].b * 100) + 0.5))
	end

	function cbh.BuffColorUpdate(index, rbgNumber)
		if rbgNumber == 1 then
			cbhColorGlobal[cbhValues.roleset][index].r = cbh.BuffColorR:GetPosition() / 100
		elseif rbgNumber == 2 then
			cbhColorGlobal[cbhValues.roleset][index].g = cbh.BuffColorG:GetPosition() / 100
		elseif rbgNumber == 3 then
			cbhColorGlobal[cbhValues.roleset][index].b = cbh.BuffColorB:GetPosition() / 100
		end
		for i = 1, 20 do
			if cbhValues.buffwarncolor then
				for j = 1, 9 do
					cbh.groupHoTs[i][j]:SetBackgroundColor(cbhColorGlobal[cbhValues.roleset][1].r, cbhColorGlobal[cbhValues.roleset][1].g, cbhColorGlobal[cbhValues.roleset][1].b, 1)
				end
			else
				cbh.groupHoTs[i][index]:SetBackgroundColor(cbhColorGlobal[cbhValues.roleset][index].r, cbhColorGlobal[cbhValues.roleset][index].g, cbhColorGlobal[cbhValues.roleset][index].b, 1)
			end
		end
	end


	-- TOGGLE BUFF TRACKING -- SETUP IS IN THE BUFF MONITORING SECTION FOR NOW
	cbh.BuffListToggle:SetPoint("TOPLEFT", cbh.BuffColorList, "TOPRIGHT", 20, 0)
	cbh.BuffListToggle:SetFontSize(cbhValues.optfontsize)
	cbh.BuffListToggle:SetLayer(0)
	cbh.BuffListToggle:SetText("Track HoT Buffs")
	cbh.BuffListToggle:SetChecked(cbhValues.hotwatch == true)
	function cbh.BuffListToggle.Event.CheckboxChange()
		if cbh.BuffListToggle:GetChecked() == true then
			cbhValues.hotwatch = true
		else
			cbhValues.hotwatch = false
		end
	end

	-- cbh.BuffColorText:SetPoint("TOPLEFT", cbh.tAbilityListScroll, "TOPRIGHT", 20, 0)
	-- SET BUFF FADE/FLASH OPTION
	cbh.BuffFadeToggle:SetPoint("TOPLEFT", cbh.BuffListToggle, "TOPLEFT", 0, 30)
	cbh.BuffFadeToggle:SetFontSize(14)
	cbh.BuffFadeToggle:SetLayer(1)
	cbh.BuffFadeToggle:SetText("Fade buffs near end")
	cbh.BuffFadeToggle:SetChecked(cbhValues.bufffade == true)
	function cbh.BuffFadeToggle.Event.CheckboxChange()
		if cbh.BuffFadeToggle:GetChecked() == true then
			cbhValues.bufffade = true
			cbh.BuffFlashToggle:SetChecked(false)
		else
			cbhValues.bufffade = false
		end
	end

	cbh.BuffFlashToggle:SetPoint("TOPLEFT", cbh.BuffFadeToggle, "TOPLEFT", 0, 30)
	cbh.BuffFlashToggle:SetFontSize(14)
	cbh.BuffFlashToggle:SetLayer(1)
	cbh.BuffFlashToggle:SetText("Flash buffs near end")
	cbh.BuffFlashToggle:SetChecked(cbhValues.buffflash == true)
	function cbh.BuffFlashToggle.Event.CheckboxChange()
		if cbh.BuffFlashToggle:GetChecked() == true then
			cbhValues.buffflash = true
			cbh.BuffFadeToggle:SetChecked(false)
		else
			cbhValues.buffflash = false
		end
	end

	-- SET BUFF WARNING COLOR OPTION
	cbh.BuffWarnColorToggle:SetPoint("TOPLEFT", cbh.BuffFlashToggle, "TOPLEFT", 0, 30)
	cbh.BuffWarnColorToggle:SetFontSize(14)
	cbh.BuffWarnColorToggle:SetLayer(1)
	cbh.BuffWarnColorToggle:SetText("Use \"low duration\" colors")
	cbh.BuffWarnColorToggle:SetChecked(cbhValues.buffwarncolor == true)
	function cbh.BuffWarnColorToggle.Event.CheckboxChange()
		if cbh.BuffWarnColorToggle:GetChecked() == true then
			cbhValues.buffwarncolor = true
			cbh.BuffColorList:SetItems(cbh.BuffWarnColorText)
			cbh.BuffColorList:GetItems()
			cbhColorGlobal = cbhBuffWarnColors
			cbh.BuffColorList:SetSelectedIndex(1)
			cbh.BuffIconOption:SetChecked(false)
		else
			cbhValues.buffwarncolor = false
			cbh.BuffColorList:SetItems(cbh.BuffOptionsText)
			cbh.BuffColorList:GetItems()
			cbhColorGlobal = cbhBuffColors
			cbh.BuffColorList:SetSelectedIndex(1)
		end
	end


	-- BUFF ICON OPTIONS
	-- cbh.BuffIconOption:SetPoint("BOTTOMLEFT", cbh.tAbilityListScroll, "BOTTOMRIGHT", 20, -200)
	cbh.BuffIconOption:SetPoint("TOPLEFT", cbh.BuffWarnColorToggle, "TOPLEFT", 0, 30)
	cbh.BuffIconOption:SetFontSize(14)
	cbh.BuffIconOption:SetLayer(1)
	cbh.BuffIconOption:SetText("Show icons for tracked buffs")
	cbh.BuffIconOption:SetChecked(cbhValues.bufficons == true)
	function cbh.BuffIconOption.Event.CheckboxChange()
		if cbh.BuffIconOption:GetChecked() == true then
			cbhValues.bufficons = true
			cbh.BuffWarnColorToggle:SetChecked(false)
		else
			cbhValues.bufficons = false
		end
	end


	-- SET BUFF HOT ICON SIZE
	cbh.BuffSizeText:SetPoint("TOPLEFT", cbh.BuffIconOption, "TOPLEFT", 0, 40)
	cbh.BuffSizeText:SetFontSize(14)
	cbh.BuffSizeText:SetText("Set buff watch size")
	cbh.BuffSize:SetPoint("TOPLEFT", cbh.BuffSizeText, "TOPLEFT", 0, 20)
	cbh.BuffSize:SetWidth(180)
	cbh.BuffSize:SetRange(4, 32)
	cbh.BuffSize:SetPosition(cbhValues.hotsize)
	function cbh.BuffSize.Event.SliderChange()
		cbhValues.hotsize = cbh.BuffSize:GetPosition()
		cbh.CreateGroupFrames()
	end
end




--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
--[[										DEBUFF SETTINGS LAYOUT]]
--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]

function cbh.DebuffOptionsTab()
	-- TOGGLE DEBUFF TRACKING
	cbh.DebuffListToggle:SetPoint("TOPLEFT", cbh.WindowOptionsD, "TOPLEFT", 630, 28)
	cbh.DebuffListToggle:SetFontSize(14)
	cbh.DebuffListToggle:SetLayer(1)
	cbh.DebuffListToggle:SetText("Track Debuffs")
	cbh.DebuffListToggle:SetChecked(cbhValues.debuffwatch == true)
	function cbh.DebuffListToggle.Event.CheckboxChange()
		if cbh.DebuffListToggle:GetChecked() == true then
			cbhValues.debuffwatch = true
		else
			cbhValues.debuffwatch = false
		end
	end

	-- TOGGLE COLORING THE WHOLE FRAME WHEN DEBUFFED	**THIS NOT BEING ON ALSO REQUIRES HEALTH PERCENTS TO BE SHOWN
	cbh.DebuffColorWholeToggle:SetPoint("TOPLEFT", cbh.DebuffListToggle, "TOPLEFT", 0, 30)
	cbh.DebuffColorWholeToggle:SetFontSize(14)
	cbh.DebuffColorWholeToggle:SetLayer(1)
	cbh.DebuffColorWholeToggle:SetText("Color whole frame debuffed")
	cbh.DebuffColorWholeToggle:SetChecked(cbhValues.debuffcolorwhole == true)
	function cbh.DebuffColorWholeToggle.Event.CheckboxChange()
		if cbh.DebuffColorWholeToggle:GetChecked() == true then
			cbhValues.debuffcolorwhole = true
		else
			cbhValues.debuffcolorwhole = false
		end
	end


	-- CREATES THE DEBUFF WHITELIST ENTRIES
	cbh.DeBuffWListText:SetPoint("TOPLEFT", cbh.WindowOptionsD, "TOPLEFT", 630, 100)
	cbh.DeBuffWListText:SetFontSize(14)
	cbh.DeBuffWListText:SetText("DeBuff WhiteList")

	cbh.DeBuffWListFrame:SetPoint("TOPLEFT", cbh.DeBuffWListText, "BOTTOMLEFT", 0, 10)
	cbh.DeBuffWListFrame:SetWidth(200)
	cbh.DeBuffWListFrame:SetHeight(140)
	cbh.DeBuffWListFrame:SetLayer(1)
	cbh.DeBuffWListFrame:SetBorder(1, 1, 1, 1, 1)

	cbh.DeBuffWListAddSpell:SetPoint("TOPLEFT", cbh.DeBuffWListFrame, "BOTTOMLEFT", 0, 10)
	cbh.DeBuffWListAddSpell:SetWidth(200)
	cbh.DeBuffWListAddSpell:SetBackgroundColor(.2,.2,.2,1)
	cbh.DeBuffWListAddSpell:SetLayer(1)

	cbh.DeBuffWListAddButton:SetPoint("TOPLEFT", cbh.DeBuffWListAddSpell, "BOTTOMLEFT", 0, 10)
	cbh.DeBuffWListAddButton:SetText("Add Spell")
	cbh.DeBuffWListAddButton:SetLayer(1)
	cbh.DeBuffWListAddButton:SetWidth(100)

	cbh.DeBuffWListRemButton:SetPoint("TOPLEFT", cbh.DeBuffWListAddButton, "TOPRIGHT", 0, 0)
	cbh.DeBuffWListRemButton:SetText("Remove Spell")
	cbh.DeBuffWListRemButton:SetLayer(1)
	cbh.DeBuffWListRemButton:SetWidth(120)

	cbh.DeBuffWList:SetItems(cbhDeBuffWList)
	cbh.DeBuffWList:GetItems()
	cbh.DeBuffWList:SetFontSize(14)
	cbh.DeBuffWListFrame:SetContent(cbh.DeBuffWList)

	function cbh.DeBuffWListAddButton.Event.LeftPress()
		local addspell = cbh.DeBuffWListAddSpell:GetText()
		if string.len(addspell) > 1 then
			table.insert(cbhDeBuffWList, addspell)
		end
		cbh.DeBuffWList:SetItems(cbhDeBuffWList)
		cbh.DeBuffWList:GetItems()
		cbh.DeBuffWListAddSpell:SetText("")
		ClearKeyFocus()
	end

	function cbh.DeBuffWListRemButton.Event.LeftPress()
		if cbh.DeBuffWList:GetSelectedItem() == nil then print ("Select a Spell from list to Remove") end
		if cbh.DeBuffWList:GetSelectedItem() ~= nil then
		table.remove(cbhDeBuffWList, cbh.DeBuffWList:GetSelectedIndex())
		end
		cbh.DeBuffWList:SetItems(cbhDeBuffWList)
		cbh.DeBuffWList:GetItems()
	end



	-- CREATES THE DEBUFF BLACKLIST ENTRIES
	cbh.DeBuffBListText:SetPoint("TOPLEFT", cbh.WindowOptionsD, "TOPLEFT", 630, 375)
	cbh.DeBuffBListText:SetFontSize(14)
	cbh.DeBuffBListText:SetText("DeBuff BlackList")
	-- cbh.DeBuffBListText:SetVisible(false)

	cbh.DeBuffBListFrame:SetPoint("TOPLEFT", cbh.DeBuffBListText, "BOTTOMLEFT", 0, 10)
	cbh.DeBuffBListFrame:SetWidth(200)
	cbh.DeBuffBListFrame:SetHeight(140)
	cbh.DeBuffBListFrame:SetLayer(1)
	cbh.DeBuffBListFrame:SetBorder(1, 1, 1, 1, 1)

	cbh.DeBuffBListAddSpell:SetPoint("TOPLEFT", cbh.DeBuffBListFrame, "BOTTOMLEFT", 0, 10)
	cbh.DeBuffBListAddSpell:SetWidth(200)
	cbh.DeBuffBListAddSpell:SetBackgroundColor(.2,.2,.2,1)
	cbh.DeBuffBListAddSpell:SetLayer(1)

	cbh.DeBuffBListAddButton:SetPoint("TOPLEFT", cbh.DeBuffBListAddSpell, "BOTTOMLEFT", 0, 10)
	cbh.DeBuffBListAddButton:SetText("Add Spell")
	cbh.DeBuffBListAddButton:SetLayer(1)
	cbh.DeBuffBListAddButton:SetWidth(100)

	cbh.DeBuffBListRemButton:SetPoint("TOPLEFT", cbh.DeBuffBListAddButton, "TOPRIGHT", 0, 0)
	cbh.DeBuffBListRemButton:SetText("Remove Spell")
	cbh.DeBuffBListRemButton:SetLayer(1)
	cbh.DeBuffBListRemButton:SetWidth(120)

	cbh.DeBuffBList:SetItems(cbhDeBuffBList)
	cbh.DeBuffBList:GetItems()
	cbh.DeBuffBList:SetFontSize(14)
	cbh.DeBuffBListFrame:SetContent(cbh.DeBuffBList)

	function cbh.DeBuffBListAddButton.Event.LeftPress()
		local addspell = cbh.DeBuffBListAddSpell:GetText()
		if string.len(addspell) > 1 then
			table.insert(cbhDeBuffBList, addspell)
		end
		cbh.DeBuffBList:SetItems(cbhDeBuffBList)
		cbh.DeBuffBList:GetItems()
		cbh.DeBuffBListAddSpell:SetText("")
		ClearKeyFocus()
	end

	function cbh.DeBuffBListRemButton.Event.LeftPress()
		if cbh.DeBuffBList:GetSelectedItem() == nil then print("Select a Spell from list to Remove") end
		if cbh.DeBuffBList:GetSelectedItem() ~= nil then
		table.remove(cbhDeBuffBList, cbh.DeBuffBList:GetSelectedIndex())
		end
		cbh.DeBuffBList:SetItems(cbhDeBuffBList)
		cbh.DeBuffBList:GetItems()
	end
end




--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
--[[												CUSTOM PROFILE TAB]]
--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]

function cbh.ProfileOptions()
	cbh.newLayout = false

	-- Backdrop for options
	cbh.LayoutEntryBackground:SetPoint("TOPLEFT", cbh.WindowOptionsE, "TOPLEFT", 30, 30)
	cbh.LayoutEntryBackground:SetBackgroundColor(0.25, 0.25, 0.25, 0.3)
	cbh.LayoutEntryBackground:SetWidth(500)
	cbh.LayoutEntryBackground:SetHeight(130)
	cbh.LayoutEntryBackground:SetLayer(1)

	-- Text for save entry box
	cbh.LayoutEntryText:SetPoint("TOPLEFT", cbh.LayoutEntryBackground, "TOPLEFT", 10, 10)
	cbh.LayoutEntryText:SetFontSize(16)
	cbh.LayoutEntryText:SetLayer(2)
	cbh.LayoutEntryText:SetText("Enter name to save layout:   ")

	-- Text field for saving custom layouts
	cbh.LayoutEntry:SetPoint("TOPLEFT", cbh.LayoutEntryBackground, "TOPLEFT", 10, 50)
	cbh.LayoutEntry:SetWidth(200)
	cbh.LayoutEntry:SetHeight(25)
	cbh.LayoutEntry:SetLayer(2)
	cbh.LayoutEntry:SetText("")
	cbh.LayoutEntry:SetBackgroundColor(0, 0, 0, 1)

	-- Text for drop down list
	cbh.LayoutEntryDropText:SetPoint("TOPLEFT", cbh.LayoutEntryBackground, "TOPLEFT", 300, 10)
	cbh.LayoutEntryDropText:SetFontSize(16)
	cbh.LayoutEntryDropText:SetLayer(2)
	cbh.LayoutEntryDropText:SetText("Select a layout")

	-- Drop down list for available layouts
	cbh.LayoutEntryList:SetPoint("TOPLEFT", cbh.LayoutEntryBackground, "TOPLEFT", 300, 50)
	cbh.LayoutEntryList:SetWidth(150)
	cbh.LayoutEntryList:SetHeight(25)
	cbh.LayoutEntryList:SetLayer(3)
	cbh.LayoutEntryList:SetFontSize(14)
	cbh.getLayoutEntryList(cbhSelectedLayout)
	cbh.LayoutEntryList:ResizeToFit()

	cbh.LayoutEntryApply:SetPoint("BOTTOMLEFT", cbh.LayoutEntryBackground, "BOTTOMLEFT", 0, 0)
	cbh.LayoutEntryApply:SetText("Save Layout")
	cbh.LayoutEntryApply:SetLayer(2)

	cbh.LayoutEntryRemove:SetPoint("BOTTOMLEFT", cbh.LayoutEntryBackground, "BOTTOMLEFT", 300, 0)
	cbh.LayoutEntryRemove:SetText("Delete Layout")
	cbh.LayoutEntryRemove:SetLayer(2)

	-- Explanation text for layout options
	cbh.LayoutInfoText:SetPoint("TOPLEFT", cbh.LayoutEntryBackground, "BOTTOMLEFT", 0, 40)
	cbh.LayoutInfoText:SetFontSize(16)
	cbh.LayoutInfoText:SetText("Layouts are saved templates for most of your options.\n\nFrame locations, sizes, preferences and calling colors are all saved in each layout.\nBuff/Debuff colors options are not included in the layout and will remain saved per character.\n\nTo save your current settings into a new layout, type in a name at hit \"Save Layout.\"\nTo change layouts, use the drop-down menu to select another layout name.\nYou can delete any layout except for default by choosing it from the drop-down list and clicking \"Delete Layout.\"\n\nYou will be prompted to do a /reloadui after selecting a different layout or deleting your current layout.")
	cbh.LayoutInfoText:SetLayer(2)

	function cbh.LayoutEntryApply.Event.LeftClick()
		if cbh.LayoutEntry:GetText() ~= "" then
			cbh.newLayout = true
			local n = cbh.LayoutEntry:GetText()
			cbhSelectedLayout = n

			cbhCustomLayouts[n] = {}
			cbhCustomLayouts[n] = {
				cbhValues = {},
				cbhCallingColors = {},
				cbhGroupCHColor = {}
			}

			for k, v in pairs(cbhValues) do
				cbhCustomLayouts[n].cbhValues[k] = v
			end

			for k, v in pairs(cbhCallingColors) do
				cbhCustomLayouts[n].cbhCallingColors[k] = {}
				for i, x in pairs(v) do
					cbhCustomLayouts[n].cbhCallingColors[k][i] = x
				end
			end

			for k, v in pairs(cbhGroupCHColor) do
				cbhCustomLayouts[n].cbhGroupCHColor[k] = {}
				for i, x in pairs (v) do
					cbhCustomLayouts[n].cbhGroupCHColor[k][i] = x
				end
			end

			-- temporary substitution for cbh.loadLayout  **allowing it to be localized elsewhere
			cbhValues = cbhCustomLayouts[n].cbhValues
			cbhCallingColors = cbhCustomLayouts[n].cbhCallingColors
			cbhGroupCHColor = cbhCustomLayouts[n].cbhGroupCHColor

			cbh.getLayoutEntryList(n)
			cbh.LayoutEntry:SetText("")
			ClearKeyFocus()

			cbh.newLayout = false
			print("New layout "..n.." added and set!")
		else
			print("Please enter a name for your layout!")
		end
	end

	function cbh.LayoutEntryRemove.Event.LeftClick()
		if cbh.LayoutEntryList:GetSelectedItem() ~= "default" then
			local n = cbh.LayoutEntryList:GetSelectedItem()
			cbhSelectedLayout = "default"
			cbhCustomLayouts[n] = nil
			cbh.getLayoutEntryList("default")
			print("Layout "..n.." has been deleted. Your layout selection has been set to default.")
		else
		   print("The default layout cannot be deleted.")
		end
	end

	cbh.LayoutEntryList.Event.ItemSelect = function(view, n)
		if cbh.newLayout ~= true then
			cbhSelectedLayout = n

			cbh.Window:SetVisible(false)
			cbh.ShowConfig()
			cbh.ResetWindow()
			cbh.WindowReset:SetVisible(true)
			print("Layout "..n.." has been selected. Please do a reloadui to activate!")
		end
	end
end

-- Generates the available layout list. Passed in variable is for different cases of when this list is generated. See originating call.
function cbh.getLayoutEntryList(layout)
	addlist = nil
	addlist = {}
	for i, v in pairs(cbhCustomLayouts) do
		table.insert(addlist, ""..i)	-- Concatenated to a string incase the user saves thier entry as a number
	end
	cbh.LayoutEntryList:SetItems(addlist)
	cbh.LayoutEntryList:SetSelectedItem(layout, silent)
end