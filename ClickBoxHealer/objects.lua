--[[
file: objects.lua
by: Solsis00
for: ClickBoxHealer

Where the individual components are created. Not drawn... just created. Contains all the UI.Create defines organized by file/area.

**COMPLETE: Converted to local cbh table successfully.
]]--

local addon, cbh = ...


local _G = getfenv(0)
cbh.abilList = _G.Inspect.Ability.New.List
cbh.abilDetail = _G.Inspect.Ability.New.Detail
cbh.unitDetail = _G.Inspect.Unit.Detail
cbh.unitLookup = _G.Inspect.Unit.Lookup
cbh.buffDetail = _G.Inspect.Buff.Detail
cbh.buffList = _G.Inspect.Buff.List

cbh.mfloor = _G.math.floor
cbh.mceil = _G.math.ceil
cbh.makestring = _G.tostring

cbh.defaults = {}

--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--			MAIN WINDOW SETUP
--[[<>>>>>>>>>>>>>>>>>>>>>>>>>>>]]
--CREATES THE CONTAINER THAT ACTUALLY HOLDS/EDITS EVERYTHING
cbh.Context = UI.CreateContext("Context")
cbh.Context:SetSecureMode("restricted")

cbh.Window = UI.CreateFrame("Frame", "MainWindow", cbh.Context)
cbh.Window:SetSecureMode("restricted")

cbh.WindowDrag = UI.CreateFrame("Texture", "drag frame", cbh.Context)

cbh.SetPoint = {"TOPLEFT", "TOPCENTER", "TOPRIGHT", "CENTERLEFT", "CENTER", "CENTERRIGHT", "BOTTOMLEFT", "BOTTOMCENTER", "BOTTOMRIGHT"}

-- GREEN GLOW
cbh.TitleGlowTable = { blurX=5, blurY=5, colorA=1, colorB=0.25, colorG=0.5, colorR=0.25, knockout=false, offsetX=0, offsetY=0, replace=false, strength=5 }
cbh.ConfigGlowTable = { blurX=2, blurY=2, colorA=1, colorB=0.25, colorG=0.5, colorR=0.25, knockout=false, offsetX=0, offsetY=0, replace=false, strength=1 }

-- BUFF STACK GLOW
cbh.BuffStackGlow = { blurX=1, blurY=1, colorA=1, colorB=0, colorG=0, colorR=0, knockout=false, offsetX=0, offsetY=0, replace=false, strength=6 }

-- UNIT FRAME TEXT GLOW
cbh.NameGlowTable = { blurX=3, blurY=3, colorA=1, colorB=0, colorG=0, colorR=0, knockout=false, offsetX=0, offsetY=0, replace=false, strength=5 }
	
-- INFORMATION DROPPED IN THE NOTIFICATION BOX WHEN CBH IS UPDATED.
cbh.NotificationText = [[
			**Welcome the Player and Target Frames**
			######### v1.31 NOTES ########
		
* Fixed a bug with incorrect securemode for target frame
* Fixed a bug that caused a nil values sometimes with buffs
]]

cbh.adetail = Inspect.Addon.Detail("ClickBoxHealer")

cbh.GenericTooltip = UI.CreateFrame("SimpleTooltip", "Basic Reusable TT", cbh.Context)
cbh.GenericTooltip:SetFontSize(16)
cbh.GenericTooltip:SetLayer(9)


cbh.WindowMMB = UI.CreateFrame("Texture", "MinimapButton",  cbh.Context)
cbh.WindowMMBTip = UI.CreateFrame("SimpleTooltip", "MinimapTip", cbh.WindowMMB)


cbh.playerinfo = {}
-- cbh.playerinfo.id = cbh.unitLookup("player")




-- DEFAULT CLASS COLOR SETTINGS
cbh.ClassColors = {
	warrior = {r = 1, g = 0, b = 0}, --, a = cbhPlayerValues["Colors"][3].a},
	cleric = {r = 0, g = 1, b = 0}, --, a = cbhPlayerValues["Colors"][3].a},
	mage = {r = 0.8, g = 0.5, b = 1}, --, a = cbhPlayerValues["Colors"][3].a},
	rogue = {r = 1, g = 1, b = 0}, --, a = cbhPlayerValues["Colors"][3].a},
}




--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
--[[													UNIT FRAME SETUP]]
--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]

