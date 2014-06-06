local toc, data = ...

Wykkyd.Outfitter.LeftMouseDown = false
local outfitFrame = false
local slotScale = 1

function Wykkyd.Outfitter.BuildEquipSlot(myCount, slot, attachTo, size, side, parent)
    if Wykkyd.Outfitter.ignoredSlots[myCount] == nil then Wykkyd.Outfitter.ignoredSlots[myCount] = Wykkyd.Outfitter.Globals.IgnoredSlots end
    if Wykkyd.Outfitter.draggedSlots[myCount] == nil then Wykkyd.Outfitter.draggedSlots[myCount] = Wykkyd.Outfitter.Globals.DraggedSlots end
    
    local fldSubName = slot
    if fldSubName == nil then fldSubName = "ph" end
    local fldName = "wykOutfitter_"..fldSubName

    local borderSize = wyk.vars.Images.sizes.border * slotScale
    local iconSize = wyk.vars.Images.sizes.equip * slotScale
    local placeHolder = false
    
    local buttonScale = .75
    local buttonShift = 0
    
    local downShift = 0
    
    if slot == nil then
        slot = "placeholder"
        placeHolder = true
    end
    
    local scale = 1
    
    if size == 2 then
        scale = .75
        borderSize = borderSize * .75
        iconSize = iconSize * .75
    elseif size == 1 then
        scale = .85
        borderSize = borderSize * .85
        iconSize = iconSize * .85
    end

    local slotWrapper = wyk.frame.CreateFrame(fldName, attachTo, {
		SetWidth = borderSize,
		SetHeight = borderSize,
		SetLayer = 3,
	}, false)
    
    local slotBorder = wyk.frame.CreateTexture(fldName.."_border", slotWrapper, {
		SetPoint = {point="CENTER", target=slotWrapper, targetpoint="CENTER", x=0, y=0},
		SetWidth = borderSize,
		SetHeight = borderSize,
		SetLayer = 12,
	}, false)
    if placeHolder then 
        slotBorder:SetTexture(wyk.vars.Images.borders.disabled.src, wyk.vars.Images.borders.disabled.file)
        slotBorder:SetAlpha(.35) 
    else
        slotBorder:SetAlpha(.9)
    end
    slotWrapper.border = slotBorder
    
	local slotIcon = wyk.frame.CreateTexture(fldName.."_icon", slotWrapper, {
		SetPoint = {point="CENTER", target=slotWrapper, targetpoint="CENTER", x=0, y=0},
		SetWidth = iconSize,
		SetHeight = iconSize,
		SetLayer = 10,
	}, false)
    slotWrapper.icon = slotIcon
	slotIcon:EventAttach(Event.UI.Input.Mouse.Cursor.In,function(self, h)
		if Wykkyd.Outfitter.displayedGear[myCount][slot] then 
			--local mouse = Inspect.Mouse()
			Wykkyd.Outfitter.OpenTooltipWindow(myCount, Wykkyd.Outfitter.displayedGear[myCount][slot]) 
		end	
	end, "Event.UI.Input.Mouse.Cursor.In")

	slotIcon:EventAttach(Event.UI.Input.Mouse.Cursor.Out, function(self, h)
		Wykkyd.Outfitter.OpenTooltipWindow(myCount, nil)
	end, "Event.UI.Input.Mouse.Cursor.Out")
    
	slotIcon:EventAttach(Event.UI.Input.Mouse.Left.Down, function(self, h)
		Wykkyd.Outfitter.LeftMouseDown = true;
	end, "Event.UI.Input.Mouse.Left.Down")	
    
	slotIcon:EventAttach(Event.UI.Input.Mouse.Left.Up, function(self, h)
		if not Wykkyd.Outfitter.LeftMouseDown then
			local cursor, held = Inspect.Cursor()
			if(cursor and cursor == "item") then
				Command.Item.Standard.Drop(held)
				Wykkyd.Outfitter.AttemptEquip(held, slot, Wykkyd.Outfitter.FindEmptySlots())
				Wykkyd.Outfitter.ChangeGear()
			end
		end
		Wykkyd.Outfitter.LeftMouseDown = false
	end, "Event.UI.Input.Mouse.Left.Up")
	
	local slotIgnoreScreen = wyk.frame.CreateFrame(fldName.."_ignoreScreen", slotWrapper, {
		SetPoint = {point="CENTER", target=slotIcon, targetpoint="CENTER", x=0, y=0},
		SetWidth = iconSize,
		SetHeight = iconSize,
	}, false)
    if not placeHolder then slotIgnoreScreen:SetBackgroundColor(.75,.25,.25,0.65) end
    slotIgnoreScreen:SetVisible(false)
    slotIgnoreScreen:SetLayer(18)
    slotWrapper.ignore = slotIgnoreScreen
    slotWrapper.SetIgnore = function(ctrl, value) 
        local window = Wykkyd.Outfitter.ContextWindow[myCount]
        local content = window:GetContent()
        if value then
            content.gear[slot].border:SetTexture(
                            wyk.vars.Images.borders.disabled.src, 
                            wyk.vars.Images.borders.disabled.file
                        )
        else
            content.gear[slot].border:SetTexture(
                            wyk.vars.Images.borders.disabled.src, 
                            wyk.vars.Images.borders.disabled.file
                        )
        end
        content.gear[slot].ignore:SetVisible(value)
        Wykkyd.Outfitter.ignoredSlots[myCount][slot] = value
    end
    
    if not placeHolder then 
        local slotIgnore = wyk.frame.CreateTexture(fldName.."_ignore", slotWrapper, {
			SetHeight = 28 * scale,
			SetWidth = 28 * scale,
			SetTexture = wyk.vars.Images.other.lock,
			SetAlpha = .9,
			SetLayer = 24,
		}, false)

		slotIgnore:EventAttach(Event.UI.Input.Mouse.Left.Click, function(self, h)
            if not Wykkyd.Outfitter.ContextWindow[myCount] then return end
            local window = Wykkyd.Outfitter.ContextWindow[myCount]
            local content = window:GetContent()
            if Wykkyd.Outfitter.ignoredSlots[myCount][slot] then
                Wykkyd.Outfitter.ignoredSlots[myCount][slot] = false
            else
                Wykkyd.Outfitter.ignoredSlots[myCount][slot] = true
            end
            local location = content.gear[slot]
            if location then
                location.ignore:SetVisible(Wykkyd.Outfitter.ignoredSlots[myCount][slot])
            end
		end, "Event.UI.Input.Mouse.Left.Click")

		slotIgnore:EventAttach(Event.UI.Input.Mouse.Left.Down, function(self, h)
			Wykkyd.Outfitter.LeftMouseDown = true;
		end, "Event.UI.Input.Mouse.Left.Down")
        
		slotIgnore:EventAttach(Event.UI.Input.Mouse.Left.Up, function(self, h)
            if not Wykkyd.Outfitter.LeftMouseDown then
                local cursor, held = Inspect.Cursor()
                if(cursor and cursor == "item") then
                    pcall(Command.Item.Standard.Drop, held)
                end
            end
            Wykkyd.Outfitter.LeftMouseDown = false
		end, "Event.UI.Input.Mouse.Left.Up")
		
		slotWrapper.ignoreBtn = slotIgnore
        
        if side == "LEFT" then
            slotIgnore:SetPoint("CENTER", slotBorder, "LEFTCENTER", 2, 0)
        elseif side == "RIGHT" then
            slotIgnore:SetPoint("CENTER", slotBorder, "RIGHTCENTER", -2, 0)
        else
            slotIgnore:SetPoint("CENTER", slotBorder, "RIGHTCENTER", -2, 0)
        end
    end
    
    if parent == nil then
        if side == "LEFT" then
            slotWrapper:SetPoint("TOPLEFT", attachTo, "TOPLEFT", 4, 4)
        elseif side == "RIGHT" then
            slotWrapper:SetPoint("TOPRIGHT", attachTo, "TOPRIGHT", -4, 4)
        else
            if not placeHolder and side == "BOTTOMCENTER" then 
                slotWrapper:SetPoint(side, attachTo, side, buttonShift, 8)
            else
                slotWrapper:SetPoint(side, attachTo, side, 0, 0)
            end
        end
    else
        if side == "LEFT" then
            slotWrapper:SetPoint("TOPRIGHT", parent, "BOTTOMRIGHT", 0, -6)
        elseif side == "RIGHT" then
            slotWrapper:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 0, -6)
        else
            if not placeHolder and side == "BOTTOMCENTER" then 
                slotWrapper:SetPoint(side, parent, side, buttonShift, 0)
            else
                slotWrapper:SetPoint(side, attachTo, side, 0, 0)
            end
        end
    end
    
    return slotWrapper
