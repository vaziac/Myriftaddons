﻿-- Cyclorax Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXCCCX_Settings = nil
chKBMEXCCCX_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Charmer's Caldera"]

local MOD = {
	Directory = Instance.Directory,
	File = "Cyclorax.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Cyclorax",
	Object = "MOD",
}

MOD.Cyclorax = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Cyclorax",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	UTID = "U40AF94B15D2606D7",
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Cyclorax = KBM.Language:Add(MOD.Cyclorax.Name)
MOD.Lang.Unit.Cyclorax:SetGerman()
MOD.Lang.Unit.Cyclorax:SetFrench()
MOD.Lang.Unit.Cyclorax:SetRussian("Циклоракс")
MOD.Lang.Unit.Cyclorax:SetKorean("사이클로락스")
MOD.Cyclorax.Name = MOD.Lang.Unit.Cyclorax[KBM.Lang]
MOD.Descript = MOD.Cyclorax.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Cyclorax.Name] = self.Cyclorax,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Cyclorax.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Cyclorax.Settings.TimersRef,
		-- AlertsRef = self.Cyclorax.Settings.AlertsRef,
	}
	KBMEXCCCX_Settings = self.Settings
	chKBMEXCCCX_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXCCCX_Settings = self.Settings
		self.Settings = chKBMEXCCCX_Settings
	else
		chKBMEXCCCX_Settings = self.Settings
		self.Settings = KBMEXCCCX_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXCCCX_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXCCCX_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXCCCX_Settings = self.Settings
	else
		KBMEXCCCX_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXCCCX_Settings = self.Settings
	else
		KBMEXCCCX_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Cyclorax.UnitID == UnitID then
		self.Cyclorax.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Cyclorax.UnitID == UnitID then
		self.Cyclorax.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Cyclorax.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Cyclorax.Dead = false
					self.Cyclorax.Casting = false
					self.Cyclorax.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Cyclorax.Name, 0, 100)
					self.Phase = 1
				end
				self.Cyclorax.UnitID = unitID
				self.Cyclorax.Available = true
				return self.Cyclorax
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Cyclorax.Available = false
	self.Cyclorax.UnitID = nil
	self.Cyclorax.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Cyclorax)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Cyclorax)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Cyclorax.CastBar = KBM.Castbar:Add(self, self.Cyclorax)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end