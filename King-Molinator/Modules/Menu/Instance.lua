﻿-- KBM Menu System: Encounter System
-- Written by Paul Snart
-- Copyright 2013
--

local AddonIni, KBM = ...
local LibSata = Inspect.Addon.Detail("SafesTableLib").data
local LibSGui = Inspect.Addon.Detail("SafesGUILib").data

local Menu = KBM.Menu
Menu.Instance = {}
local Instance = Menu.Instance
local Build = {}
Instance.Ref = {}
Instance.Page = {}

function Instance:SetStyle()
	Menu.Current.Style = "Instance"
	Menu.PageUI.Tabber:SetVisible(true)
	Menu.PageUI.Panel:SetPoint("TOP", Menu.Header.Cradle, "BOTTOM", nil, Menu.PageUI.Tabber:GetHeight())
	Menu.PageUI.Content:SetVisible(false)
	Menu.PageUI.Main:SetContentHeight(10)
end

function Instance:Create(Mod)
	local InstanceObj = {}
	if not Menu.Tab.Rift[Mod.Rift] then
		print("Warning: "..tostring(Mod.Name).." has an Unknown Rift Version: "..tostring(Mod.Rift))
		local strBuild = ""
		return
	end
	local Table = Menu.Tab.Rift[Mod.Rift][Mod.Type]
	
	InstanceObj.LongID = Mod.Rift.."_"..Mod.Type.."_"..Mod.ID
	if not KBM.Options.MenuState[InstanceObj.LongID] then
		KBM.Options.MenuState[InstanceObj.LongID] = KBM.Defaults.Menu()
	end
	InstanceObj.MenuState = KBM.Options.MenuState[InstanceObj.LongID]
	InstanceObj.Instance = Mod
	InstanceObj.TabObj = Table
	InstanceObj.Node = Table.TreeView:Create(Mod.Name, {Collapse = InstanceObj.MenuState.Collapse})
	InstanceObj.Type = "Instance"
	InstanceObj.ID = Mod.ID
	InstanceObj.Name = Mod.Name
	InstanceObj.Encounter = {}
	InstanceObj.TabObj.Tab:Enable()
	
	function InstanceObj:CollapseHandler()
		InstanceObj.MenuState.Collapse = true
	end
	InstanceObj.Node:EventAttach("Collapse", InstanceObj.CollapseHandler, "Node "..InstanceObj.ID.." Collapse")
	
	function InstanceObj:ExpandHandler()
		InstanceObj.MenuState.Collapse = false
	end
	InstanceObj.Node:EventAttach("Expand", InstanceObj.ExpandHandler, "Node "..InstanceObj.ID.." Expand")
	
	function InstanceObj:CreateEncounter(Mod)
		local Encounter = {}
		Encounter.Instance = self
		Encounter.Mod = Mod
		Encounter.Node = self.Node:Create(Mod.Descript)
		Encounter.Name = Mod.Descript
		Encounter.Node.UserData._pageObj = Encounter
		Encounter.ID = Mod.ID
		Encounter.UI = {}
		Encounter.Type = "Encounter"
		Encounter.Style = "Single"

		Encounter.TabStore = {}
		for ID, TabObj in pairs(Instance.Page) do
			Encounter.TabStore[ID] = {}
		end
		
		for ID, _function in pairs(Menu.Object) do
			Encounter.UI[ID] = function(Name, Settings, ID, Callback)
				return _function(Menu.Object, Name, Settings, ID, Callback, Encounter)
			end
		end				
		self.Encounter[Encounter.ID] = Encounter
		
		function Encounter:SetStyle()
			if self.Selected then
				if self.Style ~= self.Selected.Style then
					self.Style = self.Selected.Style
					if self.Style == "Double" then
						Menu.PageUI.Main:SetPoint("RIGHT", Menu.PageUI.Panel.Content, 0.677, nil)
						Menu.PageUI.Side:SetVisible(true)
						Menu.PageUI.Side:SetPoint("LEFT", Menu.PageUI.Panel.Content, 0.677, nil, 4, nil)
						Menu.PageUI.Side:SetPoint("RIGHT", Menu.PageUI.Panel.Content, "RIGHT", -0.5, nil)
					else 
						Menu.PageUI.Main:SetPoint("RIGHT", Menu.PageUI.Panel.Content, "RIGHT")
						Menu.PageUI.Side:ClearPoint("RIGHT")
						Menu.PageUI.Side:SetVisible(false)
					end
				end
			end
		end

		function Encounter:ApplyRecords()
			if Instance.Page.Records.Complete then
				local Settings = self.Mod.Settings.Records
				if Settings.Best then
					if Settings.Best > 0 then
						self.Mod.MenuStore.Records.Best:Update(KBM.ConvertTime(Settings.Best))
						if Settings.Date then
							self.Mod.MenuStore.Records.Date:Update(KBM.Language.Records.Date[KBM.Lang]..Settings.Date)
						end
					else
						self.Mod.MenuStore.Records.Best:Update(KBM.Language.Records.NoRecord[KBM.Lang])
					end
				else
					self.Mod.MenuStore.Records.Best:Update(KBM.Language.Records.NoRecord[KBM.Lang])
				end
				if Settings.Kills > Settings.Attempts then
					local Adjust = Settings.Kills - Settings.Attempts
					Settings.Attempts = Settings.Attempts + Adjust
				end
				if Settings.Wipes ~= (Settings.Attempts - Settings.Kills) then
					Settings.Wipes = (Settings.Attempts - Settings.Kills)
				end
				self.Mod.MenuStore.Records.Attempts:Update(KBM.Language.Records.Attempts[KBM.Lang]..Settings.Attempts)
				self.Mod.MenuStore.Records.Kills:Update(KBM.Language.Records.Kills[KBM.Lang]..Settings.Kills)
				self.Mod.MenuStore.Records.Wipes:Update(KBM.Language.Records.Wipes[KBM.Lang]..Settings.Wipes)
				if Settings.Attempts > 0 then
					self.Mod.MenuStore.Records.Rate:Update(KBM.Language.Records.Rate[KBM.Lang]..string.format("%0.1f%%", (Settings.Kills/Settings.Attempts) * 100))
				else
					self.Mod.MenuStore.Records.Rate:Update(KBM.Language.Records.Rate[KBM.Lang].."n/a")
				end
			end
		end
		
		function Encounter:SetCastbars()
			KBM.Castbar.Global.CastObj:SetVisible(false)
			if self.Mod.HasCastbars then
				for BossName, BossObj in pairs(self.Mod.Bosses) do
					if BossObj.CastBar then
						BossObj.CastBar:Display()
						--print(BossName.." Enabled: "..tostring(BossObj.CastBar.CastObj.Enabled))
					end
				end
			end		
		end
		
		function Encounter:ClearCastbars()
			if self.Mod.HasCastbars then
				for BossName, BossObj in pairs(self.Mod.Bosses) do
					if BossObj.CastBar then
						BossObj.CastBar:Hide()
					end
				end
			end
			KBM.Castbar.Global.CastObj:SetVisible(KBM.Options.Castbar.Global.visible)
		end
		
		function Encounter:Open()
			if Menu.Current.Style ~= "Instance" then
				Instance:SetStyle()
			end
			Menu.Header.MainText:SetText(self.Instance.Name)
			Menu.Header.SubText:SetText(self.Name)
			for ID, PageObj in pairs(Instance.Page) do
				PageObj:Render(self)
			end
			if self.Selected then
				self.Selected.Tab:Select()
				self.Selected:Open()
			end
			Menu.Current.Encounter = self
			
			-- Set Page Specific Settings/Layout
			if self.Mod.Settings.EncTimer then
				if self.Mod.Settings.EncTimer.Override then
					KBM.EncTimer.Settings = self.Mod.Settings.EncTimer
					KBM.EncTimer:ApplySettings()
				end
			end
			
			if self.Mod.Settings.PhaseMon then
				if self.Mod.Settings.PhaseMon.Override then
					KBM.PhaseMonitor.Settings = self.Mod.Settings.PhaseMon
					KBM.PhaseMonitor:ApplySettings()
				end
			end
			
			if self.Mod.Settings.MechTimer then
				if self.Mod.Settings.MechTimer.Override then
					KBM.MechTimer.Settings = self.Mod.Settings.MechTimer
					KBM.MechTimer:ApplySettings()
				end
			end
			
			if self.Mod.Settings.MechSpy then
				if self.Mod.Settings.MechSpy.Override then
					KBM.MechSpy.Settings = self.Mod.Settings.MechSpy
					KBM.MechSpy:ApplySettings()
				end
			end
			
			if self.Mod.Settings.Alerts then
				if self.Mod.Settings.Alerts.Override then
					KBM.Alert.Settings = self.Mod.Settings.Alerts
					KBM.Alert:ApplySettings()
				end
			end
			self:SetCastbars()
			
			-- To be fixed
			if self.Mod.Custom then
				if self.Mod.Custom.SetPage then
					--self.Mod.Custom.SetPage()
				end
			end
			self:SetStyle()
		end
		
		function Encounter:Close()
			Menu.Current.Encounter = nil
			Menu.RenderHalt()
			if self.Selected then
				self.Selected:Close()
			end
			for _, PageObj in pairs(Instance.Page) do
				PageObj:Remove()
			end
			KBM.EncTimer.Settings = KBM.Options.EncTimer
			KBM.EncTimer:ApplySettings()
			KBM.PhaseMonitor.Settings = KBM.Options.PhaseMon
			KBM.PhaseMonitor:ApplySettings()
			KBM.MechTimer.Settings = KBM.Options.MechTimer
			KBM.MechTimer:ApplySettings()
			KBM.Alert.Settings = KBM.Options.Alerts
			KBM.Alert:ApplySettings()
			KBM.MechSpy.Settings = KBM.Options.MechSpy
			KBM.MechSpy:ApplySettings()
			
			self:ClearCastbars()
			self.Style = nil
			
			if self.Mod.Custom then
				if self.Mod.Custom.ClearPage then
					--self.Boss.Mod.Custom.ClearPage()
				end
			end
		end
		
		function Encounter:Select()
			-- Force Selection of a Page
			self:Open()
		end
		Encounter.Selected = Instance.Page.Encounter
		
		return Encounter
	end
	
	if not Instance.Ref[Mod.Rift] then
		Instance.Ref[Mod.Rift] = {}
	end
	if not Instance.Ref[Mod.Rift][Mod.Type] then
		Instance.Ref[Mod.Rift][Mod.Type] = {}
	end
	if not Instance.Ref[Mod.Rift][Mod.Type][Mod.ID] then
		Instance.Ref[Mod.Rift][Mod.Type][Mod.ID] = InstanceObj
	else
		error("Duplicate Instance ID: "..Mod.ID)
	end
		
	Mod.MenuObj = InstanceObj
