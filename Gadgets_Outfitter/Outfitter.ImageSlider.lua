function Wykkyd.Outfitter.ImageSlider(myCount, target, points, layer, value, valReturn)
    if Wykkyd.Outfitter.ContextImageSlider[myCount] ~= nil then
        Wykkyd.Outfitter.ContextImageSlider[myCount]:SetVisible(true)
        return
    end
    
    local uName = "wykkydOutfitter_slideFrame"
	local t = target
	local ll = layer + 1
    Wykkyd.Outfitter.ContextImageSlider[myCount] = wyk.frame.ImageSlider(uName, t, { 
		layer = ll,
		bg = {r=.25, g=.25, b=.25, a=1}, 
		w = 340,
		h = 200,
	})
	local obj = Wykkyd.Outfitter.ContextImageSlider[myCount]
	wyk.frame.border(obj, 1, {r=0, g=0, b=0, a=1}, false)
            

    local btnSet = wyk.frame.CreateButton(uName.."_setBtn", obj, nil, true)
    btnSet:SetPoint("BOTTOMLEFT", obj, "BOTTOMCENTER", 6, -4 )
    btnSet:SetText("Set")

	btnSet:EventAttach(Event.UI.Input.Mouse.Left.Click, function(self, h)
        valReturn( obj.imageSlider.slider:GetPosition() )
        Wykkyd.Outfitter.ContextImageSlider[myCount]:SetVisible(false)
	end, "Event.UI.Input.Mouse.Left.Click")
    
    local btnCancel = wyk.frame.CreateButton(uName.."_endBtn", obj, nil, true)
    btnCancel:SetPoint("BOTTOMRIGHT", obj, "BOTTOMCENTER", -6, -4 )
    btnCancel:SetText("Cancel")

	btnCancel:EventAttach(Event.UI.Input.Mouse.Left.Click, function(self, h)
        Wykkyd.Outfitter.ContextImageSlider[myCount]:SetVisible(false)
	end, "Event.UI.Input.Mouse.Left.Click")
        
    Wykkyd.Outfitter.ContextImageSlider[myCount]:SetVisible(true)
end