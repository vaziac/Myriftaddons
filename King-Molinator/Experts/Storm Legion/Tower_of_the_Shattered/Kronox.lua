﻿-- Kronox Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLEXTOSKRX_Settings = nil
chKBMSLEXTOSKRX_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["ETower_of_the_Shattered"]

local MOD = {
	Directory = Instance.Directory,
	File = "Kronox.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Ex_Kronox",
	Object = "MOD",
}

MOD.Kronox = {
	Mod = MOD,
	Level = "60",
	Active = false,
	Name = "Kronox",
	NameShort = "Kronox",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFD3B83BA51A8B891",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Kronox = KBM.Language:Add(MOD.Kronox.Name)
MOD.Lang.Unit.Kronox:SetGerman()
MOD.Lang.Unit.Kronox:SetFrench()
MOD.Kronox.Name = MOD.Lang.Unit.Kronox[KBM.Lang]
MOD.Descript = MOD.Kronox.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Kronox")
MOD.Lang.Unit.AndShort:SetGerman()
MOD.Lang.Unit.AndShort:SetFrench()
MOD.Kronox.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Kronox.Name] = self.Kronox,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Kronox.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Kronox.Settings.TimersRef,
		-- AlertsRef = self.Kronox.Settings.AlertsRef,
	}
	KBMSLEXTOSKRX_Settings = self.Settings
	chKBMSLEXTOSKRX_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLEXTOSKRX_Settings = self.Settings
		self.Settings = chKBMSLEXTOSKRX_Settings
	else
		chKBMSLEXTOSKRX_Settings = self.Settings
		self.Settings = KBMSLEXTOSKRX_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLEXTOSKRX_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLEXTOSKRX_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLEXTOSKRX_Settings = self.Settings
	else
		KBMSLEXTOSKRX_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLEXTOSKRX_Settings = self.Settings
	else
		KBMSLEXTOSKRX_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Kronox.UnitID == UnitID then
		self.Kronox.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Kronox.UnitID == UnitID then
		self.Kronox.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Kronox.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Kronox.Dead = false
				self.Kronox.Casting = false
				self.Kronox.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Kronox.Name, 0, 100)
				self.Phase = 1
			end
			self.Kronox.UnitID = unitID
			self.Kronox.Available = true
			return self.Kronox
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Kronox.Available = false
	self.Kronox.UnitID = nil
	self.Kronox.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Kronox)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Kronox)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Kronox.CastBar = KBM.Castbar:Add(self, self.Kronox)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end