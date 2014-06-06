﻿-- Subversionary Liaz Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLEXGFSL_Settings = nil
chKBMSLEXGFSL_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["EGolem_Foundry"]

local MOD = {
	Directory = Instance.Directory,
	File = "Liaz.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Ex_Liaz",
	Object = "MOD",
}

MOD.Liaz = {
	Mod = MOD,
	Level = "57",
	Active = false,
	Name = "Subversionary Liaz",
	NameShort = "Liaz",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFEE71A8360BBFCD8",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Liaz = KBM.Language:Add(MOD.Liaz.Name)
MOD.Lang.Unit.Liaz:SetGerman("Liaz der Umstürzler")
MOD.Lang.Unit.Liaz:SetFrench("Liaz le Subversif")
MOD.Liaz.Name = MOD.Lang.Unit.Liaz[KBM.Lang]
MOD.Descript = MOD.Liaz.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Liaz")
MOD.Lang.Unit.AndShort:SetGerman()
MOD.Lang.Unit.AndShort:SetFrench()
MOD.Liaz.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Liaz.Name] = self.Liaz,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Liaz.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Liaz.Settings.TimersRef,
		-- AlertsRef = self.Liaz.Settings.AlertsRef,
	}
	KBMSLEXGFSL_Settings = self.Settings
	chKBMSLEXGFSL_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLEXGFSL_Settings = self.Settings
		self.Settings = chKBMSLEXGFSL_Settings
	else
		chKBMSLEXGFSL_Settings = self.Settings
		self.Settings = KBMSLEXGFSL_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLEXGFSL_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLEXGFSL_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLEXGFSL_Settings = self.Settings
	else
		KBMSLEXGFSL_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLEXGFSL_Settings = self.Settings
	else
		KBMSLEXGFSL_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Liaz.UnitID == UnitID then
		self.Liaz.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Liaz.UnitID == UnitID then
		self.Liaz.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Liaz.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Liaz.Dead = false
				self.Liaz.Casting = false
				self.Liaz.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Liaz.Name, 0, 100)
				self.Phase = 1
			end
			self.Liaz.UnitID = unitID
			self.Liaz.Available = true
			return self.Liaz
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Liaz.Available = false
	self.Liaz.UnitID = nil
	self.Liaz.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Liaz)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Liaz)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Liaz.CastBar = KBM.Castbar:Add(self, self.Liaz)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end