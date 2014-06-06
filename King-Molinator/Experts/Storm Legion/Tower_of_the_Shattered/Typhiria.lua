﻿-- Commissar Typhiria Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLEXTOSCVS_Settings = nil
chKBMSLEXTOSCVS_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["ETower_of_the_Shattered"]

local MOD = {
	Directory = Instance.Directory,
	File = "Typhiria.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Ex_Typhiria",
	Object = "MOD",
}

MOD.Typhiria = {
	Mod = MOD,
	Level = "60",
	Active = false,
	Name = "Commissar Typhiria",
	NameShort = "Typhiria",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFC5FE5910B50AE81",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Typhiria = KBM.Language:Add(MOD.Typhiria.Name)
MOD.Lang.Unit.Typhiria:SetGerman("Kommissarin Typhiria")
MOD.Lang.Unit.Typhiria:SetFrench("commissaire Typhiria")
MOD.Typhiria.Name = MOD.Lang.Unit.Typhiria[KBM.Lang]
MOD.Descript = MOD.Typhiria.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Typhiria")
MOD.Lang.Unit.AndShort:SetGerman()
MOD.Lang.Unit.AndShort:SetFrench()
MOD.Typhiria.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Typhiria.Name] = self.Typhiria,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Typhiria.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Typhiria.Settings.TimersRef,
		-- AlertsRef = self.Typhiria.Settings.AlertsRef,
	}
	KBMSLEXTOSCVS_Settings = self.Settings
	chKBMSLEXTOSCVS_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLEXTOSCVS_Settings = self.Settings
		self.Settings = chKBMSLEXTOSCVS_Settings
	else
		chKBMSLEXTOSCVS_Settings = self.Settings
		self.Settings = KBMSLEXTOSCVS_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLEXTOSCVS_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLEXTOSCVS_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLEXTOSCVS_Settings = self.Settings
	else
		KBMSLEXTOSCVS_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLEXTOSCVS_Settings = self.Settings
	else
		KBMSLEXTOSCVS_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Typhiria.UnitID == UnitID then
		self.Typhiria.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Typhiria.UnitID == UnitID then
		self.Typhiria.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		local BossObj = self.UTID[uDetails.type] 
		if BossObj then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				BossObj.Dead = false
				BossObj.Casting = false
				BossObj.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Typhiria, 0, 100)
				self.Phase = 1
			end
			BossObj.UnitID = unitID
			BossObj.Available = true
			return BossObj
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Typhiria.Available = false
	self.Typhiria.UnitID = nil
	self.Typhiria.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Typhiria)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Typhiria)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Typhiria.CastBar = KBM.Castbar:Add(self, self.Typhiria)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end