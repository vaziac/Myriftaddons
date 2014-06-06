﻿-- Telaphalon Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLEXSBPTEL_Settings = nil
chKBMSLEXSBPTEL_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["EStorm_Breaker_Protocol"]

local MOD = {
	Directory = Instance.Directory,
	File = "Telaphalon.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Ex_Telaphalon",
	Object = "MOD",
}

MOD.Telaphalon = {
	Mod = MOD,
	Level = "62",
	Active = false,
	Name = "Telaphalon",
	NameShort = "Telaphalon",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFFD3D7004348DBAD",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Telaphalon = KBM.Language:Add(MOD.Telaphalon.Name)
MOD.Lang.Unit.Telaphalon:SetGerman()
MOD.Lang.Unit.Telaphalon:SetFrench("Télaphalon")
MOD.Telaphalon.Name = MOD.Lang.Unit.Telaphalon[KBM.Lang]
MOD.Descript = MOD.Telaphalon.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Telaphalon")
MOD.Lang.Unit.AndShort:SetGerman()
MOD.Lang.Unit.AndShort:SetFrench("Télaphalon")
MOD.Telaphalon.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Telaphalon.Name] = self.Telaphalon,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Telaphalon.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Telaphalon.Settings.TimersRef,
		-- AlertsRef = self.Telaphalon.Settings.AlertsRef,
	}
	KBMSLEXSBPTEL_Settings = self.Settings
	chKBMSLEXSBPTEL_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLEXSBPTEL_Settings = self.Settings
		self.Settings = chKBMSLEXSBPTEL_Settings
	else
		chKBMSLEXSBPTEL_Settings = self.Settings
		self.Settings = KBMSLEXSBPTEL_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLEXSBPTEL_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLEXSBPTEL_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLEXSBPTEL_Settings = self.Settings
	else
		KBMSLEXSBPTEL_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLEXSBPTEL_Settings = self.Settings
	else
		KBMSLEXSBPTEL_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Telaphalon.UnitID == UnitID then
		self.Telaphalon.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Telaphalon.UnitID == UnitID then
		self.Telaphalon.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.type == self.Telaphalon.UTID then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Telaphalon.Dead = false
					self.Telaphalon.Casting = false
					self.Telaphalon.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Telaphalon.Name, 0, 100)
					self.Phase = 1
				end
				self.Telaphalon.UnitID = unitID
				self.Telaphalon.Available = true
				return self.Telaphalon
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Telaphalon.Available = false
	self.Telaphalon.UnitID = nil
	self.Telaphalon.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Telaphalon)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Telaphalon)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Telaphalon.CastBar = KBM.Castbar:Add(self, self.Telaphalon)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end