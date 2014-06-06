--[[
file: view.lua
by: Solsis00
for: ClickBoxHealer

This file is where the frames are actually drawn. Nothing more.. nothing less..

**COMPLETE: Converted to local cbh table successfully.
]]--

local addon, cbh = ...

--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
--[[								UNIT FRAME CONTAINER LAYOUT]]
--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]

function cbh.CreateMain()
	cbh.Window:SetPoint("TOPLEFT", cbh.Context, "TOPLEFT", cbhValues.locmainx, cbhValues.locmainy)

	--LOCK FRAMES
	cbh.FrameLocked(cbhValues.islocked)
	windowdragActive = false
	windowResizeActive = false

	-- CREATE "DRAG ORB" FOR MOVING FRAME
	cbh.WindowDrag:SetPoint("TOPLEFT", cbh.Window, "TOPLEFT", -4, -4)
	-- cbh.WindowDrag:SetTexture("ClickBoxHealer", "Textures/lockorb.png")
	-- cbh.WindowDrag:SetTexture("Rift", "AreaQuest_VFX_CenterBursts.png.dds")
	cbh.WindowDrag:SetLayer(9)
	cbh.WindowDrag:SetBackgroundColor(1,0,0,.5)
	cbh.WindowDrag:SetVisible(false)

	-- ALLOWS DRAGGING OF FRAME AND REPOSITIONING WHEN FRAME ISN'T LOCKED
	cbh.WindowDrag:EventAttach(Event.UI.Input.Mouse.Left.Down, function(self, h)
		self.windowdragActive = true
		local mouseStatus = Inspect.Mouse()
		self.oldx = mouseStatus.x - cbhValues.locmainx
		self.oldy = mouseStatus.y - cbhValues.locmainy
	end, "Event.UI.Input.Mouse.LeftDown")

	--CHANGE SAVED FRAMENUMBERIABLES WHEN MOUSE IS MOVED WHILE DRAGGING ACTIVE
	cbh.WindowDrag:EventAttach(Event.UI.Input.Mouse.Cursor.Move, function(self, h)
		if self.windowdragActive == true then
			self.moved = true
			local newx, newy
			local mouseStatus = Inspect.Mouse()
			cbhValues.locmainx = mouseStatus.x - self.oldx
			cbhValues.locmainy = mouseStatus.y - self.oldy
			cbh.Window:SetPoint("TOPLEFT", cbh.Context, "TOPLEFT", cbhValues.locmainx, cbhValues.locmainy)
		end
	end, "Event.UI.Input.Mouse.Cursor.Move")

	-- ENDS DRAGGING WHEN LEFT CLICK RELEASED
	cbh.WindowDrag:EventAttach(Event.UI.Input.Mouse.Left.Up, function(self, h)
		self.windowdragActive = false
	end, "Event.UI.Input.Mouse.LeftUp")

	cbh.WindowDrag:EventAttach(Event.UI.Input.Mouse.Left.Upoutside, function(self, h)
		self.windowdragActive = false
	end, "Event.UI.Input.Mouse.Left.Upoutside")

	-- LOCKS FRAME IF RIGHT CLICKED
	cbh.WindowDrag:EventAttach(Event.UI.Input.Mouse.Right.Click, function(self, h)
		cbh.FrameLocked()
	end, "Event.UI.Input.Mouse.Right.Click")

	if cbhValues.windowstate then cbh.Window:SetVisible(true) end
	if not cbhValues.windowstate then print ("Click Box Healer is currently closed, '/cbh show' to open") end
	
	cbh.CreateGroupFrames()
	-- if cbhTargetValues.enabled then
		-- cbh.CreateTargetFrame()
	-- end
end




--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
--[[									UNIT FRAME LAYOUT DRAWING]]
--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]