end

function Instance:BuildTabs()
	for i, TabRef in ipairs(Menu.Default.TabList.Page) do
		local Page = {}
		Page.Object = LibSata:Create()
		Page.Tab = Menu.PageUI.Tab[TabRef.ID].Tab
		Page.Tab.UserData._function = Page
		Page.Rendered = LibSata:Create()
		Page.ID = TabRef.ID
		Page.Type = "Encounter"
		Page.UI = {
			Cradle = Menu.PageUI.Tab[TabRef.ID].Anchor,
			Content = Menu.PageUI.Tab[TabRef.ID].Content,
		}
		Page.Style = TabRef.Style
		Page._root = Page
		Page.Height = 10
		Page.Padding = 0
		Page.Complete = false
		Page.ChildState = true
		Page.Enabled = true
		
		Page.Side = {
			Object = LibSata:Create(),
			UI = {
				Cradle = Menu.PageUI.Tab[TabRef.ID].Side.Anchor,
				Content = Menu.PageUI.Tab[TabRef.ID].Side.Content,
			},
			Height = 10,
			Padding = 0,
			Complete = false,
			Enabled = true,
			ChildState = true,
			ID = TabRef.ID,
			Page = Page,
			Type = "Encounter",
			Rendered = LibSata:Create(),
		}
		Page.Side._root = Page.Side
		
		for ID, _function in pairs(Menu.Object) do
			Page.UI[ID] = function(Name, Settings, ID, Callback)
				return _function(Menu.Object, Name, Settings, ID, Callback, Page)
			end
			Page.Side.UI[ID] = function(Name, Settings, ID, Callback)
				return _function(Menu.Object, Name, Settings, ID, Callback, Page.Side)
			end
		end

		function Page:Pad(Spacer)
			self.Padding = self.Padding + Spacer
		end
		function Page.Side:Pad(Spacer)
			self.Padding = self.Padding + Spacer
		end

		function Page:LinkY(Object)
			if self.LastObject then
				self.LastObject:LinkY(Object, 10)
			else
				Object:SetPoint("TOP", self.UI.Cradle, "TOP")
			end			
		end
		function Page.Side:LinkY(Object)
			if self.LastObject then
				self.LastObject:LinkY(Object, 10)
			else
				Object:SetPoint("TOP", self.UI.Cradle, "TOP")
			end					
		end
		
		function Page:LinkX(Object)
			Object:SetPoint("LEFT", self.UI.Cradle, "LEFT")			
		end
		function Page.Side:LinkX(Object)
			Object:SetPoint("LEFT", self.UI.Cradle, "LEFT")					
		end
				
		function Page:Open()
			if self.Encounter.Selected then
				if self.Encounter.Selected ~= self then
					self.Encounter.Selected:Close()
				end
			end
			self.Encounter.Selected = self
			self.UI.Content:SetVisible(true)
			self.Active = true
			if self.Complete then
				Menu.PageUI.Main:SetContentHeight(self.Height + self.Padding)
				if self.ID == "Records" then
					self.Encounter:ApplyRecords()
				end
				if self.Encounter.TabStore[self.ID].ScrollPos then
					Menu.PageUI.Main.Scrollbar:SetPosition(self.Encounter.TabStore[self.ID].ScrollPos)
				end
			end
			self.Encounter:SetStyle()
			self.Side.UI.Content:SetVisible(true)
		end
		
		function Page:Close()
			self.UI.Content:SetVisible(false)
			self.Side.UI.Content:SetVisible(false)
			self.Active = false
			self.Encounter.TabStore[Page.ID].ScrollPos = Menu.PageUI.Main.Scrollbar:GetPosition()
		end
		
		function Page:Remove()
			self.Selected = nil
			self.Side:Remove()
			self.Complete = false
			self.Height = 10
			self.Padding = 0
			for _, RemoveObj in LibSata.EachIn(self.Rendered) do
				RemoveObj:Remove()
			end
			self.Rendered:Clear()
			self.LastObject = nil
			for _, Object in LibSata.EachIn(self.Object) do
				Object:Clear()
			end
			self.Object:Clear()
			self.Tab:Disable()
			self.Encounter = nil
			self.Mod = nil
			if self.Active then
				Menu.PageUI.Main:SetContentHeight(self.Height)
			end
			self.Active = false
		end
		
		function Page.Side:Remove()
			self.Complete = false
			self.Height = 10
			self.Padding = 0
			for _, RemoveObj in LibSata.EachIn(self.Rendered) do
				RemoveObj:Remove()
			end
			self.Rendered:Clear()
			self.LastObject = nil
			for _, Object in LibSata.EachIn(self.Object) do
				Object:Clear()
			end
			self.Object:Clear()
			if self.Page.Active then
				Menu.PageUI.Side:SetContentHeight(self.Height)
			end
			self.Active = false
		end
		
		function Page:Displayed()
			self.Complete = true
			if self.Active then
				Menu.PageUI.Main:SetContentHeight(self.Height + self.Padding)
				if self.ID == "Records" then
					self.Encounter:ApplyRecords()
				end
				if self.Encounter.TabStore[self.ID].ScrollPos then
					Menu.PageUI.Main.Scrollbar:SetPosition(self.Encounter.TabStore[self.ID].ScrollPos)
				end
			end
		end
		
		function Page:Render(Encounter)
			self.Encounter = Encounter
			self.Mod = Encounter.Mod
			Build[self.ID](self)
			Menu.Queue.PageEnd(self)
		end
		Instance.Page[TabRef.ID] = Page
	end
