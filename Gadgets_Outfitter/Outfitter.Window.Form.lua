
local cHdr = { r =     1.0, g =     1.0, b =     0.0 }
local rolesAmount = 0
Wykkyd.Outfitter.Selected = {}

function Wykkyd.Outfitter.AttachDragControls(thing, includeEquip)
	thing:EventAttach(Event.UI.Input.Mouse.Left.Down, function(self, h)
		Wykkyd.Outfitter.LeftMouseDown = true;
	end, "Event.UI.Input.Mouse.Left.Down")

	thing:EventAttach(Event.UI.Input.Mouse.Left.Up, function(self, h)
		if not Wykkyd.Outfitter.LeftMouseDown then
			local cursor, held = Inspect.Cursor()
			if cursor == "item" then
				pcall(Command.Item.Standard.Drop, held)
				if includeEquip then
					Wykkyd.Outfitter.AttemptEquip(held,slot);
					Wykkyd.Outfitter.ChangeGear()
				end
			end
		end
		Wykkyd.Outfitter.LeftMouseDown = false
	end, "Event.UI.Input.Mouse.Left.Up")
end

function Wykkyd.Outfitter.ComboBox.Create(myCount, parent, label, default, listItems, sort, onchange, under, attachDrag, dragFunctional)
	local control = wyk.frame.CreateFrame("Control", parent)

	local tfValue = wyk.frame.CreateTextfield("Control_TextField", control)
	tfValue:SetBackgroundColor(0.2,0.2,0.2,0.9)
	control.field = tfValue
	if attachDrag then Wykkyd.Outfitter.AttachDragControls(tfValue, dragFunctional); end

	local txtLabel = nil
	if label then
		txtLabel = wyk.frame.CreateText("Control_Label", control)
		txtLabel:SetText(label)
		txtLabel:SetPoint("TOPLEFT", control, "TOPLEFT")
		control.label = txtLabel
		if under then
			tfValue:SetPoint("TOPLEFT", txtLabel, "BOTTOMLEFT", 0, 0)
		else
			tfValue:SetPoint("CENTERLEFT", txtLabel, "CENTERRIGHT", 8, 0)
		end
		control.value = tfValue
		if attachDrag then Wykkyd.Outfitter.AttachDragControls(txtLabel, dragFunctional); end
	else
		tfValue:SetPoint("TOPLEFT", control, "TOPLEFT", 0, 0)
	end

	local function selectVal(value)
		if txtLabel:GetText() == "Select an Equipment Set:" then
			local setSuccess = false
			Wykkyd.Outfitter.chosenEquipmentSet[myCount] = value
			for _, v in pairs(Wykkyd.Outfitter.ContextConfig[myCount].EquipSetList) do
				if value == v.value then
					tfValue:SetText(v.text)
					setSuccess = true
				end
			end
			if not setSuccess then tfValue:SetText("Set: "..value.."") end
		else
			tfValue:SetText(tostring(value))
		end
	end

	local dropDownIcon = wyk.frame.CreateTexture("Control_Dropdown", tfValue)
	dropDownIcon:SetTexture(wykkydImageSource, "resource/wtDropDown.png")
	dropDownIcon:SetHeight(tfValue:GetHeight())
	dropDownIcon:SetWidth(tfValue:GetHeight())
	dropDownIcon:SetPoint("TOPLEFT", tfValue, "TOPRIGHT", -10, 0)
	if attachDrag then Wykkyd.Outfitter.AttachDragControls(dropDownIcon, dragFunctional); end
	local menu = WT.Control.Menu.Create(parent, listItems, function(value) selectVal(value) end, sort)
	menu:SetPoint("TOPRIGHT", dropDownIcon, "BOTTOMCENTER")
	if attachDrag then Wykkyd.Outfitter.AttachDragControls(menu, dragFunctional); end
	selectVal(default)

	control.SetItems = function(ctrl, inItems)
		menu:SetItems(inItems)
	end

	dropDownIcon:EventAttach(Event.UI.Input.Mouse.Left.Click, function(self, h)
		menu:Toggle()
	end, "Event.UI.Input.Mouse.Left.Click")

	control.GetText = function() return tfValue:GetText() end
	control.SetText =
	function(ctrl, value)
		selectVal(value)
		if onchange then onchange(tostring(value)) end
	end

	if under then
		control:SetHeight(40)
	else
		control:SetHeight(20)
	end
	return control
end

