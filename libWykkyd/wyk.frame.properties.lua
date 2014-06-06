local toc, data = ...
local id = toc.identifier

local function validPoint(p)
	local retVal = false
	if p ~= nil then
		local t = string.upper(p)
		if t == "TOPLEFT" then retVal = true end
		if t == "TOP" then retVal = true end
		if t == "TOPCENTER" then retVal = true end
		if t == "TOPRIGHT" then retVal = true end
		if t == "RIGHT" then retVal = true end
		if t == "CENTERRIGHT" then retVal = true end
		if t == "BOTTOMRIGHT" then retVal = true end
		if t == "BOTTOM" then retVal = true end
		if t == "BOTTOMCENTER" then retVal = true end
		if t == "BOTTOMLEFT" then retVal = true end
		if t == "LEFT" then retVal = true end
		if t == "CENTERLEFT" then retVal = true end
		if t == "CENTER" then retVal = true end
		if t == "CENTERCENTER" then retVal = true end
		if t == "XCENTER" then retVal = true end
		if t == "CENTERX" then retVal = true end
		if t == "YCENTER" then retVal = true end
		if t == "CENTERY" then retVal = true end
	end
	return retVal
end

local function validSecureMode(p)
	local retVal = false
	if p ~= nil then
		local t = string.lower(p)
		if t == "restricted" then retVal = true end
		if t == "normal" then retVal = true end
	end
	return retVal
end

local function GetColors(o)
	local oR = 0
	local oG = 0
	local oB = 0
	local oA = 0
	if o.Red ~= nil then oR = o.Red end
	if o.Green ~= nil then oG = o.Green end
	if o.Blue ~= nil then oB = o.Blue end
	if o.Alpha ~= nil then oA = o.Alpha end
	if o.red ~= nil then oR = o.red end
	if o.green ~= nil then oG = o.green end
	if o.blue ~= nil then oB = o.blue end
	if o.alpha ~= nil then oA = o.alpha end
	if o.R ~= nil then oR = o.R end
	if o.G ~= nil then oG = o.G end
	if o.B ~= nil then oB = o.B end
	if o.A ~= nil then oA = o.A end
	if o.r ~= nil then oR = o.r end
	if o.g ~= nil then oG = o.g end
	if o.b ~= nil then oB = o.b end
	if o.a ~= nil then oA = o.a end
	return { r=oR, g=oG, b=oB, a=oA }
end

local function inRange(d)
	if wyk.func.isNumeric(d) then
		local n = tonumber(d)
		if n >= -2147483648 then
			if n <= 2147483647 then
				return true
			end
		end
	end
	return false
end

function wyk.frame.setAllPoints(obj, o) if obj == nil or o == nil then return end; if o.target ~= nil then obj:SetAllPoints(o.target) end end

function wyk.frame.setAlpha(obj, o) if obj == nil or o == nil then return end; if wyk.func.isNumeric(o) then obj:SetAlpha(o) end end

function wyk.frame.setBackgroundColor(obj, i) if obj == nil or i == nil then return end; local o = GetColors(i); obj:SetBackgroundColor(o.r, o.g, o.b, o.a); end

function wyk.frame.setChecked(obj, o) if obj == nil or o == nil then return end; if wyk.func.isBoolean(o) then obj:SetChecked(o) end end

function wyk.frame.setController(obj, o) if obj == nil or o == nil then return end; if o ~= nil then obj:SetController(o) end end

function wyk.frame.setCursor(obj, o) if obj == nil or o == nil then return end; if o ~= nil then obj:SetCursor(o) end end

function wyk.frame.setEnabled(obj, o) if obj == nil or o == nil then return end; if wyk.func.isBoolean(o) then obj:SetEnabled(o) end end

function wyk.frame.setFont(obj, o) if obj == nil or o == nil then return end;
	local s = nil
	local f = nil
	if o.source ~= nil then s = o.source end
	if o.s ~= nil then s = o.s end
	if o.file ~= nil then f = o.file end
	if o.f ~= nil then f = o.f end
	if f ~= nil then
		if s == nil then
			obj:SetFont("Rift", f)
		else
			obj:SetFont(s, f)
		end
	end
end

function wyk.frame.setFontColor(obj, i) if obj == nil or i == nil then return end; local o = GetColors(i); obj:SetFontColor(o.r, o.g, o.b, o.a); end

