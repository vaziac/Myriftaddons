--[[
file: main.lua -- Where all the magic really happens
by: Solsis00
for: ClickBoxHealer

This file contains all the core functions that do the real work, including all status changes post frame creation

**COMPLETE: Converted to local cbh table successfully.
]]--

local addon, cbh = ...


local timeFrame = _G.Inspect.Time.Frame
local lastUnitUpdate = 0
local lastBuffUpdate = 0

cbh.rolechange = true	-- Set to always force an ability check on reloadui. Role change function gets triggered by the inital load from character screen but NOT on reloaduis

function cbh.getThrottle(throttle)
	-- local lastUnitUpdate = 0
	local now = timeFrame()
	local elapsed = now - lastUnitUpdate
	if (elapsed >= throttle) then
		lastUnitUpdate = now
		return true
	end
end

cbh.unitcount = 1	-- Static unit counter. Only counted in RefreshUnit function when cbh.tempuc and this count don't match.
cbh.tempuc = 0	-- Temporary unit counter
cbh.petshow = false	-- Variable to signify whether you have <= 5 party members and pets are ok to show

function cbh.UnitUpdate(hEvent)
	if cbh.initialLoad or not cbhValues or not cbhValues.islocked then return end
	local timer = cbh.getThrottle(1)
	if not timer then return end

	cbh.tempuc = 0
	maxIndexAboveFive = false

	for i, v in pairs(cbh.UnitsTable) do
		if cbh.unitLookup(v) then
			cbh.tempuc = cbh.tempuc + 1
			if i > 5 then maxIndexAboveFive = true end
		end
	end
	if cbh.tempuc > 5 or maxIndexAboveFive then
		cbh.QueryTable = cbh.RaidTable
		cbh.petshow = false
		if not processraid then
			cbh.processMacroText(cbh.UnitsTable)
		end
	elseif cbh.tempuc > 0 and cbh.tempuc <= 5 then
		cbh.QueryTable = cbh.GroupTable
		cbh.petshow = true
		if not processgroup then
			cbh.processMacroText(cbh.UnitsGroupTable)
		end
	else
		cbh.QueryTable = cbh.SoloTable
		cbh.petshow = true
		cbh.tempuc = cbh.tempuc + 1
		if not processsolo then
			cbh.processMacroText(cbh.UnitTable)
		end
	end

	cbh.RefreshUnits()

	local details = cbh.unitDetail(cbh.QueryTable)
	
	for unitident, unitID in pairs(details) do
		local groupnum = stripnum(unitident)	-- Gets the group number of the specified unit
		-- If show pets is checked then add +5 to the group number to align pets
		if cbh.petshow and string.find(unitident, "pet") then
			groupnum = groupnum + 5
			if cbhValues.pet then cbh.tempuc = cbh.tempuc + 1 end			
		end
		
		--CHECKS FOR CHANGED UNITIDS WHEN MEMBERS ARE REPLACED BY A NEW UNIT
		if cbh.UnitStatus[groupnum].uid ~= unitID.id then --and not cbhValues.isincombat then
			cbh.UnitsChanged = true
			
			local tempj = cbh.GetIndexFromID(unitID.id)	--Clear changed units' old position in the table
			if tempj ~= nil then
				cbh.BuffUnitTable[cbh.UnitStatus[tempj].uid] = nil
				cbh.UnitStatus[tempj].uid = nil
				if not cbhValues.isincombat then cbh.groupMask[tempj]:SetMouseoverUnit(nil) end
			end
			
			--Pass this info over to create the updated table and frame
			cbh.ClearIndex(hEvent, unitident, groupnum)
			
			--If this unit was the player's target, re-apply the target indicator
			cbh.UnitChange(cbh.unitLookup("player.target"))
			if cbhTargetValues.enabled then cbh.TargetUnitChange(cbh.unitLookup("player.target")) end
			
			--Hide absorb frame, set back to standard color
			cbh.groupAbsBot[groupnum]:SetAlpha(0)
			cbh.groupAbsBot[groupnum]:SetBackgroundColor(cbhCallingColors[8].r, cbhCallingColors[8].g, cbhCallingColors[8].b, cbhCallingColors[8].a)
		end	--End of changed unit checks
		
		--	Sets mouseover info if not set
		if cbh.UnitStatus[groupnum].uid ~= nil then
			if cbh.groupMask[groupnum]:GetMouseoverUnit() == nil or cbh.groupMask[groupnum]:GetMouseoverUnit() ~= unitID.id then
				if not cbhValues.isincombat then
					cbh.groupMask[groupnum]:SetMouseoverUnit(unitID.id)
				end
			end
		end
		
		if not unitID.offline then
			--[[ 1.) what about doing the math part ddx = ... in the event.unit.coord and just doing a compare here? ]]--
			if cbh.tempuc > 1 and cbhValues.rangecheck then	-- New range check system
				if not unitID.blocked then
					if unitID.id ~= cbh.playerinfo.id and unitID.coordX ~= nil and cbh.playerinfo.coordX ~= nil then
						local ddx = ((cbh.playerinfo.coordX - unitID.coordX)^2)+((cbh.playerinfo.coordZ - unitID.coordZ)^2)
						if ddx ~= nil then
							if ddx > cbh.rangevalue then --and not cbh.UnitStatus[groupnum].outofrange then
								cbh.UnitStatus[groupnum].outofrange = true
								if cbhValues.hideooc then
									cbh.HideOutofCombat(groupnum, cbh.UnitStatus[groupnum].outofrange)
								elseif cbh.UnitStatus[groupnum].oocalpha ~= cbhValues.alphasetting then
									cbh.groupBase[groupnum]:SetAlpha(cbhValues.alphasetting)
									cbh.UnitStatus[groupnum].oocalpha = cbhValues.alphasetting
								end
							elseif ddx <= cbh.rangevalue then --and cbh.UnitStatus[groupnum].outofrange then
								cbh.UnitStatus[groupnum].outofrange = false
								if cbhValues.hideooc and not cbh.UnitStatus[groupnum].istarget then
									cbh.HideOutofCombat(groupnum, cbh.UnitStatus[groupnum].outofrange)
								elseif cbh.UnitStatus[groupnum].oocalpha ~= 1 then
									cbh.groupBase[groupnum]:SetAlpha(1)
									cbh.UnitStatus[groupnum].oocalpha = 1
								end
							end
						end
					end
				end
			end
		end
	end
