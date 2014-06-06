Wykkyd.Outfitter.EquipSets = {}
Wykkyd.Outfitter.EquipSetFrame = false

function Wykkyd.Outfitter.EquipSets.UnEquip(slot)
	if pcall(Inspect.Item.Detail, slot) then
		local displacedItem = Inspect.Item.Detail(slot)
		if displacedItem then
			Wykkyd.Outfitter.AttemptEquip(displacedItem, nil, "BAG", hasRoom)
		end
	end
end

function Wykkyd.Outfitter.EquipSets.Equip(id, itemType, targetSlot, hasRoom)
	if id == nil then return end
	if id == 0 then return end
	Wykkyd.Outfitter.AttemptEquip(id, itemType, targetSlot, hasRoom)
end

function Wykkyd.Outfitter.EquipSets.Delete(myCount, id)
	local upd = {}
	for _, v in pairs(Wykkyd.Outfitter.ContextConfig[myCount].EquipSetList) do
		if v.value ~= id then
			if v.text ~= nil and v.text ~= "" then
				table.insert(upd, v)
			end
		end
	end
	Wykkyd.Outfitter.ContextConfig[myCount].EquipSetList = upd
	upd = {}
	for i, l in pairs(Wykkyd.Outfitter.ContextConfig[myCount].EquipSetList) do
		for _, v in pairs(Wykkyd.Outfitter.ContextConfig[myCount].EquipSetGear) do
			if v.id ~= id and l.value == v.id then
				table.insert(upd, v)
			end
		end
	end
	Wykkyd.Outfitter.ContextConfig[myCount].EquipSetGear = upd
end