function cbh.CreateGroupFrames()
	local ufwidth = cbhValues.ufwidth
	local ufheight = cbhValues.ufheight
	local mb = cbhValues.mbheight
	local vgap = cbhValues.ufvgap
	local hgap = cbhValues.ufhgap
	local x, y, ufgroups
	local ufgroups = cbhValues.ufcols
	local ufgroupsize = math.ceil(20 / ufgroups)
	
	if cbhValues.ufcols > 4 then cbhValues.ufcols = 4 end
	
	-- if not cbhValues.orderhleft then
		-- if cbhValues.ufcols >= 5 then	--used to force drawing frames horizontal
		if cbhValues.orderhleft then	--used to force drawing frames horizontal
			-- ufgroups = 4
			-- ufgroupsize = 5
			cbh.Window:SetWidth((ufwidth*ufgroupsize)+((ufgroupsize+1)*vgap))
			cbh.Window:SetHeight((ufheight*ufgroups)+((ufgroups+1)*hgap))
		else
			cbh.Window:SetWidth((ufwidth*ufgroups)+((ufgroups)*hgap))
			cbh.Window:SetHeight((ufheight*ufgroupsize)+((ufgroupsize)*vgap))
		end
	-- else
		-- print("@@@ Draw horizontal")
			-- cbh.Window:SetWidth((ufwidth*ufgroupsize)+((ufgroupsize+1)*vgap))
			-- cbh.Window:SetHeight((ufheight*ufgroups)+((ufgroups+1)*hgap))
	-- end
	
	-- cbh.Window:SetBackgroundColor(1,1,1,.5)	--Window background for position troubleshooting

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
	local framemount = cbhValues.framemount

	for a = 1, ufgroups do
		for i = 1, ufgroupsize do
			local groupnum = i + ((a-1) * ufgroupsize)
			
			-- if cbhValues.ufcols >= 5 then
			if cbhValues.orderhleft then
				x = ufwidth * (i - 1) + (i * vgap)
				y = (ufheight * (a - 1) + (a * hgap))
				--		45 * (1-1) + (1 * 2) = 2 + mb
			else
				x = ufwidth * (a - 1) + (a * hgap)
				y = (ufheight * (i - 1) + (i * vgap))
			end
			if cbhValues.orderhright then x = -(x)	end
			if cbhValues.ordervup then y = -(y) end
			
			cbh.framepos[groupnum] = nil
			cbh.framepos[groupnum] = { ["x"] = x, ["y"] = y, ["ymb"] = y-mb}
			
			-- SET BACKGROUND TEXTURE, SIZE AND COLOR
			if not cbh.initialLoad then cbh.groupBase[groupnum]:ClearAll() end
			cbh.groupBase[groupnum]:SetPoint(framemount, cbh.Window, framemount, x, y)
			-- cbh.groupBase[groupnum]:SetLayer(0)
			-- cbh.groupBase[groupnum]:SetBackgroundColor(cbhCallingColors[6].r, cbhCallingColors[6].g, cbhCallingColors[6].b, cbhCallingColors[6].a)
			cbh.groupBase[groupnum]:SetWidth(ufwidth)
			cbh.groupBase[groupnum]:SetHeight(ufheight)


			-- SET BORDER FRAME
			-- cbh.groupBFBorder[groupnum]:SetPoint("TOPLEFT", cbh.groupHF[groupnum], "TOPLEFT", -1, -1)
			cbh.groupBFBorder[groupnum]:SetPoint("TOPLEFT", cbh.groupBase[groupnum], "TOPLEFT", -1, -1)
			cbh.groupBFBorder[groupnum]:SetPoint("BOTTOMRIGHT", cbh.groupBase[groupnum], "BOTTOMRIGHT", 1, 1)
			cbh.groupBFBorder[groupnum]:SetTexture("ClickBoxHealer", "Textures/nbackframe.png")
			cbh.groupBFBorder[groupnum]:SetLayer(1)
			-- cbh.groupBFBorder[groupnum]:SetHeight(ufheight+2)
			-- cbh.groupBFBorder[groupnum]:SetWidth(ufwidth+2)

			-- GROUP AGGRO FRAME
			cbh.groupAggro[groupnum]:SetPoint("TOPLEFT", cbh.groupBase[groupnum], "TOPLEFT", -2, -2)
			cbh.groupAggro[groupnum]:SetPoint("BOTTOMRIGHT", cbh.groupBase[groupnum], "BOTTOMRIGHT", 2, cbhValues.mbheight)
			cbh.groupAggro[groupnum]:SetTexture("ClickBoxHealer", "Textures/naggroframe.png")
			cbh.groupAggro[groupnum]:SetLayer(1) --8
			cbh.groupAggro[groupnum]:SetVisible(false)
			-- cbh.groupAggro[groupnum]:SetWidth(ufwidth + 4)
			-- cbh.groupAggro[groupnum]:SetHeight(ufheight + 4)

			-- SET "SELECTED" FRAME HIGHLIGHT TEXTURE, SIZE AND COLOR
			cbh.groupSel[groupnum]:SetPoint("TOPLEFT", cbh.groupBase[groupnum], "TOPLEFT", -2, -2)
			cbh.groupSel[groupnum]:SetPoint("BOTTOMRIGHT", cbh.groupBase[groupnum], "BOTTOMRIGHT", 2, cbhValues.mbheight)
			cbh.groupSel[groupnum]:SetTexture("ClickBoxHealer", "Textures/selected.png")
			cbh.groupSel[groupnum]:SetLayer(1) --9
			-- cbh.groupSel[groupnum]:SetWidth(ufwidth + 4)
			-- cbh.groupSel[groupnum]:SetHeight(ufheight + 4)
			cbh.groupSel[groupnum]:SetVisible(false)
		

			-- SET HEALTH FRAME OPTIONS
			cbh.groupHF[groupnum]:SetPoint("TOPLEFT", cbh.groupBase[groupnum], "TOPLEFT", 0, 0)
			cbh.groupHF[groupnum]:SetTexture("ClickBoxHealer", "Textures/"..cbhValues.texture)
			cbh.groupHF[groupnum]:SetLayer(2)
			cbh.groupHF[groupnum]:SetBackgroundColor(cbhCallingColors[7].r, cbhCallingColors[7].g, cbhCallingColors[7].b, cbhCallingColors[7].a)
			cbh.groupHF[groupnum]:SetWidth(ufwidth)
			cbh.groupHF[groupnum]:SetAlpha(1)

			
			-- SET BACK FRAME OPTIONS
			cbh.groupBF[groupnum]:SetPoint("TOPRIGHT", cbh.groupHF[groupnum], "TOPRIGHT", 0, 0)
			cbh.groupBF[groupnum]:SetLayer(3)
			cbh.groupBF[groupnum]:SetBackgroundColor(cbhCallingColors[6].r, cbhCallingColors[6].g, cbhCallingColors[6].b, cbhCallingColors[6].a)
			cbh.groupBF[groupnum]:SetWidth(0)

			
			-- SET HEALTH FRAME OPTIONS
			cbh.groupHPCap[groupnum]:SetPoint("TOPCENTER", cbh.groupHF[groupnum], "TOPLEFT", 0, 0)
			cbh.groupHPCap[groupnum]:SetTexture("ClickBoxHealer", "Textures/healthCap.png")
			cbh.groupHPCap[groupnum]:SetLayer(5)
			cbh.groupHPCap[groupnum]:SetHeight(cbhValues.ufheight)
			cbh.groupHPCap[groupnum]:SetVisible(false)

			
			-- SET ROLE SIZE AND POSITION
			cbh.groupRole[groupnum]:SetPoint(cbhValues.rolesetpoint, cbh.groupHF[groupnum], cbhValues.rolesetpoint, 0, 0)
			cbh.groupRole[groupnum]:SetWidth(cbhValues.rolesize)
			cbh.groupRole[groupnum]:SetHeight(cbhValues.rolesize)
			cbh.groupRole[groupnum]:SetLayer(4)
			
			
			-- SET RAID MARKER POSITION AND SIZE
			cbh.RaidMarker[groupnum]:SetPoint(cbhValues.rmarksetpoint, cbh.groupHF[groupnum], cbhValues.rmarksetpoint, 0, 0)
			cbh.RaidMarker[groupnum]:SetLayer(4)
			cbh.RaidMarker[groupnum]:SetWidth(cbhValues.raidmarkersize)
			cbh.RaidMarker[groupnum]:SetHeight(cbhValues.raidmarkersize)
			cbh.RaidMarker[groupnum]:SetAlpha(0.75)

			
			-- SET PLAYER NAME POSITION AND SIZE
			cbh.groupName[groupnum]:SetPoint(cbhValues.namesetpoint, cbh.groupHF[groupnum], cbhValues.namesetpoint, 0, 0)
			cbh.groupName[groupnum]:SetLayer(4)
			cbh.groupName[groupnum]:SetFontSize(cbhValues.namesize)
			cbh.groupName[groupnum]:SetEffectGlow(cbh.NameGlowTable)

			
			-- SET STATUS FRAME POSITION AND SIZE
			cbh.groupStatus[groupnum]:SetPoint(cbhValues.statussetpoint, cbh.groupHF[groupnum], cbhValues.statussetpoint, 0, 0)
			cbh.groupStatus[groupnum]:SetLayer(4)
			cbh.groupStatus[groupnum]:SetFontSize(cbhValues.statussize)
			cbh.groupStatus[groupnum]:SetFontColor(cbhCallingColors[5].r, cbhCallingColors[5].g, cbhCallingColors[5].b, 1)
			cbh.StatusGlowTable = { blurX=3, blurY=3, colorA=1, colorB=0, colorG=0, colorR=0, knockout=false, offsetX=0, offsetY=0, replace=false, strength=5 }
			cbh.groupStatus[groupnum]:SetEffectGlow(cbh.StatusGlowTable)
			
			
			--READY CHECK SETUP
			cbh.groupRDY[groupnum]:SetPoint(cbhValues.readychecksetpoint, cbh.groupHF[groupnum], cbhValues.readychecksetpoint, 0, 0)
			cbh.groupRDY[groupnum]:SetTexture("ClickBoxHealer", "Textures/undecided.png")
			cbh.groupRDY[groupnum]:SetLayer(6)
			cbh.groupRDY[groupnum]:SetWidth(cbhValues.readychecksize)
			cbh.groupRDY[groupnum]:SetHeight(cbhValues.readychecksize)
			cbh.groupRDY[groupnum]:SetVisible(false)

			
			-- SET BOTTOM ABSORB FRAME TEXTURE AND COLOR
			cbh.groupAbsBot[groupnum]:SetPoint("BOTTOMLEFT", cbh.groupHF[groupnum], "BOTTOMLEFT", 0, 0)
			cbh.groupAbsBot[groupnum]:SetTexture("ClickBoxHealer", "Textures/"..cbhValues.texture)
			cbh.groupAbsBot[groupnum]:SetLayer(4)
			cbh.groupAbsBot[groupnum]:SetWidth(50)
			cbh.groupAbsBot[groupnum]:SetHeight(cbhValues.absheight)
			cbh.groupAbsBot[groupnum]:SetBackgroundColor(cbhCallingColors[8].r, cbhCallingColors[8].g, cbhCallingColors[8].b, cbhCallingColors[8].a)

			
			-- SETS MANA BACKGROUND SETTINGS
			cbh.groupMB[groupnum]:SetPoint("TOPLEFT", cbh.groupHF[groupnum], "BOTTOMLEFT", 0, 0)
			cbh.groupMB[groupnum]:SetLayer(4)
			cbh.groupMB[groupnum]:SetWidth(ufwidth)
			cbh.groupMB[groupnum]:SetHeight(cbhValues.mbheight)
			cbh.groupMB[groupnum]:SetBackgroundColor(0, 0, 0, 1)
			
			-- SET MANA FRAME TEXTURE, SIZE AND COLOR
			cbh.groupMF[groupnum]:SetPoint("TOPLEFT", cbh.groupHF[groupnum], "BOTTOMLEFT", 0, 0)
			cbh.groupMF[groupnum]:SetTexture("ClickBoxHealer", "Textures/"..cbhValues.texture)
			cbh.groupMF[groupnum]:SetLayer(5)
			cbh.groupMF[groupnum]:SetWidth(ufwidth)
			cbh.groupMF[groupnum]:SetHeight(cbhValues.mbheight)
			-- cbh.groupMF[groupnum]:SetBackgroundColor(0, 0, 1, 1)
			if not cbh.UnitStatus[groupnum].mana then
				cbh.groupMF[groupnum]:SetVisible(false)
				cbh.groupMB[groupnum]:SetVisible(false)
				cbh.groupBF[groupnum]:SetHeight(ufheight)
				cbh.groupHF[groupnum]:SetHeight(ufheight)
			else
				cbh.framepos[groupnum].ymb = cbh.framepos[groupnum].y-cbhValues.mbheight
				-- if cbhValues.ordervup then cbh.groupBase[groupnum]:SetPoint(cbhValues.framemount, cbh.Window, cbhValues.framemount, cbh.framepos[groupnum].x, cbh.framepos[groupnum].ymb) end
				cbh.groupMF[groupnum]:SetVisible(true)
				cbh.groupMB[groupnum]:SetVisible(true)
				cbh.groupBF[groupnum]:SetHeight(ufheight-mb)
				cbh.groupHF[groupnum]:SetHeight(ufheight-mb)
			end
			
			-- CREATE HOT BOXES AND STACK COUNTERS; HIDE THEM FOR NOW
			for x = 1, 9 do
				-- cbh.groupHoTs[groupnum][x]:SetPoint(cbh.BuffWatchLocations[x], cbh.groupBF[groupnum], cbh.BuffWatchLocations[x], 0, 0)
				cbh.groupHoTs[groupnum][x]:SetPoint(cbh.SetPoint[x], cbh.groupHF[groupnum], cbh.SetPoint[x], 0, 0)
				cbh.groupHoTs[groupnum][x]:SetTexture("ClickBoxHealer", "Textures/nbuffhot.png")
				cbh.groupHoTs[groupnum][x]:SetSecureMode("normal")
				if cbhValues.buffwarncolor then
					cbh.groupHoTs[groupnum][x]:SetBackgroundColor(cbhBuffWarnColors[cbhValues.roleset][1].r, cbhBuffWarnColors[cbhValues.roleset][1].g, cbhBuffWarnColors[cbhValues.roleset][1].b, 1)
				else
					cbh.groupHoTs[groupnum][x]:SetBackgroundColor(cbhBuffColors[cbhValues.roleset][x].r, cbhBuffColors[cbhValues.roleset][x].g, cbhBuffColors[cbhValues.roleset][x].b, 1)
				end
				cbh.groupHoTs[groupnum][x]:SetLayer(6)
				cbh.groupHoTs[groupnum][x]:SetVisible(false)
				cbh.groupHoTs[groupnum][x]:SetWidth(cbhValues.hotsize)
				cbh.groupHoTs[groupnum][x]:SetHeight(cbhValues.hotsize)

				cbh.groupHoTicon[groupnum][x]:SetPoint(cbh.SetPoint[x], cbh.groupHF[groupnum], cbh.SetPoint[x], 0, 0)
				cbh.groupHoTicon[groupnum][x]:SetWidth(cbhValues.hotsize)
				cbh.groupHoTicon[groupnum][x]:SetHeight(cbhValues.hotsize)
				cbh.groupHoTicon[groupnum][x]:SetSecureMode("normal")
				cbh.groupHoTicon[groupnum][x]:SetLayer(6)
				cbh.groupHoTicon[groupnum][x]:SetVisible(false)
				
				cbh.groupHoTstack[groupnum][x]:SetPoint("CENTER", cbh.groupHoTs[groupnum][x], "CENTER", 0, 1)
				cbh.groupHoTstack[groupnum][x]:SetFontColor(1, 1, 1, 1)
				cbh.groupHoTstack[groupnum][x]:SetText("")
				cbh.groupHoTstack[groupnum][x]:SetLayer(7)
				cbh.groupHoTstack[groupnum][x]:SetFontSize(12)
				cbh.groupHoTstack[groupnum][x]:SetEffectGlow(cbh.BuffStackGlow)
				cbh.groupHoTstack[groupnum][x]:SetVisible(false)
			end
			-- Why is this not inside the for loop? Sets HoT box positions
			-- cbh.groupHoTs[groupnum][1]:SetPoint("TOPRIGHT", cbh.groupBF[groupnum], "TOPRIGHT", -1, 1)
			-- cbh.groupHoTs[groupnum][2]:SetPoint("TOPLEFT", cbh.groupBF[groupnum], "TOPLEFT", 1, ((ufheight - cbhValues.mbheight) / 3) * 2)
			-- cbh.groupHoTs[groupnum][3]:SetPoint("TOPRIGHT", cbh.groupBF[groupnum], "TOPRIGHT", -2, ((ufheight - cbhValues.mbheight) / 3) * 2)
			-- cbh.groupHoTs[groupnum][4]:SetPoint("TOPLEFT", cbh.groupBF[groupnum], "TOPLEFT", 2, ((ufheight - cbhValues.mbheight) / 3) + 1)
			-- cbh.groupHoTs[groupnum][5]:SetPoint("TOPRIGHT", cbh.groupBF[groupnum], "TOPRIGHT", -2, ((ufheight - cbhValues.mbheight) / 3) + 1)

			-- cbh.groupHoTicon[groupnum][1]:SetPoint("TOPRIGHT", cbh.groupHoTs[groupnum][1], "TOPRIGHT", -1, 1)
			-- cbh.groupHoTicon[groupnum][2]:SetPoint("TOPLEFT", cbh.groupHoTs[groupnum][2], "TOPLEFT", 1, 1)
			-- cbh.groupHoTicon[groupnum][3]:SetPoint("TOPRIGHT", cbh.groupHoTs[groupnum][3], "TOPRIGHT", -1, 1)
			-- cbh.groupHoTicon[groupnum][4]:SetPoint("TOPLEFT", cbh.groupHoTs[groupnum][4], "TOPLEFT", 1, 1)
			-- cbh.groupHoTicon[groupnum][5]:SetPoint("TOPRIGHT", cbh.groupHoTs[groupnum][5], "TOPRIGHT", -1, 1)
			
			-- Create mask for frame
			cbh.groupMask[groupnum]:SetPoint("TOPLEFT", cbh.groupHF[groupnum], "TOPLEFT", 0, 0)
			-- cbh.groupMask[groupnum]:SetLayer(5)
			cbh.groupMask[groupnum]:SetWidth(ufwidth)
			cbh.groupMask[groupnum]:SetHeight(ufheight)
		end
	end
