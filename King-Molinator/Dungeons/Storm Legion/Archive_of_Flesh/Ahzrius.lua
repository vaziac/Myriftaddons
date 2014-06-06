﻿-- Ahzrius Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLNMAOFAHZ_Settings = nil
chKBMSLNMAOFAHZ_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Archive of Flesh"]

local MOD = {
	Directory = Instance.Directory,
	File = "Ahzrius.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Norm_Ahzrius",
	Object = "MOD",
}

MOD.Ahzrius = {
	Mod = MOD,
	Level = "59",
	Active = false,
	Name = "Ahzrius",
	NameShort = "Ahzrius",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFABA25291969FB5C",
	TimeOut = 5,
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
MOD.Lang.Unit.Ahzrius = KBM.Language:Add(MOD.Ahzrius.Name)
MOD.Lang.Unit.Ahzrius:SetGerman()
MOD.Lang.Unit.Ahzrius:SetFrench()
MOD.Ahzrius.Name = MOD.Lang.Unit.Ahzrius[KBM.Lang]
MOD.Descript = MOD.Ahzrius.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Ahzrius")
MOD.Lang.Unit.AndShort:SetGerman()
MOD.Lang.Unit.AndShort:SetFrench()
MOD.Ahzrius.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}
MOD.Lang.Ability.Drastic = KBM.Language:Add("Drastic Renovations")
MOD.Lang.Ability.Drastic:SetGerman("Drastische Sanierung")

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Ahzrius.Name] = self.Ahzrius,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Ahzrius.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Ahzrius.Settings.TimersRef,
		-- AlertsRef = self.Ahzrius.Settings.AlertsRef,
	}
	KBMSLNMAOFAHZ_Settings = self.Settings
	chKBMSLNMAOFAHZ_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLNMAOFAHZ_Settings = self.Settings
		self.Settings = chKBMSLNMAOFAHZ_Settings
	else
		chKBMSLNMAOFAHZ_Settings = self.Settings
		self.Settings = KBMSLNMAOFAHZ_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLNMAOFAHZ_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLNMAOFAHZ_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLNMAOFAHZ_Settings = self.Settings
	else
		KBMSLNMAOFAHZ_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLNMAOFAHZ_Settings = self.Settings
	else
		KBMSLNMAOFAHZ_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Ahzrius.UnitID == UnitID then
		self.Ahzrius.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Ahzrius.UnitID == UnitID then
		self.Ahzrius.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Ahzrius.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Ahzrius.Dead = false
					self.Ahzrius.Casting = false
					self.Ahzrius.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Ahzrius.Name, 0, 100)
					self.Phase = 1
				end
				self.Ahzrius.UnitID = unitID
				self.Ahzrius.Available = true
				return self.Ahzrius
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Ahzrius.Available = false
	self.Ahzrius.UnitID = nil
	self.Ahzrius.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Ahzrius)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Ahzrius)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Ahzrius.CastBar = KBM.Castbar:Add(self, self.Ahzrius)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
end