function Wykkyd.Outfitter.EquipSets.Save(myCount, tempId)
	if Wykkyd.Outfitter.Selected[myCount] == nil then Wykkyd.Outfitter.Selected[myCount] = {} end
	local tempName          = Wykkyd.Outfitter.Selected[myCount].Name
	if tempName == nil then return end
	if wyk.func.Trim(tempName) == "" then return end
	local tempMakeIcon      = Wykkyd.Outfitter.Selected[myCount].ButtonChk
	local tempIcon          = Wykkyd.Outfitter.Selected[myCount].Icon
	local tempChangeRole    = Wykkyd.Outfitter.Selected[myCount].RoleChk
	local tempTargetRole    = Wykkyd.Outfitter.Selected[myCount].Role
	local tempManageKaruul  = Wykkyd.Outfitter.Selected[myCount].KaruulChk
	local tempKaruulSet1    = Wykkyd.Outfitter.Selected[myCount].Set1
	local tempKaruulSet2    = Wykkyd.Outfitter.Selected[myCount].Set2
	local tempAlertCheck    = Wykkyd.Outfitter.Selected[myCount].AlertChk
	local tempAlertText    = Wykkyd.Outfitter.Selected[myCount].AlertText
	local tempAlertChannel    = Wykkyd.Outfitter.Selected[myCount].AlertChannel
	local tempChangeWardrobe = Wykkyd.Outfitter.Selected[myCount].WardrobeChk
	local tempTargetWardrobe = Wykkyd.Outfitter.Selected[myCount].Wardrobe
	if Wykkyd.Outfitter.ContextConfig[myCount].EquipSetGear == nil then Wykkyd.Outfitter.ContextConfig[myCount].EquipSetGear = {}; end
	if Wykkyd.Outfitter.ContextConfig[myCount].EquipSetList == nil then Wykkyd.Outfitter.ContextConfig[myCount].EquipSetList = {}; end
	local updating = true
	local matched = false
	if tempId == 0 then
		for _, v in pairs(Wykkyd.Outfitter.ContextConfig[myCount].EquipSetList) do
			if v.text == tempName then
				tempId = v.value
				matched = true
				break
			elseif v.value > tempId then
				tempId = v.value
			end
		end
		if not matched then
			tempId = tempId + 1
			updating = false
		end
	end
	Wykkyd.Outfitter.EquipSets.Delete(myCount, tempId)
	table.insert( Wykkyd.Outfitter.ContextConfig[myCount].EquipSetList, { value = tempId, text = tempName } )
	Wykkyd.Outfitter.PrepList(myCount)
	local gearSet = {
		Wykkyd.Outfitter.EquipSets.CreateGearElement( Wykkyd.Outfitter.displayedGearSlot[myCount].helmet, Wykkyd.Outfitter.ignoredSlots[myCount].helmet ),
		Wykkyd.Outfitter.EquipSets.CreateGearElement( Wykkyd.Outfitter.displayedGearSlot[myCount].shoulders, Wykkyd.Outfitter.ignoredSlots[myCount].shoulders ),
		Wykkyd.Outfitter.EquipSets.CreateGearElement( Wykkyd.Outfitter.displayedGearSlot[myCount].cape, Wykkyd.Outfitter.ignoredSlots[myCount].cape ),
		Wykkyd.Outfitter.EquipSets.CreateGearElement( Wykkyd.Outfitter.displayedGearSlot[myCount].chest, Wykkyd.Outfitter.ignoredSlots[myCount].chest ),
		Wykkyd.Outfitter.EquipSets.CreateGearElement( Wykkyd.Outfitter.displayedGearSlot[myCount].gloves, Wykkyd.Outfitter.ignoredSlots[myCount].gloves ),
		Wykkyd.Outfitter.EquipSets.CreateGearElement( Wykkyd.Outfitter.displayedGearSlot[myCount].belt, Wykkyd.Outfitter.ignoredSlots[myCount].belt ),
		Wykkyd.Outfitter.EquipSets.CreateGearElement( Wykkyd.Outfitter.displayedGearSlot[myCount].legs, Wykkyd.Outfitter.ignoredSlots[myCount].legs ),
		Wykkyd.Outfitter.EquipSets.CreateGearElement( Wykkyd.Outfitter.displayedGearSlot[myCount].feet, Wykkyd.Outfitter.ignoredSlots[myCount].feet ),
		Wykkyd.Outfitter.EquipSets.CreateGearElement( Wykkyd.Outfitter.displayedGearSlot[myCount].seal, Wykkyd.Outfitter.ignoredSlots[myCount].seal ),
		Wykkyd.Outfitter.EquipSets.CreateGearElement( Wykkyd.Outfitter.displayedGearSlot[myCount].handmain, Wykkyd.Outfitter.ignoredSlots[myCount].handmain ),
		Wykkyd.Outfitter.EquipSets.CreateGearElement( Wykkyd.Outfitter.displayedGearSlot[myCount].handoff, Wykkyd.Outfitter.ignoredSlots[myCount].handoff ),
		Wykkyd.Outfitter.EquipSets.CreateGearElement( Wykkyd.Outfitter.displayedGearSlot[myCount].ranged, Wykkyd.Outfitter.ignoredSlots[myCount].ranged ),
		Wykkyd.Outfitter.EquipSets.CreateGearElement( Wykkyd.Outfitter.displayedGearSlot[myCount].neck, Wykkyd.Outfitter.ignoredSlots[myCount].neck ),
		Wykkyd.Outfitter.EquipSets.CreateGearElement( Wykkyd.Outfitter.displayedGearSlot[myCount].trinket, Wykkyd.Outfitter.ignoredSlots[myCount].trinket ),
		Wykkyd.Outfitter.EquipSets.CreateGearElement( Wykkyd.Outfitter.displayedGearSlot[myCount].ring1, Wykkyd.Outfitter.ignoredSlots[myCount].ring1 ),
		Wykkyd.Outfitter.EquipSets.CreateGearElement( Wykkyd.Outfitter.displayedGearSlot[myCount].ring2, Wykkyd.Outfitter.ignoredSlots[myCount].ring2 ),
		Wykkyd.Outfitter.EquipSets.CreateGearElement( Wykkyd.Outfitter.displayedGearSlot[myCount].synergy, Wykkyd.Outfitter.ignoredSlots[myCount].synergy ),
		Wykkyd.Outfitter.EquipSets.CreateGearElement( Wykkyd.Outfitter.displayedGearSlot[myCount].focus, Wykkyd.Outfitter.ignoredSlots[myCount].focus )
	}
	local tempList = {
		id = tempId,
		name = tempName,
		makeIcon = tempMakeIcon,
		icon = tempIcon,
		changeRole = tempChangeRole,
		targetRole = tempTargetRole,
		manageKaruul = tempManageKaruul,
		karuulSet1 = tempKaruulSet1,
		karuulSet2 = tempKaruulSet2,
		alertCheck = tempAlertCheck,
		alertText = tempAlertText,
		alertChannel = tempAlertChannel,
		gear = gearSet,
		changeWardrobe = tempChangeWardrobe,
		targetWardrobe = tempTargetWardrobe,
	}

	table.insert( Wykkyd.Outfitter.ContextConfig[myCount].EquipSetGear, tempList)
	if updating == true then
		Wykkyd.Outfitter.UpdateButton(myCount, tempList)
	end
