﻿-- Chillblains Winterfrost Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXROTFCW_Settings = nil
chKBMEXROTFCW_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["The Realm of the Fae"]

local MOD = {
	Directory = Instance.Directory,
	File = "Winterfrost.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Winterfrost",
	Object = "MOD",
}

MOD.Winterfrost = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Chillblains Winterfrost",
	NameShort = "Winterfrost",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	UTID = "U126EF8EC1AC7CB14",
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
MOD.Lang.Unit.Winterfrost = KBM.Language:Add(MOD.Winterfrost.Name)
MOD.Lang.Unit.Winterfrost:SetGerman("Chillblains Winterfrost")
MOD.Lang.Unit.Winterfrost:SetFrench("Perniose le Chaleureux")
MOD.Lang.Unit.Winterfrost:SetRussian("Знобящий Морозник")
MOD.Lang.Unit.Winterfrost:SetKorean("냉수포 겨울서리")
MOD.Winterfrost.Name = MOD.Lang.Unit.Winterfrost[KBM.Lang]
MOD.Descript = MOD.Winterfrost.Name
MOD.Lang.Unit.WinShort = KBM.Language:Add("Winterfrost")
MOD.Lang.Unit.WinShort:SetGerman()
MOD.Lang.Unit.WinShort:SetFrench("Chaleureux")
MOD.Lang.Unit.WinShort:SetRussian("Морозник")
MOD.Lang.Unit.WinShort:SetKorean("겨울서리")
MOD.Winterfrost.NameShort = MOD.Lang.Unit.WinShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Winterfrost.Name] = self.Winterfrost,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Winterfrost.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Winterfrost.Settings.TimersRef,
		-- AlertsRef = self.Winterfrost.Settings.AlertsRef,
	}
	KBMEXROTFCW_Settings = self.Settings
	chKBMEXROTFCW_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXROTFCW_Settings = self.Settings
		self.Settings = chKBMEXROTFCW_Settings
	else
		chKBMEXROTFCW_Settings = self.Settings
		self.Settings = KBMEXROTFCW_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXROTFCW_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXROTFCW_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXROTFCW_Settings = self.Settings
	else
		KBMEXROTFCW_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXROTFCW_Settings = self.Settings
	else
		KBMEXROTFCW_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Winterfrost.UnitID == UnitID then
		self.Winterfrost.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Winterfrost.UnitID == UnitID then
		self.Winterfrost.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Winterfrost.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Winterfrost.Dead = false
					self.Winterfrost.Casting = false
					self.Winterfrost.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Winterfrost.Name, 0, 100)
					self.Phase = 1
				end
				self.Winterfrost.UnitID = unitID
				self.Winterfrost.Available = true
				return self.Winterfrost
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Winterfrost.Available = false
	self.Winterfrost.UnitID = nil
	self.Winterfrost.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Winterfrost:SetTimers(bool)	
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

function MOD.Winterfrost:SetAlerts(bool)
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
	--KBM.Defaults.TimerObj.Assign(self.Winterfrost)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Winterfrost)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Winterfrost.CastBar = KBM.Castbar:Add(self, self.Winterfrost)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end