end

function Build:Encounter()
	local Page = self
	Page.Layout = {}
	
	function Page.Layout:EncTimer()	
		local Callbacks = {}
	
		-- Encounter Timer callbacks
		function Callbacks:Override(bool)
			self.Mod.Settings.EncTimer.Override = bool
			if bool then
				KBM.EncTimer.Settings = self.Mod.Settings.EncTimer
			else
				KBM.EncTimer.Settings = KBM.Options.EncTimer
			end
			KBM.EncTimer:ApplySettings()
		end
		
		function Callbacks:Enabled(bool)
			self.Mod.Settings.EncTimer.Enabled = bool
		end
		
		function Callbacks:Visible(bool)
			self.Mod.Settings.EncTimer.Visible = bool
			self.Mod.Settings.EncTimer.Unlocked = bool
			KBM.EncTimer.Frame:SetVisible(bool)
			KBM.EncTimer.Enrage.Frame:SetVisible(bool)
			KBM.EncTimer.Frame.Drag:SetVisible(bool)
		end
		
		function Callbacks:ScaleWidth(bool)
			self.Mod.Settings.EncTimer.ScaleWidth = bool
		end
		
		function Callbacks:ScaleHeight(bool)
			self.Mod.Settings.EncTimer.ScaleHeight = bool
		end
		
		function Callbacks:TextScale(bool)
			self.Mod.Settings.EncTimer.TextScale = bool
		end
	
		if self.Mod.Settings.EncTimer then
			self.Tab:Enable()
			local Settings = self.Mod.Settings.EncTimer
			local Header = self.UI.CreateHeader(KBM.Language.Options.EncTimerOverride[KBM.Lang], Settings, "Override", Callbacks)
			Header:CreateCheck(KBM.Language.Options.Enabled[KBM.Lang], Settings, "Enabled", Callbacks)
			Header:CreateCheck(KBM.Language.Options.ShowAnchor[KBM.Lang],Settings, "Visible", Callbacks)
			Header:CreateCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], Settings, "ScaleWidth", Callbacks)
			Header:CreateCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], Settings, "ScaleHeight", Callbacks)
			Header:CreateCheck(KBM.Language.Options.UnlockText[KBM.Lang], Settings, "TextScale", Callbacks)
		end
	end

	function Page.Layout:PhaseMon()			
		local Callbacks = {}
		
		-- Phase Monitor Callbacks.
		function Callbacks:Override(bool)
			self.Mod.Settings.PhaseMon.Override = bool
			if bool then
				KBM.PhaseMonitor.Settings = self.Mod.Settings.PhaseMon
			else
				KBM.PhaseMonitor.Settings = KBM.Options.PhaseMon
			end
			KBM.PhaseMonitor:ApplySettings()				
		end
		
		function Callbacks:Enabled(bool)
			self.Mod.Settings.PhaseMon.Enabled = bool
		end
		
		function Callbacks:Visible(bool)
			self.Mod.Settings.PhaseMon.Visible = bool
			KBM.PhaseMonitor.Anchor:SetVisible(bool)
			self.Mod.Settings.PhaseMon.Unlocked = bool
			KBM.PhaseMonitor.Anchor.Drag:SetVisible(bool)
		end
		
		function Callbacks:Phase(bool)
			self.Mod.Settings.PhaseMon.PhaseDisplay = bool
		end
		
		function Callbacks:Objectives(bool)
			self.Mod.Settings.PhaseMon.Objectives = bool
		end
		
		function Callbacks:ScaleWidth(bool)
			self.Mod.Settings.PhaseMon.ScaleWidth = bool
		end
		
		function Callbacks:ScaleHeight(bool)
			self.Mod.Settings.PhaseMon.ScaleHeight = bool
		end
		
		function Callbacks:TextScale(bool)
			self.Mod.Settings.PhaseMon.TextScale = bool
		end
				
		if self.Mod.Settings.PhaseMon then
			self.Tab:Enable()
			local Settings = self.Mod.Settings.PhaseMon
			local Header = self.UI.CreateHeader(KBM.Language.Options.PhaseMonOverride[KBM.Lang], Settings, "Override", Callbacks)
			Header:CreateCheck(KBM.Language.Options.Enabled[KBM.Lang], Settings, "Enabled", Callbacks)
			Header:CreateCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], Settings, "Visible", Callbacks)
			Header:CreateCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], Settings, "ScaleWidth", Callbacks)
			Header:CreateCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], Settings, "ScaleHeight", Callbacks)
			Header:CreateCheck(KBM.Language.Options.UnlockText[KBM.Lang], Settings, "TextScale", Callbacks)
		end
	end
	
	Page.Layout.EncTimer(Page)
	Page.Layout.PhaseMon(Page)
