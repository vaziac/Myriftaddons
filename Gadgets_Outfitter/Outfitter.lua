local gadgetIndex = 0
local OutfitButtons = {}

local gadgetFactory = false
local gadgetConfig = false
local gadgetId = false
local labels = {}
local barButtons = {}
local started = false

function wykOBBHighlight(myCount)
	for ii = 1, wykkydContextCount, 1 do
		if ii == myCount then
			Wykkyd.Outfitter.Anchor[ii].highlight:SetVisible(true)
		else
			Wykkyd.Outfitter.Anchor[ii].highlight:SetVisible(false)
		end
	end
end
local function SetRootIcon(myCount, set)
	if set == nil then set = 0 end
	if set == 0 then myCount = 0 end
local img = { src = "", file = "" }
	if set ~= 0 then
		img.src = Wykkyd.Outfitter.Bbar[myCount][set].RootIconSrc
		img.file = Wykkyd.Outfitter.Bbar[myCount][set].RootIconImage
	end
	for ii = 1, wykkydContextCount, 1 do
		if ii == myCount then
			Wykkyd.Outfitter.Anchor[ii].icon:SetTexture(img.src, img.file)
			Wykkyd.Outfitter.Anchor[ii].rim:SetVisible(true)
		else
			Wykkyd.Outfitter.Anchor[ii].icon:SetTexture(
			Wykkyd.Outfitter.Anchor[ii].RootIconSrc,
			Wykkyd.Outfitter.Anchor[ii].RootIconImage
			)
			Wykkyd.Outfitter.Anchor[ii].rim:SetVisible(false)
		end
	end
end