function Wykkyd.Outfitter.TextBox.Create(parent, label, default, onchange, under, attachDrag, dragFunctional)
	local control = wyk.frame.CreateFrame("Control", parent)

	local tfValue = wyk.frame.CreateTextfield("Control_TextField", control)
	tfValue:SetText(default or "")
	tfValue:SetBackgroundColor(0.2,0.2,0.2,0.9)
	if attachDrag then Wykkyd.Outfitter.AttachDragControls(tfValue, dragFunctional); end

	if label then
		local txtLabel = wyk.frame.CreateText("Control_Label", control)
		txtLabel:SetText(label)
		txtLabel:SetPoint("TOPLEFT", control, "TOPLEFT")
		control.label = txtLabel
		if under then
			tfValue:SetPoint("TOPLEFT", txtLabel, "BOTTOMLEFT", 0, 0)
		else
			tfValue:SetPoint("CENTERLEFT", txtLabel, "CENTERRIGHT", 8, 0)
		end
		if attachDrag then Wykkyd.Outfitter.AttachDragControls(txtLabel, dragFunctional); end
	else
		tfValue:SetPoint("TOPLEFT", control, "TOPLEFT", 0, 0)
	end
	control.value = tfValue

	if under then
		control:SetHeight(40)
	else
		control:SetHeight(20)
	end
	return control
end


local function clearFields(myCount, content)
	if Wykkyd.Outfitter.Selected[myCount] == nil then Wykkyd.Outfitter.Selected[myCount] = {} end
	if not Wykkyd.Outfitter.ContextWindow[myCount] then return end
	content.equipsetName.value:SetText("")
	content.makeIcon:SetChecked(false)
	content.icon.set(1)
	content.changeRole:SetChecked(false)
	content.targetRole.slider:SetPosition(1)
	if not Wykkyd.Outfitter.ContextConfig[myCount].ignoreKaruul then
		content.manageKaruul:SetChecked(false)
		content.karuulSet1.slider:SetPosition(1)
		content.karuulSet2.slider:SetPosition(1)
	end
	content.selectedAlertCheck:SetChecked(false)
	content.selectedAlertText:SetText("I'm changing roles, give me a sec...")
	content.selectedAlertChannel:SetText("Raid")
	content.changeWardrobe:SetChecked(false)
	content.targetWardrobe.slider:SetPosition(0)
end