end

function Build:Timers()
	local Page = self
	Page.Layout = {}
	
	function Page.Layout:MechTimer()
		local Callbacks = {}
	
		-- Mechanic Timer and Mech Spy callbacks
		function Callbacks:Override(bool)
			self.Mod.Settings.MechTimer.Override = bool
			if bool then
				KBM.MechTimer.Settings = self.Mod.Settings.MechTimer
			else
				KBM.MechTimer.Settings = KBM.Options.MechTimer
			end
			KBM.MechTimer:ApplySettings()
		end
		
		function Callbacks:Visible(bool)
			self.Mod.Settings.MechTimer.Visible = bool
			self.Mod.Settings.MechTimer.Unlocked = bool
			KBM.MechTimer.Anchor:SetVisible(bool)
			KBM.MechTimer.Anchor.Drag:SetVisible(bool)
		end
				
		function Callbacks:Enabled(bool)
			self.Mod.Settings.MechTimer.Enabled = bool
		end

		function Callbacks:ScaleWidth(bool)
			self.Mod.Settings.MechTimer.ScaleWidth = bool
		end
		
		function Callbacks:ScaleHeight(bool)
			self.Mod.Settings.MechTimer.ScaleHeight = bool
		end
		
		function Callbacks:TextScale(bool)
			self.Mod.Settings.MechTimer.TextScale = bool
		end
		
		if self.Mod.Settings.MechTimer then
			self.Tab:Enable()
			local Settings = self.Mod.Settings.MechTimer
			local Header = self.UI.CreateHeader(KBM.Language.Options.MechTimerOverride[KBM.Lang], Settings, "Override", Callbacks)
			Header:CreateCheck(KBM.Language.Options.Enabled[KBM.Lang], Settings, "Enabled", Callbacks)
			Header:CreateCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], Settings, "Visible", Callbacks)
			Header:CreateCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], Settings, "ScaleWidth", Callbacks)
			Header:CreateCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], Settings, "ScaleHeight", Callbacks)
			Header:CreateCheck(KBM.Language.Options.UnlockText[KBM.Lang], Settings, "TextScale", Callbacks)
			
			for BossName, BossObj in pairs(self.Mod.Bosses) do
				if BossObj.Settings then
					local Settings = BossObj.Settings.TimersRef
					if Settings then
						local Callbacks = {}
						
						function Callbacks:Enabled(bool)
							Settings.Enabled = bool
							KBM.SetBossTimers(BossObj, bool)
						end
						
						if BossObj.NameShort then
							BossName = BossObj.NameShort
						end
						
						local Header = self.UI.CreateHeader(KBM.Language.Options.TimersEnabled[KBM.Lang].." ("..tostring(BossName)..")", Settings, "Enabled", Callbacks)
						for TimerID, TimerObj in pairs(BossObj.TimersRef) do
							if TimerObj.HasMenu then
								local Callbacks = {}
								local TimerSettings = Settings[TimerID]
								
								function Callbacks:Enabled(bool)
									TimerSettings.Enabled = bool
									TimerObj.Enabled = bool
									if TimerObj.Linked then
										for _, SlaveTimer in pairs(TimerObj.Linked) do
											SlaveTimer.Enabled = bool
											SlaveTimer.Settings.Enabled = bool
										end
									end
								end
								
								function Callbacks:Select()
									local SideCallbacks = {}
									
									function SideCallbacks:Enabled(bool)
										TimerSettings.Enabled = bool
										TimerObj.Enabled = bool
										if TimerObj.Linked then
											for _, SlaveTimer in pairs(TimerObj.Linked) do
												SlaveTimer.Enabled = bool
												SlaveTimer.Settings.Enabled = bool
											end
										end
									end
									
									function SideCallbacks:Color(bool, Color)
										if not Color then
											TimerSettings.Custom = bool
											local setColor = TimerObj.Default_Color
											if bool then
												setColor = TimerSettings.Color
											end
											TimerObj.Color = setColor
											if TimerObj.Linked then
												for _, SlaveTimer in pairs(TimerObj.Linked) do
													SlaveTimer.Color = setColor
												end
											end
										elseif Color then
											TimerSettings.Color = Color
											TimerObj.Color = Color
											if TimerObj.Linked then
												for _, SlaveTimer in pairs(TimerObj.Linked) do
													SlaveTimer.Color = Color
													SlaveTimer.Settings.Color = Color
												end
											end
										end																										
									end
									
									local SubHeader = self.Side.UI.CreatePlainHeader(TimerObj.MenuName or TimerObj.Name, nil, "SubTitle", nil)
									SubHeader:CreateColorPicker("Color", TimerObj, "Color", SideCallbacks)
								end
							
								local Child = Header:CreateCheck(TimerObj.MenuName or TimerObj.Name, TimerSettings, "Enabled", Callbacks)
								Child:SetPage(self.Side, Callbacks)
							end
						end
					end
				end
			end
		end
	end
	
	function Page.Layout:MechSpy()
		local Callbacks = {}
	
		function Callbacks:Override(bool)
			self.Mod.Settings.MechSpy.Override = bool
			if bool then
				KBM.MechSpy.Settings = self.Mod.Settings.MechSpy
			else
				KBM.MechSpy.Settings = KBM.Options.MechSpy
			end
			KBM.MechSpy:ApplySettings()
		end
		
		function Callbacks:Visible(bool)
			self.Mod.Settings.MechSpy.Visible = bool
			self.Mod.Settings.MechSpy.Unlocked = bool
			KBM.MechSpy.Anchor:SetVisible(bool)
			KBM.MechSpy.Anchor.Drag:SetVisible(bool)
		end
		
		function Callbacks:Enabled(bool)
			self.Mod.Settings.MechSpy.Enabled = bool
		end

		function Callbacks:ScaleWidth(bool)
			self.Mod.Settings.MechSpy.ScaleWidth = bool
		end
		
		function Callbacks:ScaleHeight(bool)
			self.Mod.Settings.MechSpy.ScaleHeight = bool
		end
		
		function Callbacks:ScaleText(bool)
			self.Mod.Settings.MechSpy.ScaleText = bool
		end
	
		if self.Mod.Settings.MechSpy then
			self.Tab:Enable()
			local Settings = self.Mod.Settings.MechSpy
			local Header = self.UI.CreateHeader(KBM.Language.MechSpy.Override[KBM.Lang], Settings, "Override", Callbacks)
			Header:CreateCheck(KBM.Language.Options.Enabled[KBM.Lang], Settings, "Enabled", Callbacks)
			Header:CreateCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], Settings, "Visible", Callbacks)
			Header:CreateCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], Settings, "ScaleWidth", Callbacks)
			Header:CreateCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], Settings, "ScaleHeight", Callbacks)
			Header:CreateCheck(KBM.Language.Options.UnlockText[KBM.Lang], Settings, "ScaleText", Callbacks)
			
			for BossName, BossObj in pairs(self.Mod.Bosses) do
				if BossObj.Settings then
					local Settings = BossObj.Settings.MechRef
					if Settings then
						local Callbacks = {}
						
						function Callbacks:Enabled(bool)
							Settings.Enabled = bool
							KBM.SetBossSpies(BossObj, bool)
						end
						
						BossName = BossObj.NameShort or BossName
						
						local Header = self.UI.CreateHeader(KBM.Language.MechSpy.Enabled[KBM.Lang].." ("..tostring(BossName)..")", Settings, "Enabled", Callbacks)
						for SpyID, SpyObj in pairs(BossObj.MechRef) do
							if SpyObj.HasMenu then
								local Callbacks = {}
								local SpySettings = Settings[SpyID]
								
								function Callbacks:Enabled(bool)
									SpySettings.Enabled = bool
									SpyObj.Enabled = bool
									if SpyObj.Linked then
										for _, SlaveSpy in pairs(SpyObj.Linked) do
											SlaveSpy.Enabled = bool
											SlaveSpy.Settings.Enabled = bool
										end
									end
								end
								
								function Callbacks:Select()
									local SideCallbacks = {}
									
									function SideCallbacks:Enabled(bool)
										SpySettings.Enabled = bool
										SpyObj.Enabled = bool
										if SpyObj.Linked then
											for _, SlaveSpy in pairs(SpyObj.Linked) do
												SlaveSpy.Enabled = bool
												SlaveSpy.Settings.Enabled = bool
											end
										end
									end
									
									function SideCallbacks:Color(bool, Color)
										if not Color then
											SpySettings.Custom = bool
											local setColor = SpyObj.Default_Color
											if bool then
												setColor = SpySettings.Color
											end
											SpyObj.Color = setColor
											if SpyObj.Linked then
												for _, SlaveSpy in pairs(SpyObj.Linked) do
													SlaveSpy.Color = setColor
												end
											end
										elseif Color then
											SpySettings.Color = Color
											SpyObj.Color = Color
											if SpyObj.Linked then
												for _, SlaveSpy in pairs(SpyObj.Linked) do
													SlaveSpy.Color = Color
													SlaveSpy.Settings.Color = Color
												end
											end
										end																										
									end
									
									local SubHeader = self.Side.UI.CreatePlainHeader(SpyObj.MenuName or SpyObj.Name, nil, "SubTitle", nil)
									SubHeader:CreateColorPicker("Color", SpyObj, "Color", SideCallbacks)
								end
							
								local Child = Header:CreateCheck(SpyObj.MenuName or SpyObj.Name, SpySettings, "Enabled", Callbacks)
								Child:SetPage(self.Side)
							end
						end
					end
				end
			end
		end
	end
	
	Page.Layout.MechTimer(Page)
	Page.Layout.MechSpy(Page)
