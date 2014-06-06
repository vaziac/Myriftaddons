local toc, data = ...
local id = toc.identifier

function wyk.frame.border(obj, thickness, color, inside)
	if obj == nil then return end
	local thick = thickness or 2
	local horizontal = obj:GetWidth()
	local vertical = obj:GetHeight()
	if inside then
		horizontal = horizontal - (thick * 2)
		vertical = vertical - (thick * 2)
	end
	local tb = wyk.frame.CreateFrame("tb", obj, {
		w = horizontal,
		h = thick,
		bg = color,
		layer = 1,
	}, true)
	local bb = wyk.frame.CreateFrame("bb", obj, {
		w = horizontal,
		h = thick,
		bg = color,
		layer = 1,
	}, true)
	local lb = wyk.frame.CreateFrame("lb", obj, {
		h = vertical,
		w = thick,
		bg = color,
		layer = 1,
	}, true)
	local rb = wyk.frame.CreateFrame("rb", obj, {
		h = vertical,
		w = thick,
		bg = color,
		layer = 1,
	}, true)
	local tlc = wyk.frame.CreateFrame("tlc", obj, {
		h = thick,
		w = thick,
		bg = color,
		layer = 1,
	}, true)
	local trc = wyk.frame.CreateFrame("trc", obj, {
		h = thick,
		w = thick,
		bg = color,
		layer = 1,
	}, true)
	local blc = wyk.frame.CreateFrame("blc", obj, {
		h = thick,
		w = thick,
		bg = color,
		layer = 1,
	}, true)
	local brc = wyk.frame.CreateFrame("brc", obj, {
		h = thick,
		w = thick,
		bg = color,
		layer = 1,
	}, true)
	if inside then
		tb:SetPoint("TOPCENTER", obj, "TOPCENTER", 0, 0)
		trc:SetPoint("TOPRIGHT", obj, "TOPRIGHT", 0, 0)
		rb:SetPoint("CENTERRIGHT", obj, "CENTERRIGHT", 0, 0)
		brc:SetPoint("BOTTOMRIGHT", obj, "BOTTOMRIGHT", 0, 0)
		bb:SetPoint("BOTTOMCENTER", obj, "BOTTOMCENTER", 0, 0)
		blc:SetPoint("BOTTOMLEFT", obj, "BOTTOMLEFT", 0, 0)
		lb:SetPoint("CENTERLEFT", obj, "CENTERLEFT", 0, 0)
		tlc:SetPoint("TOPLEFT", obj, "TOPLEFT", 0, 0)
	else
		tb:SetPoint("BOTTOMCENTER", obj, "TOPCENTER", 0, 0)
		trc:SetPoint("BOTTOMLEFT", obj, "TOPRIGHT", 0, 0)
		rb:SetPoint("CENTERLEFT", obj, "CENTERRIGHT", 0, 0)
		brc:SetPoint("TOPLEFT", obj, "BOTTOMRIGHT", 0, 0)
		bb:SetPoint("TOPCENTER", obj, "BOTTOMCENTER", 0, 0)
		blc:SetPoint("TOPRIGHT", obj, "BOTTOMLEFT", 0, 0)
		lb:SetPoint("CENTERRIGHT", obj, "CENTERLEFT", 0, 0)
		tlc:SetPoint("BOTTOMRIGHT", obj, "TOPLEFT", 0, 0)
	end
	obj.tb = tb
	obj.trc = trc
	obj.rb = rb
	obj.brc = brc
	obj.bb = bb
	obj.blc = blc
	obj.lb = lb
	obj.tlc = tlc
end