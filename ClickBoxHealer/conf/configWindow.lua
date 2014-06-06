--[[
file: optionWindow.lua
by: Solsis00
for: ClickBoxHealer

This file houses the configuration window for CBH.

**COMPLETE: Converted to local cbh table successfully.
]]--


local addon, cbh = ...

cbh.optionsloaded = false



--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--			OPTION WINDOW CREATION
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]

function cbh.ConfigCreate()
	cbh.GlobalTextures = {}
	table.insert(cbh.GlobalTextures, 1, "None")
	Command.System.Watchdog.Quiet()
	for i = 1, 43 do
		table.insert(cbh.GlobalTextures, "health_"..i..".png")
	end
	-- if cbhValues.customTextures then
		-- print("I HAVE CUSTOM TEXTURES")
	-- end
end


--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--			OPTION WINDOW SETUP
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
function cbh.CreateOptions()
	if cbhValues.isincombat then return end
	
	cbh.ConfigCreate()	--temporary as I move stuff into the proper location
	
	local loadedoptions = {}

	cbh.WindowOptions:SetPoint("TOPLEFT", cbh.Context, "TOPLEFT", UIParent:GetWidth()/2-890/2, UIParent:GetHeight()/2-700*0.5)
	cbh.WindowOptions:SetBackgroundColor(0, 0, 0, 0.5)
	cbh.WindowOptions:SetWidth(890)
	cbh.WindowOptions:SetHeight(700)
	cbh.WindowOptions:SetLayer(6)

	-- Left menu for selecting different option groups
	cbh.ConfigGroupsFrame:SetPoint("TOPRIGHT", cbh.WindowOptions, "TOPLEFT", 20, 100)
	cbh.ConfigGroupsFrame:SetBackgroundColor(0, 0, 0, 0.5)
	cbh.ConfigGroupsFrame:SetWidth(200)
	cbh.ConfigGroupsFrame:SetHeight(500)
	cbh.ConfigGroupsFrame:SetLayer(5)
	-- cbh.ConfigGroupsFrame:SetVisible(false)

	cbh.configGroups = {"General", "Player", "Target", "Raid", "Profile"}
	cbhgroupindex = 1

	cbh.ConfigGroupsList:SetPoint("TOPLEFT", cbh.ConfigGroupsFrame, "TOPLEFT", 10, 10)
	cbh.ConfigGroupsList:SetWidth(170)
	cbh.ConfigGroupsList:SetFontSize(15)
	cbh.ConfigGroupsList:SetBorder(1, 1, 1, 1, 0)
	cbh.ConfigGroupsList:SetItems(cbh.configGroups)
	cbh.ConfigGroupsList:SetSelectedIndex(1)
	
	
	-- Cancel changes
	cbh.WindowOptionsCancel:SetPoint("BOTTOMRIGHT", cbh.WindowOptions, "BOTTOMRIGHT", -125, 0)
	cbh.WindowOptionsCancel:SetText("Cancel")
	cbh.WindowOptionsCancel:SetWidth(125)
	cbh.WindowOptionsCancel:SetHeight(40)

	-- Save Changes
	cbh.WindowOptionsSave:SetPoint("BOTTOMLEFT", cbh.WindowOptionsCancel, "BOTTOMRIGHT", 0, 0)
	cbh.WindowOptionsSave:SetText("Save Colors")
	cbh.WindowOptionsSave:SetWidth(125)
	cbh.WindowOptionsSave:SetHeight(40)

	
	-- Option window tabs
	cbh.WindowOptionsTab:SetPoint("TOPLEFT", cbh.WindowOptions, "TOPLEFT", 15, 20)
	cbh.WindowOptionsTab:SetPoint("BOTTOMRIGHT", cbh.WindowOptions, "BOTTOMRIGHT", -15, -15)
	cbh.WindowOptionsTab:SetBackgroundColor(0, 0, 0, 0)
	cbh.WindowOptionsTab:SetTabContentBackgroundColor(0, 0, 0, 0.6)
	cbh.WindowOptionsTab:SetActiveTabBackgroundColor(0.1, 0.3, 0.1, 0.9)
	cbh.WindowOptionsTab:SetInactiveTabBackgroundColor(0, 0, 0, 0.75)
	cbh.WindowOptionsTab:SetActiveFontColor(0.75, 0.75, 0.75, 1)
	cbh.WindowOptionsTab:SetInactiveFontColor(0.2, 0.2, 0.2, 0.3)

	cbh.WindowOptionsTitle = UI.CreateFrame("Text", "OptTitleBar", cbh.WindowOptions)
	cbh.WindowOptionsTitle:SetPoint("CENTER", cbh.WindowOptions, "TOPCENTER", 0, 0)
	cbh.WindowOptionsTitle:SetFontSize(30)
	cbh.WindowOptionsTitle:SetText("CLICK BOX HEALER")
	cbh.WindowOptionsTitle:SetEffectGlow(cbh.TitleGlowTable)

	cbh.WindowOptionsText = UI.CreateFrame("Text", "CurrentVersion", cbh.WindowOptions)
	cbh.WindowOptionsText:SetPoint("BOTTOMLEFT", cbh.WindowOptionsTitle, "BOTTOMRIGHT", 5, 5)
	cbh.WindowOptionsText:SetFontSize(14)
	cbh.WindowOptionsText:SetLayer(3)
	cbh.WindowOptionsText:SetText("v"..cbh.adetail.toc.Version)

	cbh.BasicInfo()	-- TAB 1 frame load
	-- loadedoptions[1]=true

	--creation functions to fill the option tabs	***edit these to not load until the specific tab is clicked
	-- cbh.WindowOptionsTab.Event.TabSelect = function(view, index)
		-- if not loadedoptions[index] then
			-- if index == 2 then
				-- loadedoptions[index]=true
				cbh.FrameOptions()	-- TAB 2 frame load
			-- elseif index == 3 then
				-- loadedoptions[index]=true
				cbh.AbilityOptions()	-- Tab 3 - ability related options load
			-- elseif index == 4 then
				-- loadedoptions[index]=true
				-- cbh.BuffOptions()
				cbh.BuffOptionsTab()
				cbh.DebuffOptionsTab()
			-- elseif index == 5 then
				-- loadedoptions[index]=true
				cbh.ProfileOptions()
			-- end
		-- end

		-- if index == 3 or index == 4 then
			-- cbh.tAbilityListScroll:SetVisible(true)
		-- else
			-- cbh.tAbilityListScroll:SetVisible(false)
		-- end
	-- end
	
	-- cbh.PlayerConfigSetup()
	cbh.TargetConfigSetup()
	cbh.RaidConfigSetup()
