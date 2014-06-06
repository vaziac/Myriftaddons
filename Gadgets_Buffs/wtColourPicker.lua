--[[
                                G A D G E T S
      -----------------------------------------------------------------
                            wildtide@wildtide.net
                           DoomSprout: Rift Forums 
      -----------------------------------------------------------------
      Gadgets Framework   : v0.1.3
      Project Date (UTC)  : 2012-08-07T01:23:40Z
      File Modified (UTC) : 2012-08-07T01:23:40Z (Wildtide)
      -----------------------------------------------------------------     
--]]

local toc, data = ...
local AddonId = toc.identifier
local TXT = Library.Translate

local selector = nil
local blocker = nil

local ctxColourPicker = UI.CreateContext("ctxColourPicker")
ctxColourPicker:SetStrata("menu")


local function SetColor(r,g,b,a)
	selector.current:SetBackgroundColor(r,g,b,a)
	selector.swatch:SetBackgroundColor(r,g,b,a)
	if selector.swatch.Control.OnColorChanged then
		selector.swatch.Control.OnColorChanged(r,g,b,a)
	end			 
end


local function UpdateMarkers()
 
	local r,g,b,a = selector.swatch:GetBackgroundColor()
	
	local ctrlWidth = selector.olayRed:GetWidth() - 1 
	
	selector.olayRed.marker:SetPoint("CENTER", selector.olayRed, "TOPLEFT", 1 + (r * ctrlWidth), 6)			
	selector.olayGreen.marker:SetPoint("CENTER", selector.olayGreen, "TOPLEFT", 1 + (g * ctrlWidth), 6)
	selector.olayBlue.marker:SetPoint("CENTER", selector.olayBlue, "TOPLEFT", 1 + (b * ctrlWidth), 6)
	selector.olayAlpha.marker:SetPoint("CENTER", selector.olayAlpha, "TOPLEFT", 1 + (a * ctrlWidth), 6)
	
	selector.olayRed.value = r
	selector.olayGreen.value = g
	selector.olayBlue.value = b
	selector.olayAlpha.value = a
	
	selector.txtHex:SetText(string.format("%02X%02X%02X%02X", selector.olayAlpha.value * 255, selector.olayRed.value * 255, selector.olayGreen.value * 255, selector.olayBlue.value * 255))
	selector.hexEditor.text:SetText(string.format("%02X%02X%02X%02X", selector.olayAlpha.value * 255, selector.olayRed.value * 255, selector.olayGreen.value * 255, selector.olayBlue.value * 255))
	
	SetColor(r,g,b,a)
	
end