--Defines all the container tables used to store information about  units/frames.
cbh.groupMask = {}
cbh.groupBase = {}
cbh.groupBF = {}
cbh.groupBFBorder = {}
cbh.groupHF = {}
-- cbh.groupHFbackground = {}
cbh.groupHPCap = {}
cbh.groupAggro = {}
cbh.groupAbsBot = {}
cbh.groupMB = {} -- Mana bars backframe
cbh.groupMF = {}	-- Mana bars
cbh.groupName = {}
cbh.groupStatus = {}
cbh.groupRole = {}
cbh.groupRDY = {} -- Ready Check Icon
cbh.groupHoT = {}
cbh.groupHoTs = {}
cbh.groupHoTstack = {}
cbh.groupHoTicon = {}
cbh.groupSel = {}
cbh.groupText = {}
cbh.SoloTable = {}
cbh.groupTooltip = {}

cbh.QueryTable = {}
cbh.RaidTable = {}
cbh.GroupTable = {}
cbh.UnitBuffTable = {}
-- Creates a checks and balances table to store information about each unit in
cbh.UnitStatus = {}
cbh.DeBuffwicon = {}
cbh.RaidMarker = {}
cbh.BuffUnitTable = {}


-- for i = 1, 25 do
for i = 1, 20 do
	cbh.groupBase[i] = UI.CreateFrame("Frame", "Border", cbh.Window)
	cbh.groupBFBorder[i] = UI.CreateFrame("Texture", "Border", cbh.groupBase[i])
	cbh.groupSel[i] = UI.CreateFrame("Texture", "SelBorder", cbh.groupBase[i])
	cbh.groupAggro[i] = UI.CreateFrame("Texture", "AggroBorder", cbh.groupBase[i])
	cbh.groupHF[i] = UI.CreateFrame("Texture", "Health", cbh.groupBase[i])
	cbh.groupBF[i] = UI.CreateFrame("Frame", "Border", cbh.groupBase[i])
	-- cbh.groupHFbackground[i] = UI.CreateFrame("Frame", "Health", cbh.groupBF[i])
	cbh.groupHPCap[i] = UI.CreateFrame("Texture", "Health", cbh.groupBase[i])
	cbh.groupAbsBot[i] = UI.CreateFrame("Texture", "Absorb", cbh.groupBase[i])
	-- cbh.groupMB[i] = UI.CreateFrame("Texture", "Border", cbh.groupBF[i])
	cbh.groupMB[i] = UI.CreateFrame("Frame", "Border", cbh.groupBase[i])
	cbh.groupMF[i] = UI.CreateFrame("Texture", "ManaBars", cbh.groupBase[i])
	cbh.groupName[i] = UI.CreateFrame("Text", "Name", cbh.groupBase[i])
	cbh.groupStatus[i] = UI.CreateFrame("Text", "Status", cbh.groupBase[i])
	cbh.DeBuffwicon[i] = UI.CreateFrame("Texture", "Debuff_Icon", cbh.groupBase[i])
	cbh.RaidMarker[i] = UI.CreateFrame("Texture", "Raid_Mark", cbh.groupBase[i])
	cbh.groupRole[i] = UI.CreateFrame("Texture", "Role", cbh.groupBase[i])
	cbh.groupRDY[i] = UI.CreateFrame("Texture", "RDY", cbh.groupBase[i])
	cbh.groupHoTs[i] = {}
	cbh.groupHoTicon[i] = {}
	cbh.groupHoTstack[i] = {}
	for x = 1, 9 do
		cbh.groupHoTs[i][x] = UI.CreateFrame("Texture", "HoTs", cbh.groupBase[i])
		cbh.groupHoTicon[i][x] = UI.CreateFrame("Texture", "HoTIcon", cbh.groupBase[i])
		cbh.groupHoTstack[i][x] = UI.CreateFrame("Text", "HoTStackText", cbh.groupBase[i])
	end
	cbh.groupTooltip[i] = UI.CreateFrame("SimpleTooltip","groupT"..i, cbh.Window)
	cbh.groupMask[i] = UI.CreateFrame("Frame", "group"..i, cbh.Window)
	cbh.groupMask[i]:SetSecureMode("restricted")
	cbh.RaidTable[string.format("group%.2d", i)] = true
	cbh.UnitBuffTable[string.format("group%.2d", i)] = {}
	cbh.UnitStatus[i] = {}
end

for i = 1, 5 do
	cbh.GroupTable[string.format("group%.2d", i)] = true
	cbh.GroupTable[string.format("group%.2d.pet", i)] = true
	cbh.UnitBuffTable[string.format("group%.2d.pet", i)] = {}
end

cbh.UnitBuffTable["player"] = {}
cbh.UnitBuffTable["player.pet"] = {}
cbh.SoloTable["player"] = true 
cbh.SoloTable["player.pet"] = true 