end



--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
--[[											MINIMAP BUTTON SETUP]]
--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]

function cbh.CreateMMB()
	cbh.WindowMMB:SetPoint("TOPLEFT", context, "TOPLEFT", cbhValues.MMBx, cbhValues.MMBy)
	cbh.WindowMMB:SetVisible(cbhValues.MMBVis)
	cbh.WindowMMB:SetTexture("ClickBoxHealer", "Textures/cbhMMB.png")
	cbh.WindowMMB:SetWidth(32)
	cbh.WindowMMB:SetHeight(32)

	local imoved = false

	cbh.WindowMMB:EventAttach(Event.UI.Input.Mouse.Right.Down, function(self, h)
		self.MouseDown = true
		local mouseData = Inspect.Mouse()
		self.sx = mouseData.x - cbh.WindowMMB:GetLeft()
		self.sy = mouseData.y - cbh.WindowMMB:GetTop()
	end, "Event.UI.Input.Mouse.Right.Down")

	cbh.WindowMMB:EventAttach(Event.UI.Input.Mouse.Cursor.Move, function(self, h)
		if self.MouseDown then
			local nx, ny
			local mouseData = Inspect.Mouse()
			nx = mouseData.x - self.sx
			ny = mouseData.y - self.sy
			if cbh.WindowMMB:GetLeft() ~= cbhValues.MMBx then
				imoved = true
			end
			cbh.WindowMMB:SetPoint("TOPLEFT", UIParent, "TOPLEFT", nx,ny)
		end
	end, "Event.UI.Input.Mouse.Cursor.Move")

	cbh.WindowMMB:EventAttach(Event.UI.Input.Mouse.Right.Up, function(self, h)
		if self.MouseDown and imoved then
			self.MouseDown = false
			imoved = false
		elseif not imoved then
			self.MouseDown = false
			cbh.ToggleLock()
		end
		cbhValues.MMBx = cbh.WindowMMB:GetLeft()
		cbhValues.MMBy = cbh.WindowMMB:GetTop()
	end, "Event.UI.Input.Mouse.Right.Up")

	cbh.WindowMMB:EventAttach(Event.UI.Input.Mouse.Left.Down, function(self, h)
		if not cbhValues.isincombat then cbh.ShowConfig() else print("Menu can't be toggled in combat.") end
	end, "Event.UI.Input.Mouse.Left.Down")

	cbh.WindowMMB:EventAttach(Event.UI.Input.Mouse.Middle.Click, function(self, h)
		cbh.ToggleWindow()
	end, "Event.UI.Input.Mouse.Left.Down")

	cbh.WindowMMB:EventAttach(Event.UI.Input.Mouse.Cursor.In, function(self, h)
		cbh.WindowMMBTip:Show(cbh.WindowMMB, "Left Click - Open Option Window \nMiddle Click - Hide/Show Frames \nRight Click - Unlock Frame \nRight Click+Drag to move button", "TOPLEFT")
	end, "Event.UI.Input.Mouse.Cursor.In")

	cbh.WindowMMB:EventAttach(Event.UI.Input.Mouse.Cursor.Out, function(self, h)
		cbh.WindowMMBTip:Hide(cbh.WindowMMB)
	end, "Event.UI.Input.Mouse.Cursor.In")