local function prepButtonbar(myCount, targ)
	if Wykkyd.Outfitter.ContextConfig[myCount].EquipSetList == nil or Wykkyd.Outfitter.ContextConfig[myCount].EquipSetGear == nil then return end
	local iMax = 0
	local doCount = 0
	for _, v in pairs(Wykkyd.Outfitter.ContextConfig[myCount].EquipSetList) do
		if v.value > iMax then iMax = v.value end
	end
	for ii = 1, iMax, 1 do
		barButtons[ii] = false
		for _, v in pairs(Wykkyd.Outfitter.ContextConfig[myCount].EquipSetGear) do
			if v.id == ii then
				if v.makeIcon then
					doCount = doCount + 1
					barButtons[ii] = {
						icon = v.icon,
						changeRole = v.changeRole,
						id = v.id,
						karuulSet1 = v.karuulSet1,
						karuulSet2 = v.karuulSet2,
						makeIcon = v.makeIcon,
						manageKaruul = v.manageKaruul,
						name = v.name,
						targetRole = v.targetRole,
						alertCheck = v.alertCheck,
						alertText = v.alertText,
						alertChannel = v.alertChannel,
						changeWardrobe = v.changeWardrobe,
						targetWardrobe = v.targetWardrobe,
						bIcon = nil,
					}
				end
			end
		end
	end
	if doCount > 0 then
		local _buttonbarExpandDirection = Wykkyd.Outfitter.ContextConfig[myCount].buttonbarExpandDirection
		local _buttonbarIconAlpha = Wykkyd.Outfitter.ContextConfig[myCount].buttonbarIconAlpha
		local _buttonbarIconSize = Wykkyd.Outfitter.ContextConfig[myCount].buttonbarIconSize
		local _buttonbarBorderImage = Wykkyd.Outfitter.ContextConfig[myCount].buttonbarBorderImage
		local _buttonbarBorderImageSrc = Wykkyd.Outfitter.ContextConfig[myCount].buttonbarBorderImageSrc
		local _buttonBarShowLabels = Wykkyd.Outfitter.ContextConfig[myCount].checkboxLabelsEnabler
		local lastObj = nil
		local uName = wyk.UniqueName("wykButtonBar")
		local borderSize = (128 * (_buttonbarIconSize/100))*.85
		local iconSize = (96 * (_buttonbarIconSize/100))*.85
		Wykkyd.Outfitter.Bbar[myCount] = wyk.frame.CreateFrame("wykButtonBar", targ )
		local pointOne = ""
		local pointTwo = ""
		if _buttonbarExpandDirection == "LEFT" then
			pointOne = "RIGHTCENTER"
			pointTwo = "LEFTCENTER"
		elseif _buttonbarExpandDirection == "RIGHT" then
			pointOne = "LEFTCENTER"
			pointTwo = "RIGHTCENTER"
		elseif _buttonbarExpandDirection == "UP" then
			pointOne = "BOTTOMCENTER"
			pointTwo = "TOPCENTER"
		else
			pointOne = "TOPCENTER"
			pointTwo = "BOTTOMCENTER"
		end
		Wykkyd.Outfitter.Bbar[myCount]:SetHeight(doCount*borderSize)
		Wykkyd.Outfitter.Bbar[myCount]:SetWidth(borderSize)

		Wykkyd.Outfitter.Bbar[myCount]:SetPoint(pointOne, targ, pointTwo, 0, 0)
		Wykkyd.Outfitter.Bbar[myCount]:SetLayer(1)
		Wykkyd.Outfitter.Bbar[myCount]:SetSecureMode("restricted")
		for ii = 1, iMax, 1 do
			if barButtons[ii] ~= false then
				local img = wyk.func.IconID(barButtons[ii].icon)
				local bBorder = wyk.frame.CreateTexture("wykButtonBar_b", Wykkyd.Outfitter.Bbar[myCount])
				bBorder:SetAlpha(_buttonbarIconAlpha)
				bBorder:SetTexture(_buttonbarBorderImageSrc, _buttonbarBorderImage)
				bBorder.RootBorderSrc = _buttonbarBorderImageSrc
				bBorder.RootBorderImage = _buttonbarBorderImage
				local bIcon = wyk.frame.CreateTexture( "wykButtonBar_i", bBorder)
				bIcon:SetAlpha(_buttonbarIconAlpha)
				bIcon:SetTexture(wyk.vars.Icons[img].src or "Rift", wyk.vars.Icons[img].file)
				bBorder.RootIconSrc = wyk.vars.Icons[img].src or "Rift"
				bBorder.RootIconImage = wyk.vars.Icons[img].file
				if lastObj == nil then
					bBorder:SetPoint(pointOne, Wykkyd.Outfitter.Bbar[myCount], pointOne, 0, 0)
				else
					bBorder:SetPoint(pointOne, lastObj, pointTwo, 0, 0)
				end
				bIcon:SetPoint("CENTER", bBorder, "CENTER", 0, 0)
				bBorder:SetSecureMode("restricted")
				bIcon:SetSecureMode("restricted")
				bBorder:SetWidth(borderSize)
				bBorder:SetHeight(borderSize)
				bIcon:SetWidth(iconSize)
				bIcon:SetHeight(iconSize)
				bBorder:SetLayer(3)
				bIcon:SetLayer(5)
				lastObj = bIcon
				local macros = {}
				local macroCount = 0

				if barButtons[ii].alertCheck then
					if barButtons[ii].alertChannel == "Raid" then
						macroCount = macroCount+1
						macros[macroCount] = wyk.func.LineClose(macroCount).."ra "..barButtons[ii].alertText
					elseif barButtons[ii].alertChannel == "Group" then
						macroCount = macroCount+1
						macros[macroCount] = wyk.func.LineClose(macroCount).."p "..barButtons[ii].alertText
					elseif barButtons[ii].alertChannel == "Yell" then
						macroCount = macroCount+1
						macros[macroCount] = wyk.func.LineClose(macroCount).."y "..barButtons[ii].alertText
					else
						macroCount = macroCount+1
						macros[macroCount] = wyk.func.LineClose(macroCount).."s "..barButtons[ii].alertText
					end
				end

				if barButtons[ii].changeRole then
					macroCount = macroCount+1
					macros[macroCount] = wyk.func.LineClose(macroCount).."role "..barButtons[ii].targetRole
				end

				if barButtons[ii].changeWardrobe then
					macroCount = macroCount+1
					macros[macroCount] = wyk.func.LineClose(macroCount).."wardrobe "..barButtons[ii].targetWardrobe
				end

				if barButtons[ii].manageKaruul then
					local addons = Inspect.Addon.List()
					if addons.kAlert ~= nil then
						macroCount = macroCount+1
						macros[macroCount] = wyk.func.LineClose(macroCount).."karuulalert set="..barButtons[ii].karuulSet1
						macroCount = macroCount+1
						macros[macroCount] = wyk.func.LineClose(macroCount).."karuulalert subset="..barButtons[ii].karuulSet2
					end
				end

				macroCount = macroCount+1
				macros[macroCount] = wyk.func.LineClose(macroCount).."outfitter equip "..myCount.." "..barButtons[ii].id

				if macroCount > 0 then
					local macro = ""
					for macroCounter = 1, macroCount, 1 do
						macro = macro..macros[macroCounter]
					end
					bIcon:EventMacroSet(Event.UI.Input.Mouse.Left.Down, macro)


				end
				if _buttonBarShowLabels then
					local label = wyk.frame.CreateText("label", targ )
					label:SetText(barButtons[ii].name)
					label:SetBackgroundColor(0,0,0,1)
					label:SetLayer(40)
					label:SetVisible(false)
					label:SetPoint("CENTER",bIcon,"CENTER",0,0)
					bIcon.label = label

					bIcon:EventAttach(Event.UI.Input.Mouse.Left.Down, function(self, h)
						label:SetVisible(false)

					end, "Event.UI.Input.Mouse.Left.Click")
					bIcon:EventAttach(Event.UI.Input.Mouse.Cursor.In, function(self, h)
						label:SetVisible(true)

					end, "Event.UI.Input.Mouse.Cursor.in")
					bIcon:EventAttach(Event.UI.Input.Mouse.Cursor.Out, function(self, h)
						label:SetVisible(false)
					end, "Event.UI.Input.Mouse.Cursor.out")
				end
				barButtons[ii].bIcon = bIcon
				Wykkyd.Outfitter.Bbar[myCount][barButtons[ii].id] = bBorder
			end
		end
	end
