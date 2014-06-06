local toc, data = ...

function Wykkyd.Outfitter.OpenMassReplacementWindow(contextCount)
	local fldName = "massReplacementWindow"
	local myCount = contextCount
	local inContext = Wykkyd.Outfitter.Context[myCount]
	if inContext == nil then
		inContext = WT.Context
	end
	Wykkyd.Outfitter.MassReplacementWindow[myCount] = UI.CreateFrame("SimpleWindow", fldName, inContext)
	local window = Wykkyd.Outfitter.MassReplacementWindow[myCount]
	window.myCount = myCount
	window:SetVisible(false)
	if Wykkyd.Outfitter.ContextConfig[myCount] == nil then
		Wykkyd.Outfitter.ContextConfig[myCount] = {};
	end
	if Wykkyd.Outfitter.ContextConfig[myCount].MassReplacementWindow ~= nil then
		if Wykkyd.Outfitter.ContextConfig[myCount].MassReplacementWindow.xpos ~= nil and Wykkyd.Outfitter.ContextConfig[myCount].MassReplacementWindow.ypos ~= nil then
			window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", Wykkyd.Outfitter.ContextConfig[myCount].MassReplacementWindow.xpos, Wykkyd.Outfitter.ContextConfig[myCount].MassReplacementWindow.ypos)
		else setNewPos = true
		end
	else
		setNewPos = true
	end
	if setNewPos then
		window:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
		Wykkyd.Outfitter.MassReplacementWindowPos(window:GetLeft(),window:GetTop())
	end
	window:SetWidth(265)

	local heightMargin = -20
	for k,v in pairs(Wykkyd.Outfitter.ContextConfig[myCount].EquipSetList) do
		heightMargin=heightMargin+20
	end
	window:SetHeight(230+ heightMargin)
	window:SetLayer(11000)
	window:SetTitle("mass replacement tool")

	window:EventAttach(Event.UI.Input.Mouse.Left.Down, function(self, h)
		Wykkyd.Outfitter.LeftMouseDown = true;
	end, "Event.UI.Input.Mouse.Left.Down")

	window:EventAttach(Event.UI.Input.Mouse.Cursor.Move, function(self,h)
		Wykkyd.Outfitter.MassReplacementWindowPos( window:GetLeft(), window:GetTop() )
	end,"Event.UI.Input.Mouse.Cursor.Move")

	window:EventAttach(Event.UI.Input.Mouse.Cursor.Out, function(self, h)
		Wykkyd.Outfitter.ReleaseCursor();
	end, "Event.UI.Input.Mouse.Cursor.Out")

	local content = window:GetContent()

	local replacementFrame = wyk.frame.CreateFrame( fldName.."_frame", content)
	replacementFrame:SetPoint("TOPLEFT", content, "TOPLEFT", 8, 8)
	replacementFrame:SetPoint("BOTTOMRIGHT", content, "BOTTOMRIGHT", -8, -8)

	replacementFrame:EventAttach(Event.UI.Input.Mouse.Left.Down, function(self, h)
		Wykkyd.Outfitter.LeftMouseDown = true;
	end, "Event.UI.Input.Mouse.Left.Down")

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
	Wykkyd.Outfitter.MassReplacementWindow.BuildForm(myCount)
	window:SetVisible(true)



end


function Wykkyd.Outfitter.MassReplacementWindowPos( newX, newY)
	for ii = 1, wykkydContextCount, 1 do
		if Wykkyd.Outfitter.ContextConfig[ii] == nil then Wykkyd.Outfitter.ContextConfig[ii] = {}; end
		if Wykkyd.Outfitter.ContextConfig[ii].MassReplacementWindow == nil then Wykkyd.Outfitter.ContextConfig[ii].MassReplacementWindow = {}; end
		Wykkyd.Outfitter.ContextConfig[ii].MassReplacementWindow.xpos = newX
		Wykkyd.Outfitter.ContextConfig[ii].MassReplacementWindow.ypos = newY
	end
end
