﻿-- Thalguur Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGPTR_Settings = nil
chKBMGPTR_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local GP = KBM.BossMod["Gilded Prophecy"]

local TR = {
	Directory = GP.Directory,
	File = "Thalguur.lua",
	Enabled = true,
	Instance = GP.Name,
	InstanceObj = GP,
	Lang = {},
	ID = "Thalguur",
	Object = "TR",
}

TR.Thalguur = {
	Mod = TR,
	Level = "??",
	Active = false,
	Name = "Thalguur",
	NameShort = "Thalguur",
	Menu = {},
	TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	Dead = false,
	UTID = "U361E2A4E40189448",
	Available = false,
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		TimersRef = {
			Enabled = true,
			Power = KBM.Defaults.TimerObj.Create("dark_green"),
		},
		AlertsRef = {
			Enabled = true,
			Touch = KBM.Defaults.AlertObj.Create("red"),
			Power = KBM.Defaults.AlertObj.Create("dark_green"),
			Gold = KBM.Defaults.AlertObj.Create("yellow"),
			Curse = KBM.Defaults.AlertObj.Create("purple"),
		},
		MechRef = {
			Enabled = true,
			Gold = KBM.Defaults.MechObj.Create("yellow"),
			Touch = KBM.Defaults.MechObj.Create("red"),
		},
	},
}

KBM.RegisterMod(TR.ID, TR)

-- Main Unit Dictionary
TR.Lang.Unit = {}
TR.Lang.Unit.Thalguur = KBM.Language:Add(TR.Thalguur.Name)
TR.Lang.Unit.Thalguur:SetGerman()
TR.Lang.Unit.Thalguur:SetFrench()
TR.Lang.Unit.Thalguur:SetRussian("Талгуур")
TR.Lang.Unit.Thalguur:SetKorean("살구르")
TR.Thalguur.Name = TR.Lang.Unit.Thalguur[KBM.Lang]

-- Ability Dictionary
TR.Lang.Ability = {}
TR.Lang.Ability.Touch = KBM.Language:Add("Touch of the Core")
TR.Lang.Ability.Touch:SetGerman("Berührung des Kerns")
TR.Lang.Ability.Touch:SetFrench("Contact du Noyau")
TR.Lang.Ability.Touch:SetRussian("Прикосновение ядра")
TR.Lang.Ability.Touch:SetKorean("코어의 손길")
TR.Lang.Ability.Power = KBM.Language:Add("Absorb Power")
TR.Lang.Ability.Power:SetGerman("Kraft absorbieren")
TR.Lang.Ability.Power:SetFrench("Absorption de Pouvoir ")
TR.Lang.Ability.Power:SetRussian("Поглощение силы")
TR.Lang.Ability.Power:SetKorean("기력 흡수")

-- Debuff Dictionary
TR.Lang.Debuff = {}
TR.Lang.Debuff.Gold = KBM.Language:Add("Call of Gold")
TR.Lang.Debuff.Gold:SetGerman("Ruf des Goldes")
TR.Lang.Debuff.Gold:SetFrench("Appel de l'or")
TR.Lang.Debuff.Gold:SetRussian("Зов золота")
TR.Lang.Debuff.Gold:SetKorean("황금의 부름")
TR.Lang.Debuff.Curse = KBM.Language:Add("Curse of Greed")
TR.Lang.Debuff.Curse:SetGerman("Fluch der Gier")
TR.Lang.Debuff.Curse:SetFrench("Malédiction d'avidité")
TR.Lang.Debuff.Curse:SetRussian("Проклятие жадности")
TR.Lang.Debuff.Curse:SetKorean("탐욕의 저주")

TR.Descript = TR.Thalguur.Name

function TR:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Thalguur.Name] = self.Thalguur,
	}
end