end


function cbh.RefreshUnits(x)
	if cbh.unitcount ~= cbh.tempuc or x == 1 then
		cbh.unitcount = 0
		for n, unitI in pairs(cbh.UnitsTable) do
			if cbh.unitLookup(unitI) == nil then
				if cbh.groupBase[n]:GetVisible() or cbh.groupSel[n]:GetVisible() then
					cbh.groupBase[n]:SetVisible(false)
					cbh.groupSel[n]:SetVisible(false)
				end
				if not cbhValues.isincombat then cbh.groupMask[n]:SetVisible(false) end
			else
				cbh.unitcount = cbh.unitcount + 1
				cbh.groupBase[n]:SetVisible(true)
				-- cbh.groupSel[n]:SetVisible(true)
				if not cbhValues.isincombat then cbh.groupMask[n]:SetVisible(true) end
			end
		end
		if cbh.unitcount == 0 then	-- Solo check to make visible
			cbh.unitcount = 1
			cbh.groupBase[1]:SetVisible(true)
			-- cbh.groupSel[1]:SetVisible(true)
			if not cbhValues.isincombat then cbh.groupMask[1]:SetVisible(true) end
			if cbh.unitLookup("player.pet") and cbhValues.pet and cbh.petshow then
				cbh.unitcount = cbh.unitcount + 1
				cbh.groupBase[6]:SetVisible(true)
				-- cbh.groupSel[6]:SetVisible(true)
				if not cbhValues.isincombat then cbh.groupMask[6]:SetVisible(true) end
			end
		end
		if cbhValues.pet and cbh.unitcount <= 5 and cbh.petshow then	-- Checks for any current pets and displays them
			for i = 1, 5 do
				local temppet = string.format("group%.2d", i)..".pet"
				if cbh.unitLookup(temppet) then
					cbh.unitcount = cbh.unitcount + 1
					cbh.groupBase[i+5]:SetVisible(true)
					-- cbh.groupSel[i+5]:SetVisible(true)
					if not cbhValues.isincombat then cbh.groupMask[i + 5]:SetVisible(true) end
				end
			end
		end
		-- if cbh.tempuc > 5 or maxIndexAboveFive then
			-- if not processraid then
				-- cbh.processMacroText(cbh.UnitsTable)
			-- end
		-- elseif cbh.tempuc > 0 and cbh.tempuc <= 5 then
			-- if not processgroup then
				-- cbh.processMacroText(cbh.UnitsGroupTable)
			-- end
		-- else
			-- if not processsolo then
				-- cbh.processMacroText(cbh.UnitTable)
			-- end
		-- end
	end