end

function Wykkyd.Outfitter.UpdateButton(myCount, vals)
	if barButtons[vals.id] ~= nil then
		local img = wyk.func.IconID(vals.icon)
		if barButtons[vals.id].bIcon ~= nil then
			barButtons[vals.id].bIcon:SetTexture(wyk.vars.Icons[img].src or "Rift", wyk.vars.Icons[img].file)
			if barButtons[vals.id].bIcon.label ~= nil then
				barButtons[vals.id].bIcon.label:SetText(vals.name)
			end
		end
		Wykkyd.Outfitter.Bbar[myCount][vals.id].RootIconImage = wyk.vars.Icons[img].file
		local macros = {}
		local macroCount = 0
		if vals.alertCheck then
			if vals.alertChannel == "Raid" then
				macroCount = macroCount+1
				macros[macroCount] = wyk.func.LineClose(macroCount).."ra "..vals.alertText
			elseif vals.alertChannel == "Group" then
				macroCount = macroCount+1
				macros[macroCount] = wyk.func.LineClose(macroCount).."p "..vals.alertText
			elseif vals.alertChannel == "Yell" then
				macroCount = macroCount+1
				macros[macroCount] = wyk.func.LineClose(macroCount).."y "..vals.alertText
			else
				macroCount = macroCount+1
				macros[macroCount] = wyk.func.LineClose(macroCount).."s "..vals.alertText
			end
		end

		if vals.changeRole then
			macroCount = macroCount+1
			macros[macroCount] = wyk.func.LineClose(macroCount).."role "..vals.targetRole
		end

		if vals.changeWardrobe then
			macroCount = macroCount+1
			macros[macroCount] = wyk.func.LineClose(macroCount).."wardrobe "..vals.targetWardrobe
		end

		if vals.manageKaruul then
			local addons = Inspect.Addon.List()
			if addons.kAlert ~= nil then
				macroCount = macroCount+1
				macros[macroCount] = wyk.func.LineClose(macroCount).."karuulalert set="..vals.karuulSet1
				macroCount = macroCount+1
				macros[macroCount] = wyk.func.LineClose(macroCount).."karuulalert subset="..vals.karuulSet2
			end
		end

		macroCount = macroCount+1
		macros[macroCount] = wyk.func.LineClose(macroCount).."outfitter equip "..myCount.." "..vals.id

		if macroCount > 0 then
			local macro = ""
			for macroCounter = 1, macroCount, 1 do
				macro = macro..macros[macroCounter]
			end
			barButtons[vals.id].bIcon:EventMacroSet(Event.UI.Input.Mouse.Left.Down, macro)
		end
	end
