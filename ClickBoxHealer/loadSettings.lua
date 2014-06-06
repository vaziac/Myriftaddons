--[[
file: loadSettings.lua
by: Solsis00
for: ClickBoxHealer

Default/saved settings are loaded and launch the beginning of CBH.

**COMPLETE: Converted to local cbh table successfully.
]]--


local addon, cbh = ...

cbh.initialLoad = true


--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
--      CREATE/LOAD SAVEDVARIABLES
--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]

--Creates/checks/loads default values for the addon if first use, loads if returning
function cbh.loadSettings(hEvent, addonid)
	if addonid == "ClickBoxHealer" then
		cbh.WindowOptions:SetVisible(false)
		cbh.Window:SetVisible(false)

		-- get rid of this
		-- cbhConstants = {
			-- buttons = 7 -- Number of buttons the user can customize
		-- }

		-- dValues = {
		cbh.defaults.Values = {
			--Basic options
			showtooltips = false,
			cmenu = false,
			fastupdates = 0.25,

			--Main frame size/positioning
			windowstate = true,
			locmainx = 500,
			locmainy = 500,
			framemount = "TOPLEFT",

			--Minimap button location
			MMBx = 600,
			MMBy = 200,
			MMBVis = true,

			--Frame size/positioning
			ufwidth = 90,
			ufheight = 45,
			ufhgap = 2,
			ufvgap = 2,
			ufcols = 4,

			--Frame ordering options
			ordervup = false,
			orderhleft = false,
			orderhright = false,

			--Frame visibility options
			hideooc = false,    --hide while out of combat
			incombatalpha = 1,
			oocalpha = 0.1,

			--Font settings
			optfontsize = 14,
			fontsize = 14,

			--Pets
			pet = false,

			--Frame customizations
			colorhealth = false,
			colorgradient = false,
			texture = "health_1.png",

			--Frame component options
			namesize = 12,
			namelength = 8,
			namelengthauto = true,
			namesetpoint = "TOPCENTER",
			hidehealth = false,
			statussize = 12,
			statusdisplay = "Percent",  -- choices are percent, health, deficit
			statussetpoint = "BOTTOMCENTER",
			readychecksize = 14,
			readychecksetpoint = "BOTTOMLEFT",
			rolewatch = true,
			rolesize = 14,
			rolesetpoint = "TOPLEFT",
			raidmarkersize = 14,
			rmarksetpoint = "CENTERRIGHT",
			mbheight = 6,
			absShow = true, -- Shows absorb effects on frames
			absheight = 8,

			--Roles? Need to find out what "set" was/is????
			set = 1,
			roleset = 1,

			--Buff/Debuff options
			hotwatch = true,
			buffwarncolor = false, -- Show one color for buffs, change color as buff nears end
			bufffade = true, -- Fade buff indicators when duration nears end
			buffflash = false, -- Flash buff indicators when duration nears end
			bufficons = true, -- Show buff icons
			hotsize = 12,
			hottextsize = 8,
			alphasetting = 0.3,
			debuffwatch = true,
			debuffcolorwhole = false, -- Color whole frame when debuffed, instead of small rect.
			-- debuffwl = true,
			-- debuffbl = true,

			--Range check options
			rangecheck = true,
			rangecheckdist = 30,

			--Version Check
			notified = nil,
		}

		-- CHECKS THE TABLES FOR BEING EMPTY AND CREATES THEIR DEFAULTS. 1 - 20 IS THE CURRENT ROLE 'SPEC' OF THE PLAYER.
		
		-- Builds MacroText  table which store the final built macros
		for i = 1, 20 do
			if cbhMacroText ~= nil then
				if cbhMacroText[i] == nil then
					cbhMacroText[i] = {"target ##", "", "", "", "", "", ""}
				elseif cbhMacroText[i][6] == nil then -- Catch if user had settings previous to wheel up/down addition, add in slots so as not to erase all settings
					cbhMacroText[i][6] = ""
					cbhMacroText[i][7] = ""
				end
			else
				cbhMacroText = {}
				cbhMacroText[i] = {"target ##", "", "", "", "", "", ""}
			end

			if cbhMacroButton ~= nil then
				if cbhMacroButton[i] == nil then
					cbhMacroButton[i] = {{"target ##", "", "", ""}, {"", "", "", ""}, {"", "", "", ""}, {"", "", "", ""}, {"", "", "", "" }, {"", "", "", "" }, {"", "", "", "" }}
				elseif cbhMacroButton[i][6] == nil then -- Catch if user had settings previous to wheel up/down addition, add in slots so as not to erase all settings
					cbhMacroButton[i][6] = {"", "", "", ""}
					cbhMacroButton[i][7] = {"", "", "", ""}
				end
			else
				cbhMacroButton = {}
				cbhMacroButton[i] = {{"target ##", "", "", ""}, {"", "", "", ""}, {"", "", "", ""}, {"", "", "", ""}, {"", "", "", "" }, {"", "", "", "" }, {"", "", "", "" }}
			end

			if cbhBuffListA ~= nil then
				if cbhBuffListA[i] == nil then
					cbhBuffListA[i] = {"", "", "", "", "", "", "", "", ""}
				else
					for x = 1, 9 do
						if cbhBuffListA[i][x] == nil then
							cbhBuffListA[i][x] = ""
						end
					end
				end
			else
				cbhBuffListA = {}
				cbhBuffListA[i] = {"", "", "", "", "", "", "", "", ""}
			end

			if cbhBuffWatchList ~= nil then
				if cbhBuffWatchList[i] == nil then
					cbhBuffWatchList[i] = {"", "", "", "", "", "", "", "", ""}
				else
					for x = 1, 9 do
						if cbhBuffWatchList[i][x] == nil then
							cbhBuffWatchList[i][x] = ""
						end
					end
				end
			else
				cbhBuffWatchList = {}
				cbhBuffWatchList[i] = {"", "", "", "", "", "", "", "", ""}
			end


			if cbhBuffColors ~= nil then
				for x = 1, 9 do
					if cbhBuffColors[i] ~= nil then
						if cbhBuffColors[i][x] == nil then
							cbhBuffColors[i][x] = {}
							cbhBuffColors[i][x] = {r = 0.2, g = 1, b = 0.2, a = 1}
						end
					else
						cbhBuffColors[i] = {}
						cbhBuffColors[i][x] = {}
						cbhBuffColors[i][x] = {r = 0.2, g = 1, b = 0.2, a = 1}
					end
				end
			else
				cbhBuffColors = {}
				cbhBuffColors[i] = {}
				for x = 1, 9 do
					cbhBuffColors[i][x] = {}
					cbhBuffColors[i][x] = {r = 0.2, g = 1, b = 0.2, a = 1}
				end
			end

			-- SET DEFAULT COLORS FOR BUFFWARNCOLOR OPTION
			if cbhBuffWarnColors ~= nil then
				for x = 1, 9 do
					if cbhBuffWarnColors[i] ~= nil then
						if cbhBuffWarnColors[i][x] == nil then
							cbhBuffWarnColors[i][x] = {}
							cbhBuffWarnColors[i][x] = {r = 0.2, g = 1, b = 0.2, a = 1}
						end
					else
						cbhBuffWarnColors[i] = {}
						cbhBuffWarnColors[i][x] = {}
						cbhBuffWarnColors[i][x] = {r = 0.2, g = 1, b = 0.2, a = 1}
					end
				end
			else
				cbhBuffWarnColors = {}
				for x = 1, 9 do
					cbhBuffWarnColors[i] = {}
					cbhBuffWarnColors[i][x] = {r = 0.2, g = 1, b = 0.2, a = 1}
				end
			end
		end


		if cbhDeBuffWList == nil then
			cbhDeBuffWList = {"Explosive Venom"}
		end

		if cbhDeBuffBList == nil then
			cbhDeBuffBList = {"Looking For Group"}
		end


		-- CHECKS FOR MISSING VALUES IN THE CUSTOM FRAME COLORS
		if dcbhCallingColors == nil then
			dcbhCallingColors = {}
		end

		if dcbhCallingColors ~= nil then
			for x = 1, 8 do
				if dcbhCallingColors[x] == nil then
					if x == 1 then
						dcbhCallingColors[x] = {r = 1, g = 0, b = 0}    --warrior
					elseif x == 2 then
						dcbhCallingColors[x] = {r = 0, g = 1, b = 0}    --cleric
					elseif x == 3 then
						dcbhCallingColors[x] = {r = 0.8, g = 0.5, b = 1}    --mage
					elseif x == 4 then
						dcbhCallingColors[x] = {r = 1, g = 1, b = 0}    --rogue
					elseif x == 5 then
						dcbhCallingColors[x] = {r = 1, g = 1, b = 1}    --percentage
					elseif x == 6 then
						dcbhCallingColors[x] = {r = .75, g = 0, b = 0, a = .5}  --Backdrop color
					elseif x == 7 then
						dcbhCallingColors[x] = {r = 0, g = 0, b = 0, a = 1} --Health Frame color
					elseif x == 8 then
						dcbhCallingColors[x] = {r = .25, g = .5, b = .5, a = 1} -- Absorb shield color
					end
				end
			end
		end

		-- CHECK TO SET THE 2 FRAME COLORING OPTIONS. CBHGROUPCHCOLOR[2] = COLOR BEHIND HEALTH BAR, CBHGROUPCHCOLOR[1] = HEALTH FRAME OVERLAY COLOR
		if dcbhGroupCHColor == nil then
			dcbhGroupCHColor = {
				{r = 0, g = 0, b = 0}   --Health color
				-- {r = 0.5, g = 0.5, b = 1, a = 0.8}   -- NOT USED
			}
		end

		-- TABLE USED TO SAVE LAYOUTS. LOADED IN THE FOLLOWING ORDER CBHVALUES, CBHBUFFCOLORS, CBHBUFFWARNCOLORS, CBHCALLINGCOLORS, CBHGROUPCHCOLOR
		if cbhCustomLayouts == nil then
			cbhSelectedLayout = "default"
			cbhCustomLayouts = {}
			cbhCustomLayouts["default"] = {}
			cbhCustomLayouts["default"] = {
				-- cbhValues = dValues,
				cbhValues = cbh.defaults.Values,
				cbhCallingColors = dcbhCallingColors,
				cbhGroupCHColor = dcbhGroupCHColor
			}
		end
		if not cbhCustomLayouts[cbhSelectedLayout] then
			print("Your last profile does not exist. Reverting to default profile.")
			cbhSelectedLayout = "default"
		end
	end
end



--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
--          LOAD LAYOUT VARIABLES
--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]