cbh.RaidMarkerImages = {
	["1"] = "vfx_ui_mob_tag_01.png.dds",
	["2"] = "vfx_ui_mob_tag_02.png.dds",
	["3"] = "vfx_ui_mob_tag_03.png.dds",
	["4"] = "vfx_ui_mob_tag_04.png.dds",
	["5"] = "vfx_ui_mob_tag_05.png.dds",
	["6"] = "vfx_ui_mob_tag_06.png.dds",
	["7"] = "vfx_ui_mob_tag_07.png.dds",
	["8"] = "vfx_ui_mob_tag_08.png.dds",
	["9"] = "vfx_ui_mob_tag_tank.png.dds",
	["10"] = "vfx_ui_mob_tag_heal.png.dds",
	["11"] = "vfx_ui_mob_tag_damage.png.dds",
	["12"] = "vfx_ui_mob_tag_support.png.dds",
	["13"] = "vfx_ui_mob_tag_arrow.png.dds",
	["14"] = "vfx_ui_mob_tag_skull.png.dds",
	["15"] = "vfx_ui_mob_tag_no.png.dds",
	["16"] = "vfx_ui_mob_tag_smile.png.dds",
	["17"] = "vfx_ui_mob_tag_squirrel.png.dds",
	--NEWLY ADDED in RIFT 2.5
	["18"] = "vfx_ui_mob_tag_crown.png.dds",
	["19"] = "vfx_ui_mob_tag_heal2.png.dds",
	["20"] = "vfx_ui_mob_tag_heal3.png.dds",
	["21"] = "vfx_ui_mob_tag_heal4.png.dds",
	["22"] = "vfx_ui_mob_tag_heart.png.dds",
	["23"] = "vfx_ui_mob_tag_heart_leftside.png.dds",
	["24"] = "vfx_ui_mob_tag_heart_rightside.png.dds",
	["25"] = "vfx_ui_mob_tag_radioactive.png.dds",
	["26"] = "vfx_ui_mob_tag_sad.png.dds",
	["27"] = "vfx_ui_mob_tag_tank2.png.dds",
	["28"] = "vfx_ui_mob_tag_tankt3.png.dds",
	["29"] = "vfx_ui_mob_tag_tank4.png.dds",
	["30"] = "vfx_ui_mob_tag_clover.png.dds",
}

cbh.DungeonRoleIcons = {
	["tank"] = "vfx_ui_mob_tag_tank.png.dds",
	["heal"] = "vfx_ui_mob_tag_heal.png.dds",
	["dps"] = "vfx_ui_mob_tag_damage.png.dds",
	["support"] = "vfx_ui_mob_tag_support.png.dds",
}


cbh.RoleImgs = {
	["tank"] = "vfx_ui_mob_tag_tank.png.dds",
	["heal"] = "vfx_ui_mob_tag_heal.png.dds",
	["dps"] = "vfx_ui_mob_tag_damage.png.dds",
	["support"] = "vfx_ui_mob_tag_support.png.dds",
}

cbh.PortraitImgs = {
	["elite"] = "emblem_boss.png.dds",
	["boss"] = "emblem_deathcon.png.dds",
	["normal"] = "emblem_normal.png.dds",
	["rare"] = "target_portrait_LootPinata.png.dds",
	["dead"] = "death_icon_(gray).png.dds",
}

-- CREATES THE STATIC TABLES USED IN VARIOUS PARTS OF THE ADDON SO THEY CAN BE CYCLED THROUGH IN CHECKS
cbh.UnitTable = {"player", "player.pet"}
cbh.UnitsTable = {"group01", "group02", "group03", "group04", "group05", "group06", "group07", "group08", "group09", "group10", "group11", "group12", "group13", "group14", "group15", "group16", "group17", "group18", "group19", "group20"}
cbh.UnitsGroupTable = {"group01", "group02", "group03", "group04", "group05", "group01.pet", "group02.pet", "group03.pet", "group04.pet", "group05.pet"}
cbh.lf = "\n"
cbh.clickOffset = {x = 0, y = 0}
cbh.resizeOffset = {x = 0, y = 0}
cbh.Calling = {"warrior", "cleric", "mage", "rogue", "percentage"}
cbh.Role = {"tank", "heal", "dps", "support"}

cbh.BuffWatchLocations = {"TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT", "CENTERLEFT", "CENTERRIGHT"}
cbh.framepos = {}




--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
--[[										NEW EVENT CALL SYSTEM]]
--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]







--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
--[[										NEW EVENT CALL SYSTEM]]
--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]







--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
--[[										NEW EVENT CALL SYSTEM]]
--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]








--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
--[[										NEW EVENT CALL SYSTEM]]
--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]