end




--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
--[[												START RECODE HERE]]
--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
function cbh.ClearIndex(hEvent, unitident, unitnum)
	maxIndexAboveFive = false

	local ufwidth = cbhValues.ufwidth
	local ufheight = cbhValues.ufheight
	local mb = cbhValues.mbheight
	
	local groupnum = unitnum
	local unitID = cbh.unitDetail(unitident)
	
	cbh.UnitStatus[groupnum] = {
		uid = unitID.id,
		groupid = groupnum,	-- Stored only to cross-ref unitIDs to there group location from the cbh.GetIndexFromID() function
		istarget = nil,
		isfriendly = unitID.friendly,
		oocalpha = nil,

		name = unitID.name,
		role = unitID.role,
		calling = unitID.calling,
		raidmark = unitID.mark,
		
		aggro = unitID.aggro,
		offline = unitID.offline,
		dead = nil,
		los = nil,	-- unitID.blocked
		outofrange = nil,
		warfront = nil,
		
		xcoord = unitID.coordX,
		ycoord = unitID.coordY,
		health = unitID.health,
		healthmax = unitID.healthMax,
		healthcap = unitID.healthCap,
		mana = unitID.mana,
		manamax = unitID.manaMax,
		
		haswhitedebuff = nil,
		whitedebuffqty = 0,
		poisonqty = 0,
		curseqty = 0,
		diseaseqty = 0,
		hasdebuffs = false,
		hasburnout = false,
	}
	
	-- Sets the unit id into a table for our functions to read it properly
	local tempID = {}
	-- Catch offline or warfront units after a reloadui
	-- if unitID.offline then
		-- tempID[unitID.id] = unitID.offline
		-- cbh.OnlineStatusUpdate(x, tempID)
	-- elseif unitID.warfront then
		-- tempID[unitID.id] = unitID.warfront
		-- cbh.WFcheck(x, tempID)
	-- elseif unitID.blocked then
		-- tempID[unitID.id] = unitID.blocked
		-- cbh.LoSUpdate(x, tempID)
	-- end

	cbh.BuffUnitTable[unitID.id] = nil

	if not cbhValues.isincombat then cbh.groupMask[groupnum]:SetMouseoverUnit(unitID.id) end
	
	for i = 1, 4 do
		if unitID.calling == cbh.Calling[i] then
			cbh.groupName[groupnum]:SetFontColor(cbhCallingColors[i].r, cbhCallingColors[i].g, cbhCallingColors[i].b, 1)
			if cbhValues.manaCC then
				cbh.groupMF[groupnum]:SetBackgroundColor(cbhCallingColors[i].r, cbhCallingColors[i].g, cbhCallingColors[i].b, 1)
			end
		elseif unitID.calling == nil then
			cbh.groupName[groupnum]:SetFontColor(.8, .8, .8, 1)
		end
	end
	
	if not cbhValues.manaCC then
		cbh.groupMF[groupnum]:SetBackgroundColor(0.25,0.25,1,1)
	end

	if cbhValues.debuffcolorwhole then
		cbh.groupHF[groupnum]:SetBackgroundColor(cbhCallingColors[7].r, cbhCallingColors[7].g, cbhCallingColors[7].b, cbhCallingColors[7].a)
	else
		cbh.groupStatus[groupnum]:SetBackgroundColor(0, 0, 0, 0)
	end

	-- if unitID.role then cbh.groupRole[groupnum]:SetTexture("ClickBoxHealer", "Textures/"..unitID.role..".png") end
	if unitID.role then cbh.groupRole[groupnum]:SetTexture("Rift", cbh.RoleImgs[unitID.role]) end

	if unitID.id == cbh.playerinfo.id then
		cbh.UnitStatus[groupnum].los = false		--not in los
		cbh.UnitStatus[groupnum].outofrange = false	--out of range
		cbh.playerinfo.coordX = unitID.coordX
		cbh.playerinfo.coordZ = unitID.coordZ
		if not cbhValues.hideooc then
			cbh.groupBase[groupnum]:SetAlpha(1)
		end
		-- cbh.HideOutofCombat(groupnum, cbh.UnitStatus[groupnum].outofrange)
	-- else
		-- if cbh.UnitStatus[groupnum].los then
			-- cbh.HideOutofCombat(groupnum, cbh.UnitStatus[groupnum].los)
		-- elseif cbh.UnitStatus[groupnum].outofrange then
			-- cbh.HideOutofCombat(groupnum, cbh.UnitStatus[groupnum].outofrange)
		-- else
			-- cbh.HideOutofCombat(groupnum, cbh.UnitStatus[groupnum].los)
		-- end
	end

	if cbhValues.hideooc then
		if cbh.UnitStatus[groupnum].los then
			cbh.HideOutofCombat(groupnum, cbh.UnitStatus[groupnum].los)
		elseif cbh.UnitStatus[groupnum].outofrange then
			cbh.HideOutofCombat(groupnum, cbh.UnitStatus[groupnum].outofrange)
		else
			cbh.HideOutofCombat(groupnum, cbh.UnitStatus[groupnum].los)
		end
	end
	
	if unitID.mark ~= nil then
		cbh.RaidMarker[groupnum]:SetTexture("Rift", cbh.RaidMarkerImages[unitID.mark])
		cbh.RaidMarker[groupnum]:SetVisible(true)
	else
		cbh.RaidMarker[groupnum]:SetVisible(false)
	end

	if unitID.manaMax ~= nil then
		cbh.framepos[groupnum].ymb = cbh.framepos[groupnum].y-cbhValues.mbheight
		-- if cbhValues.ordervup then cbh.groupBase[groupnum]:SetPoint(cbhValues.framemount, cbh.Window, cbhValues.framemount, cbh.framepos[groupnum].x, cbh.framepos[groupnum].ymb) end
		cbh.groupMB[groupnum]:SetVisible(true)
		cbh.groupMF[groupnum]:SetVisible(true)
		cbh.groupBF[groupnum]:SetHeight(ufheight-mb)
		cbh.groupHF[groupnum]:SetHeight(ufheight-mb)
	else
		-- if cbhValues.ordervup then cbh.groupBase[groupnum]:SetPoint(cbhValues.framemount, cbh.Window, cbhValues.framemount, cbh.framepos[groupnum].x, cbh.framepos[groupnum].y) end
		cbh.groupMB[groupnum]:SetVisible(false)
		cbh.groupMF[groupnum]:SetVisible(false)
		cbh.groupBF[groupnum]:SetHeight(ufheight)
		cbh.groupHF[groupnum]:SetHeight(ufheight)
	end
	
	-- Hides any previous buff tracking that was on that frame
	for i = 1, 9 do
		cbh.groupHoTs[groupnum][i]:SetVisible(false)
		cbh.groupHoTicon[groupnum][i]:SetVisible(false)
		cbh.groupHoTstack[groupnum][i]:SetVisible(false)
	end

	-- Reset aggro indicator
	if not unitID.aggro then
		cbh.groupAggro[groupnum]:SetVisible(false)
	else
		cbh.groupAggro[groupnum]:SetVisible(true)
	end
	
	cbh.nameCalc(unitID.name, groupnum)
	tempID[unitID.id] = unitID.health
	cbh.UpdateHP(hEvent, tempID, unitID.healthMax)
	tempID[unitID.id] = unitID.mana
	cbh.UpdateMB(hEvent, tempID)
	cbh.BuffAdding(hEvent, unitID.id, cbh.buffList(unitID.id))

	-- Catch offline or warfront units after a reloadui
	if unitID.offline then
		tempID[unitID.id] = unitID.offline
		cbh.OnlineStatusUpdate(x, tempID)
	elseif unitID.warfront then
		tempID[unitID.id] = unitID.warfront
		cbh.WFcheck(x, tempID)
	elseif unitID.blocked then
		tempID[unitID.id] = unitID.blocked
		cbh.LoSUpdate(x, tempID)
	end

	cbh.RefreshUnits(1)
