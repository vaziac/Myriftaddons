--[[
file: events.lua
by: Solsis00
for: ClickBoxHealer

Contains all the events and their trigger functions.

**COMPLETE: Converted to local cbh table successfully.
]]--

local addon, cbh = ...


--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
--			EVENT CALLS FROM EVENT TABLE
--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
-- Triggers from unit.Availability.full
function cbh.UpdateIndex(hEvent, units)
	if cbh.initialLoad and units[cbh.unitLookup("player")] then
		cbhValues.roleset = Inspect.TEMPORARY.Role()
		-- cbh.playerinfo = cbh.unitDetail("player")
		cbh.initialLoad = false
	end
	for k, v in pairs(cbh.QueryTable) do
		if units[cbh.unitLookup(k)] then
			local groupnum = stripnum(k)
			cbh.ClearIndex(hEvent, k, groupnum)
		end
	end
end


function cbh.CombatEnter()
	cbhValues.isincombat = true
	if not cbhValues.islocked  then
		cbhValues.islocked = true
		cbh.FrameLocked(true)
	end
	if cbhValues.hideooc then
		for groupnum = 1, 20 do
			if cbh.UnitStatus[groupnum].los then
				cbh.HideOutofCombat(groupnum, cbh.UnitStatus[groupnum].los)
			elseif cbh.UnitStatus[groupnum].outofrange then
				cbh.HideOutofCombat(groupnum, cbh.UnitStatus[groupnum].outofrange)
			else
				cbh.HideOutofCombat(groupnum, cbh.UnitStatus[groupnum].los)
			end
			-- cbh.HideOutofCombat(groupnum, cbh.UnitStatus[groupnum].outofrange)
			-- cbh.groupBF[groupnum]:SetAlpha(1)
			-- cbh.UnitStatus[groupnum].oocalpha = nil
			-- cbh.groupBF[x]:SetAlpha(1)
		end
	end
end


function cbh.CombatLeave()
	cbhValues.isincombat = false
	cbh.RefreshUnits(1) -- Redraw the frames, in case anyone joined in combat and the mask hasn't been set.
	if cbh.UnitsChanged then 
		for i, v in pairs(cbh.QueryTable) do
			if cbh.unitLookup(i) then
				local groupnum = cbh.GetIndexFromID(cbh.unitLookup(i))
				if groupnum ~= nil then
					cbh.ClearIndex(hEvent, cbh.unitLookup(i), groupnum)
				end
			end
		end
	end
	if cbhValues.hideooc then
		for groupnum = 1, 20 do
			if not cbhValues.isincombat and cbh.UnitStatus[groupnum].oocalpha ~= cbhValues.oocalpha then
				cbh.groupBase[groupnum]:SetAlpha(cbhValues.oocalpha - 0.05)
				cbh.UnitStatus[groupnum].oocalpha = cbhValues.oocalpha
			end
		-- cbh.groupBF[x]:SetAlpha(0)
		end
	end
end



function cbh.UnitMouseOver(units)
	cbh.mouseoverunit = units
end


function cbh.UpdateHP(hEvent, units, maxhp)
	for k, v in pairs(units) do
		local groupnum = cbh.GetIndexFromID(k)
		if groupnum ~= nil then
			if v > 0 then cbh.UnitStatus[groupnum].dead = false end
			cbh.UnitStatus[groupnum].health = v
			if maxhp then cbh.UnitStatus[groupnum].healthmax = maxhp end
			-- local healthcalc = (v / cbh.UnitStatus[groupnum].healthmax)
			-- cbh.groupHF[groupnum]:SetWidth(cbhValues.ufwidth * healthcalc)
			local healthcalc = (cbh.UnitStatus[groupnum].health / cbh.UnitStatus[groupnum].healthmax)
			local healthtick = (-healthcalc * cbhValues.ufwidth)
			if healthtick < cbhValues.ufwidth then healthtick = healthtick + cbhValues.ufwidth end
			cbh.groupBF[groupnum]:SetWidth(healthtick)
			-- cbh.groupHF[groupnum]:SetWidth(cbhValues.ufwidth * healthcalc)
			if cbhValues.healthgradient then
				if cbhValues.debuffcolorwhole == false or cbh.UnitStatus[groupnum].hasdebuffs == false then
					if healthcalc < .4 then
						cbh.groupHF[groupnum]:SetBackgroundColor(1, 0, 0)
					elseif healthcalc < .75 then
						cbh.groupHF[groupnum]:SetBackgroundColor(1, 1, 0)
					else
						cbh.groupHF[groupnum]:SetBackgroundColor(cbhCallingColors[7].r, cbhCallingColors[7].g, cbhCallingColors[7].b, cbhCallingColors[7].a)
					end
				end
			end
			if cbh.UnitStatus[groupnum].health <= 0 or math.ceil(healthcalc) == 0 then
				cbh.groupStatus[groupnum]:SetText("DEAD")
				cbh.UnitStatus[groupnum].dead = true
			elseif cbhValues.hidehealth == false then
				if cbhValues.statusdisplay == "Deficit" then
					local healthdef = tostring(cbh.UnitStatus[groupnum].health - cbh.UnitStatus[groupnum].healthmax)
					if healthdef ~= "0" then
						cbh.groupStatus[groupnum]:SetText(healthdef)
					else
						cbh.groupStatus[groupnum]:SetText("")
					end
				elseif cbhValues.statusdisplay == "Health" then
					local health = tostring(cbh.UnitStatus[groupnum].health)
					cbh.groupStatus[groupnum]:SetText(health)
				else
					healthpercent = math.ceil(healthcalc * 100)
					cbh.groupStatus[groupnum]:SetText(healthpercent.."%")
				end
			else
				cbh.groupStatus[groupnum]:SetText("")
			end
		end
	end
