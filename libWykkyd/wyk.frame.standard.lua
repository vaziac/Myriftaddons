local toc, data = ...
local id = toc.identifier

function wyk.frame.Create(kind, name, context, options, block)
	if kind == nil then return end
	if name == nil then return end
	if context == nil then return end

	local k = string.lower(kind)
	local n = wyk.UniqueName(name)
	
	if k == "button" then k = "riftbutton"
	elseif k == "checkbox" then k = "riftcheckbox"
	elseif k == "slider" then k = "riftslider"
	elseif k == "textfield" then k = "rifttextfield"
	elseif k == "window" then k = "riftwindow"
	end
	
	local obj = nil
		--print("creating a "..k.." named "..tostring(n).." with context type "..tostring(type(context)))
	
	if k == "frame" then
		obj = UI.CreateFrame("Frame", n, context)
	elseif k == "text" then
		obj = UI.CreateFrame("Text", n, context)
	elseif k == "texture" then
		obj = UI.CreateFrame("Texture", n, context)
	elseif k == "riftbutton" then
		obj = UI.CreateFrame("RiftButton", n, context)
	elseif k == "riftcheckbox" then
		obj = UI.CreateFrame("RiftCheckbox", n, context)
	elseif k == "riftslider" then
		obj = UI.CreateFrame("SimpleSlider", n, context)
	elseif k == "rifttextfield" then
		obj = UI.CreateFrame("RiftTextfield", n, context)
	elseif k == "riftwindow" then
		obj = UI.CreateFrame("RiftWindow", n, context)
	end
	--print("object created")
	
	if options ~= nil then
		local opts = options
		wyk.frame.setAllPoints(obj, opts.SetAllPoints)
		wyk.frame.setAllPoints(obj, opts.AllPoints)
		wyk.frame.setAllPoints(obj, opts.mapto)
		
		wyk.frame.setAlpha(obj, opts.SetAlpha)
		wyk.frame.setAlpha(obj, opts.Alpha)
		wyk.frame.setAlpha(obj, opts.alpha)
		
		wyk.frame.setBackgroundColor(obj, opts.SetBackgroundColor)
		wyk.frame.setBackgroundColor(obj, opts.BackgroundColor)
		wyk.frame.setBackgroundColor(obj, opts.Background)
		wyk.frame.setBackgroundColor(obj, opts.backgroundcolor)
		wyk.frame.setBackgroundColor(obj, opts.background)
		wyk.frame.setBackgroundColor(obj, opts.BGColor)
		wyk.frame.setBackgroundColor(obj, opts.bgcolor)
		wyk.frame.setBackgroundColor(obj, opts.BG)
		wyk.frame.setBackgroundColor(obj, opts.bg)
		
		wyk.frame.setHeight(obj, opts.SetHeight)
		wyk.frame.setHeight(obj, opts.Height)
		wyk.frame.setHeight(obj, opts.height)
		wyk.frame.setHeight(obj, opts.H)
		wyk.frame.setHeight(obj, opts.h)
		
		wyk.frame.setKeyFocus(obj, opts.SetKeyFocus)
		wyk.frame.setKeyFocus(obj, opts.KeyFocus)
		wyk.frame.setKeyFocus(obj, opts.keyfocus)
		wyk.frame.setKeyFocus(obj, opts.Focus)
		wyk.frame.setKeyFocus(obj, opts.focus)

		wyk.frame.setLayer(obj, opts.SetLayer)
		wyk.frame.setLayer(obj, opts.Layer)
		wyk.frame.setLayer(obj, opts.layer)
		wyk.frame.setLayer(obj, opts.L)
		wyk.frame.setLayer(obj, opts.l)
		
		wyk.frame.setMouseMasking(obj, opts.SetMouseMasking)
		wyk.frame.setMouseMasking(obj, opts.MouseMasking)
		wyk.frame.setMouseMasking(obj, opts.mousemasking)
		wyk.frame.setMouseMasking(obj, opts.Mask)
		wyk.frame.setMouseMasking(obj, opts.mask)
		
		wyk.frame.setMouseoverUnit(obj, opts.SetMouseoverUnit)
		wyk.frame.setMouseoverUnit(obj, opts.MouseoverUnit)
		wyk.frame.setMouseoverUnit(obj, opts.mouseoverunit)
		wyk.frame.setMouseoverUnit(obj, opts.Mouseover)
		wyk.frame.setMouseoverUnit(obj, opts.mouseover)
		
		wyk.frame.setParent(obj, opts.SetParent)
		wyk.frame.setParent(obj, opts.Parent)
		wyk.frame.setParent(obj, opts.parent)
		
		wyk.frame.setPoint(obj, opts.SetPoint)
		wyk.frame.setPoint(obj, opts.Point)
		wyk.frame.setPoint(obj, opts.point)
		wyk.frame.setPoint(obj, opts.attach)
		
		wyk.frame.setSecureMode(obj, opts.SetSecureMode)
		wyk.frame.setSecureMode(obj, opts.SecureMode)
		wyk.frame.setSecureMode(obj, opts.securemode)
		wyk.frame.setSecureMode(obj, opts.Secure)
		wyk.frame.setSecureMode(obj, opts.secure)
		wyk.frame.setSecureMode(obj, opts.Mode)
		wyk.frame.setSecureMode(obj, opts.mode)
		wyk.frame.setSecureMode(obj, opts.SM)
		wyk.frame.setSecureMode(obj, opts.sm)
		
		wyk.frame.setVisible(obj, opts.SetVisible)
		wyk.frame.setVisible(obj, opts.Visible)
		wyk.frame.setVisible(obj, opts.visible)
		wyk.frame.setVisible(obj, opts.V)
		wyk.frame.setVisible(obj, opts.V)
		
		wyk.frame.setWidth(obj, opts.SetWidth)
		wyk.frame.setWidth(obj, opts.Width) 
		wyk.frame.setWidth(obj, opts.width)
		wyk.frame.setWidth(obj, opts.W)
		wyk.frame.setWidth(obj, opts.w)
		
		if k == "text" then
			wyk.frame.setFont(obj, opts.SetFont)
			wyk.frame.setFont(obj, opts.Font)
			wyk.frame.setFont(obj, opts.font)
			wyk.frame.setFont(obj, opts.F)
			wyk.frame.setFont(obj, opts.f)
			
			wyk.frame.setFontColor(obj, opts.SetFontColor)
			wyk.frame.setFontColor(obj, opts.FontColor)
			wyk.frame.setFontColor(obj, opts.fontcolor)
			wyk.frame.setFontColor(obj, opts.FC)
			wyk.frame.setFontColor(obj, opts.fc)
			
			wyk.frame.setFontSize(obj, opts.SetFontSize)
			wyk.frame.setFontSize(obj, opts.FontSize)
			wyk.frame.setFontSize(obj, opts.fontsize)
			wyk.frame.setFontSize(obj, opts.FS)
			wyk.frame.setFontSize(obj, opts.fs)
			
			wyk.frame.setWordwrap(obj, opts.SetWordwrap)
			wyk.frame.setWordwrap(obj, opts.Wordwrap)
			wyk.frame.setWordwrap(obj, opts.wordwrap)
			wyk.frame.setWordwrap(obj, opts.Wrap)
			wyk.frame.setWordwrap(obj, opts.wrap)
			
		elseif k == "texture" then
			wyk.frame.setTexture(obj, opts.SetTexture)
			wyk.frame.setTexture(obj, opts.Texture)
			wyk.frame.setTexture(obj, opts.texture)
			wyk.frame.setTexture(obj, opts.SetImage)
			wyk.frame.setTexture(obj, opts.Image)
			wyk.frame.setTexture(obj, opts.image)
			
		elseif k == "riftbutton" then
			-- nothing custom
			
		elseif k == "riftcheckbox" then
			wyk.frame.setChecked(obj, opts.SetChecked)
			wyk.frame.setChecked(obj, opts.Checked)
			wyk.frame.setChecked(obj, opts.checked)
		
		elseif k == "riftslider" then
			wyk.frame.setPosition(obj, opts.SetPosition)
			wyk.frame.setPosition(obj, opts.Position)
			wyk.frame.setPosition(obj, opts.position)
		
			wyk.frame.setRange(obj, opts.SetRange)
			wyk.frame.setRange(obj, opts.Range)
			wyk.frame.setRange(obj, opts.range)
		
		elseif k == "rifttextfield" then
			wyk.frame.setCursor(obj, opts.SetCursor)
			wyk.frame.setCursor(obj, opts.Cursor)
			wyk.frame.setCursor(obj, opts.cursor)
			
			wyk.frame.setSelection(obj, opts.SetSelection)
			wyk.frame.setSelection(obj, opts.Selection)
			wyk.frame.setSelection(obj, opts.selection)
		
		elseif k == "riftwindow" then
			wyk.frame.setController(obj, opts.SetController)
			wyk.frame.setController(obj, opts.Controller)
			wyk.frame.setController(obj, opts.controller)
		
			wyk.frame.setTitle(obj, opts.SetTitle)
			wyk.frame.setTitle(obj, opts.Title)
			wyk.frame.setTitle(obj, opts.title)
		end
		
		if k == "text"
		or k == "riftbutton"
		or k == "rifttextfield" then
			wyk.frame.setText(obj, opts.SetText)
			wyk.frame.setText(obj, opts.Text)
			wyk.frame.setText(obj, opts.text)
			wyk.frame.setText(obj, opts.T)
			wyk.frame.setText(obj, opts.t)
		end
		
		if k == "riftbutton"
		or k == "riftcheckbox"
		or k == "riftslider" then
			wyk.frame.setEnabled(obj, opts.SetEnabled)
			wyk.frame.setEnabled(obj, opts.Enabled)
			wyk.frame.setEnabled(obj, opts.enabled)
		end
	end
	
	if block then wyk.frame.BlockDrop(obj) end
	
	return obj