function TR:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Thalguur.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		MechTimer = KBM.Defaults.MechTimer(),
		MechSpy = KBM.Defaults.MechSpy(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		Alerts = KBM.Defaults.Alerts(),
		AlertsRef = self.Thalguur.Settings.AlertsRef,
		TimersRef = self.Thalguur.Settings.TimersRef,
		MechRef = self.Thalguur.Settings.MechRef,
	}
	KBMGPTR_Settings = self.Settings
	chKBMGPTR_Settings = self.Settings
end

function TR:SwapSettings(bool)

	if bool then
		KBMGPTR_Settings = self.Settings
		self.Settings = chKBMGPTR_Settings
	else
		chKBMGPTR_Settings = self.Settings
		self.Settings = KBMGPTR_Settings
	end

end

function TR:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMGPTR_Settings, self.Settings)
	else
		KBM.LoadTable(KBMGPTR_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMGPTR_Settings = self.Settings
	else
		KBMGPTR_Settings = self.Settings
	end	
end

function TR:SaveVars()	
	if KBM.Options.Character then
		chKBMGPTR_Settings = self.Settings
	else
		KBMGPTR_Settings = self.Settings
	end	
end

function TR:Castbar(units)
end

function TR:RemoveUnits(UnitID)
	if self.Thalguur.UnitID == UnitID then
		self.Thalguur.Available = false
		return true
	end
	return false
end

function TR:Death(UnitID)
	if self.Thalguur.UnitID == UnitID then
		self.Thalguur.Dead = true
		return true
	end
	return false
end

function TR.PhaseTwo()
	TR.Phase = 2
	TR.PhaseObj.Objectives:Remove()
	TR.PhaseObj.Objectives:AddPercent(TR.Thalguur.Name, 70, 90)
	TR.PhaseObj:SetPhase(2)
end

function TR.PhaseThree()
	TR.Phase = 3
	TR.PhaseObj.Objectives:Remove()
	TR.PhaseObj.Objectives:AddPercent(TR.Thalguur.Name, 50, 70)
	TR.PhaseObj:SetPhase(3)
end

function TR.PhaseFour()
	TR.Phase = 4
	TR.PhaseObj.Objectives:Remove()
	TR.PhaseObj.Objectives:AddPercent(TR.Thalguur.Name, 30, 50)
	TR.PhaseObj:SetPhase(4)
end

function TR.PhaseFive()
	TR.Phase = 5
	TR.PhaseObj.Objectives:Remove()
	TR.PhaseObj.Objectives:AddPercent(TR.Thalguur.Name, 10, 30)
	TR.PhaseObj:SetPhase(5)
end

function TR.PhaseSix()
	TR.Phase = 6
	TR.PhaseObj.Objectives:Remove()
	TR.PhaseObj.Objectives:AddPercent(TR.Thalguur.Name, 0, 10)
	TR.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
end

function TR:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Thalguur.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Thalguur.Dead = false
					self.Thalguur.Casting = false
					self.Thalguur.CastBar:Create(unitID)
					self.Phase = 1
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj.Objectives:AddPercent(self.Thalguur.Name, 90, 100)
					self.PhaseObj:SetPhase(1)
				end
				self.Thalguur.UnitID = unitID
				self.Thalguur.Available = true
				return self.Thalguur
			end
		end
	end
end

function TR:Reset()
	self.EncounterRunning = false
	self.Thalguur.Available = false
	self.Thalguur.UnitID = nil
	self.Thalguur.Dead = false
	self.Thalguur.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function TR:Timer()
	
end

function TR:DefineMenu()
	self.Menu = GP.Menu:CreateEncounter(self.Thalguur, self.Enabled)
end

function TR:Start()
	-- Create Timers
	self.Thalguur.TimersRef.Power = KBM.MechTimer:Add(self.Lang.Ability.Power[KBM.Lang], nil)
	KBM.Defaults.TimerObj.Assign(self.Thalguur)
	
	-- Create Alerts
	self.Thalguur.AlertsRef.Touch = KBM.Alert:Create(self.Lang.Ability.Touch[KBM.Lang], nil, true, true, "red")
	self.Thalguur.AlertsRef.Power = KBM.Alert:Create(self.Lang.Ability.Power[KBM.Lang], 3, true, true, "dark_green")
	self.Thalguur.AlertsRef.Gold = KBM.Alert:Create(self.Lang.Debuff.Gold[KBM.Lang], nil, false, false, "yellow")
	self.Thalguur.AlertsRef.Curse = KBM.Alert:Create(self.Lang.Debuff.Curse[KBM.Lang], nil, false, true, "purple")
	KBM.Defaults.AlertObj.Assign(self.Thalguur)
	
	-- Create Mechanic Spies
	self.Thalguur.MechRef.Gold = KBM.MechSpy:Add(self.Lang.Debuff.Gold[KBM.Lang], nil, "playerDebuff", self.Thalguur)
	self.Thalguur.MechRef.Touch = KBM.MechSpy:Add(self.Lang.Ability.Touch[KBM.Lang], nil, "channel", self.Thalguur)
	KBM.Defaults.MechObj.Assign(self.Thalguur)
	
	-- Assign Timers and Alerts to Triggers
	self.Thalguur.Triggers.Touch = KBM.Trigger:Create(self.Lang.Ability.Touch[KBM.Lang], "channel", self.Thalguur)
	self.Thalguur.Triggers.Touch:AddAlert(self.Thalguur.AlertsRef.Touch)
	self.Thalguur.Triggers.Touch:AddSpy(self.Thalguur.MechRef.Touch)
	self.Thalguur.Triggers.Power = KBM.Trigger:Create(self.Lang.Ability.Power[KBM.Lang], "channel", self.Thalguur)
	self.Thalguur.Triggers.Power:AddAlert(self.Thalguur.AlertsRef.Power)
	self.Thalguur.Triggers.Power:AddTimer(self.Thalguur.TimersRef.Power)
	self.Thalguur.Triggers.Gold = KBM.Trigger:Create("B6EFA4619511ADE8D", "playerIDBuff", self.Thalguur)
	self.Thalguur.Triggers.Gold:AddAlert(self.Thalguur.AlertsRef.Gold, true)
	self.Thalguur.Triggers.Gold:AddSpy(self.Thalguur.MechRef.Gold)
	self.Thalguur.Triggers.GoldRemove = KBM.Trigger:Create("B6EFA4619511ADE8D", "playerIDBuffRemove", self.Thalguur)
	self.Thalguur.Triggers.GoldRemove:AddStop(self.Thalguur.AlertsRef.Gold)
	self.Thalguur.Triggers.GoldRemove:AddStop(self.Thalguur.MechRef.Gold)
	self.Thalguur.Triggers.Curse = KBM.Trigger:Create(self.Lang.Debuff.Curse[KBM.Lang], "playerBuff", self.Thalguur)
	self.Thalguur.Triggers.Curse:AddAlert(self.Thalguur.AlertsRef.Curse, true)
	self.Thalguur.Triggers.PhaseTwo = KBM.Trigger:Create(90, "percent", self.Thalguur)
	self.Thalguur.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Thalguur.Triggers.PhaseThree = KBM.Trigger:Create(70, "percent", self.Thalguur)
	self.Thalguur.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	self.Thalguur.Triggers.PhaseFour = KBM.Trigger:Create(50, "percent", self.Thalguur)
	self.Thalguur.Triggers.PhaseFour:AddPhase(self.PhaseFour)
	self.Thalguur.Triggers.PhaseFive = KBM.Trigger:Create(30, "percent", self.Thalguur)
	self.Thalguur.Triggers.PhaseFive:AddPhase(self.PhaseFive)
	self.Thalguur.Triggers.PhaseSix = KBM.Trigger:Create(10, "percent", self.Thalguur)
	self.Thalguur.Triggers.PhaseSix:AddPhase(self.PhaseSix)
	
	self.Thalguur.CastBar = KBM.Castbar:Add(self, self.Thalguur)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end