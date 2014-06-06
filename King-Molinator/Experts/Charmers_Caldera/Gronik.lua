﻿-- Gronik Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXCCGK_Settings = nil
chKBMEXCCGK_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Charmer's Caldera"]

local MOD = {
	Directory = Instance.Directory,
	File = "Gronik.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Gronik",
	Object = "MOD",
}

MOD.Gronik = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Gronik",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	UTID = "U4AAB6A5512038E1D",
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
MOD.Lang.Unit.Gronik = KBM.Language:Add(MOD.Gronik.Name)
MOD.Lang.Unit.Gronik:SetGerman()
MOD.Lang.Unit.Gronik:SetFrench()
MOD.Lang.Unit.Gronik:SetRussian("Гроник")
MOD.Lang.Unit.Gronik:SetKorean("그로니크")
MOD.Gronik.Name = MOD.Lang.Unit.Gronik[KBM.Lang]
MOD.Descript = MOD.Gronik.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Gronik.Name] = self.Gronik,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Gronik.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Gronik.Settings.TimersRef,
		-- AlertsRef = self.Gronik.Settings.AlertsRef,
	}
	KBMEXCCGK_Settings = self.Settings
	chKBMEXCCGK_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXCCGK_Settings = self.Settings
		self.Settings = chKBMEXCCGK_Settings
	else
		chKBMEXCCGK_Settings = self.Settings
		self.Settings = KBMEXCCGK_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXCCGK_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXCCGK_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXCCGK_Settings = self.Settings
	else
		KBMEXCCGK_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXCCGK_Settings = self.Settings
	else
		KBMEXCCGK_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Gronik.UnitID == UnitID then
		self.Gronik.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Gronik.UnitID == UnitID then
		self.Gronik.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Gronik.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Gronik.Dead = false
					self.Gronik.Casting = false
					self.Gronik.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Gronik.Name, 0, 100)
					self.Phase = 1
				end
				self.Gronik.UnitID = unitID
				self.Gronik.Available = true
				return self.Gronik
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Gronik.Available = false
	self.Gronik.UnitID = nil
	self.Gronik.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Gronik)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Gronik)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Gronik.CastBar = KBM.Castbar:Add(self, self.Gronik)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end