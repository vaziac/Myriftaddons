local toc, data = ...

function Wykkyd.Outfitter.MassReplacementWindow.BuildForm(myCount)
	if not Wykkyd.Outfitter.MassReplacementWindow[myCount] then return end
	local window = Wykkyd.Outfitter.MassReplacementWindow[myCount]
	myCount = window.myCount
	local content = window:GetContent()
	local uName = "wykkydOutfitter"
	local borderSize = wyk.vars.Images.sizes.border
	local placeHolder = true
	local iconSize = wyk.vars.Images.sizes.equip
	local itemToSave = {}



	local fg = wyk.frame.CreateFrame("_frame", window)
	fg:SetLayer(20)
	fg:SetHeight(window:GetHeight()-20)
	fg:SetWidth(window:GetWidth()-20)
	fg:SetPoint("TOPCENTER", content, "TOPCENTER", 0, -20)

	local slotWrapper = wyk.frame.CreateFrame(uName .."_slot", fg)
	slotWrapper:SetLayer(21)
	slotWrapper:SetWidth(borderSize)
	slotWrapper:SetHeight(borderSize)
	slotWrapper:SetPoint("TOPCENTER", content, "TOPCENTER", 0, 30)
	slotWrapper:SetVisible(true)

	local slotBorder = wyk.frame.CreateTexture(uName.."_border", slotWrapper)
	slotBorder:SetWidth(borderSize)
	slotBorder:SetHeight(borderSize)
	slotBorder:SetPoint("CENTER", slotWrapper, "CENTER", 0, 0)
	slotBorder:SetLayer(22)
	slotBorder:SetTexture(wyk.vars.Images.borders.disabled.src, wyk.vars.Images.borders.disabled.file)
	slotBorder:SetAlpha(.35)
	slotBorder:SetAlpha(.9)
	slotWrapper.border = slotBorder
	local slotIcon = wyk.frame.CreateTexture(uName.."_icon", slotWrapper, {
		SetPoint = {point="CENTER", target=slotWrapper, targetpoint="CENTER", x=0, y=0},
		SetWidth = iconSize,
		SetHeight = iconSize,
		SetLayer = 10,
	}, false)
	slotIcon:SetTexture(wyk.vars.Images.slots.chest.src, wyk.vars.Images.slots.chest.file)
	slotWrapper.icon = slotIcon

	local offHandCheckbox = wyk.frame.CreateCheckbox(uName .. "offhandchkbox", fg)
	local offhandCheckBoxLabel = wyk.frame.CreateText(uName .. "offhandLbl", fg)
	offhandCheckBoxLabel:SetText("offslot")
	offHandCheckbox:SetPoint("CENTER", slotWrapper , "CENTER", 40, 0)
	offhandCheckBoxLabel:SetPoint("LEFTCENTER", offHandCheckbox, "RIGHTCENTER", 2, 0)
	offHandCheckbox:SetEnabled(false)
	offHandCheckbox:SetVisible(false)
	offhandCheckBoxLabel:SetVisible(false)

	local errorLbl = wyk.frame.CreateText(uName .. "errorLbl", fg)
	errorLbl:SetText("")
	errorLbl:SetFontColor(255,0,0,1)
	errorLbl:SetPoint("TOPCENTER",fg, "TOPCENTER", 0,20)


	slotIcon:EventAttach(Event.UI.Input.Mouse.Left.Up, function(self, h)
		local cursor, held = Inspect.Cursor()
		if(cursor and cursor == "item") then
			Command.Item.Standard.Drop(held)
			itemToSave = Inspect.Item.Detail(held)
			local cat = wyk.func.Split(itemToSave.category ,"%S+")
			errorLbl:SetText("")
			if cat[2] == "onehand" then
				offhandCheckBoxLabel:SetText("offhand slot")
				offHandCheckbox:SetEnabled(true)
				offHandCheckbox:SetVisible(true)
				offhandCheckBoxLabel:SetVisible(true)
			elseif cat[3] == "ring" then
				offhandCheckBoxLabel:SetText("2nd ring slot")
				offHandCheckbox:SetEnabled(true)
				offHandCheckbox:SetVisible(true)
				offhandCheckBoxLabel:SetVisible(true)

			else
				offHandCheckbox:SetVisible(false)
				offhandCheckBoxLabel:SetVisible(false)
				offHandCheckbox:SetEnabled(false)
				offHandCheckbox:SetChecked(false)
			end
			slotIcon:SetTexture("Rift",itemToSave.icon)
			if itemToSave.rarity == "relic" then
				slotBorder:SetTexture(
				wyk.vars.Images.borders.relic.src,
				wyk.vars.Images.borders.relic.file
				)
			elseif itemToSave.rarity == "epic" then
				slotBorder:SetTexture(
				wyk.vars.Images.borders.epic.src,
				wyk.vars.Images.borders.epic.file
				)
			elseif itemToSave.rarity == "uncommon" then
				slotBorder:SetTexture(
				wyk.vars.Images.borders.uncommon.src,
				wyk.vars.Images.borders.uncommon.file
				)
			elseif itemToSave.rarity == "rare" then
				slotBorder:SetTexture(
				wyk.vars.Images.borders.rare.src,
				wyk.vars.Images.borders.rare.file
				)
			else
				slotBorder:SetTexture(
				wyk.vars.Images.borders.default.src,
				wyk.vars.Images.borders.default.file
				)
			end

		end
	end
	, "Event.UI.Input.Mouse.Left.Up")


	local margin = 60 - (fg:GetHeight()/4)
	local indexes = {}
	local saveBtnAllowed = true
	for k,v in pairs(Wykkyd.Outfitter.ContextConfig[myCount].EquipSetList) do
		if v.value > 0 then
			local name = v.text
			local checkbox = wyk.frame.CreateCheckbox(uName .. "chkbox" .. name, fg)
			local checkBoxLabel = wyk.frame.CreateText(uName .. "Lbl" .. name, fg)
			checkBoxLabel:SetText(name)
			checkbox:SetPoint("LEFTCENTER", fg, "LEFTCENTER", 40, margin)
			checkBoxLabel:SetPoint("LEFTCENTER", checkbox, "RIGHTCENTER", 10, 0)
			margin = margin+20

			function checkbox.Event:CheckboxChange ()
				local value = v.value
				if checkbox:GetChecked() then
					table.insert(indexes, value)
				else
					for k, v in pairs (indexes) do
						if v == value then
							table.remove(indexes,k)
						end
					end
				end
			end
		end
	end
	if table.getn(Wykkyd.Outfitter.ContextConfig[myCount].EquipSetList) <= 1 then
		saveBtnAllowed = false
		margin = margin + 20
		local noSetsFoundLbl = wyk.frame.CreateText(uName .. "noSetsFoundLbl", fg)
		noSetsFoundLbl:SetText("No sets were found, please make some!")
		noSetsFoundLbl:SetPoint("LEFTCENTER", fg, "RIGHTCENTER", -225, margin)
	end

	local saveButton = wyk.frame.CreateButton(uName .. "saveBtn", fg)
	saveButton:SetText("Save")
	saveButton:SetPoint("CENTER", fg, "CENTER", 0, margin+ 20)
	saveButton:SetEnabled(saveBtnAllowed)
	if saveBtnAllowed == true then
		saveButton:EventAttach(Event.UI.Input.Mouse.Left.Up, function(self, h)
			if(offHandCheckbox:GetChecked()) then
				local newCategory = ""
				local tempCat = wyk.func.Split(itemToSave.category,"%S+")
				if tempCat[3] == "ring" then
					newCategory = tempCat[1].." "..tempCat[2].." off"..tempCat[3]
				elseif tempCat[2] == "onehand" then
					newCategory = tempCat[1].." off"..tempCat[2].." "..tempCat[3]
				end
				itemToSave.category = newCategory
			end
			if itemToSave.id ~= nil then
				Wykkyd.Outfitter.MassReplacementWindow.SaveItem(itemToSave, indexes, myCount)
				slotIcon:SetTexture(wyk.vars.Images.slots.chest.src, wyk.vars.Images.slots.chest.file)
				slotBorder:SetTexture(wyk.vars.Images.borders.disabled.src, wyk.vars.Images.borders.disabled.file)
				itemToSave = {}
				offHandCheckbox:SetChecked(false)
				offHandCheckbox:SetVisible(false)
				offHandCheckbox:SetEnabled(false)
				offhandCheckBoxLabel:SetVisible(false)
			else
				errorLbl:SetText("Drag an item in the slot first!")
			end
		end
		, "Event.UI.Input.Mouse.Left.Up")
	end