--LOADS SAVED CBHXXXX VARIABLES INTO A BASE VARIABLE. **THIS WILL BE REMOVED ONCE CUSTOMLAYOUT IS APPLIED ACROSS THE BOARD
function cbh.loadLayout(hEvent)
	local n = cbhSelectedLayout
	for k, v in pairs(cbh.defaults.Values) do
		if cbhCustomLayouts[n].cbhValues[k] == nil then
			cbhCustomLayouts[n].cbhValues[k] = v
		end
	end

	for i, a in pairs(dcbhCallingColors) do
		if cbhCustomLayouts[n].cbhCallingColors[i] == nil then
			cbhCustomLayouts[n].cbhCallingColors[i] = a
		end
	end

	cbhValues = cbhCustomLayouts[n].cbhValues
	cbhCallingColors = cbhCustomLayouts[n].cbhCallingColors
	cbhGroupCHColor = cbhCustomLayouts[n].cbhGroupCHColor
	if not cbhValues.buffwarncolors then
		cbhColorGlobal = cbhBuffColors
	else
		cbhColorGlobal = cbhBuffWarnColors
	end

end



--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
--          INITIALIZATION CALLS
--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]

--INITIALIZATION PROCESS TO LOAD/CREATE EVERYTHING
function cbh.Initialize(hEvent)
	cbh.loadLayout()
	cbhValues.isincombat = false
	cbhValues.islocked = false
	Command.System.Watchdog.Quiet()

	--[[    REMOVE IN V2.0 ]]--
	if cbhValues.ordervup and cbhValues.orderhright then
		cbhValues.framemount = "BOTTOMRIGHT"
	elseif cbhValues.ordervup or cbhValues.orderhright then
		if cbhValues.ordervup then
			cbhValues.framemount = "BOTTOMLEFT"
		elseif cbhValues.orderhright then
			cbhValues.framemount = "TOPRIGHT"
		end
	else
		cbhValues.framemount = "TOPLEFT"
	end

	--[[    REMOVE IN V2.0 ]]--
	if cbhValues.statusdisplay == "deficit" then
		cbhValues.statusdisplay = "Deficit"
	elseif cbhValues.statusdisplay == "health" then
		cbhValues.statusdisplay = "Health"
	elseif cbhValues.statusdisplay == "percent" then
		cbhValues.statusdisplay = "Percent"
	end

	cbh.CreateMain()
	cbh.CreateMMB()
	cbh.ToggleLock()
	cbh.rangevalue = cbhValues.rangecheckdist^2

	cbh.Notifications()
	if cbhValues.notified ~= cbh.adetail.toc.Version then cbh.NotifyWindow:SetVisible(true) end

	Command.Console.Display("general", false, "<font color='#FFFF00'>Thank you for using <font color='#005CE6'><b>"..cbh.adetail.toc.Name.."</b></font><font color='#00CC00'> v"..cbh.adetail.toc.Version.."</font>!</font>", true)
	Command.Console.Display("general", false, "<font color='#FFFF00'>Use <font color='#CC3300'><b>/cbh</b></font> for commands.</font>", true)

	-- will allow me updating the ver for beta testing without triggering off libversion warnings
	if not string.find(cbh.adetail.toc.Version, "beta") then LibVersionCheck.register(cbh.adetail.toc.Name, cbh.adetail.toc.Version) end