end


function cbh.UpdateHPMax(hEvent, units)
	local tempID = {}
	for k, v in pairs(units) do
		local groupnum = cbh.GetIndexFromID(k)
		if groupnum ~= nil then
			cbh.UnitStatus[groupnum].healthmax = v
			if not cbh.UnitStatus[groupnum].dead then
				tempID[k] = cbh.UnitStatus[groupnum].health
				cbh.UpdateHP(hEvent, tempID)
			end
		end
	end
end


function cbh.UpdateHPCap(bEvent, units)
	for k, v in pairs(units) do
		local groupnum = cbh.GetIndexFromID(k)
		if groupnum ~= nil then
			cbh.UnitStatus[groupnum].healthcap = v
			if v ~= cbh.UnitStatus[groupnum].healthmax then
				cbh.UnitStatus[groupnum].healthcap = v
				cbh.groupHPCap[groupnum]:SetVisible(true)
				local healthx = cbhValues.ufwidth*(v/cbh.UnitStatus[groupnum].healthmax)
				cbh.groupHPCap[groupnum]:SetPoint("TOPCENTER", cbh.groupHF[groupnum], "TOPLEFT", healthx, 0)
			else
				cbh.UnitStatus[groupnum].healthmax = v
				cbh.groupHPCap[groupnum]:SetVisible(false)
			end
		end
	end
end



function cbh.UpdateMB(hEvent, units)
	for k, v in pairs(units) do
		local groupnum = cbh.GetIndexFromID(k)
		if groupnum ~= nil then
			cbh.UnitStatus[groupnum].mana = v
			local manamax = cbh.UnitStatus[groupnum].manamax
			if cbh.UnitStatus[groupnum].mana ~= nil and manamax ~= nil then
				cbh.groupMF[groupnum]:SetWidth((cbhValues.ufwidth)*(cbh.UnitStatus[groupnum].mana/manamax))
			end
			if not cbh.UnitStatus[groupnum].mana then
				cbh.UnitStatus[groupnum].mana = true
				cbh.groupMB[groupnum]:SetVisible(true)
				cbh.groupMF[groupnum]:SetVisible(true)
				cbh.groupHF[groupnum]:SetHeight(cbhValues.ufheight - cbhValues.mbheight)
				-- cbhAdjustAbsBar(j, 1)
			end
		-- elseif j ~= nil and unitID.mana == nil then
			-- cbhAdjustAbsBar(j, 0)
		end
    end
end



function cbh.UpdateMBMax(hEvent, units)
	local tempID = {}
	for k, v in pairs(units) do
		local groupnum = cbh.GetIndexFromID(k)
		if groupnum ~= nil then
			cbh.UnitStatus[groupnum].manamax = v
			if not cbh.UnitStatus[groupnum].dead then
				tempID[k] = cbh.UnitStatus[groupnum].mana
				cbh.UpdateMB(hEvent, tempID)
			end
		end
	end
end



function cbh.Mentored(hEvent, units)
	local tempID = {}
    local details = cbh.unitDetail(units)
    for unitName, unitID in pairs(details) do
        local groupnum = cbh.GetIndexFromID(unitID.id)
		if groupnum ~= nil then
			cbh.UnitStatus[groupnum].healthmax = unitID.healthMax
			cbh.UnitStatus[groupnum].manamax = unitID.manaMax
			tempID[unitID.id] = unitID.mana
			cbh.UpdateMB(hEvent, tempID)
			tempID[unitID.id] = unitID.health
			cbh.UpdateHP(hEvent, tempID)
		end
	end
