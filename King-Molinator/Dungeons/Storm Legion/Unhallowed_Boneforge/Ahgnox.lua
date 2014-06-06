﻿-- Ahgnox Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLNMUBFAHG_Settings = nil
chKBMSLNMUBFAHG_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Unhallowed Boneforge"]

local MOD = {
	Directory = Instance.Directory,
	File = "Ahgnox.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Norm_Ahgnox",
	Object = "MOD",
}

MOD.Ahgnox = {
	Mod = MOD,
	Level = "52",
	Active = false,
	Name = "Ahgnox the Corpsekeeper",
	NameShort = "Ahgnox",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U5D23B71F1A138FF6",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Ahgnox = KBM.Language:Add(MOD.Ahgnox.Name)
MOD.Lang.Unit.Ahgnox:SetGerman("Ahgnox der Leichenhüter")
MOD.Lang.Unit.Ahgnox:SetFrench("Ahgnox le Gardien des morts")
MOD.Ahgnox.Name = MOD.Lang.Unit.Ahgnox[KBM.Lang]
MOD.Descript = MOD.Ahgnox.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Ahgnox")
MOD.Lang.Unit.AndShort:SetGerman()
MOD.Lang.Unit.AndShort:SetFrench()
MOD.Ahgnox.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Ahgnox.Name] = self.Ahgnox,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Ahgnox.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Ahgnox.Settings.TimersRef,
		-- AlertsRef = self.Ahgnox.Settings.AlertsRef,
	}
	KBMSLNMUBFAHG_Settings = self.Settings
	chKBMSLNMUBFAHG_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLNMUBFAHG_Settings = self.Settings
		self.Settings = chKBMSLNMUBFAHG_Settings
	else
		chKBMSLNMUBFAHG_Settings = self.Settings
		self.Settings = KBMSLNMUBFAHG_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLNMUBFAHG_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLNMUBFAHG_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLNMUBFAHG_Settings = self.Settings
	else
		KBMSLNMUBFAHG_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLNMUBFAHG_Settings = self.Settings
	else
		KBMSLNMUBFAHG_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Ahgnox.UnitID == UnitID then
		self.Ahgnox.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Ahgnox.UnitID == UnitID then
		self.Ahgnox.Dead = true
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
				BossObj.UnitID = unitID
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Ahgnox, 0, 100)
				self.Phase = 1
			else
				BossObj.UnitID = unitID
				BossObj.Available = true
			end
			return BossObj
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Ahgnox.Available = false
	self.Ahgnox.UnitID = nil
	self.Ahgnox.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Ahgnox)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Ahgnox)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Ahgnox.CastBar = KBM.Castbar:Add(self, self.Ahgnox)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end