end

function Build:Alerts()
	local Page = self
	Page.Layout = {}
	
	function Page.Layout:Alerts()
		local Callbacks = {}
				
		-- Alert callbacks
		function Callbacks:Override(bool)
			self.Mod.Settings.Alerts.Override = bool
			if bool then
				KBM.Alert.Settings = self.Mod.Settings.Alerts
			else
				KBM.Alert.Settings = KBM.Options.Alerts
			end
			KBM.Alert:ApplySettings()
		end
		
		function Callbacks:Enabled(bool)
			self.Mod.Settings.Alerts.Enabled = bool
		end
		
		function Callbacks:Flash(bool)
			self.Mod.Settings.Alerts.Flash = bool
			KBM.Alert:ApplySettings()
		end
		
		function Callbacks:Vertical(bool)
			self.Mod.Settings.Alerts.Vertical = bool
			KBM.Alert:ApplySettings()
		end
		
		function Callbacks:Horizontal(bool)
			self.Mod.Settings.Alerts.Horizontal = bool
			KBM.Alert:ApplySettings()
		end
		
		function Callbacks:Notify(bool)
			self.Mod.Settings.Alerts.Text = bool
		end
		
		function Callbacks:Visible(bool)
			self.Mod.Settings.Alerts.Visible = bool
			self.Mod.Settings.Alerts.Unlocked = bool
			KBM.Alert.Anchor:SetVisible(bool)
			KBM.Alert.Anchor.Drag:SetVisible(bool)
			KBM.Alert:ApplySettings()
		end
		
		function Callbacks:ScaleText(bool)
			self.Mod.Settings.Alerts.ScaleText = bool
		end
		
		function Callbacks:FlashUnlocked(bool)
			self.Mod.Settings.Alerts.FlashUnlocked = bool
			KBM.Alert:ApplySettings()
		end
					
		if self.Mod.Settings.Alerts then
			self.Tab:Enable()
			local Settings = self.Mod.Settings.Alerts
			local Header = self.UI.CreateHeader(KBM.Language.Options.AlertsOverride[KBM.Lang], Settings, "Override", Callbacks)
			Header:CreateCheck(KBM.Language.Options.Enabled[KBM.Lang], Settings, "Enabled", Callbacks)
			Header:CreateCheck(KBM.Language.Options.AlertText[KBM.Lang], Settings, "Notify", Callbacks)
			Header:CreateCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], Settings, "Visible", Callbacks)
			Header:CreateCheck(KBM.Language.Options.UnlockText[KBM.Lang], Settings, "ScaleText", Callbacks)
			Header:CreateCheck(KBM.Language.Options.UnlockFlash[KBM.Lang], Settings, "FlashUnlocked", Callbacks)
			local HeaderBar = Header:CreateHeader(KBM.Language.Options.AlertFlash[KBM.Lang], Settings, "Flash", Callbacks)
			HeaderBar:CreateCheck(KBM.Language.Options.AlertVert[KBM.Lang], Settings, "Vertical", Callbacks)
			HeaderBar:CreateCheck(KBM.Language.Options.AlertHorz[KBM.Lang], Settings, "Horizontal", Callbacks)
			
			for BossName, BossObj in pairs(self.Mod.Bosses) do
				if BossObj.Settings then
					local Settings = BossObj.Settings.AlertsRef
					if Settings then
						local Callbacks = {}
						
						function Callbacks:Enabled(bool)
							Settings.Enabled = bool
							KBM.SetBossAlerts(BossObj, bool)
						end
						
						BossName = BossObj.NameShort or BossName
						
						local Header = self.UI.CreateHeader(KBM.Language.Options.AlertsEnabled[KBM.Lang].." ("..tostring(BossName)..")", Settings, "Enabled", Callbacks)
						for AlertID, AlertObj in pairs(BossObj.AlertsRef) do
							if AlertObj.HasMenu then
								local Callbacks = {}
								local AlertSettings = Settings[AlertID]
								
								function Callbacks:Enabled(bool)
									AlertSettings.Enabled = bool
									AlertObj.Enabled = bool
									if AlertObj.Linked then
										for _, SlaveAlert in pairs(AlertObj.Linked) do
											SlaveAlert.Enabled = bool
											SlaveAlert.Settings.Enabled = bool
										end
									end
								end
								
								function Callbacks:Select()
									local SideCallbacks = {}
									
									function SideCallbacks:Enabled(bool)
										AlertSettings.Enabled = bool
										AlertObj.Enabled = bool
										if AlertObj.Linked then
											for _, SlaveAlert in pairs(AlertObj.Linked) do
												SlaveAlert.Enabled = bool
												SlaveAlert.Settings.Enabled = bool
											end
										end
									end
									
									function SideCallbacks:Border(bool)
										AlertSettings.Border = bool
										if AlertObj.Linked then
											for _, SlaveAlert in pairs(AlertObj.Linked) do
												SlaveAlert.Settings.Border = bool
											end
										end
									end
																	
									function SideCallbacks:Notify(bool)
										AlertSettings.Notify = bool
										if AlertObj.Linked then
											for _, SlaveAlert in pairs(AlertObj.Linked) do
												SlaveAlert.Settings.Notify = bool
											end
										end
									end
									
									function SideCallbacks:Sound(bool)
										AlertSettings.Sound = bool
										if AlertObj.Linked then
											for _, SlaveAlert in pairs(AlertObj.Linked) do
												SlaveAlert.Settings.Sound = bool
											end
										end
									end
									
									function SideCallbacks:Color(bool, Color)							
										if not Color then
											AlertSettings.Custom = bool
											local setColor = AlertObj.Default_Color
											if bool then
												setColor = AlertSettings.Color
											end
											AlertObj.Color = setColor
											if AlertObj.Linked then
												for _, SlaveAlert in pairs(AlertObj.Linked) do
													SlaveAlert.Color = setColor
												end
											end
										elseif Color then
											AlertSettings.Color = Color
											AlertObj.Color = Color
											if AlertObj.Linked then
												for _, SlaveAlert in pairs(AlertObj.Linked) do
													SlaveAlert.Color = Color
													SlaveAlert.Settings.Color = Color
												end
											end
										end																										
									end
								
									local SubHeader = self.Side.UI.CreatePlainHeader(AlertObj.MenuName or AlertObj.Text, nil, "SubTitle", nil)
									SubHeader:CreateCheck(KBM.Language.Options.Border[KBM.Lang], AlertSettings, "Border", SideCallbacks)
									SubHeader:CreateCheck(KBM.Language.Options.Notify[KBM.Lang], AlertSettings, "Notify", SideCallbacks)
									local Sound = SubHeader:CreateCheck(KBM.Language.Options.Sound[KBM.Lang], AlertSettings, "Sound", SideCallbacks)
									Sound.Enabled = false
									SubHeader:CreateColorPicker("Color", AlertObj, "Color", SideCallbacks)
								end
							
								local Child = Header:CreateCheck(AlertObj.MenuName or AlertObj.Text, AlertSettings, "Enabled", Callbacks)
								Child:SetPage(self.Side)
							end
						end
					end					
				end
			end
		end
	end
	
	function Page.Layout:Chat()
		local Callbacks = {}
		
		-- Chat Options
		for BossName, BossObj in pairs(self.Mod.Bosses) do
			if BossObj.Settings then
				local Settings = BossObj.Settings.ChatRef
				if Settings then
					self.Tab:Enable()
					local Callbacks = {}
					
					function Callbacks:Enabled(bool)
						Settings.Enabled = bool
						KBM.SetBossChat(BossObj, bool)
					end
					
					BossName = BossObj.NameShort or BossName
					
					local Header = self.UI.CreateHeader(KBM.Language.Chat.Enabled[KBM.Lang].." ("..tostring(BossName)..")", Settings, "Enabled", Callbacks)
					for ChatID, ChatObj in pairs(BossObj.ChatRef) do
						if ChatObj.HasMenu then
							local Callbacks = {}
							local ChatSettings = Settings[ChatID]
							
							function Callbacks:Enabled(bool)
								ChatSettings.Enabled = bool
							end
							
							function Callbacks:Select()
								local SideCallbacks = {}
								
								function SideCallbacks:Enabled(bool)
									ChatSettings.Enabled = bool
									ChatObj.Enabled = bool
								end
								
								local SubHeader = self.Side.UI.CreatePlainHeader(ChatObj.MenuName or ChatObj.Text, nil, "SubTitle", nil)
								SubHeader:CreateCheck(KBM.Language.Options.Enabled[KBM.Lang], ChatSettings, "Enabled", SideCallbacks)
							end
						
							local Child = Header:CreateCheck(ChatObj.MenuName or ChatObj.Text, ChatSettings, "Enabled", Callbacks)
							Child:SetPage(self.Side)
						end
					end
				end					
			end
		end
	end
	
	Page.Layout.Alerts(Page)
	Page.Layout.Chat(Page)