end



function cbh.aggroUpdate(hEvent, units)
	for k, v in pairs(units) do
		local groupnum = cbh.GetIndexFromID(k)
		if groupnum ~= nil then
			cbh.UnitStatus[groupnum].aggro = v
			if cbh.UnitStatus[groupnum].aggro then
				cbh.groupAggro[groupnum]:SetVisible(true)
			else
				cbh.groupAggro[groupnum]:SetVisible(false)
			end
		end
	end
end



function cbh.OnlineStatusUpdate(hEvent, units)
	for k, v in pairs(units) do
		local groupnum = cbh.GetIndexFromID(k)
		if groupnum ~= nil then
			cbh.UnitStatus[groupnum].offline = v
			if v then
				cbh.groupBase[groupnum]:SetAlpha(.5)
				cbh.groupName[groupnum]:SetFontColor(1, 1, 1, 1)
				cbh.groupStatus[groupnum]:SetFontColor(1, 1, 1, 1)
				cbh.groupStatus[groupnum]:SetText("OFFLINE")
				cbh.groupBF[groupnum]:SetWidth(cbhValues.ufwidth)
				cbh.groupBF[groupnum]:SetHeight(cbhValues.ufheight)
				cbh.groupMF[groupnum]:SetVisible(false)
				for i = 1, 9 do
					cbh.groupHoTs[groupnum][i]:SetVisible(false)
				end
				cbh.RaidMarker[groupnum]:SetVisible(false)
			else
				-- don't think this else statement is needed. Should all get updated through the full.availability trigger -> Status update function.
				cbh.groupStatus[groupnum]:SetText("")
				cbh.groupHF[groupnum]:SetWidth(cbhValues.ufwidth)
				cbh.UnitStatus[groupnum].los = false
				-- cbh.UpdateHP(hEvent, units)
				-- cbh.UpdateMB(hEvent, units)
			end
		end
	end
end



function cbh.WFcheck(hEvent, units)
	for k, v in pairs(units) do
		local groupnum = cbh.GetIndexFromID(k)
		if groupnum ~= nil then
			cbh.UnitStatus[groupnum].warfront = v
			if v then
				cbh.groupStatus[groupnum]:SetText("In Warfront")
				cbh.groupName[groupnum]:SetFontColor(1, 1, 1, 1)
				cbh.groupMB[groupnum]:SetVisible(false)
				cbh.groupMF[groupnum]:SetVisible(false)
				cbh.groupBF[groupnum]:SetHeight(cbhValues.ufheight)
				cbh.groupBF[groupnum]:SetWidth(1)
			end
		end
    end
end



-- Triggered by a units block status changing
function cbh.LoSUpdate(hEvent, units)
	for k, v in pairs(units) do
		local groupnum = cbh.GetIndexFromID(k)
		if groupnum ~= nil then
			-- print("LOS CHK   ", groupnum, k, v)
			-- if v then --and cbh.UnitStatus[j].los ~= unitID.blocked then
				cbh.UnitStatus[groupnum].los = v
				if cbhValues.hideooc then
					if v then
						cbh.HideOutofCombat(groupnum, cbh.UnitStatus[groupnum].los)
					else
						cbh.HideOutofCombat(groupnum, cbh.UnitStatus[groupnum].outofrange)
					end
				else
					if v then
						cbh.groupBase[groupnum]:SetAlpha(cbhValues.alphasetting)
					elseif not cbh.UnitStatus[groupnum].outofrange and not cbh.UnitStatus[groupnum].los then
						cbh.groupBase[groupnum]:SetAlpha(1)
					end
				end
			-- end
		end
	end
end


function cbh.RangeCheck(hEvent, xv, yv, zv)
 	if xv[cbh.playerinfo.id] then
		cbh.playerinfo.coordX = xv[cbh.playerinfo.id]
		cbh.playerinfo.coordZ = zv[cbh.playerinfo.id]
	end
end



-- Triggered when absorption value on a unit changes
function cbh.Absorb(hEvents, units)
	if not cbhValues.absShow then return end
	for k, v in pairs(units) do
		local groupnum = cbh.GetIndexFromID(k)
		if groupnum ~= nil then
			if not v then
				cbh.groupAbsBot[groupnum]:SetAlpha(0)
			else
				if cbh.groupAbsBot[groupnum]:GetAlpha() ~= 1 then
					cbh.groupAbsBot[groupnum]:SetAlpha(1)
				end
				if cbh.UnitStatus[groupnum].healthmax == nil then
					cbh.ClearIndex(hEvent, k, groupnum)
				else
					local fillPortion = (v / cbh.UnitStatus[groupnum].healthmax)
					if (fillPortion > 1) then
						cbh.groupAbsBot[groupnum]:SetWidth(cbhValues.ufwidth)
					else
						cbh.groupAbsBot[groupnum]:SetWidth(fillPortion * cbhValues.ufwidth)
					end
				end
			end
		end
	end