function Wykkyd.Outfitter.PushSettings(myCount, content, vals)
	rolesAmount = wyk.func.GetRoleAmount()

	if Wykkyd.Outfitter.Selected[myCount] == nil then Wykkyd.Outfitter.Selected[myCount] = {} end
	if not Wykkyd.Outfitter.ContextWindow[myCount] then return end
	if vals ~= nil then
		Wykkyd.Outfitter.Selected[myCount].Name = vals.name
		Wykkyd.Outfitter.Selected[myCount].ButtonChk = vals.makeIcon
		Wykkyd.Outfitter.Selected[myCount].Icon = vals.icon
		Wykkyd.Outfitter.Selected[myCount].RoleChk = vals.changeRole
		Wykkyd.Outfitter.Selected[myCount].Role = vals.targetRole
		Wykkyd.Outfitter.Selected[myCount].KaruulChk = vals.manageKaruul
		Wykkyd.Outfitter.Selected[myCount].Set1 = vals.karuulSet1
		Wykkyd.Outfitter.Selected[myCount].Set2 = vals.karuulSet2
		Wykkyd.Outfitter.Selected[myCount].AlertChk = vals.alertCheck
		Wykkyd.Outfitter.Selected[myCount].AlertText = vals.alertText
		Wykkyd.Outfitter.Selected[myCount].AlertChannel = vals.alertChannel
		Wykkyd.Outfitter.Selected[myCount].WardrobeChk = vals.changeWardrobe
		Wykkyd.Outfitter.Selected[myCount].Wardrobe = vals.targetWardrobe
	end
	clearFields(myCount, content)
	for _, v in pairs(vals.ignored) do
		if     v.slot == "seqp.hlm" then content.gear.helmet:SetIgnore(v.ignored)
		elseif v.slot == "seqp.rn1" then content.gear.ring1:SetIgnore(v.ignored)
		elseif v.slot == "seqp.rn2" then content.gear.ring2:SetIgnore(v.ignored)
		elseif v.slot == "seqp.blt" then content.gear.belt:SetIgnore(v.ignored)
		elseif v.slot == "seqp.nck" then content.gear.neck:SetIgnore(v.ignored)
		elseif v.slot == "seqp.tkt" then content.gear.trinket:SetIgnore(v.ignored)
		elseif v.slot == "seqp.chs" then content.gear.chest:SetIgnore(v.ignored)
		elseif v.slot == "seqp.fcs" then content.gear.focus:SetIgnore(v.ignored)
		elseif v.slot == "seqp.hof" then content.gear.handoff:SetIgnore(v.ignored)
		elseif v.slot == "seqp.lgs" then content.gear.legs:SetIgnore(v.ignored)
		elseif v.slot == "seqp.shl" then content.gear.shoulders:SetIgnore(v.ignored)
		elseif v.slot == "seqp.syn" then content.gear.synergy:SetIgnore(v.ignored)
		elseif v.slot == "seqp.rng" then content.gear.ranged:SetIgnore(v.ignored)
		elseif v.slot == "seqp.fet" then content.gear.feet:SetIgnore(v.ignored)
		elseif v.slot == "seqp.hmn" then content.gear.handmain:SetIgnore(v.ignored)
		elseif v.slot == "seqp.glv" then content.gear.gloves:SetIgnore(v.ignored)
		elseif v.slot == "seqp.sel" then content.gear.seal:SetIgnore(v.ignored)
		end
	end
	if Wykkyd.Outfitter.Selected[myCount].EquipmentSet ~= 0 then
		if Wykkyd.Outfitter.Selected[myCount].Name ~= nil then content.equipsetName.value:SetText(Wykkyd.Outfitter.Selected[myCount].Name) end
		if Wykkyd.Outfitter.Selected[myCount].ButtonChk ~= nil then content.makeIcon:SetChecked(Wykkyd.Outfitter.Selected[myCount].ButtonChk)  end
		if Wykkyd.Outfitter.Selected[myCount].Icon ~= nil then content.icon.set(wyk.func.IconID(Wykkyd.Outfitter.Selected[myCount].Icon)) end
		if Wykkyd.Outfitter.Selected[myCount].RoleChk ~= nil then content.changeRole:SetChecked(Wykkyd.Outfitter.Selected[myCount].RoleChk)  end
		if Wykkyd.Outfitter.Selected[myCount].Role ~= nil then
			local iMin = 1
			local iMax = rolesAmount
			local iPos = 1
			if not Wykkyd.Outfitter.Selected[myCount].Role then iPos = 1
			else
				iPos = Wykkyd.Outfitter.Selected[myCount].Role
				if iPos < iMin then iPos = iMin end
				if iPos > iMax then iPos = iMax end
			end
			content.targetRole.slider:SetPosition(iPos)
		end
		if not Wykkyd.Outfitter.ContextConfig[myCount].ignoreKaruul then
			if Wykkyd.Outfitter.Selected[myCount].KaruulChk ~= nil then content.manageKaruul:SetChecked(Wykkyd.Outfitter.Selected[myCount].KaruulChk) end
			if Wykkyd.Outfitter.Selected[myCount].Set1 ~= nil then
				local iMin = 1
				local iMax = rolesAmount
				local iPos = 1
				if not Wykkyd.Outfitter.Selected[myCount].Set1 then iPos = 1
				else
					iPos = Wykkyd.Outfitter.Selected[myCount].Set1
					if iPos < iMin then iPos = iMin end
					if iPos > iMax then iPos = iMax end
				end
				content.karuulSet1.slider:SetPosition(iPos)
			end
			if Wykkyd.Outfitter.Selected[myCount].Set2 ~= nil then
				local iMin = 0
				local iMax = 10
				local iPos = 1
				if not Wykkyd.Outfitter.Selected[myCount].Set2 then iPos = 1
				else
					iPos = Wykkyd.Outfitter.Selected[myCount].Set2
					if iPos < iMin then iPos = iMin end
					if iPos > iMax then iPos = iMax end
				end
				content.karuulSet2.slider:SetPosition(iPos)
			end
		end
		if Wykkyd.Outfitter.Selected[myCount].AlertChk ~= nil then content.selectedAlertCheck:SetChecked(Wykkyd.Outfitter.Selected[myCount].AlertChk) end
		content.selectedAlertText:SetText(Wykkyd.Outfitter.Selected[myCount].AlertText or "I'm changing roles, give me a sec...")
		content.selectedAlertChannel:SetText(Wykkyd.Outfitter.Selected[myCount].AlertChannel or "Raid")
		if Wykkyd.Outfitter.Selected[myCount].WardrobeChk ~= nil then content.changeWardrobe:SetChecked(Wykkyd.Outfitter.Selected[myCount].WardrobeChk) end
		if Wykkyd.Outfitter.Selected[myCount].Wardrobe ~= nil then
			local wardrobeMin = 0 --0 is wardrobe off
			local wardrobeMax = 19 --TODO: 9/12/2013: currently can't check for amount of wardrobes someone has, change as soon as API gives info
			local iPos = 0
			if not Wykkyd.Outfitter.Selected[myCount].Wardrobe then iPos = 0
			else
				iPos = Wykkyd.Outfitter.Selected[myCount].Wardrobe
				if iPos < wardrobeMin then iPos = wardrobeMin end
				if iPos > wardrobeMax then iPos = wardrobeMax end
			end
			content.targetWardrobe.slider:SetPosition(iPos)
		end
	end
end

