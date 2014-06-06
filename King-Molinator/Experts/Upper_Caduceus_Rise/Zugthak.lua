﻿-- Zugthak Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXUCRZK_Settings = nil
chKBMEXUCRZK_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Upper Caduceus Rise"]

local MOD = {
	Directory = Instance.Directory,
	File = "Zugthak.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Zugthak",
	Object = "MOD",
}

MOD.Zugthak = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = "Zugthak",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	UTID = "U4E148FF15BE6106E",
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		-- TimersRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.TimerObj.Create("red"),
		-- },
		-- AlertsRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.AlertObj.Create("red"),
		-- },
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Zugthak = KBM.Language:Add(MOD.Zugthak.Name)
MOD.Lang.Unit.Zugthak:SetGerman("Zugthak")
MOD.Lang.Unit.Zugthak:SetFrench("Zugthak")
MOD.Lang.Unit.Zugthak:SetRussian("Загтак")
MOD.Lang.Unit.Zugthak:SetKorean("주그타크")
MOD.Zugthak.Name = MOD.Lang.Unit.Zugthak[KBM.Lang]
MOD.Descript = MOD.Zugthak.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Zugthak.Name] = self.Zugthak,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Zugthak.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Zugthak.Settings.TimersRef,
		-- AlertsRef = self.Zugthak.Settings.AlertsRef,
	}
	KBMEXUCRZK_Settings = self.Settings
	chKBMEXUCRZK_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXUCRZK_Settings = self.Settings
		self.Settings = chKBMEXUCRZK_Settings
	else
		chKBMEXUCRZK_Settings = self.Settings
		self.Settings = KBMEXUCRZK_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXUCRZK_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXUCRZK_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXUCRZK_Settings = self.Settings
	else
		KBMEXUCRZK_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXUCRZK_Settings = self.Settings
	else
		KBMEXUCRZK_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Zugthak.UnitID == UnitID then
		self.Zugthak.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Zugthak.UnitID == UnitID then
		self.Zugthak.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Zugthak.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Zugthak.Dead = false
					self.Zugthak.Casting = false
					self.Zugthak.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Zugthak.Name, 0, 100)
					self.Phase = 1
				end
				self.Zugthak.UnitID = unitID
				self.Zugthak.Available = true
				return self.Zugthak
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Zugthak.Available = false
	self.Zugthak.UnitID = nil
	self.Zugthak.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Zugthak:SetTimers(bool)	
	if bool then
		for TimerID, TimerObj in pairs(self.TimersRef) do
			TimerObj.Enabled = TimerObj.Settings.Enabled
		end
	else
		for TimerID, TimerObj in pairs(self.TimersRef) do
			TimerObj.Enabled = false
		end
	end
end

function MOD.Zugthak:SetAlerts(bool)
	if bool then
		for AlertID, AlertObj in pairs(self.AlertsRef) do
			AlertObj.Enabled = AlertObj.Settings.Enabled
		end
	else
		for AlertID, AlertObj in pairs(self.AlertsRef) do
			AlertObj.Enabled = false
		end
	end
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Zugthak)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Zugthak)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Zugthak.CastBar = KBM.Castbar:Add(self, self.Zugthak)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end