end



function cbh.ContextMenu(xid)
	Command.Unit.Menu(xid)
end


-- throttle function for the buff monitoring system
function cbh.buffwatchThrottle(throttle)
	-- local lastUnitUpdate = 0
	local now = timeFrame()
	local elapsed = now - lastBuffUpdate
	if (elapsed >= throttle) then
		lastBuffUpdate = now
		return true
	end
end

-- set this up on it's own system.update trigger
function cbh.HotWatch(blankevent)
	if cbh.initialLoad or not cbhValues or not cbhValues.islocked then return end
	local timer = cbh.buffwatchThrottle(0.25)
	if not timer then return end
	for k, v in pairs(cbh.BuffUnitTable) do
		local groupnum = cbh.GetIndexFromID(k)
		local unit = k
	-- if cbh.BuffUnitTable[unit] ~= nil then
		for buffid, buffinfo in pairs(cbh.BuffUnitTable[unit]) do
			if cbh.UnitStatus[groupnum] ~= nil and cbh.BuffUnitTable[unit][buffid].duration and cbh.BuffUnitTable[unit][buffid].begin and cbh.BuffUnitTable[unit][buffid].remaining and cbh.BuffUnitTable[unit][buffid].slot then
				cbh.BuffUnitTable[unit][buffid].remaining = cbh.BuffUnitTable[unit][buffid].duration - (timeFrame() - cbh.BuffUnitTable[unit][buffid].begin)				
				if cbh.BuffUnitTable[unit][buffid].remaining > 15 then	-- here temporarily to catch buff changes in the options window
					for k = 1, 9 do
						if cbhBuffListA[cbhValues.roleset][k] == buffinfo.name and cbh.UnitStatus[groupnum].uid then
							if cbhValues.bufficons then --and cbh.UnitStatus[groupnum].uid then
								cbh.groupHoTicon[groupnum][cbh.BuffUnitTable[unit][buffid].slot]:SetVisible(true)
							else
								cbh.groupHoTs[groupnum][cbh.BuffUnitTable[unit][buffid].slot]:SetVisible(true)
							end
						end
					end
				end

				if cbh.UnitStatus[groupnum].uid then
					if cbh.BuffUnitTable[unit][buffid].remaining < 10 and cbhValues.bufffade then
						if cbhValues.bufficons then
							cbh.groupHoTicon[groupnum][cbh.BuffUnitTable[unit][buffid].slot]:SetAlpha((cbh.BuffUnitTable[unit][buffid].remaining) /8)
						else
							cbh.groupHoTs[groupnum][cbh.BuffUnitTable[unit][buffid].slot]:SetAlpha((cbh.BuffUnitTable[unit][buffid].remaining) /8)
						end
					elseif cbh.BuffUnitTable[unit][buffid].remaining < 3 and cbhValues.buffflash then
						if cbhValues.bufficons then --and cbh.BuffUnitTable[unit] then
							cbh.groupHoTicon[groupnum][cbh.BuffUnitTable[unit][buffid].slot]:SetVisible(not cbh.groupHoTicon[groupnum][cbh.BuffUnitTable[unit][buffid].slot]:GetVisible())
						else
							cbh.groupHoTs[groupnum][cbh.BuffUnitTable[unit][buffid].slot]:SetVisible(not cbh.groupHoTs[groupnum][cbh.BuffUnitTable[unit][buffid].slot]:GetVisible())
						end
					end
				end
				
				if cbh.UnitStatus[groupnum].uid then
					if not cbhValues.bufficons and cbhValues.buffwarncolor then
						if cbh.BuffUnitTable[unit][buffid].remaining < 3 then
							cbh.groupHoTs[groupnum][cbh.BuffUnitTable[unit][buffid].slot]:SetBackgroundColor(cbhColorGlobal[cbhValues.roleset][3].r, cbhColorGlobal[cbhValues.roleset][3].g, cbhColorGlobal[cbhValues.roleset][3].b)
						elseif cbh.BuffUnitTable[unit][buffid].remaining < 5 then
							cbh.groupHoTs[groupnum][cbh.BuffUnitTable[unit][buffid].slot]:SetBackgroundColor(cbhColorGlobal[cbhValues.roleset][2].r, cbhColorGlobal[cbhValues.roleset][2].g, cbhColorGlobal[cbhValues.roleset][2].b)
						elseif cbh.BuffUnitTable[unit][buffid].stack ~= nil then
							cbh.groupHoTs[groupnum][cbh.BuffUnitTable[unit][buffid].slot]:SetBackgroundColor(cbhColorGlobal[cbhValues.roleset][1].r, cbhColorGlobal[cbhValues.roleset][1].g, cbhColorGlobal[cbhValues.roleset][1].b)
						end
					end
				end
			end
		end
	end