end




function Wykkyd.Outfitter.MassReplacementWindow.SaveItem(item, indexes, myCount)
	local gearSlot = wyk.func.DeriveSlotByCategory(item)

	if gearSlot == nil then
		print("nice try! that's not an equipable item!")
		return
	end
	for key,val in pairs(indexes) do
		local equipSetKey, equipSet = Wykkyd.Outfitter.EquipSets.GetEquipSetWithId(myCount,val)
		local tempGear = equipSet.gear
		for gearKey,gearValue in pairs(tempGear) do
			if gearSlot == "seqp.hof" then
				if gearValue.id ~= nil then
					local item = Inspect.Item.Detail(gearValue.id)
					if item ~= nil then
						if wyk.func.DeriveWeaponType(item) == "twohand" then
							table.remove(tempGear, gearKey)
							table.insert(tempGear,Wykkyd.Outfitter.EquipSets.CreateGearElement(wyk.func.DeriveSlot("handmain")))
							break
						end
					end
				end
			end
			if wyk.func.DeriveWeaponType(item) == "twohand" then
				if gearValue.targetSlot == wyk.vars.slotsByCategory["offonehand"] then
					table.remove(tempGear, gearKey)
					table.insert(tempGear,Wykkyd.Outfitter.EquipSets.CreateGearElement(wyk.func.DeriveSlot("handoff")))
				end
			end
			if gearValue.targetSlot == gearSlot then
				table.remove(tempGear, gearKey)
				local newItem = Wykkyd.Outfitter.EquipSets.CreateGearElement(gearSlot, false)
				newItem.id = item.id
				newItem.itemType = item.itemType
				table.insert(tempGear,newItem)
				break
			end
		end
		equipSet.gear = tempGear
		Wykkyd.Outfitter.EquipSets.SetEquipSetWithId(myCount,equipSetKey,equipSet)
	end
end