function wyk.frame.setFontSize(obj, o) if obj == nil or o == nil then return end; if wyk.func.isNumeric(o) then obj:SetFontSize(o) end end

function wyk.frame.setHeight(obj, o) if obj == nil or o == nil then return end; if wyk.func.isNumeric(o) then obj:SetHeight(o) end end

function wyk.frame.setKeyFocus(obj, o) if obj == nil or o == nil then return end; if wyk.func.isBoolean(o) then obj:SetKeyFocus(o) end end

function wyk.frame.setLayer(obj, o) if obj == nil or o == nil then return end; if wyk.func.isNumeric(o) then obj:SetLayer(o) end end

function wyk.frame.setMouseMasking(obj, o) if obj == nil or o == nil then return end; if o ~= nil then obj:SetMouseMasking(o) end end

function wyk.frame.setMouseoverUnit(obj, o) if obj == nil or o == nil then return end; if o ~= nil then obj:SetMouseoverUnit(o) end end

function wyk.frame.setParent(obj, o) if obj == nil or o == nil then return end; if o ~= nil then obj:SetParent(o) end end

function wyk.frame.setPoint(obj, o) if obj == nil or o == nil then return end;
	if validPoint(o.point) and o.target ~= nil and validPoint(o.targetpoint) then
		if x ~= nil then
			if y ~= nil then
				obj:SetPoint(o.point, o.target, o.targetpoint, x, y)
			else
				obj:SetPoint(o.point, o.target, o.targetpoint, x)
			end
		else
			if y ~= nil then
				obj:SetPoint(o.point, o.target, o.targetpoint, 0, y)
			else
				obj:SetPoint(o.point, o.target, o.targetpoint)
			end
		end
	end
end

function wyk.frame.setPosition(obj, o) if obj == nil or o == nil then return end; if wyk.func.isNumeric(o) then obj:SetPosition(o) end end

function wyk.frame.setRange(obj, o) if obj == nil or o == nil then return end; 
	local L = nil
	local H = nil
	
	if o.minimum ~= nil then L = o.minimum end
	if o.min ~= nil then L = o.min end
	if o.low ~= nil then L = o.low end
	if o.l ~= nil then L = o.l end
	if o.L ~= nil then L = o.L end
	if o.maximum ~= nil then H = o.maximum end
	if o.max ~= nil then H = o.max end
	if o.high ~= nil then H = o.high end
	if o.h ~= nil then H = o.h end
	if o.H ~= nil then H = o.H end
	
	if L ~= nil and H == nil then H = L + 1 end
	if H ~= nil and L == nil then L = H - 1 end
	
	if inRange(H) and inRange(L) then
		obj:SetRange(L, H)
	end
end

function wyk.frame.setSecureMode(obj, o) if obj == nil or o == nil then return end; if validSecureMode(o) then obj:SetSecureMode(o) end end

function wyk.frame.setSelection(obj, o) if obj == nil or o == nil then return end; if o ~= nil then obj:SetSelection(o) end end

function wyk.frame.setText(obj, o) if obj == nil or o == nil then return end; if o ~= nil then obj:SetText(tostring(o)) else obj:SetText("") end end

function wyk.frame.setTexture(obj, o) if obj == nil or o == nil then return end;
	local s = nil
	local f = nil
	if o.source ~= nil then s = o.source end
	if o.src ~= nil then s = o.src end
	if o.s ~= nil then s = o.s end
	if o.resource ~= nil then f = o.resource end
	if o.r ~= nil then f = o.r end
	if o.file ~= nil then f = o.file end
	if o.f ~= nil then f = o.f end
	if f ~= nil then
		if s == nil then
			obj:SetTexture("", f)
		else
			obj:SetTexture(s, f)
		end
	end
end

function wyk.frame.setTitle(obj, o) if obj == nil or o == nil then return end; if o ~= nil then obj:SetTitle(tostring(o)) else obj:SetTitle("") end end

function wyk.frame.setVisible(obj, o) if obj == nil or o == nil then return end; if wyk.func.isBoolean(o) then obj:SetVisible(o) end end

function wyk.frame.setWidth(obj, o) if obj == nil or o == nil then return end; if wyk.func.isNumeric(o) then obj:SetWidth(o) end end

function wyk.frame.setWordwrap(obj, o) if obj == nil or o == nil then return end; if wyk.func.isBoolean(o) then obj:SetWordwrap(o) end end