end


function cbh.HideOutofCombat(groupnum, oor)
	if oor then
		if cbhValues.hideooc then
			if not cbhValues.isincombat and cbh.UnitStatus[groupnum].oocalpha ~= cbhValues.oocalpha then
				cbh.groupBF[groupnum]:SetAlpha(cbhValues.oocalpha - 0.05)
				cbh.UnitStatus[groupnum].oocalpha = cbhValues.oocalpha
			elseif cbhValues.isincombat and cbh.UnitStatus[groupnum].oocalpha ~= cbhValues.alphasetting then
				cbh.groupBF[groupnum]:SetAlpha(cbhValues.alphasetting)
				cbh.UnitStatus[groupnum].oocalpha = cbhValues.alphasetting
			end
		else
		
		end
	else
		if cbhValues.hideooc then
			if not cbhValues.isincombat and cbh.UnitStatus[groupnum].oocalpha ~= cbhValues.oocalpha then
				cbh.groupBF[groupnum]:SetAlpha(cbhValues.oocalpha)
				cbh.UnitStatus[groupnum].oocalpha = cbhValues.oocalpha
			elseif cbhValues.isincombat and cbh.UnitStatus[groupnum].oocalpha ~= 1 then
				cbh.groupBF[groupnum]:SetAlpha(1)
				cbh.UnitStatus[groupnum].oocalpha = 1
			end
		else
		
		end
	end