end

function Build:Records()
	local Page = self
	Page.Layout = {}
	self.Tab:Enable()
	
	function Page.Layout:Records()
		local Callbacks = {}
		if not self.Mod.MenuStore then
			self.Mod.MenuStore = {}
		end
		self.Mod.MenuStore.Records = {}
		
		local Settings = self.Mod.Settings.Records
		local Header = self.UI.CreateHeader(KBM.Language.Records.Best[KBM.Lang], nil, "Records", nil)
		self.Mod.MenuStore.Records.Best = Header:CreateCheck("n/a", nil, "Best", nil)
		self.Mod.MenuStore.Records.Date = Header:CreateCheck(KBM.Language.Records.Date[KBM.Lang].."n/a", nil, "Date", nil)
		local Header = self.UI.CreateHeader(KBM.Language.Records.Details[KBM.Lang], nil, "Details", nil)
		self.Mod.MenuStore.Records.Attempts = Header:CreateCheck(KBM.Language.Records.Attempts[KBM.Lang]..Settings.Attempts, nil, "Attempts", nil)
		self.Mod.MenuStore.Records.Kills = Header:CreateCheck(KBM.Language.Records.Kills[KBM.Lang]..Settings.Kills, nil, "Kills", nil)
		self.Mod.MenuStore.Records.Wipes = Header:CreateCheck(KBM.Language.Records.Wipes[KBM.Lang]..Settings.Wipes, nil, "Wipes", nil)
		self.Mod.MenuStore.Records.Rate = Header:CreateCheck(KBM.Language.Records.Rate[KBM.Lang].."n/a", nil, "Rate", nil)
	end
	
	Page.Layout.Records(Page)