function Wykkyd.Outfitter.ClearSettings(myCount, content)
	if Wykkyd.Outfitter.Selected[myCount] == nil then Wykkyd.Outfitter.Selected[myCount] = {} end
	if not Wykkyd.Outfitter.ContextWindow[myCount] then return end
	Wykkyd.Outfitter.chosenEquipmentSet[myCount] = 0
	Wykkyd.Outfitter.Selected[myCount].EquipmentSet = 0
	Wykkyd.Outfitter.Selected[myCount].Name = nil
	Wykkyd.Outfitter.Selected[myCount].ButtonChk = false
	Wykkyd.Outfitter.Selected[myCount].Icon = 1
	Wykkyd.Outfitter.Selected[myCount].RoleChk = false
	Wykkyd.Outfitter.Selected[myCount].Role = 1
	Wykkyd.Outfitter.Selected[myCount].KaruulChk = false
	Wykkyd.Outfitter.Selected[myCount].Set1 = 1
	Wykkyd.Outfitter.Selected[myCount].Set2 = 1
	Wykkyd.Outfitter.Selected[myCount].AlertChk = false
	Wykkyd.Outfitter.Selected[myCount].AlertText = "I'm changing roles, give me a sec..."
	Wykkyd.Outfitter.Selected[myCount].AlertChannel = "Raid"
	Wykkyd.Outfitter.Selected[myCount].WardrobeChk = false
	Wykkyd.Outfitter.Selected[myCount].Wardrobe = 1
	clearFields(myCount, content)
end

local function cycleSettings(myCount, content)
	if Wykkyd.Outfitter.Selected[myCount] == nil then Wykkyd.Outfitter.Selected[myCount] = {} end
	if not Wykkyd.Outfitter.ContextWindow[myCount] then return end
	local vals = Wykkyd.Outfitter.EquipSets.Load(myCount, Wykkyd.Outfitter.Selected[myCount].EquipmentSet)
	if vals ~= nil then
		Wykkyd.Outfitter.PushSettings(myCount, content, vals)
	else
		Wykkyd.Outfitter.ClearSettings(myCount, content)
	end
end

local function makeBorders(target, name, c)
	wyk.frame.border(target, 1, c or { r = .65, g = .9, b = .75, a = .5 }, false)
end

local function makeGroup(target, name, h, w, l, bg, border)
	local fg = wyk.frame.CreateFrame(name, target)
	fg:SetLayer(l)
	fg:SetHeight(h)
	fg:SetWidth(w)
	fg:SetBackgroundColor(bg.r, bg.g, bg.b, bg.a)
	makeBorders(fg, name, border)
	return fg
end