end

local function StartUp()
	if started == false then
		if wyk.func.PlayerCalling() ~= nil then
			if wyk.vars.IconCount > 0 then
				started = true
				--local itm = Inspect.Item.Find("i0354800002ED4E2E")
				--print (itm)
				--for x,i in pairs(itm) do
				--	if x == "stats" then
				--		for a,b in pairs(i) do
				--			print("stat - "..tostring(a).." = "..tostring(b))
				--		end
				--	else
				--		print(tostring(x).." = "..tostring(i))
				--	end
				--end

				--local sl = Inspect.Item.Detail("si01")
				--for _,k in pairs(sl) do
				--	if k ~= nil then
				--		for i,d in pairs(k) do
				--			print(tostring(i).." - "..tostring(d))
				--		end
				--	end
				--end
			end
		end
	end
end

local dialog = false
Wykkyd.Outfitter.watchdoginserted = false

Wykkyd.Outfitter.ConfigFrame = false
wykkydContextCount = 0

Wykkyd.Outfitter.BbarExpanded = {}
Wykkyd.Outfitter.Bbar = {}

local function Create(configuration)
	wykkydContextCount = wykkydContextCount + 1
	local myCount = wykkydContextCount
	Wykkyd.Outfitter.BbarExpanded[myCount] = false
	Wykkyd.Outfitter.Context[myCount] = UI.CreateContext(configuration.id)
	Wykkyd.Outfitter.ContextConfig[myCount] = configuration

	if Wykkyd.Outfitter.ContextConfig[myCount].buttonbarBorderImageSrc == "Gadgets_Outfitter" then Wykkyd.Outfitter.ContextConfig[myCount].buttonbarBorderImageSrc = "libWykkyd" end
	if Wykkyd.Outfitter.ContextConfig[myCount].buttonbarClickyImageSrc == "Gadgets_Outfitter" then Wykkyd.Outfitter.ContextConfig[myCount].buttonbarClickyImageSrc = "libWykkyd" end

	local iconAlpha   = (Wykkyd.Outfitter.ContextConfig[myCount].buttonbarIconAlpha / 100)
	local iconSize    = (Wykkyd.Outfitter.ContextConfig[myCount].buttonbarIconSize / 100)
	local iconImgSize = 96 * iconSize
	local iconBrdrSize = 128 * iconSize

	Wykkyd.Outfitter.Anchor[myCount] = wyk.frame.CreateFrame("wykkydOutfitterButtonBar", WT.Context)
	local obbWrapper = Wykkyd.Outfitter.Anchor[myCount]
	obbWrapper:SetWidth(iconBrdrSize)
	obbWrapper:SetHeight(iconBrdrSize)
	obbWrapper:SetBackgroundColor(0,0,0,0.0)
	obbWrapper:SetSecureMode("restricted")

	local obbBorder = wyk.frame.CreateTexture("wykkydOutfitterButtonBar_border", obbWrapper)
	obbBorder:SetWidth(iconBrdrSize)
	obbBorder:SetHeight(iconBrdrSize)
	obbBorder:SetTexture(Wykkyd.Outfitter.ContextConfig[myCount].buttonbarBorderImageSrc, Wykkyd.Outfitter.ContextConfig[myCount].buttonbarBorderImage)
	obbBorder:SetLayer(2)
	obbBorder:SetAlpha(iconAlpha)
	obbBorder:SetSecureMode("restricted")

	local function expand(targ)
		if Wykkyd.Outfitter.Bbar[myCount] == nil then prepButtonbar(myCount, targ); end
		if Wykkyd.Outfitter.Bbar[myCount] == nil then return end
		if not Wykkyd.Outfitter.BbarExpanded[myCount] then
			Wykkyd.Outfitter.Bbar[myCount]:SetVisible(true)
			Wykkyd.Outfitter.BbarExpanded[myCount] = true
		else
			Wykkyd.Outfitter.Bbar[myCount]:SetVisible(false)
			Wykkyd.Outfitter.BbarExpanded[myCount] = false
		end
	end

	local obbIcon = wyk.frame.CreateTexture("wykkydOutfitterButtonBar_clicky", obbWrapper)
	obbIcon:SetWidth(iconImgSize)
	obbIcon:SetHeight(iconImgSize)
	obbIcon:SetTexture(Wykkyd.Outfitter.ContextConfig[myCount].buttonbarClickyImageSrc, Wykkyd.Outfitter.ContextConfig[myCount].buttonbarClickyImage)
	obbIcon:SetLayer(4)
	obbIcon:SetAlpha(iconAlpha)
	obbIcon:SetSecureMode("restricted")
	obbBorder.icon = obbIcon

	obbIcon:EventAttach(Event.UI.Input.Mouse.Left.Click, function(self, h)
		if Inspect.System.Secure() then return end
		expand(obbIcon)
	end, "Event.UI.Input.Mouse.Left.Click")

	obbIcon:EventAttach(Event.UI.Input.Mouse.Right.Click, function(self, h)
		if Inspect.System.Secure() then return end
		if Wykkyd.Outfitter.ContextWindowOpen[myCount] then
			for ii = 1, wykkydContextCount, 1 do
				if Wykkyd.Outfitter.ContextWindow[ii] ~= nil then
					Wykkyd.Outfitter.ContextWindowOpen[ii] = false
					Wykkyd.Outfitter.ContextWindow[ii]:SetVisible(false)
					wykOBBHighlight(0)
				end
			end
		else
			for ii = 1, wykkydContextCount, 1 do
				if Wykkyd.Outfitter.ContextWindow[ii] ~= nil then
					Wykkyd.Outfitter.ContextWindowOpen[ii] = false
					Wykkyd.Outfitter.ContextWindow[ii]:SetVisible(false)
				end
			end
			wykOBBHighlight(myCount)
			Wykkyd.Outfitter.OpenWindow(myCount)
		end
	end, "Event.UI.Input.Mouse.Right.Click")

	obbIcon:EventAttach(Event.UI.Input.Mouse.Middle.Click, function(self, h)
		if Inspect.System.Secure() then return end
		wykOBBHighlight(myCount)
		Wykkyd.Outfitter.OpenMassReplacementWindow(myCount)

	end,"Event.UI.Input.Mouse.Middle.Click")


	local bBarHighlight = wyk.frame.CreateFrame("wykkydOutfitterButtonBar_ignoreScreen", obbWrapper)
	bBarHighlight:SetPoint("CENTER", obbIcon, "CENTER", 0, 0)
	bBarHighlight:SetWidth(iconImgSize)
	bBarHighlight:SetHeight(iconImgSize)
	bBarHighlight:SetBackgroundColor(.25,.25,.75,0.65)
	bBarHighlight:SetVisible(false)
	bBarHighlight:SetLayer(6)

	local bBarHighlightBorder = wyk.frame.CreateFrame("wykkydOutfitterButtonBar_ignoreScreen", obbWrapper)
	bBarHighlightBorder:SetPoint("CENTER", obbBorder, "CENTER", 0, 0)
	bBarHighlightBorder:SetWidth(iconImgSize+2)
	bBarHighlightBorder:SetHeight(iconImgSize+2)
	bBarHighlightBorder:SetBackgroundColor(1,.5,0,0.75)
	bBarHighlightBorder:SetVisible(false)
	bBarHighlightBorder:SetLayer(3)

	obbWrapper.icon = obbIcon
	obbWrapper.RootIconSrc = Wykkyd.Outfitter.ContextConfig[myCount].buttonbarClickyImageSrc
	obbWrapper.RootIconImage = Wykkyd.Outfitter.ContextConfig[myCount].buttonbarClickyImage
	obbWrapper.border = obbBorder
	obbWrapper.RootBorderSrc = Wykkyd.Outfitter.ContextConfig[myCount].buttonbarBorderImageSrc
	obbWrapper.RootBorderImage = Wykkyd.Outfitter.ContextConfig[myCount].buttonbarBorderImage
	obbWrapper.highlight = bBarHighlight
	obbWrapper.rim = bBarHighlightBorder

	obbIcon:SetPoint("CENTER", obbBorder, "CENTER", 0, 0)
	obbBorder:SetPoint("TOPCENTER", obbWrapper, "TOPCENTER", 0, 0)

	if not Wykkyd.Outfitter.watchdoginserted then
		Command.Event.Attach(Event.System.Update.End, StartUp, "StartUp")
		Wykkyd.Outfitter.watchdoginserted = true
	end
	return obbWrapper