local function CreateSelector()

	blocker = UI.CreateFrame("Frame", "frmColourPickerBlocker", ctxColourPicker)
	blocker:SetVisible(false)
	blocker:SetAllPoints(UIParent)
	blocker.Event.LeftDown = function() blocker:SetVisible(false) end

	local border = UI.CreateFrame("Frame", "frmBorder", blocker)
	border:SetBackgroundColor(1,1,1,1)

	selector = UI.CreateFrame("Texture", "frmColourPickerSelector", border)
	selector:SetTexture(AddonId, "img/wtColourPicker.png")
	
	border:SetPoint("TOPLEFT", selector, "TOPLEFT", -1, -1)
	border:SetPoint("BOTTOMRIGHT", selector, "BOTTOMRIGHT", 1, 1)
	
	selector.Event.LeftDown = function() end
	
	local olayRed = UI.CreateFrame("Frame", "olayRed", selector)
	olayRed:SetPoint("TOPLEFT", selector, "TOPLEFT", 23, 12) 
	olayRed:SetHeight(10) 
	olayRed:SetWidth(132)

	local olayGreen = UI.CreateFrame("Frame", "olayGreen", selector)
	olayGreen:SetPoint("TOPLEFT", selector, "TOPLEFT", 23, 25) 
	olayGreen:SetHeight(10) 
	olayGreen:SetWidth(132)

	local olayBlue = UI.CreateFrame("Frame", "olayBlue", selector)
	olayBlue:SetPoint("TOPLEFT", selector, "TOPLEFT", 23, 38) 
	olayBlue:SetHeight(10) 
	olayBlue:SetWidth(132)

	local olayAlpha = UI.CreateFrame("Frame", "olayAlpha", selector)
	olayAlpha:SetPoint("TOPLEFT", selector, "TOPLEFT", 23, 51) 
	olayAlpha:SetHeight(10) 
	olayAlpha:SetWidth(132)

	local current = UI.CreateFrame("Frame", "stored", selector)
	current:SetBackgroundColor(1,0,0,0.5)
	current:SetPoint("TOPLEFT", selector, "TOPLEFT", 5, 72)
	current:SetWidth(32)
	current:SetHeight(16)

	local held = UI.CreateFrame("Frame", "held", selector)
	held:SetBackgroundColor(1,0,0,0.5)
	held:SetPoint("TOPLEFT", selector, "TOPLEFT", 149, 72)
	held:SetWidth(16)
	held:SetHeight(16)
	held.Event.LeftDown = 
		function() 
			SetColor(held:GetBackgroundColor()) UpdateMarkers()
		end

	local cmdHold = UI.CreateFrame("Frame", "cmdHold", selector)
	cmdHold:SetPoint("TOPRIGHT", held, "TOPLEFT", -5, 0)
	cmdHold:SetWidth(40)
	cmdHold:SetHeight(16)
	cmdHold.Event.LeftDown = function() held:SetBackgroundColor(selector.swatch:GetBackgroundColor()) end

	local txtHex = UI.CreateFrame("Text", "txtHex", selector)
	txtHex:SetPoint("CENTERLEFT", current, "CENTERRIGHT", 4, 0)
	txtHex:SetText("00000000")
	txtHex:SetFontSize(10)
	
	local hexEditor = UI.CreateFrame("Frame", "hexEditor", selector)
	hexEditor:SetPoint("TOPLEFT", selector, "TOPLEFT")
	hexEditor:SetPoint("BOTTOMRIGHT", selector, "BOTTOMRIGHT", 0, -26)
	hexEditor:SetBackgroundColor(0,0,0,0.9)
	hexEditor:SetLayer(100)
	local lblHexEditor = UI.CreateFrame("Text", "lblhexEditor", hexEditor)
	lblHexEditor:SetText("HEX COLOR")
	lblHexEditor:SetFontSize(11)
	lblHexEditor:SetPoint("TOPCENTER", hexEditor, "TOPCENTER", 0, 6)	
	local txtHexEditor = UI.CreateFrame("RiftTextfield", "txtHexEditor", hexEditor)
	txtHexEditor:SetPoint("TOPCENTER", lblHexEditor, "BOTTOMCENTER")
	txtHexEditor:SetWidth(70)
	txtHexEditor:SetLayer(10)
	txtHexEditor:SetBackgroundColor(0.3,0.3,0.3,1.0)
	txtHexEditor:SetText("00000000")
	local borderHex = UI.CreateFrame("Frame", "borderHex", hexEditor)
	borderHex:SetBackgroundColor(1,1,1,1)
	borderHex:SetPoint("TOPLEFT", txtHexEditor, "TOPLEFT", -1, -1)
	borderHex:SetPoint("BOTTOMRIGHT", txtHexEditor, "BOTTOMRIGHT", 1, 1)
	
	hexEditor.text = txtHexEditor 
	
	lblValid = UI.CreateFrame("Text", "lblValid", hexEditor)
	lblValid:SetPoint("TOPCENTER", borderHex, "BOTTOMCENTER", 0, 0)
	lblValid:SetFontSize(10)
	
	hexEditor:SetVisible(false)
	
	txtHexEditor.Event.KeyDown = 
		function(ctrl, key)
			if key == "\r" then
				txtHexEditor:SetKeyFocus(false)
				hexEditor:SetVisible(false)
			end
		end
	
	txtHexEditor.Event.TextfieldChange = 
		function()
			local txt = txtHexEditor:GetText():upper()
			if txt:len() > 8 then
				txt = txt:sub(1, 8)				
			end
			txtHexEditor:SetText(txt)
			local pattern = "[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]"
			if txt:match(pattern) then
				lblValid:SetText("OK")
				lblValid:SetFontColor(0,1,0,1)
				txtHex:SetText(txt)
				local a = tonumber(txt:sub(1,2), 16) / 255
				local r = tonumber(txt:sub(3,4), 16) / 255
				local g = tonumber(txt:sub(5,6), 16) / 255
				local b = tonumber(txt:sub(7,8), 16) / 255
				SetColor(r,g,b,a)
				UpdateMarkers()
			else
				lblValid:SetText("INVALID")
				lblValid:SetFontColor(1,0,0,1)
			end 
		end
	
	local ctrlWidth = 131
	
	olayRed.marker = UI.CreateFrame("Texture", "frmColourPickerSelector", selector)
	olayRed.marker:SetTexture(AddonId, "img/wtColourMarker.png")
	olayRed.marker:SetPoint("CENTER", olayRed, "TOPLEFT", 1, 6)			

	olayGreen.marker= UI.CreateFrame("Texture", "frmColourPickerSelector", selector)
	olayGreen.marker:SetTexture(AddonId, "img/wtColourMarker.png")
	olayGreen.marker:SetPoint("CENTER", olayGreen, "TOPLEFT", 1, 6)

	olayBlue.marker= UI.CreateFrame("Texture", "frmColourPickerSelector", selector)
	olayBlue.marker:SetTexture(AddonId, "img/wtColourMarker.png")
	olayBlue.marker:SetPoint("CENTER", olayBlue, "TOPLEFT", 1, 6)

	olayAlpha.marker= UI.CreateFrame("Texture", "frmColourPickerSelector", selector)
	olayAlpha.marker:SetTexture(AddonId, "img/wtColourMarker.png")
	olayAlpha.marker:SetPoint("CENTER", olayAlpha, "TOPLEFT", 1, 6)
		
	selector.olayRed = olayRed
	selector.olayGreen = olayGreen
	selector.olayBlue = olayBlue
	selector.olayAlpha = olayAlpha		
	selector.current = current
	selector.txtHex = txtHex
	selector.hexEditor = hexEditor
		
	local dragging = nil
	
	local function UpdateMarker()
		if not dragging then return end
		local ctrlX = dragging:GetLeft()
		local ctrlWidth = dragging:GetWidth() - 1
		local mouseX = Inspect.Mouse().x
		local offset = mouseX - ctrlX;
		if offset < 0 then offset = 0 end
		if offset > ctrlWidth then offset = ctrlWidth end
		dragging.marker:SetPoint("CENTER", dragging, "TOPLEFT", 1 + offset, 6)
		
		local percent = offset / ctrlWidth
		dragging.value = percent
		
		SetColor(olayRed.value, olayGreen.value, olayBlue.value, olayAlpha.value)
		txtHex:SetText(string.format("%02X%02X%02X%02X", olayAlpha.value * 255, olayRed.value * 255, olayGreen.value * 255, olayBlue.value * 255))
		hexEditor.text:SetText(string.format("%02X%02X%02X%02X", selector.olayAlpha.value * 255, selector.olayRed.value * 255, selector.olayGreen.value * 255, selector.olayBlue.value * 255))	
	end
	
	Command.Event.Attach(Event.Mouse.Move, UpdateMarker, "wtColourPicker_MouseMove") 
	
	olayRed.Event.LeftDown = function() dragging = olayRed; UpdateMarker() end
	olayRed.Event.LeftUp = function() dragging = nil end 
	olayRed.Event.LeftUpoutside = function() dragging = nil end 

	olayGreen.Event.LeftDown = function() dragging = olayGreen; UpdateMarker() end
	olayGreen.Event.LeftUp = function() dragging = nil end 
	olayGreen.Event.LeftUpoutside = function() dragging = nil end 

	olayBlue.Event.LeftDown = function() dragging = olayBlue; UpdateMarker() end
	olayBlue.Event.LeftUp = function() dragging = nil end 
	olayBlue.Event.LeftUpoutside = function() dragging = nil end 

	olayAlpha.Event.LeftDown = function() dragging = olayAlpha; UpdateMarker() end
	olayAlpha.Event.LeftUp = function() dragging = nil end 
	olayAlpha.Event.LeftUpoutside = function() dragging = nil end 

	txtHex.Event.LeftDown = 
		function() 				
			local show = not hexEditor:GetVisible()
			hexEditor.text:SetKeyFocus(show)
			hexEditor:SetVisible(show) 
		end
			