end

function wyk.frame.CreateFrame(name, context, options, block) return wyk.frame.Create("frame", name, context, options, block) end
function wyk.frame.CreateText(name, context, options, block) return wyk.frame.Create("text", name, context, options, block) end
function wyk.frame.CreateTexture(name, context, options, block) return wyk.frame.Create("texture", name, context, options, block) end
function wyk.frame.CreateButton(name, context, options, block) return wyk.frame.Create("riftbutton", name, context, options, block) end
function wyk.frame.CreateCheckbox(name, context, options, block) return wyk.frame.Create("riftcheckbox", name, context, options, block) end
function wyk.frame.CreateSlider(name, context, options, block) return wyk.frame.Create("riftslider", name, context, options, block) end
function wyk.frame.CreateTextfield(name, context, options, block) return wyk.frame.Create("rifttextfield", name, context, options, block) end
function wyk.frame.CreateWindow(name, context, options, block) return wyk.frame.Create("riftwindow", name, context, options, block) end
function wyk.frame.CreateRiftButton(name, context, options, block) return wyk.frame.Create("riftbutton", name, context, options, block) end
function wyk.frame.CreateRiftCheckbox(name, context, options, block) return wyk.frame.Create("riftcheckbox", name, context, options, block) end
function wyk.frame.CreateRiftSlider(name, context, options, block) return wyk.frame.Create("riftslider", name, context, options, block) end
function wyk.frame.CreateRiftTextfield(name, context, options, block) return wyk.frame.Create("rifttextfield", name, context, options, block) end
function wyk.frame.CreateRiftWindow(name, context, options, block) return wyk.frame.Create("riftwindow", name, context, options, block) end