end




-- local function cbhPartialUpdate(hEvent, units)
	-- for k, v in pairs(cbh.QueryTable) do
		-- if units[cbh.unitLookup(k)] then
			-- print("Partial Avail Unit")
			-- local groupnum = stripnum(k)
			-- cbh.ClearIndex(hEvent, k, groupnum)
		-- end
	-- end
-- end



function cbh.GetIndexFromID(ID)	-- Retrieves groupXX frameID based off of the stored unitID.id
    for v, g in pairs(cbh.UnitStatus) do
        if g.uid == ID then
            return (g.groupid)
        end
    end
    return nil
end


function stripnum(name)
    local j
    if name == "player" or name == "player.pet" then j = 1
    else j = tonumber(string.sub(name, string.find(name, "%d%d"))) end
    return j
end


function getIdentifierFromIndex(index)
	local counter=1
	for id,ph in pairs(cbh.QueryTable) do
		if counter==index then
			return id
		end
	end
	return nil
end


function cbh.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end


-- Set # of characters to show for unit name text
function cbh.nameCalc(name, unitpos, frame)
	local length
	if frame == "player" and cbhPlayerValues.enabled then
		if cbhPlayerValues.namelengthauto then
			local x = cbhPlayerValues.namefontsize / cbhPlayerValues.fwidth
			length = math.floor(1/x)
		else
			length = cbhPlayerValues.namelength
		end
		if string.len(name) > length then name = string.sub(name, 1, length)..".." end
		cbh.PlayerName:SetText(name)
	elseif frame == "target" and cbhTargetValues.enabled then
		if cbhTargetValues.namelengthauto then
			local x = cbhTargetValues.namefontsize / cbhTargetValues.fwidth
			length = math.floor(1/x)
		else
			length = cbhTargetValues.namelength
		end
		if string.len(name) > length then name = string.sub(name, 1, length)..".." end
		cbh.TargetName:SetText(name)
	else
		if cbhValues.namelengthauto then
			local x = cbhValues.namesize / cbhValues.ufwidth
			length = math.floor(1/x)
		else	
			length = cbhValues.namelength
		end
		if string.len(name) > length then name = string.sub(name, 1, length)..".." end
		cbh.groupName[unitpos]:SetText(name)
	end