end



function cbh.RaidMark(hEvent, units)
	for k, v in pairs(units) do
		local groupnum = cbh.GetIndexFromID(k)
		if groupnum ~= nil then
			if v then
				cbh.RaidMarker[groupnum]:SetTexture("Rift", cbh.RaidMarkerImages[v])
				cbh.RaidMarker[groupnum]:SetVisible(true)
			else
				cbh.RaidMarker[groupnum]:SetVisible(false)
			end
		end
	end
end



-- Updates group role changes based on current spec unless in a dungeon
function cbh.UnitRoleCheck(hEvent, units)
	for k, v in pairs(units) do
		local groupnum = cbh.GetIndexFromID(k)
		if groupnum ~= nil and v then
			cbh.groupRole[groupnum]:SetTexture("Rift", cbh.RoleImgs[v])
		end
	end
end



function cbh.RDYcheck(hEvent, units)
	if units then
		local groupsize
		cbh.readychecking = true	--variable created simply for if the user changes ready check settings while in progress
		if processsolo or processgroup then groupsize = 5 else groupsize = 20 end	
		for i = 1, groupsize do
			cbh.groupRDY[i]:SetVisible(true)
		end
	end
	for k, v in pairs(units) do
		local groupnum = cbh.GetIndexFromID(k)
		if groupnum ~= nil then
			cbh.groupRDY[groupnum]:SetVisible(true)
			if v == true then
				cbh.groupRDY[groupnum]:SetTexture("ClickBoxHealer", "Textures/readyYes.png")
			elseif v == false then
				cbh.groupRDY[groupnum]:SetTexture("ClickBoxHealer", "Textures/readyNo.png")
			else
				cbh.groupRDY[groupnum]:SetTexture("ClickBoxHealer", "Textures/undecided.png")
				cbh.groupRDY[groupnum]:SetVisible(false)
				cbh.readychecking = nil
			end
		end
	end
end



-- PLAYER ROLE TRACKING ONLY -- This is to track role changes for the keybind separation
-- THIS WILL TRIGGER UPON INITIAL LOGIN BUT NOT AT RELOADUI
function cbh.RoleChange(hEvent, crole)
	if cbh.tAbilityIconsText ~= nil then
		print("Hiding all icons to build new list")
		for i, v in pairs(cbh.tAbilityIconsText) do
			cbh.tAbilityIcons[i]:SetVisible(false)
			cbh.tAbilityIconsText[i]:SetVisible(false)
		end
	end
	-- local groupnum = cbh.GetIndexFromID(cbh.unitLookup("player"))
	-- cbh.BuffUnitTable[cbh.UnitStatus[groupnum].uid] = nil
	if cbh.BuffUnitTable[cbh.unitLookup("player")] then cbh.BuffUnitTable[cbh.unitLookup("player")] = nil end
	cbh.WindowOptions:SetVisible(false)
	cbh.rolechange = true
	cbhValues.roleset = crole
	cbh.processMacroText(cbh.UnitsTable)

	if cbh.optionsloaded then
		-- Set buff color list sliders in correct positions for new role (forces selection of first list item)
		cbh.BuffColorList:SetSelectedIndex(1)
		cbh.BuffColorR:SetPosition(math.floor((cbhColorGlobal[cbhValues.roleset][1].r * 100) + 0.5))
		cbh.BuffColorG:SetPosition(math.floor((cbhColorGlobal[cbhValues.roleset][1].g * 100) + 0.5))
		cbh.BuffColorB:SetPosition(math.floor((cbhColorGlobal[cbhValues.roleset][1].b * 100) + 0.5))
		
		for i = 1, 4 do	-- Sets the correct text in the keybind text fields after a role swap
			cbh.OptionsModTextInput[i]:SetText(cbhMacroButton[cbhValues.roleset][optionSelected][i])
		end
		for i = 1, 9 do	-- Sets the correct text in the buffwatch text fields after a role swap
			cbh.BuffTextDisplay[i]:SetText(cbhBuffListA[cbhValues.roleset][i])
		end
	end
end