--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
--										CREATE OPTION WINDOWS
--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]

-- cbh.ConfigWindowCreate()


-- function cbh.ConfigWindowCreate()
	cbh.WindowOptions = UI.CreateFrame("Frame", "OptionsWindow", cbh.Context)
	cbh.WindowOptions:SetVisible(false)

	cbh.WindowOptionsCancel = UI.CreateFrame("RiftButton", "CloseOptWindow", cbh.WindowOptions)
	cbh.WindowOptionsSave = UI.CreateFrame("RiftButton", "SaveColorChanges", cbh.WindowOptions)

	cbh.ConfigGroupsFrame = UI.CreateFrame("Frame", "ConfigGroupsFrame", cbh.WindowOptions)
	cbh.ConfigGroupsList = UI.CreateFrame("SimpleList", "ConfigGroupsFrame", cbh.ConfigGroupsFrame)

	cbh.WindowOptionsTab = UI.CreateFrame("SimpleTabView", "OptionsWindowFrame", cbh.WindowOptions)
	cbh.WindowOptionsA = UI.CreateFrame("Frame", "OptionsWindowA", cbh.WindowOptionsTab)
	cbh.WindowOptionsB = UI.CreateFrame("Frame", "OptionsWindowB", cbh.WindowOptionsTab)
	cbh.WindowOptionsC = UI.CreateFrame("Frame", "OptionsWindowC", cbh.WindowOptionsTab)
	cbh.WindowOptionsD = UI.CreateFrame("Frame", "OptionsWindowD", cbh.WindowOptionsTab)
	cbh.WindowOptionsE = UI.CreateFrame("Frame", "OptionsWindowE", cbh.WindowOptionsTab)
	cbh.WindowOptionsTab:AddTab("Addon Basics", cbh.WindowOptionsA)
	cbh.WindowOptionsTab:AddTab("Frame Options", cbh.WindowOptionsB)
	cbh.WindowOptionsTab:AddTab("Spell Bindings", cbh.WindowOptionsC)
	cbh.WindowOptionsTab:AddTab("Buff/De Options", cbh.WindowOptionsD)
	cbh.WindowOptionsTab:AddTab("Profiles", cbh.WindowOptionsE)



	cbh.configTabTable = { "WindowOptionsTab", "PlayerConfig" }
-- end





--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
--[[								FILLER FRAME FOR NOW - INFO]]
--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]

cbh.InfoTabText = UI.CreateFrame("Text", "Basics", cbh.WindowOptionsA)
cbh.MMBToggle = UI.CreateFrame("SimpleCheckbox", "ToggleMMB", cbh.WindowOptionsA)
cbh.OutofCombat = UI.CreateFrame("SimpleCheckbox", "OutofCombat", cbh.WindowOptionsA)
cbh.OutofCombatAlphaText = UI.CreateFrame("Text", "OutofCombatAlpha", cbh.WindowOptionsA)
cbh.OutofCombatAlpha = UI.CreateFrame("SimpleSlider", "OutofCombatAlphaSlider", cbh.WindowOptionsA)
cbh.NotificationToggle = UI.CreateFrame("RiftButton", "ToggleNotifyWindow", cbh.WindowOptionsA)


-- cbh.InfoTab = UI.CreateFrame("RiftTextfield", "EntryBox", cbh.WindowOptionsA)
-- cbh.InfoTabDropText = UI.CreateFrame("Text", "EntryBoxDropText", cbh.WindowOptionsA)
-- cbh.InfoTabBackground = UI.CreateFrame("Frame", "Layout Backdrop", cbh.WindowOptionsA)
-- cbh.InfoTabRemove = UI.CreateFrame("RiftButton", "Layout Remove Button", cbh.WindowOptionsA)
-- cbh.InfoTabApply = UI.CreateFrame("RiftButton", "Layout Apply Button", cbh.WindowOptionsA)
-- cbh.InfoTabList = UI.CreateFrame("SimpleSelect", "Layout List", cbh.WindowOptionsA)
-- cbh.InfoTabAddedText = UI.CreateFrame("Text", "Layout Info", cbh.WindowOptionsA)

cbh.NotifyWindow = UI.CreateFrame("Frame", "MainWindow", cbh.Context)
cbh.NotifyWindowText = UI.CreateFrame("Text", "MainWindow", cbh.NotifyWindow)
cbh.NotifyWindowTitle = UI.CreateFrame("Text", "OptTitleBar", cbh.NotifyWindow)
cbh.NotifyWindowOKButton = UI.CreateFrame("RiftButton", "MainWindow", cbh.NotifyWindow)