end


function cbh.processMacroText(table)
	ttcat = {}
	tt = {}
	
	processsolo, processgroup, processraid = false, false, false
	if cbhValues.isincombat then return end
	for v, k in pairs(table) do
		tnum = stripnum(k)
		if (cbh.tempuc <= 5) and string.find(k, "pet") then tnum = tnum + 5 end
		for i = 1, 7 do
			if string.find(cbhMacroText[cbhValues.roleset][i], "\13") then
				-- if cbhMacroText[cbhValues.roleset][i]["stopcasting"] then
					-- tt[i] = "suppressmacrofailures\13"..cbhMacroText[cbhValues.roleset][i]
				-- else
					tt[i] = "suppressmacrofailures\13"..cbhMacroText[cbhValues.roleset][i]
				-- end
				tt[i] = string.gsub(string.gsub(tt[i], "##", "@" .. k), "\13", "\n")
			elseif string.find(cbhMacroText[cbhValues.roleset][i], "group##") then
				tt[i] = string.gsub(cbhMacroText[cbhValues.roleset][i], "@group##", "@"..k)
			elseif string.find(cbhMacroText[cbhValues.roleset][i], "##") then
				tt[i] = string.gsub(cbhMacroText[cbhValues.roleset][i], "##", "@"..k)
			else
				tt[i] = cbhMacroText[cbhValues.roleset][i]
			end
		end
		cbh.groupText[tnum] = "MBL - "..tt[1]..cbh.lf.."MBR - "..tt[2]..cbh.lf.."MBM - "..tt[3]..cbh.lf.."MB4 - "..tt[4]..cbh.lf.."MB5 - "..tt[5]..cbh.lf.."WU - "..tt[6]..cbh.lf.."WD - "..tt[7]
		
		
		
		
		--move this part into a separate function called updatemacrosclicks or something. then call it whenever los or outofrange gets changed.
		cbh.groupMask[tnum].Event.LeftClick = tt[1]
		if not cbhValues.cmenu then
			cbh.groupMask[tnum].Event.RightClick = tt[2]
		elseif cbhValues.cmenu then
			cbh.groupMask[tnum].Event.RightClick = function(self)
				cbh.ContextMenu(cbh.mouseoverunit) end
		end
		cbh.groupMask[tnum].Event.MiddleClick = tt[3]
		cbh.groupMask[tnum].Event.Mouse4Click = tt[4]
		cbh.groupMask[tnum].Event.Mouse5Click = tt[5]
		cbh.groupMask[tnum].Event.WheelForward = tt[6]
		cbh.groupMask[tnum].Event.WheelBack = tt[7]
		--may only need done for raid frames ^^^^ test theory later on target.
	end

	for var = 1, 20 do
		if cbhValues.showtooltips then
			-- cbh.groupMask[var]:EventAttach(Event.UI.Input.Mouse.Cursor.In, function(self, h)
				-- cbh.GenericTooltip:Show(cbh.groupBF[var], cbh.groupText[var])
			-- end, "Event.UI.Input.Mouse.Cursor.In")
			-- cbh.groupMask[var]:EventAttach(Event.UI.Input.Mouse.Cursor.Out, function(self, h)
				-- cbh.GenericTooltip:Hide(cbh.groupBF[var])
			-- end, "Event.UI.Input.Mouse.Cursor.Out")
			cbh.groupTooltip[var]:InjectEvents(cbh.groupMask[var], function() return cbh.groupText[var] end)
		else
			cbh.groupTooltip[var]:RemoveEvents(cbh.groupMask[var], function() return cbh.groupText[var] end)
		end
	end
	if table == cbh.UnitTable then processsolo = true end	
	if table == cbh.UnitsTable then processraid = true end
	if table == cbh.UnitsGroupTable then processgroup = true end	
	-- cbh.processtargetmacro()
