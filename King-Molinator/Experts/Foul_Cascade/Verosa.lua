﻿-- Matron Verosa Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXFOLHRF_Settings = nil
chKBMEXFOLHRF_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Foul Cascade"]

local MOD = {
	Directory = Instance.Directory,
	File = "Verosa.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Verosa",
	Object = "MOD",
}

MOD.Verosa = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Matron Verosa",
	NameShort = "Verosa",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U22D5027D3A7FDA7C",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Verosa = KBM.Language:Add(MOD.Verosa.Name)
MOD.Lang.Unit.Verosa:SetGerman("Matrone Verosa")
MOD.Lang.Unit.Verosa:SetFrench("Matrone Verosa")
MOD.Verosa.Name = MOD.Lang.Unit.Verosa[KBM.Lang]
MOD.Descript = MOD.Verosa.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

-- Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Lesch = KBM.Language:Add("Lesch")
MOD.Lang.Unit.Lesch:SetGerman("Lesch")
MOD.Lang.Unit.Lesch:SetFrench("Lesch")
MOD.Lang.Unit.Lesch:SetRussian("Леш")
MOD.Lang.Unit.Lesch:SetKorean("레쉬")
MOD.Lang.Unit.Gurze = KBM.Language:Add("Gurze")
MOD.Lang.Unit.Gurze:SetGerman("Gurze")
MOD.Lang.Unit.Gurze:SetFrench("Gurze")
MOD.Lang.Unit.Gurze:SetRussian("Гурз")
MOD.Lang.Unit.Gurze:SetKorean("구르제")

MOD.Lesch = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = MOD.Lang.Unit.Lesch[KBM.Lang],
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U49AC50157CCFB190",
	TimeOut = 5,
}

MOD.Gurze = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = MOD.Lang.Unit.Gurze[KBM.Lang],
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U0F8EA515041F4557",
	TimeOut = 5,
}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Verosa.Name] = self.Verosa,
		[self.Lesch.Name] = self.Lesch,
		[self.Gurze.Name] = self.Gurze,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Verosa.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Verosa.Settings.TimersRef,
		-- AlertsRef = self.Verosa.Settings.AlertsRef,
	}
	KBMEXFOLHRF_Settings = self.Settings
	chKBMEXFOLHRF_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXFOLHRF_Settings = self.Settings
		self.Settings = chKBMEXFOLHRF_Settings
	else
		chKBMEXFOLHRF_Settings = self.Settings
		self.Settings = KBMEXFOLHRF_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXFOLHRF_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXFOLHRF_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXFOLHRF_Settings = self.Settings
	else
		KBMEXFOLHRF_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXFOLHRF_Settings = self.Settings
	else
		KBMEXFOLHRF_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Verosa.UnitID == UnitID then
		self.Verosa.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Verosa.UnitID == UnitID then
		self.Verosa.Dead = true
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
					if BossObj.Name == self.Verosa.Name then
						BossObj.CastBar:Create(unitID)
					end
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Verosa.Name, 0, 100)
					self.PhaseObj.Objectives:AddPercent(self.Lesch.Name, 0, 100)
					self.PhaseObj.Objectives:AddPercent(self.Gurze.Name, 0, 100)
					self.Phase = 1
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Verosa.Name then
						BossObj.CastBar:Create(unitID)
					end
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return BossObj
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
	end
	self.Verosa.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Verosa)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Verosa)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Verosa.CastBar = KBM.Castbar:Add(self, self.Verosa)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end