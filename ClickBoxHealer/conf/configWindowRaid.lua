--[[
file: optionWindow.lua
by: Solsis00
for: ClickBoxHealer

This file houses the configuration window for CBH.

**COMPLETE: Converted to local cbh table successfully.
]]--


local addon, cbh = ...


function cbh.RaidConfigCreate()
	cbh.RaidConfig = UI.CreateFrame("SimpleTabView", "OptionsWindowFrame", cbh.WindowOptions)
	cbh.RaidConfigA = UI.CreateFrame("Frame", "RaidConfigA", cbh.RaidConfig)
	cbh.RaidConfigB = UI.CreateFrame("Frame", "RaidConfigB", cbh.RaidConfig)
	cbh.RaidConfigC = UI.CreateFrame("Frame", "RaidConfigC", cbh.RaidConfig)
	cbh.RaidConfig:AddTab("Basics", cbh.RaidConfigA)
	cbh.RaidConfig:AddTab("Appearance", cbh.RaidConfigB)
	cbh.RaidConfig:AddTab("Positioning", cbh.RaidConfigC)
	
	cbh.RaidTempText = UI.CreateFrame("Text", "Temp", cbh.RaidConfigA)
	--[[ XXXXXXXXXXXXXXXXXXXXXXX ]]--
	--				BASICS TAB
	--[[ XXXXXXXXXXXXXXXXXXXXXXX ]]--

	
	
	--[[ XXXXXXXXXXXXXXXXXXXXXXX ]]--
	--			APPEARANCE TAB
	--[[ XXXXXXXXXXXXXXXXXXXXXXX ]]--
	cbh.RaidTempColor = {}
	
	
	--[[ XXXXXXXXXXXXXXXXXXXXXXX ]]--
	--				BASICS TAB
	--[[ XXXXXXXXXXXXXXXXXXXXXXX ]]--

end


--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
--			OPTION WINDOW SETUP
--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]

function cbh.RaidConfigSetup()
	if cbhValues.isincombat then return end

	-- Calls the creation of the frames objects
	cbh.RaidConfigCreate()
	
	-- Raid option window
	cbh.RaidConfig:SetPoint("TOPLEFT", cbh.WindowOptions, "TOPLEFT", 15, 20)
	cbh.RaidConfig:SetPoint("BOTTOMRIGHT", cbh.WindowOptions, "BOTTOMRIGHT", -15, -15)
	cbh.RaidConfig:SetBackgroundColor(0, 0, 0, 0)
	cbh.RaidConfig:SetTabContentBackgroundColor(0, 0, 0, 0.6)
	cbh.RaidConfig:SetActiveTabBackgroundColor(0.1, 0.3, 0.1, 0.9)
	cbh.RaidConfig:SetInactiveTabBackgroundColor(0, 0, 0, 0.75)
	cbh.RaidConfig:SetActiveFontColor(0.75, 0.75, 0.75, 1)
	cbh.RaidConfig:SetInactiveFontColor(0.2, 0.2, 0.2, 0.3)
	cbh.RaidConfig:SetVisible(false)

	RaidBasicTab()
	RaidAppearanceTab()
	RaidPositioningTab()
end



function RaidBasicTab()
	cbh.RaidTempText:SetPoint("TOPLEFT", cbh.RaidConfigA, "TOPLEFT", 20, 20)
	cbh.RaidTempText:SetWidth(300)
	cbh.RaidTempText:SetHeight(600)
	cbh.RaidTempText:SetFontSize(16)
	cbh.RaidTempText:SetWordwrap(true)
	cbh.RaidTempText:SetFontColor(1,1,1,1)
	cbh.RaidTempText:SetText("Raid Frame options are currently being converted from the previous area into their designated location. \n\nPlease be patient and check here if you find other options missing")

end


function RaidAppearanceTab()

end


function RaidPositioningTab()

end
