local toc, data = ...
local AddonId = toc.identifier

-- Frame Configuration Options --------------------------------------------------
local LifeRaidFrame2 = WT.UnitFrame:Template("LifeRaidFrame2")
LifeRaidFrame2.Configuration.Name = "Life Raid Frame 2"
LifeRaidFrame2.Configuration.RaidSuitable = true
LifeRaidFrame2.Configuration.FrameType = "Frame"
LifeRaidFrame2.Configuration.Width = 50
LifeRaidFrame2.Configuration.Height = 20
LifeRaidFrame2.Configuration.Resizable = { 55, 40, 500, 70 }
LifeRaidFrame2.Configuration.SupportsHoTPanel = true
LifeRaidFrame2.Configuration.SupportsDebuffPanel = true

--------------------------------------------------------------
function LifeRaidFrame2:Construct(options)
	local template =
	{
		elements = 
		{
			{
				id="frameBackdrop", type="Frame", parent="frame", layer=0,
				attach = 
				{ 
					{ point="TOPLEFT", element="frame", targetPoint="TOPLEFT", offsetX=1, offsetY=-1, },
					{ point="BOTTOMRIGHT", element="frame", targetPoint="BOTTOMRIGHT", offsetX=-1, offsetY=1, } 
				},            				
				visibilityBinding="id", 
				color={r=0,g=0,b=0,a=0},
				FrameAlpha = 1,
				FrameAlphaBinding="FrameAlpha",
			}, 
			{
				id="barHealth", type="Bar", parent="frameBackdrop", layer=10,
				attach = {
					{ point="TOPLEFT", element="frame", targetPoint="TOPLEFT", offsetX=2, offsetY=2 },
					{ point="BOTTOMRIGHT", element="frame", targetPoint="BOTTOMRIGHT", offsetX=-2, offsetY=-2 },
				},
				growthDirection="right",
				binding="healthPercent",				
				healthPercentColor={r=0.22,g=0.55,b=0.06, a=0.85},
				colorBinding="healthPercentColor",	
				media="Texture 39",
				backgroundColor={r=0.07, g=0.07, b=0.07, a=0.85},				
			},
			{
				id="healthCap", type="HealthCap", parent="barHealth", layer=15,
				attach = {
					{ point="TOPLEFT", element="barHealth", targetPoint="TOPLEFT" },
					{ point="BOTTOMRIGHT", element="barHealth", targetPoint="BOTTOMRIGHT" },
				},
				growthDirection="left",
				visibilityBinding="healthCap",
				binding="healthCapPercent",
				color={r=0.5, g=0, b=0, a=0.8},
				media="wtGlaze",
			},			
			{
				id="border", type="Bar", parent="frameBackdrop", layer=10, alpha=1,
				attach = {
					{ point="TOPLEFT", element="frame", targetPoint="TOPLEFT", offsetX=2, offsetY=2 },
					{ point="BOTTOMRIGHT", element="frame", targetPoint="BOTTOMRIGHT", offsetX=-2, offsetY=-2 },
				},
				binding="borderWigth",
				backgroundColor={r=0, g=0, b=0, a=0},				
				Color={r=0,g=0,b=0, a=0},
				border=true, BorderColorBinding="BorderColor", BorderColor = {r=0,g=0,b=0,a=1},
				borderTextureTarget=true, BorderTextureTargetVisibleBinding="BorderTextureTargetVisible", BorderTextureTargetVisible=true,
				borderTextureAggro=true, BorderTextureAggroVisibleBinding="BorderTextureAggroVisible", BorderTextureAggroVisible=true,
			},			
			{
				id="barAbsorb", type="BarWithBorder", parent="frameBackdrop", layer=12,
				attach = {
					{ point="BOTTOMLEFT", element="frame", targetPoint="BOTTOMLEFT", offsetX=3, offsetY=-4 },
					{ point="TOPRIGHT", element="frame", targetPoint="BOTTOMRIGHT", offsetX=-3, offsetY=-7 },
				},
				growthDirection="right",
				binding="absorbPercent", color={r=0.1,g=0.79,b=0.79,a=1.0},
				backgroundColor={r=0, g=0, b=0, a=0},
				media="Texture 69", 
				fullBorder=true,
				BarWithBorderColor={r=0,g=1,b=1,a=1}, 
			},
			{
				id="imgRole", type="MediaSet", parent="frameBackdrop", layer=20,
				attach = {{ point="TOPLEFT", element="frame", targetPoint="TOPLEFT", offsetX=2, offsetY=-2 }}, 
				visibilityBinding="role",
				nameBinding="role", 
				names = { ["tank"] = "iconRoleTank", ["heal"] = "iconRoleHeal", ["dps"] = "iconRoleDPS", ["support"] = "iconRoleSupport" },
				width = 13, height = 13,
				defaultIndex = "hide",
			},		
			{
				id="labelName", type="Label", parent="frame", layer=20,
				attach = {{ point="CENTER", element="frame", targetPoint="CENTER", offsetX=0, offsetY=3 }},
				visibilityBinding="name",
				text="{nameShort}", maxLength=10, default="", outline=true,
				colorBinding="NameColor",
			},
			{
				id="labelStatus", type="Label", parent="frame", layer=20,
				attach = {{ point="BOTTOMCENTER", element="frame", targetPoint="BOTTOMCENTER", offsetX=0, offsetY=-1 }},
				visibilityBinding="UnitStatus",
				color={r = 0.35, g = 0.35, b = 0.35, a = 1.0},
				text=" {UnitStatus}", default="", fontSize=12, outline = true,
			},
			{
			    id="imgMark", type="MediaSet", parent="frameBackdrop", layer=30,
			    attach = {{ point="CENTERLEFT", element="labelName", targetPoint="CENTERRIGHT", offsetX=0, offsetY=0 }},
			    width = 12, height = 12,
			    nameBinding="mark",
			    names = 
			    {
			        ["1"] = "riftMark01_mini",
			        ["2"] = "riftMark02_mini",
			        ["3"] = "riftMark03_mini",
			        ["4"] = "riftMark04_mini",
			        ["5"] = "riftMark05_mini",
			        ["6"] = "riftMark06_mini",
			        ["7"] = "riftMark07_mini",
			        ["8"] = "riftMark08_mini",
			        ["9"] = "riftMark09_mini",
			        ["10"] = "riftMark10_mini",
			        ["11"] = "riftMark11_mini",
			        ["12"] = "riftMark12_mini",
			        ["13"] = "riftMark13_mini",
			        ["14"] = "riftMark14_mini",
			        ["15"] = "riftMark15_mini",
			        ["16"] = "riftMark16_mini",
			        ["17"] = "riftMark17_mini",
			        ["18"] = "riftMark18_mini",
			        ["19"] = "riftMark10_mini",
			        ["20"] = "riftMark10_mini",
			        ["21"] = "riftMark10_mini",
			        ["22"] = "riftMark22_mini",
			        ["23"] = "riftMark23_mini",
			        ["24"] = "riftMark24_mini",
			        ["25"] = "riftMark25_mini",
			        ["26"] = "riftMark26_mini",
			        ["27"] = "riftMark09_mini",
					["28"] = "riftMark09_mini",
			        ["29"] = "riftMark09_mini",
			        ["30"] = "riftMark30_mini",
			    },
			    visibilityBinding="mark",alpha=1.0,
			},
			{
			    id="imgMark2", type="MediaSet", parent="frameBackdrop", layer=31,
			    attach = {{ point="CENTERRIGHT", element="imgMark", targetPoint="CENTERRIGHT", offsetX=7, offsetY=0 }},
			    width = 12, height = 12,
			    nameBinding="mark",
			    names = 
			    {
			        ["19"] = "riftMark02_mini",
			        ["20"] = "riftMark03_mini",
			        ["21"] = "riftMark04_mini",
			        ["27"] = "riftMark02_mini",
					["28"] = "riftMark03_mini",
			        ["29"] = "riftMark04_mini",
			    },
			    visibilityBinding="mark",alpha=1.0,
			},
			{
				id="imgReady", type="ImageSet", parent="frame", layer=30,
				attach = {{ point="CENTER", element="frame", targetPoint="CENTER" }},
				texAddon=AddonId, texFile="img/wtReady.png", nameBinding="readyStatus", cols=1, rows=2, 
				names = { ["ready"] = 0, ["notready"] = 1 }, defaultIndex = "hide"
			},
			{
				id="buffPanelDebuffs", type="BuffPanel", semantic="DebuffPanel", parent="frameBackdrop", layer=30,
				attach = {{ point="BOTTOMRIGHT", element="frameBackdrop", targetPoint="BOTTOMRIGHT", offsetX=-1, offsetY=-3 }},
				rows=1, cols=6, iconSize=16, iconSpacing=1, borderThickness=1,
				auraType="debuff", 
				growthDirection = "left_up",
				--timer = true, timerSize = 14, outline=true, 
				color={r=1,g=1,b=0,a=1},
				stack = true, stackSize = 15, outline=true,
			},
			{
				id="buffPanelHoTs", type="BuffPanel", semantic="HoTPanel", parent="frameBackdrop", layer=30,
				attach = {{ point="TOPRIGHT", element="frameBackdrop", targetPoint="TOPRIGHT", offsetX=-1, offsetY=3 }},
				rows=1, cols=6, iconSize=16, iconSpacing=0, borderThickness=1,
				auraType="hot",selfCast=true, 
				timer = true, timerSize = 11, outline=true, color={r=1,g=1,b=0,a=1}, 
				stack = true, stackSize = 12, outline=true,
				growthDirection = "left_up",
			},
			
		}
	}
	
	for idx,element in ipairs(template.elements) do
		local showElement = true
		if not options.showAbsorb and element.id == "barAbsorb" then showElement = false end
		if element.semantic == "HoTTracker" and not options.showHoTTracker then showElement = false	end
		if element.semantic == "HoTPanel" and not options.showHoTPanel then showElement = false	end
		if element.semantic == "DebuffPanel" and not options.showDebuffPanel then showElement = false	end
		if options.growthDirection and element.id == "barHealth" then element.growthDirection = options.growthDirection	end
		if showElement then
			self:CreateElement(element)
		end
	end

	self:EventAttach(
		Event.UI.Layout.Size,
		function(el)	
			local newWidth = self:GetWidth()
			local newHeight = self:GetHeight()
			local fracWidth = newWidth / LifeRaidFrame2.Configuration.Width
			local fracHeight = newHeight / LifeRaidFrame2.Configuration.Height
			local fracMin = math.min(fracWidth, fracHeight)
			local fracMax = math.max(fracWidth, fracHeight)
			local labName = self.Elements.labelName
			labName:SetFontSize(14)
		end,
		"LayoutSize")
	
	self:SetSecureMode("restricted")
	self:SetMouseoverUnit(self.UnitSpec)
	self:SetMouseMasking("limited")	
	
	if options.clickToTarget then 
		self:EventMacroSet(Event.UI.Input.Mouse.Left.Click, "target @" .. self.UnitSpec)
	end
	if options.contextMenu then
		self:EventAttach(Event.UI.Input.Mouse.Right.Click, function(self, h)
			if self.UnitId then Command.Unit.Menu(self.UnitId) end
		end, "Event.UI.Input.Mouse.Right.Click")
	end 
	
 end  