end
		

function WT.CreateColourPicker(parent, r, g, b, a)

	local control = UI.CreateFrame("Texture", "frmColourPicker", parent)	
	control:SetTexture(AddonId, "img/wtColourBox.png")
	
	local colourSwatch = UI.CreateFrame("Frame", "frmColourSwatch", control)
	colourSwatch:SetPoint("TOPLEFT", control, "TOPLEFT", 1, 1)
	colourSwatch:SetPoint("BOTTOMRIGHT", control, "BOTTOMRIGHT", -1, -1)
	colourSwatch:SetBackgroundColor(r,g,b,a)
	colourSwatch.Control = control

	control.Event.LeftDown =
	 
		function()
		 
			if not selector then
				CreateSelector()	
			end		
								
			selector:SetPoint("TOPLEFT", control, "CENTER", 0, 0)
			selector.swatch = colourSwatch
			selector.current:SetBackgroundColor(selector.swatch:GetBackgroundColor())
			
			UpdateMarkers()
			blocker:SetVisible(true)
			 
		end

	control.SetColor = 
		function(ctrl, r, g, b, a)
			colourSwatch:SetBackgroundColor(r,g,b,a)
		end 

	control.GetColor = 
		function(ctrl)
			return colourSwatch:GetBackgroundColor()
		end 

	return control
	
end