end




--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
--[[										RESET DEFAULTS WINDOW]]
--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]

function cbh.ResetWindow()
	cbh.WindowReset = UI.CreateFrame("SimpleWindow", "MainWindow", cbh.Context)
	cbh.WindowReset:SetSecureMode("restricted")
	cbh.WindowReset:SetVisible(false)

	cbh.WindowResetText = UI.CreateFrame("Text", "MainWindow", cbh.WindowReset)
	cbh.WindowResetButton = UI.CreateFrame("RiftButton", "MainWindow", cbh.WindowReset)
	cbh.WindowResetButton:SetSecureMode("restricted")

	cbh.WindowReset:SetPoint("CENTER", UIParent, "CENTER")
	cbh.WindowReset:SetTitle("Reset")
	cbh.WindowReset:SetWidth(325)
	cbh.WindowReset:SetHeight(200)

	cbh.WindowResetText:SetPoint("TOPLEFT", cbh.WindowReset, "TOPLEFT", 25, 50)
	cbh.WindowResetText:SetWidth(275)
	cbh.WindowResetText:SetHeight(100)
	cbh.WindowResetText:SetBackgroundColor(.1, .1, .1, .5)
	cbh.WindowResetText:SetWordwrap(true)
	cbh.WindowResetText:SetFontSize(16)
	cbh.WindowResetText:SetText("The changes you have made require a reloadui for these values to take effect. Click continue to reload.")

	cbh.WindowResetButton:SetPoint("CENTER", cbh.WindowReset, "CENTER", 0, 50)
	cbh.WindowResetButton:SetWidth(150)
	cbh.WindowResetButton:SetHeight(50)
	cbh.WindowResetButton:SetLayer(2)
	cbh.WindowResetButton:SetText("CONTINUE")
	cbh.WindowResetButton.Event.LeftClick = "/reloadui"