end
local function eqpSlot(myCount, slot, attachTo, size, side, parent)
    return Wykkyd.Outfitter.BuildEquipSlot(myCount, slot, attachTo, size, side, parent)
end

local function ShowGear(gear, slot, name)
    if gear then
        slot.icon:SetTexture( "Rift", gear.icon )
		if gear.rarity == "relic" then
			slot.border:SetTexture( 
				wyk.vars.Images.borders.relic.src, 
				wyk.vars.Images.borders.relic.file 
			)
		elseif gear.rarity == "epic" then
			slot.border:SetTexture( 
				wyk.vars.Images.borders.epic.src, 
				wyk.vars.Images.borders.epic.file 
			)
		elseif gear.rarity == "uncommon" then
			slot.border:SetTexture( 
				wyk.vars.Images.borders.uncommon.src, 
				wyk.vars.Images.borders.uncommon.file 
			)
		elseif gear.rarity == "rare" then
			slot.border:SetTexture( 
				wyk.vars.Images.borders.rare.src, 
				wyk.vars.Images.borders.rare.file 
			)
		else
			slot.border:SetTexture( 
				wyk.vars.Images.borders.default.src, 
				wyk.vars.Images.borders.default.file 
			)
		end
    else
        slot.border:SetTexture(
            wyk.vars.Images.borders.disabled.src, 
            wyk.vars.Images.borders.disabled.file
        )
        slot.icon:SetTexture(
            wyk.vars.Images.slots[name].src, 
            wyk.vars.Images.slots[name].file
        )
    end
