﻿-- Kaliban's Bodyguards Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLNMECKBB_Settings = nil
chKBMSLNMECKBB_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Empyrean Core"]

local MOD = {
	Directory = Instance.Directory,
	File = "Bodyguards.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Norm_Bodyguards",
	Object = "MOD",
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Strauz = KBM.Language:Add("Strauz")
MOD.Lang.Unit.Strauz:SetGerman()
MOD.Lang.Unit.Strauz:SetFrench()
MOD.Lang.Unit.StrShort = KBM.Language:Add("Strauz")
MOD.Lang.Unit.StrShort:SetGerman()
MOD.Lang.Unit.StrShort:SetFrench()
MOD.Lang.Unit.Mercutial = KBM.Language:Add("Mercutial")
MOD.Lang.Unit.Mercutial:SetGerman()
MOD.Lang.Unit.Mercutial:SetFrench()
MOD.Lang.Unit.MerShort = KBM.Language:Add("Mercutial")
MOD.Lang.Unit.MerShort:SetGerman()
MOD.Lang.Unit.MerShort:SetFrench()

MOD.Strauz = {
	Mod = MOD,
	Level = "60",
	Active = false,
	Name = MOD.Lang.Unit.Strauz[KBM.Lang],
	NameShort = MOD.Lang.Unit.StrShort[KBM.Lang],
	Dictionary = MOD.Lang.Unit.Strauz,
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFC71504711EB92F4",
	TimeOut = 5,
	AlertsRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
			Enabled = true,
			Vortex = KBM.Defaults.AlertObj.Create("yellow")
		},
	}
}

MOD.Mercutial = {
	Mod = MOD,
	Level = "60",
	Active = false,
	Name = MOD.Lang.Unit.Mercutial[KBM.Lang],
	NameShort = MOD.Lang.Unit.MerShort[KBM.Lang],
	Dictionary = MOD.Lang.Unit.Mercutial,
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFF2C9E610588090E",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

-- Ability Dictionary
MOD.Lang.Ability = {}
MOD.Lang.Ability.Vortex = KBM.Language:Add("Siphoning Vortex")

-- Description
MOD.Lang.Main = {}
MOD.Lang.Main.Descript = KBM.Language:Add("Kaliban's Bodyguards")
MOD.Lang.Main.Descript:SetGerman("Kalibans Leibwachen")
MOD.Lang.Main.Descript:SetFrench("Gardes du corps de Kaliban")

MOD.Descript = MOD.Lang.Main.Descript[KBM.Lang]

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Strauz.Name] = self.Strauz,
		[self.Mercutial.Name] = self.Mercutial,
	}
	
	for BossName, BossObj in pairs(self.Bosses) do
		if BossObj.Settings then
			if BossObj.Settings.CastBar then
				BossObj.Settings.CastBar.Override = true
				BossObj.Settings.CastBar.Multi = true
			end
		end
	end
	
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = {
			Multi = true,
			Override = true,
		},
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		Alerts = KBM.Defaults.Alerts(),
		Strauz = {
			CastBar = self.Strauz.Settings.CastBar,
			AlertsRef = self.Strauz.Settings.AlertsRef,
		},
		Mercutial = {
			CastBar = self.Mercutial.Settings.CastBar,
		},
	}
	KBMSLNMECKBB_Settings = self.Settings
	chKBMSLNMECKBB_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLNMECKBB_Settings = self.Settings
		self.Settings = chKBMSLNMECKBB_Settings
	else
		chKBMSLNMECKBB_Settings = self.Settings
		self.Settings = KBMSLNMECKBB_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLNMECKBB_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLNMECKBB_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLNMECKBB_Settings = self.Settings
	else
		KBMSLNMECKBB_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLNMECKBB_Settings = self.Settings
	else
		KBMSLNMECKBB_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Strauz.UnitID == UnitID then
		self.Strauz.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Strauz.UnitID == UnitID then
		self.Strauz.Dead = true
	elseif self.Mercutial.UnitID == UnitID then
		self.Mercutial.Dead = true
	end
	if self.Strauz.Dead == true and self.Mercutial.Dead == true then
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
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Strauz, 0, 100)
				self.PhaseObj.Objectives:AddPercent(self.Mercutial, 0, 100)
				self.Phase = 1
			end
			if not BossObj.CastBar.Active then
				BossObj.CastBar:Create(unitID)
			end
			BossObj.UnitID = unitID
			BossObj.Available = true
			return BossObj
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	for Name, BossObj in pairs(self.Bosses) do
		BossObj.Dead = false
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.CastBar:Remove()
	end
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Strauz)
	
	-- Create Alerts
	self.Strauz.AlertsRef.Vortex = KBM.Alert:Create(self.Lang.Ability.Vortex[KBM.Lang], nil, false, true, "yellow")
	KBM.Defaults.AlertObj.Assign(self.Strauz)
	
	-- Assign Alerts and Timers to Triggers
	self.Strauz.Triggers.VortexCast = KBM.Trigger:Create(self.Lang.Ability.Vortex[KBM.Lang], "cast", self.Strauz)
	self.Strauz.Triggers.VortexCast:AddAlert(self.Strauz.AlertsRef.Vortex)
	self.Strauz.Triggers.VortexChannel = KBM.Trigger:Create(self.Lang.Ability.Vortex[KBM.Lang], "channel", self.Strauz)
	self.Strauz.Triggers.VortexChannel:AddAlert(self.Strauz.AlertsRef.Vortex)
	self.Strauz.Triggers.VortexInt = KBM.Trigger:Create(self.Lang.Ability.Vortex[KBM.Lang], "interrupt", self.Strauz)
	self.Strauz.Triggers.VortexInt:AddStop(self.Strauz.AlertsRef.Vortex)
	
	self.Strauz.CastBar = KBM.Castbar:Add(self, self.Strauz)
	self.Mercutial.CastBar = KBM.Castbar:Add(self, self.Mercutial)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end