﻿-- Chekaroth Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLNMSQCH_Settings = nil
chKBMSLNMSQCH_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Exodus of the Storm Queen"]

local MOD = {
	Directory = Instance.Directory,
	File = "Chekaroth.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Norm_Chekaroth",
	Object = "MOD",
}

MOD.Chekaroth = {
	Mod = MOD,
	Level = "52",
	Active = false,
	Name = "Chekaroth",
	NameShort = "Chekaroth",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFBFF16EB12144CE0",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Chekaroth = KBM.Language:Add(MOD.Chekaroth.Name)
MOD.Lang.Unit.Chekaroth:SetGerman()
MOD.Lang.Unit.Chekaroth:SetFrench()
MOD.Chekaroth.Name = MOD.Lang.Unit.Chekaroth[KBM.Lang]
MOD.Descript = MOD.Chekaroth.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Chekaroth")
MOD.Lang.Unit.AndShort:SetGerman()
MOD.Lang.Unit.AndShort:SetFrench()
MOD.Chekaroth.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Chekaroth.Name] = self.Chekaroth,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Chekaroth.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Chekaroth.Settings.TimersRef,
		-- AlertsRef = self.Chekaroth.Settings.AlertsRef,
	}
	KBMSLNMSQCH_Settings = self.Settings
	chKBMSLNMSQCH_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLNMSQCH_Settings = self.Settings
		self.Settings = chKBMSLNMSQCH_Settings
	else
		chKBMSLNMSQCH_Settings = self.Settings
		self.Settings = KBMSLNMSQCH_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLNMSQCH_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLNMSQCH_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLNMSQCH_Settings = self.Settings
	else
		KBMSLNMSQCH_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLNMSQCH_Settings = self.Settings
	else
		KBMSLNMSQCH_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Chekaroth.UnitID == UnitID then
		self.Chekaroth.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Chekaroth.UnitID == UnitID then
		self.Chekaroth.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Chekaroth.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Chekaroth.Dead = false
					self.Chekaroth.Casting = false
					self.Chekaroth.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Chekaroth.Name, 0, 100)
					self.Phase = 1
				end
				self.Chekaroth.UnitID = unitID
				self.Chekaroth.Available = true
				return self.Chekaroth
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Chekaroth.Available = false
	self.Chekaroth.UnitID = nil
	self.Chekaroth.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Chekaroth)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Chekaroth)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Chekaroth.CastBar = KBM.Castbar:Add(self, self.Chekaroth)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end