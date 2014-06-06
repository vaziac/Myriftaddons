﻿-- Loggodhan Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXROTFLN_Settings = nil
chKBMEXROTFLN_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["The Realm of the Fae"]

local MOD = {
	Directory = Instance.Directory,
	File = "Luggodhan.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Luggodhan",
	Object = "MOD",
}

MOD.Loggodhan = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Luggodhan",
	--NameShort = "Loggodhan",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	UTID = "U7A9F3EC2663A6774",
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
MOD.Lang.Unit.Loggodhan = KBM.Language:Add(MOD.Loggodhan.Name)
MOD.Lang.Unit.Loggodhan:SetGerman("Luggodhan")
MOD.Lang.Unit.Loggodhan:SetFrench("Luggodhan")
MOD.Lang.Unit.Loggodhan:SetRussian("Луггодан")
MOD.Lang.Unit.Loggodhan:SetKorean("루고단")
MOD.Loggodhan.Name = MOD.Lang.Unit.Loggodhan[KBM.Lang]
MOD.Descript = MOD.Loggodhan.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Loggodhan.Name] = self.Loggodhan,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Loggodhan.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Loggodhan.Settings.TimersRef,
		-- AlertsRef = self.Loggodhan.Settings.AlertsRef,
	}
	KBMEXROTFLN_Settings = self.Settings
	chKBMEXROTFLN_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXROTFLN_Settings = self.Settings
		self.Settings = chKBMEXROTFLN_Settings
	else
		chKBMEXROTFLN_Settings = self.Settings
		self.Settings = KBMEXROTFLN_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXROTFLN_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXROTFLN_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXROTFLN_Settings = self.Settings
	else
		KBMEXROTFLN_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXROTFLN_Settings = self.Settings
	else
		KBMEXROTFLN_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Loggodhan.UnitID == UnitID then
		self.Loggodhan.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Loggodhan.UnitID == UnitID then
		self.Loggodhan.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Loggodhan.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Loggodhan.Dead = false
					self.Loggodhan.Casting = false
					self.Loggodhan.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Loggodhan.Name, 0, 100)
					self.Phase = 1
				end
				self.Loggodhan.UnitID = unitID
				self.Loggodhan.Available = true
				return self.Loggodhan
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Loggodhan.Available = false
	self.Loggodhan.UnitID = nil
	self.Loggodhan.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Loggodhan:SetTimers(bool)	
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

function MOD.Loggodhan:SetAlerts(bool)
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
	--KBM.Defaults.TimerObj.Assign(self.Loggodhan)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Loggodhan)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Loggodhan.CastBar = KBM.Castbar:Add(self, self.Loggodhan)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end