end




--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
-- CREATE IN-GAME SLASH COMMAND RESPONSES
--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]

function cbh.SlashCommand(hEvent, params)
	if params == "reset" then
		cbh.ResetWindow()
		cbh.Window:SetVisible(false)
		cbhBuffListA = nil
		cbhMacroText = nil
		cbhMacroButton = nil
		cbhBuffColors = nil
		cbhBuffWarnColors = nil
		cbhSelectedLayout = nil
		cbhCustomLayouts = nil
		-- ************* Add options to reset just these to defaults *********************
		-- cbhCustomLayouts[cbhSelectedLayout].cbhValues = nil
		-- cbhCustomLayouts[cbhSelectedLayout].cbhBuffColors = nil
		-- cbhCustomLayouts[cbhSelectedLayout].cbhBuffWarnColors = nil
		-- cbhCustomLayouts[cbhSelectedLayout].cbhCallingColors = nil
		-- cbhCustomLayouts[cbhSelectedLayout].cbhGroupCHColor = nil
		cbh.Window:SetPoint("TOPLEFT", context, "TOPLEFT", cbhValues.locmainx, cbhValues.locmainy)
		print("CLICK COTINUE to reloadui and apply the default settings.")
		cbh.WindowReset:SetVisible(true)
	elseif params == "show" then
			cbh.ShowWindow()
	elseif params == "hide" then
			cbh.HideWindow()
	elseif params == "config" then
		cbh.ShowConfig()
	elseif params == "toggle" then
		cbh.ToggleWindow()
	elseif params == "lock" then
		cbh.ToggleLock()
	elseif params == "tt" then
		cbh.ToggleTT()
	elseif params == "rbufflist" then
		cbhBuffListA = nil
	elseif params == "rbuffcolors" then
		cbhBuffColors = nil
		cbhBuffWarnColors = nil
	elseif params == "rcbhvalues" then
		cbhCustomLayouts[cbhSelectedLayout].cbhValues = cbh.defaults.Values
	elseif params == "rframecolors" then
		cbhCustomLayouts[cbhSelectedLayout].cbhCallingColors = dcbhCallingColors
	else
		print("----------------------------------------------")
		print("Click Box Healer Help Menu")
		print("-----------------------------------------------")
		print("/cbh show    -- Show window")
		print("/cbh hide    -- Hide window")
		print("/cbh toggle  -- Toggles displaying main window")
		print("/cbh reset   -- Reset all settings AND clickbinds to default!")
		print("/cbh rbufflist   -- Reset tracked buffs")
		print("/cbh rbuffcolors -- Reset all buff coloring to defaults")
		print("/cbh rcbhvalues  -- Reset location, texture, size, etc settings to defaults")
		print(" ")
		print("/cbh config  -- Display config window")
		print("/cbh lock -- Allows you to move the frame. Type again to lock")
		print("/cbh tt -- Toggles tooltips on frame mouseover")
	end