end



-- WINDOW TO LOAD MAJOR CHANGES/NEWS FOR CBH IN
function cbh.Notifications()
	-- cbh.NotifyWindow:SetSecureMode("restricted")
	cbh.NotifyWindow:SetPoint("TOPCENTER", cbh.Context, "CENTER", UIParent:GetWidth()/2, UIParent:GetTop()+100)
	cbh.NotifyWindow:SetWidth(575)
	cbh.NotifyWindow:SetBackgroundColor(0,0,0,.5)
	cbh.NotifyWindow:SetLayer(9)
	cbh.NotifyWindow:SetVisible(false)
	
	cbh.NotifyWindowTitle:SetPoint("CENTER", cbh.NotifyWindow, "TOPCENTER", 0, 0)
	cbh.NotifyWindowTitle:SetFontSize(24)
	cbh.NotifyWindowTitle:SetText("CBH Notifications")
	cbh.NotifyWindowTitle:SetEffectGlow(cbh.TitleGlowTable)

	cbh.NotifyWindowText:SetPoint("TOPCENTER", cbh.NotifyWindow, "TOPCENTER", 0, 30)
	cbh.NotifyWindowText:SetWidth(550)
	cbh.NotifyWindowText:SetBackgroundColor(0, 0, 0, .75)
	cbh.NotifyWindowText:SetWordwrap(true)
	cbh.NotifyWindowText:SetFontSize(16)
	cbh.NotifyWindowText:SetText(cbh.NotificationText)
	cbh.NotifyWindowText:SetLayer(9)
	
	cbh.NotifyWindow:SetHeight(cbh.NotifyWindowText:GetHeight()+30+30)

	-- cbh.NotifyWindowOKButton:SetSecureMode("restricted")
	cbh.NotifyWindowOKButton:SetPoint("BOTTOMCENTER", cbh.NotifyWindow, "BOTTOMCENTER", 0, 0)
	cbh.NotifyWindowOKButton:SetText("OK")
	cbh.NotifyWindowOKButton:EventAttach(Event.UI.Input.Mouse.Left.Click, function(self, h)
		cbh.NotifyWindow:SetVisible(false)
		cbhValues.notified = cbh.adetail.toc.Version
	end, "Event.UI.Input.Mouse.Left.Click")
end