end

function Build:Castbars()
	local Page = self
	Page.Layout = {}
	
	function Page.Layout:CastBar()
		if self.Mod.HasCastbars then
			for BossName, Boss in pairs(self.Mod.Bosses) do
				if Boss.CastBar then
					local Settings = Boss.CastBar.Settings
					local BossSettings = Boss.CastBar.BossSettings
					local GlobalSettings = KBM.Options.Castbar.Global
					if Settings then
						local Callbacks = {}
						function Callbacks:override(bool)
							-- print("<< MENU >> "..Boss.Name.." Override")
							BossSettings.override = bool
							if bool then
								if BossSettings.custom then
									-- print("<< MENU >> Local Settings")
									Boss.CastBar.Settings = BossSettings
									-- print("<< MENU >> calling :Hide()")
									-- Boss.CastBar:Hide()
									-- print("<< MENU >> Removing from Anchor")									
									Boss.CastBar.CastObj:SettingsTable(Boss.CastBar.Settings)
									KBM.Castbar.Anchor:RemoveBar(Boss.CastBar.CastObj)
								else
									--print("<< MENU >> Global Settings")
									Boss.CastBar.Settings = GlobalSettings
									Boss.CastBar.CastObj:SettingsTable(Boss.CastBar.Settings)
								end
								--print("<< MENU >> calling :Enabled()")
								Boss.CastBar.CastObj:Enable(BossSettings.enabled)
							else
							--	print("<< MENU >> Global Settings")
								Boss.CastBar.Settings = GlobalSettings
								if BossSettings.custom then
									-- print("<< MENU >> calling :Hide()")
									-- Boss.CastBar:Hide()
									-- print("<< MENU >> Adding to Anchor")									
									Boss.CastBar.CastObj:SettingsTable(Boss.CastBar.Settings)
									KBM.Castbar.Anchor:AddBar(Boss.CastBar.CastObj)
								end
								-- print("<< MENU >> calling :Enabled()")
								Boss.CastBar.CastObj:Enable(GlobalSettings.enabled)
							end
							
							Settings = Boss.CastBar.Settings
						--	print("<< MENU >> calling :Display()")
							Boss.CastBar:Display()
						end
						
						function Callbacks:enabled(bool)
							BossSettings.enabled = bool
							Boss.CastBar.CastObj:Enable(bool)
							Boss.CastBar:Display()
						end
						
						function Callbacks:custom(bool)
							BossSettings.custom = bool
							if bool then
								Boss.CastBar.Settings = BossSettings
								Boss.CastBar.CastObj:SettingsTable(Boss.CastBar.Settings)
								KBM.Castbar.Anchor:RemoveBar(Boss.CastBar.CastObj)
							else
								Boss.CastBar.Settings = GlobalSettings
								Boss.CastBar.CastObj:SettingsTable(Boss.CastBar.Settings)
								KBM.Castbar.Anchor:AddBar(Boss.CastBar.CastObj)
							end
							Settings = Boss.CastBar.Settings
							Boss.CastBar:Display()
						end
						
						-- function Callbacks:Pinned(bool)
							-- self.Mod.Settings.CastBar.Pinned = bool
							-- Boss.CastBar:Hide()
							-- Boss.CastBar:Display()
						-- end
						
						function Callbacks:visible(bool)
							Boss.CastBar:Hide()
							BossSettings.visible = bool
							BossSettings.unlocked = bool
							Boss.CastBar.CastObj:Unlocked(bool)
							Boss.CastBar:Display()
						end
						
						function Callbacks:widthUnlocked(bool)
							BossSettings.scale.widthUnlocked = bool
						end
						
						function Callbacks:heightUnlocked(bool)
							BossSettings.scale.heightUnlocked = bool
						end
						
						-- function Callbacks:TextScale(bool)
							-- self.Mod.Settings.CastBar.TextScale = bool
						-- end
						
						--local Header = self.UI.CreateHeader(KBM.Language.Options.CastbarOverride[KBM.Lang], Settings, "pinned", Callbacks)
						local Header = self.UI.CreateHeader(string.format(KBM.Language.Options.CastbarOverride[KBM.Lang], BossName), BossSettings, "override", Callbacks)
						local SubHeader = Header:CreateCheck(KBM.Language.Options.Enabled[KBM.Lang], BossSettings, "enabled", Callbacks)
						local Custom = SubHeader:CreateCheck(KBM.Language.CastBar.Custom[KBM.Lang], BossSettings, "custom", Callbacks)
						-- if Boss.PinCastBar then
							-- Header:CreateOption(BossObj.Settings.PinMenu, Settings, "Pinned", Callbacks)
						-- end
						Custom:CreateCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], BossSettings, "visible", Callbacks)
						Custom:CreateCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], BossSettings.scale, "widthUnlocked", Callbacks)
						Custom:CreateCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], BossSettings.scale, "heightUnlocked", Callbacks)
						-- Header:CreateCheck(KBM.Language.Options.UnlockText[KBM.Lang], Settings, "TextScale", Callbacks)
					end
				end
			end
			if self.Mod.HasCastbars then
				self.Tab:Enable()
			else
				self.Tab:Disable()
			end
		end
	end
	
	Page.Layout.CastBar(Page)
end

function Build:Triggers()
	local Triggers = {}
	return Triggers
end

function Instance._tabEventHandler(Tabber, Tab)
	if Tab.UserData then
		Tab.UserData._function:Open()
	end
end