function cbh.UnitChange(units)
	--when target changes clear all targets to false
	for x = 1, 20 do
		cbh.UnitStatus[x].istarget = false
		cbh.groupSel[x]:SetVisible(false)
		if cbhValues.hideooc then
			if cbh.UnitStatus[x].los then
				cbh.HideOutofCombat(x, cbh.UnitStatus[x].los)
			elseif cbh.UnitStatus[x].outofrange then
				cbh.HideOutofCombat(x, cbh.UnitStatus[x].outofrange)
			else
				cbh.HideOutofCombat(x, false)
			end
		end
	end
	-- if target is in the raid
	local i = cbh.GetIndexFromID(units)
	if units and i ~= nil then
		cbh.UnitStatus[i].istarget = true
		cbh.groupSel[i]:SetVisible(true)
		if cbhValues.hideooc then
			cbh.groupBF[i]:SetAlpha(1)
			cbh.UnitStatus[i].oocalpha = 1
		end
	end
end



function cbh.BuffAdding(hEvent, unit, buffs)
	if cbhValues.hotwatch == false and cbhValues.debuffwatch == false then return end
	
	-- CREATES MY BUFF TABLE PER UNIT IF NOT ALREADY EXISTING
	if not cbh.BuffUnitTable[unit] then 
		cbh.BuffUnitTable[unit] = {}
	end

	local function addtablebuff(binfo, btype, bslot)
		cbh.BuffUnitTable[unit][binfo.id] = nil	-- ensures no leftover status remains
		cbh.BuffUnitTable[unit][binfo.id] = {
			begin = binfo.begin, -- The time the buff was cast on the target
			buffType = btype, -- String containing the type of buff
			caster = binfo.caster, -- **Do I need caster? When am I checking after the check in the above if statement?
			duration = binfo.duration, -- duration of entire buff (used in calculation for remaining)
			icon = binfo.icon, -- The buff icon
			name = binfo.name, -- The buff name
			remaining = binfo.remaining, -- time remaining on the buff (starts at the total duration)
			slot = bslot, -- Tthe location the buff is being shown at
			stack = binfo.stack, -- **why do I need to bring stack up? check coloring frame lines
		}
	end
	
	if buffs ~= nil then
		local groupnum = cbh.GetIndexFromID(unit)
		if groupnum ~= nil then
			for buffID in pairs(buffs) do
				local buffinfo = cbh.buffDetail(unit, buffID)
				

				--BEGINS THE ACTUAL UNIT FRAME MANIPULATION TO SHOW BUFFS IF DESIRED
				if cbhValues.hotwatch == true and not buffinfo.debuff then	-- CHECKS IF BUFF IS A BUFF OR DEBUFF AND APPLIES ACCORDINGLY
					for k = 1, 9 do
						if cbhBuffListA[cbhValues.roleset][k] == buffinfo.name and buffinfo.caster == cbh.playerinfo.id then
							if buffinfo.stack ~= nil then
								local stackcount = tostring(buffinfo.stack)
								cbh.groupHoTstack[groupnum][k]:SetText(stackcount)
								cbh.groupHoTstack[groupnum][k]:SetVisible(true)
							else
								cbh.groupHoTstack[groupnum][k]:SetText("")
								cbh.groupHoTstack[groupnum][k]:SetVisible(false)
							end
							if buffinfo.icon then
								if cbhValues.bufficons then
									cbh.groupHoTicon[groupnum][k]:SetTexture("Rift", buffinfo.icon)
									cbh.groupHoTicon[groupnum][k]:SetVisible(true)
								else
									cbh.groupHoTs[groupnum][k]:SetVisible(true)	
								end
							end
							addtablebuff(buffinfo, "buff", k)
							break
						end
					end	-- end buff check
				elseif cbhValues.debuffwatch and buffinfo.debuff then			
					if buffinfo.name == "Burnout" and cbhValues.absShow then
						cbh.groupAbsBot[groupnum]:SetBackgroundColor(.8, .2, .8)
						cbh.UnitStatus[groupnum].hasburnout = true
						-- addtablebuff(buffinfo, "buff")
						addtablebuff(buffinfo, "buff")
					end
					for k = 1, 9 do
						if cbhBuffListA[cbhValues.roleset][k] == buffinfo.name and buffinfo.caster == cbh.playerinfo.id then
							if buffinfo.icon then
								if cbhValues.bufficons then
									cbh.groupHoTicon[groupnum][k]:SetTexture("Rift", buffinfo.icon)
									cbh.groupHoTicon[groupnum][k]:SetVisible(true)
								else
									cbh.groupHoTs[groupnum][k]:SetVisible(true)	
								end
							end
							addtablebuff(buffinfo, "buff", k)
							break
						end
					end
					for k, dbuffwID in pairs(cbhDeBuffWList) do	-- Checks to see if the added debuff is in the whitelist. Buffs found here take full priority over other debuffs on the target.
						if dbuffwID == buffinfo.name then
							cbh.debuffwl = true
							cbh.UnitStatus[groupnum].haswhitedebuff = cbh.debuffwl
							if cbhValues.debuffcolorwhole then
								cbh.groupHF[groupnum]:SetBackgroundColor(1, 0, 0)
							else
								cbh.groupStatus[groupnum]:SetBackgroundColor(1, 0, 0, 1)
							end
							cbh.UnitStatus[groupnum].whitedebuffqty = cbh.UnitStatus[groupnum].whitedebuffqty + 1
							cbh.UnitStatus[groupnum].hasdebuffs = true
							addtablebuff(buffinfo, "whitelist")
						-- else
							-- cbhdebuffwl = false
							break
						end
					end
					if not cbh.debuffwl then
						for i, v in pairs(cbhDeBuffBList) do	-- Checks to see if the added debuff is in the blacklist and prevents it from being displayed.
						-- if cbhDeBuffBList[buffinfo.name] then
							if buffinfo.name == v then
								cbhdebuffbl = true
								break
						-- else
							else
								cbhdebuffbl = false
							end
						end
					end
					
					if not cbhdebuffbl and not cbh.UnitStatus[groupnum].haswhitedebuff then
						-- if not cbh.UnitStatus[groupnum].haswhitedebuff then	-- Checks if there is a buff present that is in the whitelist. This is to keep the whitelisted buff "on top".
							if buffinfo.poison then	-- Color UFs based on debuff type and color whole box option
								if cbhValues.debuffcolorwhole then
									cbh.groupHF[groupnum]:SetBackgroundColor(0, 1, .8)
								else
									cbh.groupStatus[groupnum]:SetBackgroundColor(0, 1, .8, 1)
								end
								cbh.UnitStatus[groupnum].poisonqty = cbh.UnitStatus[groupnum].poisonqty + 1
								cbh.UnitStatus[groupnum].hasdebuffs = true
								addtablebuff(buffinfo, "poison")
							-- end
							elseif buffinfo.curse then
								if cbhValues.debuffcolorwhole then
									cbh.groupHF[groupnum]:SetBackgroundColor(.4, 0, 1)
								else
									cbh.groupStatus[groupnum]:SetBackgroundColor(.4, 0, 1, 1)
								end
								cbh.UnitStatus[groupnum].curseqty = cbh.UnitStatus[groupnum].curseqty + 1
								cbh.UnitStatus[groupnum].hasdebuffs = true
								addtablebuff(buffinfo, "curse")
							-- end
							elseif buffinfo.disease then
								if cbhValues.debuffcolorwhole then
									cbh.groupHF[groupnum]:SetBackgroundColor(1, .5, 0)
								else
									cbh.groupStatus[groupnum]:SetBackgroundColor(1, .5, 0, 1)
								end
								cbh.UnitStatus[groupnum].diseaseqty = cbh.UnitStatus[groupnum].diseaseqty + 1
								cbh.UnitStatus[groupnum].hasdebuffs = true
								addtablebuff(buffinfo, "disease")
							end
						-- end
					end
				end	-- end debuff check
			end
		end
	end
