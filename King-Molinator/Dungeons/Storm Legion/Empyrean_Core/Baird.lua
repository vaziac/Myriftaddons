﻿-- Baird Bringhurst Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLNMECBAI_Settings = nil
chKBMSLNMECBAI_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Empyrean Core"]

local MOD = {
	Directory = Instance.Directory,
	File = "Baird.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Norm_Baird",
	Object = "MOD",
}

MOD.Baird = {
	Mod = MOD,
	Level = "60",
	Active = false,
	Name = "Baird Bringhurst",
	NameShort = "Baird",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFDBE24E335876970",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Baird = KBM.Language:Add(MOD.Baird.Name)
MOD.Lang.Unit.Baird:SetGerman("Baird Bringhurst")
MOD.Baird.Name = MOD.Lang.Unit.Baird[KBM.Lang]
MOD.Descript = MOD.Baird.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Baird")
MOD.Lang.Unit.AndShort:SetGerman()
MOD.Lang.Unit.AndShort:SetFrench()
MOD.Baird.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Baird.Name] = self.Baird,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Baird.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Baird.Settings.TimersRef,
		-- AlertsRef = self.Baird.Settings.AlertsRef,
	}
	KBMSLNMECBAI_Settings = self.Settings
	chKBMSLNMECBAI_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLNMECBAI_Settings = self.Settings
		self.Settings = chKBMSLNMECBAI_Settings
	else
		chKBMSLNMECBAI_Settings = self.Settings
		self.Settings = KBMSLNMECBAI_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLNMECBAI_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLNMECBAI_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLNMECBAI_Settings = self.Settings
	else
		KBMSLNMECBAI_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLNMECBAI_Settings = self.Settings
	else
		KBMSLNMECBAI_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Baird.UnitID == UnitID then
		self.Baird.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Baird.UnitID == UnitID then
		self.Baird.Dead = true
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
				if BossObj == self.Baird then
					self.Baird.CastBar:Create(unitID)
				end
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Baird.Name, 0, 100)
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
	self.Baird.Available = false
	self.Baird.UnitID = nil
	self.Baird.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Baird)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Baird)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Baird.CastBar = KBM.Castbar:Add(self, self.Baird)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end