--[[
                                G A D G E T S
      -----------------------------------------------------------------
                            wildtide@wildtide.net
                           DoomSprout: Rift Forums 
      -----------------------------------------------------------------
      Gadgets Framework   : v0.6.2
      Project Date (UTC)  : 2014-05-04T15:20:31Z
      File Modified (UTC) : 2013-09-14T09:22:53Z (Adelea)
      -----------------------------------------------------------------     
--]]

local toc, data = ...
local AddonId = toc.identifier
local TXT = Library.Translate



WT.Control.ComboBox = {}
WT.Control.ComboBox_mt = 
{ 
	__index = function(tbl,name)
		if tbl.frameIndex[name] then return tbl.frameIndex[name] end
		if WT.Control.ComboBox[name] then return WT.Control.ComboBox[name] end  
		if WT.Control[name] then return WT.Control[name] end
		return nil  
	end 
}

function WT.Control.ComboBox.Create(parent, label, default, listItems, sort, onchange)

	local control = UI.CreateFrame("Frame", WT.UniqueName("Control"), parent)
	control.frameIndex = getmetatable(control).__index
	setmetatable(control, WT.Control.ComboBox_mt) 

	local tfValue = UI.CreateFrame("RiftTextfield", WT.UniqueName("GadgetControlUnitSpecSelector_TextField"), control)
	tfValue:SetText(default or "")
	tfValue:SetBackgroundColor(0.2,0.2,0.2,0.9)

	if label then
		local txtLabel = UI.CreateFrame("Text", WT.UniqueName("GadgetControlUnitSpecSelector_Label"), control)
		txtLabel:SetText(label)
		txtLabel:SetPoint("TOPLEFT", control, "TOPLEFT")
		tfValue:SetPoint("CENTERLEFT", txtLabel, "CENTERRIGHT", 8, 0)
	else
		tfValue:SetPoint("TOPLEFT", control, "TOPLEFT", 0, 0)
	end	

	local dropDownIcon = UI.CreateFrame("Texture", WT.UniqueName("GadgetControlUnitSpecSelector_Dropdown"), tfValue)
	dropDownIcon:SetTexture(AddonId, "img/wtDropDown.png")
	dropDownIcon:SetHeight(tfValue:GetHeight())
	dropDownIcon:SetWidth(tfValue:GetHeight())
	dropDownIcon:SetPoint("TOPLEFT", tfValue, "TOPRIGHT", -10, 0)

	-- local menu = WT.Control.Menu.Create(parent, listItems, function(value) tfValue:SetText(value) end, sort)
	local menu = WT.Control.Menu.Create(parent, listItems, function(value) control:SetText(value) end, sort)
	control.listItems = listItems
	
	menu:SetPoint("TOPRIGHT", dropDownIcon, "BOTTOMCENTER")

	dropDownIcon:EventAttach(Event.UI.Input.Mouse.Left.Click, function(self, h)
		menu:Toggle()
	end, "Event.UI.Input.Mouse.Left.Click")

	control.GetText = function() return tfValue:GetText() end
	control.SetText = 
		function(ctrl, value) 
			tfValue:SetText(tostring(value))
			if onchange then onchange(tostring(value)) end 
		end
		
	control:SetHeight(20)
		
	return control
			
end
