﻿-- Psychophage Primakov Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLEXTOSPPR_Settings = nil
chKBMSLEXTOSPPR_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["ETower_of_the_Shattered"]

local MOD = {
	Directory = Instance.Directory,
	File = "Primakov.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Ex_Primakov",
	Object = "MOD",
	Enarge = 7 * 60,
}

MOD.Primakov = {
	Mod = MOD,
	Level = "60",
	Active = false,
	Name = "Psychophage Primakov",
	NameShort = "Primakov",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFBBF8C9827FBD2AE",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Primakov = KBM.Language:Add(MOD.Primakov.Name)
MOD.Lang.Unit.Primakov:SetGerman()
MOD.Lang.Unit.Primakov:SetFrench("Primakov le Psychophage")
MOD.Primakov.Name = MOD.Lang.Unit.Primakov[KBM.Lang]
MOD.Descript = MOD.Primakov.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Primakov")
MOD.Lang.Unit.AndShort:SetGerman()
MOD.Lang.Unit.AndShort:SetFrench()
MOD.Primakov.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Primakov.Name] = self.Primakov,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Primakov.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Primakov.Settings.TimersRef,
		-- AlertsRef = self.Primakov.Settings.AlertsRef,
	}
	KBMSLEXTOSPPR_Settings = self.Settings
	chKBMSLEXTOSPPR_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLEXTOSPPR_Settings = self.Settings
		self.Settings = chKBMSLEXTOSPPR_Settings
	else
		chKBMSLEXTOSPPR_Settings = self.Settings
		self.Settings = KBMSLEXTOSPPR_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLEXTOSPPR_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLEXTOSPPR_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLEXTOSPPR_Settings = self.Settings
	else
		KBMSLEXTOSPPR_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLEXTOSPPR_Settings = self.Settings
	else
		KBMSLEXTOSPPR_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Primakov.UnitID == UnitID then
		self.Primakov.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Primakov.UnitID == UnitID then
		self.Primakov.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Primakov.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Primakov.Dead = false
				self.Primakov.Casting = false
				self.Primakov.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Primakov.Name, 0, 100)
				self.Phase = 1
			end
			self.Primakov.UnitID = unitID
			self.Primakov.Available = true
			return self.Primakov
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Primakov.Available = false
	self.Primakov.UnitID = nil
	self.Primakov.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Primakov)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Primakov)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Primakov.CastBar = KBM.Castbar:Add(self, self.Primakov)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end