end

function Wykkyd.Outfitter.LoadEquipment(myCount)
    if not Wykkyd.Outfitter.ContextWindow[myCount] then return end
    local window = Wykkyd.Outfitter.ContextWindow[myCount]
    local content = window:GetContent()
    
    Wykkyd.Outfitter.displayedGearSlot[myCount] = {
        helmet      = wyk.func.DeriveSlot("helmet"),
        shoulders   = wyk.func.DeriveSlot("shoulders"),
        cape       	= wyk.func.DeriveSlot("cape"),
        chest       = wyk.func.DeriveSlot("chest"),
        gloves      = wyk.func.DeriveSlot("gloves"),
        belt        = wyk.func.DeriveSlot("belt"),
        legs        = wyk.func.DeriveSlot("legs"),
        feet        = wyk.func.DeriveSlot("feet"),
        handmain    = wyk.func.DeriveSlot("handmain"),
        handoff     = wyk.func.DeriveSlot("handoff"),
        ranged      = wyk.func.DeriveSlot("ranged"),
        neck        = wyk.func.DeriveSlot("neck"),
        trinket     = wyk.func.DeriveSlot("trinket"),
        ring1       = wyk.func.DeriveSlot("ring1"),
        ring2       = wyk.func.DeriveSlot("ring2"),
        synergy     = wyk.func.DeriveSlot("synergy"),
        seal        = wyk.func.DeriveSlot("seal"),
        focus       = wyk.func.DeriveSlot("focus"),
    }
    Wykkyd.Outfitter.displayedGear[myCount] = {
        helmet      = wyk.func.DeriveItem("helmet"),
        shoulders   = wyk.func.DeriveItem("shoulders"),
        cape       	= wyk.func.DeriveItem("cape"),
        chest       = wyk.func.DeriveItem("chest"),
        gloves      = wyk.func.DeriveItem("gloves"),
        belt        = wyk.func.DeriveItem("belt"),
        legs        = wyk.func.DeriveItem("legs"),
        feet        = wyk.func.DeriveItem("feet"),
        handmain    = wyk.func.DeriveItem("handmain"),
        handoff     = wyk.func.DeriveItem("handoff"),
        ranged      = wyk.func.DeriveItem("ranged"),
        neck        = wyk.func.DeriveItem("neck"),
        trinket     = wyk.func.DeriveItem("trinket"),
        ring1       = wyk.func.DeriveItem("ring1"),
        ring2       = wyk.func.DeriveItem("ring2"),
        synergy     = wyk.func.DeriveItem("synergy"),
        seal        = wyk.func.DeriveItem("seal"),
        focus       = wyk.func.DeriveItem("focus"),
    }
    
    local worn = Wykkyd.Outfitter.displayedGear[myCount]
    
    ShowGear( worn.helmet, content.gear.helmet, "helmet" )
    ShowGear( worn.cape, content.gear.cape, "cape" )
    ShowGear( worn.shoulders, content.gear.shoulders, "shoulders" )
    ShowGear( worn.chest, content.gear.chest, "chest" )
    ShowGear( worn.gloves, content.gear.gloves, "gloves" )
    ShowGear( worn.belt, content.gear.belt, "belt" )
    ShowGear( worn.legs, content.gear.legs, "legs" )
    ShowGear( worn.feet, content.gear.feet, "feet" )
    ShowGear( worn.handmain, content.gear.handmain, "handmain" )
    ShowGear( worn.handoff, content.gear.handoff, "handoff" )
    ShowGear( worn.ranged, content.gear.ranged, "ranged" )
    ShowGear( worn.neck, content.gear.neck, "neck" )
    ShowGear( worn.trinket, content.gear.trinket, "trinket" )
    ShowGear( worn.ring1, content.gear.ring1, "ring1" )
    ShowGear( worn.ring2, content.gear.ring2, "ring2" )
    ShowGear( worn.synergy, content.gear.synergy, "synergy" )
    ShowGear( worn.seal, content.gear.seal, "seal" )
    ShowGear( worn.focus, content.gear.focus, "focus" )