end




--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
--          SLASH COMMAND FUNCTIONS
--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]

--FUNCTIONS FOR ALL THE /CBH COMMANDS
function cbh.ShowWindow()
	cbh.Window:SetVisible(true)
	cbhValues.windowstate = true
end

function cbh.HideWindow()
	cbh.Window:SetVisible(false)
	cbhValues.windowstate = false
end

function cbh.ToggleWindow()
	if not cbhValues.isincombat then
		if cbh.Window:GetVisible() then
			cbh.Window:SetVisible(false)
			cbhValues.windowstate = false
		else
			cbh.Window:SetVisible(true)
			cbhValues.windowstate = true
		end
	end
end

function cbh.ShowConfig()
	if not cbhValues.isincombat then
		if not cbh.optionsloaded then
			cbh.CreateOptions()
			cbh.optionsloaded = true
		end
		if cbh.WindowOptions:GetVisible() then
			cbh.WindowOptions.CloseMe()
		else
			if cbh.rolechange then
				cbh.tAbilityIconsText = nil
				cbh.tAbilityIcons = nil
				cbh.AbilityListUpdate()
				cbh.rolechange = false
			end
			cbh.WindowOptions:SetVisible(true)
		end
	else
		print("Cannot open window while in combat!")
	end
end

function cbh.FrameLocked(lockcheck)
	if lockcheck == false then
		cbhValues.islocked = false
		cbh.WindowDrag:SetVisible(true)
		if cbh.PlayerLoaded then
			cbh.PlayerWindowDrag:SetVisible(true)
			cbh.PlayerComboDrag:SetVisible(true)
			for i = 1, 5 do
				cbh.PlayerCombo[i]:SetVisible(true)
			end
		end
		if cbh.TargetLoaded then cbh.TargetWindowDrag:SetVisible(true) end
		for i = 1, 20 do
			cbh.groupBase[i]:SetVisible(true)
			cbh.groupBase[i]:SetAlpha(1)
			-- cbh.groupMask[i]:SetVisible(true)
			cbh.groupStatus[i]:SetBackgroundColor(0,0,0,0)
		end
		cbh.processMacroText(cbh.UnitsTable)
		processraid = false
		processgroup = false
		-- cbh.Window:SetBackgroundColor(1,0,0,1)
		cbh.WindowDrag:SetWidth(cbh.Window:GetWidth()+8)
		cbh.WindowDrag:SetHeight(cbh.Window:GetHeight()+8)
	else
		cbhValues.islocked = true
		cbh.WindowDrag:SetVisible(false)
		if cbh.PlayerLoaded then
			cbh.PlayerWindowDrag:SetVisible(false)
			cbh.PlayerComboDrag:SetVisible(false)
			for i = 1, 5 do
				if cbh.playerinfo.combo and cbh.playerinfo.combo >= i then
					cbh.PlayerCombo[i]:SetVisible(true)
				else
					cbh.PlayerCombo[i]:SetVisible(false)
				end
			end
		end
		if cbh.TargetLoaded then cbh.TargetWindowDrag:SetVisible(false) end
		-- cbh.Window:SetBackgroundColor(0,0,0,0)
		cbh.RefreshUnits(1)
		for groupnum = 1, 20 do
			-- this needs work.. dont think this will always work properly
			cbh.UnitStatus[groupnum].oocalpha = nil
			if cbhValues.hideooc then
				if cbh.UnitStatus[groupnum].los then
					cbh.HideOutofCombat(groupnum, cbh.UnitStatus[groupnum].los)
				elseif cbh.UnitStatus[groupnum].outofrange then
					cbh.HideOutofCombat(groupnum, cbh.UnitStatus[groupnum].outofrange)
				else
					cbh.HideOutofCombat(groupnum, cbh.UnitStatus[groupnum].los)
				end
			end
		end
	end
end

function cbh.ToggleLock()
	if not cbhValues.isincombat then
		if cbhValues.islocked then
			cbhValues.islocked = false
			print("Frame unlocked. Click and drag to move.")
		else
			cbhValues.islocked = true
			print("Frame locked. Saved configuration.")
		end
		cbh.FrameLocked(cbhValues.islocked)
	else
		print("Frame state cannot be changed while in combat")
	end
end

function cbh.ToggleTT(notoggle)
	if not cbhValues.isincombat then
		if notoggle == nil then
			if cbhValues.showtooltips then
				cbhValues.showtooltips = false
				cbh.processMacroText(cbh.UnitsTable)
			else
				cbhValues.showtooltips = true
				cbh.processMacroText(cbh.UnitsTable)
			end
		else
			cbh.processMacroText(cbh.UnitsTable)
		end
	end
end

function cbh.ToggleMMB(notoggle)
	if not cbhValues.isincombat then
		if notoggle == nil then
			if cbhValues.MMBVis then
				cbh.WindowMMB:SetVisible(true)
			else
				cbh.WindowMMB:SetVisible(false)
			end
		else
			print("Doesn't do anything yet")
		end
	end
end