end


function cbh.processtargetmacro()
	if cbhTargetValues.macros then
		attarget = {}

		for i = 1, 7 do
			if string.find(cbhMacroText[cbhValues.roleset][i], "\13") then
				-- if cbhMacroText[cbhValues.roleset][i]["stopcasting"] then
					-- tt[i] = "suppressmacrofailures\13"..cbhMacroText[cbhValues.roleset][i]
				-- else
					attarget[i] = "suppressmacrofailures\13"..cbhMacroText[cbhValues.roleset][i]
				-- end
				attarget[i] = string.gsub(string.gsub(attarget[i], "##", "@target"), "\13", "\n")
			elseif string.find(cbhMacroText[cbhValues.roleset][i], "group##") then
				attarget[i] = string.gsub(cbhMacroText[cbhValues.roleset][i], "@group##", "@target")
			elseif string.find(cbhMacroText[cbhValues.roleset][i], "##") then
				attarget[i] = string.gsub(cbhMacroText[cbhValues.roleset][i], "##", "@target")
			else
				print("NOTHING")
				attarget[i] = cbhMacroText[cbhValues.roleset][i]
			end
		end
		cbh.TargetClick.Event.LeftClick = attarget[1]
		if not cbhValues.cmenu then
			cbh.TargetClick.Event.RightClick = attarget[2]
		elseif cbhValues.cmenu then
			cbh.TargetClick.Event.RightClick = function(self)
				if cbh.unitLookup("player.target") then cbh.ContextMenu("player.target") end
			end
		end
		cbh.TargetClick.Event.MiddleClick = attarget[3]
		cbh.TargetClick.Event.Mouse4Click = attarget[4]
		cbh.TargetClick.Event.Mouse5Click = attarget[5]
		cbh.TargetClick.Event.WheelForward = attarget[6]
		cbh.TargetClick.Event.WheelBack = attarget[7]
	end
end


function cbh.frameclickupdate()


end



--[[	WILL USE LATER. Rage mentioned looking at raidcooldowns addons. It uses a global table between the addon among other people in the group. I might be able to use this to pick up when people are casting rezzes on other players.	]]--
-- Command.Event.Attach(Event.Unit.Castbar, cbh.CastBarTest, "TESTCASTING")
-- function cbh.CastBarTest(blank, units)
	-- for unit, value in pairs(units) do
		-- if value then
			-- local frame = cbh.GetIndexFromID(unit)
			-- if frame ~= nil then
				-- local castdetails = uCast(unit)
					-- if castdetails.abilityname == "Ascended Resurrection" then
						-- print("Casting REZ on ##")
					-- end
				-- dump(castdetails)
			-- end
		-- end
	-- end
-- end


--[[
find:			(UnitStatus.*\])\[1\]
replace:	\1\.aggro
]]--

--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
--[[													END RECODE HERE]]
--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]