--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
--[[										COLOR/TEXTURES OBJECTS]]
--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]

-- TEXT OBJECTS FOR FRAME TAB
cbh.CallingSelText = UI.CreateFrame("Text", "Example", cbh.WindowOptionsB)
cbh.TextureSelText = UI.CreateFrame("Text", "Example", cbh.WindowOptionsB)
cbh.UFPreviewText = UI.CreateFrame("Text", "Example", cbh.WindowOptionsB)

-- UNIT CALLING COLOR OBJECTS
cbh.OptionsCallingSelector = UI.CreateFrame("SimpleList", "ColorList", cbh.WindowOptionsB)

-- CUSTOM COLOR SLIDERS
cbh.OptionsColorSliderR = UI.CreateFrame("SimpleSlider", "ColorR", cbh.WindowOptionsB)
cbh.OptionsColorSliderG = UI.CreateFrame("SimpleSlider", "ColorG", cbh.WindowOptionsB)
cbh.OptionsColorSliderB = UI.CreateFrame("SimpleSlider", "ColorB", cbh.WindowOptionsB)
cbh.OptionsColorSliderText = UI.CreateFrame("Text", "TextCallingColor", cbh.WindowOptionsB)

cbh.OptionsColorToggle = UI.CreateFrame("SimpleCheckbox", "ColorToggle", cbh.WindowOptionsB)

-- UNIT BACK FRAME ALPHA SLIDER
cbh.OptionsColorSliderBFCA = UI.CreateFrame("SimpleSlider", "FColorAlpha", cbh.WindowOptionsB)
-- cbh.OptionsColorSliderBFCAText = UI.CreateFrame("Text", "TextFColor", cbh.WindowOptionsB)



-- LOCATION OPTIONS FOR FRAME ELEMENTS
cbh.StatusOptions = {"Percent", "Deficit", "Health"}

cbh.RoleLocation = UI.CreateFrame("SimpleSelect", "RoleLocation", cbh.WindowOptionsB)
cbh.RoleLocationText = UI.CreateFrame("Text", "RoleLocationText", cbh.WindowOptionsB)
cbh.RoleSize = UI.CreateFrame("SimpleSlider", "RoleIconSize", cbh.WindowOptionsB)

cbh.NameLocation = UI.CreateFrame("SimpleSelect", "NameLocation", cbh.WindowOptionsB)
cbh.NameLocationText = UI.CreateFrame("Text", "NameLocationText", cbh.WindowOptionsB)
cbh.NameLengthOption = UI.CreateFrame("SimpleCheckbox", "NameLengthOption", cbh.WindowOptionsB)
cbh.NameLength = UI.CreateFrame("SimpleSlider", "NameLength", cbh.WindowOptionsB)
cbh.FontSizer = UI.CreateFrame("SimpleSlider", "FontSize", cbh.WindowOptionsB)

cbh.ReadyCheckLocation = UI.CreateFrame("SimpleSelect", "NameLocation", cbh.WindowOptionsB)
cbh.ReadyCheckText = UI.CreateFrame("Text", "NameLocationText", cbh.WindowOptionsB)
cbh.ReadyCheckSize = UI.CreateFrame("SimpleSlider", "NameLength", cbh.WindowOptionsB)

cbh.StatusLocation = UI.CreateFrame("SimpleSelect", "StatusLocation", cbh.WindowOptionsB)
cbh.StatusLocationText = UI.CreateFrame("Text", "StatusLocationText", cbh.WindowOptionsB)
cbh.StatusFontSizer = UI.CreateFrame("SimpleSlider", "FontSize", cbh.WindowOptionsB)
cbh.StatusDisplay = UI.CreateFrame("SimpleSelect", "StatusDisplay", cbh.WindowOptionsB)
cbh.StatusDisplayText = UI.CreateFrame("Text", "StatusDisplay", cbh.WindowOptionsB)

cbh.RMarkLocation = UI.CreateFrame("SimpleSelect", "RMarkLocation", cbh.WindowOptionsB)
cbh.RMarkLocationText = UI.CreateFrame("Text", "RMarkLocationText", cbh.WindowOptionsB)
cbh.RMarkSize = UI.CreateFrame("SimpleSlider", "FontSize", cbh.WindowOptionsB)





-- OBJECTS FOR PREVIEW
cbh.OptionsUITexture = UI.CreateFrame("Texture", "Health", cbh.WindowOptionsB)
cbh.OptionsUITextureBF = UI.CreateFrame("Texture", "HealthBF", cbh.WindowOptionsB)
cbh.OptionsColor1 = UI.CreateFrame("Text", "Example", cbh.WindowOptionsB)
cbh.OptionsColor2 = UI.CreateFrame("Text", "Example", cbh.WindowOptionsB)
cbh.OptionsUITextureAb = UI.CreateFrame("Texture", "Absorb Preview", cbh.WindowOptionsB)