end


function cbh.BuffRemoving(hEvent, unit, buffs)
	if cbhValues.hotwatch == false and cbhValues.debuffwatch == false then return end
	if buffs ~= nil then
		local groupnum = cbh.GetIndexFromID(unit)
		if groupnum ~= nil then
			for buffid in pairs(buffs) do
				if cbh.BuffUnitTable[unit] and cbh.BuffUnitTable[unit][buffid] then --and cbh.BuffUnitTable[unit][buffid].buffType then
					if cbh.BuffUnitTable[unit][buffid].buffType ~= "buff" then	-- filter out anything not buff since all other combos are debuffs
						local recolor = false
						--	check to see what kind of debuff we are and decrement the counter accordingly
						if cbh.BuffUnitTable[unit][buffid].buffType == "whitelist" then
							cbh.UnitStatus[groupnum].whitedebuffqty = cbh.UnitStatus[groupnum].whitedebuffqty - 1
							if cbh.UnitStatus[groupnum].whitedebuffqty == 0 then recolor = true end	--no more of this debuff are present. Color needs to change.
						elseif cbh.BuffUnitTable[unit][buffid].buffType == "poison" then
							cbh.UnitStatus[groupnum].poisonqty = cbh.UnitStatus[groupnum].poisonqty - 1
							if cbh.UnitStatus[groupnum].poisonqty == 0 then recolor = true end	--no more of this debuff are present. Color needs to change.
						elseif cbh.BuffUnitTable[unit][buffid].buffType == "curse" then
							cbh.UnitStatus[groupnum].curseqty = cbh.UnitStatus[groupnum].curseqty - 1
							if cbh.UnitStatus[groupnum].curseqty == 0 then recolor = true end	--no more of this debuff are present. Color needs to change.
						elseif cbh.BuffUnitTable[unit][buffid].buffType == "disease" then
							cbh.UnitStatus[groupnum].diseaseqty = cbh.UnitStatus[groupnum].diseaseqty - 1
							if cbh.UnitStatus[groupnum].diseaseqty == 0 then recolor = true end	--no more of this debuff are present. Color needs to change.
						end
						
						-- count remaining debuffs
						local debuffcount = 0
						for buffID, buffinfo in pairs(cbh.BuffUnitTable[unit]) do
							if buffinfo.buffType ~= "buff" then
								debuffcount = debuffcount + 1
							end
						end
						-- If we have one debuff, it's the one currently being removed, so make sure we have no remaining debuff flags.
						if debuffcount < 2 then
							cbh.UnitStatus[groupnum].whitedebuffqty = 0
							cbh.UnitStatus[groupnum].poisonqty = 0
							cbh.UnitStatus[groupnum].curseqty = 0
							cbh.UnitStatus[groupnum].diseaseqty = 0
							recolor = true
						end
						
						-- If you need to recolor, figure out which color to change to
						if recolor then
							if cbh.UnitStatus[groupnum].whitedebuffqty == 0 and cbh.UnitStatus[groupnum].poisonqty == 0 and cbh.UnitStatus[groupnum].curseqty == 0 and cbh.UnitStatus[groupnum].diseaseqty == 0 then -- if no debuffs present, recolor to base
								if cbhValues.debuffcolorwhole then
									cbh.groupHF[groupnum]:SetBackgroundColor(cbhCallingColors[7].r, cbhCallingColors[7].g, cbhCallingColors[7].b, cbhCallingColors[7].a)
								else
									cbh.groupStatus[groupnum]:SetBackgroundColor(0, 0, 0, 0)
								end
								cbh.UnitStatus[groupnum].hasdebuffs = false -- set debuff flag to false
							elseif cbh.UnitStatus[groupnum].whitedebuffqty > 0 then -- still a whitelisted debuff, recolor with that color scheme
								if cbhValues.debuffcolorwhole then
									cbh.groupHF[groupnum]:SetBackgroundColor(1, 0, 0)
								else
									cbh.groupStatus[groupnum]:SetBackgroundColor(1, 0, 0, 1)
								end
								break
							elseif cbh.UnitStatus[groupnum].poisonqty > 0 then -- still a poison debuff, recolor with that color scheme
								if cbhValues.debuffcolorwhole then
									cbh.groupHF[groupnum]:SetBackgroundColor(0, 1, .8)
								else
									cbh.groupStatus[groupnum]:SetBackgroundColor(0, 1, .8, 1)
								end
								break
							elseif cbh.UnitStatus[groupnum].curseqty > 0 then -- still a curse debuff, recolor with that color scheme
								if cbhValues.debuffcolorwhole then
									cbh.groupHF[groupnum]:SetBackgroundColor(.4, 0, 1)
								else
									cbh.groupStatus[groupnum]:SetBackgroundColor(.4, 0, 1, 1)
								end
								break
							elseif cbh.UnitStatus[groupnum].diseaseqty > 0 then -- still a disease debuff, recolor with that color scheme
								if cbhValues.debuffcolorwhole then
									cbh.groupHF[groupnum]:SetBackgroundColor(1, .5, 0)
								else
									cbh.groupStatus[groupnum]:SetBackgroundColor(1, .5, 0, 1)
								end
							end
						end	-- end of debuff removals
					else
					-- end
						if cbh.BuffUnitTable[unit][buffid].name == "Burnout" and cbhValues.absShow then
							cbh.groupAbsBot[groupnum]:SetBackgroundColor(cbhCallingColors[8].r, cbhCallingColors[8].g, cbhCallingColors[8].b, cbhCallingColors[8].a)
							cbh.UnitStatus[groupnum].hasburnout = false
						end
						if cbh.BuffUnitTable[unit][buffid].slot then
							cbh.groupHoTs[groupnum][cbh.BuffUnitTable[unit][buffid].slot]:SetAlpha(1)
							cbh.groupHoTs[groupnum][cbh.BuffUnitTable[unit][buffid].slot]:SetVisible(false)
							if cbh.BuffUnitTable[unit][buffid].icon then
								cbh.groupHoTicon[groupnum][cbh.BuffUnitTable[unit][buffid].slot]:SetAlpha(1)
								cbh.groupHoTicon[groupnum][cbh.BuffUnitTable[unit][buffid].slot]:SetVisible(false)
							end
							if cbhValues.buffwarncolor == true then
								cbh.groupHoTs[groupnum][cbh.BuffUnitTable[unit][buffid].slot]:SetBackgroundColor(cbhColorGlobal[cbhValues.roleset][1].r, cbhColorGlobal[cbhValues.roleset][1].g, cbhColorGlobal[cbhValues.roleset][1].b)
							end
						end
						if cbh.BuffUnitTable[unit][buffid].stack then
							cbh.groupHoTstack[groupnum][cbh.BuffUnitTable[unit][buffid].slot]:SetText("")
							cbh.groupHoTstack[groupnum][cbh.BuffUnitTable[unit][buffid].slot]:SetVisible(false)
						end
					end
					cbh.BuffUnitTable[unit][buffid] = nil
				end
			end
		end
	end