end

function Wykkyd.Outfitter.CollapseBars()
	for ii = 1, wykkydContextCount, 1 do
		if Wykkyd.Outfitter.Bbar[ii] ~= nil then
			Wykkyd.Outfitter.Bbar[ii]:SetVisible(false)
			Wykkyd.Outfitter.BbarExpanded[ii] = false
		end
	end
end

local function ConfigDialog(container)
	local configFrame = wyk.frame.CreateFrame("wykkydOutfitterConfig", container)
	configFrame:SetPoint("TOPLEFT", container, "TOPLEFT")
	configFrame:SetPoint("BOTTOMRIGHT", container, "BOTTOMRIGHT", 0, -32)
	Wykkyd.Outfitter.ConfigFrame = configFrame

	local sldiconAlpha = wyk.frame.SlideFrame("wykkydOutfitterIconAlpha", configFrame, 220, {L=0, H=100}, 70, "Icon Opacity %")
	sldiconAlpha:SetPoint("TOPCENTER", configFrame, "TOPCENTER", 0, 16)
	configFrame.iconAlpha = sldiconAlpha

	local sldiconSize = wyk.frame.SlideFrame("wykkydOutfitterIconSize", configFrame, 220, {L=0, H=100}, 49, "Icon Scale")
	sldiconSize:SetPoint("TOPCENTER", sldiconAlpha, "BOTTOMCENTER", 0, 16)
	configFrame.iconSize = sldiconSize



	local picker = wyk.frame.DeluxeImageSlider("wykkydOutfitterPicker", configFrame, {
		w=240,
		SetPoint = {point="TOPCENTER", target=sldiconSize, targetpoint="BOTTOMCENTER", x=0, y=16},
	}, 1, nil, nil, 2)
	configFrame.iconChooser = picker.iconChooser
	configFrame.borderChooser = picker.borderChooser

	local dirList = {
		{ text = "RIGHT", value = "RIGHT" },
		{ text = "LEFT", value = "LEFT" },
		{ text = "DOWN", value = "DOWN" },
		{ text = "UP", value = "UP" },
	}

	local expandDir = Wykkyd.Outfitter.ComboBox.Create(0, container, "Expand to the:", "RIGHT", dirList, false, false, true)
	expandDir:SetPoint("TOPCENTER", picker, "BOTTOMCENTER", -100, 12)
	configFrame.expandDirection = expandDir
	expandDir:SetLayer(20)

	local labelsEnabler = wyk.frame.CreateRiftCheckbox("labelCheckbox", configFrame)
	labelsEnabler:SetPoint("TOPCENTER", expandDir, "BOTTOMCENTER", -10,20)
	labelsEnabler:SetLayer(20)
	configFrame.labelsEnabler = labelsEnabler
	local labelsEnablerLabel = wyk.frame.CreateText("labelsEnablerLabel",configFrame)
	labelsEnablerLabel:SetText("Enable labels on set buttons")
	labelsEnablerLabel:SetLayer(20)
	labelsEnablerLabel:SetPoint("TOPCENTER", expandDir, "BOTTOMCENTER", 80,20)

