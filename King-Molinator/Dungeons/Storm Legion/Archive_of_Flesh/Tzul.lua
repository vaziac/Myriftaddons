﻿-- Tzul Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLNMAOFTZ_Settings = nil
chKBMSLNMAOFTZ_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Archive of Flesh"]

local MOD = {
	Directory = Instance.Directory,
	File = "Tzul.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Norm_Tzul",
	Object = "MOD",
}

MOD.Tzul = {
	Mod = MOD,
	Level = "59",
	Active = false,
	Name = "Tzul",
	NameShort = "Tzul",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFDEF1C3552D0B261",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Tzul = KBM.Language:Add(MOD.Tzul.Name)
MOD.Lang.Unit.Tzul:SetGerman()
MOD.Lang.Unit.Tzul:SetFrench()
MOD.Tzul.Name = MOD.Lang.Unit.Tzul[KBM.Lang]
MOD.Descript = MOD.Tzul.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Tzul")
MOD.Lang.Unit.AndShort:SetGerman()
MOD.Lang.Unit.AndShort:SetFrench()
MOD.Tzul.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Tzul.Name] = self.Tzul,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Tzul.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Tzul.Settings.TimersRef,
		-- AlertsRef = self.Tzul.Settings.AlertsRef,
	}
	KBMSLNMAOFTZ_Settings = self.Settings
	chKBMSLNMAOFTZ_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLNMAOFTZ_Settings = self.Settings
		self.Settings = chKBMSLNMAOFTZ_Settings
	else
		chKBMSLNMAOFTZ_Settings = self.Settings
		self.Settings = KBMSLNMAOFTZ_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLNMAOFTZ_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLNMAOFTZ_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLNMAOFTZ_Settings = self.Settings
	else
		KBMSLNMAOFTZ_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLNMAOFTZ_Settings = self.Settings
	else
		KBMSLNMAOFTZ_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Tzul.UnitID == UnitID then
		self.Tzul.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Tzul.UnitID == UnitID then
		self.Tzul.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Tzul.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Tzul.Dead = false
					self.Tzul.Casting = false
					self.Tzul.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Tzul.Name, 0, 100)
					self.Phase = 1
				end
				self.Tzul.UnitID = unitID
				self.Tzul.Available = true
				return self.Tzul
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Tzul.Available = false
	self.Tzul.UnitID = nil
	self.Tzul.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Tzul)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Tzul)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Tzul.CastBar = KBM.Castbar:Add(self, self.Tzul)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end