end




--[[<<<<<<<<<<<<<<<<<<<<<<]]
--				TABLE EVENTS
--[[<<<<<<<<<<<<<<<<<<<<<<]]

Command.Event.Attach(Event.Unit.Availability.Full, cbh.UpdateIndex, "UpdateIndex")
Command.Event.Attach(Event.Unit.Detail.Aggro, cbh.aggroUpdate, "UpdateArgo")
Command.Event.Attach(Event.Unit.Detail.Offline, cbh.OnlineStatusUpdate, "UpdateOffline")
Command.Event.Attach(Event.Unit.Detail.Coord, cbh.RangeCheck, "UpdateRange")
Command.Event.Attach(Event.Unit.Detail.Absorb, cbh.Absorb, "UpdateAbsorbDetails")
Command.Event.Attach(Event.Unit.Detail.Mark, cbh.RaidMark, "UpdateRaidMark")
Command.Event.Attach(Event.Unit.Detail.Warfront, cbh.WFcheck, "UpdateWarfrontStatus")
Command.Event.Attach(Event.Unit.Detail.Ready, cbh.RDYcheck, "UpdateReadyCheck")
Command.Event.Attach(Event.Unit.Detail.Blocked, cbh.LoSUpdate, "UpdateLOS")
Command.Event.Attach(Event.Unit.Detail.Role, cbh.UnitRoleCheck, "UpdateRole")
Command.Event.Attach(Event.TEMPORARY.Role, cbh.RoleChange, "UpdateSpecChange")