function Wykkyd.Outfitter.BuildForm(myCount)
	rolesAmount = wyk.func.GetRoleAmount()
	if not Wykkyd.Outfitter.ContextWindow[myCount] then return end
	local window = Wykkyd.Outfitter.ContextWindow[myCount]
	myCount = window.myCount
	local content = window:GetContent()
	local uName = "wykkydOutfitter"

	local innerBackground = { r = 0, g = 0, b = 0, a = .3 }
	local innerBorder = { r = .65, g = .75, b = .9, a = .5 }

	local icoSize = 34
	local brdSize = 48
	local icoScale1 = 1.55
	local icoScale2 = 1.25
	local icoScale3 = 1
	local brdSz = brdSize*icoScale1
	local icoSz1 = icoSize*icoScale1

	Wykkyd.Outfitter.chosenEquipmentSet[myCount] = 0
	if Wykkyd.Outfitter.ignoredSlots[myCount] == nil then Wykkyd.Outfitter.ignoredSlots[myCount] = Wykkyd.Outfitter.Globals.IgnoredSlots end
	if Wykkyd.Outfitter.draggedSlots[myCount] == nil then Wykkyd.Outfitter.draggedSlots[myCount] = Wykkyd.Outfitter.Globals.DraggedSlots end

	Wykkyd.Outfitter.PrepList(myCount)

	local formGroup1 = makeGroup(content, uName.."_formGroup1", 60, 351, 24, { r = 0, g = 0, b = 0, a = .4 })
	formGroup1:SetPoint("TOPCENTER", content, "TOPCENTER", 0, 19)

	local formEquipList = Wykkyd.Outfitter.ComboBox.Create(myCount, formGroup1, "Select an Equipment Set:", 0, Wykkyd.Outfitter.ContextConfig[myCount].EquipSetList, true, false, true, false, false)
	formEquipList:SetPoint("LEFTCENTER", formGroup1, "LEFTCENTER", 4, 0)
	formEquipList.label:SetFontColor(cHdr.r, cHdr.g, cHdr.b, 1)
	content.selectedSet = formEquipList
	formEquipList:SetLayer(20)
	Wykkyd.Outfitter.addWindowChild(myCount, formEquipList.value)

	local formLoadBtn = wyk.frame.CreateButton(uName.."_loadBtn", formGroup1)
	formLoadBtn:SetText("Load Set")
	formLoadBtn:SetPoint("BOTTOMRIGHT", formGroup1, "BOTTOMRIGHT", 0, 0)
	formLoadBtn:SetLayer(20)
	Wykkyd.Outfitter.AttachDragControls(formLoadBtn, false)

	local formDelBtn = wyk.frame.CreateButton(uName.."_delBtn", formGroup1)
	formDelBtn:SetText("Delete")
	formDelBtn:SetPoint("TOPRIGHT", formGroup1, "TOPRIGHT", 0, 0)
	formDelBtn:SetLayer(20)
	Wykkyd.Outfitter.AttachDragControls(formDelBtn, false)


	local formGroup2 = makeGroup(content, uName.."_formGroup2", 384, 351, 20, { r = 0, g = 0, b = 0, a = .4 })
	formGroup2:SetPoint("TOPCENTER", formGroup1, "BOTTOMCENTER", 0, 16)


	local formGroup3 = makeGroup(formGroup2, uName.."_formGroup3", 60, 343, 20, innerBackground, innerBorder)
	formGroup3:SetPoint("TOPCENTER", formGroup2, "TOPCENTER", 0, 4)

	local formEquipName = Wykkyd.Outfitter.TextBox.Create(formGroup3, "Equipment Set Name:", "", false, true, false, false)
	formEquipName:SetPoint("LEFTCENTER", formGroup3, "LEFTCENTER", 4, 0)
	formEquipName.label:SetFontColor(cHdr.r, cHdr.g, cHdr.b, 1)
	content.equipsetName = formEquipName
	formEquipName:SetLayer(20)
	Wykkyd.Outfitter.addWindowChild(myCount, formEquipName.value)

	local formSaveBtn = wyk.frame.CreateButton( uName.."_saveBtn", formGroup3)
	formSaveBtn:SetText("Save Set")
	formSaveBtn:SetPoint("BOTTOMRIGHT", formGroup3, "BOTTOMRIGHT", 0, 0)
	formSaveBtn:SetLayer(20)
	Wykkyd.Outfitter.AttachDragControls(formSaveBtn, false)

	local formClearBtn = wyk.frame.CreateButton( uName.."_clearBtn", formGroup3)
	formClearBtn:SetText("Clear")
	formClearBtn:SetPoint("TOPRIGHT", formGroup3, "TOPRIGHT", 0, 0)
	formClearBtn:SetLayer(20)
	Wykkyd.Outfitter.AttachDragControls(formClearBtn, false)


	local formGroup4 = makeGroup(formGroup2, uName.."_formGroup3", 100, 221, 20, innerBackground, innerBorder)
	formGroup4:SetPoint("TOPLEFT", formGroup3, "BOTTOMLEFT", 0, 4)

	local chkButton = wyk.frame.CreateCheckbox(uName.."_chkUseIcon", formGroup4)
	local chkButtonLbl = wyk.frame.CreateText(uName.."_lblUseIcon", formGroup4)
	chkButtonLbl:SetText("Make a button!")
	chkButtonLbl:SetFontColor(cHdr.r, cHdr.g, cHdr.b, 1)
	chkButton:SetLayer(20)
	chkButtonLbl:SetLayer(20)
	Wykkyd.Outfitter.AttachDragControls(chkButton, false)
	Wykkyd.Outfitter.AttachDragControls(chkButtonLbl, false)
	content.makeIcon = chkButton

	local staticIcon = wyk.frame.CreateTexture( uName.."_staticIcon", formGroup4)
	staticIcon:SetHeight(icoSz1)
	staticIcon:SetWidth(icoSz1)
	staticIcon:SetAlpha(1)
	staticIcon:SetLayer(24)
	content.icon = staticIcon
	staticIcon.set = function(value)
		content.iconSelected = value
		content.icon:SetTexture( wyk.vars.Icons[value].src, wyk.vars.Icons[value].file )
	end
	content.iconSelected = 1
	staticIcon:SetTexture( wyk.vars.Icons[1].src, wyk.vars.Icons[1].file )
	Wykkyd.Outfitter.AttachDragControls(staticIcon, false)

	local staticIconBrd = wyk.frame.CreateTexture( uName.."_staticIconBrd", formGroup4)
	staticIconBrd:SetHeight(brdSz)
	staticIconBrd:SetWidth(brdSz)
	staticIconBrd:SetAlpha(1)
	staticIconBrd:SetLayer(23)
	staticIconBrd:SetTexture( wyk.vars.Images.borders.gray.src, wyk.vars.Images.borders.gray.file )
	Wykkyd.Outfitter.AttachDragControls(staticIconBrd, false)

	local btnChangeIcon = wyk.frame.CreateButton( uName.."_iconChgBtn", formGroup4)
	btnChangeIcon:SetText("Change Icon")
	btnChangeIcon:SetLayer(23)

	btnChangeIcon:EventAttach(Event.UI.Input.Mouse.Left.Click, function(self, h)
		Wykkyd.Outfitter.ImageSlider(
		myCount,
		content,
		{One = "TOPCENTER", Two = "TOPCENTER", X = 0, Y = 120},
		30,
		content.iconSelected,
		function(value)
			content.iconSelected = value;
			content.icon:SetTexture( wyk.vars.Icons[value].src, wyk.vars.Icons[value].file );
		end
		)
	end, "Event.UI.Input.Mouse.Left.Click")

	Wykkyd.Outfitter.AttachDragControls(btnChangeIcon, false)

	staticIconBrd:SetPoint("LEFTCENTER", formGroup4, "LEFTCENTER", 4, 0)
	staticIcon:SetPoint("CENTER", staticIconBrd, "CENTER", 0, 0)
	chkButton:SetPoint("LEFTCENTER", staticIconBrd, "RIGHTCENTER", 12, -16)
	chkButtonLbl:SetPoint("LEFTCENTER", chkButton, "RIGHTCENTER", 4, 2)
	btnChangeIcon:SetPoint("LEFTCENTER", staticIconBrd, "RIGHTCENTER", 2, 16)


	local formGroup5 = makeGroup(formGroup2, uName.."_formGroup5", 100, 116, 20, innerBackground, innerBorder)
	formGroup5:SetPoint("TOPRIGHT", formGroup3, "BOTTOMRIGHT", 0, 4)

	local chkRole = wyk.frame.CreateCheckbox( wyk.UniqueName("wykkydChangeRoleChk"), formGroup5)
	local chkRoleLbl = wyk.frame.CreateText( wyk.UniqueName("wykkydChangeRoleChkLbl"), formGroup5)
	local roleName = wyk.frame.CreateText( wyk.UniqueName("wykkydRoleName"), formGroup5)
	roleName:SetText(wyk.func.GetRoleName(1))
	chkRoleLbl:SetText("Change roles!")
	chkRoleLbl:SetFontColor(cHdr.r, cHdr.g, cHdr.b, 1)
	chkRole:SetLayer(20)
	chkRoleLbl:SetLayer(20)
	Wykkyd.Outfitter.AttachDragControls(chkRole, false)
	Wykkyd.Outfitter.AttachDragControls(chkRoleLbl, false)
	content.changeRole = chkRole

	local func = function(frame,num)
		roleName:SetText(wyk.func.GetRoleName(num))
	end

	local roleSlider = wyk.frame.SlideFrame(uName.."_roleSlider", formGroup5, 92, {L=1, H=rolesAmount}, 1, nil)
	Wykkyd.Outfitter.AttachDragControls(chkRole, false)
	wyk.frame.AttachScrollControls(roleSlider,func)
	roleSlider:SetLayer(20)
	content.targetRole = roleSlider

	chkRole:SetPoint("LEFTCENTER", formGroup5, "LEFTCENTER", 4, -15)
	chkRoleLbl:SetPoint("LEFTCENTER", chkRole, "RIGHTCENTER", 4, 2)
	roleSlider:SetPoint("LEFTCENTER", formGroup5, "LEFTCENTER", 38, 23)
	roleName:SetPoint("LEFTCENTER", roleSlider, "LEFTCENTER",-30,8) 


	if not Wykkyd.Outfitter.ContextConfig[myCount].ignoreKaruul then
		local formGroup6 = makeGroup(formGroup2, uName.."_formGroup6", 88, 343, 20, innerBackground, innerBorder)
		formGroup6:SetPoint("TOPCENTER", formGroup3, "BOTTOMCENTER", 0, 108)

		local chkKaruul = wyk.frame.CreateCheckbox( uName.."_chkKaruul", formGroup6)
		local chkKaruulLbl = wyk.frame.CreateText( uName.."_lblKaruul", formGroup6)
		chkKaruulLbl:SetText("Manage Karuul Alerts when I swap to this Set.")
		chkKaruulLbl:SetFontColor(cHdr.r, cHdr.g, cHdr.b, 1)
		chkKaruul:SetLayer(20)
		chkKaruulLbl:SetLayer(20)
		Wykkyd.Outfitter.AttachDragControls(chkKaruul, false)
		Wykkyd.Outfitter.AttachDragControls(chkKaruulLbl, false)
		content.manageKaruul = chkKaruul

		local karuulSlider1 = wyk.frame.SlideFrame(uName.."_KASlider1", formGroup6, 134, {L=1, H=rolesAmount}, 1, "Set")
		Wykkyd.Outfitter.AttachDragControls(chkKaruul, false)
		karuulSlider1.label:SetFontColor(cHdr.r, cHdr.g, cHdr.b, 1)
		karuulSlider1:SetLayer(20)
		Wykkyd.Outfitter.AttachDragControls(karuulSlider1, false)
		wyk.frame.AttachScrollControls(karuulSlider1)
		content.karuulSet1 = karuulSlider1

		local karuulSlider2 = wyk.frame.SlideFrame(uName.."_KASlider2", formGroup6, 134, {L=0, H=10}, 1, "Subset (0 is off)")
		Wykkyd.Outfitter.AttachDragControls(chkKaruul, false)
		karuulSlider2.label:SetFontColor(cHdr.r, cHdr.g, cHdr.b, 1)
		karuulSlider2:SetLayer(20)
		Wykkyd.Outfitter.AttachDragControls(karuulSlider2, false)
		wyk.frame.AttachScrollControls(karuulSlider2)
		content.karuulSet2 = karuulSlider2

		chkKaruul:SetPoint("TOPCENTER", formGroup6, "TOPCENTER", -124, 4)
		chkKaruulLbl:SetPoint("LEFTCENTER", chkKaruul, "RIGHTCENTER", 6, 2)
		karuulSlider1:SetPoint("TOPLEFT", formGroup6, "TOPCENTER", -108, 40)
		karuulSlider2:SetPoint("TOPRIGHT", formGroup6, "TOPCENTER", 108, 40)
	end


	local formGroup7 = makeGroup(formGroup2, uName.."_formGroup7", 56, 343, 20, innerBackground, innerBorder)
	formGroup7:SetPoint("TOPCENTER", formGroup3, "BOTTOMCENTER", 0, 200)

	local alertCheck = wyk.frame.CreateCheckbox( uName.."_chkAlert", formGroup7)
	local alertLabel = wyk.frame.CreateText( uName.."_lblAlert", formGroup7)
	local alertText = wyk.frame.CreateTextfield( uName.."_txtAlert", formGroup7)
	local alertChannel = Wykkyd.Outfitter.ComboBox.Create(myCount, formGroup7, "Channel:", "Raid", {"Raid", "Group", "Yell", "Say"}, true, false, true, false, false)
	alertChannel.label:SetFontColor(cHdr.r, cHdr.g, cHdr.b, 1)
	alertChannel.field:SetWidth(90)
	alertChannel:SetLayer(21)
	Wykkyd.Outfitter.addWindowChild(myCount, alertChannel.value)
	alertLabel:SetText("Alert others when I change:")
	alertText:SetWidth(214)
	alertText:SetText("I'm changing roles, give me a sec...")
	alertText:SetBackgroundColor(0.2,0.2,0.2,0.9)
	Wykkyd.Outfitter.AttachDragControls(alertText, false)
	alertLabel:SetFontColor(cHdr.r, cHdr.g, cHdr.b, 1)

	content.selectedAlertCheck = alertCheck
	content.selectedAlertText = alertText
	content.selectedAlertChannel = alertChannel.field

	alertCheck:SetPoint("LEFTCENTER", formGroup7, "LEFTCENTER", 4, -13)
	alertLabel:SetPoint("LEFTCENTER", alertCheck, "RIGHTCENTER", 4, 2)
	alertText:SetPoint("LEFTCENTER", formGroup7, "LEFTCENTER", 4, 9)
	alertChannel:SetPoint("RIGHTCENTER", formGroup7, "RIGHTCENTER", -70, 0)

	local formGroup8 = makeGroup(formGroup2, uName.."_formGroup8", 56, 343, 20, innerBackground, innerBorder)
	formGroup8:SetPoint("TOPCENTER", formGroup3, "BOTTOMCENTER", 0, 260)

	local chkWardrobe = wyk.frame.CreateCheckbox( wyk.UniqueName("wykkydChangeWardrobeChk"), formGroup8)
	local chkWardrobeLbl = wyk.frame.CreateText( wyk.UniqueName("wykkydChangeWardrobeChkLbl"), formGroup8)
	chkWardrobeLbl:SetText("Change Wardrobes!")
	chkWardrobeLbl:SetFontColor(cHdr.r, cHdr.g, cHdr.b, 1)
	chkWardrobe:SetLayer(20)
	chkWardrobeLbl:SetLayer(20)
	Wykkyd.Outfitter.AttachDragControls(chkWardrobe, false)
	Wykkyd.Outfitter.AttachDragControls(chkWardrobeLbl, false)
	content.changeWardrobe = chkWardrobe

	local wardrobeSlider = wyk.frame.SlideFrame(uName.."_wardrobeSlider", formGroup8, 134, {L=0, H=19}, 1, "Set(0 is equipment)")
	Wykkyd.Outfitter.AttachDragControls(wardrobeSlider, false)
	wardrobeSlider.label:SetFontColor(cHdr.r, cHdr.g, cHdr.b, 1)
	wardrobeSlider:SetLayer(20)
	Wykkyd.Outfitter.AttachDragControls(wardrobeSlider, false)
	wyk.frame.AttachScrollControls(wardrobeSlider)
	content.targetWardrobe = wardrobeSlider

	chkWardrobe:SetPoint("LEFTCENTER",formGroup8,"LEFTCENTER",4,-13)
	chkWardrobeLbl:SetPoint("LEFTCENTER",chkWardrobe,"RIGHTCENTER",4,2)
	wardrobeSlider:SetPoint("TOPRIGHT", formGroup8, "TOPCENTER", 108, 10)
	Wykkyd.Outfitter.ClearSettings(myCount, content)

	formEquipList:EventAttach(Event.UI.Input.Mouse.Cursor.Out, function(self, h)
		WT.Utility.ClearKeyFocus(formEquipList.value)
	end, "Event.UI.Input.Mouse.Cursor.Out")

	formEquipName:EventAttach(Event.UI.Input.Mouse.Cursor.Out, function(self, h)
		WT.Utility.ClearKeyFocus(formEquipName.value)
	end, "Event.UI.Input.Mouse.Cursor.Out")


	formSaveBtn:EventAttach(Event.UI.Input.Mouse.Left.Click, function(self, h)
		if formEquipName.value:GetText() ~= nil and formEquipName.value:GetText() ~= "" then
			if wyk.func.Trim(formEquipName.value:GetText()) ~= "" then
				Wykkyd.Outfitter.Selected[myCount].Name = content.equipsetName.value:GetText()
				Wykkyd.Outfitter.Selected[myCount].ButtonChk = content.makeIcon:GetChecked()
				Wykkyd.Outfitter.Selected[myCount].Icon = wyk.vars.Icons[content.iconSelected].file
				Wykkyd.Outfitter.Selected[myCount].RoleChk = content.changeRole:GetChecked()
				Wykkyd.Outfitter.Selected[myCount].Role = content.targetRole.slider:GetPosition()
				Wykkyd.Outfitter.Selected[myCount].KaruulChk = content.manageKaruul:GetChecked()
				Wykkyd.Outfitter.Selected[myCount].Set1 = content.karuulSet1.slider:GetPosition()
				Wykkyd.Outfitter.Selected[myCount].Set2 = content.karuulSet2.slider:GetPosition()
				Wykkyd.Outfitter.Selected[myCount].AlertChk = content.selectedAlertCheck:GetChecked()
				Wykkyd.Outfitter.Selected[myCount].AlertText = content.selectedAlertText:GetText()
				Wykkyd.Outfitter.Selected[myCount].AlertChannel = content.selectedAlertChannel:GetText()
				Wykkyd.Outfitter.Selected[myCount].WardrobeChk = content.changeWardrobe:GetChecked()
				Wykkyd.Outfitter.Selected[myCount].Wardrobe = content.targetWardrobe.slider:GetPosition()
				Wykkyd.Outfitter.EquipSets.Save(myCount, Wykkyd.Outfitter.Selected[myCount].EquipmentSet)
				--TODO see if I can move these two lines outside of the if and eventually use defaultButtonBehaviour() here.
				cycleSettings(myCount, content)
				formEquipList:SetItems(Wykkyd.Outfitter.ContextConfig[myCount].EquipSetList)
				formEquipList:SetText(Wykkyd.Outfitter.Selected[myCount].EquipmentSet)
			end
		end
		WT.Utility.ClearKeyFocus(formEquipList.value)
		WT.Utility.ClearKeyFocus(formEquipName.value)
	end, "Event.UI.Input.Mouse.Left.Click")

	formLoadBtn:EventAttach(Event.UI.Input.Mouse.Left.Click, function(self, h)
		Wykkyd.Outfitter.Selected[myCount].EquipmentSet = Wykkyd.Outfitter.chosenEquipmentSet[myCount]
		defaultButtonBehaviour(myCount,content,formEquipList,formEquipName)
	end, "Event.UI.Input.Mouse.Left.Click")

	formClearBtn:EventAttach(Event.UI.Input.Mouse.Left.Click, function(self, h)
		Wykkyd.Outfitter.Selected[myCount].EquipmentSet = 0
		defaultButtonBehaviour(myCount,content,formEquipList,formEquipName)
	end, "Event.UI.Input.Mouse.Left.Click")

	formDelBtn:EventAttach(Event.UI.Input.Mouse.Left.Click, function(self, h)
		Wykkyd.Outfitter.EquipSets.Delete(myCount, Wykkyd.Outfitter.chosenEquipmentSet[myCount])
		Wykkyd.Outfitter.PrepList(myCount)
		Wykkyd.Outfitter.ClearSettings(myCount, content)
		defaultButtonBehaviour(myCount,content,formEquipList,formEquipName)
	end, "Event.UI.Input.Mouse.Left.Click")

end

function defaultButtonBehaviour(myCount,content,formEquipList,formEquipName)
	cycleSettings(myCount, content)
	formEquipList:SetItems(Wykkyd.Outfitter.ContextConfig[myCount].EquipSetList)
	formEquipList:SetText(Wykkyd.Outfitter.Selected[myCount].EquipmentSet)
	WT.Utility.ClearKeyFocus(formEquipList.value)
	WT.Utility.ClearKeyFocus(formEquipName.value)
end