local tooltipEnabler = wyk.frame.CreateRiftCheckbox("tooltipCheckbox", configFrame)
tooltipEnabler:SetPoint("TOPCENTER", labelsEnabler, "BOTTOMCENTER", 0, 20)
tooltipEnabler:SetLayer(20)
configFrame.tooltipEnabler = tooltipEnabler
local tooltipLabel = wyk.frame.CreateText("tooltipEnableLabel",configFrame)
tooltipLabel:SetText("Enable tooltip hook")
tooltipLabel:SetPoint("TOPCENTER", labelsEnabler, "BOTTOMCENTER", 70, 15)
end


local function GetConfiguration()
	local config = {
		buttonbarIconAlpha = Wykkyd.Outfitter.ConfigFrame.iconAlpha.slider:GetPosition(),
		buttonbarIconSize = Wykkyd.Outfitter.ConfigFrame.iconSize.slider:GetPosition(),
		buttonbarExpandDirection = Wykkyd.Outfitter.ConfigFrame.expandDirection.value:GetText(),
		checkboxLabelsEnabler = Wykkyd.Outfitter.ConfigFrame.labelsEnabler:GetChecked(),
		checkboxTooltipEnabler = Wykkyd.Outfitter.ConfigFrame.tooltipEnabler:GetChecked(),
	}
	local brdPos = Wykkyd.Outfitter.ConfigFrame.borderChooser.slider:GetPosition() or 8
	local icoPos = Wykkyd.Outfitter.ConfigFrame.iconChooser.slider:GetPosition()
	local brdPos = Wykkyd.Outfitter.ConfigFrame.borderChooser.slider:GetPosition()
	local icoPos = Wykkyd.Outfitter.ConfigFrame.iconChooser.slider:GetPosition()
	if brdPos == 1 then
		config.buttonbarBorderImageSrc = wyk.vars.Images.borders.dark.src
		config.buttonbarBorderImage = wyk.vars.Images.borders.dark.file
	elseif brdPos == 2 then
		config.buttonbarBorderImageSrc = wyk.vars.Images.borders.gray.src
		config.buttonbarBorderImage = wyk.vars.Images.borders.gray.file
	elseif brdPos == 3 then
		config.buttonbarBorderImageSrc = wyk.vars.Images.borders.air.src
		config.buttonbarBorderImage = wyk.vars.Images.borders.air.file
	elseif brdPos == 4 then
		config.buttonbarBorderImageSrc = wyk.vars.Images.borders.death.src
		config.buttonbarBorderImage = wyk.vars.Images.borders.death.file
	elseif brdPos == 5 then
		config.buttonbarBorderImageSrc = wyk.vars.Images.borders.earth.src
		config.buttonbarBorderImage = wyk.vars.Images.borders.earth.file
	elseif brdPos == 6 then
		config.buttonbarBorderImageSrc = wyk.vars.Images.borders.fire.src
		config.buttonbarBorderImage = wyk.vars.Images.borders.fire.file
	elseif brdPos == 7 then
		config.buttonbarBorderImageSrc = wyk.vars.Images.borders.life.src
		config.buttonbarBorderImage = wyk.vars.Images.borders.life.file
	else
		config.buttonbarBorderImageSrc = wyk.vars.Images.borders.water.src
		config.buttonbarBorderImage = wyk.vars.Images.borders.water.file
	end
	config.buttonbarClickyImageSrc = wyk.vars.Icons[icoPos].src
	config.buttonbarClickyImage = wyk.vars.Icons[icoPos].file
	wyk.func.TPrint(config)
	return config