--[[	THIS STUFF CAN BE REMOVED AT v1.9
	-- cbhCrOptBuffs()
	-- ***** SHOULD BE ABLE TO USE THIS TO PERFORM THE ABOVE COMMENT ******
	-- cbh.WindowOptionsSetTab.Event.TabSelect = function(view, index)
		-- cbh.WindowOptionsSetParent:SetParent(cbh.WindowOptionsSetFrame[index])
		-- cbhValues.roleset = index
		-- for i = 1, 4 do
			-- cbh.OptionsModTextInput[i]:SetText(cbhMacroButton[cbhValues.roleset][optionSelected][i])
		-- end
		-- cbh.AbilityList:ClearSelection()
		-- cbh.processMacroText(cbh.UnitsTable)
	-- end
]]

	-- cbh.OptionsCallingSelector.Event.ItemSelect = function(view, item, value, index)
		-- cbhclindex = index
		-- if cbhclindex == nil then cbhclindex = 1 end
		-- if index < 5 then
			-- cbh.OptionsColor1:SetText("I am a "..cbh.OptionsCallingSelector:GetSelectedItem(item))
		-- end
		-- cbh.OptionsColorSliderR:SetPosition(math.floor((cbh.TempColors[cbhclindex].r * 100) + 0.5))
		-- cbh.OptionsColorSliderG:SetPosition(math.floor((cbh.TempColors[cbhclindex].g * 100) + 0.5))
		-- cbh.OptionsColorSliderB:SetPosition(math.floor((cbh.TempColors[cbhclindex].b * 100) + 0.5))
		-- if cbhclindex == 6 or cbhclindex == 7 then
			-- cbh.OptionsColorSliderBFCA:SetVisible(true)
			-- cbh.OptionsColorSliderBFCA:SetPosition(math.floor((cbh.TempColors[cbhclindex].a * 100) + 0.5))
		-- else
			-- cbh.OptionsColorSliderBFCA:SetVisible(false)
		-- end
	-- end


	-- OPTION WINDOW CHANGIN TABS
	function cbh.WindowOptionsTab.Event.TabSelect(tab)
		atab = cbh.WindowOptionsTab:GetActiveTab()
		if atab == 3 or atab == 4 then
			cbh.tAbilityListScroll:SetVisible(true)
		else
			cbh.tAbilityListScroll:SetVisible(false)
		end
	end


	cbh.ConfigGroupsList.Event.ItemSelect = function(view, item, value, index)
		-- index (1-General, 2-Player, 3-Target, 4-Raid)
		if index == nil then index = 1 end
		if index == 1 then
			cbh.WindowOptionsTab:SetVisible(true)
			if cbhPlayerConfigSetup then cbh.PlayerConfig:SetVisible(false) end
			if cbhTargetConfigSetup then cbh.TargetConfig:SetVisible(false) end
			cbh.RaidConfig:SetVisible(false)
		elseif index == 2 then
			cbh.WindowOptionsTab:SetVisible(false)
			if not cbhPlayerConfigSetup then cbh.PlayerConfigSetup() end
			cbh.PlayerConfig:SetVisible(true)
			if cbhTargetConfigSetup then cbh.TargetConfig:SetVisible(false) end
			cbh.RaidConfig:SetVisible(false)
		elseif index == 3 then
			cbh.WindowOptionsTab:SetVisible(false)
			if cbhPlayerConfigSetup then cbh.PlayerConfig:SetVisible(false) end
			if not cbhTargetConfigSetup then cbh.TargetConfigSetup() end
			cbh.TargetConfig:SetVisible(true)
			cbh.RaidConfig:SetVisible(false)
		elseif index == 4 then
			cbh.WindowOptionsTab:SetVisible(false)
			if cbhPlayerConfigSetup then cbh.PlayerConfig:SetVisible(false) end
			if cbhTargetConfigSetup then cbh.TargetConfig:SetVisible(false) end
			cbh.RaidConfig:SetVisible(true)
		end
	end


	-- If nothing is passed to opt it will save,apply,close the window. Otherwise cancel or the x were clicked.
	function cbh.WindowOptions.CloseMe(opt)
	-- Add an additional buff list/detail check here to see if any newly tracked buffs are currently active on units. If list will provide name use it as it will be cheaper.
		if opt == nil then
			for i = 1, 8 do
				cbhCallingColors[i].r = cbh.TempColors[i].r
				cbhCallingColors[i].g = cbh.TempColors[i].g
				cbhCallingColors[i].b = cbh.TempColors[i].b
				cbhCallingColors[i].a = cbh.TempColors[i].a
			end
			for x = 1, 20 do
				cbh.groupStatus[x]:SetFontColor(cbhCallingColors[5].r, cbhCallingColors[5].g, cbhCallingColors[5].b, 1)
				cbh.groupBF[x]:SetBackgroundColor(cbhCallingColors[6].r, cbhCallingColors[6].g, cbhCallingColors[6].b, cbhCallingColors[6].a)
				cbh.groupHF[x]:SetBackgroundColor(cbhCallingColors[7].r, cbhCallingColors[7].g, cbhCallingColors[7].b, cbhCallingColors[7].a)
				cbh.groupAbsBot[x]:SetBackgroundColor(cbhCallingColors[8].r, cbhCallingColors[8].g, cbhCallingColors[8].b, cbhCallingColors[8].a)
				for i = 1, 4 do
					if cbh.UnitStatus[x].calling == cbh.Calling[i] then
						cbh.groupName[x]:SetFontColor(cbhCallingColors[i].r, cbhCallingColors[i].g, cbhCallingColors[i].b, 1)
					end
				end
				for i = 1, 9 do
					if cbh.BuffTextDisplay[i]:GetText() == "" then
						cbh.groupHoTs[x][i]:SetVisible(false)
						cbh.groupHoTicon[x][i]:SetVisible(false)
					end
				end
			end
			-- if cbhPlayerValues.enabled then cbh.PlayerFrame:SetBackgroundColor(cbhCallingColors[7].r, cbhCallingColors[7].g, cbhCallingColors[7].b, cbhCallingColors[7].a) end
			if cbhTargetValues.enabled then cbh.TargetFrame:SetBackgroundColor(cbhCallingColors[7].r, cbhCallingColors[7].g, cbhCallingColors[7].b, cbhCallingColors[7].a) end
			print("CBH configuration saved.")
		end

		for i = 1, 8 do
			cbh.TempColors[i].r = cbhCallingColors[i].r
			cbh.TempColors[i].g = cbhCallingColors[i].g
			cbh.TempColors[i].b = cbhCallingColors[i].b
			cbh.TempColors[i].a = cbhCallingColors[i].a
		end
		cbh.OptionsCallingSelector:SetSelectedIndex(1)
		cbh.OptionsColorSliderR:SetPosition(math.floor((cbh.TempColors[1].r * 100) + 0.5))
		cbh.OptionsColorSliderG:SetPosition(math.floor((cbh.TempColors[1].g * 100) + 0.5))
		cbh.OptionsColorSliderB:SetPosition(math.floor((cbh.TempColors[1].b * 100) + 0.5))

		cbh.OptionsUITexture:SetBackgroundColor(cbh.TempColors[6].r, cbh.TempColors[6].g, cbh.TempColors[6].b, cbh.TempColors[6].a)
		cbh.OptionsUITexture:SetBackgroundColor(cbh.TempColors[7].r, cbh.TempColors[7].g, cbh.TempColors[7].b, cbh.TempColors[7].a)

		
		--[[ NEW CONFIG SAVING ]]--
		--[[ XXXXXXXXXXXXXXXXXXXXXXXXXXXX ]]
		if cbhPlayerTempColors then
			for i = 1, 5 do	-- saves player frame color changes
				cbhPlayerValues["Colors"][i].r = cbhPlayerTempColors[i].r
				cbhPlayerValues["Colors"][i].g = cbhPlayerTempColors[i].g
				cbhPlayerValues["Colors"][i].b = cbhPlayerTempColors[i].b
				cbhPlayerValues["Colors"][i].a = cbhPlayerTempColors[i].a
			end
		end
		if cbhTargetTempColors then
			for i = 1, 5 do	-- saves Target frame color changes
				cbhTargetValues["Colors"][i].r = cbhTargetTempColors[i].r
				cbhTargetValues["Colors"][i].g = cbhTargetTempColors[i].g
				cbhTargetValues["Colors"][i].b = cbhTargetTempColors[i].b
				cbhTargetValues["Colors"][i].a = cbhTargetTempColors[i].a
			end
		end
		
		ClearKeyFocus()
		cbh.WindowOptions:SetVisible(false)
	end

	
	-- EVENT FOR CLOSING THE OPTION WINDOW
	cbh.WindowOptionsSave:EventAttach(Event.UI.Input.Mouse.Left.Click, function(self, h)
		cbh.WindowOptions.CloseMe()
	end, "Event.UI.Input.Mouse.Left.Click")

	cbh.WindowOptionsCancel:EventAttach(Event.UI.Input.Mouse.Left.Click, function(self, h)
		cbh.WindowOptions.CloseMe("cancel")
	end, "Event.UI.Input.Mouse.Left.Click")

	
	-- EVENTS FOR MOVING THE OPTION WINDOW
	cbh.WindowOptions:EventAttach(Event.UI.Input.Mouse.Left.Down, function(self, h)
		self.MouseDown = true
		local mouseData = Inspect.Mouse()
		self.sx = mouseData.x - cbh.WindowOptions:GetLeft()
		self.sy = mouseData.y - cbh.WindowOptions:GetTop()
	end, "Event.UI.Input.Mouse.Left.Down")

	cbh.WindowOptions:EventAttach(Event.UI.Input.Mouse.Cursor.Move, function(self, h)
		if self.MouseDown then
			local nx, ny
			local mouseData = Inspect.Mouse()
			nx = mouseData.x - self.sx
			ny = mouseData.y - self.sy
			cbh.WindowOptions:SetPoint("TOPLEFT", cbh.Context, "TOPLEFT", nx, ny)
		end
	end, "Event.UI.Input.Mouse.Cursor.Move")

	cbh.WindowOptions:EventAttach(Event.UI.Input.Mouse.Left.Up, function(self, h)
		self.MouseDown = false
	end, "Event.UI.Input.Mouse.Left.Up")

	cbh.WindowOptions:EventAttach(Event.UI.Input.Mouse.Left.Upoutside, function(self, h)
		self.MouseDown = false
	end, "Event.UI.Input.Mouse.Left.Upoutside")
end

