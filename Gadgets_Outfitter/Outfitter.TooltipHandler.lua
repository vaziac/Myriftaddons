local toc, data = ...
local tooltipContext = UI.CreateContext("OutfitterTooltip")
tooltipContext:SetStrata("topmost")
local tooltip = UI.CreateFrame("Text","tooltipOutfitter",tooltipContext)
tooltip:SetBackgroundColor(0.0,0.1,0.1,0.7)
tooltip:SetLayer(999)
tooltip:SetHeight(30)
tooltip:SetWidth(250)
tooltip:SetFontSize(12)
local itemTooltipWidth=0
local text = ""
local lineCounter=0
local counter=0

local function checkItemID(id)
	local equipsets = ""
	if id then
		for k,context in pairs(Wykkyd.Outfitter.ContextConfig) do
			if context.checkboxTooltipEnabler == true and type(context.EquipSetGear) == "table" then
				for k,equipSet in pairs(context.EquipSetGear) do
					for k,v in pairs(equipSet.gear) do
						if v.id == id then
							equipsets = equipsets .. equipSet.name .. ", "
							break
						end
					end
				end
			end
		end
	end
	return string.sub(equipsets,0,(string.len(equipsets)-2))
end

local function concatenateText(curText,text)
	if (string.len(curText) + string.len(text)) <= 30 then
		return	0,curText .. " " .. text
	else
		return 1,curText .. "\n" .. text
	end
end

local function prettifyTooltipText(text)
	if text == nil then return 0, "" end
	local l = 0
	local tempText = ""
	local returnText = ""
	local textSplit = wyk.func.Split(text,"%S+")
	local lineCounter = 1
	for _,v in pairs(textSplit) do
		l, tempText = concatenateText(tempText,v)
		if l == 1 or table.getn(textSplit) == 1 or table.getn(textSplit) == _ then
			returnText = returnText .. tempText
			tempText = ""
			lineCounter = lineCounter + 1
		end
	end
	return lineCounter, returnText
end


function Wykkyd.Outfitter.TooltipHandler(self, h)
	if UI.Native.Tooltip:GetLoaded() then
		local tooltipType, id = Inspect.Tooltip()
			local nativeTooltipAnchor = "BOTTOMLEFT"
			local tooltipAnchor = "TOPLEFT"
		if tooltipType then
			itemTooltipWidth = UI.Native.Tooltip:GetWidth()
			lineCounter,text = prettifyTooltipText(checkItemID(id))
			tooltip:SetHeight(lineCounter*20)

			tooltip:ClearAll()
			tooltip:SetPoint(nativeTooltipAnchor,UI.Native.Tooltip,tooltipAnchor,2,10)

		else
			tooltip:ClearAll()
			if UI.Native.Tooltip:GetTop() - tooltip:GetHeight() < 10 then
				nativeTooltipAnchor = "TOPLEFT"
				tooltipAnchor = "BOTTOMLEFT"
			end
			if UI.Native.Tooltip:GetLeft() < (Inspect.Mouse().x-600) then
				tooltip:SetPoint(nativeTooltipAnchor,UI.Native.Tooltip,tooltipAnchor,520,10)
			elseif UI.Native.Tooltip:GetLeft() > (Inspect.Mouse().x+400) then
				tooltip:SetPoint(nativeTooltipAnchor,UI.Native.Tooltip,tooltipAnchor,-510,10)
			elseif UI.Native.Tooltip:GetLeft() < Inspect.Mouse().x then
				tooltip:SetPoint(nativeTooltipAnchor,UI.Native.Tooltip,tooltipAnchor,250,10)
			else
				tooltip:SetPoint(nativeTooltipAnchor,UI.Native.Tooltip,tooltipAnchor,-250,10)
			end
		end
		if UI.Native.Tooltip:GetWidth() < itemTooltipWidth then
			text = ""
		end
		if text ~= ""  then
			tooltip:SetVisible(true)
			tooltip:SetText("Item saved in: \n" .. text )
		end
	else
		tooltip:SetVisible(false)
	end
end