end

local function SetConfiguration(config)
	local ico = wyk.func.IconID(config.buttonbarClickyImage or "")
	Wykkyd.Outfitter.ConfigFrame.iconChooser.slider:SetPosition(ico or 3)
	if config.buttonbarBorderImage == wyk.vars.Images.borders.dark.file then Wykkyd.Outfitter.ConfigFrame.borderChooser.slider:SetPosition(1)
	elseif config.buttonbarBorderImage == wyk.vars.Images.borders.gray.file then Wykkyd.Outfitter.ConfigFrame.borderChooser.slider:SetPosition(2)
	elseif config.buttonbarBorderImage == wyk.vars.Images.borders.air.file then Wykkyd.Outfitter.ConfigFrame.borderChooser.slider:SetPosition(3)
	elseif config.buttonbarBorderImage == wyk.vars.Images.borders.death.file then Wykkyd.Outfitter.ConfigFrame.borderChooser.slider:SetPosition(4)
	elseif config.buttonbarBorderImage == wyk.vars.Images.borders.earth.file then Wykkyd.Outfitter.ConfigFrame.borderChooser.slider:SetPosition(5)
	elseif config.buttonbarBorderImage == wyk.vars.Images.borders.fire.file then Wykkyd.Outfitter.ConfigFrame.borderChooser.slider:SetPosition(6)
	elseif config.buttonbarBorderImage == wyk.vars.Images.borders.life.file then Wykkyd.Outfitter.ConfigFrame.borderChooser.slider:SetPosition(7)
	else Wykkyd.Outfitter.ConfigFrame.borderChooser.slider:SetPosition(8)
	end
	Wykkyd.Outfitter.ConfigFrame.iconAlpha.slider:SetPosition( config.buttonbarIconAlpha )
	Wykkyd.Outfitter.ConfigFrame.iconSize.slider:SetPosition( config.buttonbarIconSize )
	Wykkyd.Outfitter.ConfigFrame.expandDirection.value:SetText( config.buttonbarExpandDirection )
	--added this in for all the older configs that didn't have the checkbox. this'll prevent people from having to reset they're buttons completely
	if config.checkboxLabelsEnabler == nil then
		config.checkboxLabelsEnabler = false
	end
	if config.checkboxTooltipEnabler == nil then
		config.checkboxTooltipEnabler = true
	end
	Wykkyd.Outfitter.ConfigFrame.labelsEnabler:SetChecked(config.checkboxLabelsEnabler)
	Wykkyd.Outfitter.ConfigFrame.tooltipEnabler:SetChecked(config.checkboxTooltipEnabler)