-- UNIT TEXTURE OBJECTS
cbh.OptionsTextureSelector = UI.CreateFrame("SimpleSelect", "TextureList", cbh.WindowOptionsB)



-- OPTIONS FOR UNIT FRAME ORDERING
cbh.groupColumns = UI.CreateFrame("SimpleSelect", "UFColumns", cbh.WindowOptionsB)
cbh.groupOrderVup = UI.CreateFrame("SimpleCheckbox", "ToggleOrderVup", cbh.WindowOptionsB)
cbh.groupOrderHRight = UI.CreateFrame("SimpleCheckbox", "ToggleOrderHRight", cbh.WindowOptionsB)
cbh.groupOrderHLeft = UI.CreateFrame("SimpleCheckbox", "DrawHorizontalGroups", cbh.WindowOptionsB)


-- ENABLES FAST CPU UPDATES
-- cbh.UIFastCPU = UI.CreateFrame("SimpleCheckbox", "Faster updates", cbh.WindowOptionsB)
-- cbh.UIFastCPUText = UI.CreateFrame("Frame", "FastUpdateWarn", cbh.WindowOptionsB)

cbh.CMenuToggle = UI.CreateFrame("SimpleCheckbox", "ToggleContextMenu", cbh.WindowOptionsB)
cbh.CMenuToggleText = UI.CreateFrame("Text", "ToggleCMenuText", cbh.WindowOptionsB)


-- OPTIONS FOR UNIT FRAME SPACING
cbh.groupSpacingText = UI.CreateFrame("Text", "SpacingText", cbh.WindowOptionsB)
cbh.groupVSpacing = UI.CreateFrame("SimpleSlider", "VerticalSpacing", cbh.WindowOptionsB)
cbh.groupHSpacing = UI.CreateFrame("SimpleSlider", "HorizontalSpacing", cbh.WindowOptionsB)


-- SIZE OF EACH FRAME
cbh.groupSizeText = UI.CreateFrame("Text", "GroupSizeText", cbh.WindowOptionsB)
cbh.groupWidth = UI.CreateFrame("SimpleSlider", "GroupSizeWidth", cbh.WindowOptionsB)
cbh.groupHeight = UI.CreateFrame("SimpleSlider", "GroupSizeHeight", cbh.WindowOptionsB)


-- RANGE/LOS ALPHA SETTING
cbh.AlphaSetting = UI.CreateFrame("SimpleSlider", "AlphaSetting", cbh.WindowOptionsB)
cbh.AlphaSettingText = UI.CreateFrame("Text", "AlphaSetting", cbh.WindowOptionsB)


-- TOGGLE BUTTONS FOR VARIOUS OBJECTS.
cbh.RoleToggle = UI.CreateFrame("SimpleCheckbox", "RoleToggleCheck", cbh.WindowOptionsB)
cbh.ShowPetsToggle = UI.CreateFrame("SimpleCheckbox", "PetToggleCheck", cbh.WindowOptionsB)
cbh.TooltipsToggle = UI.CreateFrame("SimpleCheckbox", "ToggleTT", cbh.WindowOptionsB)
cbh.RangeToggle = UI.CreateFrame("SimpleCheckbox", "ToggleRangeCheck", cbh.WindowOptionsB)
cbh.RangeDistance = UI.CreateFrame("SimpleCheckbox", "RangeDistanceCheck", cbh.WindowOptionsB)
cbh.HideHealthToggle = UI.CreateFrame("SimpleCheckbox", "ToggleContextMenu", cbh.WindowOptionsB)
cbh.AbsorbToggle = UI.CreateFrame("SimpleCheckbox", "ToggleAbosrb", cbh.WindowOptionsB)
cbh.manaClassColor = UI.CreateFrame("SimpleCheckbox", "ToggleClassColorMana", cbh.WindowOptionsB)


-- MANA BAR SIZE BUTTONS
cbh.ManabarSizeText = UI.CreateFrame("Text", "Manabar Size Text", cbh.WindowOptionsB)
cbh.ManabarSizeHeight = UI.CreateFrame("SimpleSlider", "Manabar Size Height", cbh.WindowOptionsB)

-- ABSORB BAR SIZE BUTTONS
cbh.AbsbarSizeText = UI.CreateFrame("Text", "Absorb Size Text", cbh.WindowOptionsB)
cbh.AbsbarSizeHeight = UI.CreateFrame("SimpleSlider", "Absorb Size Height", cbh.WindowOptionsB)





