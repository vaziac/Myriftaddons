﻿-- Trickster Maelow Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXROTFTM_Settings = nil
chKBMEXROTFTM_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["The Realm of the Fae"]

local MOD = {
	Directory = Instance.Directory,
	File = "Maelow.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Maelow",
	Object = "MOD",
}

MOD.Maelow = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Trickster Maelow",
	NameShort = "Maelow",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	UTID = "U2093D5D83C2D0D66",
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

-- Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Maelow = KBM.Language:Add(MOD.Maelow.Name)
MOD.Lang.Unit.Maelow:SetGerman("Schwindler Maelow")
MOD.Lang.Unit.Maelow:SetFrench("Entourloupeur Maelow")
MOD.Lang.Unit.Maelow:SetRussian("Ловкач Майлоу")
MOD.Lang.Unit.Maelow:SetKorean("마술쟁이 마엘로")
MOD.Maelow.Name = MOD.Lang.Unit.Maelow[KBM.Lang]
MOD.Descript = MOD.Maelow.Name
MOD.Lang.Unit.MaelowShort = KBM.Language:Add(MOD.Maelow.NameShort)
MOD.Lang.Unit.MaelowShort:SetGerman()
MOD.Lang.Unit.MaelowShort:SetFrench()
MOD.Lang.Unit.MaelowShort:SetRussian("Майлоу")
MOD.Lang.Unit.MaelowShort:SetKorean("마엘로")
MOD.Maelow.NameShort = MOD.Lang.Unit.MaelowShort[KBM.Lang]
MOD.Lang.Unit.Brae = KBM.Language:Add("Lifeward Brae")
MOD.Lang.Unit.Brae:SetGerman("Lebenswache Brae")
MOD.Lang.Unit.Brae:SetFrench("Garde-vie Brae")
MOD.Lang.Unit.Brae:SetRussian("Хранительница жизни Браэ")
MOD.Lang.Unit.Brae:SetKorean("생명결계 브라에")
MOD.Lang.Unit.BraeShort = KBM.Language:Add("Brae")
MOD.Lang.Unit.BraeShort:SetGerman()
MOD.Lang.Unit.BraeShort:SetFrench()
MOD.Lang.Unit.BraeShort:SetRussian("Браэ")
MOD.Lang.Unit.BraeShort:SetKorean("브라에")
MOD.Lang.Unit.Celoah = KBM.Language:Add("Lifeward Celoah")
MOD.Lang.Unit.Celoah:SetGerman("Lebenswache Celoah")
MOD.Lang.Unit.Celoah:SetFrench("Garde-vie Celoah")
MOD.Lang.Unit.Celoah:SetRussian("Хранительница жизни Целоа")
MOD.Lang.Unit.Celoah:SetKorean("생명결계 셀로아")
MOD.Lang.Unit.CeloahShort = KBM.Language:Add("Celoah")
MOD.Lang.Unit.CeloahShort:SetGerman()
MOD.Lang.Unit.CeloahShort:SetFrench()
MOD.Lang.Unit.CeloahShort:SetRussian("Целоа")
MOD.Lang.Unit.CeloahShort:SetKorean("셀로아")

-- Ability Dictionary
MOD.Lang.Ability = {}

MOD.Brae = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = MOD.Lang.Unit.Brae[KBM.Lang],
	NameShort = MOD.Lang.Unit.BraeShort[KBM.Lang],
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U7682C75012E9382B",
	TimeOut = 5,
}

MOD.Celoah = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = MOD.Lang.Unit.Celoah[KBM.Lang],
	NameShort = MOD.Lang.Unit.CeloahShort[KBM.Lang],
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U7A5FB4E314BA32F1",
	TimeOut = 5,
}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Maelow.Name] = self.Maelow,
		[self.Brae.Name] = self.Brae,
		[self.Celoah.Name] = self.Celoah,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Maelow.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Maelow.Settings.TimersRef,
		-- AlertsRef = self.Maelow.Settings.AlertsRef,
	}
	KBMEXROTFTM_Settings = self.Settings
	chKBMEXROTFTM_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXROTFTM_Settings = self.Settings
		self.Settings = chKBMEXROTFTM_Settings
	else
		chKBMEXROTFTM_Settings = self.Settings
		self.Settings = KBMEXROTFTM_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXROTFTM_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXROTFTM_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXROTFTM_Settings = self.Settings
	else
		KBMEXROTFTM_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXROTFTM_Settings = self.Settings
	else
		KBMEXROTFTM_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Maelow.UnitID == UnitID then
		self.Maelow.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Maelow.UnitID == UnitID then
		self.Maelow.Dead = true
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
					if BossObj.Name == self.Maelow.Name then
						BossObj.CastBar:Create(unitID)
					end
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Maelow.Name, 0, 100)
					self.PhaseObj.Objectives:AddPercent(self.Brae.Name, 0, 100)
					self.PhaseObj.Objectives:AddPercent(self.Celoah.Name, 0, 100)
					self.Phase = 1
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Maelow.Name then
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
		BossObj.Dead = false
	end
	self.Maelow.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Maelow:SetTimers(bool)	
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

function MOD.Maelow:SetAlerts(bool)
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
	--KBM.Defaults.TimerObj.Assign(self.Maelow)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Maelow)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Maelow.CastBar = KBM.Castbar:Add(self, self.Maelow)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end