end

function Wykkyd.Outfitter.LoadOutfit( myCount, set )
    if not Wykkyd.Outfitter.ContextWindow[myCount] then return end
    local window = Wykkyd.Outfitter.ContextWindow[myCount]
    local content = window:GetContent()
end

function Wykkyd.Outfitter.UpdateWindow(updates)
    Wykkyd.Outfitter.ChangeGear()
    for ii = 1, wykkydContextCount, 1 do
        if Wykkyd.Outfitter.ContextWindowOpen[ii] then
            Wykkyd.Outfitter.LoadEquipment(ii)
        end
    end
end

function Wykkyd.Outfitter.WindowPos(newX, newY)
    for ii = 1, wykkydContextCount, 1 do
        if Wykkyd.Outfitter.ContextConfig[ii] == nil then Wykkyd.Outfitter.ContextConfig[ii] = {}; end
        if Wykkyd.Outfitter.ContextConfig[ii].Window == nil then Wykkyd.Outfitter.ContextConfig[ii].Window = {}; end
        Wykkyd.Outfitter.ContextConfig[ii].Window.xpos = newX
        Wykkyd.Outfitter.ContextConfig[ii].Window.ypos = newY
    end
end

function Wykkyd.Outfitter.OpenWindow(contextCount) --id)

    local fldName = "wykOutfitter"
    
    local myCount = contextCount
    local inContext = Wykkyd.Outfitter.Context[myCount]
    if inContext == nil then inContext = WT.Context end
    
    local setNewPos = false
    if not Wykkyd.Outfitter.ContextWindow[myCount] then
        Wykkyd.Outfitter.ContextWindow[myCount] = UI.CreateFrame("SimpleWindow", fldName, inContext)
        local window = Wykkyd.Outfitter.ContextWindow[myCount]
        window.myCount = myCount
        window:SetVisible(false)
        if Wykkyd.Outfitter.ContextConfig[myCount] == nil then Wykkyd.Outfitter.ContextConfig[myCount] = {}; end
        if Wykkyd.Outfitter.ContextConfig[myCount].Window ~= nil then
            if Wykkyd.Outfitter.ContextConfig[myCount].Window.xpos ~= nil and Wykkyd.Outfitter.ContextConfig[myCount].Window.ypos ~= nil then
                window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", Wykkyd.Outfitter.ContextConfig[myCount].Window.xpos, Wykkyd.Outfitter.ContextConfig[myCount].Window.ypos)
            else setNewPos = true
            end
        else
            setNewPos = true
        end
        if setNewPos then
            window:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
            Wykkyd.Outfitter.WindowPos( window:GetLeft(), window:GetTop() )
        end
		window:SetWidth(530)
		window:SetHeight(580)
		window:SetLayer(11000)
        window:SetTitle("Gadgets: Outfitter  v"..WykkydOutfitterVersion)

		window:EventAttach(Event.UI.Input.Mouse.Left.Down, function(self, h)
			Wykkyd.Outfitter.LeftMouseDown = true;
		end, "Event.UI.Input.Mouse.Left.Down")
	

		window:EventAttach(Event.UI.Input.Mouse.Left.Up, function(self, h)
			if not Wykkyd.Outfitter.LeftMouseDown then
				local cursor, held = Inspect.Cursor()
				if(cursor and cursor == "item") then
					pcall(Command.Item.Standard.Drop, held)
				end
			end
			Wykkyd.Outfitter.LeftMouseDown = false
		end, "Event.UI.Input.Mouse.Left.Up")
		
		window:EventAttach(Event.UI.Input.Mouse.Cursor.Move, function(self,h)
			Wykkyd.Outfitter.WindowPos( window:GetLeft(), window:GetTop() )
		end,"Event.UI.Input.Mouse.Cursor.Move")
        
		window:EventAttach(Event.UI.Input.Mouse.Cursor.Out, function(self, h)
			Wykkyd.Outfitter.ReleaseCursor();
		end, "Event.UI.Input.Mouse.Cursor.Out")
		
		Wykkyd.Outfitter.addWindowChild(myCount, window)
		
		local content = window:GetContent()
        
        local outfitFrame = wyk.frame.CreateFrame( fldName.."_frame", content)
		outfitFrame:SetPoint("TOPLEFT", content, "TOPLEFT", 8, 8)
		outfitFrame:SetPoint("BOTTOMRIGHT", content, "BOTTOMRIGHT", -8, -8)	
	
		outfitFrame:EventAttach(Event.UI.Input.Mouse.Left.Down, function(self, h)
			Wykkyd.Outfitter.LeftMouseDown = true;
		end, "Event.UI.Input.Mouse.Left.Down")

        outfitFrame:EventAttach(Event.UI.Input.Mouse.Left.Up, function(self, h)
			if not Wykkyd.Outfitter.LeftMouseDown then
				local cursor, held = Inspect.Cursor()
				if(cursor and cursor == "item") then
					pcall(Command.Item.Standard.Drop, held)
					Wykkyd.Outfitter.AttemptEquip(held, nil, Wykkyd.Outfitter.FindEmptySlots())
				end
			end
			Wykkyd.Outfitter.LeftMouseDown = false
		end, "Event.UI.Input.Mouse.Left.Up")
		
		content.gear = outfitFrame
        
		local btnCancel = wyk.frame.CreateTexture( fldName.."_cancel", window)
        btnCancel:SetHeight(64)
        btnCancel:SetWidth(64)
        btnCancel:SetTexture(
            wyk.vars.Images.other.cross.src,
            wyk.vars.Images.other.cross.file
        )
        btnCancel:SetLayer( 3 )
		btnCancel:SetPoint("TOPRIGHT", window, "TOPRIGHT", 6, 2)
        btnCancel:EventAttach(Event.UI.Input.Mouse.Left.Click, function(self, h)
			window:SetVisible(false); 
			WT.Utility.ClearKeyFocus(window); 
			Wykkyd.Outfitter.ContextWindowOpen[myCount] = false; 
			wykOBBHighlight(0); 
		end, "Event.UI.Input.Mouse.Left.Click")
		
        btnCancel:EventAttach(Event.UI.Input.Mouse.Left.Down, function(self, h)
			Wykkyd.Outfitter.LeftMouseDown = true;
		end, "Event.UI.Input.Mouse.Left.Down")

        btnCancel:EventAttach(Event.UI.Input.Mouse.Left.Up, function(self, h)
			if not Wykkyd.Outfitter.LeftMouseDown then
				local cursor, held = Inspect.Cursor()
				if(cursor and cursor == "item") then
					pcall(Command.Item.Standard.Drop, held)
				end
			end
			Wykkyd.Outfitter.LeftMouseDown = false
		end, "Event.UI.Input.Mouse.Left.Up")

        outfitFrame.helmet      = eqpSlot(myCount, "helmet", outfitFrame, 0, "LEFT", nil)
        outfitFrame.cape       	= eqpSlot(myCount, "cape", outfitFrame, 0, "LEFT", outfitFrame.helmet)
        outfitFrame.shoulders   = eqpSlot(myCount, "shoulders", outfitFrame, 0, "LEFT", outfitFrame.cape)
        outfitFrame.chest       = eqpSlot(myCount, "chest", outfitFrame, 0, "LEFT", outfitFrame.shoulders)
        outfitFrame.gloves      = eqpSlot(myCount, "gloves", outfitFrame, 0, "LEFT", outfitFrame.chest)
        outfitFrame.belt        = eqpSlot(myCount, "belt", outfitFrame, 0, "LEFT", outfitFrame.gloves)
        outfitFrame.legs        = eqpSlot(myCount, "legs", outfitFrame, 0, "LEFT", outfitFrame.belt)
        outfitFrame.feet        = eqpSlot(myCount, "feet", outfitFrame, 0, "LEFT", outfitFrame.legs)
        
        outfitFrame.handmain    = eqpSlot(myCount, "handmain", outfitFrame, 0, "RIGHT", nil)
        outfitFrame.handoff     = eqpSlot(myCount, "handoff", outfitFrame, 0, "RIGHT", outfitFrame.handmain)
        outfitFrame.ranged      = eqpSlot(myCount, "ranged", outfitFrame, 0, "RIGHT", outfitFrame.handoff)
        outfitFrame.neck        = eqpSlot(myCount, "neck", outfitFrame, 1, "RIGHT", outfitFrame.ranged)
        outfitFrame.trinket     = eqpSlot(myCount, "trinket", outfitFrame, 1, "RIGHT", outfitFrame.neck)
        outfitFrame.ring1       = eqpSlot(myCount, "ring1", outfitFrame, 2, "RIGHT", outfitFrame.trinket)
        outfitFrame.ring2       = eqpSlot(myCount, "ring2", outfitFrame, 2, "RIGHT", outfitFrame.ring1)
        outfitFrame.synergy     = eqpSlot(myCount, "synergy", outfitFrame, 2, "RIGHT", outfitFrame.ring2)
        outfitFrame.seal        = eqpSlot(myCount, "seal", outfitFrame, 2, "RIGHT", outfitFrame.synergy)
        outfitFrame.focus       = eqpSlot(myCount, "focus", outfitFrame, 1, "RIGHT", outfitFrame.seal)
        
        Wykkyd.Outfitter.BuildForm(myCount)
        
        window:SetVisible(true)
    else
        Wykkyd.Outfitter.ContextWindow[myCount]:SetVisible(true)
    end
    
    Wykkyd.Outfitter.ContextWindowOpen[myCount] = true
    Wykkyd.Outfitter.LoadEquipment(myCount)
    if not Wykkyd.Outfitter.ContextWindowPrepped[myCount] then
        Wykkyd.Outfitter.ContextWindowPrepped[myCount] = true
		Command.Event.Attach(Event.Item.Slot, Wykkyd.Outfitter.UpdateWindow, "Wykkyd.Outfitter.UpdateWindow")
    end
end