end

function Wykkyd.Outfitter.EquipSets.Load(myCount, id)
	if id == nil then return nil; end
	if id == 0 then return nil; end
	--print("context = "..myCount.." and set = "..id)
	local retVal = {}
	retVal.ignored = {}
	local hasRoom = Wykkyd.Outfitter.FindEmptySlots()
	Wykkyd.Outfitter.PrepGearChange()
	for _, g in pairs(Wykkyd.Outfitter.ContextConfig[myCount].EquipSetGear) do
		if g.id == id then
			retVal.id = g.id
			retVal.name = g.name
			retVal.icon = g.icon
			if type(g.makeIcon) == "string" then
				retVal.makeIcon = false
			else
				retVal.makeIcon = g.makeIcon
			end
			retVal.changeRole = g.changeRole
			retVal.manageKaruul = g.manageKaruul
			retVal.targetRole = g.targetRole
			retVal.karuulSet1 = g.karuulSet1
			retVal.karuulSet2 = g.karuulSet2
			retVal.alertCheck = g.alertCheck
			retVal.alertText = g.alertText
			retVal.alertChannel = g.alertChannel
			retVal.changeWardrobe = g.changeWardrobe
			retVal.targetWardrobe = g.targetWardrobe
			for idx, itm in pairs( g.gear ) do
				if not itm.disabled then
					if wyk.func.NilSafe(itm.id) ~= "" then
						Wykkyd.Outfitter.EquipSets.Equip(itm.id,itm.itemType, itm.targetSlot, hasRoom)
					end
					table.insert(retVal.ignored, { slot = itm.targetSlot, ignored = false })
				else
					table.insert(retVal.ignored, { slot = itm.targetSlot, ignored = true })
				end
			end
			for idx, itm in pairs( g.gear ) do
				if not itm.disabled then
					if wyk.func.NilSafe(itm.id) == "" then
						Wykkyd.Outfitter.EquipSets.UnEquip(itm.targetSlot)
					end
				end
			end
			Wykkyd.Outfitter.DonePreparingGearChange()
			return retVal
		end
	end
	Wykkyd.Outfitter.DonePreparingGearChange()
	return nil
end

function Wykkyd.Outfitter.EquipSets.SwitchTo(myCount, id)
	local doNadaWithThis = Wykkyd.Outfitter.EquipSets.Load(myCount, id)
end

function Wykkyd.Outfitter.EquipSets.GetEquipSetWithId(myCount,id)
	for equipSetKey, equipSet in pairs(Wykkyd.Outfitter.ContextConfig[myCount].EquipSetGear) do
		if equipSet.id == id then
			return equipSetKey, equipSet
		end
	end
	return nil, nil
end

function Wykkyd.Outfitter.EquipSets.SetEquipSetWithId(myCount,equipSetKey,equipSet)
	if equipSet ~= nil then
		Wykkyd.Outfitter.ContextConfig[myCount].EquipSetGear[equipSetKey] = equipSet
	end
end

function Wykkyd.Outfitter.EquipSets.CreateGearElement(slot,isDisabled)
	return {id = wyk.func.DeriveID(slot),
	itemType = wyk.func.DeriveItemType(slot),
	targetSlot = slot,
	disabled = isDisabled}
end