--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
--[[									ABILITY LIST/BINDING OBJECTS]]
--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]

cbh.OptionsText = {"Mouse Left", "Mouse Right", "Mouse Middle", "Mouse 4", "Mouse 5", "Wheel Up", "Wheel Down", "Shift", "Ctrl", "Alt", "None", "[shift]", "[ctrl]", "[alt]", ""}
cbh.OptionsRadioA = {}
cbh.OptionsRadioB = {}
cbh.OptionsModText = {}
cbh.OptionsModTextInput = {}
-- cbh.WindowOptionsEditor = UI.CreateFrame("Frame", "OptionsMacro Editor", cbh.WindowOptions)
cbh.WindowOptionsEditor = UI.CreateFrame("Frame", "OptionsMacro Editor", cbh.WindowOptionsC)
cbh.OptionsCustom = UI.CreateFrame("RiftTextfield", "Custom", cbh.WindowOptionsEditor)
cbh.OptionsCustomHelp = UI.CreateFrame("Text", "Custom", cbh.WindowOptionsEditor)
cbh.OptionsCustomButton = UI.CreateFrame("RiftButton", "Custom", cbh.WindowOptionsEditor)
cbh.CustomMacroCancel = UI.CreateFrame("RiftButton", "OpenCustomBuffAdd", cbh.WindowOptionsEditor)
cbh.OptionsCustomHelpText = "Type each macro command on a single line.\nYou do not have to enter SUPPRESSMACROFAILURES, that will be handled in code.\n\nYou can use all the modifiers in here [shift], [ctrl] [alt].\nMacros work exactly in this editor as they do in the Rift editor with a small change.\n\nInstead of using mouseover, you need to use ## instead. The result will be group01 to group 20.\n    Example: cast [ctrl] ## Healing Wave\n\nThis will cast Healing Wave on your current group member you are clicking and only if you are holding down control key as well."


-- Creates radio selections for mouse button selector (mouse left, mouse right, middle, etc
cbh.OptionsSetA = Library.LibSimpleWidgets.RadioButtonGroup("cbh.OptionsSetA")
for i = 1, 7 do
	cbh.OptionsRadioA[i] = UI.CreateFrame("SimpleRadioButton", "OptionsRadioButtonA", cbh.WindowOptionsC)
	cbh.OptionsSetA:AddRadioButton(cbh.OptionsRadioA[i])
end
cbh.OptionsRadioSeperator = UI.CreateFrame("Texture", "OptionsBorderB", cbh.WindowOptionsC)

-- Creates ability list and container
cbh.tAbilityListScroll = UI.CreateFrame("SimpleScrollView", "AbilityScrollFrame", cbh.WindowOptionsTab)
cbh.tAbilityContainer = UI.CreateFrame("Frame", "AbilitySpellContainer", cbh.tAbilityListScroll)
cbh.tAbilityHelpText = UI.CreateFrame("Text", "test", cbh.WindowOptionsC)
-- cbh.tAbilityListScrollTip = UI.CreateFrame("SimpleTooltip", "AbilityTips", cbh.WindowOptions)






--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
--[[									BUFF/DEBUFF CONFIG OBJECTS]]
--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]

cbh.myBuffs = {}
cbh.myBuffIcons = UI.CreateFrame("Texture", "abilicons", cbh.WindowOptionsD)

cbh.BuffOptionsText = {"Top Right", "Bottom Left", "Bottom Right", "Left Center", "Right Center"}
cbh.BuffWarnColorText = {"Base Color", "5 Second Warning", "3 Second Warning"}
cbh.BuffOptions = {}
cbh.BuffTextDisplay = {}


-- Custom Buff Adder
cbh.CustomBuff = UI.CreateFrame("Frame", "OptionsMacro Editor", cbh.WindowOptions)
cbh.CustomBuffAdd = UI.CreateFrame("RiftTextfield", "Custom", cbh.CustomBuff)
cbh.CustomBuffAddButton = UI.CreateFrame("RiftButton", "Custom", cbh.CustomBuff)
cbh.CustomBuffCanButton = UI.CreateFrame("RiftButton", "Custom", cbh.CustomBuff)
cbh.CustomBuffLocText = UI.CreateFrame("Text", "CustomText", cbh.CustomBuff)