end

local function tryAdd(num) local r = num+1 end
local function isInt(x) if pcall(tryAdd, x) then return true; else return false; end end

Wykkyd.Outfitter.Command = {}
function Wykkyd.Outfitter.Command.Listener(args)
	if wyk.isReady() == false then return end
	local params = {}
	local paramCount = 0
	for arg in args:gmatch("%w+") do
		paramCount = paramCount+1
		params[paramCount] = arg
	end
	if paramCount >= 3 then
		if params[1] == "equip" then
			if isInt(params[2]) and isInt(params[3]) then
				SetRootIcon(params[2]+0, params[3]+0)
				--Wykkyd.Outfitter.ContextConfig[params[2]+0].EquipSetGear
				local num = params[2]+0
				local eset = params[3]+0
				for _, g in pairs(Wykkyd.Outfitter.ContextConfig[num].EquipSetGear) do
					if g.id == eset then
						wyk.func.colorPrint( "[Outfitter v"..WykkydOutfitterVersion.."] Loading '"..g.name.."'", 0x8A2BE2, 0xBF5FFF )
					end
				end
				Wykkyd.Outfitter.EquipSets.Load(params[2]+0, params[3]+0)
				Wykkyd.Outfitter.CollapseBars()
			end
		end
	end
end

table.insert(Command.Slash.Register("outfitter"), {Wykkyd.Outfitter.Command.Listener, "Gadgets_Outfitter", "Wykkyd.Outfitter.Command.Listener"})
Command.Event.Attach(Event.Tooltip,Wykkyd.Outfitter.TooltipHandler,"tooltipHandling Outfitter")

WT.Gadget.RegisterFactory("outfitWrapper",
{
	name="Outfitter: Set Button",
	description="Places a 'Button Bar' for gear swaps.",
	author="Wykkyd, Merxion. Current Maintainer: " .. WykkydOutfitter.Author,
	version=WykkydOutfitterVersion,
	["Create"] = Create,
	["ConfigDialog"] = ConfigDialog,
	["GetConfiguration"] = GetConfiguration,
	["SetConfiguration"] = SetConfiguration,
})


