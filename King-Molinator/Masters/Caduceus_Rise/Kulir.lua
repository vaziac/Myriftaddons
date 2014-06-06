﻿-- Headhunter Kulir Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMMMCRKV_Settings = nil
chKBMMMCRKV_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Caduceus Rise"]

local MOD = {
	Directory = Instance.Directory,
	File = "Kulir.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "MM_Kulir",
	Object = "MOD",
}

MOD.Kulir = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = "Headhunter Kulir",
	NameShort = "Kulir",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	UTID = "none",
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
MOD.Lang.Unit.Kulir = KBM.Language:Add(MOD.Kulir.Name)
MOD.Lang.Unit.Kulir:SetGerman("Kopfgeldjäger Kulir")
MOD.Lang.Unit.Kulir:SetFrench("Chasseur de tête Kulir")
MOD.Lang.Unit.Kulir:SetRussian("Охотник за головами Кулир")
MOD.Lang.Unit.Kulir:SetKorean("징병담당자 쿨리르")
MOD.Kulir.Name = MOD.Lang.Unit.Kulir[KBM.Lang]
MOD.Descript = MOD.Kulir.Name
MOD.Lang.Unit.KulirShort = KBM.Language:Add("Kulir")
MOD.Lang.Unit.KulirShort:SetGerman("Kulir")
MOD.Lang.Unit.KulirShort:SetFrench("Kulir")
MOD.Lang.Unit.KulirShort:SetRussian("Кулир")
MOD.Lang.Unit.KulirShort:SetKorean("쿨리르")
MOD.Kulir.NameShort = MOD.Lang.Unit.KulirShort[KBM.Lang]
MOD.Lang.Unit.Varash = KBM.Language:Add("Disciple Varash")
MOD.Lang.Unit.Varash:SetGerman("Jünger Varash")
MOD.Lang.Unit.Varash:SetFrench("Disciple Varash")
MOD.Lang.Unit.Varash:SetRussian("Ученик Вараш")
MOD.Lang.Unit.Varash:SetKorean("사도 바라시")
MOD.Lang.Unit.VarashShort = KBM.Language:Add("Varash")
MOD.Lang.Unit.VarashShort:SetGerman("Varash")
MOD.Lang.Unit.VarashShort:SetFrench("Varash")
MOD.Lang.Unit.VarashShort:SetRussian("Вараш")
MOD.Lang.Unit.VarashShort:SetKorean("바라시")
-- Ability Dictionary
MOD.Lang.Ability = {}

MOD.Varash = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = MOD.Lang.Unit.Varash[KBM.Lang],
	NameShort = MOD.Lang.Unit.VarashShort[KBM.Lang],
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "none",
	TimeOut = 5,
}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Kulir.Name] = self.Kulir,
		[self.Varash.Name] = self.Varash,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Kulir.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Kulir.Settings.TimersRef,
		-- AlertsRef = self.Kulir.Settings.AlertsRef,
	}
	KBMMMCRKV_Settings = self.Settings
	chKBMMMCRKV_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMMMCRKV_Settings = self.Settings
		self.Settings = chKBMMMCRKV_Settings
	else
		chKBMMMCRKV_Settings = self.Settings
		self.Settings = KBMMMCRKV_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMMMCRKV_Settings, self.Settings)
	else
		KBM.LoadTable(KBMMMCRKV_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMMMCRKV_Settings = self.Settings
	else
		KBMMMCRKV_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMMMCRKV_Settings = self.Settings
	else
		KBMMMCRKV_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Kulir.UnitID == UnitID then
		self.Kulir.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Kulir.UnitID == UnitID then
		self.Kulir.Dead = true
	elseif self.Varash.UnitID == UnitID then
		self.Varash.Dead = true
	end
	if self.Kulir.Dead and self.Varash.Dead then
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if self.Bosses[uDetails.name] then
				local BossObj = self.Bosses[uDetails.name]
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Kulir.Name then
						BossObj.CastBar:Create(unitID)
					end
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Single")
					self.PhaseObj.Objectives:AddPercent(self.Kulir.Name, 0, 100)
					self.PhaseObj.Objectives:AddPercent(self.Varash.Name, 0, 100)
					self.Phase = 1
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Kulir.Name then
						BossObj.CastBar:Create(unitID)
					end
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return self.Kulir
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
	end
	self.Kulir.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Kulir:SetTimers(bool)	
	if bool then
		for TimerID, TimerObj in pairs(self.TimersRef) do
			TimerObj.Enabled = TimerObj.Settings.Enabled
		end
	else
		for TimerID, TimerObj in pairs(self.TimersRef) do
			TimerObj.Enabled = false
		end
	end
end

function MOD.Kulir:SetAlerts(bool)
	if bool then
		for AlertID, AlertObj in pairs(self.AlertsRef) do
			AlertObj.Enabled = AlertObj.Settings.Enabled
		end
	else
		for AlertID, AlertObj in pairs(self.AlertsRef) do
			AlertObj.Enabled = false
		end
	end
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Kulir)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Kulir)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Kulir.CastBar = KBM.Castbar:Add(self, self.Kulir)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end