-- BUFF CUSTOM COLOR OBJECTS
cbh.BuffColorText = UI.CreateFrame("Text", "BuffColorText", cbh.WindowOptionsD)
cbh.BuffColorList = UI.CreateFrame("SimpleList", "BuffColorList", cbh.WindowOptionsD)
cbh.BuffColorR = UI.CreateFrame("SimpleSlider", "BuffColorRed", cbh.WindowOptionsD)
cbh.BuffColorG = UI.CreateFrame("SimpleSlider", "BuffColorGreen", cbh.WindowOptionsD)
cbh.BuffColorB = UI.CreateFrame("SimpleSlider", "BuffColorBlue", cbh.WindowOptionsD)

cbh.BuffListToggle = UI.CreateFrame("SimpleCheckbox", "ListRefresh", cbh.WindowOptionsD)
cbh.BuffIconOption = UI.CreateFrame("SimpleCheckbox", "BuffIcon", cbh.WindowOptionsD)

-- BUFF WARNING COLOR TOGGLE
cbh.BuffWarnColorToggle = UI.CreateFrame("SimpleCheckbox", "ListRefresh", cbh.WindowOptionsD)

-- BUFF FADE/FLASH OBJECTS
cbh.BuffFadeToggle = UI.CreateFrame("SimpleCheckbox", "ListRefresh", cbh.WindowOptionsD)
cbh.BuffFlashToggle = UI.CreateFrame("SimpleCheckbox", "ListRefresh", cbh.WindowOptionsD)

-- BUFF WATCH SIZE
cbh.BuffSize = UI.CreateFrame("SimpleSlider", "CBHBuffSize", cbh.WindowOptionsD)
cbh.BuffSizeText =  UI.CreateFrame("Text", "CBHBuffSizeText", cbh.WindowOptionsD)




-- DEBUFF SETTINGS OBJECTS
cbh.DebuffListToggle = UI.CreateFrame("SimpleCheckbox", "DebuffToggle", cbh.WindowOptionsD)
cbh.DebuffColorWholeToggle = UI.CreateFrame("SimpleCheckbox", "DebuffColorWhole", cbh.WindowOptionsD)


cbh.DeBuffWListText = UI.CreateFrame("Text", "DeBuffW Whitelist", cbh.WindowOptionsD)
cbh.DeBuffWListFrame = UI.CreateFrame("SimpleScrollView", "List", cbh.WindowOptionsD)
cbh.DeBuffWListAddSpell = UI.CreateFrame("RiftTextfield", "ListRefresh", cbh.WindowOptionsD)
cbh.DeBuffWListAddButton = UI.CreateFrame("RiftButton", "ListRefresh", cbh.WindowOptionsD)
cbh.DeBuffWListRemButton = UI.CreateFrame("RiftButton", "ListRefresh", cbh.WindowOptionsD)
cbh.DeBuffWList = UI.CreateFrame("SimpleList", "List", cbh.WindowOptionsD)


cbh.DeBuffBListText = UI.CreateFrame("Text", "DeBuffB Whitelist", cbh.WindowOptionsD)
cbh.DeBuffBListFrame = UI.CreateFrame("SimpleScrollView", "List", cbh.WindowOptionsD)
cbh.DeBuffBListAddSpell = UI.CreateFrame("RiftTextfield", "ListRefresh", cbh.WindowOptionsD)
cbh.DeBuffBListAddButton = UI.CreateFrame("RiftButton", "ListRefresh", cbh.WindowOptionsD)
cbh.DeBuffBListRemButton = UI.CreateFrame("RiftButton", "ListRefresh", cbh.WindowOptionsD)
cbh.DeBuffBList = UI.CreateFrame("SimpleList", "List", cbh.WindowOptionsD)



--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]
--[[										CUSTOM LAYOUT OBJECTS]]
--[[<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>]]

cbh.LayoutEntry = UI.CreateFrame("RiftTextfield", "EntryBox", cbh.WindowOptionsE)
cbh.LayoutEntryText = UI.CreateFrame("Text", "EntryBoxText", cbh.WindowOptionsE)
cbh.LayoutEntryDropText = UI.CreateFrame("Text", "EntryBoxDropText", cbh.WindowOptionsE)
cbh.LayoutEntryBackground = UI.CreateFrame("Frame", "Layout Backdrop", cbh.WindowOptionsE)
cbh.LayoutEntryRemove = UI.CreateFrame("RiftButton", "Layout Remove Button", cbh.WindowOptionsE)
cbh.LayoutEntryApply = UI.CreateFrame("RiftButton", "Layout Apply Button", cbh.WindowOptionsE)
cbh.LayoutEntryList = UI.CreateFrame("SimpleSelect", "Layout List", cbh.WindowOptionsE)
cbh.LayoutInfoText = UI.CreateFrame("Text", "Layout Info", cbh.WindowOptionsE)
