local toc, data = ...
local id = toc.identifier

function wyk.frame.SlideFrame(name, context, width, range, position, displayText, block)
	local uName = wyk.UniqueName(name)

	local frame = wyk.frame.CreateFrame(uName, context)
	if block then wyk.frame.BlockDrop(frame) end

	frame.label = {}
	if displayText ~= nil then
		frame.label = wyk.frame.CreateText(uName.."_label", frame, {
			point = {point="TOPCENTER", target=frame, targetpoint="TOPCENTER", x=0, y=0},
			text = displayText,
		})
		if block then wyk.frame.BlockDrop(frame.label) end
	end

	frame.slider = wyk.frame.CreateRiftSlider(uName.."_slider", frame, {
		SetRange = range,
		SetPosition = position,
		w = width,
	})
	if block then wyk.frame.BlockDrop(frame.slider) end
	if displayText ~= nil then
		frame.slider:SetPoint("TOPCENTER", frame.label, "BOTTOMCENTER", 0, 0)
	else
		frame.slider:SetPoint("TOPCENTER", frame, "TOPCENTER", 0, 0)
	end

	return frame
end

function changePos(slider, iMod,optFunc)
	--TODO: test if local min, max = slider:GetRange() works
	local range = {slider:GetRange()}
	local min = range[1]
	local max = range[2]
	pos = slider:GetPosition() + iMod
	if pos < min then 
		pos = min
	elseif pos > max then 
		pos = max
	end
		slider:SetPosition(pos) 
		if optFunc ~= nil then
		optFunc(slider,pos)
	end
end

function wyk.frame.AttachScrollControls(frame, optionalFunction)
	frame.slider:EventAttach(Event.UI.Input.Mouse.Wheel.Forward, function(self, h) changePos(frame.slider, 1,optionalFunction) end, "Event.UI.Input.Mouse.Wheel.Forward")
	frame.slider:EventAttach(Event.UI.Input.Mouse.Wheel.Back, function(self, h) changePos(frame.slider, -1, optionalFunction) end, "Event.UI.Input.Mouse.Wheel.Back")
end