Command.Event.Attach(Event.Unit.Detail.Health, cbh.UpdateHP, "UpdateHP")
Command.Event.Attach(Event.Unit.Detail.HealthMax, cbh.UpdateHPMax, "UpdateHP")
Command.Event.Attach(Event.Unit.Detail.HealthCap, cbh.UpdateHPCap, "UpdateHP")
Command.Event.Attach(Event.Unit.Detail.Mana, cbh.UpdateMB, "UpdateMB")
Command.Event.Attach(Event.Unit.Detail.ManaMax, cbh.UpdateMBMax, "UpdateMaxMana")
Command.Event.Attach(Event.Unit.Detail.Mentoring, cbh.Mentored, "UpdateMaxMana")

Command.Event.Attach(Event.Buff.Add, cbh.BuffAdding, "TESTUpdateBuffs")
Command.Event.Attach(Event.Buff.Remove, cbh.BuffRemoving, "TESTRemoveBuffs")


Command.Event.Attach(Event.System.Secure.Enter, cbh.CombatEnter, "CombatEnter")
Command.Event.Attach(Event.System.Secure.Leave, cbh.CombatLeave, "CombatLeave")

Command.Event.Attach(Event.System.Update.Begin, cbh.UnitUpdate, "frame update")
Command.Event.Attach(Event.System.Update.Begin, cbh.HotWatch, "buffwatch update")

Command.Event.Attach(Event.Addon.SavedVariables.Load.End, cbh.loadSettings, "cbhLoadVariables")
Command.Event.Attach(Event.Addon.Startup.End, cbh.Initialize, "LoadVariables")

Command.Event.Attach(Command.Slash.Register("cbh"), cbh.SlashCommand, "SlashCommands")


-- These can't be updated until LibSimpleWidgets updates his addon to work with the new event model.
table.insert(Library.LibUnitChange.Register("player.target"), {cbh.UnitChange, "ClickBoxHealer", "cbhOnUnitChange"})	-- create a change target event
table.insert(Library.LibUnitChange.Register("mouseover"), {cbh.UnitMouseOver, "ClickBoxHealer", "cbhOnUnitMouseOver"}) -- create a mouseover event


